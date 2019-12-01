const LAZY_NODE = 2
const TEXT_NODE = 3

const compose = (f, g) => f && g ? x => f(g(x)) : f || g; 

const h = name => ps => children => {
    const style = {};
    const props = {style};
    const vdom = { name, children: children.filter(x => x), props, node: null };
    const n = ps.length;
    for (let i = 0; i < n; i++) {
        const [t, k, v] = ps[i];
        if (t === 0)
            vdom.key = k;
        else if (t == 1)
            props[k] = v;
        else if (t === 2)
            props.class = (props.class ? props.class + " " : "") + k;
        else if (t === 3)
            style[k] = v;
    }
    return vdom;
}

const createTextVNode = text => ({
    name: text,
    props: {},
    children: [],
    type: 3
})

const lazy = st => view => ({
    type: LAZY_NODE,
    lazy: {
        view: (x => view(x.state)),
        state: st
    }
});

exports.mapView = mapf => vnode => Object.assign({}, vnode, {mapf: compose(vnode.mapf, mapf)})
exports.emptyNode = null
exports.appAux = appAux
exports.key = key => [0, key]
exports.attr = k => v => [1, k, v]
exports.class_ = cls => [2, cls]
exports.noProp = [-1]
exports.unsafeOnWithEffect = k => v => [1, k, v]
exports.style = k => v => [3, k, v]
exports.h = h
exports.text = createTextVNode
exports.lazy = lazy
