// code comes from hyperapp by Jorge Bucaran
// https://github.com/jorgebucaran/hyperapp
// modified by Guillaume Bagan

const TEXT_NODE = 3

const merge = (a, b) => Object.assign({}, a, b)
const compose = (f, g) => f && g ? x => f(g(x)) : f || g

const patchProperty = (node, key, oldValue, newValue, listener, isSvg, mapf) => {
    if (key === "style") {
        for (let k in merge(oldValue, newValue)) {
            oldValue = newValue == null || newValue[k] == null ? "" : newValue[k]
            if (k[0] === "-") {
                node[key].setProperty(k, oldValue)
            } else {
                node[key][k] = oldValue
            }
        }
    } else if (key[0] === "o" && key[1] === "n") {
        const key2 = key.slice(2);
        (node.actions || (node.actions = {}))[key2] = mapf && newValue ? mapf(newValue) : newValue
        if (!newValue) {
            node.removeEventListener(key2, listener)
        } else if (!oldValue) {
            node.addEventListener(key2, listener)
        }
    } else if (!isSvg && key !== "list" && key in node) {
        node[key] = newValue
    } else if (newValue == null || newValue === false || (key === "class" && !newValue)) {
        node.removeAttribute(key)
    } else {
        node.setAttribute(key, newValue)
    }
}

const createNode = (vnode, listener, isSvg, mapf) => {
    const node =
        vnode.type === TEXT_NODE
            ? document.createTextNode(vnode.tag)
            : (isSvg = isSvg || vnode.tag === "svg")
                ? document.createElementNS("http://www.w3.org/2000/svg", vnode.tag)
                : document.createElement(vnode.tag)
    const props = vnode.props
    mapf = compose(mapf, vnode.mapf);

    for (let k in props) {
        patchProperty(node, k, null, props[k], listener, isSvg, mapf)
    }
    for (let i = 0, len = vnode.children.length; i < len; i++) {
        node.appendChild(
            createNode(
                getVNode(vnode.children[i])[1],
                listener,
                isSvg,
                mapf
            )
        )
    }

    return (vnode.node = node)
}

const getKey = keyednode => keyednode == null ? null : keyednode[0]

const patch = (parent, node, oldVNode, newVNode, listener, isSvg, mapf) => {
    if (oldVNode === newVNode) {
    } else if (oldVNode != null && oldVNode.type === TEXT_NODE && newVNode.type === TEXT_NODE) {
        if (oldVNode.tag !== newVNode.tag)
            node.nodeValue = newVNode.tag
    } else if (oldVNode == null || oldVNode.tag !== newVNode.tag) {
        node = parent.insertBefore(
            createNode(newVNode, listener, isSvg, mapf),
            node
        )//todo
        if (oldVNode && oldVNode.node) {
            parent.removeChild(oldVNode.node)
        }
    } else {
        const oldVProps = oldVNode.props
        const newVProps = newVNode.props

        const oldVKids = oldVNode.children
        const newVKids = newVNode.children

        let oldHead = 0
        let newHead = 0
        let oldTail = oldVKids.length - 1
        let newTail = newVKids.length - 1

        mapf = compose(mapf, newVNode.mapf)
        isSvg = isSvg || newVNode.tag === "svg"

        for (let i in merge(oldVProps, newVProps)) {
            if (
                (i === "value" || i === "selected" || i === "checked"
                    ? node[i]
                    : oldVProps[i]) !== newVProps[i]
            ) {
                patchProperty(node, i, oldVProps[i], newVProps[i], listener, isSvg, mapf)
            }
        }

        if(!newVNode.keyed) {
            for (let i = 0; i <= oldTail && i <= newTail; i++) {
                const oldVNode = oldVKids[i][1]
                const newVNode = getVNode(newVKids[i], oldVNode)[1]
                patch(node, oldVNode.node, oldVNode, newVNode, listener, isSvg, mapf)
            }
            for (let i = oldTail + 1; i <= newTail; i++) {
                const newVNode = getVNode(newVKids[i], oldVNode)[1]
                node.appendChild(
                    createNode(newVNode, listener, isSvg, mapf)
                )
            }
            for (let i = newTail + 1; i <= oldTail; i++) {
                node.removeChild(oldVKids[i][1].node)
            }

        } else { //  node.keyed == true
            while (newHead <= newTail && oldHead <= oldTail) {
                const [oldKey, oldVNode] = oldVKids[oldHead]
                if (oldKey !==  newVKids[newHead][0])
                    break
                const newKNode = getVNode(newVKids[newHead], oldVNode)  ////////////////////
                patch(node, oldVNode.node, oldVNode, newKNode[1], listener, isSvg, mapf)
                newHead++
                oldHead++
            }

            while (newHead <= newTail && oldHead <= oldTail) {
                const [oldKey, oldVNode] = oldVKids[oldTail]
                if (oldKey !== newVKids[newTail][0])
                    break
                const newKNode = getVNode(newVKids[newTail], oldVNode)  ////////////////////
                patch(node, oldVNode.node, oldVNode, newKNode[1], listener, isSvg, mapf)
                newTail--
                oldTail--
            }

            if (oldHead > oldTail) {
                while (newHead <= newTail) {
                    const newVNode = getVNode(newVKids[newHead])[1]
                    node.insertBefore(
                        createNode(newVNode, listener, isSvg, mapf),
                        oldVKids[oldHead] && oldVKids[oldHead][1].node
                    )
                    newHead++
                }
            } else if (newHead > newTail) {
                while (oldHead <= oldTail) {
                    node.removeChild(oldVKids[oldHead][1].node)
                    oldHead++
                }
            } else {
                const keyed = {}
                const newKeyed = {}
                for (let i = oldHead; i <= oldTail; i++) {
                    keyed[oldVKids[i][0]] = oldVKids[i][1]
                }

                while (newHead <= newTail) {
                    const [oldKey, oldVKid] = oldVKids[oldHead]
                    const [newKey, newVKid] = getVNode(newVKids[newHead], oldVKid)

                    if (newKeyed[oldKey] || newKey === getKey(oldVKids[oldHead + 1])) {
                        oldHead++
                        continue
                    }
                    if (oldKey === newKey) {
                        patch(node, oldVKid.node, oldVKid, newVKid, listener, isSvg, mapf)
                        newKeyed[newKey] = true
                        oldHead++
                    } else {
                        const vkid = keyed[newKey]
                        if (vkid != null) {
                            patch(
                                node,
                                node.insertBefore(vkid.node, oldVKid.node),
                                vkid,
                                newVKids[newHead][1],
                                listener,
                                isSvg,
                                mapf
                            )
                            newKeyed[newKey] = true
                        } else {
                            // todo
                            patch(node, oldVKid.node, null, newVKids[newHead][1], listener, isSvg, mapf)
                        }
                    }
                    newHead++
                }

                for (let i in keyed) {
                    if (!newKeyed[i]) {
                        node.removeChild(keyed[i].node)
                    }
                }
            }
        }
    }

    return (newVNode.node = node)
}

const propsChanged = (a, b) => {
    for (let i = 0; i < a.length; i++)
        if (a[i] !== b[i])
            return true
    return false
}

const evalMemo = (f, memo) => memo.reduce((g, v) => g(v), f)

const getVNode = (newVNode, oldVNode) => {
    if (typeof newVNode[1].type === "function") {
        if (!oldVNode || oldVNode.memo == null || propsChanged(oldVNode.memo, newVNode[1].memo)) {
            oldVNode = copyVNode(evalMemo(newVNode[1].type, newVNode[1].memo))
            oldVNode.memo = newVNode[1].memo
        }
        newVNode[1] = oldVNode
    }
    return newVNode
}

const copyVNode = vnode => Object.assign({}, vnode, {children: vnode.children && vnode.children.map(([k, v]) => [k, copyVNode(v)]) })

exports.copyVNode = copyVNode
exports.getAction = target => type => () => target.actions[type]
exports.unsafePatch = parent => node => oldVDom => newVDom => listener => () => patch(parent, node, oldVDom, newVDom, e => listener(e)())