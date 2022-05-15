# purescript-pha
a simple and fast Elm-like library based on [Superfine](https://github.com/jorgebucaran/superfine)

### Documentation
Documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-pha)

### Minimal example
```purescript
module Example.Counter where
import Prelude
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
    [   H.button [E.onClick Decrement] [text "-"]
    ,   H.span [] [text $ show counter]
    ,   H.button [E.onClick Increment] [text "+"]
    ]

main ∷ Effect Unit
main = sandbox {init, update, view, selector: "#root"}
```

### Other examples

Randomness (+ animation) [Code](https://github.com/gbagan/purescript-pha-examples/blob/master/src/Random.purs) |  [Demo](https://gbagan.github.io/purescript-pha//ex-random.html)

Inputs (event effects, text and checkbox inputs) [Code](https://github.com/gbagan/purescript-pha-examples/blob/master/src/Inputs.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-inputs.html)

Cats (HTTP, json) [Code](https://github.com/gbagan/purescript-pha-examples/blob/master/src/Cats.purs) | [Demo](https://gbagan.github.io/purescript-pha//ex-cats.html)
