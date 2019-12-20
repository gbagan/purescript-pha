exports.dispatchPopState = () => {
    const popStateEvent = new PopStateEvent('popstate', {});
    dispatchEvent(popStateEvent);
}

exports.makeUrlAux = nothing => just => url => baseUrl => {
    try {
        return just(new URL(url, baseUrl));
    }
    catch (e) {
        return nothing
    }
}

exports.handleClickOnAnchor = handler => ev => () => {
    if (ev.ctrlKey || ev.metaKey || ev.shiftKey || ev.button >= 1)
        return;
    const a = ev.target.closest("a");
    if (a) {
        ev.preventDefault();
        console.log(a, a.href);
        handler(a.href)();
    }
}
