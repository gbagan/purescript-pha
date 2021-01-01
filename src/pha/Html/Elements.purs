module Pha.Html.Elements where

import Prelude
import Pha.Html.Core (Html, Prop, h, attr, text)

a ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
a = h "a"

br ∷ ∀msg. Html msg
br = h "br" [] []

button ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
button = h "button"

div ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
div = h "div"


footer ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
footer = h "footer"

form ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
form = h "form"

img ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
img = h "img"
    
h1 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h1 = h "h1"

h2 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h2 = h "h2"

h3 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h3 = h "h3"

h4 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h4 = h "h4"

h5 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h5 = h "h5"

h6 ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
h6 = h "h6"

header ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
header = h "header"

hr ∷ ∀msg. Array (Prop msg) → Html msg
hr attrs = h "hr" attrs []

input ∷ ∀msg. Array (Prop msg) → Html msg
input attrs = h "input" attrs []

label ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
label = h "label"

li ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
li = h "li"

p ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
p = h "p"

main ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
main = h "main"

nav ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
nav = h "nav"

ol ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
ol = h "ol"

section ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
section = h "section"

span ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
span = h "span"

ul ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
ul = h "ul"


--- SVG

svg ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
svg = h "svg"

g ∷ ∀msg. Array (Prop msg) → Array (Html msg) → Html msg
g = h "g"
        
rect ∷ ∀msg. Array (Prop msg) → Html msg
rect props = h "rect" props []
    
path ∷ ∀msg. Array (Prop msg) → Html msg
path props = h "path" props []
    
line ∷  ∀msg. Array (Prop msg) → Html msg
line props = h "line" props []
    
circle ∷ ∀msg. Array (Prop msg) → Html msg
circle props = h "circle" props []

use ∷ ∀msg. Array (Prop msg) → Html msg
use props = h "use" props []
    
text_ ∷ ∀msg. String → Array (Prop msg) → Html msg
text_ t props = h "text" props [text t]
