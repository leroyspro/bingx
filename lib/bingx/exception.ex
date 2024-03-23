defmodule BingX.Exception do
  @moduledoc """
  This module defines `Exception` which is used to specify BingX API related errors.
  """

  defexception [:message, :code]

  @impl Exception
  def message(exception) do
    exception.message
  end

  @impl Exception
  def exception(message) when is_binary(message) do
    exception(message: message)
  end

  @impl Exception
  def exception(args) when is_list(args) do
    struct!(__MODULE__, args)
  end
end
