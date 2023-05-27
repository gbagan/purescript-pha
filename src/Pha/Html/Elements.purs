module Pha.Html.Elements where

import Pha.Html.Core (Html, Prop, elem)

a ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
a = elem "a"

abbr ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
abbr = elem "abbr"

area ∷ ∀msg. Array (Prop msg) → Html msg
area attrs = elem "area" attrs []

article ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
article = elem "article"

aside ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
aside = elem "aside"

audio ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
audio = elem "audio"

b ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
b = elem "b"

br ∷ ∀msg. Html msg
br = elem "br" [] []

button ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
button = elem "button"

canvas ∷ ∀msg. Array (Prop msg) → Html msg
canvas attrs = elem "canvas" attrs []

div ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
div = elem "div"

em ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
em = elem "em"

footer ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
footer = elem "footer"

form ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
form = elem "form"
    
h1 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h1 = elem "h1"

h2 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h2 = elem "h2"

h3 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h3 = elem "h3"

h4 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h4 = elem "h4"

h5 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h5 = elem "h5"

h6 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h6 = elem "h6"

header ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
header = elem "header"

hr ∷ ∀msg. Array (Prop msg) → Html msg
hr attrs = elem "hr" attrs []

i ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
i = elem "i"

img ∷ ∀msg. Array (Prop msg) → Html msg
img attrs = elem "img" attrs []

input ∷ ∀msg. Array (Prop msg) → Html msg
input attrs = elem "input" attrs []

label ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
label = elem "label"

li ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
li = elem "li"

link ∷ ∀msg. Array (Prop msg) → Html msg
link attrs = elem "link" attrs []

main ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
main = elem "main"

menu ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
menu = elem "menu"

nav ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
nav = elem "nav"

ol ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
ol = elem "ol"

option ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
option = elem "option"

p ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
p = elem "p"

pre ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
pre = elem "pre"

section ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
section = elem "section"

select ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
select = elem "select"

span ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
span = elem "span"

table ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
table = elem "table"

td ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
td = elem "td"

textarea ∷ ∀msg. Array (Prop msg) → Html msg
textarea attrs = elem "textarea" attrs []

tr ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
tr = elem "tr"

ul ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
ul = elem "ul"
