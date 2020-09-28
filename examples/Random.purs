module Example.Random where
import Prelude hiding (div)
import Data.Int (toNumber)
import Data.Array ((..), mapWithIndex)
import Data.Array.NonEmpty (NonEmptyArray, cons')
import Effect (Effect)
import Pha ((/\))
import Pha as H
import Pha.App (Document, app, attachTo)
import Pha.Update (Update)
import Pha.Random as R
import Pha.Effects.Random (RNG, randomly, interpretRng)
import Pha.Elements as HH
import Pha.Events as E
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

update RollDice = randomly \st → st{dice = _} <$> R.int 1 6
update DrawCard = randomly \st →  st{card = _} <$> R.element cards
update ShufflePuzzle = randomly \st → st{puzzle = _} <$> R.shuffle st.puzzle

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
        HH.div [] [
            HH.div [H.class' "counter" true] [H.text $ show dice],
            HH.button [E.onclick RollDice] [H.text "Roll dice"],

            HH.div [H.style "font-size" "12em" ] [H.text $ viewCard card ],
            HH.button [E.onclick DrawCard] [H.text "Draw" ],

            HH.div [H.class' "puzzle" true] (
                puzzle # mapWithIndex \i j →
                    HH.div [
                        H.class' "puzzle-item" true,
                        H.style "left" $ pc (0.25 * toNumber (j / 4)),
                        H.style "top" $ pc (0.25 * toNumber (j `mod` 4)) 
                    ] [H.text $ show i]
            ),
            HH.button [E.onclick ShufflePuzzle] [H.text "Shuffle"]
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
