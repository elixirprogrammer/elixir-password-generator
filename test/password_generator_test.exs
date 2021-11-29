defmodule PasswordGeneratorTest do
  use ExUnit.Case
  describe "Password Generator" do
    setup do
      options = %{
        lowercase: Enum.map(Enum.to_list(?a..?z), fn(n) -> <<n>> end)
      }
      %{options: options}
    end

    test "returns a lowercase string", %{options: options} do
      result = PasswordGenerator.generate(10, :lowercase)
      result_length = String.length(result)

      assert is_bitstring(result)

      assert String.contains?(result, options.lowercase)

      assert 10 = result_length
    end
  end
end
