defmodule BingX.Socket do
  @moduledoc """
  This module provides enhanced interface over WebSocket connection to hide implementation details.
  """
  use WebSockex

  require Logger

  alias :zlib, as: Zlib

  @type new_state :: term()
  @type message :: binary()

  @callback handle_connect(state :: term()) :: {:ok, new_state}
  @callback handle_disconnect(state :: term()) :: {:stop, new_state} | {:reconnect, new_state}
  @callback handle_event(event :: map(), state :: term()) :: {:ok, new_state} | {:disconnect, new_state}
  @callback handle_info(message :: any(), state :: term()) :: {:send, message, new_state} | {:ok, new_state} | {:disconnect, new_state}
  @callback handle_cast(message :: any(), state :: term()) :: {:send, message, new_state} | {:ok, new_state} | {:disconnect, new_state}
  @optional_callbacks handle_disconnect: 1, handle_connect: 1, handle_info: 2, handle_cast: 2

  # Interface
  # =========

  @doc """
  Starts a WebSocket process linked to the current process.
  """
  def start_link(url, module, state, options \\ []) do
    WebSockex.start_link(url, __MODULE__, {module, state}, options)
  end

  @doc """
  Starts a WebSocket process.
  """
  def start(url, module, state, options \\ []) do
    WebSockex.start(url, __MODULE__, {module, state}, options)
  end

  @doc """
  Sends a message to the process to the specified PID.
  """
  def send(pid, message) do
    WebSockex.cast(pid, {:"$bingx_send", message})
  end

  @doc """
  Sends an asynchronous message.
  """
  def cast(pid, message) do
    WebSockex.cast(pid, message)
  end

  # Implementation
  # ==============

  @impl WebSockex
  def handle_connect(_conn, {module, state}) do
    if function_exported?(module, :handle_connect, 1) do
      {:ok, new_state} = apply(module, :handle_connect, [state])
      {:ok, {module, new_state}}
    else
      {:ok, {module, state}}
    end
  end

  @impl WebSockex
  def handle_disconnect(_details, {module, state}) do
    if function_exported?(module, :handle_disconnect, 1) do
      case apply(module, :handle_disconnect, [state]) do
        {:reconnect, new_state} -> {:reconnect, {module, new_state}}
        {:stop, new_state} -> {:ok, {module, new_state}}
      end
    else
      {:reconnect, {module, state}}
    end
  end

  @impl WebSockex
  def handle_frame({:binary, frame}, {module, state}) do
    case Zlib.gunzip(frame) do
      "Ping" ->
        {:reply, {:text, "Pong"}, {module, state}}

      data ->
        handle_event_data(data, {module, state})
    end
  end

  @impl WebSockex
  def handle_frame(data, {module, state}) do
    Logger.warning("Got unknown frame message: #{inspect(data)}")
    {:ok, {module, state}}
  end

  @impl WebSockex
  def handle_cast({:"$bingx_send", message}, state) do
    {:reply, {:text, message}, state}
  end

  @impl WebSockex
  def handle_cast(message, {module, state}) do
    if function_exported?(module, :handle_cast, 2) do
      case apply(module, :handle_cast, [message, state]) do
        {:disconnect, new_state} ->
          {:close, {module, new_state}}

        {:ok, new_state} ->
          {:ok, {module, new_state}}

        {:send, message, new_state} ->
          {:reply, {:text, message}, {module, new_state}}
      end
    else
      Logger.warning("Got unknown cast message: #{inspect(message)}")
      {:ok, {module, state}}
    end
  end

  @impl WebSockex
  def handle_info(message, {module, state}) do
    if function_exported?(module, :handle_info, 2) do
      case apply(module, :handle_info, [message, state]) do
        {:disconnect, new_state} ->
          {:close, {module, new_state}}

        {:ok, new_state} ->
          {:ok, {module, new_state}}

        {:send, message, new_state} ->
          {:reply, {:text, message}, {module, new_state}}
      end
    else
      Logger.warning("Got unknown info message: #{inspect(message)}")
      {:ok, {module, state}}
    end
  end

  # Helpers
  # =======

  defp handle_event_data(data, {module, state}) do
    case send_event_data(data, {module, state}) do
      {:ok, new_state} -> {:ok, {module, new_state}}
      {:disconnect, new_state} -> {:close, {module, new_state}}
    end
  end

  defp send_event_data(data, {module, state}) do
    event = Jason.decode!(data)
    apply(module, :handle_event, [event, state])
  end
end
