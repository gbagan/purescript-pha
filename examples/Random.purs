module Example.Random where
import Prelude hiding (div)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.Array ((..), mapWithIndex)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Pha (text, class', style)
import Pha.App (Document, app, attachTo)
import Pha.Action (Action, getState, setState)
import Pha.Random (randomInt, shuffle, sample)
import Pha.Effects.Random (RNG, randomGenerate, interpretRng)
import Pha.Elements (div, button)
import Pha.Events (onclick)
import Pha.Util (pc)
import Run as Run

data Card = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King

type State = {
    dice ∷ Int,
    puzzle ∷ Array Int,
    card ∷ Card
}

data Msg = RollDice | DrawCard | ShufflePuzzle

-- effects used in this app
type EFFS = (rng ∷ RNG)

-- initial state
state ∷ State
state = {
    dice: 1,
    puzzle: 0 .. 15,
    card: Ace
}

update ∷ Msg → Action State EFFS

update RollDice = do
    rolled ← randomGenerate $ randomInt 6 <#> (_ + 1)
    setState _{dice = rolled}

update DrawCard = do
    drawn ← randomGenerate $ sample [Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King]
    case drawn of
        Just card → setState _{card = card}
        Nothing → pure unit

update ShufflePuzzle = do
    {puzzle} ← getState
    shuffled ← randomGenerate $ shuffle puzzle
    setState _{puzzle = shuffled}

viewCard ∷ Card → String
viewCard Ace   = "🂡"
viewCard Two   = "🂢"
viewCard Three = "🂣"
viewCard Four  = "🂤"
viewCard Five  = "🂥"
viewCard Six   = "🂦"
viewCard Seven = "🂧"
viewCard Eight = "🂨"
viewCard Nine  = "🂩"
viewCard Ten   = "🂪"
viewCard Jack  = "🂫"
viewCard Queen = "🂭"
viewCard King  = "🂮"

view ∷ State → Document Msg
view {dice, puzzle, card} = {
    title: "Randomness example",
    body:
        div [] [
            div [class' "counter" true] [text $ show dice],
            button [onclick RollDice] [text "Roll dice"],

            div [style "font-size" "12em" ] [ text $ viewCard card ],
            button [onclick DrawCard] [ text "Draw" ],

            div [class' "puzzle" true] (
                puzzle # mapWithIndex \i j →
                    div [
                        class' "puzzle-item" true,
                        style "left" $ pc (0.25 * toNumber (j / 4)),
                        style "top" $ pc (0.25 * toNumber (j `mod` 4)) 
                    ] [text $ show i]
            ),
            button [onclick ShufflePuzzle] [text "Shuffle"]
        ]
}

main ∷ Effect Unit
main = app {
    init: state /\ update RollDice,
    view,
    update,
    subscriptions: const [],
    interpreter: Run.match {
        rng: interpretRng
    }
} # attachTo "root"