module Pha (VDom, Prop, Sub, h, text, emptyNode, key, attr, style, on_, class_, class', memo,
    when, maybeN, maybe, unsafeOnWithEffect, module E,
      EventHandler) where
import Prelude hiding (when)
import Effect (Effect)
import Data.Maybe (Maybe(..), fromMaybe)
import Web.Event.Event (Event) as E
import Web.Event.Event (Event)
foreign import data VDom ∷ Type → Type

type EventHandler msg = Event → Effect (Maybe msg)

foreign import data Sub ∷ Type → Type
foreign import data Prop ∷ Type → Type
  
-- | adds a key to the vnode
foreign import key ∷ ∀msg. String → Prop msg
  
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

-- | adds or changes a style attribute
foreign import style ∷ ∀msg. String → String → Prop msg

-- | h tag attributes children
foreign import h ∷ ∀msg. String → Array (Prop msg) → Array (VDom msg) → VDom msg

-- | creates a text virtual node
foreign import text ∷ ∀msg. String → VDom msg

-- | represents an empty virtual node
-- | 
-- | does not generate HTML content. Only used for commodity
foreign import emptyNode ∷ ∀msg. VDom msg

-- | lazily generates a virtual dom
-- |
-- | i.e. generates only if the first argument has changed.
-- | otherwise, return the previous generated virtual dom
foreign import memo ∷ ∀a msg. a → (a → VDom msg) → VDom msg

-- | ```purescript
-- | when true f = f unit
-- | when false f = emptyNode
-- | ```
when ∷ ∀msg. Boolean → (Unit → VDom msg) → VDom msg
when cond vdom = if cond then vdom unit else emptyNode

-- | ```purescript
-- | maybeN (Just vdom) = vdom
-- | maybeN Nothing = emptyNode
-- | ```
maybeN ∷ ∀msg. Maybe (VDom msg) → VDom msg
maybeN = fromMaybe emptyNode

maybe ∷ ∀a msg. Maybe a → (a → VDom msg) → VDom msg
maybe (Just a) f = f a
maybe Nothing _ = emptyNode

    
foreign import mapView ∷ ∀a b. (EventHandler a → EventHandler b) → VDom a → VDom b
instance functorVDom ∷ Functor VDom where
    map fn = mapView mapH where
        mapH handler ev = do
            msg <- handler ev
            pure (map fn msg)
