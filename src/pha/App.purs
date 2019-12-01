module Pha.App (app, sandbox, attachTo, Document, App) where
import Prelude
import Effect (Effect)
import Effect.Aff (Aff, launchAff_)
import Effect.Class (liftEffect)
import Data.Maybe (Maybe(..))
import Data.Traversable (for_)
import Pha (VDom, Event, Sub, EventHandler, purely, Transition)
import Data.Tuple (Tuple(..))
import Pha.Internal (app) as Internal
import Data.Const (Const(..))

type Document msg = {
    title ∷ String,
    body ∷ VDom msg
}

-- effs: effects in the app
-- neffs: non interpreted effs
newtype App model msg effs = App {
    init ∷ Transition model msg effs,
    view ∷ model → Document msg,
    update ∷ model → msg → Transition model msg effs,
    subscriptions ∷ model → Array (Sub msg),
    interpreter ∷ Interpreter msg effs 
}

-- | ```purescript
-- | app ∷ ∀msg state effs. {
-- |     init ∷ Tuple state (Action state effs),
-- |     view ∷ state → Document msg,
-- |     update ∷ msg → Action state effs,
-- |     subscriptions ∷ state → Array (Sub msg)
-- | } → App effs
-- | ```

--addAff ∷ forall a b. Run a b → Run (aff ∷ AFF | a) b
--addAff = unsafeCoerce

app ∷ ∀msg model effs. {
    init ∷ Transition model msg effs,
    view ∷ model → Document msg,
    update ∷ model → msg → Transition model msg effs,
    subscriptions ∷ model → Array (Sub msg),
    interpreter ∷ Interpreter msg effs 
} → App model msg effs
app = App

{-
withInterpret ∷ ∀msg state effs effs1 effs2. Interpret state effs1 effs2 → App msg state effs effs1 → App msg state effs effs2
withInterpret interpret (App a) = App a{interpret = a.interpret >>> interpret}
-}
attachTo ∷ ∀msg model effs. String → App model msg effs → Effect Unit
attachTo node (App {init, view, update, subscriptions, interpreter}) = Internal.app fn where
    fn getS setS =
        {view, node, init: init2, subscriptions, dispatch, dispatchEvent} where

        runTransition ∷ Transition model msg effs → Effect Unit
        runTransition (Tuple model effects) = do
            setS model 
            for_ effects \effect -> launchAff_ do
                msg <- interpreter effect
                liftEffect $ dispatch msg

        dispatch ∷ msg → Effect Unit
        dispatch msg = do
            model <- getS
            runTransition (update model msg)

        dispatchEvent ∷ Event → (EventHandler msg) → Effect Unit
        dispatchEvent = \ev handler → do
            let {effect, msg} = handler ev
            effect
            case msg of
                Nothing → pure unit
                Just m → dispatch m
        
        init2 = runTransition init
        

-- | ```purescript
-- | sandbox ∷ ∀msg state effs. {
-- |     init ∷ state,
-- |     view ∷ state → VDom msg,
-- |     update ∷ msg → state → state,
-- |     node ∷ String
-- | } → Effect Unit
-- | ```

sandbox ∷ ∀msg model. {
    init ∷ model,
    view ∷ model → VDom msg,
    update ∷ model → msg → model
} → App model msg  (Const Void)

sandbox {init, view, update} =
    app 
        {   init: purely init
        ,   view: \st → {title: "app", body: view st}
        ,   update: \model msg → purely (update model msg) 
        ,   subscriptions: const []
        ,   interpreter: \(Const a) -> absurd a
        }

type Interpreter msg effs = effs msg -> Aff msg
