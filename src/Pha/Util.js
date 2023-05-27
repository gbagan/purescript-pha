const objEq = (a, b) => {
    if (a === undefined)
        return false
    for (let x in a)
        if (a[x] !== b[x])
            return false
    return true
}

export const memoizeImpl = f => g => {
    let u = undefined;
    let a = undefined;
    let res = undefined;
    return v => {
        if (u === v)
            return res
        u = v;
        const b = f(v);
        if (a === b)
            return res;
        a = b;
        res = g(b);
        return res;
    }
}

export const memoizeObj = f => g => {
    let u = undefined;
    let a = undefined;
    let res = undefined;
    return v => {
        if (u === v)
            return res;
        u = v;
        const b = f(v);
        if (objEq(a, b))
            return res;
        a = b;
        res = g(b);
        return res;
    }
}