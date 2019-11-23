module Pha (Event, Prop(..), InterpretEffs, VDom, h, text, emptyNode, lazy, ifN, maybeN, app) where

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
  | Event String (Event -> Action st effs)

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