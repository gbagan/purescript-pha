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

### More advanced example

```purescript
module Example.Main where
import Prelude
import Data.Int (even, toNumber)
import Data.Array ((..), mapWithIndex)
import Data.Lens (Lens', lens)
import Effect (Effect)
import Run (match)
import Pha (VDom, InterpretEffs, app, text, lazy)
import Pha.Action (Action, getState, setState, 
                    DELAY, delay, delayEffect,
                    RNG, rngEffect)
import Pha.Lens (viewOver)
import Pha.Random (shuffle)
import Pha.Html (div', button, span, click, class', style, pc)

type State = {
    counter :: Int,
    puzzle :: Array Int
}

-- effects used in this app
type EFFS = (delay :: DELAY, rng :: RNG)

-- initial state
state :: State
state = {
    counter: 1,
    puzzle: 0 .. 15
}

-- a lens is similar to purescript-map
_counter :: Lens' State Int
_counter = lens _.counter _{counter = _}

-- pure actions
increment :: forall effs. Action State effs
increment = setState \st@{counter} -> st{counter = counter + 1}

-- actions with effects
delayedIncrement :: forall effs. Action State (delay :: DELAY | effs)
delayedIncrement = delay 1000 *> increment

shufflePuzzle :: forall effs. Action State (rng :: RNG | effs)
shufflePuzzle = do
    {puzzle} <- getState
    shuffled <- shuffle puzzle
    setState _{puzzle = shuffled}

lazyView :: forall s r.  Int -> VDom s r 
lazyView i = div' [class' "counter" true] [text $ show i]

view :: State -> VDom State EFFS
view {counter, puzzle} = 
    div' [] [
        div' [class' "counter" true] [text $ show counter],
        button [click increment] [text "Increment"],
        button [click delayedIncrement] [text "Delayed Increment"],
        -- view over a lens
        viewOver _counter (
            button [click $ setState (_ + 1)] [text "Increment bis"]
        ),

        div' [] [
            span [] [text "green when counter is even"],
            div' [
                class' "box" true, 
                class' "even" (even counter)
            ] []
        ],

        lazy (counter/4) lazyView,

        div' [class' "puzzle" true] (
            puzzle # mapWithIndex \i j ->
                div' [
                    class' "puzzle-item" true,
                    style "left" $ pc (0.25 * toNumber (j / 4)),
                    style "top" $ pc (0.25 * toNumber (j `mod` 4)) 
                ] [text $ show i]
        ),
        button [click shufflePuzzle] [text "Shuffle"]
    ]

-- a mapping of each algebraic effect to a real effect
-- delayEffect and rngEffect are default mappings but we can use a mockup mapping for testing.
interpretEffects :: InterpretEffs EFFS
interpretEffects = match {
    delay: delayEffect,
    rng: rngEffect
}

main :: Effect Unit
main = app {
    state,           -- initial state
    view,            -- a mapping of the state to virtual dom
    init: pure unit, -- action triggered at the start of the app (no action here)
    node: "root",    -- the id of the root node of the app
    events: [],
    effects: interpretEffects
}
```
