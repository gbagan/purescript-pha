module Pha.App (app, sandbox, attachTo, Document, App) where
import Prelude
import Effect (Effect)
import Data.Maybe (Maybe(..))
import Pha (VDom, Event, Sub, EventHandler)
import Run (onMatch, VariantF)
import Run as Run
import Data.Tuple (Tuple(..))
import Pha.Internal (app) as Internal
import Pha.Action (Action, setState,  GetState(..), SetState(..))

type Document msg = {
    title ∷ String,
    body ∷ VDom msg
}

-- effs: effects in the app
-- neffs: non interpreted effs
newtype App msg state effs = App {
    init ∷ Tuple state (Action state effs),
    view ∷ state → Document msg,
    update ∷ msg → Action state effs,
    subscriptions ∷ state → Array (Sub msg),
    interpreter ∷ VariantF effs (Effect Unit) → Effect Unit
}


-- | ```purescript
-- | app ∷ ∀msg state effs. {
-- |     init ∷ Tuple state (Action state effs),
-- |     view ∷ state → Document msg,
-- |     update ∷ msg → Action state effs,
-- |     subscriptions ∷ state → Array (Sub msg)
-- | } → App effs
-- | ```

app ∷ ∀msg state effs. {
    init ∷ Tuple state (Action state effs),
    view ∷ state → Document msg,
    update ∷ msg → Action state effs,
    subscriptions ∷ state → Array (Sub msg),
    interpreter ∷ VariantF effs (Effect Unit) → Effect Unit
} → App msg state effs
app = App

--addInterpret ∷ ∀msg state effs effs1 effs2. Interpret state effs1 effs2 → App msg state effs effs1 → App msg state effs effs2
--addInterpret interpret (App a) = App a{interpret = a.interpret >>> interpret}

attachTo ∷ ∀msg state effs. String → App msg state effs → Effect Unit
attachTo node (App {init: Tuple state init, view, update, subscriptions, interpreter}) = Internal.app fn where
    fn getS setS =
        {state, view, node, init: init2, subscriptions, dispatch, dispatchEvent} where

        runAction ∷ Action state effs → Effect Unit
        runAction = Run.runCont handleState (const (pure unit)) where
            handleState = onMatch {
                getState: \(GetState next) → do
                    a <- getS
                    next a
            ,   setState: \(SetState f next) → do
                    a <- getS
                    setS (f a)
                    next
            } interpreter
        
        dispatch ∷ msg → Effect Unit
        dispatch = runAction <<< update

        dispatchEvent ∷ Event → (EventHandler msg) → Effect Unit
        dispatchEvent = \ev handler → do
            let {effect, msg} = handler ev
            effect
            case msg of
                Nothing → pure unit
                Just m → dispatch m
        
        init2 = runAction init 



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
    update ∷ msg → state → state
} → App msg state ()

sandbox {init, view, update} =
    app 
        {   init: Tuple init (pure unit)
        ,   view: \st → {title: "app", body: view st}
        ,   update: \msg → setState (update msg)
        ,   subscriptions: const []
        ,   interpreter: const (pure unit)
        }

