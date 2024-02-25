defmodule BingX.API.AccountTest do
  @moduledoc """
  Module to test BingX.API.Account.

  ## ATTENTION

  Do patch **every** network request to real world!
  These tests are used only to verify internal logic of the module, not others.
  """

  use ExUnit.Case
  use Patch

  alias BingX.API.{QueryParams, Headers, Account, Exception}
  alias BingX.API.Account.BalanceResponse

  @origin Application.compile_env!(:bingx, :origin)

  setup_all do
    {
      :ok,
      api_key: "API_KEY_FOR_TEST", secret_key: "SECRET_KEY_FOR_TEST"
    }
  end

  describe "BingX.API.Account get_balance/2" do
    setup _context do
      {:ok, endpoint: @origin <> "/openApi/swap/v2/user/balance"}
    end

    test "should make GET request", context do
      %{api_key: api_key, secret_key: secret_key} = context

      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(HTTPoison.get(_endpoint, _headers, _options))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, secret_key: secret_key, endpoint: endpoint} = context

      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(HTTPoison.get(^endpoint, _headers, _options))
    end

    test "should request with authentication in headers", context do
      %{api_key: api_key, secret_key: secret_key} = context

      headers = %{"API_KEY" => api_key}

      patch(Headers, :append_api_key, headers)
      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(Headers.append_api_key(_, ^api_key))
      assert_called_once(HTTPoison.get(_url, ^headers, _options))
    end

    test "should request with receive window in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      receive_window = 473_289_473_289
      params_with_receive_window = %{"RECEIVE_WINDOW" => receive_window}

      patch(QueryParams, :append_receive_window, &Map.merge(&1, params_with_receive_window))

      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(
        HTTPoison.get(_url, _headers, params: %{"RECEIVE_WINDOW" => ^receive_window})
      )

      assert_called_once(QueryParams.append_receive_window(_))
    end

    test "should request with timestamp in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      timestamp = 21_321_321_321
      params_with_timestamp = %{"TIMESTAMP" => timestamp}

      patch(QueryParams, :append_timestamp, &Map.merge(&1, params_with_timestamp))
      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(HTTPoison.get(_url, _headers, params: %{"TIMESTAMP" => ^timestamp}))
      assert_called_once(QueryParams.append_timestamp(_))
    end

    test "should request with signature in query params", context do
      %{api_key: api_key, secret_key: secret_key} = context

      signature = "********"
      params_with_signature = %{"SIGNATURE" => signature}

      patch(QueryParams, :append_signature, fn params, _secret_key ->
        Map.merge(params, params_with_signature)
      end)

      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(HTTPoison.get(_url, _headers, params: %{"SIGNATURE" => ^signature}))
      assert_called_once(QueryParams.append_signature(_, ^secret_key))
    end

    test "should return the original error if request failed", context do
      %{api_key: api_key, secret_key: secret_key} = context

      result = {:error, %HTTPoison.Error{reason: :timeout}}

      patch(HTTPoison, :get, result)

      assert ^result = Account.get_balance(api_key, secret_key)
    end

    test "should return the original error if request is not 200", context do
      %{api_key: api_key, secret_key: secret_key} = context

      result = {:error, %HTTPoison.Response{status_code: 301}}

      patch(HTTPoison, :get, result)

      assert ^result = Account.get_balance(api_key, secret_key)
    end

    test "should wrap the successful response in BalanceResponse", context do
      %{api_key: api_key, secret_key: secret_key} = context

      data = %{"success" => "ALWAYS!"}
      body = Jason.encode!(%{"code" => 0, "data" => %{"balance" => data}})
      struct = %{success: "ALWAYS!"}

      patch(HTTPoison, :get, {:ok, %HTTPoison.Response{body: body, status_code: 200}})
      patch(BalanceResponse, :new, struct)

      assert {:ok, ^struct} = Account.get_balance(api_key, secret_key)

      assert_called_once(BalanceResponse.new(^data))
    end

    test "should wrap the unsuccessful response in Exception", context do
      %{api_key: api_key, secret_key: secret_key} = context

      code = 1001
      message = "Too funny"
      body = Jason.encode!(%{"code" => code, "msg" => message})
      struct = %{success: "NEVER!"}

      patch(HTTPoison, :get, {:ok, %HTTPoison.Response{body: body, status_code: 200}})
      patch(Exception, :new, struct)

      assert {:error, ^struct} = Account.get_balance(api_key, secret_key)

      assert_called_once(Exception.new(^code, ^message))
    end
  end
end
