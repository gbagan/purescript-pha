module Example.Main where
import Prelude
import Data.Int (even, toNumber)
import Data.Array ((..), mapWithIndex)
import Data.Lens (Lens', lens)
import Effect (Effect)
import Run (match)
import Pha (VDom, InterpretEffs, app, text)
import Pha.Action (Action, Event, getState, setState, 
                    DELAY, delay, delayEffect,
                    RNG, rngEffect)
import Pha.Lens (viewOver)
import Pha.Random (shuffle)
import Pha.Html (div', button, span, click, class', style, pc)

type State = {
    counter :: Int,
    puzzle :: Array Int
}

type EFFS = (delay :: DELAY, rng :: RNG)

state :: State
state = {
    counter: 0,
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


interpretEffects :: Event -> InterpretEffs EFFS
interpretEffects ev = match {
    delay: delayEffect,
    rng: rngEffect
}

main :: Effect Unit
main = app {
    state,
    view,
    init: pure unit,
    node: "root",
    events: [],
    effects: interpretEffects
}