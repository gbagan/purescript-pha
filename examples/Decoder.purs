module Example.Decoder where
import Prelude hiding (div)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Pha.App (sandbox, attachTo)
import Pha as H
import Pha.Elements as HH
import Pha.Attributes as P
import Pha.Events as E
import Pha.Events.Decoder (Decoder, readNumber, readProp, currentTarget, getBoundingClientRect)
import Pha.Util (pc, translate)

type Position = {x ∷ Number, y ∷ Number}

type State = Maybe Position

data Msg = SetPosition (Maybe Position)

decoder ∷ Decoder Position
decoder f = do
    {left, top, width, height} ← f # currentTarget >>= getBoundingClientRect
    x ← f # readProp "clientX" >>= readNumber
    y ← f # readProp "clientY" >>= readNumber
    pure {
        x: (x - left) / width,
        y: (y - top) / height
    }
-- initial state
init ∷ State
init = Nothing

update ∷ Msg → State → State
update (SetPosition p) = const p 

view ∷ State → H.VDom Msg
view position = 
    HH.div [] [
        HH.div [
            H.style "width" "400px",
            H.style "height" "400px",
            H.style "border" "solid grey thin",
            E.on "pointermove" (\f → SetPosition <$> Just <$> decoder f),
            E.onpointerleave (SetPosition Nothing)
        ] [
            HH.svg [P.viewBox 0 0 100 100] [
                H.maybeN $ position <#> \{x, y} →
                    HH.circle [
                        P.r "7.0",
                        P.fill "red",
                        P.stroke "black",
                        H.style "transform" $ translate (pc x) (pc y)
                    ]
            ]
        ]
    ]

main ∷ Effect Unit
main = sandbox { init, view, update} # attachTo "root"