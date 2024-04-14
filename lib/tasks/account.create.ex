defmodule Mix.Tasks.Account.Create do
  use Mix.Task

  alias SFFoodTrucks.Accounts

  @impl true
  def run(_args) do
    Mix.Task.run("app.start")

    if Mix.env() != :dev do
      raise "Task intended only for dev"
    end

    with {:ok, user} <-
           Accounts.register_user(%{email: "user@example.com", password: "password123"}) do
      token = Accounts.create_user_api_token(user)

      Mix.shell().info("""

      Test User created!

      Use these credentials to login: #{user.email}, password123.
      Use this authorization token to test the API routes: #{token}.

      """)
    else
      {:error, error} ->
        Mix.shell().error("""
        Error when generating test user.

        #{inspect(error)}
        """)
    end
  end
end
