module Example.Cats where
import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Run (match)
import Pha (VDom, app, text)
import Pha.Action (Action, setState)
import Pha.Http (simpleRequest, HTTP, interpretHttp)
import Pha.Html (div', h2, button, style, onclick, img, src)
import Data.Argonaut (jsonParser, toObject, toString)
import Foreign.Object (lookup)
import Data.Either (hush)

data State = Failure | Loading | Success String

-- effects used in this app
type EFFS = (http :: HTTP)

-- initial state
state :: State
state = Loading

requestCat :: forall effs. Action State (http :: HTTP | effs)
requestCat = do
    setState \_ -> Loading
    res <- simpleRequest "https://api.giphy.com/v1/gifs/random?api_key=dc6zaTOxFJmzC&tag=cat"
    let status = case res
                >>= (jsonParser >>> hush)
                >>= toObject 
                >>= lookup "data"
                >>= toObject
                >>= lookup "image_url" 
                >>= toString
        of
            Nothing -> Failure
            Just url -> Success url
    setState \_ -> status

view :: State -> VDom State EFFS
view st = 
    div' [] [
        h2 [] "Random Cats",  
        viewGif st
    ]

viewGif :: State -> VDom State EFFS
viewGif Failure = div' [] [
        text "I could not load a random cat for some reason. ",
        button [onclick requestCat] [ text "Try Again!" ]
    ]
viewGif Loading = text "Loading..."
viewGif (Success url) = div' [] [
        button [ onclick requestCat, style "display" "block" ] [ text "More Please!" ],
        img [ src url ] []
    ]

main :: Effect Unit
main = app {
    state,
    view,
    init: requestCat,
    node: "root",
    events: [],
    effects: match {
        http: interpretHttp
    }
}