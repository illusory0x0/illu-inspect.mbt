///|
fn TestFileManager::update_source_file(self : TestFileManager) -> Unit {
  let test_states : Array[Array[TestState]] = coerce(self.test_blocks)
  let test_states = test_states.flatten()
  let temp = []
  for state in test_states {
    guard state is Failure(actual~, expected~, loc~, argsloc~) else { continue }
    temp.push((actual, loc, argsloc))
  }
  if temp.is_empty() {
    return
  } else {
    let file_path = temp[0].1.path
    let file = self.file
    let builder = StringBuilder::new(size_hint=file.length())
    let mut row = 0
    let mut col = 0
    let mut idx = 0 // for temp
    temp.sort_by((a, b) => {
      // Fix sorting to use the correct location based on the logic
      let a_target_loc = if a.2.length() > 2 && a.2[2] is Some(_) {
        a.2[2]
      } else {
        a.2[1]
      }
      let b_target_loc = if b.2.length() > 2 && b.2[2] is Some(_) {
        b.2[2]
      } else {
        b.2[1]
      }
      match (a_target_loc, b_target_loc) {
        (Some(a_loc), Some(b_loc)) =>
          if a_loc.start.row != b_loc.start.row {
            a_loc.start.row.compare(b_loc.start.row)
          } else {
            a_loc.start.column.compare(b_loc.start.column)
          }
        (Some(_), None) => -1
        (None, Some(_)) => 1
        (None, None) => 0
      }
    })
    let buffer = StringBuilder::new(size_hint=file.length() * 2)

    // Iterate through the file character by character
    let mut i = 0
    while i < file.length() {
      let char = file[i]

      // Check if we're at the start of a temp loc range
      if idx < temp.length() {
        let (actual, loc, argsloc) = temp[idx]

        // Determine the target location based on the new logic:
        // If argsloc[2] == None, use argsloc[1]'s end position for insertion
        // Otherwise, use argsloc[2]'s range for replacement
        let (target_loc, is_insertion) = if argsloc.length() > 2 &&
          argsloc[2] is Some(arg2_loc) {
          // argsloc[2] exists, use it for replacement
          (Some(arg2_loc), false)
        } else if argsloc[1] is Some(arg1_loc) {
          // argsloc[2] is None, use argsloc[1]'s end position for insertion
          (Some(arg1_loc), true)
        } else {
          // Skip if no valid location
          (None, false)
        }
        if target_loc is None {
          continue // Skip if no valid location
        }
        let target_location = target_loc.unwrap()
        let (target_row, target_col, end_row, end_col) = if is_insertion {
          // For insertion, use the end position of argsloc[1]
          let target_row = target_location.end.row - 1
          let target_col = target_location.end.column - 1
          (target_row, target_col, target_row, target_col)
        } else {
          // For replacement, use the full range of argsloc[2]
          let target_row = target_location.start.row - 1
          let target_col = target_location.start.column - 1
          let end_row = target_location.end.row - 1
          let end_col = target_location.end.column - 1
          (target_row, target_col, end_row, end_col)
        }

        // If we're at the target position
        if row == target_row && col == target_col {
          if is_insertion {
            // For insertion, write the content at the end position without replacing anything
            buffer.write_string(", expected=\{actual.escape()}")
            idx = idx + 1 // Move to next temp location
          } else {
            // For replacement, write the new actual value and skip the old content
            buffer.write_string("expected=\{actual.escape()}")

            // Skip through the target location range until we reach the end
            while i < file.length() {
              let skip_char = file[i]

              // Update position based on character
              if skip_char == '\n' {
                row = row + 1
                col = 0
              } else {
                col = col + 1
              }
              i = i + 1

              // Check if we've reached the end of this target location
              if row == end_row && col >= end_col {
                idx = idx + 1 // Move to next temp location
                break
              }
            }
          }
          continue // Continue to next iteration
        }
      }

      // Write the current character (we're not in a target range)
      buffer.write_char(char.unsafe_to_char())

      // Update current position
      if char == '\n' {
        row = row + 1
        col = 0
      } else {
        col = col + 1
      }
      i = i + 1
    }

    // Write the updated content back to the file
    try! @fs.write_string_to_file(file_path.to_string(), buffer.to_string())
  }
  return
}
