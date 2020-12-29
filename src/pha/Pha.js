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
            props.class = (props.class ? props.class + " " : "") + k
        else if (t === 3)
            style[k] = v
    }
    return vdom
}

const h = tag => ps => children => _h(tag, ps, children.map(v => [null, v]))
const keyed = tag => ps => children => _h(tag, ps, children.map(v => [v.value0, v.value1]), true);


const createTextVNode = text => ({
    tag: text,
    props: {},
    children: [],
    type: 3
})

exports.mapView = mapf => vnode => Object.assign({}, vnode, {mapf: compose(vnode.mapf, mapf)})
exports.attr = k => v => [1, k, v]
exports.class_ = cls => [2, cls]
exports.noProp = [-1]
exports.unsafeOnWithEffect = k => v => [1, k, v]
exports.style = k => v => [3, k, v]
exports.h = h
exports.keyed = keyed
exports.text = createTextVNode
exports.lazy = view => val => ({ memo: [val], type: view})
exports.lazy2 = view => val1 => val2 => ({ memo: [val1, val2], type: view})
exports.lazy3 = view => val1 => val2 => val3 => ({ memo: [val1, val2, val3], type: view})