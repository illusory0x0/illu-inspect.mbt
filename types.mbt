///|
fnalias println as print_error_message

///|
fn is_update() -> Bool {
  let env_vars = @sys.get_env_vars()
  env_vars.get("ILLU_MOON_UPDATE") == Some("true")
}

///|
let is_inspect_update : Bool = is_update()

///|
typealias String as FilePath

///|
struct TestManager(Map[FilePath, TestFileManager]) derive(Show)

///|
struct TestFileManager {
  file : String
  count : Int
  mut current_test_block_index : Int
  test_blocks : Array[TestBlock]
} derive(Show)

///|
let test_manager : TestManager = TestManager({})

///|
enum TestState {
  Failure(
    actual~ : String,
    expected~ : String,
    loc~ : @quote.SourceLocation,
    argsloc~ : Array[@quote.SourceLocation?]
  )
  Success
} derive(Show)

///|
struct TestBlock(Array[TestState]) derive(Show)
