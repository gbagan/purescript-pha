module Pha.Random where
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

randomInt :: ∀r. Int -> Run (rng :: RNG | r) Int
randomInt max = lift (SProxy :: SProxy "rng") (RngInt max identity)

type Random a = ∀r. Run (rng :: RNG | r) a
type Random' r a = Run (rng :: RNG | r) a

randomBool :: Random Boolean
randomBool = randomInt 2 <#> eq 0

shuffle :: ∀a. Array a -> Random (Array a)
shuffle array = do
    rnds <- sequence $ array # mapWithIndex \i x -> Tuple x <$> randomInt (i+1)
    pure $ rnds # foldl (\t (Tuple x i) -> t # insertAt i x # fromMaybe []) []

randomPick :: ∀a r. Array a -> Maybe (Random' r a)
randomPick [] = Nothing
randomPick t = Just $ unsafePartial $ unsafeIndex t <$> (randomInt $ length t)
