module Example.Random where
import Prelude
import Data.Int (toNumber)
import Data.Array ((..), mapWithIndex)
import Effect (Effect)
import Run (match)
import Pha (VDom, app, text)
import Pha.Action (Action, getState, setState, RNG, rngEffect)
import Pha.Random (randomInt, shuffle)
import Pha.Html (div', button, onclick, class', style, pc)

type State = {
    dice :: Int,
    puzzle :: Array Int
}

-- effects used in this app
type EFFS = (rng :: RNG)

-- initial effects
state :: State
state = {
    dice: 1,
    puzzle: 0 .. 15
}

rollDice :: forall effs. Action State (rng :: RNG | effs)
rollDice = do
    rolled <- randomInt 6 <#> (_ + 1)
    setState _{dice = rolled}

shufflePuzzle :: forall effs. Action State (rng :: RNG | effs)
shufflePuzzle = do
    {puzzle} <- getState
    shuffled <- shuffle puzzle
    setState _{puzzle = shuffled}

view :: State -> VDom State EFFS
view {dice, puzzle} = 
    div' [] [
        div' [class' "counter" true] [text $ show dice],
        button [onclick rollDice] [text "Roll dice"],

        div' [class' "puzzle" true] (
            puzzle # mapWithIndex \i j ->
                div' [
                    class' "puzzle-item" true,
                    style "left" $ pc (0.25 * toNumber (j / 4)),
                    style "top" $ pc (0.25 * toNumber (j `mod` 4)) 
                ] [text $ show i]
        ),
        button [onclick shufflePuzzle] [text "Shuffle"]
    ]

main :: Effect Unit
main = app {
    state,
    view,
    init: rollDice,
    node: "root",
    events: [],
    effects: match {
        rng: rngEffect
    }
}