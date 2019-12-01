module Pha.Effects.Random (randomNumber, randomInt, randomBool, shuffle, sample, wrapGen, interpretGenerate,
        GenWrapper, GenWrapper', Random, RandomF) where
import Prelude
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Aff (Aff)
import Data.Maybe (Maybe, fromMaybe)
import Data.Tuple (Tuple(Tuple))
import Data.Traversable (sequence)
import Data.Int (floor, toNumber)
import Data.Array (length, mapWithIndex, foldl, index, insertAt)
import Control.Monad.Free (Free, liftF, runFreeM)
import Data.Exists (Exists, mkExists, runExists)

data RandomF a = RngInt Int (Int → a) | RngNumber (Number → a)
derive instance functorRng ∷ Functor RandomF
type Random = Free RandomF

-- | generate a random integer in the range [0, n - 1]
randomInt ∷ Int → Random Int
randomInt n = liftF (RngInt n identity)

-- | generate a random number in the range [0, 1)
randomNumber ∷ Random Number
randomNumber = liftF (RngNumber identity)

-- | generate a random boolean 
randomBool ∷ Random Boolean
randomBool = randomInt 2 <#> eq 0

-- | randomly shuffle an array
shuffle ∷ ∀a. Array a → Random (Array a)
shuffle array = do
    rnds ← sequence $ array # mapWithIndex \i x → Tuple x <$> randomInt (i+1)
    pure $ rnds # foldl (\t (Tuple x i) → t # insertAt i x # fromMaybe []) []

-- | randomly select an element from the array
sample ∷ ∀a. Array a → Random (Maybe a)
sample t = index t <$> (randomInt $ length t)

data GenWrapper' msg a = GenWrapper' (Random a) (a → msg)
type GenWrapper msg = Exists (GenWrapper' msg)
wrapGen ∷ ∀a msg. (Random a) → (a → msg) → GenWrapper msg
wrapGen rnd fmsg = mkExists (GenWrapper' rnd fmsg)

foreign import mathRandom ∷ Effect Number

runRng :: forall eff a. Random a -> Effect a
runRng = runFreeM go where
    go (RngInt m next) = do
        x <- mathRandom
        pure (next $ floor(x * toNumber m))
    go (RngNumber next) = do
        mathRandom <#> next


interpretGenerate :: forall msg. GenWrapper msg  -> Aff msg
interpretGenerate wrap = wrap # runExists \(GenWrapper' randomData fmsg) ->
    liftEffect $ runRng randomData <#> fmsg

{-
-- | default implementation for random effects
interpretRng ∷ ∀r. Run (aff ∷ AFF, rng ∷ RNG | r) ~> Run (aff ∷ AFF | r)
interpretRng  = Run.run(Run.on _rng handle Run.send) where
    handle ∷ Rng ~> Run (aff ∷ AFF | r)
    handle (RngInt m next) = do
        x <- Run.liftAff $ liftEffect mathRandom 
        pure $ next (floor(x * toNumber m))
    handle (RngNumber next) =
        Run.liftAff $ liftEffect mathRandom <#> next