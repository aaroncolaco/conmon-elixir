defmodule ConMon.TimeConverter do
  @minute 60
  @hour @minute * 60
  @day @hour * 24
  @week @day * 7
  @divisor [@week, @day, @hour, @minute, 1]

  def timestamp_to_string(0, _) do
    "0 sec"
  end

  def timestamp_to_string(timestamp, :seconds) do
    {_, [s, m, h, d, w]} =
      Enum.reduce(@divisor, {timestamp, []}, fn divisor, {n, acc} ->
        {rem(n, divisor), [div(n, divisor) | acc]}
      end)

    ["#{w} wk", "#{d} d", "#{h} hr", "#{m} min", "#{s} sec"]
    |> Enum.reject(fn str -> String.starts_with?(str, "0") end)
    |> Enum.join(", ")
  end

  def timestamp_to_string(timestamp, :milliseconds) do
    __MODULE__.timestamp_to_string(div(timestamp, 1000), :seconds)
  end
end
