module Pha.Update
  ( Update(..)
  , UpdateF(..)
  , delay
  , module Exports
  ) where
import Prelude
import Data.Tuple (Tuple)
import Data.Bifunctor (lmap)
import Control.Monad.Free (Free, liftF)
import Effect.Aff (Milliseconds)
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Control.Monad.Rec.Class (class MonadRec)
import Control.Monad.State.Class (get, gets, put, modify, modify_) as Exports
import Control.Monad.State.Class (class MonadState)
import Control.Monad.Trans.Class (class MonadTrans)

data UpdateF state m a = State (state -> Tuple a state) | Lift (m a)

instance Functor m => Functor (UpdateF state m) where
    map f (State k) = State (lmap f <<< k)
    map f (Lift q) = Lift (map f q)

newtype Update state m a = Update (Free (UpdateF state m) a)

derive newtype instance Functor (Update state m)
derive newtype instance Apply (Update state m)
derive newtype instance Applicative (Update state m)
derive newtype instance Bind (Update state m)
derive newtype instance Monad (Update state m)
derive newtype instance MonadRec (Update state m)

instance MonadState state (Update state m) where
    state = Update <<< liftF <<< State

instance MonadTrans (Update state) where
    lift = Update <<< liftF <<< Lift

instance MonadEffect m => MonadEffect (Update state m) where
    liftEffect = Update <<< liftF <<< Lift <<< liftEffect

instance MonadAff m => MonadAff (Update state m) where
    liftAff = Update <<< liftF <<< Lift <<< liftAff

delay :: forall state m. MonadAff m => Milliseconds -> Update state m Unit
delay ms = liftAff (Aff.delay ms)