module Util (memoized, memoized') where

foreign import memoized :: forall a b c. (a -> b) -> (b -> c) -> a -> c

foreign import memoizedObj :: forall a b c. (a -> b) -> (b -> c) -> a -> c

memoized' :: forall a b c. (a -> Record b) -> (Record b -> c) -> a -> c
memoized' = memoizedObj