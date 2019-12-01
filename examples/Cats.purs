module Example.Cats where
import Prelude hiding (div)
import Data.Maybe (Maybe, maybe)
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Effect.Aff (Aff)
import Pha (VDom, Transition, text, style, purely)
import Pha.App (attachTo, Document, app)
import Pha.Effects.Http (interpretAjax)
import Pha.Elements (div, h2, button, img)
import Pha.Attributes (src)
import Pha.Events (onclick)
import Data.Argonaut as J
import Foreign.Object as O

data Model = Failure | Loading | Success String

data Msg = RequestCat | CatReceived (Maybe J.Json)

-- effects used in this app
data Effs msg = Ajax String (Maybe J.Json -> msg)

catUrl :: String
catUrl = "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"

update ∷ Model → Msg → Transition Model Msg Effs
update _ RequestCat = Loading /\ [Ajax catUrl CatReceived]
update _ (CatReceived json) = purely $
    maybe Failure Success $ 
        json
        >>= J.toObject 
        >>= O.lookup "data"
        >>= J.toObject
        >>= O.lookup "image_url" 
        >>= J.toString

view ∷ Model → Document Msg
view st = {
    title: "Cats example",
    body:
        div [] 
        [   h2 [] [text "Random Cats"]  
        ,   viewGif st
        ]
}

viewGif ∷ Model → VDom Msg
viewGif Failure = div [] [
        text "I could not load a random cat for some reason. ",
        button [onclick RequestCat] [ text "Try Again!" ]
    ]
viewGif Loading = text "Loading..."
viewGif (Success url) = div [] [
        button [ onclick RequestCat, style "display" "block" ] [ text "More Please!" ],
        img [ src url ] []
    ]

interpreter :: Effs Msg -> Aff Msg 
interpreter (Ajax url fmsg) = interpretAjax url fmsg

main ∷ Effect Unit
main = app {
    init: Loading /\ [Ajax catUrl CatReceived],
    view,
    update,
    subscriptions: const [],
    interpreter
} # attachTo "root"