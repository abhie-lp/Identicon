defmodule Identicon do
  @moduledoc """
  Generate and save the identicon image for the given string.
  """
  def main(string) do
    string
    |> create_hash
    |> hash_to_list
    |> pick_color
    |> build_grid
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

  ## Examples
      iex> Identicon.hash_to_list(Identicon.create_hash("asdf"))
      [145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112]
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
