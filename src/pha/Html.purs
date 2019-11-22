module Pha.Html where

import Prelude
import Pha (VDom, Prop(..), h, text)
import Pha.Action (Action)

class EUnit a where toStr  :: a -> String
newtype Pixel a = Pixel a
newtype Percent a = Percent a

instance unittoStr :: EUnit String where toStr = identity
instance unitInt :: EUnit Int where toStr = show
instance unitNumber :: EUnit Number where toStr = show 
instance unitPx :: EUnit (Pixel Number) where toStr (Pixel x') = show x' <> "px"
instance unitPx2 :: EUnit (Pixel Int) where toStr (Pixel x') = show x' <> "px"    
instance unitPc :: EUnit (Percent Number) where toStr (Percent x') = show (100.0 * x') <> "%"

px :: ∀a. a -> Pixel a
px = Pixel
pc :: ∀a. a -> Percent a
pc = Percent

key :: ∀a effs. String -> Prop a effs
key = Key

attr :: ∀a effs u. EUnit u  => String -> u -> Prop a effs
attr n x' = Attr n (toStr x')

class' :: ∀a effs. String -> Boolean -> Prop a effs
class' = Class

style :: ∀a effs u. EUnit u => String -> u -> Prop a effs
style n x' = Style n (toStr x')

click :: ∀a effs. Action a effs -> Prop a effs
click = Event "click"

contextmenu :: ∀a effs. Action a effs -> Prop a effs
contextmenu = Event "contextmenu"

pointermove :: ∀a effs. Action a effs -> Prop a effs
pointermove = Event "pointermove"

pointerup :: ∀a effs. Action a effs -> Prop a effs
pointerup = Event "pointerup"

pointerdown :: ∀a effs. Action a effs -> Prop a effs
pointerdown = Event "pointerdown"

pointerenter :: ∀a effs. Action a effs -> Prop a effs
pointerenter = Event "pointerenter"

pointerleave :: ∀a effs. Action a effs -> Prop a effs
pointerleave = Event "pointerleave"

keydown :: ∀a effs. Action a effs -> Prop a effs
keydown = Event "keydown"

-- elements

br :: ∀a effs. VDom a effs
br = h "br" [] []

button :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
button = h "button"

div' :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
div' = h "div"

span :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
span = h "span"

h1 :: ∀a effs. Array (Prop a effs) -> String -> VDom a effs
h1 props str = h "h1" props [text str]

h2 :: ∀a effs. Array (Prop a effs) -> String -> VDom a effs
h2 props str = h "h2" props [text str]

p :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
p = h "p"

a :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
a = h "a"

-- attributes

disabled :: ∀a effs. Boolean -> Prop a effs
disabled b = attr "disabled" (if b then "true" else "")

href :: ∀a effs. String -> Prop a effs
href = attr "href"

translate :: ∀u1 u2. EUnit u1 => EUnit u2 => u1 -> u2 -> String
translate x' y' = "translate(" <> toStr x' <> "," <> toStr y' <> ")"