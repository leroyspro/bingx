defmodule BingX.HTTP.Response do
  @moduledoc """
  This module provides advanced and universal utilities for working with BingX API responses.
  """

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

      %{"code" => code, "msg" => message} ->
        exception = Exception.exception(code: code, message: message)
        {:error, :bingx_error, exception}

      payload ->
        {:ok, payload}
    end
  end

  def get_response_payload(%__MODULE__{} = response) do
    with(
      {:ok, response} <- validate_statuses(response, [200, 201, 204]),
      {:ok, body} <- get_response_body(response),
      {:ok, content} <- get_body_content(body)
    ) do
      get_content_payload(content)
    end
  end
end
