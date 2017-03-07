defmodule Mix.Tasks.CuratorDatabaseAuthenticatable.Install do
  use Mix.Task

  @shortdoc "Generates controller, model and views for an HTML based session"

  @moduledoc """
  Generates a Curator Based Session.

      mix curator_database_authenticatable.install

  Optionally, you can provide a name for the users module

      mix curator_database_authenticatable.install User users

  The first argument is the module name followed by
  its plural name (used for schema).

  The generated files will contain:

    * a view in web/views
    * a controller in web/controllers
    * new template in web/templates
    * test file for the generated controller

  If you already have a migration, the generated migration can be skipped
  with `--no-migration`.
  """
  def run(args) do
    switches = [migration: :boolean]

    {opts, parsed, _} = OptionParser.parse(args, switches: switches)
    [singular, plural | attrs] = validate_args!(parsed)

    default_opts = Application.get_env(:phoenix, :generators, [])
    opts = Keyword.merge(default_opts, opts)

    attrs   = Mix.Phoenix.attrs(attrs)
    binding = Mix.Phoenix.inflect(singular)
    path    = binding[:path]
    route   = String.split(path, "/") |> Enum.drop(-1) |> Kernel.++([plural]) |> Enum.join("/")
    binding = binding ++ [plural: plural, route: route, attrs: attrs,
                          params: Mix.Phoenix.params(attrs),
                          template_singular: String.replace(binding[:singular], "_", " "),
                          template_plural: String.replace(plural, "_", " ")]

    Mix.Phoenix.check_module_name_availability!("SessionController")
    Mix.Phoenix.check_module_name_availability!("SessionView")

    Mix.Phoenix.copy_from paths(), "priv/templates/curator_database_authenticatable.install", "", binding, [
      {:eex, "controller.ex",       "web/controllers/session_controller.ex"},
      {:eex, "new.html.eex",        "web/templates/session/new.html.eex"},
      {:eex, "view.ex",             "web/views/session_view.ex"},
      {:eex, "controller_test.exs", "test/controllers/session_controller_test.exs"},
    ] ++ migration(opts[:migration], path)

    instructions = """

    Add the resource to your browser scope in web/router.ex:

        get "/sessions", SessionController, :new
        post "/sessions", SessionController, :create
        delete "/sessions", SessionController, :delete

    Remember to update your repository by running migrations:

        $ mix ecto.migrate

    """

    Mix.shell.info instructions
  end

  defp validate_args!([_, plural | _] = args) do
    cond do
      String.contains?(plural, ":") ->
        raise_with_help()
      plural != Phoenix.Naming.underscore(plural) ->
        Mix.raise "Expected the second argument, #{inspect plural}, to be all lowercase using snake_case convention"
      true ->
        args
    end
  end

  defp validate_args!(_) do
    ["User", "users"]
  end

  @spec raise_with_help() :: no_return()
  defp raise_with_help do
    Mix.raise """
    mix curator_database_authenticatable.install expects both singular and plural names
    of the generated resource followed by any number of attributes:

        mix curator_database_authenticatable.install User users
    """
  end

  defp migration(false, _path), do: []
  defp migration(_, path) do
    [{:eex, "migration.exs",
      "priv/repo/migrations/#{timestamp()}_create_#{String.replace(path, "/", "_")}_curator_database_authenticatable.exs"}]
  end

  defp timestamp do
    {{y, m, d}, {hh, mm, ss}} = :calendar.universal_time()
    "#{y}#{pad(m)}#{pad(d)}#{pad(hh)}#{pad(mm)}#{pad(ss)}"
  end

  defp pad(i) when i < 10, do: << ?0, ?0 + i >>
  defp pad(i), do: to_string(i)

  defp paths do
    [".", :curator_database_authenticatable]
  end
end
