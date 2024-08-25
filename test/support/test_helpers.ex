defmodule BingX.TestHelpers do
  alias BingX.Interpretators
  alias BingX.Helpers

  defmacro test_module_struct(module, fields) do
    quote do
      test "should have specific number of fields" do
        assert struct(unquote(module), %{})
               |> Map.from_struct()
               |> Map.keys()
               |> length() === length(unquote(fields))
      end

      test "should have only expected fields" do
        assert struct(unquote(module), %{})
               |> Map.from_struct()
               |> Map.keys()
               |> Enum.map(fn k -> assert k in unquote(fields) end)
      end
    end
  end

  defmacro test_response_key_interp(module, func, args, key_or_path, exp_key) do
    key_path = (is_list(key_or_path) && key_or_path) || [key_or_path]
    key_path_raw = Enum.join(key_path, " -> ")

    quote do
      test "should retrieve #{unquote(key_path_raw)} and return it as #{unquote(exp_key)}" do
        module = unquote(module)
        func = unquote(func)
        args = unquote(args)
        exp_key = unquote(exp_key)
        key_path = unquote(key_path)

        data = Helpers.put_in(%{}, key_path, "X")

        assert %{^exp_key => "X"} = apply(module, func, [data] ++ args)
      end
    end
  end

  defmacro test_response_key_interp(module, func, args, interp, key_or_path, exp_key) do
    key_path = (is_list(key_or_path) && key_or_path) || [key_or_path]
    key_path_raw = Enum.join(key_path, " -> ")

    quote do
      test "should retrieve and transform #{unquote(key_path_raw)} into float" do
        module = unquote(module)
        func = unquote(func)
        args = unquote(args)
        interp = unquote(interp)
        exp_key = unquote(exp_key)
        key_path = unquote(key_path)
        data = Helpers.put_in(%{}, key_path, "X")

        patch(Interpretators, interp, "Y")

        apply(module, func, [data] ++ args)

        assert_called_once(Interpretators.unquote(interp)("X"))
      end

      test "should retrieve #{unquote(key_path_raw)} and return it as #{unquote(exp_key)}" do
        module = unquote(module)
        func = unquote(func)
        args = unquote(args)
        interp = unquote(interp)
        exp_key = unquote(exp_key)
        key_path = unquote(key_path)
        data = Helpers.put_in(%{}, key_path, "X")

        patch(Interpretators, interp, "Y")
        assert %{^exp_key => "Y"} = apply(module, func, [data] ++ args)
      end

      test "should return #{unquote(module)} struct if #{unquote(key_path_raw)} persist" do
        module = unquote(module)
        func = unquote(func)
        args = unquote(args)
        interp = unquote(interp)
        exp_key = unquote(exp_key)
        key_path = unquote(key_path)

        patch(Interpretators, interp, "Y")

        mod_struct = struct(module, [{exp_key, "Y"}])
        data = Helpers.put_in(%{}, key_path, "X")

        assert ^mod_struct = apply(module, func, [data] ++ args)
      end

      test "should omit transforming if #{unquote(key_path_raw)} not presented" do
        module = unquote(module)
        func = unquote(func)
        args = unquote(args)
        interp = unquote(interp)

        patch(Interpretators, interp, "Y")

        apply(module, func, [%{}] ++ args)

        refute_called(Interpretators.unquote(interp)(_))
      end
    end
  end
end
