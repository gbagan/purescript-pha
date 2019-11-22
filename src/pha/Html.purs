module Pha.Html where

import Prelude
import Pha (VDom, Prop(..), h, text)
import Pha.Action (Action)

class EUnit a where toStr  :: a -> String
newtype Px a = Px a
newtype Percent a = Percent a

instance unittoStr :: EUnit String where toStr = identity
instance unitInt :: EUnit Int where toStr = show
instance unitNumber :: EUnit Number where toStr = show 
instance unitPx :: EUnit (Px Number) where toStr (Px x') = show x' <> "px"
instance unitPx2 :: EUnit (Px Int) where toStr (Px x') = show x' <> "px"    
instance unitPc :: EUnit (Percent Number) where toStr (Percent x') = show (100.0 * x') <> "%"

px :: ∀a. a -> Px a
px = Px
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
width :: ∀a effs u. EUnit u => u -> Prop a effs
width = attr "width"
height :: ∀a effs u. EUnit u => u -> Prop a effs
height = attr "height"
href :: ∀a effs. String -> Prop a effs
href = attr "href"

    -- svg
x :: ∀a effs u. EUnit u => u -> Prop a effs
x = attr "x"
y :: ∀a effs u. EUnit u => u -> Prop a effs
y = attr "y" 
stroke :: ∀a effs. String -> Prop a effs
stroke = attr "stroke"
opacity :: ∀a effs. String -> Prop a effs
opacity = attr "opacity"
fill :: ∀a effs. String -> Prop a effs
fill = attr "fill"
viewBox :: ∀a effs. Int -> Int -> Int -> Int -> Prop a effs
viewBox x1 x2 x3 x4 = attr "viewBox" $ show x1 <> " " <> show x2 <> " " <> show x3 <> " " <> show x4
transform :: ∀a effs. String -> Prop a effs
transform = attr "transform"
strokeWidth :: ∀a effs. String -> Prop a effs
strokeWidth = attr "stroke-width"
strokeDasharray :: ∀a effs. String -> Prop a effs
strokeDasharray = attr "stroke-dasharray"

g :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
g = h "g"

svg :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
svg = h "svg"

rect :: ∀a effs u1 u2 u3 u4. EUnit u1 => EUnit u2 => EUnit u3 => EUnit u4 => u1 -> u2 -> u3 -> u4 -> Array (Prop a effs) -> VDom a effs
rect x' y' w h' props = h "rect" ([attr "x" x', attr "y" y', attr "width" w, attr "height" h'] <> props) []

path :: ∀a effs. String -> Array (Prop a effs) -> VDom a effs
path d props = h "path" ([attr "d" d] <> props) []

line ::  ∀a effs u1 u2 u3 u4. EUnit u1 => EUnit u2 => EUnit u3 => EUnit u4 => u1 -> u2 -> u3 -> u4 -> Array (Prop a effs) -> VDom a effs
line x1 y1 x2 y2 props = h "line" ([attr "x1" x1, attr "y1" y1, attr "x2" x2, attr "y2" y2] <> props) []

circle :: ∀a effs. Number -> Number -> Number -> Array (Prop a effs) -> VDom a effs
circle cx cy r props = h "circle" ([attr "cx" $ show cx, attr "cy" $ show cy, attr "r" $ show r] <> props) []

use :: ∀a effs u1 u2 u3 u4. EUnit u1 => EUnit u2 => EUnit u3 => EUnit u4 =>
            u1 -> u2 -> u3 -> u4 -> String -> Array (Prop a effs) -> VDom a effs
use x' y' w h' href' props =
    h "use" ([attr "x" x', attr "y" y', attr "width" w, attr "height" h', attr "href" href'] <> props) []

text' :: ∀a effs u. EUnit u => u -> u -> String -> Array (Prop a effs) -> VDom a effs
text' x' y' t props = h "text" ([attr "x" x', attr "y" y'] <> props) [text t]

translate :: ∀u1 u2. EUnit u1 => EUnit u2 => u1 -> u2 -> String
translate x' y' = "translate(" <> toStr x' <> "," <> toStr y' <> ")"

svguse :: ∀a effs. String -> Array (Prop a effs) -> VDom a effs
svguse symbol props = svg ([width "100%", height "100%"]  <> props) [h "use" [attr "href" symbol] []]

rgbColor :: Int -> Int -> Int -> String
rgbColor r g' b = "rgb(" <> show r <> "," <> show g' <> "," <> show b <> ")"