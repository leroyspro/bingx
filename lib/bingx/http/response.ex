defmodule BingX.HTTP.Response do
  alias BingX.Exception

  defstruct [:status_code, :body, :headers, :request_url]

  def validate_status(%__MODULE__{status_code: code} = response, exp_code) when is_number(exp_code) do
    if code === exp_code do
      {:ok, response}
    else
      {:error, :response_error, response}
    end
  end

  def validate_statuses(%__MODULE__{status_code: code} = response, exp_codes) when is_list(exp_codes) do
    if code in exp_codes do
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

  def get_content_payload(content) do
    case content do
      %{"code" => 0, "data" => payload} ->
        {:ok, payload}

      %{"code" => 0} ->
        {:ok, :no_data}

      %{"code" => code, "msg" => message} ->
        {:error, :bingx_error, Exception.new(code, message)}

      payload ->
        {:ok, payload}
    end
  end

  def process_response(%__MODULE__{} = response) do
    with(
      {:ok, response} <- validate_statuses(response, [200, 201, 204]),
      {:ok, body} <- get_response_body(response),
      {:ok, content} <- get_body_content(body),
      {:ok, payload} <- get_content_payload(content)
    ) do
      {:ok, payload}
    end
  end
end
