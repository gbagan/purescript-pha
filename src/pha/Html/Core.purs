module Pha.Html.Core
  ( EventHandler
  , Prop
  , Html
  , KeyedHtml
  , attr
  , class'
  , class_
  , elem
  , empty
  , fromMaybe
  , keyed
  , lazy
  , lazy2
  , lazy3
  , maybe
  , module E
  , on_
  , style
  , text
  , unsafeOnWithEffect
  , when
  )
  where
import Prelude hiding (when)
import Effect (Effect)
import Data.Maybe (Maybe(..))
import Data.Maybe as M
import Web.Event.Event (Event) as E
import Web.Event.Event (Event)

foreign import data Html ∷ Type → Type
type KeyedHtml a = {key ∷ String, html ∷ Html a}

type EventHandler msg = Event → Effect (Maybe msg)

foreign import data Prop ∷ Type → Type
  
foreign import attr ∷ ∀msg. String → String → Prop msg
  
foreign import class_ ∷ ∀msg. String → Prop msg

foreign import noProp ∷ ∀msg. Prop msg

class' ∷ ∀msg. String → Boolean → Prop msg
class' c b = if b then class_ c else noProp

foreign import unsafeOnWithEffect ∷ ∀msg. String → EventHandler msg → Prop msg

on_ ∷ ∀msg. String → (Event → Maybe msg) → Prop msg 
on_ n handler = unsafeOnWithEffect n \ev → pure (handler ev)

foreign import style ∷ ∀msg. String → String → Prop msg

foreign import elem ∷ ∀msg. String → Array (Prop msg) → Array (Html msg) → Html msg

foreign import keyed ∷ ∀msg. String → Array (Prop msg) → Array (KeyedHtml msg) → Html msg

foreign import text ∷ ∀msg. String → Html msg

empty ∷ ∀msg. Html msg
empty = text ""

foreign import lazy ∷ ∀a msg. (a → Html msg) → a → Html msg
foreign import lazy2 ∷ ∀a b msg. (a → b → Html msg) → a → b → Html msg
foreign import lazy3 ∷ ∀a b c msg. (a → b → c → Html msg) → a → b → c → Html msg

-- | ```purescript
-- | when true f = f unit
-- | when false f = empty
-- | ```
when ∷ ∀msg. Boolean → (Unit → Html msg) → Html msg
when cond vdom = if cond then vdom unit else empty

-- | ```purescript
-- | maybeN (Just html) = html
-- | maybeN Nothing = empty
-- | ```
fromMaybe ∷ ∀msg. Maybe (Html msg) → Html msg
fromMaybe = M.fromMaybe empty

maybe ∷ ∀a msg. Maybe a → (a → Html msg) → Html msg
maybe (Just a) f = f a
maybe Nothing _ = empty
    
foreign import mapView ∷ ∀a b. (EventHandler a → EventHandler b) → Html a → Html b

instance functorHtml ∷ Functor Html where
    map fn = mapView mapH where
        mapH handler ev = do
            msg ← handler ev
            pure (map fn msg)
