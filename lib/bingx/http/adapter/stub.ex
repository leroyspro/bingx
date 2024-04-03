defmodule BingX.HTTP.Adapter.Stub do
  @behaviour BingX.HTTP.Adapter

  @impl true
  def request(_method, _url, _body, _headers, _options \\ []) do
    raise """
    Improperly configured HTTP adapter!

    The request cannot be performed due to the absence of an HTTP adapter, so stub is used.

    Install HTTPoison as the project dependency to use the standard adapter.

    Or, you can use your own implementation of the custom adapter.
    Refer to the documentation for the guide.
    """
  end
end
