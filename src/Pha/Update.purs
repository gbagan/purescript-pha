module Pha.Update
  ( delay
  , module I
  , module Exports
  ) where

import Prelude
import Pha.Update.Internal (Subscription, SubscriptionId, Update, hoist, mapMessage, mapModel, subscribe, unsubscribe) as I
import Control.Monad.State.Class (get, gets, put, modify, modify_) as Exports
import Effect.Aff (Milliseconds)
import Effect.Aff as Aff
import Effect.Aff.Class (class MonadAff, liftAff)
import Effect.Aff (Milliseconds(..)) as Exports
import Effect.Aff.Class (liftAff) as Exports
import Effect.Class (liftEffect) as Exports

delay ∷ ∀model msg m. MonadAff m ⇒ Milliseconds → I.Update model msg m Unit
delay = liftAff <<< Aff.delay
