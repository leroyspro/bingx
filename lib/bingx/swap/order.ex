defmodule BingX.Swap.Order do
  @moduledoc """
  This module defines the swap order sturct using in the swap domain.
  """

  alias __MODULE__

  import BingX.Swap.Order.Helpers

  @fields [
    :type,
    :order_id,
    :client_order_id,
    :symbol,
    :side,
    :position_side,
    :quantity,
    :price,
    :stop_price,
    :working_type
  ]

  defstruct @fields

  @type t() :: %Order{
          :type => type() | nil,
          :order_id => order_id() | nil,
          :client_order_id => client_order_id() | nil,
          :symbol => symbol() | nil,
          :side => side() | nil,
          :position_side => position_side() | nil,
          :quantity => quantity() | nil,
          :price => price() | nil,
          :stop_price => stop_price() | nil,
          :working_type => working_type() | nil
        }

  @type type() :: :trigger_market
  @type status() :: :placed | :triggered | :filled | :partially_filled | :canceled | :expired
  @type order_id() :: binary()
  @type client_order_id() :: binary()
  @type symbol() :: binary()
  @type side() :: :buy | :sell
  @type position_side() :: :long | :short | :both
  @type quantity() :: number()
  @type price() :: number()
  @type stop_price() :: number()
  @type working_type() :: :mark_price | :index_price | :contract_price

  @doc """
  Creates `BingX.Swap.Order` struct using the provided parameters.
  Note that it only performs validation for the specified values, leaving `nil` for the rest.
  """
  def new(params) when is_map(params) do
    with {:ok, params} <- validate_params(params) do
      {:ok, struct(Order, params)}
    end
  end

  @doc """
  The same as new/1 but returns struct and raises error instead of tuples.
  """
  def new!(params) when is_map(params) do
    case validate_params(params) do
      {:ok, params} -> struct(Order, params)
      {:error, reason} -> raise ArgumentError, reason
    end
  end

  defp validate_params(params) do
    Enum.reduce_while(params, {:ok, %{}}, &validate_param/2)
  end

  defp validate_param({k, v} = kv, {:ok, acc}) when k in @fields do
    case validate(k, v) do
      {:ok, _} -> {:cont, {:ok, merge_kv(acc, kv)}}
      {:error, reason} -> {:halt, {:error, reason}}
    end
  end

  defp validate_param(_, acc), do: {:cont, acc}

  defp merge_kv(acc, {_, _} = kv) do
    Map.merge(acc, Map.new([kv]))
  end
end
