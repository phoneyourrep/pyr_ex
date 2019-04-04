defmodule PYREx.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      PYREx.Repo,
      PYRExWeb.Endpoint
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: PYREx.Supervisor)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PYRExWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
