module Pha.Svg where
import Prelude
import Pha (VDom, Prop, h, text, attr)

g ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
g = h "g"
    
svg ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
svg = h "svg"
    
rect ∷ ∀msg. Array (Prop msg) → VDom msg
rect props = h "rect" props []
    
path ∷ ∀msg. Array (Prop msg) → VDom msg
path props = h "path" props []
    
line ∷  ∀msg. Array (Prop msg) → VDom msg
line props = h "line" props []
    
circle ∷ ∀msg. Array (Prop msg) → VDom msg
circle props = h "circle" props []

use ∷ ∀msg. Array (Prop msg) → VDom msg
use props = h "use" props []
    
text' ∷ ∀msg. String → Array (Prop msg) → VDom msg
text' t props = h "text" props [text t]

x_ ∷ ∀msg. String → Prop msg
x_ = attr "x"
y_ ∷ ∀msg. String → Prop msg
y_ = attr "y"
x1_ ∷ ∀msg. String → Prop msg
x1_ = attr "x1"
y1_ ∷ ∀msg. String → Prop msg
y1_ = attr "y1"
x2_ ∷ ∀msg. String → Prop msg
x2_ = attr "x2"
y2_ ∷ ∀msg. String → Prop msg
y2_ = attr "y2"
cx ∷ ∀msg. String → Prop msg
cx = attr "cx"
cy ∷ ∀msg. String → Prop msg
cy = attr "cy"
r_ ∷ ∀msg. String → Prop msg
r_ = attr "r"

d_ ∷ ∀msg. String → Prop msg
d_ = attr "d"

width ∷ ∀msg. String → Prop msg
width = attr "width"
height ∷ ∀msg. String → Prop msg
height = attr "height"
stroke ∷ ∀msg. String → Prop msg
stroke = attr "stroke"
opacity ∷ ∀msg. String → Prop msg
opacity = attr "opacity"
fill ∷ ∀msg. String → Prop msg
fill = attr "fill"
viewBox ∷ ∀msg. Int → Int → Int → Int → Prop msg
viewBox a b c d = attr "viewBox" $ show a <> " " <> show b <> " " <> show c <> " " <> show d
transform ∷ ∀msg. String → Prop msg
transform = attr "transform"
strokeWidth ∷ ∀msg. String → Prop msg
strokeWidth = attr "stroke-width"
strokeDasharray ∷ ∀msg. String → Prop msg
strokeDasharray = attr "stroke-dasharray"