module Pha.Update
  ( Update(..)
  , UpdateF(..)
  , delay
  , subscribe
  , module Exports
  ) where
import Prelude
import Data.Tuple (Tuple)
import Data.Bifunctor (lmap)
import Control.Monad.Free (Free, liftF)
import Effect (Effect)
import Effect.Aff (Milliseconds)
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Control.Monad.Rec.Class (class MonadRec)
import Control.Monad.State.Class (get, gets, put, modify, modify_) as Exports
import Control.Monad.State.Class (class MonadState)
import Control.Monad.Trans.Class (class MonadTrans)

data UpdateF model msg m a =
    State (model → Tuple a model)
  | Lift (m a)
  | Subscribe ((msg → Effect Unit) → Effect Unit) a

instance Functor m => Functor (UpdateF model msg m) where
  map f (State k) = State (lmap f <<< k)
  map f (Lift q) = Lift (map f q)
  map f (Subscribe g a) = Subscribe g (f a)

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

instance MonadEffect m => MonadEffect (Update state msg m) where
  liftEffect = Update <<< liftF <<< Lift <<< liftEffect

instance MonadAff m => MonadAff (Update state msg m) where
  liftAff = Update <<< liftF <<< Lift <<< liftAff

subscribe ∷ forall model msg m. ((msg → Effect Unit) → Effect Unit) → Update model msg m Unit
subscribe f = Update $ liftF $ Subscribe f unit

delay ∷ forall model msg m. MonadAff m => Milliseconds → Update model msg m Unit
delay = liftAff <<< Aff.delay