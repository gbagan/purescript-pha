module Pha.Event (shiftKey, key, button, stopPropagation, preventDefault, targetChecked, targetValue, EVENT, eventEffect, EventF) where
import Prelude
import Pha (Event)
import Run (Run, SProxy(..), FProxy, lift)
import Data.Maybe (Maybe(..))
import Effect (Effect)

foreign import unsafeToMaybeAux :: ∀a. Maybe a -> (a -> Maybe a) -> a -> Maybe a
unsafeToMaybe :: ∀a. a -> Maybe a
unsafeToMaybe = unsafeToMaybeAux Nothing Just

foreign import shiftKey :: Event -> Boolean

foreign import unsafeKey :: Event -> String
key :: Event -> Maybe String
key = unsafeToMaybe <<< unsafeKey

foreign import unsafeButton :: Event -> Int
button :: Event -> Maybe Int
button = unsafeToMaybe <<< unsafeButton

foreign import data EventTarget :: Type

data EventF a =
      PreventDefault Event a
    | StopPropagation Event a
--    | Target Event (EventTarget -> a)
--    | CurrentTarget Event (EventTarget -> a)
    | TargetChecked Event (Maybe Boolean -> a)
    | TargetValue Event (Maybe String -> a)
derive instance functorEventF :: Functor EventF
type EVENT = FProxy EventF

preventDefault :: ∀r. Event -> Run (event :: EVENT | r) Unit
preventDefault ev = lift (SProxy :: SProxy "event") (PreventDefault ev unit)
stopPropagation :: ∀r. Event -> Run (event :: EVENT | r) Unit
stopPropagation ev = lift (SProxy :: SProxy "event") (StopPropagation ev unit)
targetChecked :: ∀r. Event -> Run (event :: EVENT | r) (Maybe Boolean)
targetChecked ev = lift (SProxy :: SProxy "event") (TargetChecked ev identity)
targetValue :: ∀r. Event -> Run (event :: EVENT | r) (Maybe String)
targetValue ev = lift (SProxy :: SProxy "event") (TargetValue ev identity)

foreign import preventDefaultE :: Event -> Effect Unit
foreign import stopPropagationE :: Event -> Effect Unit
--foreign import target :: Event -> EventTarget
--foreign import currentTargetE :: Event -> EventTarget
foreign import unsafeTargetCheckedE :: Event -> Effect Boolean
foreign import unsafeTargetValueE :: Event -> Effect String

eventEffect :: EventF (Effect Unit) -> Effect Unit
eventEffect (PreventDefault ev cont) = preventDefaultE ev *> cont
eventEffect (StopPropagation ev cont) = stopPropagationE ev *> cont
--eventEffect (Target ev cont) = targetE ev >>= cont
--eventEffect (CurrentTarget ev cont) = currentTargetE ev >>= cont
eventEffect (TargetChecked ev cont) = unsafeToMaybe <$> (unsafeTargetCheckedE ev) >>= cont
eventEffect (TargetValue ev cont) = unsafeToMaybe <$> (unsafeTargetValueE ev) >>= cont