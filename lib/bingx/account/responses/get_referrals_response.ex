defmodule BingX.Account.GetReferralsResponse do
  alias BingX.Account.ReferralInfo

  defstruct [:list, :total]

  def new(data) do 
    list = data["list"] || []

    %__MODULE__{
      list: Enum.map(list, & ReferralInfo.struct/1),
      total: length(list)
    }
  end
end
