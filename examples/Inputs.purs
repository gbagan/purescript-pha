module Example.Inputs where
import Prelude hiding (div)
import Data.Maybe (fromMaybe)
import Data.Int (fromString)
import Effect (Effect)
import Pha (VDom, text, attr)
import Pha.App (sandbox, attachTo)
import Pha.Elements (div, br, input)
import Pha.Attributes (value, checked)
import Pha.Events (onvaluechange, onchecked)

type State = {
    val1 ∷ String,
    val2 ∷ String,
    isMul ∷ Boolean
}

data Msg = ChangeVal1 String | ChangeVal2 String | ChangeOp Boolean

-- initial state
init ∷ State
init = {
    val1: "2",
    val2: "4",
    isMul: false
}

result ∷ State → String
result {val1, val2, isMul} = fromMaybe "invalid input" do
    x ← fromString val1
    y ← fromString val2
    pure $ show (if isMul then x * y else x + y)

update ∷ Msg → State → State
update (ChangeVal1 val) = _{val1 = val}
update (ChangeVal2 val) = _{val2 = val}
update (ChangeOp b) = _{isMul = b}

view ∷ State → VDom Msg
view st@{val1, val2, isMul} = 
    div [] [
        input "text" [attr "size" "5", onvaluechange ChangeVal1, value val1],
        text (if isMul then " * " else " + "),
        input "text" [attr "size" "5", onvaluechange ChangeVal2, value val2],
        text $ " = " <> result st,
        br,
        input "checkbox" [checked isMul, onchecked ChangeOp],
        text "Multiplication instead of addition"
    ]

main ∷ Effect Unit
main = sandbox {init, view, update} # attachTo "root"