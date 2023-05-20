module Pha.Html.Attributes where
import Prelude
import Pha.Html.Core (Prop, attr, prop)

class IsLength :: Type → Constraint
class IsLength a where
  toString :: a → String

instance IsLength Int where
  toString = show

instance IsLength Number where
  toString = show

instance IsLength String where
  toString = identity


action ∷ ∀msg. String → Prop msg
action = attr "action"

alt ∷ ∀msg. String → Prop msg
alt = attr "alt"

charset ∷ ∀msg. String → Prop msg
charset = attr "charset"

checked ∷ ∀msg. Boolean → Prop msg
checked b = prop "checked" b

cols ∷ ∀msg. Int → Prop msg
cols = attr "cols" <<< show

colSpan  ∷ ∀msg. Int → Prop msg
colSpan = attr "colSpan" <<< show

disabled ∷ ∀msg. Boolean → Prop msg
disabled b = prop "disabled" b

download ∷ ∀msg. String → Prop msg
download = attr "download"

hidden ∷ ∀msg. Boolean → Prop msg
hidden b = prop "hidden" b

href ∷ ∀msg. String → Prop msg
href = attr "href"

id ∷ ∀msg. String → Prop msg
id = attr "id"

max ∷ ∀msg. Int → Prop msg
max = attr "max" <<< show

maxlength ∷ ∀msg. Int → Prop msg
maxlength = attr "maxlength" <<< show

min ∷ ∀msg. Int → Prop msg
min = attr "min" <<< show

minlength ∷ ∀msg. Int → Prop msg
minlength = attr "minlength" <<< show

name ∷ ∀msg. String → Prop msg
name = attr "name"

placeholder ∷ ∀msg. String → Prop msg
placeholder = attr "placeholder"

readonly ∷ ∀msg. Boolean → Prop msg
readonly b = prop "selected" b

rel ∷ ∀msg. String → Prop msg
rel = attr "rel"


required ∷ ∀msg. Boolean → Prop msg
required b = prop "selected" b

rows ∷ ∀msg. Int → Prop msg
rows = attr "rows" <<< show

rowSpan  ∷ ∀msg. Int → Prop msg
rowSpan = attr "rowSpan" <<< show

selected ∷ ∀msg. Boolean → Prop msg
selected b = prop "selected" b

size ∷ ∀msg. Int → Prop msg
size = attr "size" <<< show

src ∷ ∀msg. String → Prop msg
src = attr "src"

value ∷ ∀msg. String → Prop msg
value = prop "value"

target ∷ ∀msg. String → Prop msg
target = attr "target"

title ∷ ∀msg. String → Prop msg
title = attr "title"

type_ ∷ ∀msg. String → Prop msg
type_ = attr "type"

-- SVG

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

fontSize ∷ ∀msg a. IsLength a => a → Prop msg
fontSize = attr "font-size" <<< toString

points ∷ ∀msg. String → Prop msg
points = attr "points"

viewBox ∷ ∀msg. Int → Int → Int → Int → Prop msg
viewBox a b c d2 = attr "viewBox" $ show a <> " " <> show b <> " " <> show c <> " " <> show d2

transform ∷ ∀msg. String → Prop msg
transform = attr "transform"

stroke ∷ ∀msg. String → Prop msg
stroke = attr "stroke"

strokeDasharray ∷ ∀msg. String → Prop msg
strokeDasharray = attr "stroke-dasharray"

strokeOpacity ∷ ∀msg. Number → Prop msg
strokeOpacity = attr "stroke-opacity" <<< show

strokeWidth ∷ ∀msg. Number → Prop msg
strokeWidth = attr "stroke-width" <<< show