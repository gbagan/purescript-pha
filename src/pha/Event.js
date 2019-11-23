exports.shiftKey = e => !!e.shiftKey;
exports.unsafeToMaybeAux = nothing => just => x => x === null || x === undefined ? nothing :  just(x);
exports.unsafeKey = e => e && e.key;
exports.unsafeButton = e => e != null && e.key;

exports.preventDefaultE = e => () => e && e.preventDefault && e.preventDefault();
exports.stopPropagationE = e => () => e && e.stopPropagation && e.stopPropagation();
//exports.targetE = e => e && e.target
//exports.currentTargetE = e => e && e.currentTarget
exports.unsafeTargetCheckedE = e => () => e && e.target && e.target.checked
exports.unsafeTargetValueE = e => () => e && e.target && e.target.value