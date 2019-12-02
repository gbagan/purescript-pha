module Pha.Effects.Random (Rng, RNG, randomGenerate, interpretRng) where
import Prelude
import Effect (Effect)
import Data.Int (floor, toNumber)
import Control.Monad.Free (runFreeM)
import Run (Run, SProxy(..), FProxy)
import Run as Run
import Pha.Random (Random, RandomF(..))
import Unsafe.Coerce (unsafeCoerce)

data GenWrapper a b = GenWrapper (Random b) (b → a)

data Rng a
mkExists :: forall a b. GenWrapper a b -> Rng a
mkExists = unsafeCoerce

runExists :: forall a r. (forall b. GenWrapper a b -> r) -> Rng a -> r
runExists = unsafeCoerce

instance functorRng ∷ Functor Rng where
    map f = runExists \(GenWrapper d g) -> mkExists (GenWrapper d (f <<< g))

type RNG = FProxy Rng
_rng = SProxy ∷ SProxy "rng"

foreign import mathRandom ∷ Effect Number

randomGenerate ∷ ∀a r. Random a → Run (rng ∷ RNG | r) a
randomGenerate d = Run.lift _rng (mkExists (GenWrapper d identity))

runRng :: forall a. Random a -> Effect a
runRng = runFreeM go where
    go (RandomInt m next) = do
        x <- mathRandom
        pure (next $ floor(x * toNumber m))
    go (RandomNumber next) = do
        mathRandom <#> next

test :: forall b. GenWrapper (Effect Unit) b -> Effect Unit
test (GenWrapper rndData next) = runRng rndData >>= next

interpretRng ∷ Rng (Effect Unit) -> Effect Unit
interpretRng a = a # runExists test
 --   runRng rndData >>= next



{-
module Pha.Effects.Random (RNG, randomNumber, randomInt, randomBool, shuffle, sample, interpretRng, Rng(..)) where
import Prelude
import Effect (Effect)
import Data.Maybe (Maybe, fromMaybe)
import Data.Tuple (Tuple(Tuple))
import Data.Traversable (sequence)
import Data.Int (floor, toNumber)
import Data.Array (length, mapWithIndex, foldl, index, insertAt)
import Run as Run
import Run (FProxy, SProxy(..), Run, AFF)

data Rng a = RngInt Int (Int → a) | RngNumber (Number → a)
derive instance functorRng ∷ Functor Rng
type RNG = FProxy Rng
_rng = SProxy ∷ SProxy "rng"

foreign import mathRandom ∷ Effect Number

-- | default implementation for random effects
interpretRng ∷ Rng (Effect Unit) -> Effect Unit
interpretRng (RngInt m next) = do
        x <- mathRandom 
        next (floor(x * toNumber m))
interpretRng (RngNumber next) =
        mathRandom >>= next