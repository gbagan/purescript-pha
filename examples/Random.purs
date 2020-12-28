module Example.Random where
import Prelude hiding (div)
import Data.Int (toNumber)
import Data.Array ((..), mapWithIndex, insertAt, foldl)
import Data.Array.NonEmpty (NonEmptyArray, cons')
import Data.Array.NonEmpty as N
import Data.Traversable (sequence)
import Data.Maybe(Maybe(..), fromMaybe)
import Data.Tuple.Nested ((/\))
import Effect.Random (randomInt)
import Effect (Effect)
import Pha as H
import Pha.App (app)
import Pha.Elements as HH
import Pha.Events as E
import Pha.Util (pc)


shuffle ∷ ∀a. Array a → Effect (Array a)
shuffle array = do
    rnds ← sequence $ array # mapWithIndex \i value → {value, index: _} <$> randomInt 0 i
    pure $ rnds # foldl (\t {value, index} → fromMaybe [] (insertAt index value t)) []



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

update {modify} RollDice = do
    n <- randomInt 1 6
    modify _{dice = n}
update {modify} DrawCard = do
    n <- randomInt 0 (N.length cards - 1)
    modify _{card = fromMaybe (N.head cards) (N.index cards n)}
update {get, modify} ShufflePuzzle = do
    p <- get <#> _.puzzle
    p2 <- shuffle p
    modify _{puzzle = p2}

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
