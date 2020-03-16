module Pha.Attributes where

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

