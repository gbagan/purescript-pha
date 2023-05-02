module Pha.Update
  ( Update(..)
  , UpdateF(..)
  , SubscriptionId(..)
  , delay
  , subscribe
  , unsubscribe
  , mapMessage
  , mapModel
  , hoist
  , module Exports
  ) where

import Prelude
import Control.Monad.Free (Free, liftF, hoistFree)
import Data.Bifunctor (lmap)
import Data.Lens (Lens', view, set)
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Aff (Milliseconds)
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Control.Monad.Rec.Class (class MonadRec)
import Control.Monad.State.Class (get, gets, put, modify, modify_) as Exports
import Control.Monad.State.Class (class MonadState)
import Control.Monad.Trans.Class (class MonadTrans)
import Unsafe.Reference (unsafeRefEq)

newtype SubscriptionId = SubscriptionId Int
derive newtype instance Eq SubscriptionId
derive newtype instance Ord SubscriptionId

type Subscription msg = (msg → Effect Unit) → Effect (Effect Unit)

data UpdateF model msg m a =
    State (model → Tuple a model)
  | Lift (m a)
  | Subscribe ((msg → Effect Unit) → Effect (Effect Unit)) (SubscriptionId → a)
  | Unsubscribe SubscriptionId a

instance Functor m ⇒ Functor (UpdateF model msg m) where
  map f (State k) = State (lmap f <<< k)
  map f (Lift q) = Lift (map f q)
  map f (Subscribe g a) = Subscribe g (f <<< a)
  map f (Unsubscribe id a) = Unsubscribe id (f a)

newtype Update model msg m a = Update (Free (UpdateF model msg m) a)

derive newtype instance Functor (Update state msg m)
derive newtype instance Apply (Update state msg m)
derive newtype instance Applicative (Update msg state m)
derive newtype instance Bind (Update state msg m)
derive newtype instance Monad (Update state msg m)
derive newtype instance MonadRec (Update state msg m)

instance MonadState state (Update state msg m) where
  state = Update <<< liftF <<< State

instance MonadTrans (Update state msg) where
  lift = Update <<< liftF <<< Lift

instance MonadEffect m ⇒ MonadEffect (Update state msg m) where
  liftEffect = Update <<< liftF <<< Lift <<< liftEffect

instance MonadAff m ⇒ MonadAff (Update state msg m) where
  liftAff = Update <<< liftF <<< Lift <<< liftAff

subscribe ∷ ∀model msg m. Subscription msg → Update model msg m SubscriptionId
subscribe f = Update $ liftF $ Subscribe f identity

unsubscribe ∷ ∀model msg m. SubscriptionId → Update model msg m Unit
unsubscribe id = Update $ liftF $ Unsubscribe id unit

delay ∷ ∀model msg m. MonadAff m ⇒ Milliseconds → Update model msg m Unit
delay = liftAff <<< Aff.delay

mapMessage ∷ ∀model msg msg' m. (msg → msg') → Update model msg m ~> Update model msg' m
mapMessage f (Update m) = Update $ m # hoistFree case _ of
  State k → State k
  Lift x → Lift x
  Subscribe g a → Subscribe (\dispatch → g \msg → dispatch (f msg)) a
  Unsubscribe id a → Unsubscribe id a

mapModel ∷ ∀model model' msg m. Lens' model model' → Update model' msg m ~> Update model msg m
mapModel lens (Update m) = Update $ m # hoistFree case _ of
    State k → State \s →
        let s2 = view lens s
            Tuple a s3 = k s2
        in
        if unsafeRefEq s2 s3 then
            Tuple a s
        else
            Tuple a (set lens s3 s)

    Lift x → Lift x
    Subscribe x a → Subscribe x a
    Unsubscribe id a → Unsubscribe id a

hoist ∷ ∀model msg m m'. (m ~> m') → Update model msg m ~> Update model msg m'
hoist f (Update m) = Update $ m # hoistFree case _ of
  State k → State k
  Lift x → Lift (f x)
  Subscribe g a → Subscribe g a
  Unsubscribe id a → Unsubscribe id a