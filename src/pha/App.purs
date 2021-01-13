module Pha.App (app, sandbox) where
import Prelude
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
import Pha.Subscriptions (Subscription) 
import Pha.Update (UpdateF(..), Update(..))
import Effect.Ref as Ref
import Web.Event.Event (EventType(..))
import Web.Event.Event as Ev
import Web.DOM.Node as Node
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode)
import Web.DOM.Element as El
import Web.DOM.ParentNode (QuerySelector(..), querySelector)

app' ∷ ∀msg state.
    {   init ∷ {state ∷ state, action ∷ Maybe msg}
    ,   view ∷ state → Html msg
    ,   update ∷ {get ∷ Effect state, put ∷ state → Effect Unit} → msg → Effect Unit
    ,   subscriptions ∷ state → Array (Subscription msg)
    ,   selector ∷ String
    } → Effect Unit
app' {init: {state: st, action}, update, view, subscriptions, selector} = do
    parentNode <- window >>= document <#> toParentNode
    selected <- map El.toNode <$> querySelector (QuerySelector selector) parentNode
    case selected of
        Nothing → pure unit
        Just node_ → do
            state <- Ref.new st
            lock <- Ref.new false
            subs <- Ref.new []
            node <- Ref.new node_
            vdom <- Ref.new (text "")
            go state lock subs node vdom
    where
    go state lock subs node vdom = do
        setState st
        case action of
            Just a → dispatch a
            Nothing → pure unit
        where
        render ∷ Html msg → Effect Unit
        render newVDom = do
                Ref.write false lock
                oldVDom <- Ref.read vdom
                node1 <- Ref.read node
                pnode <- Node.parentNode node1
                case pnode of
                    Nothing → pure unit
                    Just pnode' → do
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
                subs1 <- Ref.read subs
                subs2 <- I.patchSubs subs1 (subscriptions newState) dispatch
                Ref.write subs2 subs
                lock1 <- Ref.read lock
                unless lock1 do
                    Ref.write true lock
                    -- void $ window >>= requestAnimationFrame (
                    render $ view newState
        
        dispatch ∷ msg → Effect Unit
        -- eta expansion pour casser la dépendance cyclique
        dispatch = update {get: getState, put: \s → setState s}

        dispatchEvent ∷ Event → EventHandler msg → Effect Unit
        dispatchEvent ev handler = do
                        msg <- handler ev
                        case msg of
                            Nothing → pure unit
                            Just m → dispatch m

        listener e = do
            let EventType t = Ev.type_ e
            case Ev.currentTarget e of
                Nothing → pure unit
                Just target → do
                    fn <- I.getAction target t
                    dispatchEvent e fn
 
interpret ∷ ∀st. {get ∷ Effect st, put ∷ st → Effect Unit} → Update st Unit → Aff Unit
interpret {get, put} (Update monad) = runFreeM go monad where
    go (State k) = do
        st <- liftEffect get
        let Tuple a st2 = k st
        liftEffect (put st2)
        pure a
    go (Lift a) = a

app ∷ ∀msg state.
    {   init ∷ {state ∷ state, action ∷ Maybe msg}
    ,   view ∷ state → Html msg
    ,   update ∷ msg → Update state Unit
    ,   subscriptions ∷ state → Array (Subscription msg)
    ,   selector ∷ String
    } → Effect Unit

app {init, view, update, subscriptions, selector} = app' {
    init, view, subscriptions, selector,
    update: \helpers msg → launchAff_ $ interpret helpers (update msg)
}


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
    ,   subscriptions: const []
    ,   selector
    }
