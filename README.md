# Momoka

```
 __  __                       _         
|  \/  | ___  _ __ ___   ___ | | ____ _ 
| |\/| |/ _ \| '_ ` _ \ / _ \| |/ / _` |
| |  | | (_) | | | | | | (_) |   < (_| |
|_|  |_|\___/|_| |_| |_|\___/|_|\_\__,_|
```

Create a minimal **Mo**onBit **mo**dule **か**? 

## Example

```sh
momoka your-great-project
```

## Help

```sh
Create a minimal MoonBit module

Usage: momoka <PATH> [OPTIONS]
       momoka prefs [--show]
       momoka config [--show]

Commands:
  prefs, config            Configure default license/host/target, or print with --show

Arguments:
  <PATH>  Project directory path

Options:
  -l, --license <LICENSE>  License for moon.mod.json [default: prefs or AGPL-3.0]
      --host <HOST>        Repository hosting domain [default: prefs or github.com]
  -t, --target <TARGET>    Preferred target [default: prefs or native]
      --show               Print current preferences for prefs/config command
  -h, --help               Print help
```
