defmodule BingX.Swap.Market.PriceSocket do
  @moduledoc ~S"""

    defmodule BingX.Swap.Market.PriceSource do
      use BingX.Swap.Market.PriceSocket

      require Logger

      alias BingX.Swap.Market.PriceSocket

      def start_link(_args \\ []) do
        PriceSocket.start_link(__MODULE__, :state)
      end

      @impl true
      def handle_connect(state) do
        PriceSocket.subscribe(%{symbol: "BTC-USDT", type: :last})
        {:ok, state}
      end

      @impl true
      def handle_event(type, event, state) do
        Logger.info(%{ type: type, event: event, state: state })
        {:ok, state}
      end
    end
  """

  alias BingX.Socket
  alias BingX.Swap.Market.PriceUpdateEvent

  @origin Application.compile_env(:bingx, :swap_origin, "wss://open-api-swap.bingx.com/swap-market")

  @callback handle_event(type :: :price, event :: PriceUpdateEvent.t(), state :: any()) :: {:ok, any()} | {:close, any()}

  @doc false
  defmacro __using__(opts \\ []) do
    quote location: :keep, bind_quoted: [opts: opts] do
      @behaviour BingX.Socket
      @behaviour BingX.Swap.Market.PriceSocket

      @doc false
      def child_spec(arg) do
        default = %{
          id: __MODULE__,
          start: {__MODULE__, :start_link, [arg]}
        }

        Supervisor.child_spec(default, unquote(Macro.escape(opts)))
      end

      @impl true
      def handle_event(event, state) do
        price = PriceUpdateEvent.new(event)
        handle_event(:price, price, state)
      end

      def handle_event(type, event, state) do
        raise "handle_event/3 not implemented"
      end

      defoverridable child_spec: 1,
                     handle_event: 2,
                     handle_event: 3
    end
  end

  def start_link(module, state, options \\ []) do
    Socket.start_link(@origin, module, state, options)
  end

  def start(module, state, options \\ []) do
    Socket.start(@origin, module, state, options)
  end

  def subscribe(pid \\ self(), params) do
    %{symbol: symbol, type: type} = params

    channel =
      %{
        "id" => "24dd0e35-56a4-4f7a-af8a-394c7060909c",
        "reqType" => "sub",
        "dataType" => "#{symbol}@#{type}Price"
      }
      |> Jason.encode!()

    BingX.Socket.send(pid, channel)
  end
end
