module Pha.Effects.Http (interpretGet, interpretAjax, module R) where
import Prelude
import Affjax as AX
import Affjax.ResponseFormat (ResponseFormat, string, json,blob) as R
import Data.Argonaut.Core as J
import Data.Either (Either(..))
import Effect.Aff (Aff)
import Data.Maybe (Maybe(..))


simpleGet ∷ ∀a. R.ResponseFormat a → String → Aff (Maybe a)
simpleGet format url = do
    res <- AX.get format url
    case res of
        Left _ → pure $ Nothing
        Right response → pure $ Just response.body

interpretGet ∷ forall msg. String -> (Maybe String -> msg) -> Aff msg
interpretGet url fmsg = simpleGet R.string url <#> fmsg

interpretAjax ∷ forall msg. String -> (Maybe J.Json -> msg) -> Aff msg
interpretAjax url fmsg = simpleGet R.json url <#> fmsg
