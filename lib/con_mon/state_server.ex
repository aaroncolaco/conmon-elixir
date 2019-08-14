defmodule ConMon.StateServer do
  use GenServer

  @me __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, %{status: nil, downtime: []}, name: @me)
  end

  def init(state) do
    {:ok, state}
  end

  def clear_state do
    GenServer.cast(@me, :clear)
  end

  def connected do
    GenServer.cast(@me, :connected)
  end

  def disconnected do
    GenServer.cast(@me, :disconnected)
  end

  def get_state do
    GenServer.call(@me, :get_state)
  end

  def handle_cast(:clear, _state) do
    {:noreply, %{status: nil, downtime: []}}
  end

  def handle_cast(:connected, state) do
    case state.status do
      # do nothing
      :connected ->
        {:noreply, state}

      # :disconnected, update entry to show connection time
      :disconnected ->
        updated_first_tuple =
          state.downtime
          |> Enum.at(0)
          |> Tuple.append(DateTime.utc_now())

        state = %{
          state
          | status: :connected,
            downtime: List.replace_at(state.downtime, 0, updated_first_tuple)
        }

        {:noreply, state}

      nil ->
        state = %{
          state
          | status: :connected
        }

        {:noreply, state}
    end
  end

  def handle_cast(:disconnected, state) do
    case state.status do
      # do nothing
      :disconnected ->
        {:noreply, state}

      # :connected or nil, add a entry to show disconnect time
      _ ->
        state = %{
          state
          | status: :disconnected,
            downtime: [{DateTime.utc_now()}] ++ state.downtime
        }

        {:noreply, state}
    end
  end

  def handle_call(:get_state, _from, state) do
    downtime_duration =
      state.downtime
      |> Enum.reduce(0, fn tuple_log, acc ->
        calculate_time_difference(tuple_log) + acc
      end)

    return_state =
      state
      |> Map.put_new(:outage_count, Enum.count(state.downtime))
      |> Map.put_new(:downtime_duration, downtime_duration)
      |> Map.put_new(:latest_downtime, get_latest_downtime(state))

    {:reply, return_state, state}
  end

  defp get_latest_downtime(state) do
    case Enum.at(state.downtime, 0) do
      nil -> 0
      latest_tuple -> calculate_time_difference(latest_tuple)
    end
  end

  defp calculate_time_difference(time_tuple) do
    time_list = Tuple.to_list(time_tuple)

    # if the log has both disconnect and connect time, find the difference
    # if the log has only disconnect time it means still isn't connected. So calculate difference with current time
    # any other case return 0 difference
    case time_list do
      [disconnect_time = %DateTime{}, connect_time = %DateTime{}] ->
        DateTime.diff(connect_time, disconnect_time, :millisecond)

      [disconnect_time = %DateTime{}] ->
        DateTime.diff(DateTime.utc_now(), disconnect_time, :millisecond)

      _ ->
        0
    end
  end
end
