module Pha.Util (memoize, memoCompose, memoCompose2, memoCompose3, memoCompose') where

import Prelude

foreign import memoizeImpl :: forall a b c. (a -> b) -> (b -> c) -> a -> c
foreign import memoizeObj :: forall a b c. (a -> b) -> (b -> c) -> a -> c

-- | Memoize the function f.
-- | If the argument of f differs from the previous call, then f is recomputed.
memoize :: forall a b. (a -> b) -> a -> b
memoize = memoizeImpl identity

-- | Memoize the composition of two functions
memoCompose :: forall a b c. (a -> b) -> (b -> c) -> a -> c
memoCompose = memoizeImpl

memoCompose2 :: forall a b c d. (a -> b) -> (a -> c) -> (b -> c -> d) -> a -> d
memoCompose2 f g h = memoCompose' (\v -> {a: f v, b: g v}) \{a, b} -> h a b

memoCompose3 :: forall a b c d e. (a -> b) -> (a -> c) -> (a -> d) -> (b -> c -> d -> e) -> a -> e
memoCompose3 f g h l = memoCompose' (\v -> {a: f v, b: g v, c: h v}) \{a, b, c} -> l a b c

memoCompose' :: forall a b c. (a -> Record b) -> (Record b -> c) -> a -> c
memoCompose' = memoizeObj