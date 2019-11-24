module Pha.Svg where
import Prelude
import Pha (VDom, Prop, h, text, attr)

g :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
g = h "g"
    
svg :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
svg = h "svg"
    
rect :: ∀a effs. Array (Prop a effs) -> VDom a effs
rect props = h "rect" props []
    
path :: ∀a effs. String -> Array (Prop a effs) -> VDom a effs
path d props = h "path" ([attr "d" d] <> props) []
    
line ::  ∀a effs. Array (Prop a effs) -> VDom a effs
line props = h "line"  props []
    
circle :: ∀a effs. Array (Prop a effs) -> VDom a effs
circle props = h "circle" props []

use :: ∀a effs. String -> Array (Prop a effs) -> VDom a effs
use ref props = h "use" ([attr "href" ref] <> props) []
    
text' :: ∀a effs. String -> Array (Prop a effs) -> VDom a effs
text' t props = h "text" props [text t]

x :: ∀a effs. String -> Prop a effs
x = attr "x"
y :: ∀a effs. String -> Prop a effs
y = attr "y"
x1 :: ∀a effs. String -> Prop a effs
x1 = attr "x1"
y1 :: ∀a effs. String -> Prop a effs
y1 = attr "y1"
x2 :: ∀a effs. String -> Prop a effs
x2 = attr "x2"
y2 :: ∀a effs. String -> Prop a effs
y2 = attr "y2"
cx :: ∀a effs. String -> Prop a effs
cx = attr "cx"
cy :: ∀a effs. String -> Prop a effs
cy = attr "cy"
r :: ∀a effs. String -> Prop a effs
r = attr "r"

width :: ∀a effs. String -> Prop a effs
width = attr "width"
height :: ∀a effs. String -> Prop a effs
height = attr "height"
stroke :: ∀a effs. String -> Prop a effs
stroke = attr "stroke"
opacity :: ∀a effs. String -> Prop a effs
opacity = attr "opacity"
fill :: ∀a effs. String -> Prop a effs
fill = attr "fill"
viewBox :: ∀a effs. Int -> Int -> Int -> Int -> Prop a effs
viewBox a b c d = attr "viewBox" $ show a <> " " <> show b <> " " <> show c <> " " <> show d
transform :: ∀a effs. String -> Prop a effs
transform = attr "transform"
strokeWidth :: ∀a effs. String -> Prop a effs
strokeWidth = attr "stroke-width"
strokeDasharray :: ∀a effs. String -> Prop a effs
strokeDasharray = attr "stroke-dasharray"