defmodule Profile do
  @moduledoc "Profiling helpers for mix tasks"

  def do_work(mix_args) when is_list(mix_args) do
    cli_args(mix_args) |> ConwayDeathmatch.CLI.main
  end

  # 10 ticks by default
  defp cli_args(mix_args) do
    ["--ticks", "#{List.first(mix_args) || 10}",
     "--sleep", "0", "--no-render"]
  end
end

defmodule Mix.Tasks.Eflame do
  @shortdoc "Generate perf/flame.svg [NUM_TICKS]"
  @svg "perf/flame.svg"
  use Mix.Task

  def run(mix_args) do
    :eflame.apply(&Profile.do_work/1, [mix_args])
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

  def run(mix_args) do
    # generates output, returns records
    profile do: Profile.do_work(mix_args)

    # TODO: something with records
  end
end

defmodule Mix.Tasks.Fprof do
  @shortdoc "Profile using fprof [NUM_TICKS]"
  use Mix.Task

  def run(mix_args) do
    :fprof.apply(&Profile.do_work/1, [mix_args])
    :fprof.profile()
    :fprof.analyse([sort: :own,
                    totals: true,
                    callers: true,
                    details: true])
    Mix.Shell.IO.cmd "mv fprof.trace perf/"
  end
end
