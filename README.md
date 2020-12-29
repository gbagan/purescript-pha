# purescript-pha
Elm-like library

### Documentation
Documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-pha)

### Minimal example
```purescript
module Example.Counter where
import Prelude hiding (div)
import Effect (Effect)
import Pha (VDom, text)
import Pha.App (sandbox)
import Pha.Elements as H
import Pha.Events as E

type State = Int
data Msg = Increment | Decrement

init ∷ State
init = 0

update ∷ Msg → State → State
update Increment n = n + 1
update Decrement n = n - 1

view ∷ State → VDom Msg
view counter = 
    H.div []
    [   H.button [E.onclick Decrement] [text "-"]
    ,   H.span [] [text $ show counter]
    ,   H.button [E.onclick Increment] [text "+"]
    ]

main ∷ Effect Unit
main = sandbox {init, update, view, selector: "#root"}
```

### Other examples

Counter2 (delayed action, raw events) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Counter2.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-counter2.html)

Randomness (+ animation) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Random.purs) |  [Demo](https://gbagan.github.io/purescript-pha//ex-random.html)

Decoder (decoding events) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Decoder.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-decoder.html)

Inputs (event effects, text and checkbox inputs) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Inputs.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-inputs.html)

Cats (HTTP, json) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Cats.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-cats.html)

Routing [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Routing.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-routing.html)
