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

### Some projects using purescript-pha

- https://github.com/gbagan/valise-mam
- https://github.com/gbagan/subtract-machine
- https://github.com/gbagan/sudoku-solver
