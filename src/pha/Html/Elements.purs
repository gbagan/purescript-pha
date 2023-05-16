module Pha.Html.Elements where

import Pha.Html.Core (Html, Prop, elem)

a ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
a = elem "a"

br ∷ ∀msg. Html msg
br = elem "br" [] []

button ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
button = elem "button"

div ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
div = elem "div"


footer ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
footer = elem "footer"

form ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
form = elem "form"

img ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
img = elem "img"
    
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

input ∷ ∀msg. Array (Prop msg) → Html msg
input attrs = elem "input" attrs []

label ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
label = elem "label"

li ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
li = elem "li"

p ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
p = elem "p"

main ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
main = elem "main"

nav ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
nav = elem "nav"

ol ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
ol = elem "ol"

option ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
option = elem "option"

section ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
section = elem "section"

select ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
select = elem "select"

span ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
span = elem "span"

textarea ∷ ∀msg. Array (Prop msg) → Html msg
textarea attrs = elem "textarea" attrs []

ul ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
ul = elem "ul"


--- SVG

svg ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
svg = elem "svg"

circle ∷ ∀msg. Array (Prop msg) → Html msg
circle props = elem "circle" props []

ellipse ∷ ∀msg. Array (Prop msg) → Html msg
ellipse props = elem "ellipse" props []

g ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
g = elem "g"

image ∷ ∀msg. Array (Prop msg) → Html msg
image attrs = elem "image" attrs []

rect ∷ ∀msg. Array (Prop msg) → Html msg
rect props = elem "rect" props []
    
path ∷ ∀msg. Array (Prop msg) → Html msg
path props = elem "path" props []
    
line ∷  ∀msg. Array (Prop msg) → Html msg
line props = elem "line" props []

polygon ∷  ∀msg. Array (Prop msg) → Html msg
polygon props = elem "polygon" props []

polyline ∷  ∀msg. Array (Prop msg) → Html msg
polyline props = elem "polyline" props []

use ∷ ∀msg. Array (Prop msg) → Html msg
use props = elem "use" props []

-- | Create a SVG text element
text_ ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
text_ = elem "text"

textPath ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
textPath = elem "textPath"

tspan ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
tspan = elem "tspan"
