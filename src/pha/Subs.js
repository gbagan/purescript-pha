exports.addEventListener = name => fn => () => {
    if (window && window.addEventListener) {
        listener = window.addEventListener(name, ev => fn(ev)());
        return () => target.removeEventListener(listener);
    } else {
        return () => null;
    }
}
exports.makeSub = fn => d => [fn, d]