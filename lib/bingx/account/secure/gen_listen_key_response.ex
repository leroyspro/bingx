defmodule BingX.Account.Secure.GenListenKeyResponse do

  defstruct [:listen_key]

  def new(data), do: %__MODULE__{listen_key: Map.get(data, "listenKey")}
end
