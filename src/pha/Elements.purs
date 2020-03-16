module Pha.Elements where

import Prelude
import Pha (VDom, Prop, h, attr)

a ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
a = h "a"

br ∷ ∀msg. VDom msg
br = h "br" [] []

button ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
button = h "button"

div ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
div = h "div"

footer ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
footer = h "footer"

form ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
form = h "form"

img ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
img = h "img"

input ∷ ∀msg. String → Array (Prop msg) → VDom msg
input t props = h "input" ([attr "type" t] <> props) []
    
h1 ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
h1 = h "h1"

h2 ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
h2 = h "h2"

h3 ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
h3 = h "h3"

h4 ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
h4 = h "h4"

h5 ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
h5 = h "h5"

h6 ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
h6 = h "h6"

header ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
header = h "header"

hr ∷ ∀msg. Array (Prop msg) → VDom msg
hr attrs = h "hr" attrs []

li ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
li = h "li"

p ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
p = h "p"

main ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
main = h "main"

nav ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
nav = h "nav"

ol ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
ol = h "ol"

section ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
section = h "section"

span ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
span = h "span"

ul ∷ ∀msg. Array (Prop msg) → Array (VDom msg) → VDom msg
ul = h "ul"
