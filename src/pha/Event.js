exports.unsafeToMaybeAux = nothing => just => x => x === null || x === undefined ? nothing :  just(x);
exports.unsafeKey = e => e && e.key;
