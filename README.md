# purescript-pha
a simple and fast Elm-like library based on [Superfine](https://github.com/jorgebucaran/superfine)

### Documentation
Documentation is [published on Pursuit](https://pursuit.purescript.org/packages/purescript-pha)

### Minimal example
```purescript
module Example.Counter where
import Prelude
import Effect (Effect)
import Pha.App (sandbox)
import Pha.Html (Html)
import Pha.Html as H
import Pha.Html.Attributes as P
import Pha.Html.Events as E

type State = Int
data Msg = Increment | Decrement

init ∷ State
init = 0

update ∷ Msg → State → State
update Increment n = n + 1
update Decrement n = n - 1

view ∷ State → Html Msg
view counter = 
  H.div []
    [ H.button [E.onClick \_ → Decrement] [H.text "-"]
    , H.span [] [H.text $ show counter]
    , H.button [E.onClick \_ → Increment] [H.text "+"]
    ]

main ∷ Effect Unit
main = sandbox {init, update, view, selector: "#root"}
```

### Example with side effects
```purescript
module Example.Counter where
import Prelude
import Effect (Effect)
import Effect.Aff (Aff)
import Effect.Class (liftEffect)
import Effect.Random (randomInt)
import Pha.App (app)
import Pha.Html (Html)
import Pha.Html as H
import Pha.Html.Attributes as P
import Pha.Html.Events as E
import Pha.Update (Update, put)

type Model = Int
data Msg = RollDice

update ∷ Msg → Update Model Msg Aff Unit
update RollDice = put =<< liftEffect (randomInt 1 6)

view ∷ State → Html Msg
view dice = 
  H.div []
    [ H.button [E.onClick \_ → RollDice] [H.text "Roll dice"]
    , H.span [] [H.text $ show dice]
    ]

main ∷ Effect Unit
main =
  app
    { init: { model: 0, msg: Just RollDice }
    , view
    , update
    , selector: "#root"
    }
```

### More examples

https://github.com/gbagan/purescript-pha-examples/tree/master/src

### Some projects using purescript-pha

- https://github.com/gbagan/valise-mam
- https://github.com/gbagan/subtract-machine
- https://github.com/gbagan/neuron
- https://github.com/gbagan/graphparams
- https://github.com/gbagan/sudoku-solver
