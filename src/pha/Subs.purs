module Pha.Subs (Canceler, makeSub, on, onKeyDown, onHashChange) where
import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Pha (Sub, EventHandler)
import Web.HTML (window)
import Web.HTML.Window as W
import Web.Event.Event as E
import Web.Event.EventTarget as ET
import Web.UIEvent.KeyboardEvent as KE
import Web.HTML.Event.HashChangeEvent (HashChangeEvent)
import Web.HTML.Event.HashChangeEvent as HCE

type Canceler = Effect Unit

foreign import makeSub ∷ forall d msg. ((msg → Effect Unit) → d → Effect Canceler) → d → Sub msg 

on ∷ ∀msg. String → EventHandler msg → Sub msg
on n d = makeSub fn {name: n, decoder: d}
    where
    fn dispatch {decoder, name} = do
        let t = E.EventType name
        listener <- ET.eventListener (handleEvent dispatch decoder)
        window <#> W.toEventTarget >>= ET.addEventListener t listener false
        pure (window <#> W.toEventTarget >>= ET.removeEventListener t listener false)
    handleEvent dispatch decoder ev =
        decoder ev >>= case _ of
            Nothing → pure unit
            Just msg → dispatch msg

onKeyDown ∷ ∀msg. (String → Maybe msg) → Sub msg
onKeyDown f = on "keydown" \ev → pure $ f =<< KE.key <$> KE.fromEvent ev

onHashChange ∷ ∀msg. (HashChangeEvent → Maybe msg) → Sub msg
onHashChange f = on "hashchange" \ev → pure $ HCE.fromEvent ev >>= f