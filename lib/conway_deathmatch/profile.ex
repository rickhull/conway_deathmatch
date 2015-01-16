defmodule ConwayDeathmatch.Profile do
  @module_doc "lorem ipsum"

  def eflame(num_ticks \\ 100) do
    :eflame.apply(&invoke_cli/1, [num_ticks])
  end

  def exprof(num_ticks \\ 100) do
    import ExProf.Macro
    profile do: invoke_cli(num_ticks)
  end

  def invoke_cli(num_ticks) do
    ConwayDeathmatch.CLI.main(["--ticks", "#{num_ticks}",
                               "--sleep", "0",
                               "--no-render"])
  end
end
