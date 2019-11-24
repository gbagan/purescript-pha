module Pha.Effects.Delay (DELAY, delay, interpretDelay, Delay(..)) where
import Prelude
import Effect(Effect)
import Run (FProxy, Run, SProxy(..), lift)

data Delay a = Delay Int a
derive instance functorDelay :: Functor Delay
type DELAY = FProxy Delay

-- | sleep during n milliseconds then continue the action
delay :: ∀r. Int -> Run (delay :: DELAY | r) Unit
delay ms = lift (SProxy :: SProxy "delay") (Delay ms unit)

foreign import setTimeout :: Int -> Effect Unit -> Effect Unit

-- | default implementation of the effect delay
interpretDelay :: Delay (Effect Unit) -> Effect Unit
interpretDelay (Delay ms cont) = setTimeout ms cont