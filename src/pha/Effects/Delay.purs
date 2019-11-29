module Pha.Effects.Delay (DELAY, delay, interpretDelay, Delay(..)) where
import Prelude
import Effect.Aff as Aff
import Data.Int (toNumber)
import Run (FProxy, Run, SProxy(..), AFF, lift)
import Run as Run
import Data.Time.Duration (Milliseconds(..))

data Delay a = Delay Int a
derive instance functorDelay ∷ Functor Delay
type DELAY = FProxy Delay
_delay = SProxy ∷ SProxy "delay"

-- | sleep during n milliseconds then continue the action
delay ∷ ∀r. Int → Run (delay ∷ DELAY | r) Unit
delay ms = lift _delay (Delay ms unit)

-- | default implementation of the effect delay
interpretDelay ∷ ∀r. Run (aff ∷ AFF, delay ∷ DELAY | r) Unit → Run (aff ∷ AFF | r) Unit
interpretDelay  = Run.run (Run.on _delay handle Run.send) where
    handle ∷ Delay ~> Run (aff ∷ AFF | r)
    handle (Delay ms next) = do
        Run.liftAff $ Aff.delay (Milliseconds $ toNumber ms)
        pure next