module Example.Routing where
import Prelude hiding (div)
import Effect (Effect)
import Pha (text, (/\))
import Data.String (stripPrefix, Pattern(..))
import Data.Int (fromString)
import Data.Maybe (fromMaybe)
import Pha.App (Document, attachTo)
import Pha.App.Router (appWithRouter, Url, UrlRequest(..))
import Pha.Update (Update, purely, getState)
import Pha.Elements (div, button, h1, a)
import Pha.Attributes (href)
import Pha.Events (onclick)
import Pha.Effects.Nav (NAV, interpretNav)
import Pha.Effects.Nav as Nav
import Run as Run

type State = Url

data Msg = OnUrlChange Url | OnUrlRequest UrlRequest | NextPage

-- effects used in this app
type EFFS = (nav ∷ NAV)

extractNumber :: String → Int
extractNumber = (stripPrefix (Pattern "/page") >=> fromString) >>> fromMaybe 0

update ∷ Msg → Update State EFFS
update (OnUrlChange url) = purely $ const url
update (OnUrlRequest (Internal url)) = Nav.goTo url.href
update (OnUrlRequest (External url)) = Nav.load url
update NextPage = do
    {pathname} <- getState
    Nav.goTo $ "/page" <> show (extractNumber pathname + 1)


view ∷ State → Document Msg
view {href: href', pathname} = {
    title: "Routing example",
    body:
        div [] 
        [   h1 [] [text $ "Page: " <> href']
        ,   a 
                [href $ "/page" <> show (extractNumber pathname - 1)]
                [text "Previous page"]
        ,   button
                [onclick NextPage]
                [text "Next page"]
        ]
}

main ∷ Effect Unit
main = appWithRouter 
    {   init: (_ /\ Nav.redirectTo "/page0")
    ,   view
    ,   update
    ,   subscriptions: const []
    ,   onUrlChange: OnUrlChange
    ,   onUrlRequest: OnUrlRequest
    ,   interpreter: Run.match {
            nav: interpretNav
        }
    } # attachTo "root"
