defmodule ConMonTest do
  use ExUnit.Case
  doctest ConMon

  test "greets the world" do
    assert ConMon.hello() == :world
  end
end
