import gleam/io
import gleam/list
import gleam/string
import glexec as exec
import utils

pub fn checks(system_address_pairs: List(#(String, String))) {
  io.println("📋 Preflight Checks:")
  use pair <- list.each(system_address_pairs)
  let #(system, address) = pair

  io.println("🖥️ " <> system <> ":")
  ping(pair)
  rootable(pair)
}

fn ping(system_address_pair: #(String, String)) {
  let #(_system, address) = system_address_pair

  let assert Ok(ping) = exec.find_executable("ping")
  let command =
    exec.new()
    |> exec.with_stdin(exec.StdinPipe)
    |> exec.with_stdout(exec.StdoutCapture)
    |> exec.with_stderr(exec.StderrStdout)
    |> exec.with_monitor(True)
    |> exec.with_pty(True)
    |> exec.run_sync(exec.Execve([ping, "-c 1", address]))

  case command {
    Error(_) -> io.println_error("  ❌ Host is unreachable!")
    Ok(_) -> io.println("  ✅ Host is reachable!")
  }
}

fn rootable(system_address_pair: #(String, String)) {
  let command = utils.run_on_system(system_address_pair, "whoami")
  case command {
    Error(_) -> io.println_error("  ❌ Cannot become root!")
    Ok(_) -> io.println("  ✅ Can become root!")
  }
}