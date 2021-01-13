module Pha.Update (UpdateF(..), Update(..), Update', delay, module Exports) where
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

instance functorUpdateF :: Functor (UpdateF state) where
    map f (State k) = State (lmap f <<< k)
    map f (Lift q) = Lift (map f q)


newtype Update state a = Update (Free (UpdateF state) a)
type Update' state = Update state Unit

derive newtype instance functorUpdate :: Functor (Update state)
derive newtype instance applyUpdate :: Apply (Update state)
derive newtype instance applicativeUpdate :: Applicative (Update state)
derive newtype instance bindUpdate :: Bind (Update state)
derive newtype instance monadUpdate :: Monad (Update state)
derive newtype instance monadRecUpdate :: MonadRec (Update state)

instance monadStateUpdate :: MonadState state (Update state) where
    state = Update <<< liftF <<< State

instance monadEffectUpdate :: MonadEffect (Update state) where
    liftEffect = Update <<< liftF <<< Lift <<< liftEffect

instance monadAffUpdate :: MonadAff (Update state) where
    liftAff = Update <<< liftF <<< Lift

delay :: forall state. Milliseconds -> Update state Unit
delay ms = liftAff (Aff.delay ms)