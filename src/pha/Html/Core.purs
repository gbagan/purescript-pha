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
import Data.Function.Uncurried (Fn2, Fn3, Fn4, runFn2, runFn3, runFn4)
import Data.Maybe (Maybe(..))
import Data.Maybe as M
import Web.Event.Event (Event) as E
import Web.Event.Event (Event)

foreign import data Html ∷ Type → Type
type KeyedHtml a = {key ∷ String, html ∷ Html a}

type EventHandler msg = Event → Effect (Maybe msg)

foreign import data Prop ∷ Type → Type
  

attr ∷ ∀msg. String → String → Prop msg
attr key val = runFn2 attrImpl key val

foreign import attrImpl ∷ ∀msg. Fn2 String String (Prop msg)

foreign import class_ ∷ ∀msg. String → Prop msg

foreign import noProp ∷ ∀msg. Prop msg

class' ∷ ∀msg. String → Boolean → Prop msg
class' c b = if b then class_ c else noProp

foreign import unsafeOnWithEffectImpl ∷ ∀msg. Fn2 String (EventHandler msg) (Prop msg)

unsafeOnWithEffect ∷ ∀msg. String → EventHandler msg → Prop msg
unsafeOnWithEffect name handler = runFn2 unsafeOnWithEffectImpl name handler
 
on_ ∷ ∀msg. String → (Event → Maybe msg) → Prop msg 
on_ n handler = unsafeOnWithEffect n \ev → pure (handler ev)

style ∷ ∀msg. String → String → Prop msg
style key val = runFn2 styleImpl key val

foreign import styleImpl ∷ ∀msg. Fn2 String String (Prop msg)

elem ∷ ∀msg. String → Array (Prop msg) → Array (Html msg) → Html msg
elem name attrs children = runFn3 elemImpl name attrs children

foreign import elemImpl ∷ ∀msg. Fn3 String (Array (Prop msg)) (Array (Html msg)) (Html msg)

keyed ∷ ∀msg. String → Array (Prop msg) → Array (KeyedHtml msg) → Html msg
keyed name attrs children = runFn3 keyedImpl name attrs children

foreign import keyedImpl ∷ ∀msg. Fn3 String (Array (Prop msg)) (Array (KeyedHtml msg)) (Html msg)

foreign import text ∷ ∀msg. String → Html msg

empty ∷ ∀msg. Html msg
empty = text ""

lazy ∷ ∀a msg. (a → Html msg) → a → Html msg
lazy f a = runFn2 lazyImpl f a

lazy2 ∷ ∀a b msg. (a → b → Html msg) → a → b → Html msg
lazy2 f a b = runFn3 lazy2Impl f a b

lazy3 ∷ ∀a b c msg. (a → b → c → Html msg) → a → b → c → Html msg
lazy3 f a b c = runFn4 lazy3Impl f a b c

foreign import lazyImpl ∷ ∀a msg. Fn2 (a → Html msg) a (Html msg)
foreign import lazy2Impl ∷ ∀a b msg. Fn3 (a → b → Html msg) a b (Html msg)
foreign import lazy3Impl ∷ ∀a b c msg. Fn4 (a → b → c → Html msg) a b c (Html msg)

-- | ```purescript
-- | when true f = f unit
-- | when false f = empty
-- | ```
when ∷ ∀msg. Boolean → (Unit → Html msg) → Html msg
when cond vdom = if cond then vdom unit else empty

-- | ```purescript
-- | fromMaybe (Just html) = html
-- | fromMaybe Nothing = empty
-- | ```
fromMaybe ∷ ∀msg. Maybe (Html msg) → Html msg
fromMaybe = M.fromMaybe empty

maybe ∷ ∀a msg. Maybe a → (a → Html msg) → Html msg
maybe (Just a) f = f a
maybe Nothing _ = empty
    
foreign import mapView ∷ ∀a b. Fn2 (EventHandler a → EventHandler b) (Html a) (Html b)

instance functorHtml ∷ Functor Html where
    map fn html = runFn2 mapView mapH html where
        mapH handler ev = do
            msg ← handler ev
            pure (map fn msg)
