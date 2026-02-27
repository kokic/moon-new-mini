///|
fn preferred_dir_path(home : String) -> String {
  @path.Path::join(home, ".moon-mini").to_string()
}

///|
fn preferred_file_path(home : String) -> String {
  @path.Path::join(preferred_dir_path(home), "preferred.txt").to_string()
}

///|
fn parse_preferred_username(content : String) -> String? {
  let trimmed = content.trim()
  let prefix = "username "
  if trimmed.has_prefix(prefix) {
    let username = trimmed.view(start_offset=prefix.length()).trim().to_string()
    if username.is_empty() {
      None
    } else {
      Some(username)
    }
  } else {
    None
  }
}

///|
fn load_preferred_username(preferred_file : String) -> String? {
  if !@fs.path_exists(preferred_file) {
    None
  } else {
    let read_result = try? @fs.read_file_to_string(preferred_file)
    match read_result {
      Ok(content) => parse_preferred_username(content)
      Err(_) => None
    }
  }
}

///|
fn ensure_dir(path : String) -> Result[Unit, String] {
  if @fs.path_exists(path) {
    let is_dir_result = try? @fs.is_dir(path)
    match is_dir_result {
      Ok(true) => Ok(())
      Ok(false) => Err("path exists but is not a directory: \{path}")
      Err(err) => Err("failed to inspect directory \{path}: \{err}")
    }
  } else {
    Result::map_err(try? @fs.create_dir(path), err => {
      "failed to create directory \{path}: \{err}"
    })
  }
}

///|
fn module_name_from_project_dir(project_dir : String) -> String {
  let module_name = @path.Path::basename(project_dir).to_string()
  if module_name.is_empty() {
    "moon-new-mini"
  } else {
    module_name
  }
}
