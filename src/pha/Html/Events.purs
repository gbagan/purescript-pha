module Pha.Html.Events
  ( on
  , onClick
  , onAuxClick
  , onContextMenu
  , onPointerDown
  , onPointerEnter
  , onPointerLeave
  , onPointerMove
  , onPointerOut
  , onPointerOver
  , onPointerUp
  , onBlur
  , onFocus
  , onFocusIn
  , onFocusOut
  , onChecked
  , onValueChange
  ) where

import Prelude hiding (div)

import Data.Maybe (Maybe(..))
import Effect.Uncurried (EffectFn3, runEffectFn3)
import Pha.Html.Core (Prop, EventHandler, unsafeOnWithEffect)
import Unsafe.Coerce (unsafeCoerce)
import Web.Event.Event (Event)
import Web.Event.Event as Event
import Web.Event.EventTarget (EventTarget)
import Web.HTML.HTMLInputElement as HTMLInput 
import Web.UIEvent.MouseEvent (MouseEvent)
import Web.PointerEvent (PointerEvent)
import Web.UIEvent.FocusEvent (FocusEvent)

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

onAuxClick ∷ ∀ msg. (MouseEvent → msg) → Prop msg
onAuxClick handler = on "auxclick" (pure <<< Just <<< handler <<< mouseCoerce)

onContextMenu ∷ ∀ msg. (MouseEvent → msg) → Prop msg
onContextMenu handler = on "contextmenu" (pure <<< Just <<< handler <<< mouseCoerce)


onPointerUp ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerUp handler = on "pointerup" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerDown ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerDown handler = on "pointerdown" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerEnter ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerEnter handler = on "pointerenter" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerLeave ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerLeave handler = on "pointerleave" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerOver ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerOver handler = on "pointerover" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerOut ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerOut handler = on "pointerout" (pure <<< Just <<< handler <<< pointerCoerce)

onPointerMove ∷ ∀ msg. (PointerEvent → msg) → Prop msg
onPointerMove handler = on "pointermove" (pure <<< Just <<< handler <<< pointerCoerce)


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
