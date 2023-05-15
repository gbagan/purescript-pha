const objEq = (a, b) => {
    if (a === undefined)
        return false
    for (let x in a)
        if (a[x] !== b[x])
            return false
    return true
}

export const memoizedImpl = sel => f => {
    let u = undefined;
    let a = undefined;
    let res = undefined;
    return v => {
        if (u === v)
            return res
        const b = sel(v);
        if (a === b) {
            u = v;
            return res;
        }
        else {
            u = v;
            a = b;
            res = f(b);
            return res;
        }
    }
}

export const memoizedObj = sel => f => {
    let a = undefined;
    let res = undefined;
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