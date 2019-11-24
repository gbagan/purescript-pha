exports.setTimeout = ms => fn => () => setTimeout (fn, ms);
