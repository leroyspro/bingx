if Code.ensure_loaded?(HTTPoison) do
  defmodule BingX.HTTP.Adapter.HTTPoisonTest do
    @moduledoc """
    ## ATTENTION
    Patch **every** network request to the real world!
    These tests are used only to verify internal logic of the module, nothing else.
    """

    use ExUnit.Case
    use Patch

    alias BingX.HTTP.{Error, Response}
    alias BingX.HTTP.Adapter.HTTPoison, as: Adapter

    setup_all do
      {
        :ok, 
        method: :get, 
        headers: [{"key", "value"}], 
        url: "/fds", 
        body: "VODS", 
        options: [proxy: "NOPE"]
      }
    end

    describe "BingX.HTTP.Adapter.HTTPoison request/5" do
      test "should make request with provided method", context do
        %{method: method, url: url, body: body, headers: headers} = context

        patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

        Adapter.request(method, url, body, headers)

        assert_called_once(HTTPoison.request(%HTTPoison.Request{method: ^method}))
      end

      test "should build signed url to request", context do
        %{method: method, url: url, body: body, headers: headers} = context
        url = "http://s.r"

        patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

        Adapter.request(method, url, body, headers)

        assert_called_once(HTTPoison.request(%HTTPoison.Request{url: ^url}))
      end

      test "should request with provided body", context do
        %{method: method, url: url, body: body, headers: headers} = context

        patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

        Adapter.request(method, url, body, headers)

        assert_called_once(HTTPoison.request(%HTTPoison.Request{body: ^body}))
      end

      test "should make request with authenticated headers", context do
        %{method: method, url: url, body: body, headers: headers} = context

        patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

        Adapter.request(method, url, body, headers)

        assert_called_once(HTTPoison.request(%HTTPoison.Request{headers: ^headers}))
      end

      test "should request with provided options", context do
        %{method: method, url: url, body: body, headers: headers, options: options} = context

        patch(HTTPoison, :request, {:error, %HTTPoison.Error{reason: :timeout}})

        Adapter.request(method, url, body, headers, options)

        assert_called_once(HTTPoison.request(%HTTPoison.Request{options: ^options}))
      end

      test "should adapt HTTPoison.Error into internal interface", context do
        %{method: method, url: url, body: body, headers: headers} = context

        orig_err = %HTTPoison.Error{reason: :foo}
        exp_err = %Error{message: :foo}

        patch(HTTPoison, :request, {:error, orig_err})

        assert {:error, :http_error, ^exp_err} = Adapter.request(method, url, body, headers)
      end

      test "should adapt HTTPoison.Response into internal interface", context do
        %{method: method, url: url, body: body, headers: headers} = context

        orig_resp = %HTTPoison.Response{body: "HEHE", headers: nil}
        exp_resp = %Response{body: "HEHE"}

        patch(HTTPoison, :request, {:ok, orig_resp})

        assert {:ok, ^exp_resp} = Adapter.request(method, url, body, headers)
      end
    end
  end
end
