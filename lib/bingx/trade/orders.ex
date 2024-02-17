defmodule BingX.Trade.Orders do
  use HTTPoison.Base

  alias BingX.Helpers.{Response, QueryParams, Headers}
  alias BingX.Trade.Order

  @endpoint Application.compile_env(
              :bingx,
              :endpoint,
              "https://open-api.bingx.com"
            )

  @impl true
  def process_request_url(url), do: @endpoint <> url

  def cancel_all(api_key, secret_key) when is_binary(api_key) do
    with(
      {:ok, %{body: body}} <- do_cancel_all(api_key, secret_key),
      {:ok, response} <- Jason.decode(body, keys: :strings)
    ) do
      Response.extract_payload(response, "balance")
    end
  end

  defp do_cancel_all(api_key, secret_key) do
    headers = Headers.append_api_key(api_key)

    params =
      %{"symbol" => "BTC-USDT"}
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.sign(secret_key)

    __MODULE__.delete("/openApi/swap/v2/trade/allOpenOrders", headers, params: params)
  end

  def place(order, api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with(
      {:ok, order_params} <- Order.to_api_interface(order),
      {:ok, resp} <- do_place(order_params, api_key, secret_key),
      {:ok, response} <- Jason.decode(resp.body, keys: :strings)
    ) do
      Response.extract_payload(response, "order")
    end
  end

  defp do_place(order_params, api_key, secret_key) do
    headers = Headers.append_api_key(api_key)

    params =
      order_params
      |> QueryParams.append_receive_window()
      |> QueryParams.append_timestamp()
      |> QueryParams.sign(secret_key)

    __MODULE__.post("/openApi/swap/v2/trade/order", "", headers, params: params)
  end
end
