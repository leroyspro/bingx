defmodule BingX.Account.SecurityTest.GenerateListenKeyTest do
  @moduledoc """
  This is module is used to test BingX.Account.Security module.

  ## ATTENTION
  Patch **every** network request to the real world!
  These tests are used only to verify internal logic of the module, nothing else.
  """

  use ExUnit.Case
  use Patch

  alias BingX.Account.{Security, GenerateListenKeyResponse}
  alias BingX.HTTP.{Client, Response, Error}

  setup_all do
    {
      :ok,
      api_key: "API_KEY_FOR_TEST", path: "/openApi/user/auth/userDataStream"
    }
  end

  describe "BingX.Account.Security generate_listen_key/1" do
    test "should make a POST request", context do
      %{api_key: api_key} = context

      patch(Client, :authed_request, {:error, :http_error, %Error{message: :timeout}})

      Security.generate_listen_key(api_key)

      assert_called_once(Client.authed_request(:post, _path, _api_key))
    end

    test "should request correct endpoint", context do
      %{api_key: api_key, path: path} = context

      patch(Client, :authed_request, {:error, :http_error, %Error{message: :timeout}})

      Security.generate_listen_key(api_key)

      assert_called_once(Client.authed_request(_method, ^path, _api_key))
    end

    test "should authenticate the request with provided api_key", context do
      %{api_key: api_key} = context

      patch(Client, :authed_request, {:error, :http_error, %Error{message: :timeout}})

      Security.generate_listen_key(api_key)

      assert_called_once(Client.authed_request(_method, _path, ^api_key))
    end

    test "should extract and validate response content", context do
      %{api_key: api_key} = context

      content = "ABCD"
      response = %Response{body: %{"data" => content}}
      struct = %{"KEY" => :ABC}

      patch(GenerateListenKeyResponse, :new, struct)
      patch(Response, :process_response, {:ok, content})
      patch(Client, :authed_request, {:ok, response})

      Security.generate_listen_key(api_key)

      assert_called_once(Response.process_response(^response))
    end

    test "should wrap the success content into GenerateListenKeyResponse struct", context do
      %{api_key: api_key} = context

      content = "ABCD"
      response = %Response{body: %{"data" => content}}
      struct = %{"KEY" => :ABCD}

      patch(GenerateListenKeyResponse, :new, struct)
      patch(Response, :process_response, {:ok, content})
      patch(Client, :authed_request, {:ok, response})

      assert {:ok, ^struct} = Security.generate_listen_key(api_key)

      assert_called_once(GenerateListenKeyResponse.new(^content))
      assert_called_once(Response.process_response(^response))
    end

    test "should return the original content error", context do
      %{api_key: api_key} = context

      error = {:error, :content_error, "yep"}
      response = %Response{body: %{"data" => "a"}}

      patch(Response, :process_response, error)
      patch(Client, :authed_request, {:ok, response})

      assert ^error = Security.generate_listen_key(api_key)

      assert_called_once(Response.process_response(^response))
    end

    test "should return the original request http error", context do
      %{api_key: api_key} = context

      error = {:error, :http_error, %Error{message: :timeout}}

      patch(Client, :authed_request, error)

      assert ^error = Security.generate_listen_key(api_key)
    end
  end
end
