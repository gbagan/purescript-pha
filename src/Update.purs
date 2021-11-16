module Pha.Update (UpdateF(..), Update(..), delay, module Exports) where
import Prelude
import Data.Tuple (Tuple)
import Data.Bifunctor (lmap)
import Control.Monad.Free (Free, liftF)
import Effect.Aff (Aff, Milliseconds)
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)
import Control.Monad.Rec.Class (class MonadRec)
import Control.Monad.State.Class (get, gets, put, modify, modify_) as Exports
import Control.Monad.State.Class (class MonadState)

data UpdateF state a = State (state -> Tuple a state) | Lift (Aff a)

instance Functor (UpdateF state) where
    map f (State k) = State (lmap f <<< k)
    map f (Lift q) = Lift (map f q)

newtype Update state a = Update (Free (UpdateF state) a)

derive newtype instance Functor (Update state)
derive newtype instance Apply (Update state)
derive newtype instance Applicative (Update state)
derive newtype instance Bind (Update state)
derive newtype instance Monad (Update state)
derive newtype instance MonadRec (Update state)

instance MonadState state (Update state) where
    state = Update <<< liftF <<< State

instance MonadEffect (Update state) where
    liftEffect = Update <<< liftF <<< Lift <<< liftEffect

instance MonadAff (Update state) where
    liftAff = Update <<< liftF <<< Lift

delay :: forall state. Milliseconds -> Update state Unit
delay ms = liftAff (Aff.delay ms)