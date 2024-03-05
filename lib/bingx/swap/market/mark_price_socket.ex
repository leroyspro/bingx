defmodule BingX.Swap.Market.MarkPriceSocket do
  @moduledoc """
  This module provides interface to build generic service consuming swap mark price update events from a specific market.

  BingX last price socket API: https://bingx-api.github.io/docs/#/en-us/swapV2/socket/market.html#Subscribe%20to%20latest%20mark%20price%20changes
  """

  alias BingX.Swap.Market.PriceSocket
  alias BingX.Swap.Market.PriceUpdateEvent

  defmacro __using__(_opts \\ []) do
    quote do
      use BingX.Socket.Base

      def handle_event(event, state) do
        event
        |> PriceUpdateEvent.new()
        |> handle_update(state)
      end

      def handle_update(price, state) do
        require Logger
        Logger.info "Got price update: #{inspect(price)}"

        {:ok, state}
      end

      defoverridable handle_event: 2,
                     handle_update: 2
    end
  end

  def start_link(params, module, state) do 
    params = Map.merge(params, %{type: :mark})

    PriceSocket.start_link(params, module, state)
  end
end
