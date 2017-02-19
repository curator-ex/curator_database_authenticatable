defmodule CuratorDatabaseAuthenticatable.ConfigTest do
  use ExUnit.Case, async: true
  doctest CuratorDatabaseAuthenticatable.Config

  test "the repo" do
    assert CuratorDatabaseAuthenticatable.Config.repo == CuratorDatabaseAuthenticatable.Test.Repo
  end

  test "the user_schema" do
    assert CuratorDatabaseAuthenticatable.Config.user_schema == CuratorDatabaseAuthenticatable.Test.User
  end

  test "the default crypto_mod" do
    assert CuratorDatabaseAuthenticatable.Config.crypto_mod == Comeonin.Bcrypt
  end
end
