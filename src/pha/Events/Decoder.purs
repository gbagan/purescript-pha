module Pha.Events.Decoder (Decoder, always, currentTarget, currentTargetValue, currentTargetChecked, shiftKey, key, getBoundingClientRect, module F) where
import Prelude
import Foreign (readBoolean, readInt, readString, readNumber) as F
import Foreign (Foreign, F)
import Foreign.Index (readProp) as F

type Decoder a = Foreign -> F a

currentTarget :: Decoder Foreign
currentTarget = F.readProp "currentTarget"

currentTargetValue :: Decoder String
currentTargetValue = currentTarget >=> F.readProp "value" >=> F.readString

currentTargetChecked :: Decoder Boolean
currentTargetChecked = currentTarget >=> F.readProp "checked" >=> F.readBoolean

shiftKey :: Decoder Boolean
shiftKey = F.readProp "shiftKey" >=> F.readBoolean

key :: Decoder String
key = F.readProp "key" >=> F.readString

always ∷ ∀msg a. msg → a → F msg
always = const <<< pure

type Rectangle = {left :: Number, top :: Number, width :: Number, height :: Number}

foreign import getBoundingClientRectAux :: Foreign -> Foreign

getBoundingClientRect :: Decoder Rectangle
getBoundingClientRect f = do
    let rect = getBoundingClientRectAux f
    left <- rect # F.readProp "left" >>= F.readNumber
    top  <- rect # F.readProp "top" >>= F.readNumber
    width  <- rect # F.readProp "width" >>= F.readNumber
    height  <- rect # F.readProp "height" >>= F.readNumber
    pure {left, top, width, height}