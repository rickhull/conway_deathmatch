defmodule ConwayDeathmatch.Profile do
  @module_doc "lorem ipsum"

  def eflame do
    :eflame.apply(&invoke_cli/0, [])
  end

  def exprof do
    import ExProf.Macro
    profile do: invoke_cli
  end

  def invoke_cli(num_ticks \\ 100) do
    ConwayDeathmatch.CLI.main(["--ticks", "#{num_ticks}",
                               "--sleep", "0",
                               "--no-render"])
  end
end
