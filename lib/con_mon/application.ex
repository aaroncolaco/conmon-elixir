defmodule ConMon.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    # Authenticat with Firewall 
    ConMon.FirewallAuthenticator.authenticate()

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: ConMon.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      ConMon.StateServer,
      {ConMon.CheckServer, 2000},
      {Plug.Cowboy, scheme: :http, plug: ConMon.Http, options: [port: 8000]}
    ]
  end

  # all besides host
  def children(_target) do
    [
      ConMon.StateServer,
      {ConMon.CheckServer, 800},
      {Plug.Cowboy, scheme: :http, plug: ConMon.Http, options: [port: 80]}
    ]
  end
end
