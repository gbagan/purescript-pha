module Pha.Update where
import Prelude
import Control.Monad.Free (Free, liftF)
import Effect.Aff (Aff, Milliseconds)
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Class (class MonadEffect, liftEffect)

data UpdateF state a = Get (state -> a) | Modify (state -> state) a | Lift (Aff a)

derive instance functorUpdateF :: Functor (UpdateF state)

newtype Update' state a = Update (Free (UpdateF state) a)
type Update state = Update' state Unit

derive newtype instance functorUpdate :: Functor (Update' state)
derive newtype instance applyUpdate :: Apply (Update' state)
derive newtype instance applicativeUpdate :: Applicative (Update' state)
derive newtype instance bindUpdate :: Bind (Update' state)
derive newtype instance monadUpdate :: Monad (Update' state)

instance monadEffectUpdate :: MonadEffect (Update' state) where
    liftEffect = Update <<< liftF <<< Lift <<< liftEffect

instance monadAffUpdate :: MonadAff (Update' state) where
    liftAff = Update <<< liftF <<< Lift

get :: forall state. Update' state state
get = Update $ liftF $ Get identity

modify :: forall state. (state -> state) -> Update state
modify f = Update $ liftF $ Modify f unit

delay :: forall state. Milliseconds -> Update state
delay ms = liftAff (Aff.delay ms)

put ∷ ∀st. st → Update st
put st = Update $ liftF $ Modify (const st) unit
