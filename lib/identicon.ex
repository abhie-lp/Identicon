require Integer

defmodule Identicon do
  @moduledoc """
  Generate and save the identicon image for the given string.

  ## Examples
      iex> Identicon.main("elixir")
      :ok
      iex> Identicon.main("django")
      :ok
      iex> Identicon.main("python")
      :ok
      iex> Identicon.main("Linkin Park")
      :ok
      iex> Identicon.main("Coldplay")
      :ok
      iex> Identicon.main("Goku")
      :ok
      iex> Identicon.main("Mikasa")
      :ok
  """
  def main(string) do
    string
    |> create_hash
    |> hash_to_list
    |> pick_color
    |> build_grid
    |> filter_odd_squares
    |> build_pixel_map
    |> draw_image
    |> save_image(string)
  end

  @doc """
  Save the image to disk with string as the filename
  """
  def save_image(image, filename) do
    File.write("#{filename}.png", image)
  end

  @doc """
  Draw image based on pixel mapping
  """
  def draw_image(%Identicon.Image{color: color, pixel_map: pixel_map}) do
    image = :egd.create(270, 270)
    fill = :egd.color(color)
    Enum.each(pixel_map, fn {start, stop} ->
      :egd.filledRectangle(image, start, stop, fill)
    end)
    :egd.render(image)
  end

  def build_pixel_map(%Identicon.Image{grid: grid} = image) do
    pixel_map = Enum.map(grid, fn {_, index} ->
                horizontal = rem(index, 5) * 50 + 10
                vertical = div(index, 5) * 50 + 10

                top_left = {horizontal, vertical}
                bottom_right = {horizontal + 50, vertical + 50}

                {top_left, bottom_right}
              end)
    %Identicon.Image{image | pixel_map: pixel_map}
  end

  @doc """
  Filter out the odd squares.
  """
  def filter_odd_squares(%Identicon.Image{grid: grid} = image) do
    grid = Enum.filter(grid, fn {num, _} -> Integer.is_even(num) end)
    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Create the grid for the image
  """
  def build_grid(%Identicon.Image{hex: hex_list} = image) do
    grid = hex_list
          |> Enum.chunk_every(3, 3, :discard)
          |> Enum.map(&mirror_list/1)
          |> List.flatten
          |> Enum.with_index
    %Identicon.Image{image | grid: grid}
  end

  @doc """
  Create the mirror of the given list

  ## Examples
      iex> Identicon.mirror_list([1, 2, 3])
      [1, 2, 3, 2, 1]
      iex> Identicon.mirror_list([1, 2, 3, 4])
      [1, 2, 3, 4, 3, 2, 1]
  """
  def mirror_list(list) do
    {mirror_elements, _} = Enum.split(list, length(list) - 1)
    list ++ Enum.reverse(mirror_elements)
  end

  @doc """
  Select the first three elements from the given hash list as color
  """
  def pick_color(%Identicon.Image{hex: [red, green, blue | _]} = image) do
    %Identicon.Image{image | color: {red, green, blue}}
  end

  @doc """
  Convert the hash value to list and retuurn Identicon.Image
  """
  def hash_to_list(hash_value) do
    hex = :binary.bin_to_list(hash_value)
    %Identicon.Image{hex: hex}
  end

  @doc """
  Create the MD5 hash of the given string.

  ## Examples
      iex> Identicon.create_hash("asdf")
      <<145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112>>
  """
  def create_hash(string) do
    :crypto.hash(:md5, string)
  end
end
