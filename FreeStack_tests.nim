import unittest, FreeStack

suite "Stack Arena":
  test "any datatype can be pushed onto the stack":
    var s = Stack()
    let myInt = s.push(int, 99)
    check myInt[] == 99

    var s2 = Stack()
    let myStr = s2.push(cstring, cstring("Hello world"))
    check myStr[] == cstring("Hello world")
  #/test

  test "space can be allocated on the stack without a value":
    var s = Stack()
    let myInt = s.push(int)
    check myInt[] == 0

    var s2 = Stack()
    let myAry = s2.push(array[17, int])
    check myAry[16] == 0
  #/test

  test "items are popped from the stack in LIFO order":
    var s = Stack()
    discard s.push(int, 1)
    discard s.push(int, 2)
    discard s.push(int, 3)

    var currValue: int
    check s.pop(int, currValue) == true and currValue == 3
    check s.pop(int, currValue) == true and currValue == 2
    check s.pop(int, currValue) == true and currValue == 1
  #/test

  test "stacks can be shared with other scopes":
    proc innerScope(outerStack: var Stack)

    proc outerScope () =
      var outerStack = Stack()

      # Any pointers that are shared between scopes should be pushed
      # onto the outer scope's stack.
      var message = outerStack.push(string, "Hello")

      innerScope(outerStack)

      var newMessage: string
      check outerStack.pop(string, newMessage)
      check newMessage == "Hello world!"

    proc innerScope(outerStack: var Stack) =
      # The inner scope can have it's own, separate stack.
      var innerStack = Stack()

      var message: string
      check outerStack.pop(string, message)
      check message == "Hello"

      let innerStr = innerStack.push(string, " world!")

      # Any pointers that are shared between scopes should be pushed
      # onto the outer scope's stack.
      discard outerStack.push(string, string(message & innerStr[]))

    outerScope()
