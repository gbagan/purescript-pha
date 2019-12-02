module Example.Counter where
import Prelude hiding (div)
import Effect (Effect)
import Pha (VDom, text)
import Pha.App (sandbox, attachTo)
import Pha.Elements (div, span, button)
import Pha.Events (onclick)

type State = Int
data Msg = Increment | Decrement

init ∷ State
init = 0

update ∷ Msg → State → State
update Increment = (_ + 1)
update Decrement = (_ - 1)

view ∷ State → VDom Msg
view counter = 
    div []
    [   button [onclick Decrement] [text "-"]
    ,   span [] [text $ show counter]
    ,   button [onclick Increment] [text "-"]
    ]

main ∷ Effect Unit
main = sandbox {
    init,
    update,
    view
} # attachTo "root"