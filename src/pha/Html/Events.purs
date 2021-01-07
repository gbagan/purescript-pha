module Pha.Html.Events where
{-
(onclick, onclick',
    onmouseup, onmouseup', onmousedown, onmousedown', onmouseenter, onmouseenter', onmouseleave, onmouseleave',
    onpointerup, onpointerup', onpointerdown, onpointerdown', onpointerenter, onpointerenter', onpointerleave, onpointerleave',
    oncontextmenu, oncontextmenu',
    onvaluechange, onchecked,
    on', custom, preventDefaultOn, stopPropagationOn, releasePointerCaptureOn) where
-}
import Prelude hiding (div)
import Effect (Effect)
import Data.Maybe (Maybe(..), maybe)
import Data.Tuple (Tuple(..))
import Web.Event.Event as Event
import Web.UIEvent.MouseEvent (MouseEvent)
import Web.UIEvent.MouseEvent as ME
import Web.HTML.HTMLInputElement as HTMLInput
import Pha.Html.Core (Prop, Event, EventHandler, unsafeOnWithEffect)

always ∷ ∀ev msg. msg → ev → Effect (Maybe msg)
always msg _ = pure (pure msg)

always' ∷ ∀ev msg. msg → ev → Effect msg
always' msg _ = pure msg

on ∷ ∀msg. String → EventHandler msg → Prop msg
on = unsafeOnWithEffect

foreign import setPointerCaptureE ∷ Event → Effect Unit
foreign import releasePointerCaptureE ∷ Event → Effect Unit

custom ∷ ∀msg. String → EventHandler {message ∷ Maybe msg, stopPropagation ∷ Boolean, preventDefault ∷ Boolean} → Prop msg
custom eventname decoder = unsafeOnWithEffect eventname handler where
    handler ev = do
        decoder ev >>= case _ of
            Just {message, stopPropagation, preventDefault} → do
                when stopPropagation (Event.stopPropagation ev)
                when preventDefault (Event.preventDefault ev)
                pure message
            _  → pure Nothing



preventDefaultOn ∷ ∀msg. String → EventHandler (Tuple (Maybe msg) Boolean) → Prop msg
preventDefaultOn eventname decoder = custom eventname (decoder >>> map (map \(Tuple msg prev) → {
    message: msg,
    preventDefault: prev,
    stopPropagation: false
}))

stopPropagationOn ∷ ∀msg. String → EventHandler (Tuple (Maybe msg) Boolean) → Prop msg
stopPropagationOn eventname decoder = custom eventname (decoder >>> map (map \(Tuple msg stop) → {
    message: msg,
    preventDefault: false,
    stopPropagation: stop
}))

releasePointerCaptureOn ∷ ∀msg. String → EventHandler msg → Prop msg
releasePointerCaptureOn eventname decoder = unsafeOnWithEffect eventname handler where
    handler ev = do
        releasePointerCaptureE ev
        decoder ev

onClick ∷ ∀msg. msg → Prop msg
onClick = on "click" <<< always
onClick' ∷ ∀msg. Maybe msg → Prop msg
onClick' = on "click" <<< always'
onClick_ ∷ ∀msg. (MouseEvent → Effect (Maybe msg)) → Prop msg
onClick_ handler = on "click" \ev → ME.fromEvent ev # maybe (pure Nothing) handler

onMouseUp ∷ ∀msg. msg → Prop msg
onMouseUp = on "mouseup" <<< always
onMouseUp' ∷ ∀msg. Maybe msg → Prop msg
onMouseUp' = on "mouseup" <<< always'
onMouseUp_ ∷ ∀msg. (MouseEvent → Effect (Maybe msg)) → Prop msg
onMouseUp_ handler = on "mouseup" \ev → ME.fromEvent ev # maybe (pure Nothing) handler

onMouseDown ∷ ∀msg. msg → Prop msg
onMouseDown = on "mousedown" <<< always
onMouseDown' ∷ ∀msg. Maybe msg → Prop msg
onMouseDown' = on "mousedown" <<< always'
onMouseDown_ ∷ ∀msg. (MouseEvent → Effect (Maybe msg)) → Prop msg
onMouseDown_ handler = on "mousedown" \ev → ME.fromEvent ev # maybe (pure Nothing) handler

onMouseEnter ∷ ∀msg. msg → Prop msg
onMouseEnter = on "mouseenter" <<< always
onMouseEnter' ∷ ∀msg. Maybe msg → Prop msg
onMouseEnter' = on "mouseenter" <<< always'
onMouseEnter_ ∷ ∀msg. (MouseEvent → Effect (Maybe msg)) → Prop msg
onMouseEnter_ handler = on "mouseenter" \ev → ME.fromEvent ev # maybe (pure Nothing) handler

onMouseLeave ∷ ∀msg. msg → Prop msg
onMouseLeave = on "mouseleave" <<< always
onMouseLeave' ∷ ∀msg. Maybe msg → Prop msg
onMouseLeave' = on "mouseleave" <<< always'
onMouseLeave_ ∷ ∀msg. (MouseEvent → Effect (Maybe msg)) → Prop msg
onMouseLeave_ handler = on "mouseleave" \ev → ME.fromEvent ev # maybe (pure Nothing) handler

onPointerUp ∷ ∀msg. msg → Prop msg
onPointerUp = on "pointerup" <<< always
onPointerUp' ∷ ∀msg. Maybe msg → Prop msg
onPointerUp' = on "pointerup" <<< always'
onPointerUp_ ∷ ∀msg. (MouseEvent → Effect (Maybe msg)) → Prop msg
onPointerUp_ handler = on "pointerup" \ev → ME.fromEvent ev # maybe (pure Nothing) handler

onPointerDown ∷ ∀msg. msg → Prop msg
onPointerDown = on "pointerdown" <<< always
onPointerDown' ∷ ∀msg. Maybe msg → Prop msg
onPointerDown' = on "pointerdown" <<< always'
onPointerDown_ ∷ ∀msg. (MouseEvent → Effect (Maybe msg)) → Prop msg
onPointerDown_ handler = on "pointerdown" \ev → ME.fromEvent ev # maybe (pure Nothing) handler

onPointerEnter ∷ ∀msg. msg → Prop msg
onPointerEnter = on "pointerenter" <<< always
onPointerEnter' ∷ ∀msg. Maybe msg → Prop msg
onPointerEnter' = on "pointerenter" <<< always'
onPointerEnter_ ∷ ∀msg. (MouseEvent → Effect (Maybe msg)) → Prop msg
onPointerEnter_ handler = on "pointerenter" \ev → ME.fromEvent ev # maybe (pure Nothing) handler

onPointerLeave ∷ ∀msg. msg → Prop msg
onPointerLeave = on "pointerleave" <<< always
onPointerLeave' ∷ ∀msg. Maybe msg → Prop msg
onPointerLeave' = on "pointerleave" <<< always'
onPointerLeave_ ∷ ∀msg. (MouseEvent → Effect (Maybe msg)) → Prop msg
onPointerLeave_ handler = on "pointerleave" \ev → ME.fromEvent ev # maybe (pure Nothing) handler

-- | note: trigger preventDefault 
onContextMenu ∷ ∀msg. msg → Prop msg
onContextMenu msg = preventDefaultOn "contextmenu" $ always (Tuple (Just msg) true)

-- | note: trigger preventDefault 
onContextMenu' ∷ ∀msg. (Maybe msg) → Prop msg
onContextMenu' msg = preventDefaultOn "contextmenu" $ always (Tuple msg true)


onValueChange ∷ ∀msg. (String → msg) → Prop msg
onValueChange f = on "change" fn
    where
    fn ev =
        case Event.currentTarget ev >>= HTMLInput.fromEventTarget of
            Nothing → pure Nothing
            Just target → Just <$> f <$> HTMLInput.value target

onChecked ∷ ∀msg. (Boolean → msg) → Prop msg
onChecked f = on "change" fn
    where
    fn ev =
        case Event.currentTarget ev >>= HTMLInput.fromEventTarget of
            Nothing → pure Nothing
            Just target → Just <$> f <$> HTMLInput.checked target
