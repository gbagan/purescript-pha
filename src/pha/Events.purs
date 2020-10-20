module Pha.Events where
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
import Pha (Prop, Event, EventHandler, unsafeOnWithEffect)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Web.Event.Event as Event
import Web.HTML.HTMLInputElement as HTMLInput

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

releasePointerCaptureOn ∷ ∀msg. String → EventHandler (Maybe msg) → Prop msg
releasePointerCaptureOn eventname hander = unsafeOnWithEffect eventname handler where
    handler ev = do
        releasePointerCaptureE ev
        handler ev

onclick ∷ ∀msg. msg → Prop msg
onclick = on "click" <<< always
onclick' ∷ ∀msg. Maybe msg → Prop msg
onclick' = on "click" <<< always'

onmouseup ∷ ∀msg. msg → Prop msg
onmouseup = on "mouseup" <<< always
onmouseup' ∷ ∀msg. Maybe msg → Prop msg
onmouseup' = on "mouseup" <<< always'

onmousedown ∷ ∀msg. msg → Prop msg
onmousedown = on "mousedown" <<< always
onmousedown' ∷ ∀msg. Maybe msg → Prop msg
onmousedown' = on "mousedown" <<< always'

onmouseenter ∷ ∀msg. msg → Prop msg
onmouseenter = on "mouseenter" <<< always
onmouseenter' ∷ ∀msg. Maybe msg → Prop msg
onmouseenter' = on "mousenter" <<< always'

onmouseleave ∷ ∀msg. msg → Prop msg
onmouseleave = on "mouseleave" <<< always
onmouseleave' ∷ ∀msg. Maybe msg → Prop msg
onmouseleave' = on "mouseleave" <<< always'

onpointerup ∷ ∀msg. msg → Prop msg
onpointerup = on "pointerup" <<< always
onpointerup' ∷ ∀msg. Maybe msg → Prop msg
onpointerup' = on "pointerup" <<< always'

onpointerdown ∷ ∀msg. msg → Prop msg
onpointerdown = on "pointerdown" <<< always
onpointerdown' ∷ ∀msg. Maybe msg → Prop msg
onpointerdown' = on "pointerdown" <<< always'

onpointerenter ∷ ∀msg. msg → Prop msg
onpointerenter = on "pointerenter" <<< always
onpointerenter' ∷ ∀msg. Maybe msg → Prop msg
onpointerenter' = on "pointerenter" <<< always'

onpointerleave ∷ ∀msg. msg → Prop msg
onpointerleave = on "pointerleave" <<< always
onpointerleave' ∷ ∀msg. Maybe msg → Prop msg
onpointerleave' = on "pointerleave" <<< always'

-- | note: trigger preventDefault 
oncontextmenu ∷ ∀msg. msg → Prop msg
oncontextmenu msg = preventDefaultOn "contextmenu" $ always (Tuple (Just msg) true)

-- | note: trigger preventDefault 
oncontextmenu' ∷ ∀msg. (Maybe msg) → Prop msg
oncontextmenu' msg = preventDefaultOn "contextmenu" $ always (Tuple msg true)


onvaluechange ∷ ∀msg. (String → msg) → Prop msg
onvaluechange f = on "change" fn
    where
    fn ev =
        case Event.currentTarget ev >>= HTMLInput.fromEventTarget of
            Nothing → pure Nothing
            Just target → Just <$> f <$> HTMLInput.value target

onchecked ∷ ∀msg. (Boolean → msg) → Prop msg
onchecked f = on "change" fn
    where
    fn ev =
        case Event.currentTarget ev >>= HTMLInput.fromEventTarget of
            Nothing → pure Nothing
            Just target → Just <$> f <$> HTMLInput.checked target
