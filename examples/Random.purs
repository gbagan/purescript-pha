module Example.Random where
import Prelude hiding (div)
import Data.Int (toNumber)
import Data.Maybe (Maybe(..))
import Data.Array ((..), mapWithIndex)
import Effect (Effect)
import Effect.Aff (Aff)
import Pha (Transition, purely, text, class', style, (/\))
import Pha.App (Document, app, attachTo)
import Pha.Effects.Random (Random, GenWrapper, wrapGen, randomInt, shuffle, sample, interpretGenerate)
import Pha.Elements (div, button)
import Pha.Events (onclick)
import Pha.Util (pc)

data Card = Ace | Two | Three | Four | Five | Six | Seven | Eight | Nine | Ten | Jack | Queen | King
cards :: Array Card
cards = [Ace, Two, Three, Four, Five, Six, Seven, Eight, Nine, Ten, Jack, Queen, King]

type Model = {
    dice ∷ Int,
    puzzle ∷ Array Int,
    card ∷ Card
}

data Msg = RollDice | DiceRolled Int | DrawCard | CardDrawn (Maybe Card) | ShufflePuzzle | Shuffled (Array Int)

-- effects used in this app
data Effs msg = Generate (GenWrapper msg)
generate :: forall a msg. Random a -> (a -> msg) -> Effs msg
generate rdata fmsg = Generate (wrapGen rdata fmsg)

-- initial state
imodel ∷ Model
imodel = {
    dice: 1,
    puzzle: 0 .. 15,
    card: Ace
}

update ∷ Model → Msg → Transition Model Msg Effs 
update model = case _ of
    RollDice -> model /\ [generate (randomInt 6) DiceRolled ]
    DiceRolled rolled -> purely model{dice = rolled}  
    DrawCard -> model /\ [generate (sample cards) CardDrawn]
    CardDrawn (Just drawn) -> purely model{card = drawn}
    CardDrawn Nothing -> purely model
    ShufflePuzzle -> model /\ [generate (shuffle model.puzzle) Shuffled]
    Shuffled p -> purely model{puzzle = p}

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

view ∷ Model → Document Msg
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

interpreter :: Effs Msg -> Aff Msg 
interpreter (Generate genWrap) = interpretGenerate genWrap

main ∷ Effect Unit
main = app {
    init: purely imodel,
    view,
    update,
    subscriptions: const [],
    interpreter
}
  # attachTo "root"