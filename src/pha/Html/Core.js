/*
0: property
1: attribute
2: event
3: class
4: style
*/

const compose = (f, g) => f && g ? x => f(g(x)) : f || g

const _h = (tag, ps, children, keyed=false) => {
    const style = []
    const props = {}
    const attrs = {}
    const events = {}
    const vdom = {tag, children, props, attrs, events, node: null, keyed}
    const n = ps.length
    for (let i = 0; i < n; i++) {
        const [t, k, v] = ps[i]
        if (t === 0)
            props[k] = v
        else if (t === 1)
            attrs[k] = v
        else if (t === 2)
            events[k] = v
        else if (t === 3)
            attrs.class = attrs.class ? attrs.class + " " + k : k
        else if (t === 4)
            style.push(k + ":" + v)
    }
    const style_ = style.join(";")
    if (style_)
        attrs.style = style_
    return vdom
}

export const elemImpl = (tag, ps, children) => _h(tag, ps, children.map(html => ({key: null, html})))

export const keyedImpl = (tag, ps, children) => _h(tag, ps, children, true)

const createTextVNode = text => ({
    tag: text,
    children: [],
    type: 3
})

export const mapView = (mapf, vnode) => ({...vnode, mapf: compose(vnode.mapf, mapf)})
export const mapProp = (mapf, prop) => prop[0] == 2 ? [2, mapf(prop[1])] : prop
export const propImpl = (k, v) => [0, k, v]
export const attrImpl = (k, v) => [1, k, v]
export const unsafeOnWithEffectImpl = (k, v) => [2, k, v]
export const class_ = cls => [3, cls]
export const noProp = [-1]
export const styleImpl = (k, v) => [4, k, v]
export const text = createTextVNode
export const lazyImpl = (view, val) => ({ memo: [val], type: view})
export const lazy2Impl = (view, val1, val2) => ({ memo: [val1, val2], type: view})
export const lazy3Impl = (view, val1, val2, val3) => ({ memo: [val1, val2, val3], type: view})
export const lazy4Impl = (view, val1, val2, val3, val4) => ({ memo: [val1, val2, val3, val4], type: view})
export const lazy5Impl = (view, val1, val2, val3, val4, val5) => ({ memo: [val1, val2, val3, val4, val5], type: view})