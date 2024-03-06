defmodule BingX.HTTP.ResponseTest do
  use ExUnit.Case
  use Patch

  import BingX.TestHelpers

  alias BingX.HTTP.Response

  @fields [:status_code, :body, :headers, :request_url]

  describe "BingX.HTTP.Response struct" do
    test_module_struct(Response, @fields)
  end

  describe "BingX.HTTP.Response validate/2" do
    test "should return error if status code does not match the expected one" do
      response = %Response{status_code: 200}

      {:error, :response_error, ^response} = Response.validate(response, code: 202)
    end

    test "should return success if status code does match the expected one" do
      response = %Response{status_code: 200}

      {:ok, ^response} = Response.validate(response, code: 200)
    end

    test "should return success if status code does match the default one" do
      response = %Response{status_code: 200}
      {:ok, ^response} = Response.validate(response)

      response = %Response{status_code: 201}
      {:error, :response_error, ^response} = Response.validate(response)
    end
  end

  describe "BingX.HTTP.Response get_response_body/1" do
    test "should extract body from response struct" do
      response = %Response{status_code: 200, body: "BODY"}

      {:ok, "BODY"} = Response.get_response_body(response)
    end
  end

  describe "BingX.HTTP.Response get_body_content/1" do
    test "should extract JSON content from response body" do
      content = %{"k" => "v"}
      body = Jason.encode!(content)

      {:ok, ^content} = Response.get_body_content(body)
    end

    test "should return error for non-JSON body" do
      body = "content"

      {:error, :content_error, "content"} = Response.get_body_content(body)
    end
  end

  describe "BingX.HTTP.Response get_content_payload/1" do
    test "should extract data and return payload for success code" do
      payload = "PAYLOAD"

      assert {:ok, ^payload} = Response.get_content_payload(%{"code" => 0, "data" => payload})
    end

    test "should wrap message and code into exception for non-success code" do
      message = "supra"
      code = 12321

      assert {:error, :bingx_error, %BingX.Exception{message: ^message, code: ^code}} = 
        Response.get_content_payload(%{"code" => code, "msg" => message})
    end

    test "should return payload as it is if there is not response interface (extra case)" do
      payload = "PAYLOAD"

      assert {:ok, %{"data" => ^payload}} = Response.get_content_payload(%{"data" => payload})
    end
  end

  describe "BingX.HTTP.Response get_response_payload/1" do
    test "should validate response on 200 code" do
      response = %Response{status_code: 200}

      patch(Response, :validate, {:ok, response})
        
      Response.get_response_payload(response)

      assert_called_once(Response.validate(^response, code: 200))
    end

    test "should return validation error for response with not 200 code" do
      error = {:error, :no_reason}
      patch(Response, :validate, error)

      response = %Response{status_code: 203}

      assert ^error = Response.get_response_payload(response)

      assert_called_once(Response.validate(^response, code: 200))
    end

    test "should return error from the local body content extracter" do
      error = {:error, "NONONON!"}

      patch(Response, :get_body_content, error)
      response = %Response{status_code: 200}

      assert ^error = Response.get_response_payload(response)

      assert_called_once(Response.validate(^response, code: 200))
    end

    test "should return error from the local content payload extracter" do
      error = {:error, "NONONON!"}

      patch(Response, :get_content_payload, error)
      response = %Response{status_code: 200, body: "{}"}

      assert ^error = Response.get_response_payload(response)

      assert_called_once(Response.validate(^response, code: 200))
    end

    test "should get content payload via the local functions" do
      body = "BODYBODY"
      content = "CONTENT"
      payload = "PAYLOAD"
      
      patch(Response, :get_body_content, {:ok, content})
      patch(Response, :get_content_payload, {:ok, payload})

      response = %Response{status_code: 200, body: body}
      {:ok, ^payload} = Response.get_response_payload(response)

      assert_called_once(Response.get_body_content(^body))
      assert_called_once(Response.get_content_payload(^content))
    end
  end
end
#
#   def get_response_payload(%__MODULE__{} = resp) do
#     with(
#       :ok <- validate(resp, code: 200),
#       {:ok, body} <- get_response_body(resp),
#       {:ok, content} <- get_body_content(body),
#       {:ok, payload} <- get_content_payload(content)
#     ) do
#       {:ok, payload}
#     end
#   end
# end
