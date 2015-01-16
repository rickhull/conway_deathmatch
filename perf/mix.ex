defmodule Mix.Tasks.Profile do
  @moduledoc "Tasks for profiling"

  def do_work(num_ticks), do: args(num_ticks) |> ConwayDeathmatch.CLI.main

  defp args(num_ticks) do
    ["--ticks", "#{num_ticks}", "--sleep", "0", "--no-render"]
  end

  defmodule Flame do
    @shortdoc "Generate perf/flame.svg [NUM_TICKS]"
    use Mix.Task
    def run([]), do: run(["100"])
    def run([num_ticks]) do
      :eflame.apply(&Mix.Tasks.Profile.do_work/1, [num_ticks])
      Mix.Shell.IO.cmd "mv stacks.out perf/"
      Mix.Shell.IO.cmd "deps/eflame/flamegraph.pl perf/stacks.out > perf/flame.svg"
    end
  end

  defmodule Ex do
    @shortdoc "ExProf profiler [NUM_TICKS]"
    use Mix.Task
    import Elixir.ExProf.Macro

    def run([]), do: run(["100"])
    def run([num_ticks]) do
      # generates output, returns records
      profile do: Mix.Tasks.Profile.do_work(num_ticks)

      # TODO: something with records
    end
  end
end
