defmodule BingX.Support.Struct do
  defmacro test_module_struct(module, fields) do
    quote do
      test "should have specific number of fields" do
        assert (
          struct(unquote(module), %{})
          |> Map.from_struct()
          |> Map.keys()
          |> length() === length(unquote(fields))
        )
      end

      test "should have only expected fields" do
        assert (
          struct(unquote(module), %{})
          |> Map.from_struct()
          |> Map.keys()
          |> Enum.map(fn k -> assert k in unquote(fields) end)
        )
      end
    end
  end
end
