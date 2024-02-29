defmodule BingX.Response do
  alias BingX.Exception

  def extract_body(%HTTPoison.Response{body: body, status_code: 200}) do
    {:ok, body}
  end

  def extract_body(%HTTPoison.Response{body: _body, status_code: status_code}) do
    {:error, {:unexpected_status_code, status_code}}
  end

  def extract_content(raw_body) do
    with {:ok, data} <- Jason.decode(raw_body) do
      case data do
        %{"code" => 0, "data" => content} ->
          {:ok, content}

        %{"code" => code, "msg" => message} ->
          {:error, Exception.new(code, message)}
      end
    else
      {:error, _reason} ->
        {:error, {:bad_decode, raw_body}}
    end
  end
end
