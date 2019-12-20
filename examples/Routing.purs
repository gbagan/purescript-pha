module Example.Routing where
import Prelude hiding (div)
import Effect (Effect)
import Pha (text, (/\))
import Pha.App (Document, appWithRouter, attachTo, Url(..), UrlRequest(..))
import Pha.Update (Update, purely, getState, setState)
import Pha.Elements (div, button, h1, a)
import Pha.Attributes (href)
import Pha.Events (onclick)
import Pha.Effects.Nav (NAV, interpretNav)
import Pha.Effects.Nav as Nav
import Run as Run

type State = 
    {   page :: String
    ,   counter :: Int
    }

data Msg = OnUrlChange Url | OnUrlRequest UrlRequest | NextPage

-- effects used in this app
type EFFS = (nav ∷ NAV)

update ∷ Msg → Update State EFFS

update (OnUrlChange (Url url)) = purely $ _{page = url.pathname}
update (OnUrlRequest (Internal (Url url))) = Nav.goTo url.href
update (OnUrlRequest (External url)) = Nav.load url
update NextPage = do
    state <- getState
    setState _{counter = state.counter + 1}
    Nav.goTo $ "/page" <> show (state.counter + 1)

view ∷ State → Document Msg
view {counter, page} = {
    title: "Routing example",
    body:
        div [] 
        [   h1 [] [text $ "Page: " <> page]
        ,   a [href $ "/page" <> show counter] [text "Previous page"]
        ,   button [onclick NextPage] [text "Next page"]
        ]
}



main ∷ Effect Unit
main = appWithRouter {
    init: \(Url url) -> {counter: 0, page: ""} /\ Nav.redirectTo "/0",
    view,
    update,
    subscriptions: const [],
    onUrlChange: OnUrlChange,
    onUrlRequest: OnUrlRequest,
    interpreter: Run.match {
        nav: interpretNav
    }
} # attachTo "root"
