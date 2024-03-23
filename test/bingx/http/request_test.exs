defmodule BingX.HTTP.RequestTest do
  use ExUnit.Case
  use Patch

  @origin Application.compile_env!(:bingx, :origin)

  alias BingX.HTTP.Request
  alias BingX.HTTP.Request.QueryParams

  describe "BingX.HTTP.Request build_url/3" do
    test "should use correct origin" do
      origin_url = URI.new!(@origin)
      url = Request.build_url() |> URI.new!()

      %{
        scheme: scheme,
        host: host,
        port: port
      } = origin_url

      assert ^scheme = url.scheme
      assert ^host = url.host
      assert ^port = url.port
    end

    test "should use correct path" do
      path = "/path/path"
      url = Request.build_url(path) |> URI.new!()

      assert ^path = url.path
    end

    test "should append timestamp into query params" do
      patch(QueryParams, :append_timestamp, %{"TIMESTAMP" => 1234})

      params =
        Request.build_url()
        |> URI.new!()
        |> Map.get(:query)
        |> URI.decode_query()

      assert %{"TIMESTAMP" => "1234"} = params

      assert_called_once(QueryParams.append_timestamp(_params))
    end

    test "should append receive window into query params" do
      patch(QueryParams, :append_receive_window, %{"RECV_WINDOW" => 1234})

      params =
        Request.build_url()
        |> URI.new!()
        |> Map.get(:query)
        |> URI.decode_query()

      assert %{"RECV_WINDOW" => "1234"} = params

      assert_called_once(QueryParams.append_timestamp(_params))
    end

    test "should append signature only if the option specified" do
      patch(QueryParams, :append_signature, %{"SIGNATURE" => 1234})

      params =
        Request.build_url("", %{}, sign: 1234)
        |> URI.new!()
        |> Map.get(:query)
        |> URI.decode_query()

      assert %{"SIGNATURE" => "1234"} = params

      params =
        Request.build_url("", %{})
        |> URI.new!()
        |> Map.get(:query)
        |> URI.decode_query()

      refute Map.has_key?(params, "SIGNATURE")

      assert_called_once(QueryParams.append_signature(_params, 1234))
    end
  end
end
