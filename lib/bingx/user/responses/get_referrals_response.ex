defmodule BingX.User.GetReferralsResponse do
  alias BingX.User.ReferralInfo

  defstruct [:list, :total]

  def new(data) do
    list = data["list"] || []

    %__MODULE__{
      list: Enum.map(list, &ReferralInfo.new/1),
      total: length(list)
    }
  end
end
