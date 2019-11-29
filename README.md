# purescript-pha
Yet another Elm-like library based on Hyperapp and purescript-run

https://github.com/jorgebucaran/hyperapp

https://github.com/natefaubion/purescript-run

### Documentation
Documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-pha)

### Minimal example
```purescript
module Example.Counter where
import Prelude hiding (div)
import Effect (Effect)
import Pha (VDom, sandbox, text)
import Pha.Elements (div, span, button)
import Pha.Events (onclick)

type State = Int
data Msg = Increment | Decrement

init ∷ State
init = 0

update ∷ Msg → State → State
update Increment = (_ + 1)
update Decrement = (_ - 1)

view ∷ State → VDom Msg
view counter = 
    div []
    [   button [onclick Decrement] [text "-"]
    ,   span [] [text $ show counter]
    ,   button [onclick Increment] [text "-"]
    ]

main ∷ Effect Unit
main = sandbox {
    init,
    update,
    view,
    node: "root"
}
```

### Other examples

Counter2 (delayed action, raw events) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Counter2.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-counter2.html)

Randomness (+ animation) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Random.purs) |  [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-random.html)

Custom effects (+ svg, FFI) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/CustomEffect.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-customeffect.html)

Inputs (event effects, text and checkbox inputs) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Inputs.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-inputs.html)

Cats (HTTP, json) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Cats.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-cats.html)
