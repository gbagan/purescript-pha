module Pha.App.Router (appWithRouter, Url, UrlRequest(..), AppWithRouter) where
import Prelude
import Effect (Effect)
import Pha (Update, Sub)
import Pha.App (Document)
import Pha.App.Internal as Internal
import Data.Maybe (Maybe(..))
import Data.Tuple (Tuple(..))
import Web.HTML (window)
import Web.HTML.Window (document, location)
import Web.HTML.Window as W
import Web.HTML.Location as L
import Web.Event.Event (Event, EventType(..))
import Web.Event.EventTarget (eventListener, addEventListener)
import Web.HTML.HTMLDocument (setTitle)

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
    loc <- window >>= location
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


type AppWithRouter msg state effs = 
    {   init ∷ Url → Tuple state (Update state effs)
    ,   view ∷ state → Document msg
    ,   update ∷ msg → Update state effs
    ,   subscriptions ∷ state → Array (Sub msg)
    ,   onUrlRequest ∷ UrlRequest → msg
    ,   onUrlChange ∷ Url → msg
    ,   interpreter ∷ Internal.Interpreter effs
    }

foreign import handleClickOnAnchor ∷ (String → Effect Unit)  → Event → Effect Unit

appWithRouter ∷ ∀msg state effs. AppWithRouter msg state effs → Internal.AppBuilder msg state
appWithRouter {init, view, update, subscriptions, onUrlRequest, onUrlChange, interpreter} {getS, setS, renderVDom} =
    {render, init: init2, subscriptions, dispatch, dispatchEvent} where
    {runAction, dispatch, dispatchEvent} = Internal.getDispatchers getS setS update interpreter
    render state = do
        let {body, title} = view state
        window >>= document >>= setTitle title
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
        let Tuple state init3 = init url
        listener <- eventListener (popStateHandler url)
        window <#> W.toEventTarget >>= addEventListener (EventType "popstate") listener false
        clickListener <- eventListener (handleClickOnAnchor (hrefHandler url))
        window <#> W.toEventTarget >>= addEventListener (EventType "click") clickListener false
        setS state
        runAction init3
