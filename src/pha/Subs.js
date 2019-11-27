exports.makeSub = fn => d => [fn, d]

exports.addEventListener = name => fn => () => {
    if (window && window.addEventListener) {
        listener = window.addEventListener(name, ev => fn(ev)());
        return () => target.removeEventListener(listener);
    } else {
        return () => null;
    }
}

exports.onAnimationFrameAux = fn => () => {
    let id = requestAnimationFrame(timestamp => {
        id = requestAnimationFrame(frame)
        fn (timestamp)
    })
    return () => cancelAnimationFrame(id);
}