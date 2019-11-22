module Pha.Event where
import Prelude
import Pha.Action (Event)
import Data.Maybe (Maybe(..))
import Effect (Effect)
infixr 9 compose as ∘

foreign import unsafeToMaybeAux :: ∀a. Maybe a -> (a -> Maybe a) -> a -> Maybe a
unsafeToMaybe :: ∀a. a -> Maybe a
unsafeToMaybe = unsafeToMaybeAux Nothing Just

foreign import shiftKey :: Event -> Boolean
foreign import unsafeKey :: Event -> String
key :: Event -> Maybe String
key = unsafeToMaybe ∘ unsafeKey

foreign import preventDefault :: Event -> Effect Unit
