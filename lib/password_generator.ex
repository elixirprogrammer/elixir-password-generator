defmodule PasswordGenerator do
  @moduledoc """
  Generates random password depending on paramaters.
  """

  @doc """
  Generates password for given length and options.
  When :lowercase passed only lowercase letter string returned
  When :numbers string with numbers returned

  ## Examples
      options = %{
        "numbers" => false,
        "uppercase" => false,
        "symbols" => false
      }

      iex> PasswordGenerator.generate(5, options)
      "abcdf"

      options = %{
        "numbers" => true,
        "uppercase" => false,
        "symbols" => false
      }
      iex> PasswordGenerator.generate(5, options)
      "ab1d3"

  """
  def generate(length, options) do
    Enum.map(1..length, fn _ -> call_get(options) end)
    |> to_string
  end

  defp call_get(options) do
    option = [:lowercase_letter | include(options)]
    option = Enum.random(option)
    get(option)
  end

  defp get(:lowercase_letter) do
    <<Enum.random(?a..?z)>>
  end

  defp get(:numbers) do
    Enum.random(0..9)
    |> Integer.to_string()
  end

  # Returns a list of atoms of included options
  defp include(options) do
    # Returns a list of key names when value is true
    Enum.filter(options, fn {_key, value} -> value end)
    |> Enum.map(fn {key, _value} -> String.to_atom(key) end)
  end
end
