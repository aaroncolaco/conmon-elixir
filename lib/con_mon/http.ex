defmodule ConMon.Http do
  use Plug.Router
  alias ConMon.TimeConverter

  plug(:match)
  plug(Plug.Parsers, parsers: [:json], json_decoder: Poison)
  plug(:dispatch)

  get "/" do
    state_logs = ConMon.StateServer.get_state()
    latest_downtime = TimeConverter.timestamp_to_string(state_logs.latest_downtime, :milliseconds)
    top_logs = format_logs(state_logs.downtime, 200)

    response =
      Poison.encode!(%{
        status: state_logs.status,
        outageCount: state_logs.outage_count,
        totalDowntime:
          TimeConverter.timestamp_to_string(state_logs.downtime_duration, :milliseconds),
        latestDowntime: latest_downtime,
        latestDowntimeLogs: top_logs
      })

    send_resp(conn, 200, response)
  end

  defp format_logs([], _count), do: []

  defp format_logs(logs, count) do
    Enum.take(logs, count)
    |> Enum.map(fn
      {down, up} ->
        [
          DateTime.to_string(DateTime.add(up, 19800, :second)), # make time +5:30 for india
          DateTime.to_string(DateTime.add(down, 19800, :second))
        ]

      {down} ->
        [DateTime.to_string(DateTime.add(down, 19800, :second))]
    end)
  end

  match(_, do: send_resp(conn, 404, "Oops!"))
end
