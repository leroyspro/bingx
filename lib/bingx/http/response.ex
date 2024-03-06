defmodule BingX.HTTP.Response do
  alias BingX.Exception

  defstruct [:status_code, :body, :headers, :request_url]

  def validate(_resp, options \\ [{:code, 200}])

  def validate(%__MODULE__{status_code: status_code} = response, code: exp_status_code) do
    if status_code === exp_status_code do
      {:ok, response}
    else
      {:error, :response_error, response}
    end
  end

  def get_response_body(%__MODULE__{body: body}), do: {:ok, body}

  def get_body_content(body) do
    case Jason.decode(body || "") do
      {:ok, content} ->
        {:ok, content}

      {:error, _reason} ->
        {:error, :content_error, body}
    end
  end

  def get_content_payload(content) when is_map(content) do
    case content do
      %{"code" => 0, "data" => payload} ->
        {:ok, payload}

      %{"code" => code, "msg" => message} ->
        {:error, :bingx_error, Exception.new(code, message)}

      payload ->
        {:ok, payload}
    end
  end

  def get_response_payload(%__MODULE__{} = response) do
    with(
      {:ok, response} <- validate(response, code: 200),
      {:ok, body} <- get_response_body(response),
      {:ok, content} <- get_body_content(body),
      {:ok, payload} <- get_content_payload(content)
    ) do
      {:ok, payload}
    end
  end
end
