module Pha.App (app, sandbox, attachTo, Document, App) where
import Prelude
import Effect (Effect)
import Web.HTML (window)
import Web.HTML.Window (document)
import Web.HTML.HTMLDocument (setTitle)
import Pha (VDom, Sub)
import Data.Tuple (Tuple(..))
import Pha.App.Internal as Internal

type Document msg = {
    title ∷ String,
    body ∷ VDom msg
}

type App msg state effs = 
    {   init ∷ {state :: state, effect :: ((state → state) → Effect Unit) → Effect Unit}
    ,   view ∷ state → Document msg
    ,   update ∷ ((state → state) → Effect Unit) → msg → Effect Unit
    ,   subscriptions ∷ state → Array (Sub msg)
    }

app ∷ ∀msg state effs. App msg state effs → Internal.AppBuilder msg state
app {init, view, update, subscriptions} {getS, setS, renderVDom} = 
    {render, init: init2, subscriptions, dispatch, dispatchEvent} where
    {modify, dispatch, dispatchEvent} = Internal.getDispatchers getS setS update
    init2 = setS init.state *> init.effect modify
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
        init: {state: init, effect: \_ -> pure unit}
    ,   view: \st -> {title: "Pha App", body: view st}
    ,   update: (_ <<< update)
    ,   subscriptions: const []
    }

{-}
 {getS, setS, renderVDom} = 
    {render, init: setS init, subscriptions: const [], dispatch, dispatchEvent} where
    update2 fn = dispatch <<< update 
    {modify, dispatch, dispatchEvent} = Internal.getDispatchers getS setS update (const (pure unit))
    render = renderVDom <<< view
-}
