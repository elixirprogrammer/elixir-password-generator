defmodule PasswordGenerator do
  @moduledoc """
  Generates random password depending on paramaters. Module main function is `generate()`.
  That functon takes the length and options.

  Options example:
      options = %{
        "numbers" => false,
        "uppercase" => false,
        "symbols" => false
      }

  The options are only 3, `numbers`, `uppercase`, `symbols`.
  When the function is invoked the first thing is:
  Defines an options variable which calls the private function
  included_options(options) passing in the options
  that returns a list of atoms with the options that are truthy
  :lowercase_letter is prepended to that list as a default option.
  Then `included` is defined to get a list of the letters that are going to be included.
  For example if numbers and uppercase are true it returns the list ["a", "1", "B"].
  That is done by calling the private function `include` passing in the previously
  defined options iterating over those options and calling the private function
  `get` that gets the corresponding letter.
  Then length is defined to substract the length from the length of the previously defined included list.
  Then `random_strings` is defined to generate a list of random letters depending on the
  options, the length will be the previously defined length so that the string that we are going to return
  is going to be exact at the one passed when called.
  This is done by calling the private function `generate_strings(length, options).
  Finally the 2 lists are concatenated, shuffled and converted to a string.
  """

  @symbols "!#$%&()*+,-./:;<=>?@[]^_{|}~"

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
  @spec generate(length :: integer(), options :: map()) :: bitstring()
  def generate(length, options) do
    options = [:lowercase_letter | included_options(options)]
    included = include(options)
    length = length - length(included)
    random_strings = generate_strings(length, options)
    #concatenate, shuffles and converts list to string
    included ++ random_strings
    |> Enum.shuffle()
    |> to_string()
  end

  defp generate_strings(length, options) do
    Enum.map(1..length, fn _ ->
      Enum.random(options) |> get()
    end)
  end

  defp include(options) do
    options
    |> Enum.map(& get(&1))
  end

  # Letters can be represented by the binary value
  # example ?a = 97 and <<?a>> = "a"
  # Enum.random takes a range of integers
  # passing binary values you get all the letters of the alphabet
  defp get(:lowercase_letter) do
    <<Enum.random(?a..?z)>>
  end

  defp get(:numbers) do
    Enum.random(0..9)
    |> Integer.to_string()
  end

  defp get(:uppercase) do
    <<Enum.random(?A..?Z)>>
  end

  defp get(:symbols) do
    symbols =
      @symbols
      |> String.split("", trim: true)

    Enum.random(symbols)
  end

  # Returns a list of atoms of included options
  defp included_options(options) do
    # Returns a list of key value pairs when value is true
    # example [{"numbers", true}, {"uppercase", true}]
    # then keys get mapped and converted to atoms
    # example [:numbers, :uppercase]
    Enum.filter(options, fn {_key, value} -> value end)
    |> Enum.map(fn {key, _value} -> String.to_atom(key) end)
  end
end
