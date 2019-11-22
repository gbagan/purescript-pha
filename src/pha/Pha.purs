module Pha where

import Prelude
import Effect (Effect)
import Pha.Action (Action, Event, GetState(..), SetState(..))
import Data.Maybe (Maybe, fromMaybe)
import Data.Tuple (Tuple)
import Run (VariantF, runCont, onMatch)

foreign import data VDom :: Type -> #Type -> Type

data Prop st effs =
    Key String
  | Attr String String
  | Class String Boolean
  | Style String String
  | Event String (Action st effs)

isStyle :: ∀st effs. Prop st effs -> Boolean
isStyle (Style _ _) = true
isStyle _ = false

foreign import hAux :: ∀st effs. (Prop st effs -> Boolean) -> String -> Array (Prop st effs) -> Array (VDom st effs) -> VDom st effs
h :: ∀st effs. String -> Array (Prop st effs) -> Array (VDom st effs) -> VDom st effs
h = hAux isStyle

foreign import text :: ∀a effs. String -> VDom a effs

foreign import emptyNode :: ∀a effs. VDom a effs

ifN :: ∀a effs. Boolean -> (Unit -> VDom a effs) -> VDom a effs
ifN cond vdom = if cond then vdom unit else emptyNode

maybeN :: ∀a effs. Maybe (VDom a effs) -> VDom a effs
maybeN = fromMaybe emptyNode

-- type Match effs = -- ∀rl r1 r2 a. RowToList effs rl => VariantFMatchCases rl r1 a (Effect Unit) => Union r1 () r2 =>
--   Record effs -- -> VariantF r2 a -> b} -> Effect Unit
type InterpretEffs effs = VariantF effs (Effect Unit) -> Effect Unit

type Dispatch = ∀st effs. Effect st -> ((st -> st) -> Effect Unit) -> InterpretEffs effs -> Action st effs -> Effect Unit
dispatch :: Dispatch
dispatch getS setS matching = runCont go (\_ -> pure unit) where
    go = onMatch {
        getState: \(GetState cont) -> getS >>= cont,
        setState: \(SetState fn cont) -> setS fn *> cont
    } matching


foreign import appAux :: ∀a effs. Dispatch -> {
    state :: a,
    view :: a -> VDom a effs,
    node :: String,
    events :: Array (Tuple String (Action a effs)),
    init :: Action a effs,
    effects :: Event -> InterpretEffs effs
} -> Effect Unit

app :: ∀a effs. {
    state :: a,
    view :: a -> VDom a effs,
    node :: String,
    events :: Array (Tuple String (Action a effs)),
    init :: Action a effs,
    effects :: Event -> InterpretEffs effs
} -> Effect Unit
app = appAux dispatch
