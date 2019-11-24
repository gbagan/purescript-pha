module Pha.Lens (actionOver) where
import Prelude
import Data.Lens (Lens', (%~), view)
import Control.Monad.Free (hoistFree)
import Unsafe.Coerce (unsafeCoerce)
import Run (Run(Run), SProxy(..), onMatch)
import Data.Functor.Variant (VariantF, inj)
import Pha.Action (Action, GETSTATE, SETSTATE, GetState(..), SetState(..))
import Pha (VDom)

lensVariant :: ∀st1 st2 v. Lens' st1 st2 -> VariantF (getState :: GETSTATE st2, setState :: SETSTATE st2 | v) ~>
    VariantF (getState :: GETSTATE st1, setState :: SETSTATE st1 | v)
lensVariant lens = onMatch {
    getState: \(GetState cont) -> inj (SProxy :: SProxy "getState") (GetState (cont <<< view lens)),
    setState: \(SetState fn cont) -> inj (SProxy :: SProxy "setState") (SetState (lens %~ fn) cont)
} unsafeCoerce

-- | create an action which is applied on the target of the lens
actionOver :: ∀st1 st2 effs. Lens' st1 st2 -> Action st2 effs -> Action st1 effs
actionOver lens (Run f) = Run $ hoistFree (lensVariant lens) f

-- foreign import addDecorator :: ∀a b effs. (∀eff2. Action b eff2 -> Action a eff2) -> VDom b effs -> VDom msg

-- | return the same virtual dom as given in argument except that all actions triggered are applied on the target of the lens
--viewOver :: ∀a b effs. Lens' a b -> VDom b effs -> VDom msg
--viewOver lens = addDecorator (actionOver lens)