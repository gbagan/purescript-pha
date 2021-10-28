module Pha.Html.Attributes where
import Prelude
import Pha.Html.Core (Prop, attr)
import Unsafe.Coerce (unsafeCoerce)

alt ∷ ∀msg. String → Prop msg
alt = attr "alt"

checked ∷ ∀msg. Boolean → Prop msg
checked b = attr "checked" (unsafeCoerce b)

cols ∷ ∀msg. Int → Prop msg
cols = attr "cols" <<< show

disabled ∷ ∀msg. Boolean → Prop msg
disabled b = attr "disabled" (unsafeCoerce b)

download ∷ ∀msg. String → Prop msg
download = attr "download"

hidden ∷ ∀msg. Boolean → Prop msg
hidden b = attr "hidden" (unsafeCoerce b)

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

placeholder ∷ ∀msg. String → Prop msg
placeholder = attr "placeholder"

readonly ∷ ∀msg. Boolean → Prop msg
readonly b = attr "selected" (unsafeCoerce b)

required ∷ ∀msg. Boolean → Prop msg
required b = attr "selected" (unsafeCoerce b)

rows ∷ ∀msg. Int → Prop msg
rows = attr "rows" <<< show

selected ∷ ∀msg. Boolean → Prop msg
selected b = attr "selected" (unsafeCoerce b)

size ∷ ∀msg. Int → Prop msg
size = attr "size" <<< show

src ∷ ∀msg. String → Prop msg
src = attr "src"

value ∷ ∀msg. String → Prop msg
value = attr "value"

target ∷ ∀msg. String → Prop msg
target = attr "target"

title ∷ ∀msg. String → Prop msg
title = attr "title"

type_ ∷ ∀msg. String → Prop msg
type_ = attr "type"

-- SVG

x ∷ ∀msg. Number → Prop msg
x = attr "x" <<< show
y ∷ ∀msg. Number → Prop msg
y = attr "y" <<< show
x1 ∷ ∀msg. Number → Prop msg
x1 = attr "x1" <<< show
y1 ∷ ∀msg. Number → Prop msg
y1 = attr "y1" <<< show
x2 ∷ ∀msg. Number → Prop msg
x2 = attr "x2" <<< show
y2 ∷ ∀msg. Number → Prop msg
y2 = attr "y2" <<< show
cx ∷ ∀msg. Number → Prop msg
cx = attr "cx" <<< show
cy ∷ ∀msg. Number → Prop msg
cy = attr "cy" <<< show
r ∷ ∀msg. Number → Prop msg
r = attr "r" <<< show
rx ∷ ∀msg. Number → Prop msg
rx = attr "rx" <<< show
ry ∷ ∀msg. Number → Prop msg
ry = attr "ry" <<< show

d ∷ ∀msg. String → Prop msg
d = attr "d"

width ∷ ∀msg. String → Prop msg
width = attr "width"
height ∷ ∀msg. String → Prop msg
height = attr "height"
stroke ∷ ∀msg. String → Prop msg
stroke = attr "stroke"
opacity ∷ ∀msg. Number → Prop msg
opacity = attr "opacity" <<< show
fill ∷ ∀msg. String → Prop msg
fill = attr "fill"
viewBox ∷ ∀msg. Int → Int → Int → Int → Prop msg
viewBox a b c d2 = attr "viewBox" $ show a <> " " <> show b <> " " <> show c <> " " <> show d2
transform ∷ ∀msg. String → Prop msg
transform = attr "transform"
strokeWidth ∷ ∀msg. Number → Prop msg
strokeWidth = attr "stroke-width" <<< show
strokeDasharray ∷ ∀msg. String → Prop msg
strokeDasharray = attr "stroke-dasharray"
