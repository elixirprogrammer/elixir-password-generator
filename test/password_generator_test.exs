defmodule PasswordGeneratorTest do
  use ExUnit.Case

  describe "Password Generator" do
    setup do
      options = %{
        "length" => "10",
        "numbers" => "false",
        "uppercase" => "false",
        "symbols" => "false"
      }

      {:ok, result} = PasswordGenerator.generate(options)

      options_type = %{
        lowercase: Enum.map(Enum.to_list(?a..?z), fn n -> <<n>> end),
        numbers: Enum.map(Enum.to_list(0..9), fn n -> Integer.to_string(n) end),
        uppercase: Enum.map(Enum.to_list(?A..?Z), fn n -> <<n>> end),
        symbols: String.split("!#$%&()*+,-./:;<=>?@[]^_{|}~", "", trim: true)
      }

      %{
        options_type: options_type,
        result: result
      }
    end

    test "returns error when no length is given" do
      options = %{"invalid" => "false"}

      assert {:error, _error} = PasswordGenerator.generate(options)
    end

    test "returns error when length is not an integer" do
      options = %{"length" => "ab"}

      assert {:error, _error} = PasswordGenerator.generate(options)
    end

    test "returns error when option not allowed" do
      options = %{"length" => "5", "invalid" => "true"}

      assert {:error, _error} = PasswordGenerator.generate(options)
    end

    test "returns error when 1 option not allowed" do
      options = %{"length" => "5", "numbers" => "true", "invalid" => "true"}

      assert {:error, _error} = PasswordGenerator.generate(options)
    end

    test "returns a lowercase string just with the length", %{options_type: options}  do
      length_option = %{"length" => "5"}
      {:ok, result} = PasswordGenerator.generate(length_option)

      assert String.contains?(result, options.lowercase)

      refute String.contains?(result, options.numbers)
      refute String.contains?(result, options.uppercase)
      refute String.contains?(result, options.symbols)
    end

    test "returns error when options values are not booleans" do
      options = %{
        "length" => "10",
        "numbers" => "invalid",
        "uppercase" => "0",
        "symbols" => "false"
      }

      assert {:error, _error} = PasswordGenerator.generate(options)
    end

    test "returns a string", %{result: result} do
      assert is_bitstring(result)
    end

    test "returns a string with only lowercase", %{options_type: options, result: result} do
      assert  10 = String.length(result)
      assert String.contains?(result, options.lowercase)

      refute String.contains?(result, options.numbers)
      refute String.contains?(result, options.uppercase)
      refute String.contains?(result, options.symbols)
    end

    test "returns string just with numbers", %{options_type: options} do
      options_with_numbers = %{
        "length" => "10",
        "numbers" => "true",
        "uppercase" => "false",
        "symbols" => "false"
      }

      {:ok, result} = PasswordGenerator.generate(options_with_numbers)

      assert  10 = String.length(result)
      assert String.contains?(result, options.numbers)

      refute String.contains?(result, options.uppercase)
      refute String.contains?(result, options.symbols)
    end

    test "returns string with uppercase", %{options_type: options} do
      options_with_uppercase = %{
        "length" => "10",
        "numbers" => "false",
        "uppercase" => "true",
        "symbols" => "false"
      }

      {:ok, result} = PasswordGenerator.generate(options_with_uppercase)

      assert  10 = String.length(result)
      assert String.contains?(result, options.uppercase)

      refute String.contains?(result, options.numbers)
      refute String.contains?(result, options.symbols)
    end

    test "returns string with uppercase and numbers", %{options_type: options} do
      included_options = %{
        "length" => "10",
        "numbers" => "true",
        "uppercase" => "true",
        "symbols" => "false"
      }

      {:ok, result} = PasswordGenerator.generate(included_options)

      assert  10 = String.length(result)
      assert String.contains?(result, options.uppercase)
      assert String.contains?(result, options.numbers)

      refute String.contains?(result, options.symbols)
    end

    test "returns string with symbols", %{options_type: options} do
      included_options = %{
        "length" => "10",
        "numbers" => "false",
        "uppercase" => "false",
        "symbols" => "true"
      }

      {:ok, result} = PasswordGenerator.generate(included_options)

      assert  10 = String.length(result)
      assert String.contains?(result, options.symbols)

      refute String.contains?(result, options.numbers)
      refute String.contains?(result, options.uppercase)
    end

    test "returns string with all included options", %{options_type: options} do
      included_options = %{
        "length" => "10",
        "numbers" => "true",
        "uppercase" => "true",
        "symbols" => "true"
      }

      {:ok, result} = PasswordGenerator.generate(included_options)

      assert  10 = String.length(result)
      assert String.contains?(result, options.symbols)
      assert String.contains?(result, options.uppercase)
      assert String.contains?(result, options.numbers)
    end

    test "returns string with symbols and uppercase", %{options_type: options} do
      included_options = %{
        "length" => "10",
        "numbers" => "false",
        "uppercase" => "true",
        "symbols" => "true"
      }

      {:ok, result} = PasswordGenerator.generate(included_options)

      assert  10 = String.length(result)
      assert String.contains?(result, options.symbols)
      assert String.contains?(result, options.uppercase)

      refute String.contains?(result, options.numbers)
    end

    test "returns string with symbols and numbers", %{options_type: options} do
      included_options = %{
        "length" => "10",
        "numbers" => "true",
        "uppercase" => "false",
        "symbols" => "true"
      }

      {:ok, result} = PasswordGenerator.generate(included_options)

      assert  10 = String.length(result)
      assert String.contains?(result, options.symbols)
      assert String.contains?(result, options.numbers)

      refute String.contains?(result, options.uppercase)
    end
  end
end
