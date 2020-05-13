module Pha.Update (Update, get, modify, modify', put, STATE, State(..), _state) where
import Prelude
import Run (FProxy, Run, SProxy(..), lift)

foreign import data Event ∷ Type

data State st a = GetState (st → a) | SetState (st → st) a
derive instance functorState ∷ Functor (State st)
type STATE st = FProxy (State st)
_state = SProxy ∷ SProxy "state"

-- | return the current state
get ∷ ∀st r. Run (state ∷ STATE st | r) st
get = lift (SProxy ∷ SProxy "state") (GetState identity)

-- | evaluate a function over the current state and set the result to the state
modify ∷ ∀st r. (st → st) → Run (state ∷ STATE st | r) Unit
modify fn = lift (SProxy ∷ SProxy "state") (SetState fn unit)

-- | same as setState except it returns the current state after applying the function
modify' ∷ ∀effs st. (st → st) → Run (state ∷ STATE st | effs) st
modify' fn = modify fn *> get

put ∷ ∀effs st. st → Run (state ∷ STATE st | effs) Unit
put x = modify \_ → x

type Update st effs = Run (state ∷ STATE st | effs) Unit
