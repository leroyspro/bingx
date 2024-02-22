defmodule BingX.API.Trade do
  use HTTPoison.Base

  alias BingX.Order
  alias BingX.API.Helpers.{QueryParams, Headers}
  alias BingX.API.Trade.{Contract, PlaceOrderResponse, CancelAllOrdersResponse}
  alias BingX.API.Exception

  @endpoint Application.compile_env!(:bingx, :endpoint)

  @api_v2 "/openApi/swap/v2"
  @scope "/trade"
  @url_base @api_v2 <> @scope

  @impl true
  def process_request_url(url), do: @endpoint <> url

  def cancel_all_orders(api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with {:ok, %{body: body}} <- do_cancel_all_orders(api_key, secret_key) do
      {:ok, data} = Jason.decode(body, keys: :strings)

      case data do
        %{"code" => 0, "data" => payload} ->
          {:ok, CancelAllOrdersResponse.new(payload)}

        %{"code" => code, "msg" => message} ->
          {:error, Exception.new(%{message: message, code: code})}
      end
    end
  end

  defp do_cancel_all_orders(api_key, secret_key) do
    headers = Headers.append_api_key(api_key)

    params =
      %{"symbol" => "BTC-USDT"}
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.sign(secret_key)

    __MODULE__.delete(@url_base <> "/allOpenOrders", headers, params: params)
  end

  def place_order(%Order{} = order, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with {:ok, %{body: body}} <- do_place_order(order, api_key, secret_key) do
      {:ok, data} = Jason.decode(body, keys: :strings)

      case data do
        %{"code" => 0, "data" => %{"order" => payload}} ->
          {:ok, PlaceOrderResponse.new(payload)}

        %{"code" => code, "msg" => message} ->
          {:error, Exception.new(%{message: message, code: code})}
      end
    end
  end

  defp do_place_order(order, api_key, secret_key) do
    headers = Headers.append_api_key(api_key)

    params =
      order
      |> Contract.from_order()
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.sign(secret_key)

    __MODULE__.post(@url_base <> "/order", "", headers, params: params)
  end
end
