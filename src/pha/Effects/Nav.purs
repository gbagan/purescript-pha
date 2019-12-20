module Pha.Effects.Nav (NAV, goTo, redirectTo, load, interpretNav, Nav(..)) where
import Prelude
import Run (FProxy, Run, SProxy(..), lift)
import Effect (Effect)
import Web.HTML (window)
import Web.HTML.Window (history)
import Web.HTML.History (pushState, replaceState, URL(..), DocumentTitle(..))
import Foreign (Foreign)

data Nav a = GoTo String a | RedirectTo String a | Load String a
derive instance functorNav ∷ Functor Nav
type NAV = FProxy Nav
_nav = SProxy ∷ SProxy "nav"

goTo ∷ ∀r. String → Run (nav ∷ NAV | r) Unit
goTo url = lift _nav (GoTo url unit)

redirectTo ∷ ∀r. String → Run (nav ∷ NAV | r) Unit
redirectTo url = lift _nav (RedirectTo url unit)

load ∷ ∀r. String → Run (nav ∷ NAV | r) Unit
load url = lift _nav (Load url unit)

foreign import windowLoad ∷ String → Effect Unit
foreign import triggerPopState ∷ Effect Unit
foreign import emptyObj ∷ Foreign

emptyTitle ∷ DocumentTitle
emptyTitle = DocumentTitle ""

-- | default implementation of the effect delay
interpretNav ∷ Nav (Effect Unit) → Effect Unit
interpretNav (GoTo url next) = do
    window >>= history >>= pushState emptyObj emptyTitle (URL url)
    triggerPopState
    next
interpretNav (RedirectTo url next) = do
    window >>= history >>= replaceState emptyObj emptyTitle (URL url)
    triggerPopState
    next
interpretNav (Load url _) = windowLoad url