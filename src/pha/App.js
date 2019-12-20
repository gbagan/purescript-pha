exports.getLocation = () => {
    const {hash, host, hostname, href, origin, pathname, port, protocol, search} = window.location;
    return {hash, host, hostname, href, origin, pathname, port, protocol, search};
}

exports.dispatchPopState = () => {
    const popStateEvent = new PopStateEvent('popstate', {});
    dispatchEvent(popStateEvent);
}