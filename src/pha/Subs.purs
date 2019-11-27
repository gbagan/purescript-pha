module Pha.Subs (makeSub, on, on', onkeydown) where
import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Pha (Event, Sub)
import Pha.Events.Decoder as ED
import Unsafe.Coerce (unsafeCoerce)
import Foreign (unsafeToForeign)
import Data.Either (Either(..))
import Control.Monad.Except (runExcept)

type Canceler = Effect Unit

makeSub :: forall d msg. ((msg -> Effect Unit) -> d -> Effect (Effect Unit)) -> d -> Sub msg
makeSub fn data_ = unsafeCoerce {fn, data_: data_}

foreign import addEventListener :: String -> (Event -> Effect Unit) -> Effect Canceler


handleEvent :: forall msg. (msg -> Effect Unit ) -> ED.Decoder (Maybe msg) -> Event -> Effect Unit
handleEvent dispatch decoder ev =
    case runExcept (decoder (unsafeToForeign ev)) of
        Right (Just msg) → dispatch msg
        _  → pure unit

on :: ∀msg. String -> ED.Decoder msg → Sub msg
on name decoder = on' name (decoder >>> map(Just))

on' :: ∀msg. String -> ED.Decoder (Maybe msg) → Sub msg
on' name =
    let fn = \dispatch decoder2 -> addEventListener name (handleEvent dispatch decoder2)
    in \decoder -> makeSub fn decoder

onkeydown :: ∀msg. (String -> Maybe msg) -> Sub msg
onkeydown f = on' "keydown" (ED.key >>> map f)