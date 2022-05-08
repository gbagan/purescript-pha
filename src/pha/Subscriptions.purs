module Pha.Subscriptions (Subscription(..), makeSubscription, on, onKeyDown, onHashChange) where
import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Pha.Html.Core (EventHandler)
import Web.HTML (window)
import Web.HTML.Window as W
import Web.Event.Event as E
import Web.Event.EventTarget as ET
import Web.UIEvent.KeyboardEvent as KE
import Web.HTML.Event.HashChangeEvent (HashChangeEvent)
import Web.HTML.Event.HashChangeEvent as HCE

newtype Subscription msg = Subscription ((msg → Effect Unit) → Effect Unit)

makeSubscription ∷ forall d msg. ((msg → Effect Unit) → d → Effect Unit) → d → Subscription msg 
makeSubscription sub d = Subscription \dispatch → sub dispatch d

on ∷ ∀msg. String → EventHandler msg → Subscription msg
on n d = makeSubscription fn {name: n, decoder: d}
    where
    fn dispatch {decoder, name} = do
        listener <- ET.eventListener (handleEvent dispatch decoder)
        window <#> W.toEventTarget >>= ET.addEventListener (E.EventType name) listener false
    handleEvent dispatch decoder ev =
        decoder ev >>= case _ of
            Nothing → pure unit
            Just msg → dispatch msg

onKeyDown ∷ ∀msg. (String → Maybe msg) → Subscription msg
onKeyDown f = on "keydown" \ev → pure $ f =<< KE.key <$> KE.fromEvent ev

onHashChange ∷ ∀msg. (HashChangeEvent → Maybe msg) → Subscription msg
onHashChange f = on "hashchange" \ev → pure $ HCE.fromEvent ev >>= f

-- onResize ∷ ∀msg. (UI.UIEvent → Maybe msg) → Subscription msg
-- onResize f = on "resize" \ev → pure $ UI.fromEvent ev >>= f