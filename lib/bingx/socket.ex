defmodule BingX.Socket do
  alias BingX.Socket.Helpers

  @type consumer :: pid()

  @callback start_link(args :: %{url: binary, consumer: consumer}) :: {:ok, pid} | {:error, term}

  use WebSockex
  require Logger

  alias :zlib, as: Zlib

  # Interface
  # =========

  def subscribe(pid, channel) when is_pid(pid) and is_binary(channel) do
    WebSockex.send_frame(pid, {:text, channel})
  end

  def start_link(params) do
    %{url: url, consumer: consumer} = Helpers.validate_params(params)

    state = %{consumer: consumer}

    WebSockex.start_link(url, __MODULE__, state)
  end

  # Implementation
  # ==============

  @impl WebSockex
  def handle_connect(_conn, state) do
    Logger.debug "Socket established connection with BingX"

    {:ok, state}
  end

  @impl WebSockex
  def handle_disconnect(details, state) do
    Logger.error "Socket disconnected from BingX, details: #{inspect(details)}"

    {:ok, state}
  end

  @impl WebSockex
  def handle_frame({:binary, frame}, state) do
    data = Zlib.gunzip(frame)

    case data do
      "Ping" ->
        {:reply, {:text, "Pong"}, state}

      data ->
        send_event(data, state.consumer)

        {:ok, state}
    end
  end

  @impl WebSockex
  def handle_frame(_data, state) do
    Logger.warning "Got unknown frame message"
    {:ok, state}
  end

  @impl WebSockex
  def handle_cast(message, state) do
    Logger.warning "Got unknown cast message: #{inspect(message)}"
    {:ok, state}
  end

  @impl WebSockex
  def handle_info(message, state) do
    Logger.warning "Got unknown info message: #{inspect(message)}"
    {:ok, state}
  end

  defp send_event(data, consumer) do
    event = Jason.decode!(data)
    Process.send(consumer, {:bingx_event, event}, [])
  end
end
