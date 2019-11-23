module Example.Inputs where
import Prelude hiding (div)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Int (fromString)
import Effect (Effect)
import Run (match)
import Pha (VDom, Event, app, text)
import Pha.Action (Action, setState)
import Pha.Html (div, br, attr, input, value, checked, onchange')
import Pha.Event (EVENT, targetValue, targetChecked, interpretEvent)

type State = {
    val1 :: String,
    val2 :: String,
    isMul :: Boolean
}

-- effects used in this app
type EFFS = (event :: EVENT)

-- initial state
state :: State
state = {
    val1: "2",
    val2: "4",
    isMul: false
}

result :: State -> String
result {val1, val2, isMul} = fromMaybe "invalid input" do
    x <- fromString val1
    y <- fromString val2
    pure $ show (if isMul then x * y else x + y)

changeval1 :: forall r. Event -> Action State (event :: EVENT | r)
changeval1 ev = targetValue ev >>= case _ of
    Just val -> setState _{val1 = val}
    Nothing -> pure unit

changeval2 :: forall r. Event -> Action State (event :: EVENT | r)
changeval2 ev = targetValue ev >>= case _ of
    Just val -> setState _{val2 = val}
    Nothing -> pure unit

changemul :: forall r. Event -> Action State (event :: EVENT | r)
changemul ev = targetChecked ev >>= \val -> setState _{isMul = (val == Just true)}

view :: State -> VDom State EFFS
view st@{val1, val2, isMul} = 
    div [] [
        input "text" [attr "size" "5", onchange' changeval1, value val1],
        text " + ",
        input "text" [attr "size" "5", onchange' changeval2, value val2],
        text $ " = " <> result st,
        br,
        input "checkbox" [checked isMul, onchange' changemul],
        text "Multiplication instead of addition"
    ]

main :: Effect Unit
main = app {
    state,
    view, 
    init: pure unit,
    node: "root",
    events: [],
    effects: match {
        event: interpretEvent
    }
}