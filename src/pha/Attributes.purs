module Pha.Attributes where

import Prelude hiding (div)
import Pha (Prop, attr, on)
import Data.Maybe (Maybe(..))
import Pha.Event.Decoder (withDecoder, currentTargetChecked, currentTargetValue)

disabled :: ∀msg. Boolean -> Prop msg
disabled b = attr "disabled" (if b then "true" else "")

checked :: ∀msg. Boolean -> Prop msg
checked b = attr "checked" (if b then "true" else "")

href :: ∀msg. String -> Prop msg
href = attr "href"

src :: ∀msg. String -> Prop msg
src = attr "src"

value :: ∀msg. String -> Prop msg
value = attr "value"

always ∷ ∀ a msg. (a → msg) → a → Maybe msg
always = compose Just
    
always_ ∷ ∀ msg a. msg → a → Maybe msg
always_ = const <<< Just

-- onclick' :: ∀msg. (Event -> msg) -> Prop msg
-- onclick' = on "click"
    
onclick :: ∀msg. msg -> Prop msg
onclick = on "click" <<< always_
    
--oncontextmenu' :: ∀msg. (Event -> msg) -> Prop msg
-- oncontextmenu' = on "contextmenu"
    
-- onpointermove' :: ∀msg. (Event -> msg) -> Prop msg
-- onpointermove' = on "pointermove"
    
-- onpointerup' :: ∀msg. (Event -> msg) -> Prop msg
-- onpointerup' = on "pointerup" <<< Just
    
-- onpointerup :: ∀msg. msg -> Prop msg
-- onpointerup = onpointerup' <<< const
    
-- onpointerdown' :: ∀msg. (Event -> msg) -> Prop msg
-- onpointerdown' = on "pointerdown"
    
-- onpointerdown :: ∀msg. msg -> Prop msg
-- onpointerdown = onpointerdown' <<< const
    
-- onpointerenter' :: ∀msg. (Event -> msg) -> Prop msg
-- onpointerenter' = on "pointerenter"
    
-- onpointerenter :: ∀msg. msg -> Prop msg
--onpointerenter = onpointerenter' <<< const
    
-- onpointerleave' :: ∀msg. (Event -> msg) -> Prop msg
-- onpointerleave' = on "pointerleave"
    
-- onpointerleave :: ∀msg. msg -> Prop msg
-- onpointerleave = onpointerleave' <<< const
    
-- onchange' :: ∀msg. (Event -> msg) -> Prop msg
-- onchange' = on "change"

onvaluechange :: ∀msg. (String -> msg) -> Prop msg
onvaluechange handler = withDecoder currentTargetValue "change" (Just <<< handler)

onchecked :: ∀msg. (Boolean -> msg) -> Prop msg
onchecked handler = withDecoder currentTargetChecked "change" (Just <<< handler)
