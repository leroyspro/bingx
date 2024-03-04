defmodule BingX.Swap.Account.UpdatesSocket do
  @moduledoc """
  This module provides interface to build generic service consuming swap account update events.
  """

  alias BingX.HTTP.Request.QueryParams
  alias BingX.Socket

  @url "wss://open-api-swap.bingx.com/swap-market"

  defmacro __using__(_opts \\ []) do
    quote do
      use BingX.Socket.Base

      def handle_event(%{"e" => "ACCOUNT_CONFIG_UPDATE"} = event, state) do
        handle_update({:config, event}, state)
      end

      def handle_event(%{"e" => "WITHDRAW"} = event, state) do
        handle_update({:withdraw, event}, state)
      end

      def handle_event(%{"e" => "DEPOSIT"} = event, state) do
        handle_update({:deposit, event}, state)
      end

      def handle_event(%{"e" => "ORDER"} = event, state) do
        handle_update({:order, event}, state)
      end

      def handle_event(event, state) do
        require Logger
        Logger.error "Got unknown event: #{inspect(event)}"

        {:ok, state}
      end

      def handle_update(event, state) do
        require Logger
        Logger.debug "Skipping unprocessed event: #{inspect(event)}"

        {:ok, state}
      end

      defoverridable handle_event: 2,
                     handle_update: 2
    end
  end

  def start_link(params, module, state) do
    %{listen_key: listen_key} = validate_params(params)

    url = QueryParams.append_listen_key(@url, listen_key)

    {:ok, _pid} = Socket.start_link(url, module, state)
  end

  # Helpers
  # =======

  defp validate_params(params) do
    %{listen_key: validate_param(params, :listen_key)}
  end

  defp validate_param(%{listen_key: x}, :listen_key) when is_binary(x), do: x

  defp validate_param(_params, :listen_key) do
    raise ArgumentError, "expected :listen_key param to be given and type of binary"
  end
end
