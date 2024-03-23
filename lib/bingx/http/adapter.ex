defmodule BingX.HTTP.Adapter do
  @moduledoc """
  This module provides behavior for the HTTP adapter which is used to perform requests.
  """

  alias BingX.HTTP.{Response, Error}

  @type method :: :get | :post | :put | :delete
  @type url :: binary()
  @type body :: binary()
  @type headers :: Enumerable.t()

  @callback request(method :: method(), url :: url(), body :: binary(), headers :: headers()) ::
              {:ok, %Response{}} | {:error, :http_error, %Error{}}
end
