defmodule BingX.API.AccountTest do
  @moduledoc """
  Module to test BingX.API.Account.

  # ATTENTION

  Do patch **every** network request to real world!
  This tests are used only to verify internal logic of the module, not others.
  """

  use ExUnit.Case
  use Patch

  alias BingX.API.{QueryParams, Headers, Account, Exception}
  alias BingX.API.Account.BalanceResponse

  @hostname Application.compile_env!(:bingx, :hostname)

  setup_all do
    {
      :ok,
      api_key: "API_KEY_FOR_TEST", secret_key: "SECRET_KEY_FOR_TEST"
    }
  end

  describe "BingX.API.Account get_balance/2" do
    setup _context do
      # Add endpoint key in addition to the global setup variables
      {:ok, endpoint: @hostname <> "/openApi/swap/v2/user/balance"}
    end

    test "should make get request with correct url", context do
      %{api_key: api_key, secret_key: secret_key, endpoint: endpoint} = context

      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(HTTPoison.get(endpoint, headers, _options))
    end

    test "should put the provided api_key into the request headers", context do
      %{api_key: api_key, secret_key: secret_key} = context

      headers = %{"API_KEY" => api_key}

      patch(Headers, :append_api_key, headers)
      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(HTTPoison.get(_url, headers, _options))
      assert_called_once(Headers.append_api_key(_, api_key))
    end

    test "should emit the error if request is unsuccessful", context do
      %{api_key: api_key, secret_key: secret_key} = context

      result = {:error, %HTTPoison.Error{reason: :timeout}}

      patch(HTTPoison, :get, result)

      assert ^result = Account.get_balance(api_key, secret_key)
    end

    test "should put query params with receive window", context do
      %{api_key: api_key, secret_key: secret_key} = context

      params_with_receive_window = %{"TEST_RECEIVE_WINDOW" => 100}
      http_options = [params: params_with_receive_window]

      patch(
        QueryParams,
        :append_receive_window,
        callable(fn params ->
          Map.merge(params, params_with_receive_window)
        end)
      )

      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(HTTPoison.get(_url, _headers, http_options))
      assert_called_once(QueryParams.append_receive_window(_))
    end

    test "should put query params with timestamp", context do
      %{api_key: api_key, secret_key: secret_key} = context

      params_with_timestamp = %{"TEST_TIMESTAMP" => 100}
      http_options = [params: params_with_timestamp]

      patch(
        QueryParams,
        :append_timestamp,
        callable(fn params ->
          Map.merge(params, params_with_timestamp)
        end)
      )

      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(HTTPoison.get(_url, _headers, http_options))
      assert_called_once(QueryParams.append_timestamp(_))
    end

    test "should sign query params with the provided secret_key", context do
      %{api_key: api_key, secret_key: secret_key} = context

      params_with_signature = %{"SIGNATURE" => "*******"}
      http_options = [params: params_with_signature]

      patch(
        QueryParams,
        :append_signature,
        callable(fn params, _secret_key ->
          Map.merge(params, params_with_signature)
        end)
      )

      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(HTTPoison.get(_url, _headers, http_options))
      assert_called_once(QueryParams.append_signature(_, secret_key))
    end

    test "should wrap the successful response with BalanceResponse", context do
      %{api_key: api_key, secret_key: secret_key} = context

      data = %{"success" => "ALWAYS!"}
      body = Jason.encode!(%{"code" => 0, "data" => %{"balance" => data}})
      struct = %{success: "ALWAYS!"}

      patch(HTTPoison, :get, {:ok, %HTTPoison.Response{body: body}})
      patch(BalanceResponse, :new, struct)

      assert {:ok, ^struct} = Account.get_balance(api_key, secret_key)

      assert_called_once(BalanceResponse.new(data))
    end

    test "should wrap the unsuccessful response with Exception", context do
      %{api_key: api_key, secret_key: secret_key} = context

      code = 1001
      message = "Too funny"
      body = Jason.encode!(%{"code" => code, "msg" => message})
      struct = %{success: "NEVER!"}

      patch(HTTPoison, :get, {:ok, %HTTPoison.Response{body: body}})
      patch(Exception, :new, struct)

      assert {:error, ^struct} = Account.get_balance(api_key, secret_key)

      assert_called_once(Exception.new(code, message))
    end
  end
end
