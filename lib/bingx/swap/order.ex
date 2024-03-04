defmodule BingX.Swap.Order do
  @moduledoc """
  This module provides definition for the swap order sturct using in the swap domain.
  """

  alias __MODULE__

  import BingX.Swap.Order.Helpers

  defstruct [
    :type,
    :order_id,
    :symbol,
    :side,
    :position_side,
    :price,
    :stop_price,
    :quantity,
    :client_order_id,
    :working_type
  ]

  @type t() :: %Order{
          :order_id => order_id() | nil,
          :symbol => symbol() | nil,
          :side => side() | nil,
          :position_side => position_side() | nil,
          :type => type() | nil,
          :price => price() | nil,
          :quantity => quantity() | nil,
          :stop_price => stop_price() | nil,
          :client_order_id => client_order_id() | nil,
          :working_type => working_type() | nil
        }

  @type symbol() :: binary()
  @type side() :: :buy | :sell
  @type position_side() :: :long | :short | :both
  @type type() :: :trigger_market
  @type price() :: number()
  @type quantity() :: number()
  @type stop_price() :: number()
  @type order_id() :: binary()
  @type client_order_id() :: binary()
  @type working_type() :: :mark_price | :index_price | :contract_price

  @doc """
  Creates `BingX.Swap.Order` struct using the provided parameters.
  Note that it only performs validation for the specified values, leaving `nil` for the rest.
  """
  @spec new(map()) :: Order.t()
  def new(params) when is_map(params) do
    params =
      params
      |> Enum.map(fn {k, v} -> {k, validate!(k, v)} end)
      |> Map.new()

    struct(Order, params)
  end
end
