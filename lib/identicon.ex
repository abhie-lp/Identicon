defmodule Identicon do
  @moduledoc """
  Generate and save the identicon image for the given string.
  """
  def main(string) do
    string
    |> create_hash
  end

  @doc """
  Create the MD5 hash of the given string.

  ## Examples
      iex(4)> Identicon.create_hash("asdf")
      <<145, 46, 200, 3, 178, 206, 73, 228, 165, 65, 6, 141, 73, 90, 181, 112>>
  """
  def create_hash(string) do
    :crypto.hash(:md5, string)
  end
end
