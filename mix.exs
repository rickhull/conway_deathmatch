defmodule ConwayDeathmatch.Mixfile do
  use Mix.Project

  def project do
    common = [app: :conway_deathmatch,
              version: "0.0.1",
              elixir: "~> 1.0",
              escript: [main_module: ConwayDeathmatch.CLI],
              deps: deps]
    Keyword.merge(common, project(Mix.env))
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  defp project(:prod), do: [consolidate_protocols: true]
  defp project(:perf), do: [consolidate_protocols: true,
                            elixirc_paths: ["lib", "perf"]]
  defp project(env) when env in [:dev, :test], do: []

  defp deps, do: [exprof, eflame]

  defp exprof do
    {:exprof, "~> 0.1", only: :perf}
  end

  defp eflame do
     {:eflame, ~r//,    # project is not semantically versioned
      only:    :perf,
      github:  "proger/eflame", compile: "rebar compile",
     }
  end
end
