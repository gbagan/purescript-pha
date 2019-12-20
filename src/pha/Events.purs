module Pha.Events (onclick, onclick',
    onmouseup, onmouseup', onmousedown, onmousedown', onmouseenter, onmouseenter', onmouseleave, onmouseleave',
    onpointerup, onpointerup', onpointerdown, onpointerdown', onpointerenter, onpointerenter', onpointerleave, onpointerleave',
    oncontextmenu, oncontextmenu',
    onvaluechange, onchecked,
    on, on', custom, preventDefaultOn, stopPropagationOn, releasePointerCaptureOn) where

import Prelude hiding (div)
import Effect (Effect)
import Pha (Prop, Event, on_, unsafeOnWithEffect)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Pha.Events.Decoder (Decoder, always, currentTargetChecked, currentTargetValue)
import Foreign (unsafeToForeign)
import Data.Either (Either(..))
import Control.Monad.Except (runExcept)
import Web.Event.Event as E

on ∷ ∀msg. String → Decoder msg → Prop msg
on eventname decoder = on' eventname (decoder >>> map(Just))

on' ∷ ∀msg. String → Decoder (Maybe msg) → Prop msg
on' eventname decoder = on_ eventname handler where
    handler ev =
        case runExcept (decoder (unsafeToForeign ev)) of
            Right a → a
            _  → Nothing

foreign import setPointerCaptureE ∷ Event → Effect Unit
foreign import releasePointerCaptureE ∷ Event → Effect Unit

custom ∷ ∀msg. String → Decoder {message ∷ Maybe msg, stopPropagation ∷ Boolean, preventDefault ∷ Boolean} → Prop msg
custom eventname decoder = unsafeOnWithEffect eventname handler where
    handler ev =
        case runExcept (decoder (unsafeToForeign ev)) of
            Right {message, stopPropagation, preventDefault} →
                {   effect: do
                        when stopPropagation (E.stopPropagation ev)
                        when preventDefault (E.preventDefault ev)
                ,   msg: message
                }
            _  → {effect: pure unit, msg: Nothing}

preventDefaultOn ∷ ∀msg. String → Decoder (Tuple (Maybe msg) Boolean) → Prop msg
preventDefaultOn eventname decoder = custom eventname (decoder >>> map \(Tuple msg prev) → {
    message: msg,
    preventDefault: prev,
    stopPropagation: false
})

stopPropagationOn ∷ ∀msg. String → Decoder (Tuple (Maybe msg) Boolean) → Prop msg
stopPropagationOn eventname decoder = custom eventname (decoder >>> map \(Tuple msg stop) → {
    message: msg,
    preventDefault: false,
    stopPropagation: stop
})

releasePointerCaptureOn ∷ ∀msg. String → Decoder (Maybe msg) → Prop msg
releasePointerCaptureOn eventname decoder = unsafeOnWithEffect eventname handler where
    handler ev =
        case runExcept (decoder (unsafeToForeign ev)) of
            Right msg → {msg, effect: releasePointerCaptureE ev}
            _  → {effect: pure unit, msg: Nothing}

onclick ∷ ∀msg. msg → Prop msg
onclick = on "click" <<< always
onclick' ∷ ∀msg. Maybe msg → Prop msg
onclick' = on' "click" <<< always

onmouseup ∷ ∀msg. msg → Prop msg
onmouseup = on "mouseup" <<< always
onmouseup' ∷ ∀msg. Maybe msg → Prop msg
onmouseup' = on' "mouseup" <<< always

onmousedown ∷ ∀msg. msg → Prop msg
onmousedown = on "mousedown" <<< always
onmousedown' ∷ ∀msg. Maybe msg → Prop msg
onmousedown' = on' "mousedown" <<< always

onmouseenter ∷ ∀msg. msg → Prop msg
onmouseenter = on "mouseenter" <<< always
onmouseenter' ∷ ∀msg. Maybe msg → Prop msg
onmouseenter' = on' "mousenter" <<< always

onmouseleave ∷ ∀msg. msg → Prop msg
onmouseleave = on "mouseleave" <<< always
onmouseleave' ∷ ∀msg. Maybe msg → Prop msg
onmouseleave' = on' "mouseleave" <<< always

onpointerup ∷ ∀msg. msg → Prop msg
onpointerup = on "pointerup" <<< always
onpointerup' ∷ ∀msg. Maybe msg → Prop msg
onpointerup' = on' "pointerup" <<< always

onpointerdown ∷ ∀msg. msg → Prop msg
onpointerdown = on "pointerdown" <<< always
onpointerdown' ∷ ∀msg. Maybe msg → Prop msg
onpointerdown' = on' "pointerdown" <<< always

onpointerenter ∷ ∀msg. msg → Prop msg
onpointerenter = on "pointerenter" <<< always
onpointerenter' ∷ ∀msg. Maybe msg → Prop msg
onpointerenter' = on' "pointerenter" <<< always

onpointerleave ∷ ∀msg. msg → Prop msg
onpointerleave = on "pointerleave" <<< always
onpointerleave' ∷ ∀msg. Maybe msg → Prop msg
onpointerleave' = on' "pointerleave" <<< always

-- | note: trigger preventDefault 
oncontextmenu ∷ ∀msg. msg → Prop msg
oncontextmenu msg = preventDefaultOn "contextmenu" $ always (Tuple (Just msg) true)

-- | note: trigger preventDefault 
oncontextmenu' ∷ ∀msg. (Maybe msg) → Prop msg
oncontextmenu' msg = preventDefaultOn "contextmenu" $ always (Tuple msg true)

onvaluechange ∷ ∀msg. (String → msg) → Prop msg
onvaluechange f = on "change" (currentTargetValue >>> map f)

onchecked ∷ ∀msg. (Boolean → msg) → Prop msg
onchecked f = on "change" (currentTargetChecked >>> map f)
