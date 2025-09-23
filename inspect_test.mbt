///|
test {
  TestBlock::define(fn(t) { t.inspect(1.2323, expected="1.2323") })
}

///|
test {
  TestBlock::define(fn(t) { t.inspect("2323", expected="2323") })
}

///|
test {
  TestBlock::define(fn(t) {
    t.inspect("232", expected="232")
    t.inspect(132, expected="132")
    t.inspect("232", expected="232")
  })
}

///|
test {
  TestBlock::define(fn(t) { 
    // Test integers
    t.inspect(42, expected="42")
    t.inspect(-123, expected="-123")
    t.inspect(0, expected="0")
  })
}

///|
test {
  TestBlock::define(fn(t) { 
    // Test floating point numbers
    t.inspect(3.14159, expected="3.14159")
    t.inspect(-2.718, expected="-2.718")
    t.inspect(0.0, expected="0")
    t.inspect(1.0, expected="1")
  })
}

///|
test {
  TestBlock::define(fn(t) { 
    // Test booleans
    t.inspect(true, expected="true")
    t.inspect(false, expected="false")
  })
}

///|
test {
  TestBlock::define(fn(t) { 
    // Test strings with various content
    t.inspect("hello world", expected="hello world")
    t.inspect("", expected="")
    t.inspect("special chars: !@#$%^&*()", expected="special chars: !@#$%^&*()")
    t.inspect("unicode: 你好世界", expected="unicode: 你好世界")
  })
}

///|
test {
  TestBlock::define(fn(t) { 
    // Test arrays
    t.inspect([1, 2, 3, 4, 5], expected="[1, 2, 3, 4, 5]")
    t.inspect([], expected="[]")
    t.inspect(["a", "b", "c"], expected="[\"a\", \"b\", \"c\"]")
    t.inspect([true, false, true], expected="[true, false, true]")
  })
}

///|
test {
  TestBlock::define(fn(t) { 
    // Test nested structures
    t.inspect([[1, 2], [3, 4], [5, 6]], expected="[[1, 2], [3, 4], [5, 6]]")
    t.inspect([["hello"], ["world"]], expected="[[\"hello\"], [\"world\"]]")
  })
}

///|
test {
  TestBlock::define(fn(t) { 
    // Test mixed type combinations
    t.inspect(123, expected="123")
    t.inspect("test", expected="test")
    t.inspect(true, expected="true")
    t.inspect([1, 2, 3], expected="[1, 2, 3]")
  })
}