defmodule BingX.User.GetReferralsResponse do
  alias BingX.User.ReferralInfo

  defstruct [list: [], total: 0]

  def new(%{} = data) do
    list = data["list"] || []

    %__MODULE__{
      list: Enum.map(list, &ReferralInfo.new/1),
      total: length(list)
    }
  end

  def new(_data), do: %__MODULE__{}
end
