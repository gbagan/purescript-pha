module Pha.Html.Events
  ( on
  , onClick
  , onClick'
  , onAuxClick
  , onContextMenu
  , onContextMenuPrevent
  , onPointerDown
  , onPointerDown'
  , onPointerEnter
  , onPointerEnter'
  , onPointerLeave
  , onPointerLeave'
  , onPointerMove
  , onPointerMove'
  , onPointerOut
  , onPointerOut'
  , onPointerOver
  , onPointerOver'
  , onPointerUp
  , onPointerUp'
  , onBlur
  , onFocus
  , onFocusIn
    , onFocusOut
  , onChecked
  , onValueChange
  ) where

import Prelude hiding (div)

import Data.Maybe (Maybe(..))
import Effect (Effect)
import Effect.Uncurried (EffectFn3, runEffectFn3)
import Pha.Html.Core (Prop, EventHandler, unsafeOnWithEffect)
import Unsafe.Coerce (unsafeCoerce)
import Web.Event.Event (Event)
import Web.Event.Event as Event
import Web.Event.EventTarget (EventTarget)  
import Web.HTML.HTMLInputElement as HTMLInput
import Web.PointerEvent (PointerEvent)
import Web.UIEvent.FocusEvent (FocusEvent)
import Web.UIEvent.MouseEvent (MouseEvent)

on ∷ ∀ msg. String → EventHandler msg → Prop msg
on = unsafeOnWithEffect

mouseCoerce ∷ Event → MouseEvent
mouseCoerce = unsafeCoerce

pointerCoerce ∷ Event → PointerEvent
pointerCoerce = unsafeCoerce

focusCoerce ∷ Event → FocusEvent
focusCoerce = unsafeCoerce

onClick ∷ ∀ msg. (MouseEvent → msg) → Prop msg
onClick handler = on "click" (pure <<< Just <<< handler <<< mouseCoerce)

onClick' ∷ ∀ msg. (MouseEvent → Effect (Maybe msg)) → Prop msg
onClick' handler = on "click" (handler <<< mouseCoerce)

onAuxClick ∷ ∀ msg. (MouseEvent → msg) → Prop msg
onAuxClick handler = on "auxclick" (pure <<< Just <<< handler <<< mouseCoerce)

onContextMenu ∷ ∀ msg. (MouseEvent → msg) → Prop msg
onContextMenu handler = on "contextmenu" (pure <<< Just <<< handler <<< mouseCoerce)

onContextMenuPrevent ∷ ∀ msg. (MouseEvent → msg)  → Prop msg
onContextMenuPrevent handler = on "contextmenu" \ev → do
  Event.preventDefault ev
  pure <<< Just <<< handler <<< mouseCoerce $ ev

onPointerUp ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerUp handler = on "pointerup" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerUp' ∷ ∀ msg. (PointerEvent → Effect (Maybe msg)) → Prop msg
onPointerUp' handler = on "pointerup" (handler <<< pointerCoerce)

onPointerDown ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerDown handler = on "pointerdown" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerDown' ∷ ∀ msg. (PointerEvent → Effect (Maybe msg)) → Prop msg
onPointerDown' handler = on "pointerdown" (handler <<< pointerCoerce)

onPointerEnter ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerEnter handler = on "pointerenter" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerEnter' ∷ ∀ msg. (PointerEvent → Effect (Maybe msg)) → Prop msg
onPointerEnter' handler = on "pointerenter" (handler <<< pointerCoerce)

onPointerLeave ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerLeave handler = on "pointerleave" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerLeave' ∷ ∀ msg. (PointerEvent → Effect (Maybe msg)) → Prop msg
onPointerLeave' handler = on "pointerleave" (handler <<< pointerCoerce)

onPointerOver ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerOver handler = on "pointerover" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerOver' ∷ ∀ msg. (PointerEvent → Effect (Maybe msg)) → Prop msg
onPointerOver' handler = on "pointerover" (handler <<< pointerCoerce)

onPointerOut ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerOut handler = on "pointerout" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerOut' ∷ ∀ msg. (PointerEvent → Effect (Maybe msg)) → Prop msg
onPointerOut' handler = on "pointerout" (handler <<< pointerCoerce)

onPointerMove ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerMove handler = on "pointermove" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerMove' ∷ ∀ msg. (PointerEvent → Effect (Maybe msg)) → Prop msg
onPointerMove' handler = on "pointermove" (handler <<< pointerCoerce)


onBlur ∷ ∀ msg. (FocusEvent → msg) → Prop msg
onBlur handler = on "blur" (pure <<< Just <<< handler <<< focusCoerce)

onFocus ∷ ∀ msg. (FocusEvent → msg) → Prop msg
onFocus handler = on "focus" (pure <<< Just <<< handler <<< focusCoerce)

onFocusIn ∷ ∀ msg. (FocusEvent → msg) → Prop msg
onFocusIn handler = on "focusin" (pure <<< Just <<< handler <<< focusCoerce)

onFocusOut ∷ ∀ msg. (FocusEvent → msg) → Prop msg
onFocusOut handler = on "focusout" (pure <<< Just <<< handler <<< focusCoerce)

foreign import valueImpl :: ∀ a. EffectFn3 EventTarget (Maybe a) (a -> Maybe a) (Maybe String)

onValueChange ∷ ∀ msg. (String → msg) → Prop msg
onValueChange f = on "change" fn
  where
  fn ev =
    case Event.currentTarget ev of
      Just target → map f <$> runEffectFn3 valueImpl target Nothing Just
      Nothing → pure Nothing

onChecked ∷ ∀ msg. (Boolean → msg) → Prop msg
onChecked f = on "change" fn
  where
  fn ev =
    case Event.currentTarget ev >>= HTMLInput.fromEventTarget of
      Nothing → pure Nothing
      Just target → Just <$> f <$> HTMLInput.checked target
