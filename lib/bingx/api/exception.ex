defmodule BingX.API.Exception do
  alias __MODULE__
  defexception [:message, :code]

  @spec new(%{:code => any(), :message => any()}) :: %Exception{
          __exception__: true,
          code: any(),
          message: any()
        }
  def new(%{message: message, code: code}) do
    %__MODULE__{message: message, code: code}
  end
end
