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
onClick handler = on "click" (pure <<< Just <<< handler <<< unsafeCoerce)

onPointerUp ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerUp handler = on "pointerup" (pure <<< Just <<< handler <<< unsafeCoerce)

onPointerDown ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerDown handler = on "pointerdown" (pure <<< Just <<< handler <<< unsafeCoerce)

onPointerEnter ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerEnter handler = on "pointerenter" (pure <<< Just <<< handler <<< unsafeCoerce)

onPointerLeave ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerLeave handler = on "pointerleave" (pure <<< Just <<< handler <<< unsafeCoerce)

onPointerOver ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerOver handler = on "pointerover" (pure <<< Just <<< handler <<< unsafeCoerce)

onPointerOut ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerOut handler = on "pointerout" (pure <<< Just <<< handler <<< unsafeCoerce)

onPointerMove ∷ ∀msg. (PointerEvent → msg) → Prop msg
onPointerMove handler = on "pointermove" (pure <<< Just <<< handler <<< unsafeCoerce)

onContextMenu ∷ ∀msg. (PointerEvent → msg) → Prop msg
onContextMenu handler = on "contextmenu" \ev → do
    Event.preventDefault ev
    pure $ Just $ handler $ unsafeCoerce ev

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
