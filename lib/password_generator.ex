defmodule PasswordGenerator do
  @moduledoc """
  Generates random password depending on paramaters. Module main function is `generate(options)`.
  That functon takes the options map.
  Options example:
      options = %{
        "length" => "5",
        "numbers" => "false",
        "uppercase" => "false",
        "symbols" => "false"
      }
  The options are only 4, `length`, `numbers`, `uppercase`, `symbols`.
  When the function is invoked the first thing is:
  Defines a length variable that checks the map passed keys for the length.
  Then calls the private validate function passing in the previously defined length and the options.
  When false an error will be returned.
  When true checks if the string value of the `length` key contains an integer.
  Then calls the private function `validate_length_is_integer(length, options)`.
  When false an error is returned.
  When true:
  Defines a `length` variables that is trimmed and converted to integer.
  Defines an `options_without_length` variable to remove the length from map.
  Defines `options_value` that gets all the values from the previously defined `options_without_length`.
  Defines `value` variable which iterates over the values and converts them to atoms and check if boolean.
  If not all the values are booleans false is returned, true otherwise.
  Then the private function `validate_options_values_are_boolean(value, length, options_without_length)` is invoked.
  When false an error is returned.
  When true:
  Defines an options variable which calls the private function
  included_options(options) passing in the options
  that returns a list of atoms with the options that are truthy
  :lowercase_letter is prepended to that list as a default option.
  Then `included` is defined to get a list of the letters that are going to be included.
  For example if numbers and uppercase are true it returns the list ["a", "1", "B"].
  That is done by calling the private function `include` passing in the previously
  defined options iterating over those options and calling the private function
  `get` that gets the corresponding letter.
  If the options is invalid false will be returned and included in the list.
  Then length is defined to substract the length from the length of the previously defined included list.
  Then `random_strings` is defined to generate a list of random letters depending on the
  options, the length will be the previously defined length so that the string that we are going to return
  is going to be exact at the one passed when called.
  This is done by calling the private function `generate_strings(length, options).
  Then the 2 lists are concatenated, `included` and `random_strings` defined in the `strings` variable.
  Then `invalid_option?` is defined that iterate over the `strings` variable.
  When false is found true will be returned, false otherwise.
  Then the private function `validate_options(invalid_option?, strings)` is invoked.
  When true and error will be returned.
  When false the `strings` list will be shuffled and converted to string and `{:ok, string}` returned.
  """
  @symbols "!#$%&()*+,-./:;<=>?@[]^_{|}~"

  @doc """
  Generates password for given options.
  ## Examples
      options = %{
        "length" => "5",
        "numbers" => "false",
        "uppercase" => "false",
        "symbols" => "false"
      }
      iex> PasswordGenerator.generate(options)
      "abcdf"
      options = %{
        "length" => "5",
        "numbers" => "true",
        "uppercase" => "false",
        "symbols" => "false"
      }
      iex> PasswordGenerator.generate(options)
      "ab1d3"
  """
  @spec generate(options :: map()) :: {:ok, String.t()} | {:error, String.t()}
  def generate(options) do
    validate_length(options)
    |> validate_length_is_integer()
    |> validate_options_values_are_boolean()
    |> validate_options()
  end

  defp validate_length(options) do
    case Map.has_key?(options, "length") do
      true ->
        options

      false ->
        {:error, "Please provide a length"}
    end
  end

  defp validate_length_is_integer({:error, error}), do: {:error, error}

  defp validate_length_is_integer(options) do
    numbers = Enum.map(0..9, &Integer.to_string(&1))
    length = options["length"]

    case String.contains?(length, numbers) do
      true ->
        options

      false ->
        {:error, "Please provide a length"}
    end
  end

  def validate_options_values_are_boolean({:error, error}), do: {:error, error}

  def validate_options_values_are_boolean(options) do
    options_without_length = Map.delete(options, "length")
    options_values = Map.values(options_without_length)
    # Iterate over the values and converts them to atoms and check if boolean
    # If not all the values are booleans false is returned, true otherwise.
    value =
      options_values
      |> Enum.all?(fn x -> String.to_atom(x) |> is_boolean() end)

    case value do
      true ->
        options

      false ->
        {:error, "Only booleans allowed for options values"}
    end
  end

  defp validate_options({:error, error}), do: {:error, error}

  defp validate_options(options) do
    length_to_integer = options["length"] |> String.trim() |> String.to_integer()
    options_without_length = Map.delete(options, "length")
    options = [:lowercase_letter | included_options(options_without_length)]
    included = include(options)
    length = length_to_integer - length(included)
    random_strings = generate_strings(length, options)
    strings = included ++ random_strings
    invalid_option? = strings |> Enum.any?(&(&1 == false))

    case invalid_option? do
      true ->
        {:error, "Only options allowed numbers, uppercase, symbols."}

      false ->
        string =
          strings
          |> Enum.shuffle()
          |> to_string()

        {:ok, string}
    end
  end

  @spec generate_strings(length :: integer(), options :: list()) :: list()
  defp generate_strings(length, options) do
    Enum.map(1..length, fn _ ->
      Enum.random(options) |> get()
    end)
  end

  @spec include(options :: list()) :: list()
  defp include(options) do
    options
    |> Enum.map(&get(&1))
  end

  # Letters can be represented by the binary value
  # example ?a = 97 and <<?a>> = "a"
  # Enum.random takes a range of integers
  # passing binary values you get all the letters of the alphabet
  @spec get(atom()) :: String.t() | false
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

  defp get(_option), do: false

  # Returns a list of atoms of included options
  @spec included_options(options :: map()) :: list()
  defp included_options(options) do
    # Returns a list of key value pairs when value is true
    # example [{"numbers", true}, {"uppercase", true}]
    # then keys get mapped and converted to atoms
    # example [:numbers, :uppercase]
    Enum.filter(options, fn {_key, value} ->
      value |> String.trim() |> String.to_existing_atom()
    end)
    |> Enum.map(fn {key, _value} -> String.to_atom(key) end)
  end
end
