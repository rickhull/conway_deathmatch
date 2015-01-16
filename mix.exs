defmodule ConwayDeathmatch.Mixfile do
  use Mix.Project

  def project do
    [app: :conway_deathmatch,
     version: "0.0.1",
     elixir: "~> 1.0",
     escript: [main_module: ConwayDeathmatch.CLI],
     consolidate_protocols: true,
     elixirc_paths: elixirc_paths(Mix.env),
     deps: [exprof, eflame],
    ]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  defp elixirc_paths(:perf), do: ["lib", "perf"]
  defp elixirc_paths(env) when env in [:dev, :test, :prod], do: ["lib"]

  defp exprof do
    {:exprof, "~> 0.1", only: :perf}
  end

  defp eflame do
     {:eflame,
      ~r//,    # project is not semantically versioned
      github:  "proger/eflame",
      compile: "rebar compile",
      only:    :perf,
     }
  end
end
