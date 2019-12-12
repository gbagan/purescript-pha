module Example.Decoder where
import Prelude hiding (div)
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Pha (VDom, maybeN, style)
import Pha.App (sandbox, attachTo)
import Pha.Elements (div)
import Pha.Events (on, onpointerleave)
import Pha.Events.Decoder (Decoder, readNumber, readProp, currentTarget, getBoundingClientRect)
import Pha.Svg (svg, viewBox, circle, r, fill, stroke)
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

view ∷ State → VDom Msg
view position = 
    div [] [
        div [
            style "width" "400px",
            style "height" "400px",
            style "border" "solid grey thin",
            on "pointermove" (\f → SetPosition <$> Just <$> decoder f),
            onpointerleave (SetPosition Nothing)
        ] [
            svg [viewBox 0 0 100 100] [
                maybeN $ position <#> \{x, y} →
                    circle [
                        r "7.0",
                        fill "red",
                        stroke "black",
                        style "transform" $ translate (pc x) (pc y)
                    ]
            ]
        ]
    ]

main ∷ Effect Unit
main = sandbox { init, view, update} # attachTo "root"