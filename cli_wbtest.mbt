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
test "parse_preferred_config key-values" {
  let preferred = parse_preferred_config(
    (
      #|username kokic
      #|license MIT
      #|host gitlab.com
      #|target js
    ),
  )
  assert_eq(preferred.username, Some("kokic"))
  assert_eq(preferred.license, Some("MIT"))
  assert_eq(preferred.repository_hosting, Some("gitlab.com"))
  assert_eq(preferred.preferred_target, Some("js"))
}

///|
test "parse_preferred_config username compatibility" {
  assert_eq(parse_preferred_config("username kokic").username, Some("kokic"))
  assert_eq(
    parse_preferred_config("username   mooner  ").username,
    Some("mooner"),
  )
  assert_eq(parse_preferred_config("user kokic").username, None)
}

///|
test "preferred_config_to_content" {
  let preferred : PreferredConfig = {
    username: Some("kokic"),
    license: Some("MIT"),
    repository_hosting: Some("gitlab.com"),
    preferred_target: Some("js"),
  }
  assert_eq(
    preferred_config_to_content(preferred),
    (
      #|username kokic
      #|license MIT
      #|host gitlab.com
      #|target js
    ),
  )
}

///|
test "is_preferences_command" {
  assert_eq(is_preferences_command("prefs"), true)
  assert_eq(is_preferences_command("config"), true)
  assert_eq(is_preferences_command("demo"), false)
}

///|
test "is_preferences_show_option" {
  assert_eq(is_preferences_show_option("--show"), true)
  assert_eq(is_preferences_show_option("show"), false)
}

///|
test "module_name from resolved path basename" {
  let project_dir = @path.Path::resolve("example_project").to_string()
  assert_eq(module_name_from_project_dir(project_dir), "example_project")
}
