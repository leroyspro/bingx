defmodule BingX.HTTP.Request.Headers do
  @moduledoc """
  This module provides universal utilities for working with BingX API request headers.
  """

  def append_api_key(%{} = headers, key) do
    Map.merge(headers, %{"X-BX-APIKEY" => key})
  end
end
