module Pha.Event (key) where
import Prelude
import Pha (Event)
import Data.Maybe (Maybe(..))

foreign import unsafeToMaybeAux :: ∀a. Maybe a -> (a -> Maybe a) -> a -> Maybe a
unsafeToMaybe :: ∀a. a -> Maybe a
unsafeToMaybe = unsafeToMaybeAux Nothing Just

foreign import unsafeKey :: Event -> String
key :: Event -> Maybe String
key = unsafeToMaybe <<< unsafeKey

