exports.makeSub = fn => d => [fn, d]

exports.onAnimationFrameAux = fn => () => {
    let id = requestAnimationFrame(timestamp => {
        id = requestAnimationFrame(frame)
        fn (timestamp)
    })
    return () => cancelAnimationFrame(id);
}