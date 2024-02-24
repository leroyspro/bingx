defmodule BingX.API.Exception do
  alias __MODULE__
  defexception message: "No error description message", code: 1

  @spec new(code :: any(), message :: any()) :: %Exception{
          __exception__: true,
          code: any(),
          message: any()
        }
  def new(code, message) do
    %__MODULE__{message: message, code: code}
  end
end
