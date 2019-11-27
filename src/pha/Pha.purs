module Pha (h, text, emptyNode, key, attr, style, on_, class_, class', lazy,
    whenN, (<?>), maybeN, maybeN', (<??>), app, sandbox, unsafeOnWithEffect,
    VDom, Prop, Sub, Event, Document, InterpretEffs) where

import Prelude
import Effect (Effect)
import Pha.Action (Action, setState, GetState(..), SetState(..))
import Data.Maybe (Maybe(..), fromMaybe)
import Data.Tuple (Tuple(..))
import Run (VariantF, runCont, onMatch)
import Unsafe.Coerce (unsafeCoerce)

foreign import data VDom :: Type -> Type
foreign import data Event :: Type

type Document msg = {
    title :: String,
    body :: VDom msg
}

type EventHandler msg = Event -> {effect :: Effect Unit, msg :: Maybe msg}

foreign import data Sub :: Type -> Type

data Prop msg =
    Key String
  | Attr String String
  | Class String Boolean
  | Style String String
  | On String (EventHandler msg)

  
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

on_ :: ∀msg. String -> (Event -> Maybe msg) -> Prop msg 
on_ n handler = On n \ev -> {effect: pure unit, msg: handler ev}

unsafeOnWithEffect :: ∀msg. String -> EventHandler msg -> Prop msg
unsafeOnWithEffect = On

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
whenN :: ∀msg. Boolean -> (Unit -> VDom msg) -> VDom msg
whenN cond vdom = if cond then vdom unit else emptyNode

infix 1 whenN as <?>


-- | is equivalent to
-- |
-- | maybeN (Just vdom) = vdom
-- |
-- | maybeN Nothing = emptyNode

maybeN :: ∀msg. Maybe (VDom msg) -> VDom msg
maybeN = fromMaybe emptyNode

maybeN' :: ∀a msg. Maybe a -> (a -> VDom msg) -> VDom msg
maybeN' (Just a) f = f a
maybeN' Nothing _ = emptyNode

infix 1 maybeN' as <??>

foreign import mapView :: ∀a b. (EventHandler a -> EventHandler b) -> VDom a -> VDom b
instance functorVDom :: Functor VDom where
    map fn = mapView mapH where
        mapH handler ev = let {effect, msg} = handler ev in {effect, msg: map fn msg}
--viewOver lens = addDecorator (actionOver lens)

foreign import appAux :: ∀msg state. (Effect state -> (state -> Effect Unit) -> {
    state :: state,
    view :: state -> Document msg,
    node :: String,
    dispatch :: msg -> Effect Unit,
    dispatchEvent :: Event -> (EventHandler msg) -> Effect Unit,
    subscriptions :: state -> Array (Sub msg),
    init :: Effect Unit
}) -> Effect Unit


app :: ∀msg state effs. {
    init :: Tuple state (Action state effs),
    view :: state -> Document msg,
    update :: msg -> Action state effs,
    node :: String,
    subscriptions :: state -> Array (Sub msg),
    interpret :: InterpretEffs effs
} -> Effect Unit
app {init: Tuple state init, view, update, node, subscriptions, interpret} = appAux fn where
    fn getS setS =
        {state, view, node, init: init2, subscriptions, dispatch, dispatchEvent} where
        go = onMatch {
            getState: \(GetState cont) -> getS >>= cont,
            setState: \(SetState f cont) -> (getS >>= (f >>> setS)) *> cont
        } interpret
        runAction :: Action state effs -> Effect Unit 
        runAction = runCont go (\_ -> pure unit)

        dispatch :: msg -> Effect Unit
        dispatch = runAction <<< update

        dispatchEvent :: Event -> (EventHandler msg) -> Effect Unit
        dispatchEvent = \ev handler -> do
            let {effect, msg} = handler ev
            effect
            case msg of
                Nothing -> pure unit
                Just m -> dispatch m
        
        init2 = runAction init 

sandbox :: ∀msg state. {
    init :: state,
    view :: state -> VDom msg,
    update :: msg -> state -> state,
    node :: String
} -> Effect Unit

sandbox {init, view, update, node} =
    app 
        {   init: Tuple init (pure unit)
        ,   view: \st -> {title: "app", body: view st}
        ,   update: \msg -> setState (update msg)
        ,   node
        ,   subscriptions: const []
        ,   interpret: \_ -> pure unit
        }

type InterpretEffs effs = VariantF effs (Effect Unit) -> Effect Unit
