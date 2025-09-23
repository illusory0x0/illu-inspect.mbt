# illusory0x0/inspect 🔮

A powerful **quotation meta programming** library that hacks MoonBit's snapshot test system! This library allows you to customize `moon test` behavior with automatic source file updates and enhanced testing capabilities.

## 🚀 Features

- **Meta Programming Magic**: Uses quotation to manipulate source code at compile time
- **Snapshot Test Hacking**: Automatically updates test expectations in source files
- **Custom Test Framework**: Build your own testing behavior on top of MoonBit's test system
- **Source Code Manipulation**: Dynamically modify your `.mbt` files during testing
- **Environment-Driven Updates**: Control test behavior via environment variables

## 📦 Installation

Add to your `moon.mod.json`:

```json
{
  "deps": {
    "illusory0x0/inspect": "*"
  }
}
```

Or use the moon CLI:

```bash
moon add illusory0x0/inspect
```

## 🎯 Quick Start

The library provides a `TestBlock` API that allows you to create custom test behaviors:

```moonbit
///|
test "basic usage example" {
  TestBlock::define(fn(t) {
    t.inspect(1 + 1, expected="2")
    t.inspect("hello".length(), expected="5")
    t.inspect([1, 2, 3].length(), expected="3")
  })
}
```

## 🔧 Environment-Driven Testing

### Running Tests Normally

```bash
moon test
```

When tests fail, you'll see detailed error messages showing expected vs actual values.

### Auto-Updating Test Expectations

```bash
ILLU_MOON_UPDATE=true moon test
```

This **automatically updates your source files** to match the actual test results! The library will:

1. Parse your source code using quotation meta programming
2. Locate the failing `expected=""` parameters
3. Update them with the actual values
4. Write the changes back to your `.mbt` files

## 🧩 Advanced Usage

### Multiple Assertions in One Test

```moonbit
///|
test "multiple assertions" {
  TestBlock::define(fn(t) {
    let data = [1, 2, 3, 4, 5]
    t.inspect(data.length(), expected="5")
    t.inspect(data[0], expected="1")
    t.inspect(data.filter(fn(x) { x > 3 }), expected="[4, 5]")
  })
}
```

### Testing Complex Data Structures

```moonbit
///|
struct Point {
  x : Int
  y : Int
} derive(Show)

///|
test "struct testing" {
  TestBlock::define(fn(t) {
    let p = Point::{ x: 10, y: 20 }
    t.inspect(p, expected="{x: 10, y: 20}")
    t.inspect(p.x + p.y, expected="30")
  })
}
```

## 🎭 How the Magic Works

This library leverages several advanced MoonBit features:

1. **Quotation System**: Uses `@quote.SourceLocation` to track where tests are defined
2. **Compile-Time Inspection**: The `#callsite(autofill(loc, argsloc))` attribute captures source locations
3. **File System Access**: Reads and writes source files during test execution  
4. **Meta Programming**: Parses and manipulates MoonBit source code on the fly

The core hack works by:

- Intercepting test calls with quotation-powered location tracking
- Comparing actual vs expected values  
- When update mode is enabled, parsing the source file and updating `expected=""` parameters
- Preserving all other source code exactly as-is

## 🎪 Cool Examples

### Auto-Correcting Calculations

```moonbit
///|
test "math that auto-corrects" {
  TestBlock::define(fn(t) {
    // Write the wrong expected value initially
    t.inspect(fibonacci(10), expected="55")
    // Run with ILLU_MOON_UPDATE=true and it becomes:
    // t.inspect(fibonacci(10), expected="55")
  })
}

///|
fn fibonacci(n : Int) -> Int {
  if n <= 1 {
    n
  } else {
    fibonacci(n - 1) + fibonacci(n - 2)
  }
}
```

### API Response Testing

```moonbit  
///|
test "api response format" {
  TestBlock::define(fn(t) {
    let response : Map[String, String] = { "status": "ok", "data": "numbers" }
    t.inspect(
      response.to_string(),
      expected="{\"status\": \"ok\", \"data\": \"numbers\"}",
    ) // Auto-fills!
  })
}
```

## 🎨 Why This is Cool and Funny

1. **Breaks the Rules**: Most test frameworks are passive - this one actively modifies your source code!

2. **Self-Healing Tests**: Write broken tests and watch them fix themselves

3. **Meta Programming Mastery**: Shows off MoonBit's advanced quotation capabilities  

4. **Hack the Platform**: Uses the test system in ways it was never intended

5. **Development Flow**: Enables a "write first, assert later" development style

## 🚨 Important Notes

- **Backup Your Code**: The auto-update feature modifies source files directly
- **Version Control**: Always commit before running update mode
- **Development Only**: This is primarily a development/testing tool
- **File Permissions**: Ensure your `.mbt` files are writable when using update mode

## 🔮 Future Possibilities

This meta programming approach opens doors to:

- Custom testing DSLs
- Automatic documentation generation  
- Code transformation pipelines
- Dynamic behavior injection
- Source code analysis tools

## 🤝 Contributing

This library demonstrates the power of MoonBit's quotation system. Feel free to:

- Report issues or suggest improvements
- Extend the meta programming capabilities
- Build additional testing utilities on top

## 📄 License

Apache-2.0

---

**Warning**: This library performs source code manipulation. Use with caution and proper version control! 🧙‍♂️✨