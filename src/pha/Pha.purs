module Pha (h, text, emptyNode, key, attr, style, on, class_, class', lazy, ifN, maybeN, app, Event, Prop, VDom, InterpretEffs) where

import Prelude
import Effect (Effect)
import Pha.Action (Action, GetState(..), SetState(..))
import Data.Maybe (Maybe, fromMaybe)
import Data.Tuple (Tuple)
import Run (VariantF, runCont, onMatch)

foreign import data VDom :: Type -> #Type -> Type
foreign import data Event :: Type

data Prop st effs =
    Key String
  | Attr String String
  | Class String Boolean
  | Style String String
  | On String (Event -> Action st effs)

  
-- | add a key to the vnode
key :: ∀a effs. String -> Prop a effs
key = Key
  
-- | add or change an attribute
attr :: ∀a effs. String -> String -> Prop a effs
attr n v = Attr n v
  
-- | add a class name to the vnode
class_ :: ∀a effs. String -> Prop a effs
class_ name = Class name true
  
-- | add a class name to the vnode if the second argument is true
class' :: ∀a effs. String -> Boolean -> Prop a effs
class' = Class

on :: ∀a effs. String -> (Event -> Action a effs) -> Prop a effs 
on = On

-- | add or change a style attribute
style :: ∀a effs. String -> String -> Prop a effs
style n v = Style n v
  

isStyle :: ∀st effs. Prop st effs -> Boolean
isStyle (Style _ _) = true
isStyle _ = false

foreign import hAux :: ∀st effs. (Prop st effs -> Boolean) -> String -> Array (Prop st effs) -> Array (VDom st effs) -> VDom st effs

-- | create a virtual node with the given tag name, the given array of attributes and the given array of children
h :: ∀st effs. String -> Array (Prop st effs) -> Array (VDom st effs) -> VDom st effs
h = hAux isStyle

-- | create a text virtual node
foreign import text :: ∀a effs. String -> VDom a effs

-- | represent an empty virtual node
-- | 
-- | does not generate HTML content. Only used for commodity
foreign import emptyNode :: ∀a effs. VDom a effs

-- | lazily generate a virtual dom
-- |
-- | i.e. generate only if the first argument has changed.
-- | otherwise, return the previous generated virtual dom
foreign import lazy :: ∀a b effs. b -> (b -> VDom a effs) -> VDom a effs

-- | return a virtual dom only if the first argument is true
-- | otherwise, return an empty virtual node
ifN :: ∀a effs. Boolean -> (Unit -> VDom a effs) -> VDom a effs
ifN cond vdom = if cond then vdom unit else emptyNode

-- | is equivalent to
-- |
-- | maybeN (Just vdom) = vdom
-- |
-- | maybeN Nothing = emptyNode

maybeN :: ∀a effs. Maybe (VDom a effs) -> VDom a effs
maybeN = fromMaybe emptyNode

foreign import appAux :: ∀a effs. Dispatch -> {
    state :: a,
    view :: a -> VDom a effs,
    node :: String,
    events :: Array (Tuple String (Event -> Action a effs)),
    init :: Action a effs,
    effects :: InterpretEffs effs
} -> Effect Unit


app :: ∀a effs. {
    state :: a,
    view :: a -> VDom a effs,
    node :: String,
    events :: Array (Tuple String (Event -> Action a effs)),
    init :: Action a effs,
    effects :: InterpretEffs effs
} -> Effect Unit
app = appAux dispatch


type InterpretEffs effs = VariantF effs (Effect Unit) -> Effect Unit

type Dispatch = ∀st effs. Effect st -> ((st -> st) -> Effect Unit) -> InterpretEffs effs -> Action st effs -> Effect Unit
dispatch :: Dispatch
dispatch getS setS matching = runCont go (\_ -> pure unit) where
    go = onMatch {
        getState: \(GetState cont) -> getS >>= cont,
        setState: \(SetState fn cont) -> setS fn *> cont
    } matching