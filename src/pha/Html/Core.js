const compose = (f, g) => f && g ? x => f(g(x)) : f || g

const _h = (tag, ps, children, keyed=false) => {
    const style = []
    const props = {}
    const vdom = {tag, children, props, node: null, keyed}
    const n = ps.length
    for (let i = 0; i < n; i++) {
        const [t, k, v] = ps[i]
        if (t == 1)
            props[k] = v
        else if (t === 2)
            props.class = props.class ? props.class + " " + k : k
        else if (t === 3)
            style.push(k + ":" + v)
    }
    props.style = style.join(";")
    return vdom
}

export const elemImpl = (tag, ps, children) => _h(tag, ps, children.map(html => ({key: null, html})))

export const keyedImpl = (tag, ps, children) => _h(tag, ps, children, true)

const createTextVNode = text => ({
    tag: text,
    props: {},
    children: [],
    type: 3
})

export const mapView = (mapf, vnode) => ({...vnode, mapf: compose(vnode.mapf, mapf)})
export const attr = k => v => [1, k, v]
export const class_ = cls => [2, cls]
export const noProp = [-1]
export const unsafeOnWithEffectImpl = (k, v) => [1, "on"+k, v]
export const styleImpl = (k, v) => [3, k, v]
export const text = createTextVNode
export const lazyImpl = (view, val) => ({ memo: [val], type: view})
export const lazy2Impl = (view, val1, val2) => ({ memo: [val1, val2], type: view})
export const lazy3Impl = (view, val1, val2, val3) => ({ memo: [val1, val2, val3], type: view})