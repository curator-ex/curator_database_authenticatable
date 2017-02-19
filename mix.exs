defmodule CuratorDatabaseAuthenticatable.Mixfile do
  use Mix.Project

  def project do
    [app: :curator_database_authenticatable,
     version: "0.1.0",
     elixir: "~> 1.3",
     elixirc_paths: elixirc_paths(Mix.env),
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps,
     dialyzer: [plt_add_deps: :project],
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_),     do: ["lib"]

  def application do
    [applications: _applications(Mix.env)]
  end

  defp _applications(:test), do: [:postgrex, :ecto, :comeonin, :logger]
  defp _applications(_), do: [:comeonin, :logger]

  defp deps do
    [
      {:curator, github: "curator-ex/curator"},
      {:comeonin, "~> 3.0"},
      {:ecto, "~> 2.0"},
      {:postgrex, ">= 0.11.1", optional: true},

      {:credo, "~> 0.5", only: [:dev, :test]},
      {:dialyxir, "~> 0.4", only: [:dev, :test], runtime: false},
    ]
  end

  defp aliases do
    ["test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
