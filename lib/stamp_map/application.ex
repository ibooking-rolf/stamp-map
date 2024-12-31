defmodule StampMap.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      StampMapWeb.Telemetry,
      StampMap.Repo,
      {DNSCluster, query: Application.get_env(:stamp_map, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: StampMap.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: StampMap.Finch},
      # Start a worker by calling: StampMap.Worker.start_link(arg)
      # {StampMap.Worker, arg},
      # Start to serve requests, typically the last entry
      StampMapWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: StampMap.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    StampMapWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
