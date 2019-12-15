module Pha.Effects.Random (Rng, RNG, randomGenerate, randomly, interpretRng) where
import Prelude
import Effect (Effect)
import Data.Int (floor, toNumber)
import Control.Monad.Free (runFreeM)
import Run (Run, SProxy(..), FProxy)
import Run as Run
import Pha.Update (Update, getState, setState)
import Pha.Random (Random, RandomF(..))
import Data.Exists (Exists, mkExists, runExists)

data GenWrapper a b = GenWrapper (Random b) (b → a)

newtype Rng a = Rng (Exists (GenWrapper a)) 

instance functorRng ∷ Functor Rng where
    map f (Rng r) = Rng $ r # runExists \(GenWrapper d g) -> mkExists (GenWrapper d (f <<< g))

type RNG = FProxy Rng
_rng = SProxy ∷ SProxy "rng"

foreign import mathRandom ∷ Effect Number

randomGenerate ∷ ∀a r. Random a → Run (rng ∷ RNG | r) a
randomGenerate d = Run.lift _rng (Rng $ mkExists (GenWrapper d identity))

randomly ∷ ∀st effs. (st → Random st) → Update st (rng ∷ RNG | effs)
randomly f = do
    st <- getState
    st2 <- randomGenerate (f st)
    setState \_ → st2

runRng :: forall a. Random a -> Effect a
runRng = runFreeM go where
    go (RandomInt m next) = do
        x <- mathRandom
        pure (next $ floor(x * toNumber m))
    go (RandomNumber next) = do
        mathRandom <#> next

interpretRng ∷ Rng (Effect Unit) -> Effect Unit
interpretRng (Rng a) = runExists f a where
    f :: forall b. GenWrapper (Effect Unit) b -> Effect Unit
    f (GenWrapper rndData next) = runRng rndData >>= next