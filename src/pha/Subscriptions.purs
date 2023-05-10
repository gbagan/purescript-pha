module Pha.Subscriptions (eventListener, onKeyDown, onHashChange, onResize) where

import Prelude

import Data.Maybe (Maybe(..))
import Effect.Class (class MonadEffect, liftEffect)
import Pha.Html.Core (EventHandler)
import Pha.Update (SubscriptionId, Update, subscribe)
import Web.Event.Event as E
import Web.Event.EventTarget as ET
import Web.HTML (window)
import Web.HTML.Event.HashChangeEvent (HashChangeEvent)
import Web.HTML.Event.HashChangeEvent as HCE
import Web.HTML.Window as W
import Web.UIEvent.KeyboardEvent as KE
import Web.UIEvent.UIEvent as UI

eventListener ∷ ∀ msg model m. String → ET.EventTarget → EventHandler msg → Update model msg m SubscriptionId
eventListener name target decoder = subscribe \dispatch → do
  listener ← ET.eventListener (handleEvent dispatch)
  ET.addEventListener (E.EventType name) listener false target
  pure $ ET.removeEventListener (E.EventType name) listener false target
  where
  handleEvent dispatch ev =
    decoder ev >>= case _ of
      Nothing → pure unit
      Just msg → dispatch msg

onKeyDown ∷ ∀ msg model m. MonadEffect m ⇒ (String → Maybe msg) → Update model msg m SubscriptionId
onKeyDown f = do
  target ← liftEffect $ W.toEventTarget <$> window
  eventListener "keydown" target \ev → pure $ f =<< KE.key <$> KE.fromEvent ev

onHashChange ∷ ∀ msg model m. MonadEffect m ⇒ (HashChangeEvent → Maybe msg) → Update model msg m SubscriptionId
onHashChange f = do
  target ← liftEffect $ W.toEventTarget <$> window
  eventListener "hashchange" target \ev → pure $ f =<< HCE.fromEvent ev

onResize ∷ ∀ msg model m. MonadEffect m ⇒ (UI.UIEvent → Maybe msg) → Update model msg m SubscriptionId
onResize f = do
  target ← liftEffect $ W.toEventTarget <$> window
  eventListener "resize" target \ev → pure $ f =<< UI.fromEvent ev