defmodule BingX.Swap.Market.MarkPriceSocket do
  use BingX.Swap.Market.PriceSocket, type: :mark

  def handle_event(event, state) do
    Logger.info "Got Mark Price BingX event: #{inspect(event)}"
    {:ok, state}
  end
end
