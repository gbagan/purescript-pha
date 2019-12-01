module Example.Counter where
import Prelude hiding (div)
import Effect (Effect)
import Pha (VDom, text)
import Pha.App (sandbox, attachTo)
import Pha.Elements (div, span, button)
import Pha.Events (onclick)

type Model = Int
data Msg = Increment | Decrement

update ∷ Model → Msg → Model
update n Increment = n + 1
update n Decrement = n - 1

view ∷ Model → VDom Msg
view counter = 
    div []
    [   button [onclick Decrement] [text "-"]
    ,   span [] [text $ show counter]
    ,   button [onclick Increment] [text "-"]
    ]

main ∷ Effect Unit
main = sandbox {
    init: 0,
    update,
    view
} # attachTo "root"