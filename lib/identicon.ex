defmodule Identicon do
  @moduledoc """
  Generate and save the identicon image for the given string.
  """
  def main(string) do
    string
    |> create_hash
    |> hash_to_list
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
