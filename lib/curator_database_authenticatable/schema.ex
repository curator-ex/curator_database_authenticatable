defmodule CuratorDatabaseAuthenticatable.Schema do
  @moduledoc """
  """

  defmacro __using__(_opts \\ []) do
    quote do
      import unquote(__MODULE__)

      def password_changeset(model, params \\ %{}) do
        model
        |> cast(params, [:password])
        |> validate_required([:password])
        |> validate_confirmation(:password, message: "does not match password")
        |> validate_password
        |> hash_password
      end

      defp hash_password(%{changes: %{password: password}} = changeset) do
        put_change(changeset, :password_hash, CuratorDatabaseAuthenticatable.Config.crypto_mod.hashpwsalt(password))
      end
      defp hash_password(%{changes: %{}} = changeset), do: changeset

      # NOTE: The system should implement something for length
      # defp validate_password(%{changes: %{password: password}} = changeset)
      # end
      def validate_password(changeset), do: changeset

      defoverridable [
        {:validate_password, 1},
      ]
    end
  end

  defmacro curator_database_authenticatable_schema do
    quote do
      field :password, :string, virtual: true

      field :password_hash, :string
    end
  end
end
