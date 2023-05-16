// code comes from hyperapp by Jorge Bucaran
// https://github.com/jorgebucaran/hyperapp
// modified by Guillaume Bagan

const TEXT_NODE = 3

const compose = (f, g) => f && g ? x => f(g(x)) : f || g

const patchProperty = (node, key, newValue) => {
    node[key] = newValue;
}

const patchAttribute = (node, key, newValue) => {
    if (newValue == null || (key === "class" && !newValue)) {
        node.removeAttribute(key)
    } else {
        node.setAttribute(key, newValue)
    }
}

const patchEvent = (node, key, oldValue, newValue, listener, mapf) => {
    if (!node.actions)
        node.actions = {}
    node.actions[key] = mapf && newValue ? mapf(newValue) : newValue
    if (!newValue) {
        node.removeEventListener(key, listener)
    } else if (!oldValue) {
        node.addEventListener(key, listener)
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
    const attrs = vnode.attrs
    const events = vnode.events
    const mapf2 = compose(mapf, vnode.mapf)


    for (let k in props) {
        patchProperty(node, k, props[k])
    }
    for (let k in attrs) {
        patchAttribute(node, k, attrs[k])
    }
    for (let k in events) {
        patchEvent(node, k, null, events[k], listener, mapf2)
    }

    for (let i = 0, len = vnode.children.length; i < len; i++) {
        node.appendChild(
            createNode(
                getVNode(vnode.children[i]).html,
                listener,
                isSvg,
                mapf2
            )
        )
    }
    vnode.node = node
    return node
}

const patch = (parent, node, oldVNode, newVNode, listener, isSvg, mapf) => {
    if (oldVNode === newVNode) return
    
    if (oldVNode != null && oldVNode.type === TEXT_NODE && newVNode.type === TEXT_NODE) {
        if (oldVNode.tag !== newVNode.tag)
            node.nodeValue = newVNode.tag
    } else if (oldVNode == null || oldVNode.tag !== newVNode.tag) {
        node = parent.insertBefore(
            createNode(newVNode, listener, isSvg, mapf),
            node
        )
        if (oldVNode) {
            oldVNode.node.remove()
        }
    } else {
        const oldProps = oldVNode.props
        const newProps = newVNode.props

        for (let i in {...oldProps, ...newProps}) {
            if (oldProps[i] !== newProps[i]) {
                patchProperty(node, i, newProps[i])
            }
        }

        const oldAttrs = oldVNode.attrs
        const newAttrs = newVNode.attrs

        for (let i in {...oldAttrs, ...newAttrs}) {
            if (oldAttrs[i] !== newAttrs[i]) {
                patchAttribute(node, i, newAttrs[i])
            }
        }

        const oldEvents = oldVNode.events
        const newEvents = newVNode.events

        for (let i in {...oldEvents, ...newEvents}) {
            if (oldEvents[i] !== newEvents[i]) {
                patchEvent(node, i, oldEvents[i], newEvents[i], listener, mapf)
            }
        }

        const oldVKids = oldVNode.children
        const newVKids = newVNode.children
        let oldTail = oldVKids.length - 1
        let newTail = newVKids.length - 1

        mapf = compose(mapf, newVNode.mapf)
        isSvg = isSvg || newVNode.tag === "svg"

        if(!newVNode.keyed) { 
            for (let i = 0; i <= oldTail && i <= newTail; i++) {
                const oldVNode = oldVKids[i].html
                const newVNode = getVNode(newVKids[i], oldVNode).html
                patch(node, oldVNode.node, oldVNode, newVNode, listener, isSvg, mapf)
            }
            for (let i = oldTail + 1; i <= newTail; i++) {
                const newVNode = getVNode(newVKids[i], oldVNode).html
                node.appendChild(
                    createNode(newVNode, listener, isSvg, mapf)
                )
            }
            for (let i = newTail + 1; i <= oldTail; i++) {
                oldVKids[i].html.node.remove()
            }

        } else { //  node.keyed == true
            let oldHead = 0
            let newHead = 0
            while (newHead <= newTail && oldHead <= oldTail) {
                const {key: oldKey, html: oldVNode} = oldVKids[oldHead]
                if (oldKey !== newVKids[newHead].key)
                    break
                const newKNode = getVNode(newVKids[newHead], oldVNode)  ////////////////////
                patch(node, oldVNode.node, oldVNode, newKNode.html, listener, isSvg, mapf)
                newHead++
                oldHead++
            }

            while (newHead <= newTail && oldHead <= oldTail) {
                const {key: oldKey, html: oldVNode} = oldVKids[oldTail]
                if (oldKey !== newVKids[newTail].key)
                    break
                const newKNode = getVNode(newVKids[newTail], oldVNode)  ////////////////////
                patch(node, oldVNode.node, oldVNode, newKNode.html, listener, isSvg, mapf)
                newTail--
                oldTail--
            }

            if (oldHead > oldTail) {
                while (newHead <= newTail) {
                    const newVNode = getVNode(newVKids[newHead]).html
                    node.insertBefore(
                        createNode(newVNode, listener, isSvg, mapf),
                        oldVKids[oldHead] && oldVKids[oldHead].html.node
                    )
                    newHead++
                }
            } else if (newHead > newTail) {
                while (oldHead <= oldTail) {
                    oldVKids[oldHead].html.node.remove()
                    oldHead++
                }
            } else {
                const keyed = {}
                const newKeyed = {}
                for (let i = oldHead; i <= oldTail; i++) {
                    keyed[oldVKids[i].key] = oldVKids[i].html
                }

                while (newHead <= newTail) {                    
                    const {key: oldKey, html: oldVKid} = oldVKids[oldHead] || {key: null, html: null}
                    const {key: newKey, html: newVKid} = getVNode(newVKids[newHead], oldVKid)

                    if (newKeyed[oldKey] || oldVKids[oldHead+1] && newKey === oldVKids[oldHead+1].key) {
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
                                newVKids[newHead].html,
                                listener,
                                isSvg,
                                mapf
                            )
                            newKeyed[newKey] = true
                        } else {
                            patch(node, oldVKid && oldVKid.node, null, newVKids[newHead].html, listener, isSvg, mapf)
                        }
                    }
                    newHead++
                }
                /*
                while (oldHead <= oldTail) {
                    // dans certaines situations, removeChild est appelé ici et
                    // dans le cas juste après
                    console.log("3", oldVKids[oldHead].html.node)
                    node.removeChild(oldVKids[oldHead].html.node)
                    oldHead++
                }
                */
                for (let i in keyed) {
                    if (!newKeyed[i]) {
                        keyed[i].node.remove()
                    }
                }
            }
        }
    }
    newVNode.node = node
    return node
}

const propsChanged = (a, b) => {
    for (let i = 0; i < a.length; i++)
        if (a[i] !== b[i])
            return true
    return false
}

const getVNode = (newVNode, oldVNode) => {
    if (typeof newVNode.html.type === "function") {
        if (!oldVNode || oldVNode.memo == null || propsChanged(oldVNode.memo, newVNode.html.memo)) {
            oldVNode = copyVNode(newVNode.html.type(...newVNode.html.memo))
            oldVNode.memo = newVNode.html.memo
        }
        newVNode.html = oldVNode
    }
    return newVNode
}

export const copyVNode = vnode => ({
                            ...vnode,
                            children: vnode.children && vnode.children.map(({key, html}) => ({key, html: copyVNode(html)}))
                        })
export const getAction = (target, type) => target.actions[type]
export const unsafePatch = patch

export const unsafeLinkNode = node => vdom => { vdom.node = node; return vdom; }