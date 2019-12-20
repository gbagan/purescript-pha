exports.pushState = url => () => history && history.pushState({}, "", url);
exports.replaceState = url => () => history && history.replaceState({}, "", url);
exports.windowLoad = url => () => document.location.href = url;
exports.triggerPopState = () => {
    const ev = new PopStateEvent('popstate', {});
    dispatchEvent(ev);
}