module Pha.Effects.Delay (interpretDelay) where
import Prelude
import Effect.Aff as Aff
import Effect.Aff (Aff)
import Data.Int (toNumber)
import Data.Functor.Variant (VariantF, inj, FProxy, SProxy(..))
import Data.Time.Duration (Milliseconds(..))

interpretDelay ∷ forall msg. Int -> msg -> Aff msg
interpretDelay ms msg = do
        Aff.delay (Milliseconds $ toNumber ms)
        pure msg