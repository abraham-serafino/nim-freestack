type StackNode* = object
  data: pointer
  next: ptr StackNode
#/Node

type Stack* = object
  topNode: ptr StackNode
#/Stack

proc insertNode [T](
  this: var Stack,
  t: typedesc[T],
  size: int = sizeof(t)
): ptr StackNode =
  let node = cast[ptr StackNode](alloc0(sizeof(StackNode)))
  assert node != nil

  node.data = cast[ptr T](alloc0(size))
  assert node.data != nil

  if this.topNode != nil:
    node.next = this.topNode
  #/if

  this.topNode = node
  result = node
#/insertNode

proc push* [T](this: var Stack,t: typedesc[T]): ptr T =
  let node = this.insertNode(t)
  result = cast[ptr T](node.data)
#/stack.push(T)

proc push* [T](this: var Stack, t: typedesc[T], value: T): ptr T =
  let node = this.insertNode(t, sizeof(value))
  cast[ptr T](node.data)[] = value

  result = cast[ptr T](node.data)
#/stack.push(T, value)

proc pop* [T](this: var Stack, _: typedesc[T], res: var T): bool =
  if this.topNode == nil:
    return false

  let node = this.topNode
  this.topNode = node.next
  res = cast[ptr T](node.data)[]

  dealloc(node.data)
  dealloc(node)

  return true
#/stack.pop(T)

proc pop (this: var Stack): pointer =
  if this.topNode == nil:
    return nil

  let node = this.topNode
  this.topNode = node.next

  dealloc(node.data)
  dealloc(node)

  return this.topNode
#/stack.pop(T)

proc `=destroy` (this: var Stack) =
  while this.topNode != nil:
    discard this.pop()
