module Pha.Internal where
import Prelude
import Effect (Effect)
import Pha (VDom, Event, EventHandler, Sub)

type Document msg = {
    title ∷ String,
    body ∷ VDom msg
}

foreign import app ∷ ∀msg state. (Effect state → (state → Effect Unit) → {
    state ∷ state,
    view ∷ state → Document msg,
    node ∷ String,
    dispatch ∷ msg → Effect Unit,
    dispatchEvent ∷ Event → (EventHandler msg) → Effect Unit,
    subscriptions ∷ state → Array (Sub msg),
    init ∷ Effect Unit
}) → Effect Unit
