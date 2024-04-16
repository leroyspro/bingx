defmodule BingX.HTTP.Adapter.Loader do
  alias BingX.HTTP.Adapter

  @doc false
  defmacro load() do
    default = 
      if Code.ensure_loaded?(HTTPoison) do 
        Adapter.HTTPoison 
      else 
        Adapter.Stub
      end

    quote do
      @http_adapter Application.compile_env(:bingx, :http_adapter, unquote(default))
    end
  end
end
