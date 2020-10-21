module Pha.App (app, sandbox, attachTo, Document, App) where
import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Web.HTML (window)
import Web.HTML.Window (document)
import Web.HTML.HTMLDocument (setTitle)
import Pha (VDom, Sub)
import Pha.App.Internal as Internal

type Document msg = {
    title ∷ String,
    body ∷ VDom msg
}

type App msg state = 
    {   init ∷ {state :: state, action :: Maybe msg}
    ,   view ∷ state → Document msg
    ,   update ∷ {get ∷ Effect state, modify ∷ (state → state) → Effect Unit} → msg → Effect Unit
    ,   subscriptions ∷ state → Array (Sub msg)
    }

app ∷ ∀msg state. App msg state → Internal.AppBuilder msg state
app {init, view, update, subscriptions} {getS, setS, renderVDom} = 
    {render, init: init2, subscriptions, dispatch, dispatchEvent} where
    {dispatch, dispatchEvent} = Internal.getDispatchers getS setS update
    init2 = do
        setS init.state
        case init.action of
            Just msg → dispatch msg
            Nothing → pure unit
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

sandbox {init, view, update} = app {
        init: {state: init, action: Nothing}
    ,   view: \st -> {title: "Pha App", body: view st}
    ,   update: \{modify} msg -> modify (update msg)
    ,   subscriptions: const []
    }
