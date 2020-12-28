// code comes from hyperapp by Jorge Bucaran
// https://github.com/jorgebucaran/hyperapp
// modified by Guillaume Bagan

const TEXT_NODE = 3

const merge = (a, b) => Object.assign({}, a, b);
const compose = (f, g) => f && g ? x => f(g(x)) : f || g;

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
    } else if (typeof newValue === "function") {
        if (
            !((node.actions || (node.actions = {}))[key] = mapf ? mapf(newValue) : newValue)
        ) {
            node.removeEventListener(key, listener)
        } else if (!oldValue) {
            node.addEventListener(key, listener)
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
        const oldNode = node
        node = parent.insertBefore(
            createNode(newVNode, listener, isSvg, mapf), //////////////////////
            node
        )
        if (oldNode) {
            parent.removeChild(oldNode)
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

        if(!node.keyed) {
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
                    const [_, newVNode] = getVNode(newVKids[newHead])
                    node.insertBefore(
                        createNode(newVNode, listener, isSvg, mapf),
                        oldVKids[oldHead][1].node
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
                    const [newKey, newVKid] = getVNode(newVKids[newHead], oldVKid)  /////////////////////////

                    if (newKeyed[oldKey] || newKey === getKey(oldVKids[oldHead + 1])) {
                        oldHead++
                        continue
                    }
                    if (oldKey === newKey) {
                        patch(node, oldVKid.node, oldVKid, newVKid, listener, isSvg, mapf)
                        newKeyed[newKey] = true
                        oldHead++
                    } else {
                        const tmpVKid = keyed[newKey]
                        if (tmpVKid != null) {
                            patch(
                                node,
                                node.insertBefore(tmpVKid.node, oldVKid.node),
                                tmpVKid,
                                newVKids[newHead],
                                listener,
                                isSvg,
                                mapf
                            )
                            newKeyed[newKey] = true
                        } else {
                            patch(node, oldVKid.node, null, newVKids[newHead], listener, isSvg, mapf)
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

const propsChanged = function (a, b) {
    for (let k in a) if (a[k] !== b[k]) return true
    for (let k in b) if (a[k] !== b[k]) return true
}

const getVNode = (newVNode, oldVNode) => {
    if (typeof newVNode[1].type === "function") {
        if (!oldVNode || oldVNode.memo == null || propsChanged(oldVNode.memo, newVNode[1].memo)) {
            oldVNode = newVNode.type(newVNode.memo)
            oldVNode.memo = newVNode.memo
        }
        newVNode[1] = oldVNode
    }
    return newVNode
}


const patchSubs = (oldSubs, newSubs, dispatch) => {
    const subs = []
    for (
        let i = 0;
        i < oldSubs.length || i < newSubs.length;
        i++
    ) {
        const oldSub = oldSubs[i]
        const newSub = newSubs[i]
        subs.push(
            newSub
                ? !oldSub || newSub[0] !== oldSub[0] || newSub[1] !== oldSub[1]
                    ? [newSub[0], newSub[1], newSub[0](dispatch)(newSub[1])(), oldSub && oldSub[2]()]
                    : oldSub
                : oldSub && oldSub[2]()
        )
    }
    return subs
}

exports.getAction = target => type => () => target.actions[type]
exports.patchSubs = oldSubs => newSubs => dispatch => () => patchSubs (oldSubs, newSubs, dispatch)
exports.patch = parent => node => oldVDom => newVDom => listener => () => patch(parent, node, oldVDom, newVDom, e => listener(e)())