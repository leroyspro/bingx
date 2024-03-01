defmodule BingX.WebSocket do
  use WebSockex
  require Logger

  alias :zlib, as: Zlib

  def subscribe(pid, channel) when is_pid(pid) and is_binary(channel) do
    WebSockex.send_frame(pid, {:text, channel})
  end

  def start_link(url) do
    WebSockex.start_link(url, __MODULE__, :state)
  end

  def handle_connect(_conn, state) do
    Logger.debug "WebSocket established connection."

    {:ok, state}
  end

  def handle_frame({:binary, frame}, state) do
    {ms, data} = :timer.tc(fn -> Zlib.gunzip(frame) end)

    Logger.debug("Decoded frame in #{ms}μs")

    case data do
      "Ping" -> 
        {:reply, {:text, "Pong"}, state}

      message -> 
        Logger.debug("Socket update: #{inspect(message)}")

        {:ok, state}
    end
  end

  def handle_disconnect(details, state) do
    Logger.error "WebSocket disconnected, details: #{inspect(details)}"

    {:ok, state}
  end
end
