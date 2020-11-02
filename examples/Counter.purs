module Example.Counter where
import Prelude hiding (div)
import Effect (Effect)
import Pha (VDom, text)
import Pha.App (sandbox)
import Pha.Elements as H
import Pha.Events as E

type State = Int
data Msg = Increment | Decrement

init ∷ State
init = 0

update ∷ Msg → State → State
update Increment n = n + 1
update Decrement n = n - 1

view ∷ State → VDom Msg
view counter = 
    H.div []
    [   H.button [E.onclick Decrement] [text "-"]
    ,   H.span [] [text $ show counter]
    ,   H.button [E.onclick Increment] [text "+"]
    ]

main ∷ Effect Unit
main = sandbox {init, update, view, selector: "#root"}