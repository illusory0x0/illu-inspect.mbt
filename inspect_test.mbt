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
