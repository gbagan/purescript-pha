module Pha.Action (Action, Action', getState, setState, setState', GETSTATE, SETSTATE,
    GetState(..), SetState(..)) where
import Prelude
import Run (FProxy, Run, SProxy(..), lift)

foreign import data Event ∷ Type

data GetState st a = GetState (st → a)
derive instance functorGetState ∷ Functor (GetState st)
type GETSTATE st = FProxy (GetState st)

-- | return the current state
getState ∷ ∀st r. Run (getState ∷ GETSTATE st | r) st
getState = lift (SProxy ∷ SProxy "getState") (GetState identity)

data SetState st a = SetState (st → st) a
derive instance functorSetState ∷ Functor (SetState st)
type SETSTATE st = FProxy (SetState st)

-- | evaluate a function over the current state and set the result to the state
setState ∷ ∀st r. (st → st) → Run (setState ∷ SETSTATE st | r) Unit
setState fn = lift (SProxy ∷ SProxy "setState") (SetState fn unit)

-- | same as setState except it returns the current state after applying the function
setState' ∷ ∀effs st. (st → st) → Run (getState ∷ GETSTATE st, setState ∷ SETSTATE st | effs) st
setState' fn = setState fn *> getState

type Action' st effs a = Run (getState ∷ GETSTATE st, setState ∷ SETSTATE st | effs) a
type Action st effs = Action' st effs Unit
