module Pha.Random (randomInt, randomBool, shuffle, randomPick, RNG, Rng(..)) where
import Prelude
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple(Tuple))
import Data.Traversable (sequence)
import Data.Array (length, mapWithIndex, foldl, unsafeIndex, insertAt)
import Partial.Unsafe (unsafePartial)
import Run (FProxy, SProxy(..), Run, lift)

data Rng a = RngInt Int (Int -> a) | RngNumber (Number -> a)
derive instance functorRng :: Functor Rng
type RNG = FProxy Rng

-- | generate a random integer in the range [0, n - 1]
randomInt :: ∀r. Int -> Run (rng :: RNG | r) Int
randomInt n = lift (SProxy :: SProxy "rng") (RngInt n identity)

-- | generate a random boolean 
randomBool :: ∀r. Run (rng :: RNG | r) Boolean
randomBool = randomInt 2 <#> eq 0

-- | randomly shuffle an array
shuffle :: ∀a r. Array a -> Run (rng :: RNG | r) (Array a)
shuffle array = do
    rnds <- sequence $ array # mapWithIndex \i x -> Tuple x <$> randomInt (i+1)
    pure $ rnds # foldl (\t (Tuple x i) -> t # insertAt i x # fromMaybe []) []

randomPick :: ∀a r. Array a -> Maybe (Run (rng :: RNG | r) a)
randomPick [] = Nothing
randomPick t = Just $ unsafePartial $ unsafeIndex t <$> (randomInt $ length t)
