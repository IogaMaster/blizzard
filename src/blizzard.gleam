import argv
import clip
import clip/help
import gleam/io
import gleam/string

import install

fn command() {
  clip.subcommands([#("install", install.install_command())])
}

pub fn main() {
  let result =
    command()
    |> clip.help(help.simple(
      "blizzard",
      "Install many NixOS systems in place 🌨️",
    ))
    |> clip.run(argv.load().arguments)

  case result {
    Error(e) -> io.println_error(e)
    Ok(args) -> {
      case args {
        install.InstallArgs(_systems_and_addresses) -> {
          install.install(args)
        }
      }
    }
  }
}
