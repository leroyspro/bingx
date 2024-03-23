defmodule BingX.Account.GenerateListenKeyResponse do
  @moduledoc false

  defstruct [:listen_key]

  def new(data), do: %__MODULE__{listen_key: Map.get(data, "listenKey") || ""}
end
