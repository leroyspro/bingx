defmodule BingX.Socket do
  @moduledoc """
  This module provides enhanced interface over WebSocket connection to hide implementation details.
  """

  @doc """
  Starts a WebSocket process linked to the current process.
  """
  defdelegate start_link(url, module, state), to: WebSockex, as: :start_link

  @doc """
  Sends a message (channel) to the process to the specified PID to subscribe to events.
  """
  def subscribe(pid, channel) when is_pid(pid) and is_binary(channel) do
    WebSockex.send_frame(pid, {:text, channel})
  end
end
