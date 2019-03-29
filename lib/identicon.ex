defmodule Identicon do
  @moduledoc """
  Accept a string and create a MD5 hash. This is used to generate an identicon image
  """

  def main(input) do
    input
    |> hash_input
  end

  @doc"""
    Accepts a string input, uses that to create an MD5 hash, then creates a
    list of bytes from the hash
  """
  def hash_input(input) do
    :crypto.hash(:md5, input)
    |> :binary.bin_to_list
  end
end
