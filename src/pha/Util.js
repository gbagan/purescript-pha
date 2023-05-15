const objEq = (a, b) => {
    if (a === null && b !== null)
        return false
    for (let x in a)
        if (a[x] !== b[x])
            return false
    return true
}

export const memoized = sel => f => {
    let a = null;
    let res = null;
    return v => {
        const b = sel(v);
        if (a === b)
            return res;
        else {
            a = b;
            res = f(b);
            return res;
        }
    }
}

export const memoizedObj = sel => f => {
    let a = null;
    let res = null;
    return v => {
        const b = sel(v);
        if (objEq(a, b))
            return res;
        else {
            a = b;
            res = f(b);
            return res;
        }
    }
}