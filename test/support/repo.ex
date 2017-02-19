defmodule CuratorDatabaseAuthenticatable.Test.Repo do
  use Ecto.Repo, otp_app: :curator_database_authenticatable

  def log(_cmd), do: nil
end
