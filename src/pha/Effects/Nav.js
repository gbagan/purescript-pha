exports.pushState = url => () => history && history.pushState(null, "", url);
exports.replaceState = url => () => history && history.replaceState(null, "", url);
exports.windowLoad = url => () => document.location.href = url;
exports.triggerPopState = () => {
    const ev = new PopStateEvent('popstate', { state: state });
    dispatchEvent(ev);
}