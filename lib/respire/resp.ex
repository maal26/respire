defmodule Respire.RESP do
  @clrf "\r\n"

  def encode({:simple, text}) do
    "+" <> text <> @clrf
  end

  def encode({:error, text}) do
    "-" <> text <> @clrf
  end

  def encode({:integer, number}) do
    ":" <> Integer.to_string(number) <> @clrf
  end

  def encode({:bulk, text}) do
    size = byte_size(text)

    "$" <> Integer.to_string(size) <> @clrf <> text <> @clrf
  end

  def encode(:null) do
    "$-1" <> @clrf
  end

  def read_line(text) do
    read_line(text, "")
  end

  defp read_line(<<@clrf, rest::binary>>, acc) do
    {:ok, acc, rest}
  end

  defp read_line(<<byte, rest::binary>>, acc) do
    read_line(rest, <<acc::binary, byte>>)
  end

  defp read_line(<<>>, _acc) do
    :incomplete
  end
end
