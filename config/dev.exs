use Mix.Config

config :guardian, Guardian,
  issuer: "MyApp",
  ttl: { 1, :days },
  verify_issuer: true,
  secret_key: "woiuerojksldkjoierwoiejrlskjdf",
  serializer: CuratorDatabaseAuthenticatable.Test.GuardianSerializer

config :curator_database_authenticatable, CuratorDatabaseAuthenticatable,
  repo: CuratorDatabaseAuthenticatable.Test.Repo,
  user_schema: CuratorDatabaseAuthenticatable.Test.User
