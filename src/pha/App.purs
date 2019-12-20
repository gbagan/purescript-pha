module Pha.App (app, sandbox, attachTo, Document, App, Interpreter) where
import Prelude
import Effect (Effect)
import Data.Maybe (Maybe(..))
import Pha (VDom, Event, Sub, EventHandler)
import Run (onMatch, VariantF)
import Run as Run
import Data.Tuple (Tuple(..))
import Pha.Internal as Internal
import Pha.Update (Update, setState,  GetState(..), SetState(..))

type Document msg = {
    title ∷ String,
    body ∷ VDom msg
}


type Interpreter effs = VariantF effs (Effect Unit) → Effect Unit
type Setter state = state → Effect Unit

type App msg state effs = 
    {   init ∷ Tuple state (Update state effs)
    ,   view ∷ state → Document msg
    ,   update ∷ msg → Update state effs
    ,   subscriptions ∷ state → Array (Sub msg)
    ,   interpreter ∷ Interpreter effs
    }

getTools ∷ ∀msg state effs. Effect state → Setter state → (msg → Update state effs) → Interpreter effs →
    {   runAction ∷ Update state effs → Effect Unit
    ,   dispatch ∷ msg → Effect Unit
    ,   dispatchEvent ∷ Event → (EventHandler msg) → Effect Unit
    }

getTools getS setS update interpreter = {runAction, dispatch, dispatchEvent} where
    runAction = Run.runCont handleState (const (pure unit)) where
        handleState = onMatch {
            getState: \(GetState next) → getS >>= next
        ,   setState: \(SetState f next) → (getS <#> f >>= setS) *> next
        } interpreter
    dispatch = runAction <<< update
    dispatchEvent ev handler = do
            let {effect, msg} = handler ev
            effect
            case msg of
                Nothing → pure unit
                Just m → dispatch m


app ∷ ∀msg state effs. App msg state effs → Internal.AppBuilder msg state
app {init: Tuple state init, view, update, subscriptions, interpreter} getS setS = 
    {view, init: init2, subscriptions, dispatch, dispatchEvent} where
    {runAction, dispatch, dispatchEvent} = getTools getS setS update interpreter
    init2 = setS state *> runAction init 

attachTo ∷ ∀msg state. String → Internal.AppBuilder msg state → Effect Unit
attachTo = flip Internal.app
    
-- | ```purescript
-- | sandbox ∷ ∀msg state effs. {
-- |     init ∷ state,
-- |     view ∷ state → VDom msg,
-- |     update ∷ msg → state → state
-- | } → Effect Unit
-- | ```

sandbox ∷ ∀msg state. {
    init ∷ state,
    view ∷ state → VDom msg,
    update ∷ msg → state → state
} → Internal.AppBuilder msg state

sandbox {init, view, update} =
    app
        {   init: Tuple init (pure unit)
        ,   view: \st → {title: "app", body: view st}
        ,   update: \msg → setState (update msg)
        ,   subscriptions: const []
        ,   interpreter: const (pure unit)
        }

type Url = 
    {   hash ∷ String
    ,   host ∷ String
    ,   hostname ∷ String
    ,   href ∷ String 
    ,   origin ∷ String
    ,   pathname ∷ String
    ,   port ∷ String
    ,   protocol ∷ String
    ,   search ∷ String
    }

foreign import getLocation ∷ Effect Url
foreign import dispatchPopState ∷ Effect Unit

data UrlRequest = Internal Url | External String

type AppWithRouter msg state effs = 
    {   init ∷ Url → Tuple state (Update state effs)
    ,   view ∷ state → Document msg
    ,   update ∷ msg → Update state effs
    ,   subscriptions ∷ state → Array (Sub msg)
    ,   onUrlRequest ∷ UrlRequest -> msg
    ,   onUrlChange ∷ Url -> msg
    ,   interpreter ∷ VariantF effs (Effect Unit) → Effect Unit
    }

appWithRouter ∷ ∀msg state effs. AppWithRouter msg state effs → Internal.AppBuilder msg state
appWithRouter {init, view, update, subscriptions, onUrlRequest, onUrlChange, interpreter} getS setS =
    {view, init: init2, subscriptions, dispatch, dispatchEvent} where
    {runAction, dispatch, dispatchEvent} = getTools getS setS update interpreter
    init2 = do
        url <- getLocation
        let Tuple state init3 = init url
        setS state
        runAction init3
