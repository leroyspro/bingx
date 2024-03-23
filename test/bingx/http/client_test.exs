defmodule BingX.HTTP.ClientTest do
  use ExUnit.Case
  use Patch

  alias BingX.HTTP.{Request, Error, Client}

  @http_adapter Application.compile_env!(:bingx, :http_adapter)

  setup_all do
    {:ok, api_key: "API_KEY", secret_key: "SECRET_KEY", path: "/fds", body: "VODS"}
  end

  describe "BingX.HTTP.Client signed_request/5" do
    test "should make request with provided method", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(@http_adapter.request(:get, _method, _body, _headers))
    end

    test "should build signed url to request", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context
      url = "http://s.r"

      patch(Request, :build_url, url)
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(@http_adapter.request(_method, ^url, _body, _headers))
    end

    test "should request with provided body", context do
      %{api_key: api_key, secret_key: secret_key, path: path, body: body} = context

      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key, body: body)

      assert_called_once(@http_adapter.request(_method, _url, ^body, _headers))
    end

    test "should make request with authenticated headers", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      headers = %{"k" => "v"}

      patch(Request, :auth_headers, headers)
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(@http_adapter.request(_method, _url, _body, ^headers))
    end

    test "should build url with provided query params", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      params = %{"k" => "v"}

      patch(Request, :build_url, "")
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key, params: params)

      assert_called_once(Request.build_url(_path, ^params, _options))
    end

    test "should build url with signed query params", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      patch(Request, :build_url, "")
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(Request.build_url(_path, _params, sign: ^secret_key))
    end

    test "should prepare authenticated headers", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      headers = %{"k" => "v"}

      patch(Request, :auth_headers, headers)
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(Request.auth_headers(^api_key))
    end

    test "should build signed url for request", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      patch(Request, :build_url, "")
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(Request.build_url(^path, _params, _options))
    end

    test "should return original http request result", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      result = {:error, :http_error, %Error{message: :timeout}}

      patch(Request, :build_url, "")
      patch(@http_adapter, :request, result)

      assert ^result = Client.signed_request(:get, path, api_key, secret_key)
    end
  end

  describe "BingX.HTTP.Client authed_request/4" do
    test "should make request with provided method", context do
      %{api_key: api_key, path: path} = context

      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.authed_request(:get, path, api_key)

      assert_called_once(@http_adapter.request(:get, _url, _body, _headers))
    end

    test "should build signed url to request", context do
      %{api_key: api_key, path: path} = context
      url = "http://s.r"

      patch(Request, :build_url, url)
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.authed_request(:get, path, api_key)

      assert_called_once(@http_adapter.request(_method, ^url, _body, _headers))
    end

    test "should request with provided body", context do
      %{api_key: api_key, path: path, body: body} = context

      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.authed_request(:get, path, api_key, body: body)

      assert_called_once(@http_adapter.request(_method, _url, ^body, _headers))
    end

    test "should make request with authenticated headers", context do
      %{api_key: api_key, path: path} = context

      headers = %{"k" => "v"}

      patch(Request, :auth_headers, headers)
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.authed_request(:get, path, api_key)

      assert_called_once(@http_adapter.request(_method, _url, _body, ^headers))
    end

    test "should build signed url for request", context do
      %{api_key: api_key, path: path} = context

      patch(Request, :build_url, "")
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.authed_request(:get, path, api_key)

      assert_called_once(Request.build_url(^path, _params))
    end

    test "should build url with provided query params", context do
      %{api_key: api_key, path: path} = context

      params = %{"k" => "v"}

      patch(Request, :build_url, "")
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.authed_request(:get, path, api_key, params: params)

      assert_called_once(Request.build_url(_path, ^params))
    end

    test "should prepare authenticated headers", context do
      %{api_key: api_key, path: path} = context

      headers = %{"k" => "v"}

      patch(Request, :auth_headers, headers)
      patch(@http_adapter, :request, {:error, :http_error, %Error{message: :timeout}})

      Client.authed_request(:get, path, api_key)

      assert_called_once(Request.auth_headers(^api_key))
    end

    test "should return original http request result", context do
      %{api_key: api_key, path: path} = context

      result = {:error, :http_error, %Error{message: :timeout}}

      patch(Request, :build_url, "")
      patch(@http_adapter, :request, result)

      assert ^result = Client.authed_request(:get, path, api_key)
    end
  end
end
