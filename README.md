# CuratorDatabaseAuthenticatable

Support password based sign-in by comparing the password to a hashed password. It also provides a generator for creating a sign-in page.

## Installation

  1. Add `curator_database_authenticatable` to your list of dependencies in `mix.exs`:

    ```elixir
    def deps do
      [{:curator_database_authenticatable, "~> 0.1.0"}]
    end
    ```

  2. Run the install command

    ```elixir
    mix curator_database_authenticatable.install
    ```

  3. Update `web/models/user.ex`

    ```elixir
    defmodule Auth.User do
      use Auth.Web, :model

      use CuratorDatabaseAuthenticatable.Schema

      schema "users" do
        ...
        curator_database_authenticatable_schema
        ...
      end
    end
    ```

    If you have specific password requirements, CuratorDatabaseAuthenticatable.Schema provides an overridable function, validate_password, which can be used as below:

    ```elixir
    def validate_password(changeset) do
      changeset
      |> validate_length(:password, min: 8)
    end
    ```

  4. Update `web/router.ex`

    ```elixir
    scope "/", Auth do
      pipe_through [:browser]

      get "/sessions", SessionController, :new
      post "/sessions", SessionController, :create
      delete "/sessions", SessionController, :delete

      ...
    end
    ```

  5. Update `web/controllers/error_helper.ex`

    ```elixir
    def unauthenticated(conn, %{reason: {:error, reason}}) do
      respond(conn, response_type(conn), 401, reason, session_path(conn, :new))
    end

    def no_resource(conn, %{reason: reason}) do
      respond(conn, response_type(conn), 403, reason, session_path(conn, :new))
    end
    ```

  6. Update `test/supprt/session_helper.ex`

    ```elixir
    def create_user(user, attrs) do
      user
      |> PhoenixCurator.User.changeset(attrs)
      |> PhoenixCurator.User.password_changeset(%{password: "TEST_PASSWORD", password_confirmation: "TEST_PASSWORD"})
      ...
      |> PhoenixCurator.Repo.insert!
    end
    ```

  7. Update `test/controllers/page_controller_test.exs`

    ```elixir
    test "visiting a secret page w/o a user", %{conn: conn} do
      conn = get conn, "/secret"

      assert Phoenix.Controller.get_flash(conn, :danger) == "Please Log In"
      assert Phoenix.ConnTest.redirected_to(conn) == session_path(conn, :new)
    end
    ```
