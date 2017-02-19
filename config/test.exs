use Mix.Config

config :logger, level: :warn

config :guardian, Guardian,
  issuer: "MyApp",
  ttl: { 1, :days },
  verify_issuer: true,
  secret_key: "woiuerojksldkjoierwoiejrlskjdf",
  serializer: CuratorDatabaseAuthenticatable.Test.GuardianSerializer

config :curator_database_authenticatable, CuratorDatabaseAuthenticatable,
  repo: CuratorDatabaseAuthenticatable.Test.Repo,
  user_schema: CuratorDatabaseAuthenticatable.Test.User

config :curator_database_authenticatable, ecto_repos: [CuratorDatabaseAuthenticatable.Test.Repo]

config :curator_database_authenticatable, CuratorDatabaseAuthenticatable.Test.Repo,
  adapter: Ecto.Adapters.Postgres,
  pool: Ecto.Adapters.SQL.Sandbox,
  url: "ecto://localhost/curator_database_authenticatable_test",
  size: 1,
  max_overflow: 0,
  priv: "test/support"
