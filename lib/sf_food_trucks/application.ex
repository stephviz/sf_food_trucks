defmodule SFFoodTrucks.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      SFFoodTrucksWeb.Telemetry,
      SFFoodTrucks.Repo,
      {DNSCluster, query: Application.get_env(:sf_food_trucks, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: SFFoodTrucks.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: SFFoodTrucks.Finch},
      # Start a worker by calling: SFFoodTrucks.Worker.start_link(arg)
      # {SFFoodTrucks.Worker, arg},
      # Start to serve requests, typically the last entry
      SFFoodTrucksWeb.Endpoint,
      {DynamicSupervisor, name: SFFoodTrucks.Fixture.BatchProcessorSupervisor}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: SFFoodTrucks.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SFFoodTrucksWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
