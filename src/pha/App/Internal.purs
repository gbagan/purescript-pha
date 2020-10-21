module Pha.App.Internal where
import Prelude
import Effect (Effect)
import Data.Maybe (Maybe(..))
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

getDispatchers ∷ ∀msg state. Effect state →
                             (state → Effect Unit) →
                            ({get ∷ Effect state, modify ∷ (state → state) → Effect Unit} → msg → Effect Unit) →
    {   dispatch ∷ msg → Effect Unit
    ,   dispatchEvent ∷ Event → (EventHandler msg) → Effect Unit
    }

getDispatchers getS setS update = {dispatch, dispatchEvent} where
    modify ∷ (state → state) → Effect Unit
    modify fn = getS >>= (setS <<< fn)
    dispatch = update {get: getS, modify}
    dispatchEvent ev handler = do
            msg <- handler ev
            case msg of
                Nothing → pure unit
                Just m → dispatch m