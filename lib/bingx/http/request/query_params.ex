defmodule BingX.HTTP.Request.QueryParams do
  @moduledoc """
  This module provides universal utilities for working with BingX API request query params.
  """

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
      |> Enum.map_join("&", fn
        {k, v} when is_binary(v) -> k <> "=" <> v
        {k, v} -> k <> "=" <> Helpers.to_string(v)
      end)
      |> signature(secret_key)

    Map.merge(params, %{"signature" => signature})
  end

  def listen_key_query(listen_key) when is_binary(listen_key) do
    "listenKey=" <> listen_key
  end

  defp signature(raw, key) when is_binary(raw) and is_binary(key) do
    Crypto.mac(:hmac, :sha256, key, raw)
    |> Base.encode16(case: :lower)
  end
end
