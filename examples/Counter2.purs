module Example.Counter2 where
import Prelude hiding (div)
import Data.Int (even)
import Data.Maybe (Maybe(..))
import Data.Array (replicate, (..))
import Data.Tuple.Nested ((/\))
import Effect (Effect)
import Pha (VDom)
import Pha as H
import Pha.App (app)
import Pha.Subs as Subs
import Pha.Elements as HH
import Pha.Events as E


type State = {
    counter ∷ Int
}

-- effects used in this app

-- initial state
state ∷ State
state = {
    counter: 0
}

data Msg = Increment | DelayedIncrement

update ∷ {get ∷ Effect State, modify ∷ (State → State) → Effect Unit} → Msg → Effect Unit
update {modify} Increment = modify \{counter} → {counter: counter + 1}
update {modify} DelayedIncrement = do
    -- delay 1000 *>
    modify \{counter} → {counter: counter + 1}

view ∷ State → VDom Msg
view {counter} =
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

    ,   HH.h3 [] 
        [   H.text "press I to increment the counter"
        ]
    
    ,   HH.hr []
    ,   HH.h3 [] 
        [   H.text "keyed"
        ]

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
    ,   HH.h3 [] 
        [   H.text "non keyed"
        ]
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
    --,   HH.h3 [] 
    --    [   H.text "duplicate"
    --    ]
    --,   HH.div [] $
    --        replicate  (counter `mod` 4) (H.text "t")
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