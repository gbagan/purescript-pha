exports.emptyObj = {}
exports.windowLoad = url => () => document.location.href = url;
exports.triggerPopState = () => {
    const ev = new PopStateEvent('popstate', {});
    dispatchEvent(ev);
}