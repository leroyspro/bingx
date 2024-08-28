defmodule BingX.User.AuthTest.ExtendListenKeyTest do
  @moduledoc """
  This is module is used to test BingX.User.Auth module.

  ## ATTENTION
  Patch **every** network request to the real world!
  These tests are used only to verify internal logic of the module, nothing else.
  """

  use ExUnit.Case
  use Patch

  alias BingX.User.Auth
  alias BingX.HTTP.{Client, Response, Error}

  setup_all do
    {
      :ok,
      api_key: "API_KEY_FOR_TEST", listen_key: "EXISTING_LISTEN_KEY_FOR_TEST", path: "/openApi/user/auth/userDataStream"
    }
  end

  describe "BingX.User.Auth extend_listen_key/2" do
    test "should make a PUT request", context do
      %{api_key: api_key, listen_key: listen_key} = context

      patch(Client, :authed_request, {:error, :http_error, %Error{message: :timeout}})

      Auth.extend_listen_key(listen_key, api_key)

      assert_called_once(Client.authed_request(:put, _path, _api_key, _options))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, listen_key: listen_key, path: path} = context

      patch(Client, :authed_request, {:error, :http_error, %Error{message: :timeout}})

      Auth.extend_listen_key(listen_key, api_key)

      assert_called_once(Client.authed_request(_method, ^path, _api_key, _options))
    end

    test "should authenticate the request with the provided api key", context do
      %{api_key: api_key, listen_key: listen_key} = context

      patch(Client, :authed_request, {:error, :http_error, %Error{message: :timeout}})

      Auth.extend_listen_key(listen_key, api_key)

      assert_called_once(Client.authed_request(_method, _path, ^api_key, _options))
    end

    test "should put the listen key into query params", context do
      %{api_key: api_key, listen_key: listen_key} = context

      patch(Client, :authed_request, {:error, :http_error, %Error{message: :timeout}})

      Auth.extend_listen_key(listen_key, api_key)

      assert_called_once(Client.authed_request(_method, _path, _api_key, params: %{"listenKey" => ^listen_key}))
    end

    test "should validate response statuses", context do
      %{api_key: api_key, listen_key: listen_key} = context

      patch(Response, :validate_statuses, {:ok, ""})
      patch(Client, :authed_request, {:ok, %Response{status_code: 200}})

      Auth.extend_listen_key(listen_key, api_key)

      assert_called_once(Response.validate_statuses(_response, [200, 204]))
    end

    test "should return the original request http error", context do
      %{api_key: api_key, listen_key: listen_key} = context

      error = {:error, :http_error, %Error{message: :timeout}}

      patch(Client, :authed_request, error)

      assert ^error = Auth.extend_listen_key(listen_key, api_key)
    end
  end
end
