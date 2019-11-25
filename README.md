# purescript-pha
Yet another Elm-like library based on Hyperapp and purescript-run

https://github.com/jorgebucaran/hyperapp

https://github.com/natefaubion/purescript-run

### Documentation
Documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-pha)

### Minimal example
```purescript
module Example.Main where
import Prelude hiding (div)
import Effect (Effect)
import Pha (VDom, app, text)
import Pha.Action (Action, setState)
import Pha.Elements (div, button)
import Pha.Events (onclick)

type State = Int

data Msg = Increment | Decrement

state :: State
state = 0

update :: Msg -> Action State ()
update Increment = setState (_ + 1)
update Decrement = setState (_ - 1)

view :: State -> VDom Msg
view counter = 
    div [] [
        div [] [text $ show counter],
        button [onclick Increment] [text "+"],
        button [onclick Decrement] [text "-"]
    ]

main :: Effect Unit
main = app {
    state,
    view,
    update,
    init: pure unit,
    node: "root",
    events: [],
    interpret: \_ -> pure unit
}
```

### Other examples

Counter2 (delayed action, raw events) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Counter2.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-counter2.html)

Randomness (+ animation) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Random.purs) |  [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-random.html)

Decoder (decoding events) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Decoder.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-decoder.html)

Inputs (event effects, text and checkbox inputs) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Inputs.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-inputs.html)

Cats (HTTP, json) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Cats.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-cats.html)
