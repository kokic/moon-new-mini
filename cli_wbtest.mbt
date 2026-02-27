///|
test "parse_cli_args defaults" {
  guard parse_cli_args(["demo"]) is Ok(config) else {
    fail("expected parse success")
  }
  assert_eq(config.path, "demo")
  assert_eq(config.license, None)
  assert_eq(config.repository_hosting, None)
  assert_eq(config.preferred_target, None)
}

///|
test "parse_cli_args optional flags" {
  guard parse_cli_args(["demo", "-l", "MIT", "--host", "gitlab.com", "-t", "js"])
    is Ok(config) else {
    fail("expected parse success")
  }
  assert_eq(config.path, "demo")
  assert_eq(config.license, Some("MIT"))
  assert_eq(config.repository_hosting, Some("gitlab.com"))
  assert_eq(config.preferred_target, Some("js"))
}

///|
test "parse_cli_args invalid option" {
  guard parse_cli_args(["demo", "--oops"]) is Err(_) else {
    fail("expected parse failure")
  }
}

///|
test "parse_preferred_username" {
  guard parse_preferred_username("username kokic") is Some("kokic") else {
    fail("expected username kokic")
  }
  guard parse_preferred_username("username   mooner  ") is Some("mooner") else {
    fail("expected username mooner")
  }
  guard parse_preferred_username("user kokic") is None else {
    fail("expected parse failure")
  }
}

///|
test "module_name from resolved path basename" {
  let project_dir = @path.Path::resolve("example_project").to_string()
  assert_eq(module_name_from_project_dir(project_dir), "example_project")
}
