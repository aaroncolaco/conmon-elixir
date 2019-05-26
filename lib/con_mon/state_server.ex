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
    return_state = Map.put_new(state, :outage_count, Enum.count(state.downtime))
    {:reply, return_state, state}
  end
end
