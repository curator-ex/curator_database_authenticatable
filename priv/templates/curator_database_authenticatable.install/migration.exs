defmodule <%= base %>.Repo.Migrations.Create<%= scoped %>CuratorDatabaseAuthenticatable do
  use Ecto.Migration

  def change do
    alter table(:<%= plural %>) do
      add :password_hash, :string
    end
  end
end
