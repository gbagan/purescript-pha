module Pha.Svg.Attributes where

import Prelude
import Pha.Html.Core (Prop, attr)

class IsLength :: Type → Constraint
class IsLength a where
  toString :: a → String

instance IsLength Int where
  toString = show

instance IsLength Number where
  toString = show

instance IsLength String where
  toString = identity


x ∷ ∀msg a. IsLength a => a → Prop msg
x = attr "x" <<< toString
y ∷ ∀msg a. IsLength a => a → Prop msg
y = attr "y" <<< toString
x1 ∷ ∀msg a. IsLength a => a → Prop msg
x1 = attr "x1" <<< toString
y1 ∷ ∀msg a. IsLength a => a → Prop msg
y1 = attr "y1" <<< toString
x2 ∷ ∀msg a. IsLength a => a → Prop msg
x2 = attr "x2" <<< toString
y2 ∷ ∀msg a. IsLength a => a → Prop msg
y2 = attr "y2" <<< toString
cx ∷ ∀msg a. IsLength a => a → Prop msg
cx = attr "cx" <<< toString
cy ∷ ∀msg a. IsLength a => a → Prop msg
cy = attr "cy" <<< toString
dx ∷ ∀msg a. IsLength a => a → Prop msg
dx = attr "dx" <<< toString
dy ∷ ∀msg a. IsLength a => a → Prop msg
dy = attr "dy" <<< toString
r ∷ ∀msg a. IsLength a => a → Prop msg
r = attr "r" <<< toString
rx ∷ ∀msg a. IsLength a => a → Prop msg
rx = attr "rx" <<< toString
ry ∷ ∀msg a. IsLength a => a → Prop msg
ry = attr "ry" <<< toString

clipPath ∷ ∀msg. String → Prop msg
clipPath = attr "clip-path"

d ∷ ∀msg. String → Prop msg
d = attr "d"

width ∷ ∀msg i. IsLength i => i → Prop msg
width i = attr "width" (toString i)

height ∷ ∀msg i. IsLength i => i → Prop msg
height i = attr "height" (toString i)

opacity ∷ ∀msg. Number → Prop msg
opacity = attr "opacity" <<< show

fill ∷ ∀msg. String → Prop msg
fill = attr "fill"

fillOpacity ∷ ∀msg. Number → Prop msg
fillOpacity = attr "fill-opacity" <<< show

fillRule ∷ ∀msg. String → Prop msg
fillRule = attr "fill-rule"

fontSize ∷ ∀msg a. IsLength a => a → Prop msg
fontSize = attr "font-size" <<< toString

offset ∷ ∀msg. String → Prop msg
offset = attr "offset"

patternTransform ∷ ∀msg. String → Prop msg
patternTransform = attr "pattern-transform"

patternUnits ∷ ∀msg. String → Prop msg
patternUnits = attr "pattern-units"

points ∷ ∀msg. String → Prop msg
points = attr "points"

viewBox ∷ ∀msg. Number → Number → Number → Number → Prop msg
viewBox a b c d2 = attr "viewBox" $ show a <> " " <> show b <> " " <> show c <> " " <> show d2

transform ∷ ∀msg. String → Prop msg
transform = attr "transform"

stopColor ∷ ∀msg. String → Prop msg
stopColor = attr "stop-color"

stroke ∷ ∀msg. String → Prop msg
stroke = attr "stroke"

strokeDasharray ∷ ∀msg. String → Prop msg
strokeDasharray = attr "stroke-dasharray"

strokeOpacity ∷ ∀msg. Number → Prop msg
strokeOpacity = attr "stroke-opacity" <<< show

strokeWidth ∷ ∀msg. Number → Prop msg
strokeWidth = attr "stroke-width" <<< show