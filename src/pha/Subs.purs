module Pha.Subs (Canceler, makeSub, on, onKeyDown {-, onAnimationFrame-}) where
import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Pha (Sub, EventHandler)
import Web.HTML (window)
import Web.HTML.Window as W
import Web.Event.Event as E
import Web.Event.EventTarget as ET
import Web.UIEvent.KeyboardEvent as KE

type Canceler = Effect Unit

foreign import makeSub ∷ forall d msg. ((msg → Effect Unit) → d → Effect Canceler) → d → Sub msg 

foreign import onAnimationFrameAux ∷ (Number → Effect Unit) → Effect Canceler

on ∷ ∀msg. String → EventHandler msg → Sub msg
on name = makeSub fn
    where
    fn dispatch decoder = do
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

{-
onAnimationFrame ∷ ∀msg. (Number → msg) → Sub msg
onAnimationFrame = makeSub fn
    where
    fn dispatch decoder = do
        id <- window <#> W.requestAnimationFrame 
        pure (window <#> W.cancelAnimationFrame id)
    -- where fn = \dispatch handler → onAnimationFrameAux (dispatch <<< handler)
-}