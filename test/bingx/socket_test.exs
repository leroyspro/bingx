defmodule BingX.SocketTest do
  use ExUnit.Case
  use Patch

  alias WebSockex
  alias BingX.Socket

  @send_message :"$send"

  defmodule SocketMock do
    @behaviour BingX.Socket

    def handle_event(_event, state) do
      {:ok, state}
    end

    def handle_connect(state) do
      {:ok, state}
    end

    def handle_disconnect(state) do
      {:reconnect, state}
    end

    def handle_info(_message, state) do
      {:ok, state}
    end

    def handle_cast(_message, state) do
      {:ok, state}
    end
  end

  defmodule SocketMock.Basic do
    @behaviour BingX.Socket

    def handle_event(_event, state) do
      {:ok, state}
    end
  end

  alias __MODULE__.SocketMock

  setup_all do
    {:ok, url: "/url", module: SocketMock, state: %{"a" => :state}, options: [:a]}
  end

  describe "BingX.Socket start/4" do
    test "should start process", context do
      %{url: url, module: module, state: state, options: options} = context

      patch(WebSockex, :start, {:ok, :pid})

      Socket.start(url, module, state, options)

      assert_called_once(WebSockex.start(_url, _module, _state, _options))
    end

    test "should return original value", context do
      %{url: url, module: module, state: state, options: options} = context

      result = {:ok, :pid}

      patch(WebSockex, :start, result)

      assert ^result = Socket.start(url, module, state, options)
    end

    test "should use the provided url", context do
      %{url: url, module: module, state: state, options: options} = context

      patch(WebSockex, :start, {:ok, :pid})

      Socket.start(url, module, state, options)

      assert_called_once(WebSockex.start(^url, _module, _state, _options))
    end

    test "should use this module", context do
      %{url: url, module: module, state: state, options: options} = context

      patch(WebSockex, :start, {:ok, :pid})

      Socket.start(url, module, state, options)

      assert_called_once(WebSockex.start(_url, BingX.Socket, _state, _options))
    end

    test "should structure internal state", context do
      %{url: url, module: module, state: state, options: options} = context

      patch(WebSockex, :start, {:ok, :pid})

      Socket.start(url, module, state, options)

      assert_called_once(WebSockex.start(_url, _module, {^module, ^state}, _options))
    end

    test "should use the provided options", context do
      %{url: url, module: module, state: state, options: options} = context

      patch(WebSockex, :start, {:ok, :pid})

      Socket.start(url, module, state, options)

      assert_called_once(WebSockex.start(_url, _module, _state, ^options))
    end

    test "should use default options", context do
      %{url: url, module: module, state: state} = context

      patch(WebSockex, :start, {:ok, :pid})

      Socket.start(url, module, state)

      assert_called_once(WebSockex.start(_url, _module, _state, []))
    end
  end

  describe "BingX.Socket start_link/4" do
    test "should start the linked process", context do
      %{url: url, module: module, state: state, options: options} = context

      patch(WebSockex, :start_link, {:ok, :pid})

      Socket.start_link(url, module, state, options)

      assert_called_once(WebSockex.start_link(_url, _module, _state, _options))
    end

    test "should return original value", context do
      %{url: url, module: module, state: state, options: options} = context

      result = {:ok, :pid}

      patch(WebSockex, :start_link, result)

      assert ^result = Socket.start_link(url, module, state, options)
    end

    test "should use the provided url", context do
      %{url: url, module: module, state: state, options: options} = context

      patch(WebSockex, :start_link, {:ok, :pid})

      Socket.start_link(url, module, state, options)

      assert_called_once(WebSockex.start_link(^url, _module, _state, _options))
    end

    test "should use this module", context do
      %{url: url, module: module, state: state, options: options} = context

      patch(WebSockex, :start_link, {:ok, :pid})

      Socket.start_link(url, module, state, options)

      assert_called_once(WebSockex.start_link(_url, BingX.Socket, _state, _options))
    end

    test "should structure internal state", context do
      %{url: url, module: module, state: state, options: options} = context

      patch(WebSockex, :start_link, {:ok, :pid})

      Socket.start_link(url, module, state, options)

      assert_called_once(WebSockex.start_link(_url, _module, {^module, ^state}, _options))
    end

    test "should use the provided options", context do
      %{url: url, module: module, state: state, options: options} = context

      patch(WebSockex, :start_link, {:ok, :pid})

      Socket.start_link(url, module, state, options)

      assert_called_once(WebSockex.start_link(_url, _module, _state, ^options))
    end

    test "should use default options", context do
      %{url: url, module: module, state: state} = context

      patch(WebSockex, :start_link, {:ok, :pid})

      Socket.start_link(url, module, state)

      assert_called_once(WebSockex.start_link(_url, _module, _state, []))
    end
  end

  describe "BingX.Socket send/2" do
    test "should send process message" do
      patch(WebSockex, :cast, :ok)

      pid = :pid
      message = "MESSAGE"

      Socket.send(pid, message)

      assert_called_once(WebSockex.cast(_pid, _message))
    end

    test "should return the original value" do
      result = {:error, "no reason"}

      patch(WebSockex, :cast, result)

      pid = :pid
      message = "MESSAGE"

      assert ^result = Socket.send(pid, message)
    end

    test "should send to the provided pid" do
      patch(WebSockex, :cast, :ok)

      pid = :pid
      message = "MESSAGE"

      Socket.send(pid, message)

      assert_called_once(WebSockex.cast(^pid, _message))
    end

    test "should send the provided message" do
      patch(WebSockex, :cast, :ok)

      pid = :pid
      message = "MESSAGE"

      Socket.send(pid, message)

      assert_called_once(WebSockex.cast(_pid, {@send_message, ^message}))
    end
  end

  describe "BingX.Socket cast/2" do
    test "should send process message" do
      patch(WebSockex, :cast, :ok)

      pid = :pid
      message = "MESSAGE"

      Socket.cast(pid, message)

      assert_called_once(WebSockex.cast(_pid, _message))
    end

    test "should return the original value" do
      result = {:error, "no reason"}

      patch(WebSockex, :cast, result)

      pid = :pid
      message = "MESSAGE"

      assert ^result = Socket.cast(pid, message)
    end

    test "should send to the provided pid" do
      patch(WebSockex, :cast, :ok)

      pid = :pid
      message = "MESSAGE"

      Socket.cast(pid, message)

      assert_called_once(WebSockex.cast(^pid, _message))
    end

    test "should send the provided message" do
      patch(WebSockex, :cast, :ok)

      pid = :pid
      message = "MESSAGE"

      Socket.cast(pid, message)

      assert_called_once(WebSockex.cast(_pid, ^message))
    end
  end

  describe "BingX.Socket handle_connect/2" do
    test "should support delegation skip" do
      state = {SocketMock.Basic, :state}

      assert {:ok, _state} = Socket.handle_connect(:details, state)
    end

    test "should delegate to the interface module", context do
      # NOTE:
      # Patch does not patch apply calls and other BIFs...

      # %{state: state} = context
      #
      # Socket.handle_connect(:details, {SocketMock, state})
      # assert_called_once(SocketMock.handle_connect(^state))
    end

    test "should set the provided state by delegation" do
    end
  end

  describe "BingX.Socket handle_disconnect/2" do
    test "should support delegation skip" do
      state = {SocketMock.Basic, :state}

      assert {_status, _state} = Socket.handle_disconnect(:details, state)
    end

    test "should reconnect by default" do
      state = {SocketMock.Basic, :state}

      assert {:reconnect, _state} = Socket.handle_disconnect(:details, state)
    end

    test "should delegate to interface module" do
    end

    test "should set the provided state by delegation" do
    end

    test "should handle socket reconnect by delegation" do
    end

    test "should handle socket close by delegation" do
    end
  end

  describe "BingX.Socket handle_frame/2" do
    test "should send pongs on zipped pings" do
    end

    test "should delegate message to the interface module" do
    end

    test "should handle unknown text frames" do
    end
  end

  describe "BingX.Socket handle_info/2" do
    test "should support delegation skip" do
      state = {SocketMock.Basic, :state}

      assert {:ok, _state} = Socket.handle_info(:details, state)
    end

    test "should delegate message to the interface module" do
    end

    test "should handle message to send" do
    end

    test "should handle unknown messages" do
    end
  end

  describe "BingX.Socket handle_cast/2" do
    test "should support delegation skip" do
      state = {SocketMock.Basic, :state}

      assert {:ok, _state} = Socket.handle_cast(:details, state)
    end

    test "should delegate message to the interface module" do
    end

    test "should handle unknown messages" do
    end
  end
end
