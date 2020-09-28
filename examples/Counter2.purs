module Example.Counter2 where
import Prelude hiding (div)
import Data.Int (even)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Pha as H
import Pha ((/\))
import Run as Run
import Pha.Update (Update, modify)
import Pha.App (app, attachTo, Document)
import Pha.Effects.Delay (DELAY, delay, interpretDelay)
import Pha.Subs as Subs
import Pha.Elements as HH
import Pha.Events as E

type State = {
    counter ∷ Int
}

-- effects used in this app
type EFFS = (delay ∷ DELAY)

-- initial state
state ∷ State
state = {
    counter: 0
}

data Msg = Increment | DelayedIncrement

increment ∷ forall effs. Update State effs
increment = modify \{counter} → {counter: counter + 1}

update ∷ Msg → Update State EFFS
update Increment = increment
update DelayedIncrement = delay 1000 *> increment

view ∷ State → Document Msg
view {counter} = {
    title: "Counter example",
    body:
        HH.div []
        [   HH.div [H.class_ "counter"] [H.text $ show counter]
        ,       HH.button [E.onclick Increment] [H.text "Increment"]
        ,       HH.button [E.onclick DelayedIncrement] [H.text "Delayed Increment"]

        ,   HH.div []
            [   HH.span [] [H.text "green when the counter is even"]
            ,   HH.div
                [   H.class_ "box"
                ,   H.class' "even" (even counter)
                ] []
            ]

        ,   HH.div [] [
                H.text "press space to increment the counter"
            ]
        ]
}

keyDownHandler ∷ String → Maybe Msg
keyDownHandler " " = Just Increment
keyDownHandler _ = Nothing

main ∷ Effect Unit
main = app {
    init: state /\ pure unit,
    view,
    update,
    subscriptions: const [Subs.onKeyDown keyDownHandler],
    interpreter: Run.match {
        delay: interpretDelay
    }
} # attachTo "root"