module Example.Counter2 where
import Prelude hiding (div)
import Data.Int (even)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Run (match)
import Pha (VDom, Event, app, text, class_, class')
import Pha.Action (Action, setState)
import Pha.Effects.Delay (DELAY, delay, interpretDelay)
import Pha.Event (key) as E
import Pha.Elements (div, button, span)
import Pha.Attributes (onclick)

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

-- pure actions
increment :: forall effs. Action State effs
increment = setState \{counter} -> {counter: counter + 1}

-- actions with effects
delayedIncrement :: forall effs. Action State (delay :: DELAY | effs)
delayedIncrement = delay 1000 *> increment

view :: State -> VDom State EFFS
view {counter} = 
    div [] [
        div [class_ "counter"] [text $ show counter],
        button [onclick increment] [text "Increment"],
        button [onclick delayedIncrement] [text "Delayed Increment"],

        div [] [
            span [] [text "green when the counter is even"],
            div [
                class_ "box", 
                class' "even" (even counter)
            ] []
        ],

        div [] [
            text "press space to increment the counter"
        ]
    ]

onKeydown :: forall effs. Event -> Action State effs
onKeydown ev = case E.key (ev) of
    Just " " -> increment
    _ -> pure unit

main :: Effect Unit
main = app {
    state,           -- initial state
    view,            -- a mapping of the state to virtual dom
    init: pure unit, -- action triggered at the start of the app (no action here)
    node: "root",    -- the id of the root node of the app
    events: [Tuple "keydown" onKeydown],
    effects: match {
        delay: interpretDelay
    }
}