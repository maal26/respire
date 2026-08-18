defmodule Respire.RESPTest do
  use ExUnit.Case, async: true

  describe "encode/1" do
    test "encodes a simple string" do
      assert Respire.RESP.encode({:simple, "OK"}) == "+OK\r\n"
    end

    test "encodes an error" do
      assert Respire.RESP.encode({:error, "ERROR"}) == "-ERROR\r\n"
    end

    test "encodes a positive integer" do
      assert Respire.RESP.encode({:integer, 10}) == ":10\r\n"
    end

    test "encodes a negative integer" do
      assert Respire.RESP.encode({:integer, -10}) == ":-10\r\n"
    end

    test "encodes a bulk string" do
      assert Respire.RESP.encode({:bulk, "hello"}) == "$5\r\nhello\r\n"
    end

    test "measures a bulk string in bytes, not characters" do
      assert Respire.RESP.encode({:bulk, "olá"}) == "$4\r\nolá\r\n"
    end

    test "encodes an empty bulk string" do
      assert Respire.RESP.encode({:bulk, ""}) == "$0\r\n\r\n"
    end

    test "encodes a null bulk string" do
      assert Respire.RESP.encode(:null) == "$-1\r\n"
    end
  end
end
