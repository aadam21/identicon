defmodule Identicon do
  @moduledoc """
  Accept a string and create a MD5 hash. This is used to generate an identicon
  image. An identicon is a 5x5 grid of 50x50 pixel squares
  """

  def main(input) do
    input
    |> hash_input
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(input)
  end

  def save_image(image, input) do
    File.write("#{input}.png", image)
  end

  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(250, 250)
    fill = :egd.color(color)

    Enum.each pixel_map, fn({start, stop}) ->
      :egd.filledRectangle(image, start, stop, fill)
    end

    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map grid, fn({_code, index}) ->
      horizontal = rem(index, 5) * 50
      vertical  = div(index, 5) * 50

      top_left = {horizontal, vertical}
      bottom_right = {horizontal + 50, vertical + 50}

      {top_left, bottom_right}
    end

    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
    Accept the struct and pare down the grid, so it only includes tuples with
    values that are even numbers. Ultimately only these squares in the grid
    will be colored in
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter grid, fn({code, _index}) ->
      rem(code, 2) == 0
    end

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Take the `hex` value from the image struct and break it into a list of
    three value lists. Mirror each of those smaller lists, then flatten into
    a single list. Finally, build a list of tuples with each value and its
    index. This represents the grid, with accompanying values
  """
  def build_grid(%Identicon.Image{hex: hex} = image) do
    grid =
      hex
      |> Enum.chunk(3)
      |> Enum.map(&mirror_row/1)
      |> List.flatten
      |> Enum.with_index

    %Identicon.Image{image | grid: grid}
  end

  @doc """
    Accept a list of three elements, and "mirror" it by creating a new list
    with the first and second original elements appended in inverse order
  """
  def mirror_row(row) do
    [first, second | _tail] = row

    row ++ [second, first]
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
