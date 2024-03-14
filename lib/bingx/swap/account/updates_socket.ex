defmodule BingX.Swap.Account.UpdatesSocket do
  @moduledoc """
  This module provides interface to build generic service consuming swap account update events.

  BingX last price socket API: https://bingx-api.github.io/docs/#/en-us/swapV2/socket/account.html#Account%20balance%20and%20position%20update%20push
  """

  alias BingX.HTTP.Request.QueryParams
  alias BingX.Socket
  alias BingX.Swap.Account.{BalanceUpdateEvent, OrderTradeEvent, ConfigUpdateEvent}

  @url "wss://open-api-swap.bingx.com/swap-market"

  @callback handle_event(type :: :config, event :: %ConfigUpdateEvent{}, state :: any()) :: {:ok, any()} | {:close, any()}
  @callback handle_event(type :: :balance, event :: %BalanceUpdateEvent{}, state :: any()) :: {:ok, any()} | {:close, any()}
  @callback handle_event(type :: :order, event :: %OrderTradeEvent{}, state :: any()) :: {:ok, any()} | {:close, any()}

  defmacro __using__(opts \\ []) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @behaviour BingX.Socket
      @behaviour BingX.Swap.Account.UpdatesSocket

      @doc false
      def child_spec(arg) do
        default = %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [arg]}
        }

        Supervisor.child_spec(default, unquote(Macro.escape(opts)))
      end

      @impl true
      def handle_event(%{"e" => "ACCOUNT_CONFIG_UPDATE"} = event, state) do
        handle_event(:config, ConfigUpdateEvent.new(event), state)
      end

      @impl true
      def handle_event(%{"e" => "ORDER_TRADE_UPDATE"} = event, state) do
        handle_event(:order, OrderTradeEvent.new(event), state)
      end

      @impl true
      def handle_event(%{"e" => "ACCOUNT_UPDATE"} = event, state) do
        handle_event(:balance, BalanceUpdateEvent.new(event), state)
      end

      @impl true
      def handle_event(event, state) do
        require Logger
        Logger.info("Got unknown event: #{inspect(event)}")

        {:ok, state}
      end

      @impl true
      def handle_event(type, event, state) do
        raise "handle_event/3 not implemented"
      end

      defoverridable child_spec: 1, handle_event: 2, handle_event: 3
    end
  end

  def start_link(listen_key, module, state, options \\ []) do
    url = QueryParams.append_listen_key(@url, listen_key)

    Socket.start_link(url, module, state, options)
  end

  def start(listen_key, module, state, options \\ []) do
    url = QueryParams.append_listen_key(@url, listen_key)

    Socket.start(url, module, state, options)
  end
end
