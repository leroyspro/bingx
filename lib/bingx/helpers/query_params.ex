defmodule BingX.Helpers.QueryParams do
  import BingX.Helpers

  alias :crypto, as: Crypto

  def append_receive_window(%{} = params, value \\ 5000) do
    Map.merge(params, %{"recvWindow" => value})
  end

  def append_timestamp(%{} = params, value \\ timestamp()) do
    Map.merge(params, %{"timestamp" => value})
  end

  def sign(%{} = params, secret_key) do
    signature =
      params
      |> URI.encode_query()
      |> signature(secret_key)

    Map.merge(params, %{"signature" => signature})
  end

  defp signature(raw, key) when is_binary(raw) and is_binary(key) do
    Crypto.mac(:hmac, :sha256, key, raw)
    |> Base.encode16(case: :lower)
  end
end
