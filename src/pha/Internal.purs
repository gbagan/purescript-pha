module Pha.Internal where
import Prelude
import Effect (Effect)
import Pha (VDom, Event, EventHandler, Sub)

type Document msg = {
    title ∷ String,
    body ∷ VDom msg
}

type App msg state =
    {   view ∷ state → Document msg
    ,   dispatch ∷ msg → Effect Unit
    ,   dispatchEvent ∷ Event → (EventHandler msg) → Effect Unit
    ,   subscriptions ∷ state → Array (Sub msg)
    ,   init ∷ Effect Unit
    }

type AppBuilder msg state = Effect state → (state → Effect Unit) → App msg state

foreign import app ∷ ∀msg state. AppBuilder msg state → String → Effect Unit
