defmodule BingX.Swap.Market.MarkPriceSocket do
  alias BingX.Swap.Market.PriceSocket

  @behaviour BingX.Socket

  def start_link(params) do
    PriceSocket.start_link(%{
      type: :mark, 
      symbol: Map.get(params, :symbol),
      consumer: Map.get(params, :consumer)
    })
  end
end
