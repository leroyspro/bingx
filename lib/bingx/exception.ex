defmodule BingX.Exception do
  alias __MODULE__
  defexception [:message, :code]

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
