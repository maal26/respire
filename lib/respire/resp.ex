defmodule Respire.RESP do
  def encode({:simple, text}) do
    "+" <> text <> "\r\n"
  end

  def encode({:error, text}) do
    "-" <> text <> "\r\n"
  end

  def encode({:integer, number}) do
    ":" <> Integer.to_string(number) <> "\r\n"
  end

  def encode({:bulk, text}) do
    size = byte_size(text)

    "$" <> Integer.to_string(size) <> "\r\n" <> text <> "\r\n"
  end

  def encode(:null) do
    "$-1\r\n"
  end
end
