///|
fn create_project(
  config : CliConfig,
  username : String,
) -> Result[String, String] {
  let project_dir = @path.Path::resolve(config.path).to_string()
  match ensure_dir_recursive(project_dir) {
    Ok(_) => ()
    Err(err) => return Err(err)
  }
  let module_name = module_name_from_project_dir(project_dir)
  let license = match config.license {
    Some(value) => value
    None => "AGPL-3.0"
  }
  let repository_hosting = match config.repository_hosting {
    Some(value) => value
    None => "github.com"
  }
  let preferred_target = match config.preferred_target {
    Some(value) => value
    None => "native"
  }
  let moon_mod_content = file_content_moon_mod_json(
    username~,
    module_name~,
    license,
    repository_hosting,
    preferred_target,
  )
  let moon_mod_path = @path.Path::join(project_dir, "moon.mod.json").to_string()
  match write_string_file(moon_mod_path, moon_mod_content) {
    Ok(_) => ()
    Err(err) => return Err(err)
  }

  let moon_pkg_content = file_content_moon_pkg()
  let moon_pkg_path = @path.Path::join(project_dir, "moon.pkg").to_string()
  match write_string_file(moon_pkg_path, moon_pkg_content) {
    Ok(_) => ()
    Err(err) => return Err(err)
  }

  let gitignore_content = file_content_gitignore()
  let gitignore_path = @path.Path::join(project_dir, ".gitignore").to_string()
  match write_string_file(gitignore_path, gitignore_content) {
    Ok(_) => ()
    Err(err) => return Err(err)
  }
  Ok(project_dir)
}
