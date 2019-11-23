# purescript-pha
Yet another Elm-like library based on Hyperapp and purescript-run

https://github.com/jorgebucaran/hyperapp

https://github.com/natefaubion/purescript-run

### Documentation
Documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-pha)

### Minimal example
```purescript
module Example.Main where
import Prelude
import Effect (Effect)
import Pha (VDom, app, text)
import Pha.Action (Action, setState)
import Pha.Html (div, button, onclick)

type State = Int

state :: State
state = 0

increment :: Action State ()
increment = setState (_ + 1)

view :: State -> VDom State ()
view counter = 
    div [] [
        div [] [text $ show counter],
        button [onclick increment] [text "Increment"]
    ]

main :: Effect Unit
main = app {
    state,
    view,
    init: pure unit,
    node: "root",
    events: [],
    effects: \_ -> pure unit
}
```

### Other examples

Counter2 (delayed action, raw events) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Counter2.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-counter2.html)

Randomness (+ animation) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Random.purs) |  [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-random.html)

Custom effects (+ svg, FFI) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/CustomEffect.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-customeffect.html)

Inputs (event effects, text and checkbox inputs) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Inputs.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-inputs.html)

Cats (HTTP, json) [Code](https://github.com/gbagan/purescript-pha/blob/master/examples/Cats.purs) | [HTML](http://htmlpreview.github.io/?https://github.com/gbagan/purescript-pha/blob/master/examples/dist/ex-cats.html)
