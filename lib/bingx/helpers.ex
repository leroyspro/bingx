defmodule BingX.Helpers do
  @spec timestamp() :: integer()
  def timestamp, do: :os.system_time(:millisecond)
end
