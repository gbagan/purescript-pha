module Pha.Svg where
import Prelude
import Pha (VDom, Prop, h, text, attr)

g :: ∀msg. Array (Prop msg) -> Array (VDom msg) -> VDom msg
g = h "g"
    
svg :: ∀msg. Array (Prop msg) -> Array (VDom msg) -> VDom msg
svg = h "svg"
    
rect :: ∀msg. Array (Prop msg) -> VDom msg
rect props = h "rect" props []
    
path :: ∀msg. String -> Array (Prop msg) -> VDom msg
path d props = h "path" ([attr "d" d] <> props) []
    
line ::  ∀msg. Array (Prop msg) -> VDom msg
line props = h "line"  props []
    
circle :: ∀msg. Array (Prop msg) -> VDom msg
circle props = h "circle" props []

use :: ∀msg. String -> Array (Prop msg) -> VDom msg
use ref props = h "use" ([attr "href" ref] <> props) []
    
text' :: ∀msg. String -> Array (Prop msg) -> VDom msg
text' t props = h "text" props [text t]

x_ :: ∀msg. String -> Prop msg
x_ = attr "x"
y_ :: ∀msg. String -> Prop msg
y_ = attr "y"
x1 :: ∀msg. String -> Prop msg
x1 = attr "x1"
y1 :: ∀msg. String -> Prop msg
y1 = attr "y1"
x2 :: ∀msg. String -> Prop msg
x2 = attr "x2"
y2 :: ∀msg. String -> Prop msg
y2 = attr "y2"
cx :: ∀msg. String -> Prop msg
cx = attr "cx"
cy :: ∀msg. String -> Prop msg
cy = attr "cy"
r :: ∀msg. String -> Prop msg
r = attr "r"

width :: ∀msg. String -> Prop msg
width = attr "width"
height :: ∀msg. String -> Prop msg
height = attr "height"
stroke :: ∀msg. String -> Prop msg
stroke = attr "stroke"
opacity :: ∀msg. String -> Prop msg
opacity = attr "opacity"
fill :: ∀msg. String -> Prop msg
fill = attr "fill"
viewBox :: ∀msg. Int -> Int -> Int -> Int -> Prop msg
viewBox a b c d = attr "viewBox" $ show a <> " " <> show b <> " " <> show c <> " " <> show d
transform :: ∀msg. String -> Prop msg
transform = attr "transform"
strokeWidth :: ∀msg. String -> Prop msg
strokeWidth = attr "stroke-width"
strokeDasharray :: ∀msg. String -> Prop msg
strokeDasharray = attr "stroke-dasharray"