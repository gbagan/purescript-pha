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

width ∷ ∀msg i. IsLength i => i → Prop msg
width i = attr "width" (toString i)
height ∷ ∀msg i. IsLength i => i → Prop msg
height i = attr "height" (toString i)
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
