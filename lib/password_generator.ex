defmodule PasswordGenerator do
  @moduledoc """
  Generates random password depending on paramaters.
  """

  @lower_case_letters_list Enum.map(Enum.to_list(?a..?z), fn n -> <<n>> end)

  @doc """
  Generates password only with lowercase alphabet depending on length

  ## Examples

      iex> PasswordGenerator.generate(5, :lowercase)
      "abcdf"

  """
  def generate(length, :lowercase) do
    lower_case_letters_list(length)
    |> to_string
  end

  defp lower_case_letters_list(length) do
    Enum.map(1..length, fn _ -> <<Enum.random(?a..?z)>> end)
  end
end
