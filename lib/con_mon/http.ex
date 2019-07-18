defmodule ConMon.Http do
  use Plug.Router

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/" do
    state_logs = ConMon.StateServer.get_state()

    response =
      Poison.encode!(%{
        status: state_logs.status,
        outageCount: state_logs.outage_count,
        downtimeDuration: "#{state_logs.downtime_duration / 1000} seconds"
      })

    send_resp(conn, 200, response)
  end

  match(_, do: send_resp(conn, 404, "Oops!"))
end
