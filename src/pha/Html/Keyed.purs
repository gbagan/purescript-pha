module Pha.Html.Keyed where

import Data.Tuple (Tuple)
import Pha.Html.Core (Html, Prop, keyed)

a ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
a = keyed "a"

button ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
button = keyed "button"

div ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
div = keyed "div"

footer ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
footer = keyed "footer"

form ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
form = keyed "form"

header ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
header = keyed "header"

li ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
li = keyed "li"

p ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
p = keyed "p"

main ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
main = keyed "main"

nav ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
nav = keyed "nav"

ol ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
ol = keyed "ol"

section ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
section = keyed "section"

span ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
span = keyed "span"

ul ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
ul = keyed "ul"


--- SVG

svg ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg)) → Html msg
svg = keyed "svg"

g ∷ ∀msg. Array (Prop msg) → Array (Tuple String (Html msg))→ Html msg
g = keyed "g"
