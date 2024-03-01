defmodule BingX.HTTP.Response do
  alias BingX.Exception

  defstruct [:status_code, :body, :headers, :request_url]
  
  def validate(_resp, options \\ [{:code, 200}])

  def validate(%__MODULE__{status_code: status_code} = resp, code: exp_status_code) do
    if status_code === exp_status_code do 
      :ok 
    else
      {:error, :response_error, resp}
    end
  end

  def extract_body(%__MODULE__{body: body}), do: {:ok, body}

  def decode_body(body) do
    case Jason.decode(body) do
      {:ok, data} -> 
        {:ok, data}

      {:error, _reason} -> 
        {:error, :content_error, body}
    end
  end

  def extract_content(data) when is_map(data) do
    case data do
      %{"code" => 0, "data" => content} ->
        {:ok, content}

      %{"code" => code, "msg" => message} ->
        {:error, :bignx_error, Exception.new(code, message)}
    end
  end

  def extract_validated_content(%__MODULE__{} = resp) do
    with(
    :ok <- validate(resp, code: 200),
    {:ok, body} <- extract_body(resp),
    {:ok, data} <- decode_body(body),
    {:ok, content} <- extract_content(data)
    ) do
      {:ok, content}
    end
  end
end
