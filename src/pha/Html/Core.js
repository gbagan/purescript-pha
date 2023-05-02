const compose = (f, g) => f && g ? x => f(g(x)) : f || g

const _h = (tag, ps, children, keyed=false) => {
    const style = {}
    const props = {style}
    const vdom = {tag, children, props, node: null, keyed}
    const n = ps.length
    for (let i = 0; i < n; i++) {
        const [t, k, v] = ps[i]
        if (t == 1)
            props[k] = v
        else if (t === 2)
            props.class = props.class ? props.class + " " + k : k
        else if (t === 3)
            style[k] = v
    }
    return vdom
}

export const elem = tag => ps => children => _h(tag, ps, children.map(html => ({key: null, html})))

export const keyed = tag => ps => children => _h(tag, ps, children, true)

const createTextVNode = text => ({
    tag: text,
    props: {},
    children: [],
    type: 3
})

export const mapView = mapf => vnode => Object.assign({}, vnode, {mapf: compose(vnode.mapf, mapf)})
export const attr = k => v => [1, k, v]
export const class_ = cls => [2, cls]
export const noProp = [-1]
export const unsafeOnWithEffect = k => v => [1, "on"+k, v]
export const style = k => v => [3, k, v]
export const text = createTextVNode
export const lazy = view => val => ({ memo: [val], type: view})
export const lazy2 = view => val1 => val2 => ({ memo: [val1, val2], type: view})
export const lazy3 = view => val1 => val2 => val3 => ({ memo: [val1, val2, val3], type: view})