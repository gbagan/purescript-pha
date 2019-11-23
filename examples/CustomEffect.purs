module Example.CustomEffect where
import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Run (Run, SProxy(..), FProxy, lift, match)
import Pha (VDom, Event, app, maybeN)
import Pha.Action (Action, setState)
import Pha.Html (div', style, pc, onpointerleave, onpointermove')
import Pha.Svg (svg, viewBox, circle, fill, stroke)
import Pha.Util (translate)

type Position = {x :: Number, y :: Number}

-- custom event
data GetPointer a = GetPointer Event (Maybe Position -> a)
derive instance functorPointer :: Functor GetPointer
type POINTER = FProxy GetPointer

getPointerPosition :: ∀r. Event -> Run (pointer :: POINTER | r) (Maybe Position)
getPointerPosition ev = lift (SProxy :: SProxy "pointer") (GetPointer ev identity)

type State = {
    position :: Maybe Position
}

-- effects used in this app
type EFFS = (pointer :: POINTER)

-- initial state
state :: State
state = {
    position: Nothing
}

updatePosition :: forall effs. Event -> Action State (pointer :: POINTER | effs)
updatePosition ev = do
    position <- getPointerPosition ev
    setState _{position = position}

clearPosition :: forall effs. Action State effs
clearPosition = setState _{position = Nothing}

view :: State -> VDom State EFFS
view {position} = 
    div' [] [
        div' [
            style "width" "400px",
            style "height" "400px",
            style "border" "solid grey thin",
            onpointermove' updatePosition,
            onpointerleave clearPosition
        ] [
            svg [viewBox 0 0 100 100] [
                maybeN $ position <#> \{x, y} ->
                    circle 0.0 0.0 7.0 [
                        fill "red",
                        stroke "black",
                        style "transform" $ translate (pc x) (pc y)
                    ]
            ]
        ]
    ]

-- implementation of the effect
foreign import pointerPositionAux :: Maybe Position -> (Position -> Maybe Position) -> Event -> Effect (Maybe Position)
pointerPosition :: Event -> Effect (Maybe Position)
pointerPosition = pointerPositionAux Nothing Just

interpretPointer :: GetPointer (Effect Unit) -> Effect Unit
interpretPointer = \(GetPointer ev cont) -> pointerPosition ev >>= cont

main :: Effect Unit
main = app {
    state,           -- initial state
    view,            -- a mapping of the state to virtual dom
    init: pure unit, -- action triggered at the start of the app (no action here)
    node: "root",    -- the id of the root node of the app
    events: [],
    effects: match {
        pointer: interpretPointer
    }
}