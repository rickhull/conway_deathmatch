defmodule Profile do
  @moduledoc "Profiling helpers for mix tasks"

  def do_work(num_ticks), do: args(num_ticks) |> ConwayDeathmatch.CLI.main

  defp args(num_ticks) do
    ["--ticks", "#{num_ticks}", "--sleep", "0", "--no-render"]
  end
end

defmodule Mix.Tasks.Eflame do
  @shortdoc "Generate perf/flame.svg [NUM_TICKS]"
  @svg "perf/flame.svg"
  use Mix.Task

  def run([]), do: run(["10"])
  def run([num_ticks]) do
    :eflame.apply(&Profile.do_work/1, [num_ticks])
    Mix.Shell.IO.info "Generating SVG flamegraph..."
    Mix.Shell.IO.cmd "mv stacks.out perf/"
    Mix.Shell.IO.cmd "deps/eflame/flamegraph.pl perf/stacks.out > #{@svg}"
    Mix.Shell.IO.info @svg
  end
end

defmodule Mix.Tasks.Eprof do
  @shortdoc "Profile using eprof [NUM_TICKS]"
  use Mix.Task
  import Elixir.ExProf.Macro

  def run([]), do: run(["10"])
  def run([num_ticks]) do
    # generates output, returns records
    profile do: Profile.do_work(num_ticks)

    # TODO: something with records
  end
end

defmodule Mix.Tasks.Fprof do
  @shortdoc "Profile using fprof [NUM_TICKS]"
  use Mix.Task

  def run([]), do: run(["10"])
  def run([num_ticks]) do
    :fprof.apply(&Profile.do_work/1, [num_ticks])
    :fprof.profile()
    :fprof.analyse([sort: :own,
                    totals: true,
                    callers: true,
                    details: true])
    Mix.Shell.IO.cmd "mv fprof.trace perf/"
  end
end
