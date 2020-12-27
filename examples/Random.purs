module Example.Random where
import Prelude hiding (div)
import Data.Int (toNumber)
import Data.Array ((..), mapWithIndex)
import Data.Array.NonEmpty (NonEmptyArray, cons')
import Data.Maybe(Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Pha as H
import Pha.App (app)
import Pha.Elements as HH
import Pha.Events as E
import Pha.Util (pc)

data Card = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King
cards ∷ NonEmptyArray Card
cards = cons' Ace [Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King]

type State = {
    dice ∷ Int,
    puzzle ∷ Array Int,
    card ∷ Card
}

data Msg = RollDice | DrawCard | ShufflePuzzle

-- initial state
state ∷ State
state = {
    dice: 1,
    puzzle: 0 .. 15,
    card: Ace
}

update {modify} RollDice =
    modify \s -> s{dice = 4}
-- randomly \st → st{dice = _} <$> R.int 1 6
update _ DrawCard = pure unit
-- randomly \st →  st{card = _} <$> R.element cards
update _ ShufflePuzzle = pure unit 
--randomly \st → st{puzzle = _} <$> R.shuffle st.puzzle

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

view ∷ State → H.VDom Msg
view {dice, puzzle, card} =
        HH.div [] [
            HH.div [H.class' "counter" true] [H.text $ show dice],
            HH.button [E.onclick RollDice] [H.text "Roll dice"],

            HH.div [H.style "font-size" "12em" ] [H.text $ viewCard card],
            HH.button [E.onclick DrawCard] [H.text "Draw" ],

            H.keyed "div" [H.class_ "puzzle"] (
                puzzle # mapWithIndex \i j → show i /\
                    HH.div [
                        H.class' "puzzle-item" true,
                        H.style "left" $ pc (0.25 * toNumber (j / 4)),
                        H.style "top" $ pc (0.25 * toNumber (j `mod` 4)) 
                    ] [H.text $ show i]
            ),
            HH.button [E.onclick ShufflePuzzle] [H.text "Shuffle"]
        ]

main ∷ Effect Unit
main = app {
    init: {state, action: Just RollDice},
    view,
    update,
    subscriptions: const [],
    selector: "#root"
}
