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

onClick ∷ ∀msg. (MouseEvent → msg) → Prop msg
onClick handler = on "click" \ev → pure $ handler <$> ME.fromEvent ev

onMouseUp ∷ ∀msg. (MouseEvent → msg) → Prop msg
onMouseUp handler = on "mouseup" \ev → pure $ handler <$> ME.fromEvent ev

onMouseDown ∷ ∀msg. (MouseEvent → msg) → Prop msg
onMouseDown handler = on "mousedown" \ev → pure $ handler <$> ME.fromEvent ev

onMouseEnter ∷ ∀msg. (MouseEvent → msg) → Prop msg
onMouseEnter handler = on "mouseenter" \ev → pure $ handler <$> ME.fromEvent ev

onMouseLeave ∷ ∀msg. (MouseEvent → msg) → Prop msg
onMouseLeave handler = on "mouseleave" \ev → pure $ handler <$> ME.fromEvent ev

onMouseMove ∷ ∀msg. (MouseEvent → msg) → Prop msg
onMouseMove handler = on "mousemove" \ev → pure $ handler <$> ME.fromEvent ev


onPointerUp ∷ ∀msg. (MouseEvent → msg) → Prop msg
onPointerUp handler = on "pointerup" \ev → pure $ handler <$> ME.fromEvent ev

onPointerDown ∷ ∀msg. (MouseEvent → msg) → Prop msg
onPointerDown handler = on "pointerdown" \ev → pure $ handler <$> ME.fromEvent ev

onPointerEnter ∷ ∀msg. (MouseEvent → msg) → Prop msg
onPointerEnter handler = on "pointerenter" \ev → pure $ handler <$> ME.fromEvent ev

onPointerLeave ∷ ∀msg. (MouseEvent → msg) → Prop msg
onPointerLeave handler = on "pointerleave" \ev → pure $ handler <$> ME.fromEvent ev

onPointerMove ∷ ∀msg. (MouseEvent → msg) → Prop msg
onPointerMove handler = on "pointermove" \ev → pure $ handler <$> ME.fromEvent ev

onContextMenu ∷ ∀msg. (MouseEvent → msg) → Prop msg
onContextMenu handler = on "contextmenu" \ev → pure $ handler <$> ME.fromEvent ev

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
