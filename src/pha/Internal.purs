module Pha.Internal where
import Prelude
import Effect (Effect)
import Pha (VDom, Event, EventHandler, Sub)

type Document msg = {
    title ∷ String,
    body ∷ VDom msg
}

foreign import app ∷ ∀msg model. (Effect model → (model → Effect Unit) → {
    view ∷ model → Document msg,
    node ∷ String,
    dispatch ∷ msg → Effect Unit,
    dispatchEvent ∷ Event → (EventHandler msg) → Effect Unit,
    subscriptions ∷ model → Array (Sub msg),
    init ∷ Effect Unit
}) → Effect Unit
