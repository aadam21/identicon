defmodule Identicon.Image do
  @moduledoc """
  Struct for storing the hex values of a hashed string
  """

  defstruct hex: nil, color: nil, grid: nil, pixel_map: nil
end
