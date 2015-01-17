defmodule Profile do
  @moduledoc "Profiling helpers for mix tasks"

  def do_work(mix_args) when is_list(mix_args) do
    cli_args(mix_args) |> ConwayDeathmatch.CLI.main
  end
  def do_work(num_ticks) when is_integer(num_ticks) or is_binary(num_ticks) do
    do_work(["#{num_ticks}"])
  end

  # 10 ticks by default
  defp cli_args(mix_args) do
    ["--ticks", "#{List.first(mix_args) || 10}",
     "--sleep", "0", "--no-render"]
  end

  def elapsed_ms(old_now) do
    :timer.now_diff(:erlang.now, old_now) |> trunc |> div(1000)
  end

  def loadavg do
    {output, 0} = System.cmd("cat", ["/proc/loadavg"])
    "/proc/loadavg:\t#{output}" |> String.rstrip
  end

  def run(work_fun) when is_function(work_fun) do
    IO.puts Profile.loadavg
    start = :erlang.now
    work_fun.()
    elapsed = elapsed_ms(start)
    IO.puts Profile.loadavg
    IO.puts "elapsed:\t#{elapsed} ms"
  end
end

defmodule Mix.Tasks.DoWork do
  @shortdoc "Run standard simulation without profiling [NUM_TICKS]"
  use Mix.Task

  def run(mix_args) do
    Profile.run(fn ->
                  Profile.do_work(mix_args)
                end)
  end
end

defmodule Mix.Tasks.Eflame do
  @shortdoc "Generate perf/flame.svg [NUM_TICKS]"
  @svg "perf/flame.svg"
  use Mix.Task

  def run(mix_args) do
    Profile.run(fn ->
                  :eflame.apply(&Profile.do_work/1, [mix_args])
                  Mix.Shell.IO.info "Generating SVG flamegraph..."
                  Mix.Shell.IO.cmd "mv stacks.out perf/"
                  Mix.Shell.IO.cmd "deps/eflame/flamegraph.pl perf/stacks.out > #{@svg}"
                  Mix.Shell.IO.info @svg
                end)
  end
end

defmodule Mix.Tasks.Eprof do
  @shortdoc "Profile using eprof [NUM_TICKS]"
  use Mix.Task
  import ExProf.Macro

  def run(mix_args) do
    Profile.run(fn ->
                  profile do: Profile.do_work(mix_args)
                end)
  end
end

defmodule Mix.Tasks.Fprof do
  @shortdoc "Profile using fprof [NUM_TICKS]"
  use Mix.Task

  def run(mix_args) do
    Profile.run(fn ->
                  :fprof.apply(&Profile.do_work/1, [mix_args])
                  :fprof.profile()
                  :fprof.analyse([sort: :own,
                                  totals: true,
                                  callers: true,
                                  details: true])
                  Mix.Shell.IO.cmd "mv fprof.trace perf/"
                end)
  end
end
