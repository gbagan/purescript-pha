module Pha.Html.Attributes where
import Prelude
import Pha.Html.Core (Prop, attr, prop)

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

height ∷ ∀msg. Int → Prop msg
height = prop "height"

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

target ∷ ∀msg. String → Prop msg
target = attr "target"

title ∷ ∀msg. String → Prop msg
title = attr "title"

type_ ∷ ∀msg. String → Prop msg
type_ = attr "type"

value ∷ ∀msg. String → Prop msg
value = prop "value"

width ∷ ∀msg. Int → Prop msg
width = prop "width"