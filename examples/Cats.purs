module Example.Cats where
import Prelude hiding (div)
import Data.Maybe (maybe)
import Effect (Effect)
import Run as Run
import Pha (VDom, text, style, (/\))
import Pha.App (Document, app, attachTo)
import Pha.Update (Update, setState)
import Pha.Example.Effects.Http (ajax, HTTP, interpretHttp)
import Pha.Elements (div, h2, button, img)
import Pha.Attributes (src)
import Pha.Events (onclick)
import Control.Monad.Except (runExcept)
import Data.Either (hush)
import Foreign (readString)
import Foreign.Index ((!))

data State = Failure | Loading | Success String

data Msg = RequestCat

-- effects used in this app
type EFFS = (http ∷ HTTP)

-- initial state
state ∷ State
state = Loading

update ∷ Msg → Update State EFFS
update RequestCat = do
    setState \_ → Loading
    res ← ajax "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
    let status = maybe Failure Success $ do
                    json ← res
                    hush $ runExcept $ json ! "data" ! "image_url" >>= readString
    setState \_ → status

view ∷ State → Document Msg
view st = {
    title: "Cats example",
    body:
        div [] 
        [   h2 [] [text "Random Cats"]  
        ,   viewGif st
        ]
}

viewGif ∷ State → VDom Msg
viewGif Failure = div [] 
        [   text "I could not load a random cat for some reason. "
        ,   button [onclick RequestCat] [ text "Try Again!" ]
        ]
viewGif Loading = text "Loading..."
viewGif (Success url) = div [] 
    [   button [ onclick RequestCat, style "display" "block" ] [ text "More Please!" ]
    ,   img [ src url ] []
    ]

main ∷ Effect Unit
main = app {
    init: state /\ update RequestCat,
    view,
    update,
    subscriptions: const [],
    interpreter: Run.match {
        http: interpretHttp
    }
} # attachTo "root"
