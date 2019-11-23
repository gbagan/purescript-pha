module Pha.Event (preventDefault, shiftKey, key) where
import Prelude
import Pha (Event)
import Data.Maybe (Maybe(..))
import Effect (Effect)

foreign import unsafeToMaybeAux :: ∀a. Maybe a -> (a -> Maybe a) -> a -> Maybe a
unsafeToMaybe :: ∀a. a -> Maybe a
unsafeToMaybe = unsafeToMaybeAux Nothing Just

foreign import shiftKey :: Event -> Boolean
foreign import unsafeKey :: Event -> String
key :: Event -> Maybe String
key = unsafeToMaybe <<< unsafeKey

foreign import preventDefault :: Event -> Effect Unit
