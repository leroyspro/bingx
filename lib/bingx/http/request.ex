defmodule BingX.HTTP.Request do
  alias BingX.HTTP.Request.{QueryParams, Headers}

  @origin Application.compile_env!(:bingx, :origin)

  defdelegate auth_headers(headers \\ %{}, api_key), to: Headers, as: :append_api_key

  def build_url(path \\ "/", params \\ %{}, options \\ []) do
    url = @origin <> path

    query =
      params
      |> QueryParams.append_timestamp()
      |> QueryParams.append_receive_window()
      |> maybe_append_signature(options)
      |> URI.encode_query()

    url <> "?" <> query
  end

  defp maybe_append_signature(params, options) do
    case Keyword.get(options, :sign) do
      nil -> params
      secret_key -> QueryParams.append_signature(params, secret_key)
    end
  end
end
