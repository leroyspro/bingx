defmodule BingX.API.Account do
  use HTTPoison.Base

  alias BingX.API.Helpers.{Headers, QueryParams}
  alias BingX.API.Account.BalanceResponse
  alias BingX.API.Exception

  @endpoint Application.compile_env!(:bingx, :endpoint)

  @impl true
  def process_request_url(url), do: @endpoint <> url

  @spec get_balance(String.t(), String.t()) :: {:ok, Map} | {:error, term()}
  def get_balance(api_key, secret_key)
      when is_binary(api_key) and is_binary(secret_key) do
    with {:ok, %{body: body}} <- do_get_balance(api_key, secret_key) do
      {:ok, data} = Jason.decode(body, keys: :strings)

      case data do
        %{"code" => 0, "data" => %{ "balance" => payload }} ->
          {:ok, BalanceResponse.new(payload)}

        %{"code" => code, "msg" => message} ->
          {:error, Exception.new(%{ message: message, code: code })}
      end
    end
  end

  defp do_get_balance(api_key, secret_key) do
    headers = Headers.append_api_key(api_key)

    params =
      Map.new()
      |> QueryParams.append_timestamp()
      |> QueryParams.append_receive_window()
      |> QueryParams.sign(secret_key)

    __MODULE__.get("/openApi/swap/v2/user/balance", headers, params: params)
  end
end
