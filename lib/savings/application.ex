defmodule Savings.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Savings.Repo,
      # Start the Telemetry supervisor
      SavingsWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Savings.PubSub},
      # Start the Endpoint (http/https)
      Savings.Scheduler,
      {Task.Supervisor, name: Savings.TaskSupervisor, restart: :transient},
      SavingsWeb.Endpoint
      # Start a worker by calling: Savings.Worker.start_link(arg)
      # {Savings.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Savings.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    SavingsWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
