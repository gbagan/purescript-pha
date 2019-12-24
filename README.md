# purescript-pha
Elm-like library based on Hyperapp

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

update ∷ Msg → Model → Model
update Increment n = n + 1
update Decrement n = n - 1

view ∷ Model → VDom Msg
view counter = 
    div []
    [   button [onclick Decrement] [text "-"]
    ,   span [] [text $ show counter]
    ,   button [onclick Increment] [text "+"]
    ]

main ∷ Effect Unit
main = sandbox { init, update, view} # attachTo "root"
```

### Other examples

Counter2 (delayed action, raw events) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Counter2.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-counter2.html)

Randomness (+ animation) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Random.purs) |  [Demo](https://gbagan.github.io/purescript-pha//ex-random.html)

Decoder (decoding events) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Decoder.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-decoder.html)

Inputs (event effects, text and checkbox inputs) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Inputs.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-inputs.html)

Cats (HTTP, json) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Cats.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-cats.html)

Routing [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Routing.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-routing.html)
