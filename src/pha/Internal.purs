module Pha.Internal where
import Prelude
import Effect (Effect)
import Pha (VDom, Event, EventHandler, Sub)

type AppPrimitives msg state =
    {   getS ∷ Effect state
    ,   setS ∷ state → Effect Unit
    ,   renderVDom ∷ VDom msg → Effect Unit
    }

type App msg state =
    {   render ∷ state → Effect Unit
    ,   dispatch ∷ msg → Effect Unit
    ,   dispatchEvent ∷ Event → (EventHandler msg) → Effect Unit
    ,   subscriptions ∷ state → Array (Sub msg)
    ,   init ∷ Effect Unit
    }

type AppBuilder msg state = AppPrimitives msg state → App msg state

foreign import app ∷ ∀msg state. AppBuilder msg state → String → Effect Unit