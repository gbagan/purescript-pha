module Example.Counter2 where
import Prelude hiding (div)
import Data.Int (even)
import Data.Maybe (Maybe(..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Run (match)
import Pha (Document, app, text, class_, class')
import Pha.Action (Action, setState)
import Pha.Effects.Delay (DELAY, delay, interpretDelay)
import Pha.Subs as Subs
import Pha.Elements (div, button, span)
import Pha.Events (onclick)

type State = {
    counter :: Int
}

-- effects used in this app
type EFFS = (delay :: DELAY)

-- initial state
state :: State
state = {
    counter: 0
}

data Msg = Increment | DelayedIncrement

increment :: forall effs. Action State effs
increment = setState \{counter} -> {counter: counter + 1}

update :: Msg -> Action State EFFS
update Increment = increment
update DelayedIncrement = delay 1000 *> increment

view :: State -> Document Msg
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
                text "press space to increment the counter"
            ]
        ]
}

keyDownHandler :: String -> Maybe Msg
keyDownHandler " " = Just Increment
keyDownHandler _ = Nothing

main :: Effect Unit
main = app {
    init: state /\ pure unit, -- initial state
    view,            -- a mapping of the state to virtual dom
    update,
    node: "root",    -- the id of the root node of the app
    subscriptions: const [Subs.onKeyDown keyDownHandler],
    interpret: match {
        delay: interpretDelay
    }
}