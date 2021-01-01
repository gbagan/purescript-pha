module Pha.Update.Lens where
import Prelude
import Data.Lens (Lens', view, over)
import Control.Monad.Free (hoistFree)
import Pha.Update (Update'(..), UpdateF(..))

updateOver ∷ ∀st st'. Lens' st st' → Update' st' ~> Update' st
updateOver lens (Update m) = Update $ m # hoistFree case _ of
    Get a → Get (a <<< view lens)
    Modify f a → Modify (over lens f) a
    Lift x → Lift x