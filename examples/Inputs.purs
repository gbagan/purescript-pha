module Example.Inputs where
import Prelude hiding (div)
import Data.Maybe (fromMaybe)
import Data.Int (fromString)
import Effect (Effect)
import Pha.App (sandbox)
import Pha as H
import Pha.Elements as HH
import Pha.Attributes as P
import Pha.Events as E

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

view ∷ State → H.VDom Msg
view st@{val1, val2, isMul} = 
    HH.div []
    [   HH.input "text" [H.attr "size" "5", E.onvaluechange ChangeVal1, P.value val1]
    ,   H.text (if isMul then " * " else " + ")
    ,   HH.input "text" [H.attr "size" "5", E.onvaluechange ChangeVal2, P.value val2]
    ,   H.text $ " = " <> result st
    ,   HH.br
    ,   HH.input "checkbox" [P.checked isMul, E.onchecked ChangeOp]
    ,   H.text "Multiplication instead of addition"
    ]

main ∷ Effect Unit
main = sandbox {init, view, update, selector: "#root"}
