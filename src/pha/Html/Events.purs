module Pha.Html.Events where

import Prelude hiding (div)
import Effect (Effect)
import Data.Maybe (Maybe(..))
import Unsafe.Coerce (unsafeCoerce)
import Web.Event.Event as Event
import Web.UIEvent.MouseEvent (MouseEvent)
import Web.UIEvent.MouseEvent as ME
import Web.PointerEvent (PointerEvent)
import Web.PointerEvent.PointerEvent as PE
import Web.HTML.HTMLInputElement as HTMLInput
import Pha.Html.Core (Prop, EventHandler, unsafeOnWithEffect)

always ∷ ∀ev msg. msg → ev → Effect (Maybe msg)
always msg _ = pure (pure msg)

always' ∷ ∀ev msg. msg → ev → Effect msg
always' msg _ = pure msg

on ∷ ∀msg. String → EventHandler msg → Prop msg
on = unsafeOnWithEffect

onClick ∷ ∀msg. (PointerEvent → msg) → Prop msg
onClick handler = on "click" \ev → pure $ Just $ handler $ unsafeCoerce ev

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


onPointerUp ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerUp handler = on "pointerup" \ev → pure $ handler <$> PE.fromEvent ev

onPointerDown ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerDown handler = on "pointerdown" \ev → pure $ handler <$> PE.fromEvent ev

onPointerEnter ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerEnter handler = on "pointerenter" \ev → pure $ handler <$> PE.fromEvent ev

onPointerLeave ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerLeave handler = on "pointerleave" \ev → pure $ handler <$> PE.fromEvent ev

onPointerMove ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerMove handler = on "pointermove" \ev → pure $ handler <$> PE.fromEvent ev

onContextMenu ∷ ∀msg. (PointerEvent → msg) → Prop msg
onContextMenu handler = on "contextmenu" \ev → do
    Event.preventDefault ev
    pure $ handler <$> PE.fromEvent ev

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
