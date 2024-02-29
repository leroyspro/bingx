defmodule BingX.Response do
  alias BingX.Exception

  def validate(%HTTPoison.Response{status_code: status_code}, only: exp_status_code) 
    when status_code === exp_status_code do
    :ok
  end

  def validate(%HTTPoison.Response{status_code: status_code}) do
    {:error, {:unexpected_status_code, status_code}}
  end

  def extract_body(%HTTPoison.Response{body: body}) do
    {:ok, body}
  end

  def decode_body(raw_body) do
    case Jason.decode(raw_body) do
      {:ok, data} -> {:ok, data}
      {:error, _reason} -> {:error, {:bad_decode, raw_body}}
    end
  end

  def extract_content(data) when is_map(data) do
    case data do
      %{"code" => 0, "data" => content} ->
        {:ok, content}

      %{"code" => code, "msg" => message} ->
        {:error, Exception.new(code, message)}
    end
  end
end
