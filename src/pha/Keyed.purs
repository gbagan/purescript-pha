module Pha.Keyed where

import Data.Tuple (Tuple)
import Pha (VDom, Prop, keyed)

a ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
a = keyed "a"

button ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
button = keyed "button"

div ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
div = keyed "div"

footer ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
footer = keyed "footer"

form ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
form = keyed "form"

header ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
header = keyed "header"

li ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
li = keyed "li"

p ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
p = keyed "p"

main ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
main = keyed "main"

nav ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
nav = keyed "nav"

ol ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
ol = keyed "ol"

section ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
section = keyed "section"

span ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
span = keyed "span"

ul ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
ul = keyed "ul"


--- SVG

svg ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg
svg = keyed "svg"

g ∷ ∀msg. Array (Prop msg) → Array (Tuple String (VDom msg))→ VDom msg
g = keyed "g"
