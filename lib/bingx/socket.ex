defmodule BingX.Socket do
  defdelegate start_link(url, module, state, opts \\ []), to: WebSockex, as: :start_link

  def subscribe(pid, channel) when is_pid(pid) and is_binary(channel) do
    WebSockex.send_frame(pid, {:text, channel})
  end
end
