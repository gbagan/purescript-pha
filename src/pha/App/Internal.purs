module Pha.App.Internal where
import Prelude
import Effect (Effect)
import Data.Maybe (Maybe(..))
import Pha (VDom, Event, EventHandler, Sub)
import Pha.Update (Update, _state, State(..))
import Run (VariantF, on, runCont)

type Interpreter effs = VariantF effs (Effect Unit) → Effect Unit

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

getDispatchers ∷ ∀msg state effs. Effect state → (state → Effect Unit) → (msg → Update state effs) → Interpreter effs →
    {   runAction ∷ Update state effs → Effect Unit
    ,   dispatch ∷ msg → Effect Unit
    ,   dispatchEvent ∷ Event → (EventHandler msg) → Effect Unit
    }

getDispatchers getS setS update interpreter = {runAction, dispatch, dispatchEvent} where
    runAction = runCont handleState (const (pure unit)) where
        handleState = on _state (case _ of
            GetState next → getS >>= next
            SetState f next → (getS <#> f >>= setS) *> next
         ) interpreter
    dispatch = runAction <<< update
    dispatchEvent ev handler = do
            let {effect, msg} = handler ev
            effect
            case msg of
                Nothing → pure unit
                Just m → dispatch m