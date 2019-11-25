module Pha.Events (onclick, onpointerup, onpointerdown, onpointerenter, onpointerleave, onvaluechange, onchecked, on, custom) where

import Prelude hiding (div)
import Effect (Effect)
import Pha (Prop, Event, on_, unsafeOnWithEffect)
import Data.Maybe (Maybe(..))
import Pha.Events.Decoder (Decoder, always, currentTargetChecked, currentTargetValue)
import Foreign (unsafeToForeign)
import Data.Either (Either(..))
import Control.Monad.Except (runExcept)

on :: ∀msg. String -> Decoder msg → Prop msg
on eventname decoder = on_ eventname handler where
    handler ev =
        case runExcept (decoder (unsafeToForeign ev)) of
            Right a → Just a
            _  → Nothing

foreign import stopPropagationE :: Event -> Effect Unit
foreign import preventDefaultE :: Event -> Effect Unit
foreign import setPointerCaptureE :: Event -> Effect Unit
foreign import releasePointerCaptureE :: Event -> Effect Unit

custom :: ∀msg. String -> Decoder {message :: Maybe msg, stopPropagation :: Boolean, preventDefault :: Boolean} -> Prop msg
custom eventname decoder = unsafeOnWithEffect eventname handler where
    handler ev =
        case runExcept (decoder (unsafeToForeign ev)) of
            Right {message, stopPropagation, preventDefault} ->
                {
                     effect: do
                        when stopPropagation (stopPropagationE ev)
                        when preventDefault (preventDefaultE ev)
                    ,
                     msg: message }
            _  → {effect: pure unit, msg: Nothing}
            

onclick :: ∀msg. msg -> Prop msg
onclick = on "click" <<< always

onpointerup :: ∀msg. msg -> Prop msg
onpointerup = on "pointerup" <<< always

onpointerdown :: ∀msg. msg -> Prop msg
onpointerdown = on "pointerdown" <<< always

onpointerenter :: ∀msg. msg -> Prop msg
onpointerenter = on "pointerenter" <<< always

onpointerleave :: ∀msg. msg -> Prop msg
onpointerleave = on "pointerleave" <<< always

onvaluechange :: ∀msg. (String -> msg) -> Prop msg
onvaluechange f = on "change" (currentTargetValue >>> map f)

onchecked :: ∀msg. (Boolean -> msg) -> Prop msg
onchecked f = on "change" (currentTargetChecked >>> map f)
