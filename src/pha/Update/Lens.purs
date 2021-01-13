module Pha.Update.Lens where
import Data.Tuple (Tuple(..))
import Prelude
import Data.Lens (Lens', view, set)
import Unsafe.Reference (unsafeRefEq)
import Control.Monad.Free (hoistFree)
import Pha.Update (Update(..), UpdateF(..))

updateOver ∷ ∀st st'. Lens' st st' → Update st' ~> Update st
updateOver lens (Update m) = Update $ m # hoistFree case _ of
    State k → State \s ->
        let s2 = view lens s
            Tuple a s3 = k s2
        in
        if unsafeRefEq s2 s3 then
            Tuple a s
        else
            Tuple a (set lens s3 s)

    Lift x → Lift x