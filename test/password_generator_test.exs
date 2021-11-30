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
        uppercase: Enum.map(Enum.to_list(?A..?Z), fn n -> <<n>> end)
      }

      %{
        options_type: options_type,
        result: result
      }
    end

    test "returns a string", %{result: result} do
      assert is_bitstring(result)
    end

    test "returns same length passed", %{result: result} do
      result_length = String.length(result)

      assert 10 = result_length
    end

    test "returns a lowercase string", %{options_type: options, result: result} do
      assert String.contains?(result, options.lowercase)
    end

    test "returns string with numbers", %{options_type: options} do
      options_with_numbers = %{
        "numbers" => true,
        "uppercase" => false,
        "symbols" => false
      }

      result = PasswordGenerator.generate(10, options_with_numbers)

      assert String.contains?(result, options.numbers)
    end

    test "returns string with uppercase", %{options_type: options} do
      options_with_uppercase = %{
        "numbers" => false,
        "uppercase" => true,
        "symbols" => false
      }

      result = PasswordGenerator.generate(10, options_with_uppercase)

      assert String.contains?(result, options.uppercase)
    end

    test "returns string with uppercase and numbers", %{options_type: options} do
      included_options = %{
        "numbers" => true,
        "uppercase" => true,
        "symbols" => false
      }

      result = PasswordGenerator.generate(10, included_options)

      assert String.contains?(result, options.uppercase)
      assert String.contains?(result, options.numbers)
    end
  end
end
