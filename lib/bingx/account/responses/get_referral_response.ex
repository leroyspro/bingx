defmodule BingX.Account.GetReferralResponse do
  alias BingX.Account.ReferralInfo

  defstruct ReferralInfo.fields()

  def new(data), do: ReferralInfo.cast(data, as: __MODULE__)
end
