defmodule BingX.Swap.Market.LastPriceSocket do
  alias BingX.Swap.Market.PriceSocket

  defmacro __using__(_opts \\ []) do
    quote do
      use BingX.Socket.Base

      def handle_event(event, state) do
        require Logger
        Logger.info "Got Last Price BingX event: #{inspect(event)}"
        {:ok, state}
      end

      defoverridable handle_event: 2
    end
  end

  def start_link(params, module, state) do 
    params = Map.merge(params, %{type: :last})

    PriceSocket.start_link(params, module, state)
  end
end
