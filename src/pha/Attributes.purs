module Pha.Attributes where

import Prelude hiding (div)
import Pha (Prop, Event, attr, on)
import Pha.Action (Action)


disabled :: ∀a effs. Boolean -> Prop a effs
disabled b = attr "disabled" (if b then "true" else "")

checked :: ∀a effs. Boolean -> Prop a effs
checked b = attr "checked" (if b then "true" else "")

href :: ∀a effs. String -> Prop a effs
href = attr "href"

src :: ∀a effs. String -> Prop a effs
src = attr "src"

value :: ∀a effs. String -> Prop a effs
value = attr "value"

onclick' :: ∀a effs. (Event -> Action a effs) -> Prop a effs
onclick' = on "click"
    
onclick :: ∀a effs. Action a effs -> Prop a effs
onclick = onclick' <<< const
    
oncontextmenu' :: ∀a effs. (Event -> Action a effs) -> Prop a effs
oncontextmenu' = on "contextmenu"
    
onpointermove' :: ∀a effs. (Event -> Action a effs) -> Prop a effs
onpointermove' = on "pointermove"
    
onpointerup' :: ∀a effs. (Event -> Action a effs) -> Prop a effs
onpointerup' = on "pointerup"
    
onpointerup :: ∀a effs. Action a effs -> Prop a effs
onpointerup = onpointerup' <<< const
    
onpointerdown' :: ∀a effs. (Event -> Action a effs) -> Prop a effs
onpointerdown' = on "pointerdown"
    
onpointerdown :: ∀a effs. Action a effs -> Prop a effs
onpointerdown = onpointerdown' <<< const
    
onpointerenter' :: ∀a effs. (Event -> Action a effs) -> Prop a effs
onpointerenter' = on "pointerenter"
    
onpointerenter :: ∀a effs. Action a effs -> Prop a effs
onpointerenter = onpointerenter' <<< const
    
onpointerleave' :: ∀a effs. (Event -> Action a effs) -> Prop a effs
onpointerleave' = on "pointerleave"
    
onpointerleave :: ∀a effs. Action a effs -> Prop a effs
onpointerleave = onpointerleave' <<< const
    
onchange' :: ∀a effs. (Event -> Action a effs) -> Prop a effs
onchange' = on "change"