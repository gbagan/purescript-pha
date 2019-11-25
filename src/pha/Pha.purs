module Pha (h, text, emptyNode, key, attr, style, on, class_, class', lazy, ifN, maybeN, app, Event, Prop, VDom, InterpretEffs) where

import Prelude
import Effect (Effect)
import Pha.Action (Action, GetState(..), SetState(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple(..))
import Run (VariantF, runCont, onMatch)

foreign import data VDom :: Type -> Type
foreign import data Event :: Type

data Prop msg =
    Key String
  | Attr String String
  | Class String Boolean
  | Style String String
  | On String (Event -> Maybe msg)

  
-- | add a key to the vnode
key :: ∀msg. String -> Prop msg
key = Key
  
-- | add or change an attribute
attr :: ∀msg. String -> String -> Prop msg
attr = Attr
  
-- | add a class name to the vnode
class_ :: ∀msg. String -> Prop msg
class_ name = Class name true
  
-- | add a class name to the vnode if the second argument is true
class' :: ∀msg. String -> Boolean -> Prop msg
class' = Class

on :: ∀msg. String -> (Event -> Maybe msg) -> Prop msg 
on = On

-- | add or change a style attribute
style :: ∀msg. String -> String -> Prop msg
style = Style
  
isStyle :: ∀msg. Prop msg -> Boolean
isStyle (Style _ _) = true
isStyle _ = false

foreign import hAux :: ∀msg. (Prop msg -> Boolean) -> String -> Array (Prop msg) -> Array (VDom msg) -> VDom msg

-- | create a virtual node with the given tag name, the given array of attributes and the given array of children
h :: ∀msg. String -> Array (Prop msg) -> Array (VDom msg) -> VDom msg
h = hAux isStyle

-- | create a text virtual node
foreign import text :: ∀msg. String -> VDom msg

-- | represent an empty virtual node
-- | 
-- | does not generate HTML content. Only used for commodity
foreign import emptyNode :: ∀msg. VDom msg

-- | lazily generate a virtual dom
-- |
-- | i.e. generate only if the first argument has changed.
-- | otherwise, return the previous generated virtual dom
foreign import lazy :: ∀a msg. a -> (a -> VDom msg) -> VDom msg

-- | return a virtual dom only if the first argument is true
-- | otherwise, return an empty virtual node
ifN :: ∀msg. Boolean -> (Unit -> VDom msg) -> VDom msg
ifN cond vdom = if cond then vdom unit else emptyNode

-- | is equivalent to
-- |
-- | maybeN (Just vdom) = vdom
-- |
-- | maybeN Nothing = emptyNode

maybeN :: ∀msg. Maybe (VDom msg) -> VDom msg
maybeN = fromMaybe emptyNode

foreign import mapView :: ∀a b. (Maybe a -> Maybe b) -> VDom a -> VDom b
instance functorVDom :: Functor VDom where
    map fn = mapView (map fn)
--viewOver lens = addDecorator (actionOver lens)

foreign import appAux :: ∀msg state. (Effect state -> (state -> Effect Unit) -> {
    state :: state,
    view :: state -> VDom msg,
    node :: String,
    dispatch :: Event -> (Event -> Maybe msg) -> Effect Unit,
    events :: Array (Tuple String (Event -> Effect Unit)),
    init :: Effect Unit
}) -> Effect Unit


app :: ∀msg state effs. {
    state :: state,
    view :: state -> VDom msg,
    update :: msg -> Action state effs,
    node :: String,
    events :: Array (Tuple String (Event -> Action state effs)),
    init :: Action state effs,
    interpret :: InterpretEffs effs
} -> Effect Unit
app {state, view, update, node, events, init, interpret} = appAux fn where
    fn getS setS =
        {state, view, node, init: init2, events: events2, dispatch} where
        go = onMatch {
            getState: \(GetState cont) -> getS >>= cont,
            setState: \(SetState fn cont) -> (getS >>= (fn >>> setS)) *> cont
        } interpret
        runAction :: Action state effs -> Effect Unit 
        runAction = runCont go (\_ -> pure unit)

        dispatch = \ev handler ->
            case handler ev of
                Nothing -> pure unit
                Just msg -> runAction (update msg)
        
        init2 = runAction init
        events2 = events <#> \(Tuple name handler) -> Tuple name \ev -> runAction (handler ev)      


type InterpretEffs effs = VariantF effs (Effect Unit) -> Effect Unit

type Dispatch = ∀st effs. Effect st -> ((st -> st) -> Effect Unit) -> InterpretEffs effs -> Action st effs -> Effect Unit
dispatch :: Dispatch
dispatch getS setS matching = runCont go (\_ -> pure unit) where
    go = onMatch {
        getState: \(GetState cont) -> getS >>= cont,
        setState: \(SetState fn cont) -> setS fn *> cont
    } matching