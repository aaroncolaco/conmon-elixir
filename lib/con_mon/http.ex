defmodule ConMon.Http do
  use Plug.Router
  alias ConMon.TimeConverter

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/" do
    state_logs = ConMon.StateServer.get_state()
    latest_downtime = TimeConverter.timestamp_to_string(state_logs.latest_downtime, :milliseconds)

    response =
      Poison.encode!(%{
        status: state_logs.status,
        outageCount: state_logs.outage_count,
        totalDowntimeDuration:
          TimeConverter.timestamp_to_string(state_logs.downtime_duration, :milliseconds),
        latestDowntimeDuration: latest_downtime
      })

    send_resp(conn, 200, response)
  end

  match(_, do: send_resp(conn, 404, "Oops!"))
end
