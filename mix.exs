defmodule ConwayDeathmatch.Mixfile do
  use Mix.Project

  def project do
    [app: :conway_deathmatch,
     version: "0.0.1",
     elixir: "~> 1.0",
     escript: [main_module: ConwayDeathmatch.CLI],
     consolidate_protocols: true,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type `mix help compile.app` for more information
  def application do
    [applications: [:logger]]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type `mix help deps` for more examples and options
  defp deps do
    [{:exprof, "~> 0.1"},
     {:eflame,
      ~r//,    # project is not semantically versioned
      github:  "proger/eflame",
      compile: "rebar compile"},
    ]
  end
end
