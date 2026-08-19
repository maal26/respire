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

  describe "read_line/1" do
    test "returns the line and the remaining bytes" do
      assert Respire.RESP.read_line("$5\r\nhello\r\n") == {:ok, "$5", "hello\r\n"}
    end

    test "returns an empty rest when the CRLF ends the buffer" do
      assert Respire.RESP.read_line("*2\r\n") == {:ok, "*2", ""}
    end

    test "returns :incomplete when there is no CRLF" do
      assert Respire.RESP.read_line("$5") == :incomplete
    end

    test "returns :incomplete when the CRLF is split" do
      assert Respire.RESP.read_line("$5\r") == :incomplete
    end

    test "returns :incomplete for an empty buffer" do
      assert Respire.RESP.read_line("") == :incomplete
    end

    test "returns an empty line when the buffer starts with CRLF" do
      assert Respire.RESP.read_line("\r\nabc") == {:ok, "", "abc"}
    end
  end
end
