module Example.Counter2 where
import Prelude hiding (div)
import Data.Int (even)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Pha (text, class_, class', purely, Transition)
import Pha.App (app, attachTo, Document)
import Pha.Effects.Delay (interpretDelay)
import Pha.Subs as Subs
import Pha.Elements (div, button, span)
import Pha.Events (onclick)

type Model = {
    counter ∷ Int
}

data Effs msg = Delay Int msg

-- initial model
imodel ∷ Model
imodel = {
    counter: 0
}

data Msg = Increment | DelayedIncrement

update ∷ Model → Msg → Transition Model Msg Effs
update model Increment = purely $ {counter: model.counter + 1}
update model DelayedIncrement = model /\ [Delay 100 Increment]

view ∷ Model → Document Msg
view {counter} = {
    title: "Counter example",
    body:
        div []
        [   div [class_ "counter"] [text $ show counter]
        ,       button [onclick Increment] [text "Increment"]
        ,       button [onclick DelayedIncrement] [text "Delayed Increment"]

        ,   div []
            [   span [] [text "green when the counter is even"]
            ,   div
                [   class_ "box"
                ,   class' "even" (even counter)
                ] []
            ]

        ,   div [] [
                text "press C to increment the counter"
            ]
        ]
}

keyDownHandler ∷ String → Maybe Msg
keyDownHandler "c" = Just Increment
keyDownHandler _ = Nothing


interpreter :: Effs Msg -> Aff Msg 
interpreter (Delay n msg) = interpretDelay n msg

main ∷ Effect Unit
main = app {
    init: purely imodel,
    view,
    update,
    subscriptions: const [Subs.onKeyDown keyDownHandler],
    interpreter
}
  # attachTo "root"