defmodule BingX do
  @moduledoc ~S"""
  BingX API Client for Elixir

  ## Overview

  This BingX library provides HTTP and WebSocket API clients with various functionalities:
  - Swap (perpetual futures): to manage pending orders, including placement, deletion, retrieval, and viewing order history.
  - Account and Security: facilitating the generation and extension of API listen keys.

  Additionally, it offers enhanced WebSocket API clients, including:
  - Socket for swap price: for creating custom clients that consume either Mark or Last price updates.
  - Socket for swap account: for creating custom clients that consume balance, configuration, and order trade updates.

  The library's primary focus lies in standardizing BingX API data, emphasizing reliability and flexibility.

  ### Standardization

  Standardization provides convenient abstractions for making requests and interpreting outgoing data. Notably, it defines distinct structures for HTTP responses and socket events, ensuring uniformity in data format.

  For example, when placing an order using a predefined struct, users can anticipate receiving a structured and familiar response:

      %{
        side: :buy,
        position_side: :long,
        price: 30_000,
        quantity: 0.0001,
        symbol: "BTC-USDT",
        stop_price: 30_000,
      }
      |> BingX.Swap.Order.TriggerMarket.new!()
      |> BingX.Swap.Trade.place_order(api_key, secret_key)

  Output:

      {:ok,
        %BingX.Swap.PlaceOrderResponse{
          symbol: "BTC-USDT",
          side: :buy,
          position_side: :long,
          price: 30000.0,
          stop_price: 30000.0,
          working_type: :mark_price,
          quantity: 0.0001,
          type: :trigger_market,
          order_id: "1771329103850598400",
          client_order_id: nil,
          stop_loss: %{},
          take_profit: %{},
          time_in_force: "GTC",
          reduce_only?: false,
          price_rate: 0.0,
          activation_price: 0.0,
          close_position?: nil
        }}

  ### Reliability

  Reliability ensures tolerance to discrepancies in contract data from the exchange. This means that minor updates or errors on the BingX side or due to contract API updates won't cause errors. Unexpected field values default to nil, and value interpretation is strict.

  The library places a strong emphasis on testing to ensure reliability.

  ### Flexibility

  Flexibility allows the implementation of custom HTTP modules, HTTP adapters, and Socket clients (built on top of BingX.Socket) using internal utilities. Refer to existing implementations for ease of implementation.

  You can implement a custom HTTP adapter which is used to perform HTTP requests. Refer to an existing `BingX.HTTP.Adapter.HTTPoison` [implementation](https://github.com/leroyspro/bingx/blob/main/lib/bingx/http/adapter/httpoison.ex) for example.

  Specify which HTTP adapter should BingX library use in the preferred configuration file (e.g. config/config.exs):

      config :bingx, http_adapter: HTTPAdapter

  It's crucial to be prepared for minor and even major updates in BingX API, so the library provides common abstractions and separates components for adaptability.
  """
end
