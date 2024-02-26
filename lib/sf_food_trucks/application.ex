defmodule SfFoodTrucks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SfFoodTrucksWeb.Telemetry,
      SfFoodTrucks.Repo,
      {DNSCluster, query: Application.get_env(:sf_food_trucks, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SfFoodTrucks.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SfFoodTrucks.Finch},
      # Start a worker by calling: SfFoodTrucks.Worker.start_link(arg)
      # {SfFoodTrucks.Worker, arg},
      # Start to serve requests, typically the last entry
      SfFoodTrucksWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SfFoodTrucks.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SfFoodTrucksWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
