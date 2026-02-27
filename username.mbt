///|
async fn prompt_username(remaining_retry : Int) -> String? {
  if remaining_retry <= 0 {
    None
  } else {
    println("(first) please input MoonBit username:")
    match read_line_from_stdin() {
      Some(line) => {
        let username = line.trim().to_string()
        if username.is_empty() {
          println("username cannot be empty")
          prompt_username(remaining_retry - 1)
        } else {
          Some(username)
        }
      }
      None => None
    }
  }
}

///|
async fn ensure_username() -> Result[String, String] {
  guard home_dir() is Some(home) else {
    return Err("cannot locate home directory from HOME/USERPROFILE")
  }
  let preferred_dir = preferred_dir_path(home)
  let preferred_file = preferred_file_path(home)
  match load_preferred_username(preferred_file) {
    Some(username) => Ok(username)
    None => {
      match ensure_dir(preferred_dir) {
        Ok(_) => ()
        Err(err) => return Err(err)
      }
      guard prompt_username(5) is Some(username) else {
        return Err("failed to read username from stdin")
      }
      let content = "username \{username}"
      Result::map(write_string_file(preferred_file, content), _ => username)
    }
  }
}
