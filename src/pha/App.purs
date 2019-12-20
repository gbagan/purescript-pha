module Pha.App (app, sandbox, appWithRouter, attachTo, Document, App, Interpreter, Url(..), UrlRequest(..)) where
import Prelude
import Effect (Effect)
import Data.Maybe (Maybe(..))
import Web.HTML (window)
import Web.HTML.Window (document, location)
import Web.HTML.Window as W
import Web.HTML.Location as L
import Web.Event.Event (EventType(..))
import Web.Event.EventTarget (eventListener, addEventListener)
import Web.HTML.HTMLDocument (setTitle)
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

getDispatchers ∷ ∀msg state effs. Effect state → Setter state → (msg → Update state effs) → Interpreter effs →
    {   runAction ∷ Update state effs → Effect Unit
    ,   dispatch ∷ msg → Effect Unit
    ,   dispatchEvent ∷ Event → (EventHandler msg) → Effect Unit
    }

getDispatchers getS setS update interpreter = {runAction, dispatch, dispatchEvent} where
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
app {init: Tuple istate init, view, update, subscriptions, interpreter} {getS, setS, renderVDom} = 
    {render, init: init2, subscriptions, dispatch, dispatchEvent} where
    {runAction, dispatch, dispatchEvent} = getDispatchers getS setS update interpreter
    init2 = setS istate *> runAction init
    render state = do
        let {body, title} = view state
        window >>= document >>= setTitle title
        renderVDom body

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

sandbox {init, view, update} {getS, setS, renderVDom} = 
    {render, init: setS init, subscriptions: const [], dispatch, dispatchEvent} where
    update2 msg = setState (update msg)
    {dispatch, dispatchEvent} = getDispatchers getS setS update2 (const (pure unit))
    render = renderVDom <<< view

newtype Url = Url
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

foreign import makeUrlAux :: (∀a. Maybe a) -> (∀a. a -> Maybe a) -> String -> String -> Maybe Url
makeUrl :: String -> String -> Maybe Url
makeUrl = makeUrlAux Nothing Just

getLocationUrl ∷ Effect Url
getLocationUrl = do
    loc <- window >>= location
    hash <- L.hash loc
    host <- L.host loc
    hostname <- L.hostname loc
    href <- L.href loc
    origin <- L.origin loc
    pathname <- L.pathname loc
    port <- L.port loc
    protocol <- L.protocol loc
    search <- L.search loc
    pure $ Url {hash, host, hostname, href, origin, pathname, port, protocol, search}

foreign import dispatchPopState ∷ Effect Unit

data UrlRequest = Internal Url | External String

urlRequest ∷ Url → Url → UrlRequest
urlRequest (Url base) (Url url) =
    if base.protocol == url.protocol &&
        base.host == url.host &&
        base.port == url.port then
        Internal (Url url)
    else
        External url.href

type AppWithRouter msg state effs = 
    {   init ∷ Url → Tuple state (Update state effs)
    ,   view ∷ state → Document msg
    ,   update ∷ msg → Update state effs
    ,   subscriptions ∷ state → Array (Sub msg)
    ,   onUrlRequest ∷ UrlRequest -> msg
    ,   onUrlChange ∷ Url -> msg
    ,   interpreter ∷ VariantF effs (Effect Unit) → Effect Unit
    }

foreign import handleClickOnAnchor ∷ (String → Effect Unit)  → Event → Effect Unit

appWithRouter ∷ ∀msg state effs. AppWithRouter msg state effs → Internal.AppBuilder msg state
appWithRouter {init, view, update, subscriptions, onUrlRequest, onUrlChange, interpreter} {getS, setS, renderVDom} =
    {render, init: init2, subscriptions, dispatch, dispatchEvent} where
    {runAction, dispatch, dispatchEvent} = getDispatchers getS setS update interpreter
    render state = do
        let {body, title} = view state
        window >>= document >>= setTitle title
        renderVDom body

    hrefHandler (Url baseUrl) href  =
        case makeUrl href baseUrl.href of
            Nothing -> pure unit
            Just url ->
                dispatch $ onUrlRequest $ urlRequest url (Url baseUrl)

    popStateHandler url ev = do
        url2 <- getLocationUrl
        dispatch (onUrlChange url2)

    init2 = do
        url <- getLocationUrl
        let Tuple state init3 = init url
        listener <- eventListener (popStateHandler url)
        window <#> W.toEventTarget >>= addEventListener (EventType "popstate") listener false
        clickListener <- eventListener (handleClickOnAnchor (hrefHandler url))
        window <#> W.toEventTarget >>= addEventListener (EventType "click") clickListener false
        setS state
        runAction init3
