defmodule BingX.User.GetReferralResponse do
  alias BingX.User.ReferralInfo

  defstruct ReferralInfo.fields()

  def new(data), do: ReferralInfo.cast(data, as: __MODULE__)
end
