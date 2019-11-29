module Pha.App (app, sandbox, addInterpret, attachTo, Document, App) where
import Prelude
import Effect (Effect)
import Effect.Aff (launchAff_)
import Data.Maybe (Maybe(..))
import Effect.Class (liftEffect)
import Pha (VDom, Event, Sub, EventHandler)
import Run (Run,  onMatch, AFF)
import Run as Run
import Data.Tuple (Tuple(..))
import Pha.Internal (app) as Internal
import Pha.Action (Action, setState,  GetState(..), SetState(..))
import Unsafe.Coerce (unsafeCoerce)

type Document msg = {
    title ∷ String,
    body ∷ VDom msg
}

-- effs: effects in the app
-- neffs: non interpreted effs
newtype App msg state effs neffs = App {
    init ∷ Tuple state (Action state effs),
    view ∷ state → Document msg,
    update ∷ msg → Action state effs,
    subscriptions ∷ state → Array (Sub msg),
    interpret ∷ Interpret state effs neffs
}


-- | ```purescript
-- | app ∷ ∀msg state effs. {
-- |     init ∷ Tuple state (Action state effs),
-- |     view ∷ state → Document msg,
-- |     update ∷ msg → Action state effs,
-- |     subscriptions ∷ state → Array (Sub msg)
-- | } → App effs
-- | ```

addAff :: forall  a b. Run a b -> Run (aff :: AFF | a) b
addAff = unsafeCoerce

app ∷ ∀msg state effs. {
    init ∷ Tuple state (Action state effs),
    view ∷ state → Document msg,
    update ∷ msg → Action state effs,
    subscriptions ∷ state → Array (Sub msg)
} → App msg state effs (aff :: AFF | effs)
app {init, view, update, subscriptions} =
    App {init, view, update, subscriptions, interpret: addAff}

addInterpret ∷ ∀msg state effs effs1 effs2. Interpret state effs1 effs2 → App msg state effs effs1 → App msg state effs effs2
addInterpret interpret (App a) = App a{interpret = a.interpret >>> interpret}

attachTo :: ∀msg state effs. String -> App msg state effs (aff :: AFF) → Effect Unit
attachTo node (App {init: Tuple state init, view, update, subscriptions, interpret}) = Internal.app fn where
    fn getS setS =
        {state, view, node, init: init2, subscriptions, dispatch, dispatchEvent} where

        interpretState ::  Action state (aff :: AFF) → Run (aff :: AFF) Unit
        interpretState  = Run.run handleState where
            handleState = onMatch {
                getState: \(GetState next) → Run.liftAff $ liftEffect do
                    a <- getS
                    pure (next a)
            ,   setState: \(SetState f next) → Run.liftAff $ liftEffect do
                    a <- getS
                    setS (f a)
                    pure next
            } Run.send
        
        runAction ∷ Action state effs → Effect Unit
        runAction = interpret
                    >>> interpretState 
                    >>> Run.runBaseAff 
                    >>> launchAff_

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
-- |     update ∷ msg → state → state,
-- |     node ∷ String
-- | } → Effect Unit
-- | ```

sandbox ∷ ∀msg state. {
    init ∷ state,
    view ∷ state → VDom msg,
    update ∷ msg → state → state
} → App msg state () (aff :: AFF)

sandbox {init, view, update} =
    app 
        {   init: Tuple init (pure unit)
        ,   view: \st → {title: "app", body: view st}
        ,   update: \msg → setState (update msg)
        ,   subscriptions: const []
        }

type Interpret state effs effs2 = Action state effs -> Action state effs2
