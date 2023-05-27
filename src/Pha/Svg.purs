module Pha.Svg where

import Pha.Html.Core (Html, Prop, elem)

--- SVG

svg ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
svg = elem "svg"

circle ∷ ∀msg. Array (Prop msg) → Html msg
circle props = elem "circle" props []

clipPath ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
clipPath = elem "clipPath"

defs ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
defs = elem "defs"

ellipse ∷ ∀msg. Array (Prop msg) → Html msg
ellipse props = elem "ellipse" props []

foreignObject ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
foreignObject = elem "foreignObject"

g ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
g = elem "g"

image ∷ ∀msg. Array (Prop msg) → Html msg
image attrs = elem "image" attrs []

line ∷  ∀msg. Array (Prop msg) → Html msg
line props = elem "line" props []

linearGradient ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
linearGradient = elem "linearGradient"

path ∷ ∀msg. Array (Prop msg) → Html msg
path props = elem "path" props []

pattern ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
pattern = elem "pattern"

polygon ∷  ∀msg. Array (Prop msg) → Html msg
polygon props = elem "polygon" props []

polyline ∷  ∀msg. Array (Prop msg) → Html msg
polyline props = elem "polyline" props []

rect ∷ ∀msg. Array (Prop msg) → Html msg
rect props = elem "rect" props []

stop ∷ ∀msg. Array (Prop msg) → Html msg
stop props = elem "stop" props []

-- | Create a SVG text element
text ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
text = elem "text"

textPath ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
textPath = elem "textPath"

tspan ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
tspan = elem "tspan"

use ∷ ∀msg. Array (Prop msg) → Html msg
use props = elem "use" props []