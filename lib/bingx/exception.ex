defmodule BingX.Exception do
  @doc """
  This module provides interface over the `Exception` struct which is used as a wrapper for exceptions responsed by BingX API.
  """

  alias __MODULE__
  defexception [:message, :code]

  @doc """
  Creates a `BingX.Exception` structure with the specified code and message. 
  The BingX API sometimes returns empty strings instead of descriptive messages, 
  so if an empty string is passed for `message`, the value will be set to default.
  """
  @spec new(code :: any(), message :: any()) :: %Exception{
          __exception__: true,
          code: any(),
          message: any()
        }
  def new(code, "") do
    %__MODULE__{message: "No error description message provided", code: code}
  end

  def new(code, message) do
    %__MODULE__{message: message, code: code}
  end
end
