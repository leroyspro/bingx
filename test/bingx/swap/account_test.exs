defmodule BingX.Swap.AccountTest do
  @moduledoc """
  Module to test BingX.API.Account.

  ## ATTENTION

  Do patch **every** network request to real world!
  These tests are used only to verify internal logic of the module, not others.
  """

  use ExUnit.Case
  use Patch

  alias BingX.Exception
  alias BingX.Request.{QueryParams, Headers}
  alias BingX.Swap.Account
  alias BingX.Swap.Account.BalanceResponse

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

    test "should request with correct path", context do
      %{api_key: api_key, secret_key: secret_key, endpoint: endpoint} = context

      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(HTTPoison.get(^endpoint, _headers, _options))
    end

    test "should make secure request", context do
      %{api_key: api_key, secret_key: secret_key} = context

      headers = %{"API_KEY" => api_key}

      patch(Headers, :append_api_key, headers)
      patch(HTTPoison, :get, {:error, %HTTPoison.Error{reason: :timeout}})

      Account.get_balance(api_key, secret_key)

      assert_called_once(Headers.append_api_key(_, ^api_key))
      assert_called_once(HTTPoison.get(_url, ^headers, _options))
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
