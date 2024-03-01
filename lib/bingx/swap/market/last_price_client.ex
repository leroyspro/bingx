defmodule BingX.Swap.Market.LastPriceClient do
  alias BingX.WebSocket

  @url "wss://open-api-swap.bingx.com/swap-market"

  def start_link(symbol) do
    {:ok, pid} = WebSocket.start_link(@url)

    channel = Jason.encode!(%{
      "id" => "24dd0e35-56a4-4f7a-af8a-394c7060909c",
      "reqType" => "sub",
      "dataType" => "#{symbol}@lastPrice"
    })

    WebSocket.subscribe(pid, channel)

    {:ok, pid}
  end
end
