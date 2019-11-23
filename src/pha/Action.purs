module Pha.Action (Action, Action', getState, setState, setState', delay, GETSTATE, SETSTATE, DELAY, delayInterpret, rngInterpret,
    GetState(..), SetState(..), Delay(..), module R) where
import Prelude
import Data.Int (floor, toNumber)
import Effect(Effect)
import Run (FProxy, Run, SProxy(..), lift)
import Pha.Random (RNG, Rng(..)) as R

foreign import data Event :: Type

data GetState st a = GetState (st -> a)
derive instance functorGetState :: Functor (GetState st)
type GETSTATE st = FProxy (GetState st)

-- | return the current state
getState :: ∀st r. Run (getState :: GETSTATE st | r) st
getState = lift (SProxy :: SProxy "getState") (GetState identity)

data SetState st a = SetState (st -> st) a
derive instance functorSetState :: Functor (SetState st)
type SETSTATE st = FProxy (SetState st)

-- | evaluate a function over the current state and set the result to the state
setState :: ∀st r. (st -> st) -> Run (setState :: SETSTATE st | r) Unit
setState fn = lift (SProxy :: SProxy "setState") (SetState fn unit)

-- | same as setState except it returns the current state after applying the function
setState' :: ∀effs st. (st -> st) -> Run (getState :: GETSTATE st, setState :: SETSTATE st | effs) st
setState' fn = setState fn *> getState

type Action' st effs a = Run (getState :: GETSTATE st, setState :: SETSTATE st | effs) a
type Action st effs = Action' st effs Unit

data Delay a = Delay Int a
derive instance functorDelay :: Functor Delay
type DELAY = FProxy Delay

-- | sleep during n milliseconds then continue the action
delay :: ∀r. Int -> Run (delay :: DELAY | r) Unit
delay ms = lift (SProxy :: SProxy "delay") (Delay ms unit)

foreign import setTimeout :: Int -> Effect Unit -> Effect Unit
foreign import mathRandom :: Effect Number

-- | default implementation of the effect delay
delayInterpret :: Delay (Effect Unit) -> Effect Unit
delayInterpret (Delay ms cont) = setTimeout ms cont

-- | default implementation for random effects
rngInterpret :: R.Rng (Effect Unit) -> Effect Unit
rngInterpret (R.RngInt m cont) = mathRandom >>= \r -> cont (floor(r * toNumber m))
rngInterpret (R.RngNumber cont) = mathRandom >>= cont