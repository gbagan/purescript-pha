module Example.Counter where
import Prelude
import Effect (Effect)
import Pha.Html (Html)
import Pha.App (sandbox)
import Pha.Html as H
import Pha.Html.Events as E

type State = Int
data Msg = Increment | Decrement

init ∷ State
init = 0

update ∷ Msg → State → State
update Increment n = n + 1
update Decrement n = n - 1

view ∷ State → Html Msg
view counter =
    H.div []
    [   H.button [E.onClick \_ → Decrement] [H.text "-"]
    ,   H.span [] [H.text $ show counter]
    ,   H.button [E.onClick \_ → Increment] [H.text "+"]
    ]

main ∷ Effect Unit
main = sandbox {init, update, view, selector: "#root"}