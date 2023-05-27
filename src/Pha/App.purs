module Pha.App (app, sandbox) where

import Prelude

import Control.Monad.Free (runFreeM)
import Data.Foldable (for_)
import Data.Map (Map)
import Data.Map as Map
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Effect (Effect)
import Effect.Uncurried(mkEffectFn1, runEffectFn2, runEffectFn5)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Effect.Ref (Ref)
import Effect.Ref as Ref
import Pha.App.Internal as I
import Pha.Html.Core (Html, Event, EventHandler, text)
import Pha.Update.Internal (UpdateF(..), Update(..), SubscriptionId(..))
import Unsafe.Reference (unsafeRefEq)
import Web.DOM.Document (createTextNode)
import Web.DOM.Element as El
import Web.DOM.Node as Node
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Web.DOM.Text as Text
import Web.Event.Event (EventType(..))
import Web.Event.Event as Ev
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode, toDocument)
import Web.HTML.Window (document)

newtype IApp model msg = IApp
  { state ∷ Ref model
  , node ∷ Ref Node.Node
  , vdom ∷ Ref (Html msg)
  , subscriptions ∷ Ref (Map SubscriptionId (Effect Unit))
  , freshId ∷ Ref Int
  , update ∷ IApp model msg → msg → Effect Unit
  , view ∷ model → Html msg
  }

app'
  ∷ ∀ msg model
  . { init ∷ { model ∷ model, msg ∷ Maybe msg }
    , view ∷ model → Html msg
    , update ∷ IApp model msg → msg → Effect Unit
    , selector ∷ String
    }
  → Effect Unit
app' { init: { model, msg }, update, view, selector } = do
  parentNode ← window >>= document <#> toParentNode
  selected ← map El.toNode <$> querySelector (QuerySelector selector) parentNode
  for_ selected \node_ → do
    state ← Ref.new model
    emptyNode ← window >>= document <#> toDocument >>= createTextNode "" <#> Text.toNode
    Node.appendChild emptyNode node_
    node ← Ref.new emptyNode
    vdom ← Ref.new $ I.unsafeLinkNode emptyNode (text "")
    subscriptions ← Ref.new $ Map.empty
    freshId ← Ref.new 0
    let iapp = IApp { view, update, state, node, vdom, subscriptions, freshId }
    render iapp (view model)
    for_ msg (dispatch iapp)

render ∷ ∀ model msg. IApp model msg → Html msg → Effect Unit
render iapp@(IApp { vdom, node }) newVDom = do
  oldVDom ← Ref.read vdom
  node1 ← Ref.read node
  pnode ← Node.parentNode node1
  for_ pnode \pnode' → do
    let vdom2 = I.copyVNode newVDom
    node2 ← runEffectFn5 I.unsafePatch pnode' node1 oldVDom vdom2 listener
    Ref.write node2 node
    Ref.write vdom2 vdom
  where
  listener = mkEffectFn1 \e → do
    let EventType t = Ev.type_ e
    for_ (Ev.currentTarget e) \target → do
      fn ← runEffectFn2 I.getAction target t
      dispatchEvent iapp e fn

getState ∷ ∀ model msg. IApp model msg → Effect model
getState (IApp { state }) = Ref.read state

setState ∷ ∀ model msg. IApp model msg → model → Effect Unit
setState iapp@(IApp { state, view }) newState = do
  oldState ← Ref.read state
  unless (unsafeRefEq oldState newState) do
    Ref.write newState state
    render iapp $ view newState

dispatch ∷ ∀ model msg. IApp model msg → msg → Effect Unit
-- eta expansion pour casser la dépendance cyclique
dispatch iapp@(IApp { update }) = update iapp

dispatchEvent ∷ ∀ model msg. IApp model msg → Event → EventHandler msg → Effect Unit
dispatchEvent iapp ev handler = do
  msg' ← handler ev
  for_ msg' (dispatch iapp)

getFreshId ∷ ∀ model msg. IApp model msg → Effect SubscriptionId
getFreshId (IApp { freshId }) = do
  id ← Ref.read freshId
  Ref.write (id + 1) freshId
  pure $ SubscriptionId id

interpret
  ∷ ∀ model msg
  . (msg → Update model msg Aff Unit)
  → IApp model msg
  → Update model msg Aff Unit
  → Aff Unit
interpret update iapp@(IApp { subscriptions }) (Update m) = runFreeM go m
  where
  go (State k) = do
    st ← liftEffect $ getState iapp
    let Tuple a st2 = k st
    liftEffect $ setState iapp st2
    pure a
  go (Lift a) = a
  go (Subscribe f next) = do
    canceler ← liftEffect $ f \msg → launchAff_ $ interpret update iapp (update msg)
    id ← liftEffect $ getFreshId iapp
    liftEffect $ Ref.modify_ (Map.insert id canceler) subscriptions
    pure (next id)
  go (Unsubscribe id a) = do
    subs ← liftEffect $ Ref.read subscriptions
    for_ (Map.lookup id subs) liftEffect
    pure a

-- | ```purescript
-- | app ∷ ∀msg model.
-- |  { init ∷ {model ∷ model, msg ∷ Maybe msg}
-- |  , view ∷ model → Html msg
-- |  , update ∷ msg → Update model msg Aff Unit
-- |  , selector ∷ String
-- |  } → Effect Unit
-- | ```

app
  ∷ ∀ msg model
  . { init ∷ { model ∷ model, msg ∷ Maybe msg }
    , view ∷ model → Html msg
    , update ∷ msg → Update model msg Aff Unit
    , selector ∷ String
    }
  → Effect Unit

app { init, view, update, selector } = app' { init, view, selector, update: update' }
  where
  update' iapp msg = launchAff_ $ interpret update iapp (update msg)

-- | ```purescript
-- | sandbox ∷ ∀msg model. 
-- |   { init ∷ model
-- |   , view ∷ model → Html msg
-- |   , update ∷ msg → model → model
-- |   , selector ∷ String
-- |   } → Effect Unit
-- | ```

sandbox
  ∷ ∀ msg model
  . { init ∷ model
    , view ∷ model → Html msg
    , update ∷ msg → model → model
    , selector ∷ String
    }
  → Effect Unit

sandbox { init, view, update, selector } =
  app'
    { init: { model: init, msg: Nothing }
    , view
    , update: \iapp msg → do
        st ← getState iapp
        setState iapp (update msg st)
    , selector
    }
