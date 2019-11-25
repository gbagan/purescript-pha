module Pha.Event.Decoder (Decoder, onWithDecoder, currentTargetValue, currentTargetChecked, shiftKey, module F) where
import Prelude
import Data.Maybe (Maybe(..))
import Data.Either (Either(..))
import Pha (Prop, on)
import Foreign (readBoolean, readInt, readString) as F
import Foreign (Foreign, unsafeToForeign, F)
import Foreign.Index (readProp) as F
import Control.Monad.Except (runExcept)

type Decoder a = Foreign -> F a

onWithDecoder :: ∀a msg. Decoder a → String → (a → msg) → Prop msg
onWithDecoder decoder eventname handler = on eventname handler' where
    handler' ev =
        case runExcept (decoder (unsafeToForeign ev)) of
            Right a → Just (handler a)
            _  → Nothing

currentTargetValue :: Decoder String
currentTargetValue = F.readProp "currentTarget" >=> F.readProp "value" >=> F.readString

currentTargetChecked :: Decoder Boolean
currentTargetChecked = F.readProp "currentTarget" >=> F.readProp "checked" >=> F.readBoolean

shiftKey :: Decoder Boolean
shiftKey = F.readProp "shiftKey" >=> F.readBoolean