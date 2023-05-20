module Pha.Html.Core
  ( EventHandler
  , Html
  , KeyedHtml
  , Prop
  , elem
  , keyed
  , text
  , attr
  , prop
  , noProp
  , style
  , class_
  , class'
  , empty
  , lazy
  , lazy2
  , lazy3
  , lazy4
  , lazy5
  , when
  , fromMaybe
  , maybe
  , on_
  , unsafeOnWithEffect
  , module E
  )
  where
import Prelude hiding (when)
import Effect (Effect)
import Data.Function.Uncurried (Fn2, Fn3, Fn4, Fn5, Fn6, mkFn2, mkFn3, mkFn4, mkFn5, runFn2, runFn3, runFn4, runFn5, runFn6)
import Data.Maybe (Maybe)
import Data.Maybe as M
import Web.Event.Event (Event) as E
import Web.Event.Event (Event)

foreign import data Html ∷ Type → Type
type KeyedHtml a = {key ∷ String, html ∷ Html a}

type EventHandler msg = Event → Effect (Maybe msg)

foreign import data Prop ∷ Type → Type
  
-- | Create a HTML attribute.
attr ∷ ∀msg. String → String → Prop msg
attr key val = runFn2 attrImpl key val

-- | Create a HTML property.
prop ∷ ∀msg value. String → value → Prop msg
prop key val = runFn2 propImpl key val

foreign import attrImpl ∷ ∀msg. Fn2 String String (Prop msg)

foreign import propImpl ∷ ∀msg value. Fn2 String value (Prop msg)

-- | Create a CSS class.
foreign import class_ ∷ ∀msg. String → Prop msg

foreign import noProp ∷ ∀msg. Prop msg

-- | Create a CSS class if the boolean is True.
class' ∷ ∀msg. String → Boolean → Prop msg
class' c b = if b then class_ c else noProp

foreign import unsafeOnWithEffectImpl ∷ ∀msg. Fn2 String (EventHandler msg) (Prop msg)

unsafeOnWithEffect ∷ ∀msg. String → EventHandler msg → Prop msg
unsafeOnWithEffect name handler = runFn2 unsafeOnWithEffectImpl name handler
 
on_ ∷ ∀msg. String → (Event → Maybe msg) → Prop msg 
on_ n handler = unsafeOnWithEffect n \ev → pure (handler ev)

-- | Create a CSS property.
style ∷ ∀msg. String → String → Prop msg
style key val = runFn2 styleImpl key val

foreign import styleImpl ∷ ∀msg. Fn2 String String (Prop msg)

-- | Create a HTML element.
elem ∷ ∀msg. String → Array (Prop msg) → Array (Html msg) → Html msg
elem name attrs children = runFn3 elemImpl name attrs children

foreign import elemImpl ∷ ∀msg. Fn3 String (Array (Prop msg)) (Array (Html msg)) (Html msg)

-- | Create a HTML element where children are keyed.
keyed ∷ ∀msg. String → Array (Prop msg) → Array (KeyedHtml msg) → Html msg
keyed name attrs children = runFn3 keyedImpl name attrs children

foreign import keyedImpl ∷ ∀msg. Fn3 String (Array (Prop msg)) (Array (KeyedHtml msg)) (Html msg)

-- | Create a text node HTML value.
foreign import text ∷ ∀msg. String → Html msg

-- | Create a empty HTML value.
empty ∷ ∀msg. Html msg
empty = text ""


-- | Creates a lazy node.
-- |
-- | Lazy nodes are only updated if the parameter changes (compared by reference)
lazy ∷ ∀a msg. (a → Html msg) → a → Html msg
lazy f a = runFn2 lazyImpl f a

-- | Same as `lazy` but checks on two arguments.
lazy2 ∷ ∀a b msg. (a → b → Html msg) → a → b → Html msg
lazy2 f a b = runFn3 lazy2Impl (mkFn2 f) a b

-- | Same as `lazy` but checks on three arguments.
lazy3 ∷ ∀a b c msg. (a → b → c → Html msg) → a → b → c → Html msg
lazy3 f a b c = runFn4 lazy3Impl (mkFn3 f) a b c

-- | Same as `lazy` but checks on four arguments.
lazy4 ∷ ∀a b c d msg. (a → b → c → d → Html msg) → a → b → c → d → Html msg
lazy4 f a b c d = runFn5 lazy4Impl (mkFn4 f) a b c d

-- | Same as `lazy` but checks on five arguments.
lazy5 ∷ ∀a b c d e msg. (a → b → c → d → e → Html msg) → a → b → c → d → e → Html msg
lazy5 f a b c d = runFn6 lazy5Impl (mkFn5 f) a b c d

foreign import lazyImpl ∷ ∀a msg. Fn2 (a → Html msg) a (Html msg)
foreign import lazy2Impl ∷ ∀a b msg. Fn3 (Fn2 a b (Html msg)) a b (Html msg)
foreign import lazy3Impl ∷ ∀a b c msg. Fn4 (Fn3 a b c (Html msg)) a b c (Html msg)
foreign import lazy4Impl ∷ ∀a b c d msg. Fn5 (Fn4 a b c d (Html msg)) a b c d (Html msg)
foreign import lazy5Impl ∷ ∀a b c d e msg. Fn6 (Fn5 a b c d e (Html msg)) a b c d e (Html msg)

-- | Create a VDOM tree only if the boolean is True
when ∷ ∀msg. Boolean → (Unit → Html msg) → Html msg
when cond vdom = if cond then vdom unit else empty

-- | ```purescript
-- | fromMaybe (Just html) = html
-- | fromMaybe Nothing = empty
-- | ```
fromMaybe ∷ ∀msg. Maybe (Html msg) → Html msg
fromMaybe = M.fromMaybe empty

maybe ∷ ∀a msg. Maybe a → (a → Html msg) → Html msg
maybe = flip (M.maybe empty)

mapHandler :: ∀a b. (a → b) → EventHandler a → EventHandler b
mapHandler fn handler ev = map (map fn) (handler ev)

foreign import mapProp ∷ ∀a b. Fn2 (EventHandler a → EventHandler b) (Prop a) (Prop b)

instance Functor Prop where
  map fn pr = runFn2 mapProp (mapHandler fn) pr

foreign import mapView ∷ ∀a b. Fn2 (EventHandler a → EventHandler b) (Html a) (Html b)

instance Functor Html where
  map fn html = runFn2 mapView (mapHandler fn) html
