defmodule BingX.Swap.Market.PriceSocket do
  alias BingX.Socket

  @url "wss://open-api-swap.bingx.com/swap-market"

  def start_link(params, module, state) do
    %{symbol: symbol, type: type} = validate_params(params)

    {:ok, pid} = Socket.start_link(@url, module, state)

    channel = Jason.encode!(%{
      "id" => "24dd0e35-56a4-4f7a-af8a-394c7060909c",
      "reqType" => "sub",
      "dataType" => "#{symbol}@#{type}Price"
    })

    Socket.subscribe(pid, channel)

    {:ok, pid}
  end

  # Helpers
  # =======

  defp validate_params(params) do
    %{
      symbol: validate_param(params, :symbol), 
      type: validate_param(params, :type)
    }
  end

  defp validate_param(%{symbol: x}, :symbol) when is_binary(x), do: x

  defp validate_param(_params, :symbol) do
    raise ArgumentError, "expected :symbol param to be given and type of binary"
  end

  defp validate_param(%{type: x}, :type) when is_binary(x) or is_atom(x), do: x

  defp validate_param(_params, :type) do
    raise ArgumentError, "expected :type param to be given and type one of binary or atom"
  end
end
