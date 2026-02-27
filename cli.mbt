///|
fn usage_text() -> String {
  (
    #|Create a minimal MoonBit module
    #|
    #|Usage: momoka <PATH> [OPTIONS]
    #|
    #|Arguments:
    #|  <PATH>  Project directory path
    #|
    #|Options:
    #|  -l, --license <LICENSE>  License for moon.mod.json [default: AGPL-3.0]
    #|      --host <HOST>        Repository hosting domain [default: github.com]
    #|  -t, --target <TARGET>    Preferred target [default: native]
    #|  -h, --help               Print help
  )
}

///|
priv struct CliConfig {
  path : String
  license : String?
  repository_hosting : String?
  preferred_target : String?
}

///|
fn parse_cli_args(args : ArrayView[String]) -> Result[CliConfig, String] {
  if args.length() == 0 {
    return Err(usage_text())
  }
  let mut path : String? = None
  let mut license : String? = None
  let mut repository_hosting : String? = None
  let mut preferred_target : String? = None
  let mut i = 0
  while i < args.length() {
    let arg = args[i]
    if arg == "--help" || arg == "-h" {
      return Err(usage_text())
    } else if arg == "--license" || arg == "-l" {
      guard i + 1 < args.length() else {
        return Err("missing value for \{arg}\n\{usage_text()}")
      }
      license = Some(args[i + 1])
      i = i + 2
    } else if arg == "--host" {
      guard i + 1 < args.length() else {
        return Err("missing value for \{arg}\n\{usage_text()}")
      }
      repository_hosting = Some(args[i + 1])
      i = i + 2
    } else if arg == "--target" || arg == "-t" {
      guard i + 1 < args.length() else {
        return Err("missing value for \{arg}\n\{usage_text()}")
      }
      preferred_target = Some(args[i + 1])
      i = i + 2
    } else if arg.has_prefix("-") {
      return Err("unknown option: \{arg}\n\{usage_text()}")
    } else if path is None {
      path = Some(arg)
      i = i + 1
    } else {
      return Err("unexpected positional argument: \{arg}\n\{usage_text()}")
    }
  }
  match path {
    Some(path) => Ok({ path, license, repository_hosting, preferred_target })
    None => Err(usage_text())
  }
}

///|
fn home_dir() -> String? {
  let home = @sys.get_env_var("HOME")
  if home is Some(path) && !path.is_empty() {
    Some(path)
  } else {
    let userprofile = @sys.get_env_var("USERPROFILE")
    if userprofile is Some(path) && !path.is_empty() {
      Some(path)
    } else {
      None
    }
  }
}

///|
async fn run(args : ArrayView[String]) -> Result[String, String] {
  match parse_cli_args(args) {
    Ok(config) =>
      match ensure_username() {
        Ok(username) => create_project(config, username)
        Err(err) => Err(err)
      }
    Err(err) => Err(err)
  }
}

///|
pub async fn export_main() -> Unit {
  match @env.args() {
    [_, .. args] =>
      match run(args) {
        Ok(project_dir) =>
          println(
            "created moon.mod.json, moon.pkg and .gitignore in \{project_dir}",
          )
        Err(err) => {
          println(err)
          @sys.exit(1)
        }
      }
    [] => {
      println(usage_text())
      @sys.exit(1)
    }
  }
}
