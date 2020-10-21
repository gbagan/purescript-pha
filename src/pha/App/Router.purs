module Pha.App.Router (appWithRouter, goTo, redirectTo, loadUrl, Url, UrlRequest(..), AppWithRouter) where
import Prelude
import Effect (Effect)
import Pha (Sub)
import Pha.App (Document)
import Pha.App.Internal as Internal
import Data.Maybe (Maybe(..))
import Web.HTML (window)
import Web.HTML.Window as W
import Web.HTML.Location as L
import Web.HTML.HTMLDocument as D
import Web.HTML.History as H
import Foreign (Foreign)
import Web.Event.Event (Event, EventType(..))
import Web.Event.EventTarget (eventListener, addEventListener)


type Url =
    {   hash ∷ String
    ,   host ∷ String
    ,   hostname ∷ String
    ,   href ∷ String 
    ,   origin ∷ String
    ,   pathname ∷ String
    ,   port ∷ String
    ,   protocol ∷ String
    ,   search ∷ String
    }

foreign import makeUrlAux :: (∀a. Maybe a) → (∀a. a → Maybe a) → String → String → Maybe Url
makeUrl :: String → String → Maybe Url
makeUrl = makeUrlAux Nothing Just

getLocationUrl ∷ Effect Url
getLocationUrl = do
    loc <- window >>= W.location
    hash <- L.hash loc
    host <- L.host loc
    hostname <- L.hostname loc
    href <- L.href loc
    origin <- L.origin loc
    pathname <- L.pathname loc
    port <- L.port loc
    protocol <- L.protocol loc
    search <- L.search loc
    pure $ {hash, host, hostname, href, origin, pathname, port, protocol, search}

foreign import dispatchPopState ∷ Effect Unit

data UrlRequest = Internal Url | External String

urlRequest ∷ Url → Url → UrlRequest
urlRequest base url =
    if base.protocol == url.protocol &&
        base.host == url.host &&
        base.port == url.port then
        Internal url
    else
        External url.href


type AppWithRouter msg state = 
    {   init ∷ Url → {state :: state, action :: Maybe msg}
    ,   view ∷ state → Document msg
    ,   update ∷ {get ∷ Effect state, modify ∷ (state → state) → Effect Unit} → msg → Effect Unit
    ,   subscriptions ∷ state → Array (Sub msg)
    ,   onUrlRequest ∷ UrlRequest → msg
    ,   onUrlChange ∷ Url → msg
    }

foreign import handleClickOnAnchor ∷ (String → Effect Unit)  → Event → Effect Unit
foreign import triggerPopState ∷ Effect Unit
foreign import emptyObj ∷ Foreign

goTo ∷ String → Effect Unit
goTo url = do
    window >>= W.history >>= H.pushState emptyObj (H.DocumentTitle "") (H.URL url)
    triggerPopState

redirectTo ∷ String → Effect Unit
redirectTo url = do
    window >>= W.history >>= H.replaceState emptyObj (H.DocumentTitle "") (H.URL url)
    triggerPopState

loadUrl ∷ String → Effect Unit
loadUrl url = window >>= W.location >>= L.setHref url


appWithRouter ∷ ∀msg state. AppWithRouter msg state → Internal.AppBuilder msg state
appWithRouter {init, view, update, subscriptions, onUrlRequest, onUrlChange} {getS, setS, renderVDom} =
    {render, init: init2, subscriptions, dispatch, dispatchEvent} where
    {dispatch, dispatchEvent} = Internal.getDispatchers getS setS update
    render state = do
        let {body, title} = view state
        window >>= W.document >>= D.setTitle title
        renderVDom body

    hrefHandler baseUrl href  =
        case makeUrl href baseUrl.href of
            Nothing → pure unit
            Just url →
                dispatch $ onUrlRequest $ urlRequest baseUrl url

    popStateHandler url ev = do
        url2 <- getLocationUrl
        dispatch (onUrlChange url2)

    init2 = do
        url <- getLocationUrl
        let {state, action} = init url
        listener <- eventListener (popStateHandler url)
        window <#> W.toEventTarget >>= addEventListener (EventType "popstate") listener false
        clickListener <- eventListener (handleClickOnAnchor (hrefHandler url))
        window <#> W.toEventTarget >>= addEventListener (EventType "click") clickListener false
        setS state
        case action of
            Just msg → dispatch msg
            Nothing → pure unit
