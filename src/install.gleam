import clip
import clip/flag
import clip/help

pub fn install_command() {
  clip.command({
    use systems <- clip.parameter
    use addresses <- clip.parameter
    #(systems, addresses)
  })
  |> clip.flag(flag.new("systems") |> flag.help("Systems"))
  |> clip.help(help.simple(
    "blizzard install",
    "Install list of systems in place",
  ))
}
