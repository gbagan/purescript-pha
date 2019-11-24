module Pha.Effects.Http (simpleRequest, HTTP, interpretHttp, Http) where
import Prelude
import Data.Maybe (Maybe(..))
import Run (Run, SProxy(..), FProxy, lift)
import Effect (Effect)

data Http a = SimpleHttp String (Maybe String -> a)
derive instance fHttp :: Functor Http
type HTTP = FProxy Http

simpleRequest :: ∀r. String -> Run (http :: HTTP | r) (Maybe String)
simpleRequest url = lift (SProxy :: SProxy "http") (SimpleHttp url identity)

foreign import requestAux ::  (String -> Maybe String) -> Maybe String -> String -> (Maybe String -> Effect Unit) -> Effect Unit

interpretHttp :: Http (Effect Unit) -> Effect Unit
interpretHttp (SimpleHttp url cont) = requestAux Just Nothing url cont