# purescript-pha
A binding of hyperapp in Purescript


### Minimal example
```purescript
module Example.Main where
import Prelude
import Effect (Effect)
import Pha (VDom, app, text)
import Pha.Action (Action, setState)
import Pha.Html (div', button, click)

type State = {
    counter :: Int
}

state :: State
state = {
    counter: 1
}

increment :: Action State ()
increment = setState \{counter} -> {counter: counter + 1}

view :: State -> VDom State ()
view {counter} = 
    div' [] [
        div' [] [text $ show counter],
        button [click increment] [text "Increment"]
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
