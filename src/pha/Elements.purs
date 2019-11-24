module Pha.Elements where

import Prelude hiding (div)
import Pha (VDom, Prop, h, attr)

a :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
a = h "a"

br :: ∀a effs. VDom a effs
br = h "br" [] []

button :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
button = h "button"

div :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
div = h "div"

footer :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
footer = h "footer"

img :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
img = h "img"

input :: ∀a effs. String -> Array (Prop a effs) -> VDom a effs
input t props = h "input" ([attr "type" t] <> props) []
    
h1 :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
h1 = h "h1"

h2 :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
h2 = h "h2"

h3 :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
h3 = h "h3"

header :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
header = h "header"

li :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
li = h "li"

p :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
p = h "p"

main :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
main = h "main"

nav :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
nav = h "nav"

ol :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
ol = h "ol"

section :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
section = h "section"

span :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
span = h "span"

ul :: ∀a effs. Array (Prop a effs) -> Array (VDom a effs) -> VDom a effs
ul = h "ul"
