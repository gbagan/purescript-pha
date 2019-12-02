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

-- | generate a random integer in the range [0, n - 1]
randomInt ∷ ∀r. Int → Run (rng ∷ RNG | r) Int
randomInt n = Run.lift _rng (RngInt n identity)

-- | generate a random number in the range [0, 1)
randomNumber ∷ ∀r. Run (rng ∷ RNG | r) Number
randomNumber = Run.lift _rng (RngNumber identity)

-- | generate a random boolean 
randomBool ∷ ∀r. Run (rng ∷ RNG | r) Boolean
randomBool = randomInt 2 <#> eq 0

-- | randomly shuffle an array
shuffle ∷ ∀a r. Array a → Run (rng ∷ RNG | r) (Array a)
shuffle array = do
    rnds ← sequence $ array # mapWithIndex \i x → Tuple x <$> randomInt (i+1)
    pure $ rnds # foldl (\t (Tuple x i) → t # insertAt i x # fromMaybe []) []

-- | randomly select an element from the array
sample ∷ ∀a r. Array a → Run (rng ∷ RNG | r) (Maybe a)
sample t = index t <$> (randomInt $ length t)

foreign import mathRandom ∷ Effect Number

-- | default implementation for random effects
interpretRng ∷ Rng (Effect Unit) -> Effect Unit
interpretRng (RngInt m next) = do
        x <- mathRandom 
        next (floor(x * toNumber m))
interpretRng (RngNumber next) =
        mathRandom >>= next