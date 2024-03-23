defmodule BingX.HTTP.Error do
  @moduledoc """
  This module defines `Exception` which is used to specify HTTP related errors.
  """

  defexception [:message]
end
