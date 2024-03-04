defmodule BingX.Socket.Base do
  alias :zlib, as: Zlib
  alias __MODULE__

  @type new_state :: term()

  @callback handle_event(event :: map(), state :: term()) :: {:ok, new_state} | {:close, new_state}

  defmacro __using__(_opts \\ []) do
    quote location: :keep do
      use WebSockex

      @behaviour Base

      # Implementation
      # ==============

      @impl WebSockex
      def handle_connect(conn, state) do
        {:ok, state}
      end

      @impl WebSockex
      def handle_disconnect(details, state) do
        require Logger
        Logger.error "Socket disconnected from BingX, details: #{inspect(details)}"

        {:reconnect, state}
      end

      @impl WebSockex
      def handle_frame({:binary, frame}, state) do
        try do
          data = Zlib.gunzip(frame)

          case data do
            "Ping" ->
              {:reply, {:text, "Pong"}, state}

            data ->
              data
              |> Jason.decode!()
              |> handle_event(state)
          end
        rescue
          err ->
            require Logger

            Logger.error """
              Could not process inbound BingX event message due to raised error: #{inspect(err)}.
              It is unusual and unexpected error which MUST NOT persist. 
            """

            {:ok, state}
        end
      end

      @impl Base
      def handle_event(data, state) do
        raise "handle_event/2 not implemented"
      end

      @impl WebSockex
      def handle_frame(data, state) do
        require Logger
        Logger.warning "Got unknown frame message: #{inspect(data)}"
        {:ok, state}
      end

      @impl WebSockex
      def handle_cast(message, state) do
        require Logger
        Logger.warning "Got unknown cast message: #{inspect(message)}"
        {:ok, state}
      end

      @impl WebSockex
      def handle_info(message, state) do
        require Logger
        Logger.warning "Got unknown info message: #{inspect(message)}"
        {:ok, state}
      end

      defoverridable handle_cast: 2,
                     handle_info: 2,
                     handle_event: 2
    end
  end
end
