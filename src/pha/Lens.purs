module Pha.Lens (updateOver) where
import Prelude
import Data.Lens (Lens', (%~), view)
import Control.Monad.Free (hoistFree)
import Unsafe.Coerce (unsafeCoerce)
import Run (Run(Run), SProxy(..), onMatch)
import Data.Functor.Variant (VariantF, inj)
import Pha.Update (Update, GETSTATE, SETSTATE, GetState(..), SetState(..))

lensVariant ∷ ∀st1 st2 v. Lens' st1 st2 → VariantF (getState ∷ GETSTATE st2, setState ∷ SETSTATE st2 | v) ~>
    VariantF (getState ∷ GETSTATE st1, setState ∷ SETSTATE st1 | v)
lensVariant lens = onMatch {
    getState: \(GetState cont) → inj (SProxy ∷ SProxy "getState") (GetState (cont <<< view lens)),
    setState: \(SetState fn cont) → inj (SProxy ∷ SProxy "setState") (SetState (lens %~ fn) cont)
} unsafeCoerce

-- | create an action which is applied on the target of the lens
updateOver ∷ ∀st1 st2 effs. Lens' st1 st2 → Update st2 effs → Update st1 effs
updateOver lens (Run f) = Run $ hoistFree (lensVariant lens) f

