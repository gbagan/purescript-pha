module Pha.Event.Decoder (Decoder, withDecoder, currentTargetValue, currentTargetChecked, module F) where
import Prelude
import Data.Maybe (Maybe(..))
import Data.Either (Either(..))
import Pha (Prop, on)
import Foreign (readBoolean, readInt, readString) as F
import Foreign (Foreign, unsafeToForeign, F)
import Foreign.Index (readProp) as F
import Control.Monad.Except (runExcept)

type Decoder a = Foreign -> F a

withDecoder :: ∀a msg. Decoder a → String → (a → Maybe msg) → Prop msg
withDecoder decoder eventname handler = on eventname handler' where
    handler' ev =
        case runExcept (decoder (unsafeToForeign ev)) of
            Left _  → Nothing
            Right a → handler a

currentTargetValue :: Decoder String
currentTargetValue = F.readProp "currentTarget" >=> F.readProp "value" >=> F.readString

currentTargetChecked :: Decoder Boolean
currentTargetChecked = F.readProp "currentTarget" >=> F.readProp "checked" >=> F.readBoolean