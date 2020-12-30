module Example.Counter2 where
import Prelude hiding (div)
import Data.Int (even)
import Data.Maybe (Maybe(..))
import Data.Array ((..), replicate)
import Data.Tuple.Nested ((/\))
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Pha (VDom)
import Pha as H
import Pha.App (app)
import Pha.Update (Update, modify, delay)
import Pha.Subs as Subs
import Pha.Elements as HH
import Pha.Events as E


type State = Int


-- initial state
state ∷ State
state = 0

data Msg = Increment | DelayedIncrement

update ∷ Msg → Update State
update Increment = modify (_ + 1)
update DelayedIncrement = do
    delay (Milliseconds 1000.0)
    modify (_ + 1)

spanCounter :: Int -> VDom Msg
spanCounter v = HH.span [] [H.text $ show v]

view ∷ State → VDom Msg
view counter =
    HH.div []
    [   HH.div [H.class_ "counter"] [H.text $ show counter]
    ,       HH.button [E.onclick Increment] [H.text "Increment"]
    ,       HH.button [E.onclick DelayedIncrement] [H.text "Delayed Increment"]
    ,   HH.div []
        [   HH.span [] [H.text "green when the counter is even"]
        ,   HH.div
            [   H.class_ "box"
            ,   H.class' "even" (even counter)
            ] []
        ]

    ,   HH.h3 [] [H.text "press I to increment the counter"]
    
    ,   HH.hr []
    ,   HH.h3 [] [H.text "keyed"]

    ,   H.keyed "div" [] $
            ((0 .. (counter `mod` 4)) <#> \i ->
                show i /\ H.text (show i)
            ) <> 
                ["test" /\ H.text "test"]
            <>
            ((0 .. (counter `mod` 4)) <#> \i ->
                show i /\ H.text (show i)
            )
    ,   HH.hr []
    ,   HH.h3 [] [H.text "non keyed"]
    ,   HH.div [] $
            ((0 .. (counter `mod` 4)) <#> \i ->
                H.text (show i)
            ) <> 
                [H.text "test"]
            <>
            ((0 .. (counter `mod` 4)) <#> \i ->
                H.text (show i)
            )
    ,   HH.hr []
    ,   HH.h3 [] [H.text "lazy"]
    ,   H.lazy spanCounter (counter / 2)

    ,   HH.hr []
    ,   HH.h3 [] 
        [   H.text "duplicate"
        ]
    ,   HH.div [] $
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
    subscriptions: const [Subs.onKeyDown keyDownHandler],
    selector: "#root"
}