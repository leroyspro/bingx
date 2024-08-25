defmodule BingX.Account.ReferralInfo do
  import BingX.Helpers, only: [get_and_transform: 3]
  import BingX.Interpretators

  @fields [
    :balance,
    :benefit_expiration,
    :benefit_ratio,
    :fee_ratio,
    :current_benefit,
    :deposit,
    :direct_referral?,
    :invite_code,
    :invite_result,
    :inviter_sid,
    :verified_kyc?,
    :own_invite_code,
    :registration_date,
    :has_trades?,
    :user_id,
    :user_level
  ]

  defstruct @fields

  def fields(), do: @fields

  def cast(data, as: module) do
    params = %{
      balance: get_and_transform(data, "balanceVolume", &interp_as_float/1),
      benefit_expiration: get_and_transform(data, "benefitExpiration", &interp_as_int/1),
      benefit_ratio: get_and_transform(data, "benefitRatio", &interp_as_int/1),
      fee_ratio: get_and_transform(data, "commissionRatio", &interp_as_int/1),
      current_benefit: get_and_transform(data, "currentBenefit", &interp_as_int/1),
      deposit: get_and_transform(data, "deposit", &interp_as_boolean/1),
      direct_referral?: get_and_transform(data, "directInvitation", &interp_as_boolean/1),
      invite_code: get_and_transform(data, "inviteCode", &interp_as_binary/1),
      invite_result: get_and_transform(data, "inviteResult", &interp_as_boolean/1),
      inviter_sid: get_and_transform(data, "inviterSid", &interp_as_binary/1),
      verified_kyc?: get_and_transform(data, "kycResult", &interp_as_boolean/1),
      own_invite_code: get_and_transform(data, "ownInviteCode", &interp_as_binary/1),
      registration_date: get_and_transform(data, "registerDateTime", &interp_as_int/1),
      has_trades?: get_and_transform(data, "trade", &interp_as_boolean/1),
      user_id: get_and_transform(data, "uid", &interp_as_binary/1),
      user_level: get_and_transform(data, "userLevel", &interp_as_binary/1)
    }

    struct(module, params)
  end

  @spec new(map()) :: %__MODULE__{}
  def new(data), do: cast(data, as: __MODULE__)
end
