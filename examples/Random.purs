module Example.Random where
import Prelude hiding (div)
import Data.Int (toNumber)
import Data.Array ((..), mapWithIndex)
import Data.Array.NonEmpty (NonEmptyArray, cons')
import Effect (Effect)
import Pha (text, class', style, (/\))
import Pha.App (Document, app, attachTo)
import Pha.Update (Update)
import Pha.Random (randomInt, shuffle, sample)
import Pha.Effects.Random (RNG, randomly, interpretRng)
import Pha.Elements (div, button)
import Pha.Events (onclick)
import Pha.Util (pc)
import Run as Run

data Card = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King
cards ∷ NonEmptyArray Card
cards = cons' Ace [Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King]

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

update ∷ Msg → Update State EFFS

update RollDice = randomly \st → st{dice = _} <$> randomInt 1 6
update DrawCard = randomly \st →  st{card = _} <$> sample cards
update ShufflePuzzle = randomly \st → st{puzzle = _} <$> shuffle st.puzzle

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
