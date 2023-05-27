module Pha.Html.Keyed where

import Pha.Html.Core (Html, KeyedHtml, Prop, keyed)

a ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
a = keyed "a"

button ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
button = keyed "button"

div ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
div = keyed "div"

footer ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
footer = keyed "footer"

form ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
form = keyed "form"

header ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
header = keyed "header"

li ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
li = keyed "li"

p ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
p = keyed "p"

main ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
main = keyed "main"

menu ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
menu = keyed "menu"

nav ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
nav = keyed "nav"

ol ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
ol = keyed "ol"

select ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
select = keyed "select"

section ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
section = keyed "section"

span ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
span = keyed "span"

ul ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
ul = keyed "ul"


--- SVG

svg ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
svg = keyed "svg"

g ∷ ∀msg. Array (Prop msg) → Array (KeyedHtml msg) → Html msg
g = keyed "g"
