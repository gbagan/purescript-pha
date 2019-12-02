module Pha.Example.Effects.Http ( HTTP, get, ajax, interpretHttp, Http, module R) where
import Prelude

import Affjax as AX
import Affjax.ResponseFormat as R
import Data.Argonaut.Core as J
import Data.Either (Either(..))
import Effect.Aff (Aff, launchAff)
import Run (AFF)
import Run as Run
import Data.Maybe (Maybe(..))
import Run (Run, SProxy(..), FProxy, lift)
import Effect (Effect)

data Http a = Get String (Maybe String → a) | Ajax String (Maybe J.Json → a)
derive instance fHttp ∷ Functor Http
type HTTP = FProxy Http
_http = SProxy ∷ SProxy "http"


simpleGet ∷ ∀a. R.ResponseFormat a → String → Aff (Maybe a)
simpleGet format url = do
    res <- AX.get format url
    case res of
        Left _ → pure $ Nothing
        Right response → pure $ Just response.body

get ∷ ∀r. String → Run (http ∷ HTTP| r) (Maybe String)
get url = Run.lift _http (Get url identity)
ajax ∷ ∀r. String → Run (http ∷ HTTP | r) (Maybe J.Json)
ajax url = Run.lift _http (Ajax url identity)

interpretHttp ∷ ∀r. Run (aff ∷ AFF, http ∷ HTTP | r) Unit → Run (aff ∷ AFF | r) Unit
interpretHttp  = Run.run(Run.on _http handle Run.send) where
    handle ∷ Http ~> Run (aff ∷ AFF | r)
    handle (Get url next) = Run.liftAff $ simpleGet R.string url <#> next
    handle (Ajax url next) = Run.liftAff $ simpleGet R.json url <#> next
    