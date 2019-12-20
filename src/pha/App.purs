module Pha.App (app, sandbox, attachTo, Document, App, module Exports) where
import Prelude
import Effect (Effect)
import Web.HTML (window)
import Web.HTML.Window (document)
import Web.HTML.HTMLDocument (setTitle)
import Pha (VDom, Sub)
import Data.Tuple (Tuple(..))
import Pha.App.Internal as Internal
import Pha.App.Internal (Interpreter) as Exports
import Pha.Update (Update, setState)

type Document msg = {
    title ∷ String,
    body ∷ VDom msg
}

type App msg state effs = 
    {   init ∷ Tuple state (Update state effs)
    ,   view ∷ state → Document msg
    ,   update ∷ msg → Update state effs
    ,   subscriptions ∷ state → Array (Sub msg)
    ,   interpreter ∷ Internal.Interpreter effs
    }

app ∷ ∀msg state effs. App msg state effs → Internal.AppBuilder msg state
app {init: Tuple istate init, view, update, subscriptions, interpreter} {getS, setS, renderVDom} = 
    {render, init: init2, subscriptions, dispatch, dispatchEvent} where
    {runAction, dispatch, dispatchEvent} = Internal.getDispatchers getS setS update interpreter
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
    {dispatch, dispatchEvent} = Internal.getDispatchers getS setS update2 (const (pure unit))
    render = renderVDom <<< view

