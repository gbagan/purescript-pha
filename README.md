# purescript-pha
Yet another Elm-like library based on Hyperapp

https://github.com/jorgebucaran/hyperapp

### Documentation
Documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-pha)

### Minimal example
```purescript
module Example.Counter where
import Prelude hiding (div)
import Effect (Effect)
import Pha (VDom, text)
import Pha (sandbox, attachTo)
import Pha.Elements (div, span, button)
import Pha.Events (onclick)

type Model = Int
data Msg = Increment | Decrement

init ∷ Model
init = 0

update ∷ Model → Msg → Model
update n Increment = n + 1
update n Decrement = n - 1

view ∷ Model → VDom Msg
view counter = 
    div []
    [   button [onclick Decrement] [text "-"]
    ,   span [] [text $ show counter]
    ,   button [onclick Increment] [text "-"]
    ]

main ∷ Effect Unit
main = sandbox { init, update, view}
       # attachTo "root"
```

### Other examples

Counter2 (delayed action, raw events) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Counter2.purs) | [Demo](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-counter2.html)

Randomness (+ animation) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Random.purs) |  [Demo](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-random.html)

Decoder (decoding events) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Decoder.purs) | [Demo](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-decoder.html)

Inputs (event effects, text and checkbox inputs) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Inputs.purs) | [Demo](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-inputs.html)

Cats (HTTP, json) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Cats.purs) | [Demo](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-cats.html)
