defmodule Identicon do
  @moduledoc """
  Accept a string and create a MD5 hash. This is used to generate an identicon
  image. An identicon is a 5x5 grid of 50x50 pixel squares
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
  end

  @doc """
    Accepts an Identicon.Image struct as an argument and pattern matches to
    pull values for RGB. Then a new Identicon.Image struct is returned with the
    RGB values as a tuple with a key `:color` along with the original image
    with the key `:hex`. See examples for broken out steps

  ## Examples

      iex> image = Identicon.hash_input("asdf")
      %Identicon.Image{
        color: nil
        hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]
      }
      iex> Identicon.pick_color(image)
      %Identicon.Image{
        color: {145, 46, 200},
        hex: [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]
      }

  """
  def pick_color(%Identicon.Image{hex: [r, g, b | _tail]} = image) do
    %Identicon.Image{image | color: {r, g, b}}
  end

  @doc """
    Accepts a string input, uses that to create an MD5 hash, then creates a
    list of bytes from the hash
  """
  def hash_input(input) do
    hex = :crypto.hash(:md5, input)
    |> :binary.bin_to_list

    %Identicon.Image{hex: hex}
  end
end
