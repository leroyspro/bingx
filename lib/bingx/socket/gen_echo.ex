defmodule BingX.Socket.GenEcho do
  use GenServer
  require Logger

  def start_link(_params \\ %{}) do
    GenServer.start_link(__MODULE__, :init)
  end

  @impl true
  def init(:init), do: {:ok, :state}

  @impl true
  def handle_info({:bingx_event, event}, state) do
    Logger.info "Handled new BingX event: #{inspect(event)}"
    {:noreply, state}
  end

  @impl true
  def handle_info(message, state) do
    Logger.warning "Got unknown info message: #{inspect(message)}"
    {:noreply, state}
  end

  @impl true
  def handle_cast(message, state) do
    Logger.warning "Got unknown cast message: #{inspect(message)}"
    {:noreply, state}
  end

  @impl true
  def handle_call(message, _from, state) do
    Logger.warning "Got unknown call message: #{inspect(message)}"
    {:reply, {:error, :badop}, state}
  end
end
