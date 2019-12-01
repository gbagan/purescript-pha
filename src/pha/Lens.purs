module Pha.Lens (mapTransition) where
import Prelude
import Data.Lens (Lens', (.~), (^.))
import Pha (Transition, (/\))

-- | create an action which is applied on the target of the lens
mapTransition ∷ ∀st1 st2 msg1 msg2 effs. Functor effs =>
                    Lens' st1 st2 → (msg2 → msg1) →
                    (st2 → Transition st2 msg2 effs) → st1 → Transition st1 msg1 effs
mapTransition lens msgmap ftrans st1 =
    let st2 = st1^.lens
        st2' /\ effects = ftrans st2
    in (st1 # lens .~ st2')  /\ (effects <#> \effect -> effect <#> msgmap) 

