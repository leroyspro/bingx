defmodule BingX.Swap.Account.UpdatesSocket do
  @moduledoc """
  This module provides interface to build generic service consuming swap account update events.

  BingX last price socket API: https://bingx-api.github.io/docs/#/en-us/swapV2/socket/account.html#Account%20balance%20and%20position%20update%20push

    defmodule BingX.Swap.Account.UpdatesSource do
      use BingX.Swap.Account.UpdatesSocket

      require Logger

      alias BingX.Swap.Account.UpdatesSocket
      alias BingX.User.Auth

      def start_link do
        api_key = System.fetch_env!("API_KEY")
        {:ok, %{listen_key: listen_key}} = Auth.generate_listen_key(api_key)

        UpdatesSocket.start_link(listen_key, __MODULE__, :state)
      end

      def handle_event(type, event, state) do
        Logger.info(%{ type: type, event: event, state: state })

        {:ok, state}
      end
    end
  """

  alias BingX.HTTP.Request.QueryParams
  alias BingX.Socket
  alias BingX.Swap.Account.{AccountUpdateEvent, OrderTradeEvent, ConfigUpdateEvent}

  @origin Application.compile_env(:bingx, :swap_origin, "wss://open-api-swap.bingx.com/swap-market")

  @callback handle_event(type :: :config, event :: %ConfigUpdateEvent{}, state :: any()) :: {:ok, any()} | {:close, any()}
  @callback handle_event(type :: :account, event :: %AccountUpdateEvent{}, state :: any()) :: {:ok, any()} | {:close, any()}
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
        handle_event(:account, AccountUpdateEvent.new(event), state)
      end

      @impl true
      def handle_event(type, event, state) do
        raise "handle_event/3 not implemented"
      end

      defoverridable child_spec: 1, handle_event: 2, handle_event: 3
    end
  end

  def start_link(listen_key, module, state, options \\ []) do
    url = prepare_url(listen_key)
    Socket.start_link(url, module, state, options)
  end

  def start(listen_key, module, state, options \\ []) do
    url = prepare_url(listen_key)
    Socket.start(url, module, state, options)
  end

  defp prepare_url(listen_key) do
    @origin <> "?" <> QueryParams.listen_key_query(listen_key)
  end
end
