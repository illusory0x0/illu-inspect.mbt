///|
#callsite(autofill(loc, argsloc))
pub fn TestBlock::inspect(
  self : TestBlock,
  actual : &Show,
  expected? : String = "",
  loc~ : SourceLoc,
  argsloc~ : ArgsLoc,
) -> Unit {
  let actual = actual.to_string()
  if actual != expected {
    self.0.push(
      Failure(
        actual~,
        expected~,
        loc=try! @quote.SourceLocation::parse(loc.to_string()),
        argsloc=argsloc.0.map(lo => lo.map(l => try! @quote.SourceLocation::parse(
            l.to_string(),
          ))),
      ),
    )
  } else {
    self.0.push(Success)
  }
}

///|
#callsite(autofill(loc))
pub fn TestBlock::define(
  test_block : (TestBlock) -> Unit,
  loc~ : SourceLoc,
) -> Unit {
  let b = TestBlock::begin(loc~)
  test_block(b)
  b.end(loc~)
}

///|
#calsite(autofill(loc))
fn TestBlock::begin(loc~ : SourceLoc) -> TestBlock {
  let loc = try! @quote.SourceLocation::parse(loc.to_string())
  let file_path = loc.path.to_string()
  let file = try! @fs.read_file_to_string(file_path.to_string())
  match test_manager.0.get(file_path) {
    None =>
      test_manager.0[file_path] = TestFileManager::{
        file,
        count: moonbit_test_block_count(file),
        test_blocks: [],
        current_test_block_index: 1,
      }
    Some(manager) => manager.current_test_block_index += 1
  }
  []
}

///|
#callsite(autofill(loc))
fn TestBlock::end(self : TestBlock, loc~ : SourceLoc) -> Unit {
  if is_inspect_update {
    let loc = try! @quote.SourceLocation::parse(loc.to_string())
    let file_path = loc.path.to_string()
    let file_manager = test_manager.0[file_path]
    file_manager.test_blocks.push(self)
    if file_manager.test_blocks.length() == file_manager.count {
      file_manager.update_source_file()
    }
  } else {
    self.check_source_file()
  }
}

///|
fn[A, B] coerce(x : A) -> B = "%identity"

///|
fn TestBlock::check_source_file(self : TestBlock) -> Unit {
  for state in self.0 {
    guard state is Failure(actual~, expected~, loc~) else { continue }
    print_error_message(
      (
        $| test fail in \{loc.path}:\{loc.start.row}:\{loc.start.column}-\{loc.end.row}:\{loc.end.column}
        $| 
        $| expected: \{expected.escape()}
        $|
        $| actual: \{actual.escape()}
      ),
    )
  }
}

///|
fn moonbit_test_block_count(file : String) -> Int {
  let mut count = 0
  let lines = file.split("\n")
  for line in lines {
    // Find the start of non-whitespace content
    let mut start_idx = 0
    while start_idx < line.length() {
      let ch = line.get_char(start_idx)
      match ch {
        Some(' ') | Some('\t') => start_idx += 1
        _ => break
      }
    }

    // Check if line starts with "test" (after whitespace)
    if start_idx + 4 <= line.length() {
      let mut matches_test = true
      let test_word = "test"
      for i = 0; i < 4; i = i + 1 {
        if line.get_char(start_idx + i) != test_word.get_char(i) {
          matches_test = false
          break
        }
      }
      if matches_test {
        // Check what follows "test"
        let after_test_idx = start_idx + 4
        if after_test_idx >= line.length() {
          continue // "test" at end of line, likely not a test block
        }
        let next_char = line.get_char(after_test_idx)
        match next_char {
          Some(' ') | Some('\t') | Some('"') | Some('{') =>
            // Verify this is actually a test block by checking for opening brace
            if line.contains("{") {
              count += 1
            }
          _ => continue
        }
      }
    }
  }
  count
}
