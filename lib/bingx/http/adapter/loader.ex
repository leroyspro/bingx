defmodule BingX.HTTP.Adapter.Loader do
  alias BingX.HTTP.Adapter

  @doc false
  defmacro load() do
    default =
      cond do
        Code.ensure_loaded?(HTTPoison) ->
          IO.puts("[BingX] *INFO* Loaded HTTPoison HTTP adapter")
          Adapter.HTTPoison

        Code.ensure_loaded?(Finch) ->
          IO.puts("[BingX] *INFO* Loaded Finch HTTP adapter")
          Adapter.Finch

        true ->
          IO.puts("[BingX] *WARN* Not found HTTP adapter; Loaded HTTP adapter stub")
          Adapter.Stub
      end

    quote do
      @http_adapter Application.compile_env(:bingx, :http_adapter, unquote(default))
    end
  end
end
