module Pha.Util (memoized, memoCompose, memoCompose') where

import Prelude

foreign import memoizedImpl :: forall a b c. (a -> b) -> (b -> c) -> a -> c
foreign import memoizedObj :: forall a b c. (a -> b) -> (b -> c) -> a -> c

memoized :: forall a b. (a -> b) -> a -> b
memoized = memoizedImpl identity

memoCompose :: forall a b c. (a -> b) -> (b -> c) -> a -> c
memoCompose = memoizedImpl

memoCompose' :: forall a b c. (a -> Record b) -> (Record b -> c) -> a -> c
memoCompose' = memoizedObj