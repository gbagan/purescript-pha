// code comes from hyperapp by Jorge Bucaran
// https://github.com/jorgebucaran/hyperapp

const RECYCLED_NODE = 1
const LAZY_NODE = 2
const TEXT_NODE = 3
const EMPTY_OBJ = {}
const EMPTY_ARR = []
const map = EMPTY_ARR.map
const defer = requestAnimationFrame || setTimeout

const merge = function(a, b) {
  var out = {}

  for (var k in a) out[k] = a[k]
  for (var k in b) out[k] = b[k]

  return out
}

const patchProperty = function(node, key, oldValue, newValue, listener, isSvg) {
  if (key === "key") {
  } else if (key === "style") {
    for (var k in merge(oldValue, newValue)) {
      oldValue = newValue == null || newValue[k] == null ? "" : newValue[k]
      //if (oldValue === "")
      //  node[key].removeProperty(k);
      // else
      if (k[0] === "-") {
        node[key].setProperty(k, oldValue)
      } else {
        node[key][k] = oldValue
      }
    }
  } else if (key[0] === "o" && key[1] === "n") {
    if (
      !((node.actions || (node.actions = {}))[
        (key = key.slice(2).toLowerCase())
      ] = newValue)
    ) {
      node.removeEventListener(key, listener)
    } else if (!oldValue) {
      node.addEventListener(key, listener)
    }
  } else if (!isSvg && key !== "list" && key in node) {
    node[key] = newValue == null ? "" : newValue
  } else if (
    newValue == null ||
    newValue === false ||
    (key === "class" && !newValue)
  ) {
    node.removeAttribute(key)
  } else {
    node.setAttribute(key, newValue)
  }
}

const createNode = function(vnode, listener, isSvg) {
  var node =
    vnode.type === TEXT_NODE
      ? document.createTextNode(vnode.name)
      : (isSvg = isSvg || vnode.name === "svg")
      ? document.createElementNS("http://www.w3.org/2000/svg", vnode.name)
      : document.createElement(vnode.name)
  var props = vnode.props

  for (var k in props) {
    patchProperty(node, k, null, props[k], listener, isSvg)
  }

  for (var i = 0, len = vnode.children.length; i < len; i++) {
    node.appendChild(
      createNode(
        (vnode.children[i] = getVNode(vnode.children[i])),
        listener,
        isSvg
      )
    )
  }

  return (vnode.node = node)
}

const getKey = vnode => vnode == null ? null : vnode.key;

const patch = function(parent, node, oldVNode, newVNode, listener, isSvg) {
  if (oldVNode === newVNode) {
  } else if (
    oldVNode != null &&
    oldVNode.type === TEXT_NODE &&
    newVNode.type === TEXT_NODE
  ) {
    if (oldVNode.name !== newVNode.name) node.nodeValue = newVNode.name
  } else if (oldVNode == null || oldVNode.name !== newVNode.name) {
    node = parent.insertBefore(
      createNode((newVNode = getVNode(newVNode)), listener, isSvg),
      node
    )
    if (oldVNode != null) {
      parent.removeChild(oldVNode.node)
    }
  } else {
    var tmpVKid
    var oldVKid

    var oldKey
    var newKey

    var oldVProps = oldVNode.props
    var newVProps = newVNode.props

    var oldVKids = oldVNode.children
    var newVKids = newVNode.children

    var oldHead = 0
    var newHead = 0
    var oldTail = oldVKids.length - 1
    var newTail = newVKids.length - 1

    isSvg = isSvg || newVNode.name === "svg"

    for (var i in merge(oldVProps, newVProps)) {
      if (
        (i === "value" || i === "selected" || i === "checked"
          ? node[i]
          : oldVProps[i]) !== newVProps[i]
      ) {
        patchProperty(node, i, oldVProps[i], newVProps[i], listener, isSvg)
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
        isSvg
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
        isSvg
      )
    }

    if (oldHead > oldTail) {
      while (newHead <= newTail) {
        node.insertBefore(
          createNode(
            (newVKids[newHead] = getVNode(newVKids[newHead++])),
            listener,
            isSvg
          ),
          (oldVKid = oldVKids[oldHead]) && oldVKid.node
        )
      }
    } else if (newHead > newTail) {
      while (oldHead <= oldTail) {
        node.removeChild(oldVKids[oldHead++].node)
      }
    } else {
      for (var i = oldHead, keyed = {}, newKeyed = {}; i <= oldTail; i++) {
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

        if (newKey == null || oldVNode.type === RECYCLED_NODE) {
          if (oldKey == null) {
            patch(
              node,
              oldVKid && oldVKid.node,
              oldVKid,
              newVKids[newHead],
              listener,
              isSvg
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
              isSvg
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
                isSvg
              )
              newKeyed[newKey] = true
            } else {
              patch(
                node,
                oldVKid && oldVKid.node,
                null,
                newVKids[newHead],
                listener,
                isSvg
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

      for (var i in keyed) {
        if (newKeyed[i] == null) {
          node.removeChild(keyed[i].node)
        }
      }
    }
  }

  return (newVNode.node = node)
}

const propsChanged = function(a, b) {
  for (var k in a) if (a[k] !== b[k]) return true
  for (var k in b) if (a[k] !== b[k]) return true
}

const getVNode = function(newVNode, oldVNode) {
  return newVNode.type === LAZY_NODE
    ? ((!oldVNode || propsChanged(oldVNode.lazy, newVNode.lazy)) &&
        ((oldVNode = newVNode.lazy.view(newVNode.lazy)).lazy = newVNode.lazy),
      oldVNode)
    : newVNode
}

const createVNode = function(name, props, children, node, key, type) {
  return {
    name: name,
    props: props,
    children: children,
    node: node,
    type: type,
    key: key
  }
}

const createTextVNode = (value, node) =>
    createVNode(value, EMPTY_OBJ, EMPTY_ARR, node, null, TEXT_NODE);

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

const appAux = disp => props => () => {
  const {view, events, effects, init} = props
  let state = {};
  let lock = false
  let node = document.getElementById(props.node);
  let vdom = node && recycleNode(node);

  const listener = function(event) {
    dispatch(event, this.actions[event.type]);
  }
 
  const setState = newState => {
    if (state !== newState) {
      state = newState;
      if (!lock) defer(render, (lock = true))
    }
    return state
  }

  const dispatch = (event, action) => disp(() => state)(fn => () => setState(fn(state)))(effects(event))(action)();

  const rawEvent = (name, action) => {
     const listener = event => dispatch(event, action);
     addEventListener (name, listener);
   }


  const render = () => {
    lock = false
    node = patch(
      node.parentNode,
      node,
      vdom,
      vdom = view(state),
      listener
    )
  }
  setState(props.state);
  for (let i = 0; i < events.length; i++) {
     rawEvent(events[i].value0, events[i].value1);
  }
  dispatch(undefined, init);
}

const h = isStyle => name => ps => children => {
    const style = {};
    const props = {style};
    const vdom = { name, children: children.filter(x => x), props, node: null };
    const n = ps.length;
    for (let i = 0; i < n; i++) {
        const obj = ps[i];
        const value0 = obj.value0;
        const value1 = obj.value1;
        if (value1 === undefined)
            vdom.key = value0;
        else if (typeof value1 === 'object')
            vdom.props["on"+value0] = value1;
        else if (typeof value1 === 'boolean') {
            if(!value1)
                {}
            else if (props.class)  
                props.class += ' ' + value0;
            else
                props.class = value0;
        }
        else if (isStyle(obj))
            style[value0] = value1;
        else
            props[value0] = value1;
    }
    return vdom;
}

exports.emptyNode = null;
exports.appAux = appAux;
exports.hAux = h;
exports.text = createTextVNode;