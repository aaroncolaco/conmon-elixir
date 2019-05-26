defmodule ConMon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConMon.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      ConMon.StateServer
    ]
  end

  def children(_target) do
    [
      ConMon.StateServer
    ]
  end
end
