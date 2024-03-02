defmodule BingX.Socket.Helpers do
  def validate_params(params) do
    %{
      url: validate_param(params, :url),
      consumer: validate_param(params, :consumer)
    }
  end

  def validate_param(%{consumer: x}, :consumer) when is_pid(x), do: x

  def validate_param(_params, :consumer) do
    raise ArgumentError, "expected :consumer param to be given and type of pid"
  end

  def validate_param(%{url: x}, :url) when is_binary(x), do: x

  def validate_param(_params, :url) do
    raise ArgumentError, "expected :url param to be given and type of binary"
  end
end
