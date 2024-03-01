defmodule BingX.HTTP.Request.QueryParams do
  import BingX.Helpers
  alias BingX.Helpers

  alias :crypto, as: Crypto

  def append_receive_window(%{} = params, value \\ 5000) do
    Map.merge(params, %{"recvWindow" => value})
  end

  def append_timestamp(%{} = params) do
    Map.merge(params, %{"timestamp" => timestamp()})
  end

  def append_signature(%{} = params, secret_key) do
    signature =
      params
      |> Enum.map(fn
        {k, v} when is_list(v) -> k <> "=" <> Helpers.to_string(v)
        {k, v} when is_binary(v) -> k <> "=" <> v
        {k, v} -> k <> "=" <> inspect(v)
      end)
      |> Enum.join("&")
      |> signature(secret_key)

    Map.merge(params, %{"signature" => signature})
  end

  defp signature(raw, key) when is_binary(raw) and is_binary(key) do
    Crypto.mac(:hmac, :sha256, key, raw)
    |> Base.encode16(case: :lower)
  end
end
