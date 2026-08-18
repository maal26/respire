defmodule RespireTest do
  use ExUnit.Case
  doctest Respire

  test "greets the world" do
    assert Respire.hello() == :world
  end
end
