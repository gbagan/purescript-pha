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
import Pha.Subscriptions (Subscription(..)) 
import Pha.Update (UpdateF(..), Update(..))
import Effect.Ref as Ref
import Web.Event.Event (EventType(..))
import Web.Event.Event as Ev
import Web.DOM.Node as Node
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode)
import Web.DOM.Element as El
import Web.DOM.ParentNode (QuerySelector(..), querySelector)
import Unsafe.Coerce (unsafeCoerce)

app' ∷ ∀msg state.
    {   init ∷ {state ∷ state, action ∷ Maybe msg}
    ,   view ∷ state → Html msg
    ,   update ∷ {get ∷ Effect state, put ∷ state → Effect Unit} → msg → Effect Unit
    ,   subscriptions ∷ Array (Subscription msg)
    ,   selector ∷ String
    } → Effect Unit
app' {init: {state: st, action}, update, view, subscriptions, selector} = do
    parentNode <- window >>= document <#> toParentNode
    selected <- map El.toNode <$> querySelector (QuerySelector selector) parentNode
    for_ selected \node_ → do
        state <- Ref.new st
        node <- Ref.new node_
        vdom <- Ref.new (text "")
        go state node vdom
    where
    go state node vdom = do
        render (view st)
        for_ subscriptions \(Subscription sub) → sub dispatch
        for_ action dispatch
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
 
        getState ∷ Effect state
        getState = Ref.read state

        setState ∷ state → Effect Unit
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
            msg <- handler ev
            for_ msg dispatch

        listener e = do
            let EventType t = Ev.type_ e
            for_ (Ev.currentTarget e) \target → do
                fn <- I.getAction target t
                dispatchEvent e fn
 
interpret ∷ ∀st m. Monad m =>
    {get ∷ Effect st, put ∷ st → Effect Unit} 
    → (m ~> Aff)
    → Update st m Unit
    → Aff Unit
interpret {get, put} eval (Update m) = runFreeM go m where
    go (State k) = do
        st <- liftEffect get
        let Tuple a st2 = k st
        liftEffect (put st2)
        pure a
    go (Lift a) = eval a

app ∷ ∀msg state m. Monad m =>
    {   init ∷ {state ∷ state, action ∷ Maybe msg}
    ,   view ∷ state → Html msg
    ,   update ∷ msg → Update state m Unit
    ,   eval ∷ m ~> Aff
    ,   subscriptions ∷ Array (Subscription msg)
    ,   selector ∷ String
    } → Effect Unit

app {init, view, update, eval, subscriptions, selector} = app' {init, view, subscriptions, selector, update: update'}
    where
    update' helpers msg = launchAff_ $ interpret helpers (unsafeCoerce eval) (update msg)

-- | ```purescript
-- | sandbox ∷ ∀msg state effs. {
-- |     init ∷ state,
-- |     view ∷ state → Html msg,
-- |     update ∷ msg → state → state,
-- |     selector ∷ String
-- | } → Effect Unit
-- | ```

sandbox ∷ ∀msg state. {
    init ∷ state,
    view ∷ state → Html msg,
    update ∷ msg → state → state,
    selector ∷ String
} → Effect Unit

sandbox {init, view, update, selector} = app' {
        init: {state: init, action: Nothing}
    ,   view
    ,   update: \{get, put} msg → do
        st <- get
        put (update msg st)
    ,   subscriptions: []
    ,   selector
    }
