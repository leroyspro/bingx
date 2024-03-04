defmodule BingX.Swap.Market.PriceSocket do
  defmacro __using__(opts) do
    type = Keyword.get(opts, :type) || raise "expected :type param to be given"

    quote do
      use BingX.Socket.Base

      require Logger

      alias BingX.Socket
        
      @url "wss://open-api-swap.bingx.com/swap-market"

      def start_link(params) do
        %{symbol: symbol} = validate_params(params)

        {:ok, pid} = Socket.start_link(@url, __MODULE__, :state)

        channel = Jason.encode!(%{
          "id" => "24dd0e35-56a4-4f7a-af8a-394c7060909c",
          "reqType" => "sub",
          "dataType" => "#{symbol}@#{unquote(type)}Price"
        })

        Socket.subscribe(pid, channel)

        {:ok, pid}
      end

      def handle_event(event, state) do
        raise "handle_event/2 not implemented"
      end

      # Helpers
      # =======

      defp validate_params(params) do
        %{symbol: validate_param(params, :symbol)}
      end

      defp validate_param(%{symbol: x}, :symbol) when is_binary(x), do: x

      defp validate_param(_params, :symbol) do
        raise ArgumentError, "expected :symbol param to be given and type of binary"
      end
    end
  end
end
