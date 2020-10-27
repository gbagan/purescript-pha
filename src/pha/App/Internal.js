// code comes from hyperapp by Jorge Bucaran
// https://github.com/jorgebucaran/hyperapp
// modified by Guillaume Bagan

const RECYCLED_NODE = 1
const TEXT_NODE = 3
const EMPTY_OBJ = {}
const EMPTY_ARR = []
const map = EMPTY_ARR.map
const defer = requestAnimationFrame || setTimeout

const merge = (a, b) => Object.assign({}, a, b);
const compose = (f, g) => f && g ? x => f(g(x)) : f || g;

const patchProperty = (node, key, oldValue, newValue, listener, isSvg, mapf) => {
    if (key === "key") {
    }
    else if (key === "style") {
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
            ? document.createTextNode(vnode.name)
            : (isSvg = isSvg || vnode.name === "svg")
                ? document.createElementNS("http://www.w3.org/2000/svg", vnode.name)
                : document.createElement(vnode.name)
    const props = vnode.props
    mapf = compose(mapf, vnode.mapf);

    for (let k in props) {
        patchProperty(node, k, null, props[k], listener, isSvg, mapf)
    }

    for (let i = 0, len = vnode.children.length; i < len; i++) {
        node.appendChild(
            createNode(
                (vnode.children[i] = getVNode(vnode.children[i])),
                listener,
                isSvg,
                mapf
            )
        )
    }

    return (vnode.node = node)
}

const getKey = vnode => vnode == null ? null : vnode.key;

const patch = function (parent, node, oldVNode, newVNode, listener, isSvg, mapf) {
    if (oldVNode === newVNode) {
    } else if (
        oldVNode != null &&
        oldVNode.type === TEXT_NODE &&
        newVNode.type === TEXT_NODE
    ) {
        if (oldVNode.name !== newVNode.name)
            node.nodeValue = newVNode.name
    } else if (oldVNode == null || oldVNode.name !== newVNode.name) {
        node = parent.insertBefore(
            createNode((newVNode = getVNode(newVNode)), listener, isSvg, mapf),
            node
        )
        if (oldVNode != null) {
            parent.removeChild(oldVNode.node)
        }
    } else {
        let tmpVKid
        let oldVKid

        let oldKey
        let newKey

        const oldVProps = oldVNode.props
        const newVProps = newVNode.props

        const oldVKids = oldVNode.children
        const newVKids = newVNode.children

        let oldHead = 0
        let newHead = 0
        let oldTail = oldVKids.length - 1
        let newTail = newVKids.length - 1

        mapf = compose(mapf, newVNode.mapf);
        isSvg = isSvg || newVNode.name === "svg"

        for (let i in merge(oldVProps, newVProps)) {
            if (
                (i === "value" || i === "selected" || i === "checked"
                    ? node[i]
                    : oldVProps[i]) !== newVProps[i]
            ) {
                patchProperty(node, i, oldVProps[i], newVProps[i], listener, isSvg, mapf)
            }
        }

        while (newHead <= newTail && oldHead <= oldTail) {
            if (
                (oldKey = getKey(oldVKids[oldHead])) == null ||
                oldKey !== getKey(newVKids[newHead])
            ) {
                break
            }

            patch(
                node,
                oldVKids[oldHead].node,
                oldVKids[oldHead],
                (newVKids[newHead] = getVNode(
                    newVKids[newHead++],
                    oldVKids[oldHead++]
                )),
                listener,
                isSvg,
                mapf
            )
        }

        while (newHead <= newTail && oldHead <= oldTail) {
            if (
                (oldKey = getKey(oldVKids[oldTail])) == null ||
                oldKey !== getKey(newVKids[newTail])
            ) {
                break
            }

            patch(
                node,
                oldVKids[oldTail].node,
                oldVKids[oldTail],
                (newVKids[newTail] = getVNode(
                    newVKids[newTail--],
                    oldVKids[oldTail--]
                )),
                listener,
                isSvg,
                mapf
            )
        }

        if (oldHead > oldTail) {
            while (newHead <= newTail) {
                node.insertBefore(
                    createNode(
                        (newVKids[newHead] = getVNode(newVKids[newHead++])),
                        listener,
                        isSvg,
                        mapf
                    ),
                    (oldVKid = oldVKids[oldHead]) && oldVKid.node
                )
            }
        } else if (newHead > newTail) {
            while (oldHead <= oldTail) {
                node.removeChild(oldVKids[oldHead++].node)
            }
        } else {
            const keyed = {}
            const newKeyed = {}
            for (let i = oldHead; i <= oldTail; i++) {
                if ((oldKey = oldVKids[i].key) != null) {
                    keyed[oldKey] = oldVKids[i]
                }
            }

            while (newHead <= newTail) {
                oldKey = getKey((oldVKid = oldVKids[oldHead]))
                newKey = getKey(
                    (newVKids[newHead] = getVNode(newVKids[newHead], oldVKid))
                )

                if (
                    newKeyed[oldKey] ||
                    (newKey != null && newKey === getKey(oldVKids[oldHead + 1]))
                ) {
                    if (oldKey == null) {
                        node.removeChild(oldVKid.node)
                    }
                    oldHead++
                    continue
                }

                if (newKey == null) {
                    if (oldKey == null) {
                        patch(
                            node,
                            oldVKid && oldVKid.node,
                            oldVKid,
                            newVKids[newHead],
                            listener,
                            isSvg,
                            mapf
                        )
                        newHead++
                    }
                    oldHead++
                } else {
                    if (oldKey === newKey) {
                        patch(
                            node,
                            oldVKid.node,
                            oldVKid,
                            newVKids[newHead],
                            listener,
                            isSvg,
                            mapf
                        )
                        newKeyed[newKey] = true
                        oldHead++
                    } else {
                        if ((tmpVKid = keyed[newKey]) != null) {
                            patch(
                                node,
                                node.insertBefore(tmpVKid.node, oldVKid && oldVKid.node),
                                tmpVKid,
                                newVKids[newHead],
                                listener,
                                isSvg,
                                mapf
                            )
                            newKeyed[newKey] = true
                        } else {
                            patch(
                                node,
                                oldVKid && oldVKid.node,
                                null,
                                newVKids[newHead],
                                listener,
                                isSvg,
                                mapf
                            )
                        }
                    }
                    newHead++
                }
            }

            while (oldHead <= oldTail) {
                if (getKey((oldVKid = oldVKids[oldHead++])) == null) {
                    node.removeChild(oldVKid.node)
                }
            }

            for (let i in keyed) {
                if (newKeyed[i] == null) {
                    node.removeChild(keyed[i].node)
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

const getVNode = (newVNode, oldVNode) =>
    typeof newVNode.type === "function"
        ? ((!oldVNode || oldVNode.memo == null || propsChanged(oldVNode.memo, newVNode.memo)) &&
            ((oldVNode = newVNode.type(newVNode.memo)).memo = newVNode.memo),
            oldVNode)
        : newVNode

const createVNode = (name, props, children, node, key, type) =>
    ({ name, props, children, node, type, key })

const recycleNode = node =>
    node.nodeType === TEXT_NODE
        ? createTextVNode(node.nodeValue, node)
        : createVNode(
            node.nodeName.toLowerCase(),
            EMPTY_OBJ,
            map.call(node.childNodes, recycleNode),
            node,
            null,
            RECYCLED_NODE
        )

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

const app = props => {
    let state = null
    let lock = false
    let subs = []

    const listener = e => dispatchEvent(e)(e.currentTarget.actions[e.type])()

    const getState = () => state

    const setState = newState => () => {
        if (state !== newState) {
            state = newState
            subs = patchSubs(subs, subscriptions(state), dispatch)
            if (!lock) {
                lock = true
                defer(() => render(state)());
            }
        }
    }

    let node = null;
    let vdom = null;

    const renderVDom = newVdom => () => {
        lock = false
        node = patch(
            node.parentNode,
            node,
            vdom,
            vdom = newVdom,
            listener
        )
    }

    const { render, subscriptions, dispatch, dispatchEvent, init } = props({ getS: getState, setS: setState, renderVDom })

    return rootnode => () => {
        node = document.getElementById(rootnode)
        if (!node)
            return
        vdom = node && recycleNode(node)
        init()
    }
}

exports.app = app
