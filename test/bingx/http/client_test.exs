defmodule BingX.HTTP.ClientTest do
  use ExUnit.Case
  use Patch

  alias BingX.HTTP.{Request, Error, Response, Client}

  # def signed_request(method, path, api_key, secret_key, options \\ []) do
  #   body = Keyword.get(options, :body, "")
  #   params = Keyword.get(options, :params, %{})
  #
  #   url = Request.build_url(path, params, sign: secret_key)
  #   headers = Request.auth_headers(api_key)
  #
  #   do_request(method, url, body, headers)
  # end

  setup_all do
    {:ok, api_key: "API_KEY", secret_key: "SECRET_KEY", path: "/fds", body: "VODS"}
  end

  describe "BingX.HTTP.Client signed_request/5" do
    test "should make request with provided method", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(HTTPoison.request(%HTTPoison.Request{method: :get}))
    end

    test "should build signed url for request", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      patch(Request, :build_url, "")
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(Request.build_url(^path, _params, _options))
    end

    test "should build signed url to request", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context
      url = "http://s.r"

      patch(Request, :build_url, url)
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(HTTPoison.request(%HTTPoison.Request{url: ^url}))
    end

    test "should build url with provided query params", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      params = %{"k" => "v"}

      patch(Request, :build_url, "")
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key, params: params)

      assert_called_once(Request.build_url(_path, ^params, _options))
    end

    test "should build url with signed query params", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      patch(Request, :build_url, "")
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(Request.build_url(_path, _params, sign: ^secret_key))
    end

    test "should request with provided body", context do
      %{api_key: api_key, secret_key: secret_key, path: path, body: body} = context

      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key, body: body)

      assert_called_once(HTTPoison.request(%HTTPoison.Request{body: ^body}))
    end

    test "should make prepare authenticated headers", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      headers = %{"k" => "v"}

      patch(Request, :auth_headers, headers)
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(Request.auth_headers(^api_key))
    end

    test "should make request with authenticated headers", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      headers = %{"k" => "v"}

      patch(Request, :auth_headers, headers)
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.signed_request(:get, path, api_key, secret_key)

      assert_called_once(HTTPoison.request(%HTTPoison.Request{headers: ^headers}))
    end

    test "should adapt HTTPoison.Error into internal interface", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      orig_err = %HTTPoison.Error{reason: :foo}
      exp_err = %Error{message: :foo}

      patch(HTTPoison, :request, {:error, orig_err})

      assert {:error, :http_error, ^exp_err} = Client.signed_request(:get, path, api_key, secret_key)
    end

    test "should adapt HTTPoison.Response into internal interface", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      orig_resp = %HTTPoison.Response{body: "HEHE", headers: nil}
      exp_resp = %Response{body: "HEHE"}

      patch(HTTPoison, :request, {:ok, orig_resp})

      assert {:ok, ^exp_resp} = Client.signed_request(:get, path, api_key, secret_key)
    end
  end

  describe "BingX.HTTP.Client authed_request/4" do
    test "should make request with provided method", context do
      %{api_key: api_key, secret_key: secret_key, path: path} = context

      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.authed_request(:get, path, api_key)

      assert_called_once(HTTPoison.request(%HTTPoison.Request{method: :get}))
    end

    test "should build signed url for request", context do
      %{api_key: api_key, path: path} = context

      patch(Request, :build_url, "")
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.authed_request(:get, path, api_key)

      assert_called_once(Request.build_url(^path, _params))
    end

    test "should build signed url to request", context do
      %{api_key: api_key, path: path} = context
      url = "http://s.r"

      patch(Request, :build_url, url)
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.authed_request(:get, path, api_key)

      assert_called_once(HTTPoison.request(%HTTPoison.Request{url: ^url}))
    end

    test "should build url with provided query params", context do
      %{api_key: api_key, path: path} = context

      params = %{"k" => "v"}

      patch(Request, :build_url, "")
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.authed_request(:get, path, api_key, params: params)

      assert_called_once(Request.build_url(_path, ^params))
    end

    test "should request with provided body", context do
      %{api_key: api_key, path: path, body: body} = context

      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.authed_request(:get, path, api_key, body: body)

      assert_called_once(HTTPoison.request(%HTTPoison.Request{body: ^body}))
    end

    test "should make prepare authenticated headers", context do
      %{api_key: api_key, path: path} = context

      headers = %{"k" => "v"}

      patch(Request, :auth_headers, headers)
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.authed_request(:get, path, api_key)

      assert_called_once(Request.auth_headers(^api_key))
    end

    test "should make request with authenticated headers", context do
      %{api_key: api_key, path: path} = context

      headers = %{"k" => "v"}

      patch(Request, :auth_headers, headers)
      patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

      Client.authed_request(:get, path, api_key)

      assert_called_once(HTTPoison.request(%HTTPoison.Request{headers: ^headers}))
    end

    test "should adapt HTTPoison.Error into internal interface", context do
      %{api_key: api_key, path: path} = context

      orig_err = %HTTPoison.Error{reason: :foo}
      exp_err = %Error{message: :foo}

      patch(HTTPoison, :request, {:error, orig_err})

      assert {:error, :http_error, ^exp_err} = Client.authed_request(:get, path, api_key)
    end

    test "should adapt HTTPoison.Response into internal interface", context do
      %{api_key: api_key, path: path} = context

      orig_resp = %HTTPoison.Response{body: "HEHE", headers: nil}
      exp_resp = %Response{body: "HEHE"}

      patch(HTTPoison, :request, {:ok, orig_resp})

      assert {:ok, ^exp_resp} = Client.authed_request(:get, path, api_key)
    end
  end
end
