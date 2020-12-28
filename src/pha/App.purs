module Pha.App (app, sandbox) where
import Prelude
import Data.Maybe (Maybe(..))
import Effect (Effect)
import Web.HTML.Window (document)
import Pha.App.Internal as I
import Pha (VDom, Event, EventHandler, Sub, text)
import Effect.Ref as Ref
import Web.Event.Event (EventType(..))
import Web.Event.Event as Ev
import Web.DOM.Node as Node
import Web.HTML (window)
import Web.HTML.HTMLDocument (toParentNode)
import Web.DOM.Element as El
import Web.DOM.ParentNode (QuerySelector(..), querySelector)

app ∷ ∀msg state.
    {   init ∷ {state ∷ state, action ∷ Maybe msg}
    ,   view ∷ state → VDom msg
    ,   update ∷ {get ∷ Effect state, modify ∷ (state → state) → Effect Unit} → msg → Effect Unit
    ,   subscriptions ∷ state → Array (Sub msg)
    ,   selector ∷ String
    } → Effect Unit
app {init: {state: st, action}, update, view, subscriptions, selector} = do
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
        render ∷ VDom msg → Effect Unit
        render newVDom = do
                Ref.write false lock
                oldVDom <- Ref.read vdom
                node1 <- Ref.read node
                pnode <- Node.parentNode node1
                case pnode of
                    Nothing → pure unit
                    Just pnode' → do
                        node2 <- I.patch pnode' node1 oldVDom newVDom listener
                        Ref.write node2 node
                        Ref.write newVDom vdom
 
 
        getState ∷ Effect state
        getState = Ref.read state

        setState ∷ state → Effect Unit
        setState newState = do
                    Ref.write newState state
                    subs1 <- Ref.read subs
                    subs2 <- I.patchSubs subs1 (subscriptions newState) dispatch
                    Ref.write subs2 subs
                    lock1 <- Ref.read lock
                    unless lock1 do
                        Ref.write true lock
                        -- void $ window >>= requestAnimationFrame (
                        render $ view newState

        modify ∷ (state → state) → Effect Unit 
        modify fn = getState >>= (setState <<< fn)
        
        dispatch ∷ msg → Effect Unit
        -- eta expansion pour casser la dépendance cyclique
        dispatch = update {get: getState, modify: \f → modify f}

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
 


-- | ```purescript
-- | sandbox ∷ ∀msg state effs. {
-- |     init ∷ state,
-- |     view ∷ state → VDom msg,
-- |     update ∷ msg → state → state
-- | } → Effect Unit
-- | ```

sandbox ∷ ∀msg state. {
    init ∷ state,
    view ∷ state → VDom msg,
    update ∷ msg → state → state,
    selector ∷ String
} → Effect Unit

sandbox {init, view, update, selector} = app {
        init: {state: init, action: Nothing}
    ,   view
    ,   update: \{modify} msg → modify (update msg)
    ,   subscriptions: const []
    ,   selector
    }
