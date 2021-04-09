module Pha.App.Internal where
import Prelude
import Effect (Effect)
import Pha.Html.Core (Html, Event, EventHandler)
import Web.Event.EventTarget (EventTarget)
import Web.DOM.Node (Node)

foreign import getAction ∷ ∀msg. EventTarget → String → Effect (EventHandler msg)
foreign import unsafePatch ∷ ∀msg. Node → Node → Html msg → Html msg → (Event → Effect Unit) → Effect Node
foreign import copyVNode ∷ ∀msg. Html msg → Html msg