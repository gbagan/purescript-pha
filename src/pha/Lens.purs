module Pha.Lens (updateOver) where
import Prelude
import Data.Lens (Lens', (%~), view)
import Control.Monad.Free (hoistFree)
import Unsafe.Coerce (unsafeCoerce)
import Run (Run(Run), SProxy(..), on)
import Data.Functor.Variant (VariantF, inj)
import Pha.Update (Update, STATE, State(..))

lensVariant ∷ ∀st1 st2 v. Lens' st1 st2 → VariantF (state ∷ STATE st2 | v) ~> VariantF (state ∷ STATE st1 | v)
lensVariant lens = on (SProxy ∷ SProxy "state") (case _ of
        GetState cont → inj (SProxy ∷ SProxy "state") (GetState (cont <<< view lens))
        SetState fn cont → inj (SProxy ∷ SProxy "state") (SetState (lens %~ fn) cont)
    ) unsafeCoerce

-- | create an action which is applied on the target of the lens
updateOver ∷ ∀st1 st2 effs. Lens' st1 st2 → Update st2 effs → Update st1 effs
updateOver lens (Run f) = Run $ hoistFree (lensVariant lens) f

