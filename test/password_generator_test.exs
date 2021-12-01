defmodule PasswordGeneratorTest do
  use ExUnit.Case

  describe "Password Generator" do
    setup do
      options = %{
        "numbers" => false,
        "uppercase" => false,
        "symbols" => false
      }

      result = PasswordGenerator.generate(10, options)

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
        "numbers" => true,
        "uppercase" => false,
        "symbols" => false
      }

      result = PasswordGenerator.generate(10, options_with_numbers)

      assert  10 = String.length(result)
      assert String.contains?(result, options.numbers)

      refute String.contains?(result, options.uppercase)
      refute String.contains?(result, options.symbols)
    end

    test "returns string with uppercase", %{options_type: options} do
      options_with_uppercase = %{
        "numbers" => false,
        "uppercase" => true,
        "symbols" => false
      }

      result = PasswordGenerator.generate(10, options_with_uppercase)

      assert  10 = String.length(result)
      assert String.contains?(result, options.uppercase)

      refute String.contains?(result, options.numbers)
      refute String.contains?(result, options.symbols)
    end

    test "returns string with uppercase and numbers", %{options_type: options} do
      included_options = %{
        "numbers" => true,
        "uppercase" => true,
        "symbols" => false
      }

      result = PasswordGenerator.generate(10, included_options)

      assert  10 = String.length(result)
      assert String.contains?(result, options.uppercase)
      assert String.contains?(result, options.numbers)

      refute String.contains?(result, options.symbols)
    end

    test "returns string with symbols", %{options_type: options} do
      included_options = %{
        "numbers" => false,
        "uppercase" => false,
        "symbols" => true
      }

      result = PasswordGenerator.generate(10, included_options)

      assert  10 = String.length(result)
      assert String.contains?(result, options.symbols)

      refute String.contains?(result, options.numbers)
      refute String.contains?(result, options.uppercase)
    end

    test "returns string with all included options", %{options_type: options} do
      included_options = %{
        "numbers" => true,
        "uppercase" => true,
        "symbols" => true
      }

      result = PasswordGenerator.generate(10, included_options)

      assert  10 = String.length(result)
      assert String.contains?(result, options.symbols)
      assert String.contains?(result, options.uppercase)
      assert String.contains?(result, options.numbers)
    end

    test "returns string with symbols and uppercase", %{options_type: options} do
      included_options = %{
        "numbers" => false,
        "uppercase" => true,
        "symbols" => true
      }

      result = PasswordGenerator.generate(10, included_options)

      assert  10 = String.length(result)
      assert String.contains?(result, options.symbols)
      assert String.contains?(result, options.uppercase)

      refute String.contains?(result, options.numbers)
    end

    test "returns string with symbols and numbers", %{options_type: options} do
      included_options = %{
        "numbers" => true,
        "uppercase" => false,
        "symbols" => true
      }

      result = PasswordGenerator.generate(10, included_options)

      assert  10 = String.length(result)
      assert String.contains?(result, options.symbols)
      assert String.contains?(result, options.numbers)

      refute String.contains?(result, options.uppercase)
    end
  end
end
