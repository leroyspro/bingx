defmodule BingX.Request do
  alias BingX.Request.{QueryParams, Headers}

  @origin Application.compile_env!(:bingx, :origin)

  defdelegate auth_headers(headers \\ %{}, api_key), to: Headers, as: :append_api_key

  def build_url(path, params \\ %{}, options) do
    url = @origin <> path

    query =
      params
      |> QueryParams.append_timestamp()
      |> QueryParams.append_receive_window()
      |> maybe_sign(options)
      |> URI.encode_query()

    url <> "?" <> query
  end

  defp maybe_sign(params, options) do
    case Keyword.get(options, :sign, :default) do
      :defatul ->
        params

      secret_key ->
        QueryParams.append_signature(params, secret_key)
    end
  end
end
