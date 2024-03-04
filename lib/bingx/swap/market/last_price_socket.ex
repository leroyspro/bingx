defmodule BingX.Swap.Market.LastPriceSocket do
  use BingX.Swap.Market.PriceSocket, type: :last

  def handle_event(event, state) do
    Logger.info "Got Last Price BingX event: #{inspect(event)}"
    {:ok, state}
  end
end
