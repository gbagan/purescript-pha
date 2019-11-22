const mapObj = (map, obj) =>
    Object.entries(obj)
        .map(([k, v]) => [k, k[0] === "o" && k[1] === "n" ? map(v) : v])
        .reduce((o, [k, v]) => ((o[k] = v), o), {})

const mapVNode = (map, vnode) =>
    vnode.props
        ? Object.assign({}, vnode, {
              props: mapObj(map, vnode.props),
              children: vnode.children.map(child => mapVNode(map, child)),
          })
        : vnode

exports.viewOverAux = map => vnode => mapVNode(map, vnode);