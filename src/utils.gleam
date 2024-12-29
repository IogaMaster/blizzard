import glexec as exec

pub fn run_on_system(system_address_pair: #(String, String), command: String) {
  let #(system, address) = system_address_pair
  let assert Ok(ssh) = exec.find_executable("ssh")
  exec.new()
  |> exec.with_stdin(exec.StdinPipe)
  |> exec.with_stdout(exec.StdoutCapture)
  |> exec.with_stderr(exec.StderrStdout)
  |> exec.with_monitor(True)
  |> exec.with_pty(True)
  |> exec.run_sync(exec.Execve([ssh, "root@" <> address, command]))
}
