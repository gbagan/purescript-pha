module Pha (VDom, Prop, Sub, h, keyed, text, attr, style, on_, class_, class', lazy,
    when, maybeN, maybe, unsafeOnWithEffect, module E,
      EventHandler) where
import Prelude hiding (when)
import Effect (Effect)
import Data.Maybe (Maybe(..), fromMaybe)
import Web.Event.Event (Event) as E
import Web.Event.Event (Event)
import Data.Tuple (Tuple)
foreign import data VDom ∷ Type → Type

type EventHandler msg = Event → Effect (Maybe msg)

foreign import data Sub ∷ Type → Type
foreign import data Prop ∷ Type → Type
  
-- | adds or changes an attribute
foreign import attr ∷ ∀msg. String → String → Prop msg
  
-- | adds a class name to the vnode
foreign import class_ ∷ ∀msg. String → Prop msg

foreign import noProp ∷ ∀msg. Prop msg
-- | adds a class name to the vnode if the second argument is true
class' ∷ ∀msg. String → Boolean → Prop msg
class' c b = if b then class_ c else noProp

foreign import unsafeOnWithEffect ∷ ∀msg. String → EventHandler msg → Prop msg

on_ ∷ ∀msg. String → (Event → Maybe msg) → Prop msg 
on_ n handler = unsafeOnWithEffect n \ev → pure (handler ev)

foreign import style ∷ ∀msg. String → String → Prop msg

foreign import h ∷ ∀msg. String → Array (Prop msg) → Array (VDom msg) → VDom msg

foreign import keyed ∷ ∀msg. String → Array (Prop msg) → Array (Tuple String (VDom msg)) → VDom msg

foreign import text ∷ ∀msg. String → VDom msg

empty ∷ ∀msg. VDom msg
empty = text ""

foreign import lazy ∷ ∀a msg. (a → VDom msg) → a → VDom msg
foreign import lazy2 ∷ ∀a b msg. (a → b → VDom msg) → a → b → VDom msg
foreign import lazy3 ∷ ∀a b c msg. (a → b → c → VDom msg) → a → b → c → VDom msg

-- | ```purescript
-- | when true f = f unit
-- | when false f = text ""
-- | ```
when ∷ ∀msg. Boolean → (Unit → VDom msg) → VDom msg
when cond vdom = if cond then vdom unit else empty

-- | ```purescript
-- | maybeN (Just vdom) = vdom
-- | maybeN Nothing = text ""
-- | ```
maybeN ∷ ∀msg. Maybe (VDom msg) → VDom msg
maybeN = fromMaybe empty

maybe ∷ ∀a msg. Maybe a → (a → VDom msg) → VDom msg
maybe (Just a) f = f a
maybe Nothing _ = empty

    
foreign import mapView ∷ ∀a b. (EventHandler a → EventHandler b) → VDom a → VDom b
instance functorVDom ∷ Functor VDom where
    map fn = mapView mapH where
        mapH handler ev = do
            msg <- handler ev
            pure (map fn msg)
