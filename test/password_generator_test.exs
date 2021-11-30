defmodule PasswordGeneratorTest do
  use ExUnit.Case

  describe "Password Generator" do
    setup do
      options = %{
        "numbers" => false,
        "uppercase" => false,
        "symbols" => false
      }

      options_with_numbers = %{
        "numbers" => true,
        "uppercase" => false,
        "symbols" => false
      }

      result = PasswordGenerator.generate(10, options)
      result_with_numbers = PasswordGenerator.generate(10, options_with_numbers)

      options_type = %{
        lowercase: Enum.map(Enum.to_list(?a..?z), fn n -> <<n>> end),
        numbers: Enum.map(Enum.to_list(0..9), fn n -> Integer.to_string(n) end)
      }

      %{
        options_type: options_type,
        result: result,
        result_with_numbers: result_with_numbers
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

    test "returns string with numbers", %{options_type: options, result_with_numbers: result} do
      assert String.contains?(result, options.numbers)
    end
  end
end
