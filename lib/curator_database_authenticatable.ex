defmodule CuratorDatabaseAuthenticatable do
  @moduledoc """
  CuratorDatabaseAuthenticatable: A curator module to handle user "database authentication".
  """

  if !(
       (Application.get_env(:curator_database_authenticatable, CuratorDatabaseAuthenticatable) && Keyword.get(Application.get_env(:curator_database_authenticatable, CuratorDatabaseAuthenticatable), :repo)) ||
       (Application.get_env(:curator, Curator) && Keyword.get(Application.get_env(:curator, Curator), :repo))
      ), do: raise "CuratorDatabaseAuthenticatable requires a repo"

  if !(
       (Application.get_env(:curator_database_authenticatable, CuratorDatabaseAuthenticatable) && Keyword.get(Application.get_env(:curator_database_authenticatable, CuratorDatabaseAuthenticatable), :user_schema)) ||
       (Application.get_env(:curator, Curator) && Keyword.get(Application.get_env(:curator, Curator), :user_schema))
      ), do: raise "CuratorDatabaseAuthenticatable requires a user_schema"

  alias CuratorDatabaseAuthenticatable.Config

  def authenticate(%{"email" => email, "password" => password}) do
    user = Config.repo.get_by(Config.user_schema, email: email)

    case CuratorDatabaseAuthenticatable.verify_password(user, password) do
      true -> {:ok, user}
      false -> {:error, user, "Authentication Failure"}
    end
  end

  # def authenticate(params)
  #   login_field = :email
  #   login = params[to_string(login_field)]
  #   user = Repo.get_by(User, [{login_field, login}])
  #   password = params["password"]

  #   CuratorDatabaseAuthenticatable.verify_password(user, password)
  # end

  def verify_password(nil, _), do: Config.crypto_mod.dummy_checkpw
  def verify_password(user, password) do
    Config.crypto_mod.checkpw(password, user.password_hash)
  end
end
