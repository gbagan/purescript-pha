module Example.Counter2 where
import Prelude hiding (div)
import Data.Int (even)
import Data.Maybe (Maybe(..))
import Data.Array ((..), replicate)
import Data.Time.Duration (Milliseconds(..))
import Effect (Effect)
import Effect.Aff (Aff)
import Pha.Html (Html)
import Pha.Html as H
import Pha.Html.Events as E
import Pha.App (app)
import Pha.Update (Update, modify_, delay)
import Pha.Subscriptions (onKeyDown)

type Model = Int

-- initial state
model ∷ Model
model = 0

data Msg = Init | Increment | DelayedIncrement

update ∷ Msg → Update Model Msg Aff Unit
update Init = onKeyDown keyDownHandler
update Increment = modify_ (_ + 1)
update DelayedIncrement = do
    delay (Milliseconds 1000.0)
    modify_ (_ + 1)

spanCounter :: Int -> Html Msg
spanCounter v = H.span [] [H.text $ show v]

view ∷ Model → Html Msg
view counter =
  H.div []
    [ H.div [H.class_ "counter"] [H.text $ show counter]
    , H.button [E.onClick \_ → Increment] [H.text "Increment"]
    , H.button [E.onClick \_ → DelayedIncrement] [H.text "Delayed Increment"]
    , H.div []
        [ H.span [] [H.text "green when the counter is even"]
        , H.div
            [ H.class_ "box"
            , H.class' "even" (even counter)
            ] []
        ]

    , H.h3 [] [H.text "press I to increment the counter"]
    
    , H.hr []
    , H.h3 [] [H.text "keyed"]

    , H.keyed "div" [] $
        ((0 .. (counter `mod` 4)) <#> \i ->
            {key: "r" <> show i, html: H.text ("r" <> show i)}
        ) <> 
            [{key: "test", html: H.text "test"}]
          <>
            ((0 .. (counter `mod` 4)) <#> \i ->
                {key: "q" <> show i, html: H.text ("q" <> show i)}
            )
    , H.hr []
    , H.h3 [] [H.text "non keyed"]
    , H.div [] $
        ((0 .. (counter `mod` 4)) <#> H.text <<< show)
        <> [H.text "test"]
        <> ((0 .. (counter `mod` 4)) <#> H.text <<< show)
    , H.hr []
    , H.h3 [] [H.text "lazy"]
    , H.lazy spanCounter (counter / 2)

    , H.hr []
    , H.h3 [] [ H.text "duplicate" ]
    , H.div [] $
        replicate (counter `mod` 4) (H.text "t")
    ]

keyDownHandler ∷ String → Maybe Msg
keyDownHandler "i" = Just Increment
keyDownHandler _ = Nothing

main ∷ Effect Unit
main = app
  { init: {model, msg: Just Init}
  , view
  , update
  , eval: identity
  , selector: "#root"
  }