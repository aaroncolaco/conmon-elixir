defmodule ConMon.CheckServer do
  use GenServer

  @hosts ["https://www.google.com", "https://www.youtube.com", "https://www.linkedin.com"]
  @me __MODULE__

  def start_link(param) do
    GenServer.start_link(__MODULE__, param, name: @me)
  end

  # state is the interval between checks
  def init(state) do
    Process.send_after(self(), :check, 0)
    {:ok, state}
  end

  def handle_info(:check, state) do
    Task.start(&check_connection/0)
    Process.send_after(self(), :check, state)
    {:noreply, state}
  end

  defp check_connection do
    for host <- @hosts do
      case :hackney.head(host) do
        {:ok, 200, _} -> ConMon.StateServer.connected()
        _ -> ConMon.StateServer.disconnected()
      end
    end
  end
end
