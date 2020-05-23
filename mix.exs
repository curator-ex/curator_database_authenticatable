defmodule CuratorDatabaseAuthenticatable.Mixfile do
  use Mix.Project

  @version "0.2.0"
  @url "https://github.com/curator-ex/curator_database_authenticatable"
  @maintainers [
    "Eric Sullivan",
  ]

  def project do
    [
      app: :curator_database_authenticatable,
      version: @version,
      elixir: "~> 1.3",
      elixirc_paths: elixirc_paths(Mix.env),
      build_embedded: Mix.env == :prod,
      start_permanent: Mix.env == :prod,
      aliases: aliases,
      deps: deps,
      description: "Support password based sign-in by comparing the password to a hashed password",
      package: package(),
      source_url: @url,
      homepage_url: @url,
      docs: docs(),
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
      {:comeonin, "~> 3.0"},
      {:curator, "~> 0.3.1"},
      {:postgrex, ">= 0.0.0", optional: true},

      {:credo, "~> 0.5", only: [:dev, :test]},
      {:dialyxir, "~> 0.4", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.10", only: :dev},
    ]
  end

  def docs do
    [
      extras: ["README.md", "CHANGELOG.md"],
      source_ref: "v#{@version}"
    ]
  end

  defp package do
    [
      name: :curator_database_authenticatable,
      maintainers: @maintainers,
      licenses: ["MIT"],
      links: %{github: @url},
      files: ["lib", "priv", "mix.exs", "README*", "LICENSE*", "CHANGELOG*"],
    ]
  end

  defp aliases do
    ["test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
