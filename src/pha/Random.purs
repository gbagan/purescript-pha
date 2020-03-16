module Pha.Random (Random, number, int, int', bool, shuffle, element, element', RandomF(..)) where
import Prelude
import Data.Maybe (Maybe, fromMaybe)
import Data.Traversable (sequence)
import Data.Array (length, mapWithIndex, foldl, index, insertAt)
import Data.Array.NonEmpty as NEA
import Control.Monad.Free (Free, liftF)

data RandomF a = RandomInt Int (Int → a) | RandomNumber (Number → a)
derive instance functorRng ∷ Functor RandomF
type Random = Free RandomF

-- | generate a random integer in the range [0, n - 1]
int' ∷ Int → Random Int
int' n = liftF (RandomInt n identity)

-- | generate a random integer in the range [n, m]
int ∷ Int → Int → Random Int
int n m
    | m < n = int m n
    | otherwise = int' (m + 1 - n) <#> (_ + n)

-- | generate a random number in the range [0, 1)
number ∷ Random Number
number = liftF (RandomNumber identity)

-- | generate a random boolean 
bool ∷ Random Boolean
bool = int' 2 <#> eq 0

-- | randomly shuffle an array
shuffle ∷ ∀a. Array a → Random (Array a)
shuffle array = do
    rnds ← sequence $ array # mapWithIndex \i value → {value, index: _} <$> int' (i+1)
    pure $ rnds # foldl (\t {value, index} → fromMaybe [] (insertAt index value t)) []

-- | randomly select an element from the array
element ∷ ∀a. NEA.NonEmptyArray a → Random a
element t = fromMaybe (NEA.head t) <$> NEA.index t <$> int' (NEA.length t)

-- | randomly select an element from the array
element' ∷ ∀a. Array a → Random (Maybe a)
element' t = index t <$> int' (length t)