module Example.Counter2 where
import Prelude hiding (div)
import Data.Int (even)
import Data.Maybe (Maybe(..))
import Data.Array ((..), replicate)
import Data.Tuple.Nested ((/\))
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Pha.Html (Html)
import Pha.Html as H
import Pha.Html.Events as E
import Pha.App (app)
import Pha.Update (Update, modify_, delay)
import Pha.Subscriptions as Subs


type State = Int


-- initial state
state ∷ State
state = 0

data Msg = Increment | DelayedIncrement

update ∷ Msg → Update State Unit
update Increment = modify_ (_ + 1)
update DelayedIncrement = do
    delay (Milliseconds 1000.0)
    modify_ (_ + 1)

spanCounter :: Int -> Html Msg
spanCounter v = H.span [] [H.text $ show v]

view ∷ State → Html Msg
view counter =
    H.div []
    [   H.div [H.class_ "counter"] [H.text $ show counter]
    ,       H.button [E.onClick \_ → Increment] [H.text "Increment"]
    ,       H.button [E.onClick \_ → DelayedIncrement] [H.text "Delayed Increment"]
    ,   H.div []
        [   H.span [] [H.text "green when the counter is even"]
        ,   H.div
            [   H.class_ "box"
            ,   H.class' "even" (even counter)
            ] []
        ]

    ,   H.h3 [] [H.text "press I to increment the counter"]
    
    ,   H.hr []
    ,   H.h3 [] [H.text "keyed"]

    ,   H.keyed "div" [] $
            ((0 .. (counter `mod` 4)) <#> \i ->
                show i /\ H.text (show i)
            ) <> 
                ["test" /\ H.text "test"]
            <>
            ((0 .. (counter `mod` 4)) <#> \i ->
                show i /\ H.text (show i)
            )
    ,   H.hr []
    ,   H.h3 [] [H.text "non keyed"]
    ,   H.div [] $
            ((0 .. (counter `mod` 4)) <#> \i ->
                H.text (show i)
            ) <> 
                [H.text "test"]
            <>
            ((0 .. (counter `mod` 4)) <#> \i ->
                H.text (show i)
            )
    ,   H.hr []
    ,   H.h3 [] [H.text "lazy"]
    ,   H.lazy spanCounter (counter / 2)

    ,   H.hr []
    ,   H.h3 [] 
        [   H.text "duplicate"
        ]
    ,   H.div [] $
            replicate  (counter `mod` 4) (H.text "t")
    ]

keyDownHandler ∷ String → Maybe Msg
keyDownHandler "i" = Just Increment
keyDownHandler _ = Nothing

main ∷ Effect Unit
main = app {
    init: {state, action: Nothing},
    view,
    update,
    subscriptions: [Subs.onKeyDown keyDownHandler],
    selector: "#root"
}