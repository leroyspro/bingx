defmodule BingX.Helpers.Response do
  def extract_payload(response, keys \\ [])

  def extract_payload(%{"code" => 0, "data" => _payload} = response, key)
      when is_binary(key) or is_atom(key) do
    extract_payload(response, [key])
  end

  def extract_payload(%{"code" => 0, "data" => payload} = data, keys) when is_list(keys) do
    case get_in(payload, keys) do
      nil ->
        {:error, "unexpected response"}

      param ->
        {:ok, param}
    end
  end

  def extract_payload(%{"code" => code, "msg" => ""}, _keys) do
    {:exception, "exception without message, code: #{code}"}
  end

  def extract_payload(%{"code" => code, "msg" => message}, _keys) do
    {:exception, "exception: #{message}, code: #{code}"}
  end
end
