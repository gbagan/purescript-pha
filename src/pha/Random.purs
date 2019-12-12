module Pha.Random (Random, randomNumber, randomInt, randomBool, shuffle, sample, RandomF(..)) where
import Prelude
import Data.Maybe (Maybe, fromMaybe)
import Data.Tuple (Tuple(Tuple))
import Data.Traversable (sequence)
import Data.Array (length, mapWithIndex, foldl, index, insertAt)
import Data.Array.NonEmpty as NEA
import Control.Monad.Free (Free, liftF)

data RandomF a = RandomInt Int (Int → a) | RandomNumber (Number → a)
derive instance functorRng ∷ Functor RandomF
type Random = Free RandomF

-- | generate a random integer in the range [0, n - 1]
randomInt' ∷ Int → Random Int
randomInt' n = liftF (RandomInt n identity)

-- | generate a random integer in the range [n, m]
randomInt ∷ Int → Int → Random Int
randomInt n m = randomInt' (m - n) <#> (_ + n)

-- | generate a random number in the range [0, 1)
randomNumber ∷ Random Number
randomNumber = liftF (RandomNumber identity)

-- | generate a random boolean 
randomBool ∷ Random Boolean
randomBool = randomInt' 2 <#> eq 0

-- | randomly shuffle an array
shuffle ∷ ∀a. Array a → Random (Array a)
shuffle array = do
    rnds ← sequence $ array # mapWithIndex \i x → Tuple x <$> randomInt' (i+1)
    pure $ rnds # foldl (\t (Tuple x i) → t # insertAt i x # fromMaybe []) []

-- | randomly select an element from the array
sample ∷ ∀a. NEA.NonEmptyArray a → Random a
sample t = fromMaybe (NEA.head t) <$> NEA.index t <$> randomInt' (NEA.length t)

-- | randomly select an element from the array
sample' ∷ ∀a. Array a → Random (Maybe a)
sample' t = index t <$> randomInt' (length t)