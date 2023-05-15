module Pha.Util (memoize, memoCompose, memoCompose') where

import Prelude

foreign import memoizedImpl :: forall a b c. (a -> b) -> (b -> c) -> a -> c
foreign import memoizedObj :: forall a b c. (a -> b) -> (b -> c) -> a -> c

-- | Memoize the function f.
-- | If the argument of f differs from the previous call, then f is recomputed.
memoize :: forall a b. (a -> b) -> a -> b
memoize = memoizedImpl identity

-- | Memoize the composition of two functions f and g
-- | If the argument of f equals from the previous call, then f is recomputed.
-- | If the argument of g differs from the previous call, then g is recomputed.
memoCompose :: forall a b c. (a -> b) -> (b -> c) -> a -> c
memoCompose = memoizedImpl

memoCompose' :: forall a b c. (a -> Record b) -> (Record b -> c) -> a -> c
memoCompose' = memoizedObj