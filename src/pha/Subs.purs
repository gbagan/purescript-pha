module Pha.Subs (Canceler, makeSub, on, on', onKeyDown, onAnimationFrame) where
import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Pha (Event, Sub)
import Pha.Events.Decoder as ED
import Foreign (unsafeToForeign)
import Data.Either (Either(..))
import Control.Monad.Except (runExcept)

type Canceler = Effect Unit

foreign import makeSub :: forall d msg. ((msg -> Effect Unit) -> d -> Effect Canceler) -> d -> Sub msg 

foreign import addEventListener :: String -> (Event -> Effect Unit) -> Effect Canceler
foreign import onAnimationFrameAux :: (Number -> Effect Unit) -> Effect Canceler

handleEvent :: forall msg. (msg -> Effect Unit ) -> ED.Decoder (Maybe msg) -> Event -> Effect Unit
handleEvent dispatch decoder ev =
    case runExcept (decoder (unsafeToForeign ev)) of
        Right (Just msg) → dispatch msg
        _  → pure unit

on :: ∀msg. String -> ED.Decoder msg → Sub msg
on name decoder = on' name (decoder >>> map(Just))

on' :: ∀msg. String -> ED.Decoder (Maybe msg) → Sub msg
on' name = makeSub fn
    where fn = \dispatch decoder -> addEventListener name (handleEvent dispatch decoder)

onKeyDown :: ∀msg. (String -> Maybe msg) -> Sub msg
onKeyDown f = on' "keydown" (ED.key >>> map f)

onAnimationFrame :: ∀msg. (Number -> msg) -> Sub msg
onAnimationFrame = makeSub fn 
    where fn = \dispatch handler -> onAnimationFrameAux (dispatch <<< handler)