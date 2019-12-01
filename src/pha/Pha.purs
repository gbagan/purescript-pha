module Pha (VDom, Prop, Sub, Event, Transition, h, text, emptyNode, key, attr, style, on_, class_, class', lazy,
    when, (<&&>), maybeN, maybe, (<??>), purely, unsafeOnWithEffect, module I,
      EventHandler) where

import Prelude hiding (when)
import Effect (Effect)
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple(..))
import Data.Tuple.Nested((/\)) as I

foreign import data VDom ∷ Type → Type
foreign import data Event ∷ Type

type EventHandler msg = Event → {effect ∷ Effect Unit, msg ∷ Maybe msg}

foreign import data Sub ∷ Type → Type

foreign import data Prop ∷ Type → Type
  
-- | add a key to the vnode
foreign import key ∷ ∀msg. String → Prop msg
  
-- | add or change an attribute
foreign import attr ∷ ∀msg. String → String → Prop msg
  
-- | add a class name to the vnode
foreign import class_ ∷ ∀msg. String → Prop msg

foreign import noProp ∷ ∀msg. Prop msg
-- | add a class name to the vnode if the second argument is true
class' ∷ ∀msg. String → Boolean → Prop msg
class' c b = if b then class_ c else noProp

foreign import unsafeOnWithEffect ∷ ∀msg. String → EventHandler msg → Prop msg

on_ ∷ ∀msg. String → (Event → Maybe msg) → Prop msg 
on_ n handler = unsafeOnWithEffect n \ev → {effect: pure unit, msg: handler ev}

-- | add or change a style attribute
foreign import style ∷ ∀msg. String → String → Prop msg

-- | h tag attributes children
foreign import h ∷ ∀msg. String → Array (Prop msg) → Array (VDom msg) → VDom msg

-- | create a text virtual node
foreign import text ∷ ∀msg. String → VDom msg

-- | represent an empty virtual node
-- | 
-- | does not generate HTML content. Only used for commodity
foreign import emptyNode ∷ ∀msg. VDom msg

-- | lazily generate a virtual dom
-- |
-- | i.e. generate only if the first argument has changed.
-- | otherwise, return the previous generated virtual dom
foreign import lazy ∷ ∀a msg. a → (a → VDom msg) → VDom msg

-- | ```purescript
-- | when true = vdom unit
-- | when false = emptyNode
-- | ```
when ∷ ∀msg. Boolean → (Unit → VDom msg) → VDom msg
when cond vdom = if cond then vdom unit else emptyNode

infix 1 when as <&&>


-- | ```purescript
-- | maybeN (Just vdom) = vdom
-- | maybeN Nothing = emptyNode
-- | ```
maybeN ∷ ∀msg. Maybe (VDom msg) → VDom msg
maybeN = fromMaybe emptyNode

maybe ∷ ∀a msg. Maybe a → (a → VDom msg) → VDom msg
maybe (Just a) f = f a
maybe Nothing _ = emptyNode

infix 1 maybe as <??>

type Transition model msg effs  = Tuple model (Array(effs msg))

purely :: forall model msg effs. model → Transition model msg effs
purely model = Tuple model []

foreign import mapView ∷ ∀a b. (EventHandler a → EventHandler b) → VDom a → VDom b
instance functorVDom ∷ Functor VDom where
    map fn = mapView mapH where
        mapH handler ev = let {effect, msg} = handler ev in {effect, msg: map fn msg}
