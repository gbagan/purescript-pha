module Pha.App.Internal where
import Prelude
import Effect (Effect)
import Pha (VDom, Event, EventHandler, Sub)
import Web.Event.EventTarget (EventTarget)
import Web.DOM.Node (Node)

foreign import getAction ∷ ∀msg. EventTarget → String → Effect (EventHandler msg)
foreign import patchSubs ∷ ∀msg. Array (Sub msg) → Array (Sub msg) → (msg → Effect Unit) → Effect (Array (Sub msg))
foreign import patch ∷ ∀msg. Node → Node → VDom msg → VDom msg → (Event → Effect Unit) → Effect Node
foreign import copyVNode ∷ ∀msg. VDom msg → VDom msg