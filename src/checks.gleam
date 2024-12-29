import gleam/io
import gleam/list
import gleam/string
import glexec as exec

pub fn checks(system_address_pairs: List(#(String, String))) {
  io.println("📋 Preflight Checks:")
  use pair <- list.each(system_address_pairs)
  let #(system, address) = pair

  io.println("🖥️ " <> system <> ":")
  let reachable = ping(pair)

  case reachable {
    False -> io.println_error("  ❌ Host is unreachable!")
    True -> io.println("  ✅ Host is reachable!")
  }
}

fn ping(system_address_pair: #(String, String)) -> Bool {
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
    Error(_) -> False
    Ok(_) -> True
  }
}
