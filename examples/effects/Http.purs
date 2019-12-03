module Pha.Example.Effects.Http (ajax, HTTP, interpretHttp, Http) where
import Prelude
import Data.Maybe (Maybe(..))
import Run (Run, SProxy(..), FProxy, lift)
import Effect (Effect)
import Foreign (Foreign)

data Http a = Ajax String (Maybe Foreign -> a)
derive instance fHttp :: Functor Http
type HTTP = FProxy Http
_http = SProxy :: SProxy "http"

ajax :: ∀r. String -> Run (http :: HTTP | r) (Maybe Foreign)
ajax url = lift _http (Ajax url identity)

foreign import ajaxAux ::  (Foreign -> Maybe Foreign) -> Maybe Foreign -> String -> (Maybe Foreign -> Effect Unit) -> Effect Unit

interpretHttp :: Http (Effect Unit) -> Effect Unit
interpretHttp (Ajax url cont) = ajaxAux Just Nothing url cont

    