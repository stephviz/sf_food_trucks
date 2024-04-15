defmodule Mix.Tasks.Account.Create do
  @shortdoc "Generate new user and API token"

  @moduledoc """
  #{@shortdoc}

  Default user created on ecto.setup. To add additional users, set users table fields as flags with values following

  note: passwords need to be at least 12 characters

  ## Examples

      iex> mix account.create
      Test User created!

      Use these credentials to login: user@test.com, securepassword.
      Use this authorization token to test the API routes: <token>.

      iex> mix account.create --email "user@test.com" --password "securepassword"
      Test User created!

      Use these credentials to login: user@test.com, securepassword.
      Use this authorization token to test the API routes: <token>.

  """

  use Mix.Task

  alias SFFoodTrucks.Accounts

  @default_user %{email: "user@example.com", password: "password_123"}

  @impl true
  def run(args) do
    Mix.Task.run("app.start")

    if Mix.env() != :dev do
      raise "Task intended only for dev"
    end

    attrs = format_attrs(args, @default_user)

    with {:ok, user} <-
           Accounts.register_user(attrs) do
      token = Accounts.create_user_api_token(user)

      Mix.shell().info("""

      Test User created!

      Use these credentials to login: #{user.email}, #{attrs.password}
      Use this authorization token to test the API routes: #{token}

      """)
    else
      {:error, error} ->
        Mix.shell().error("""
        Error when generating test user.

        #{inspect(error)}
        """)
    end
  end

  defp format_attrs(args, default_user) do
    args =
      args
      |> Enum.chunk_every(2)
      |> Enum.reduce(%{}, fn params, acc ->
        [k, v] = params
        key = k |> String.replace("--", "") |> String.to_atom()
        Map.put(acc, key, v)
      end)

    Map.merge(default_user, args)
  end
end
