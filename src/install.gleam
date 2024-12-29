import checks
import clip
import clip/arg
import clip/flag
import clip/help
import clip/opt
import gleam/io
import gleam/list
import gleam/set
import gleam/string

pub type InstallArgs {
  InstallArgs(systems_and_addresses: List(String))
}

pub fn install_command() {
  clip.command({
    use systems_and_addresses <- clip.parameter
    InstallArgs(systems_and_addresses)
  })
  |> clip.arg_many(
    arg.new("systems_and_addresses") |> arg.help("Systems and Addresses"),
  )
  |> clip.help(help.simple(
    "blizzard install",
    "Install in place using a list of systems
  Pass args like so:
    `blizzard install hostname1 ip1 hostname2 ip2`
    ",
  ))
}

pub fn install(args: InstallArgs) {
  let system_address_pairs =
    // This mess turns a list of alternating values into a list of tuples. [#(hostname, ip), ...]
    args.systems_and_addresses
    |> list.window_by_2()
    |> list.index_map(fn(pair, index) {
      case index % 2 {
        0 -> pair
        _ -> #("", "")
      }
    })
    |> set.from_list()
    |> set.drop([#("", "")])
    |> set.to_list()
    |> list.reverse()

  checks.checks(system_address_pairs)
}
