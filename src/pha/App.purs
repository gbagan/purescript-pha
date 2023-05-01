module Pha.App (app, sandbox) where
import Prelude
import Data.Foldable (for_)
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Unsafe.Reference (unsafeRefEq)
import Effect (Effect)
import Effect.Class (liftEffect)
import Effect.Aff (Aff, launchAff_)
import Web.HTML.Window (document)
import Control.Monad.Free (runFreeM)
import Pha.App.Internal as I
import Pha.Html.Core (Html, Event, EventHandler, text)
import Pha.Update (UpdateF(..), Update(..))
import Effect.Ref as Ref
import Web.Event.Event (EventType(..))
import Web.Event.Event as Ev
import Web.DOM.Node as Node
import Web.DOM.Document (createTextNode)
import Web.DOM.Text as Text
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode, toDocument)
import Web.DOM.Element as El
import Web.DOM.ParentNode (QuerySelector(..), querySelector)

app' ∷ ∀msg model.
  { init ∷ {model ∷ model, msg ∷ Maybe msg}
  , view ∷ model → Html msg
  , update ∷ {get ∷ Effect model, put ∷ model → Effect Unit} → msg → Effect Unit
  , selector ∷ String
  } → Effect Unit
app' {init: {model, msg}, update, view, selector} = do
  parentNode <- window >>= document <#> toParentNode
  selected <- map El.toNode <$> querySelector (QuerySelector selector) parentNode
  for_ selected \node_ → do
    state <- Ref.new model
    emptyNode <- window >>= document <#> toDocument >>= createTextNode "" <#> Text.toNode
    Node.appendChild emptyNode node_
    node <- Ref.new emptyNode
    vdom <- Ref.new $ I.unsafeLinkNode emptyNode (text "")
    go state node vdom
  where
  go state node vdom = do
    render (view model)
    for_ msg dispatch
    where
    render ∷ Html msg → Effect Unit
    render newVDom = do
      oldVDom <- Ref.read vdom
      node1 <- Ref.read node
      pnode <- Node.parentNode node1
      for_ pnode \pnode' → do
        let vdom2 = I.copyVNode newVDom
        node2 <- I.unsafePatch pnode' node1 oldVDom vdom2 listener
        Ref.write node2 node
        Ref.write vdom2 vdom
 
    getState ∷ Effect model
    getState = Ref.read state

    setState ∷ model → Effect Unit
    setState newState = do
      oldState <- Ref.read state
      unless (unsafeRefEq oldState newState) do
        Ref.write newState state
        render $ view newState
        
    dispatch ∷ msg → Effect Unit
    -- eta expansion pour casser la dépendance cyclique
    dispatch = update {get: getState, put: \s → setState s}

    dispatchEvent ∷ Event → EventHandler msg → Effect Unit
    dispatchEvent ev handler = do
      msg' <- handler ev
      for_ msg' dispatch

    listener e = do
      let EventType t = Ev.type_ e
      for_ (Ev.currentTarget e) \target → do
        fn <- I.getAction target t
        dispatchEvent e fn
 
interpret ∷ ∀model msg.
    (msg → Update model msg Aff Unit)
    → {get ∷ Effect model, put ∷ model → Effect Unit}
    → Update model msg Aff Unit
    → Aff Unit
interpret update {get, put} (Update m) = runFreeM go m where
  go (State k) = do
    st <- liftEffect get
    let Tuple a st2 = k st
    liftEffect (put st2)
    pure a
  go (Lift a) = a
  go (Subscribe f next) = do 
    liftEffect $ f \msg → launchAff_ $ interpret update {get, put} (update msg)
    pure next

-- | ```purescript
-- | app ∷ ∀msg model.
-- |  { init ∷ {model ∷ model, msg ∷ Maybe msg}
-- |  , view ∷ model → Html msg
-- |  , update ∷ msg → Update model msg Aff Unit
-- |  , selector ∷ String
-- |  } → Effect Unit
-- | ```

app ∷ ∀msg model.
  { init ∷ {model ∷ model, msg ∷ Maybe msg}
  , view ∷ model → Html msg
  , update ∷ msg → Update model msg Aff Unit
  , selector ∷ String
  } → Effect Unit

app {init, view, update, selector} = app' {init, view, selector, update: update'}
    where
    update' helpers msg = launchAff_ $ interpret update helpers (update msg)

-- | ```purescript
-- | sandbox ∷ ∀msg model. 
-- |   { init ∷ model
-- |   , view ∷ model → Html msg
-- |   , update ∷ msg → model → model
-- |   , selector ∷ String
-- |   } → Effect Unit
-- | ```

sandbox ∷ ∀msg model. 
  { init ∷ model
  , view ∷ model → Html msg
  , update ∷ msg → model → model
  , selector ∷ String
  } → Effect Unit

sandbox {init, view, update, selector} = app' {
        init: {model: init, msg: Nothing}
    ,   view
    ,   update: \{get, put} msg → do
        st <- get
        put (update msg st)
    ,   selector
    }
