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
strokeWidth ∷ ∀msg. String → Prop msg
strokeWidth = attr "stroke-width"
strokeDasharray ∷ ∀msg. String → Prop msg
strokeDasharray = attr "stroke-dasharray"

