defmodule ConwayDeathmatch.Mixfile do
  use Mix.Project

  def project do
    [app: :conway_deathmatch,
     version: "0.0.1",
     elixir: "~> 1.0",
     escript: [main_module: ConwayDeathmatch.CLI],
     consolidate_protocols: true,
     elixirc_paths: elixirc_paths(Mix.env),
     deps: deps,
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # only compile perf stuff for perf environment
  defp elixirc_paths(:perf), do: ["lib", "perf"]
  defp elixirc_paths(env) when env in [:dev, :test, :prod], do: ["lib"]

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
