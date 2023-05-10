module Pha.App.Internal where
import Prelude
import Effect.Uncurried (EffectFn1, EffectFn2, EffectFn5)
import Pha.Html.Core (Html, Event, EventHandler)
import Web.Event.EventTarget (EventTarget)
import Web.DOM.Node (Node)

foreign import getAction ∷ ∀msg. EffectFn2 EventTarget String (EventHandler msg)
foreign import unsafePatch ∷ ∀msg. EffectFn5 Node Node (Html msg) (Html msg) (EffectFn1 Event Unit) Node
foreign import copyVNode ∷ ∀msg. Html msg → Html msg
foreign import unsafeLinkNode ∷ ∀msg. Node → Html msg → Html msg