import clip
import clip/arg
import clip/flag
import clip/help
import clip/opt

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
