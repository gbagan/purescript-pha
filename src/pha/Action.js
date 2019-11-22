exports.setTimeout = ms => fn => () => setTimeout (fn, ms);
exports.mathRandom = Math.random;