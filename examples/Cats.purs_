module Example.Cats where
import Prelude hiding (div)
import Data.Maybe (maybe)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Pha (VDom,  text, style)
import Pha.App (attachTo, Document, app, addInterpret)
import Pha.Action (Action, setState)
import Pha.Effects.Http (ajax, HTTP, interpretHttp)
import Pha.Elements (div, h2, button, img)
import Pha.Attributes (src)
import Pha.Events (onclick)
import Data.Argonaut as J
import Foreign.Object as O

data State = Failure | Loading | Success String

data Msg = RequestCat

-- effects used in this app
type EFFS = (http ∷ HTTP)

-- initial state
state ∷ State
state = Loading

update ∷ Msg → Action State EFFS
update RequestCat = do
    setState \_ → Loading
    res ← ajax "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
    let status = maybe Failure Success $ 
                res
                >>= J.toObject 
                >>= O.lookup "data"
                >>= J.toObject
                >>= O.lookup "image_url" 
                >>= J.toString
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
viewGif Failure = div [] [
        text "I could not load a random cat for some reason. ",
        button [onclick RequestCat] [ text "Try Again!" ]
    ]
viewGif Loading = text "Loading..."
viewGif (Success url) = div [] [
        button [ onclick RequestCat, style "display" "block" ] [ text "More Please!" ],
        img [ src url ] []
    ]

main ∷ Effect Unit
main = app {
    init: state /\ update RequestCat,
    view,
    update,
    subscriptions: const []
} # addInterpret interpretHttp
  # attachTo "root"