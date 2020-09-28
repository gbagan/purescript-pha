module Pha.Attributes where
import Prelude
import Pha (Prop, attr)

alt ∷ ∀msg. String → Prop msg
alt = attr "alt"

disabled ∷ ∀msg. Boolean → Prop msg
disabled b = attr "disabled" (if b then "true" else "")

checked ∷ ∀msg. Boolean → Prop msg
checked b = attr "checked" (if b then "true" else "")

href ∷ ∀msg. String → Prop msg
href = attr "href"

src ∷ ∀msg. String → Prop msg
src = attr "src"

value ∷ ∀msg. String → Prop msg
value = attr "value"

target ∷ ∀msg. String → Prop msg
target = attr "target"


-- SVG

x ∷ ∀msg. String → Prop msg
x = attr "x"
y ∷ ∀msg. String → Prop msg
y = attr "y"
x1 ∷ ∀msg. String → Prop msg
x1 = attr "x1"
y1 ∷ ∀msg. String → Prop msg
y1 = attr "y1"
x2 ∷ ∀msg. String → Prop msg
x2 = attr "x2"
y2 ∷ ∀msg. String → Prop msg
y2 = attr "y2"
cx ∷ ∀msg. String → Prop msg
cx = attr "cx"
cy ∷ ∀msg. String → Prop msg
cy = attr "cy"
r ∷ ∀msg. String → Prop msg
r = attr "r"

d ∷ ∀msg. String → Prop msg
d = attr "d"

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
viewBox a b c d2 = attr "viewBox" $ show a <> " " <> show b <> " " <> show c <> " " <> show d2
transform ∷ ∀msg. String → Prop msg
transform = attr "transform"
strokeWidth ∷ ∀msg. String → Prop msg
strokeWidth = attr "stroke-width"
strokeDasharray ∷ ∀msg. String → Prop msg
strokeDasharray = attr "stroke-dasharray"

