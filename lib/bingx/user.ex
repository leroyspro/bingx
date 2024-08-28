defmodule BingX.User do
  import BingX.HTTP.Client, only: [signed_request: 5]

  alias BingX.User.{GetReferralsResponse, GetReferralResponse}
  alias BingX.HTTP.Response

  @api_scope "/openApi/agent/v1/account"

  @get_referrals_path @api_scope <> "/inviteAccountList"
  @get_referral_path @api_scope <> "/inviteRelationCheck"

  def get_referral(
        user_id,
        api_key,
        secret_key
      )
      when is_binary(user_id) or is_integer(user_id) and
             is_binary(api_key) and
             is_binary(secret_key) do
    with(
      {:ok, resp} <- do_get_referral(user_id, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, GetReferralResponse.new(payload)}
    end
  end

  def get_referrals(
        page_index \\ 0,
        page_size \\ 200,
        start_time \\ nil,
        end_time \\ nil,
        api_key,
        secret_key
      )
      when is_integer(page_index) and
             is_integer(page_size) and
             (is_integer(start_time) or start_time == nil) and
             (is_integer(end_time) or end_time == nil) and
             is_binary(api_key) and
             is_binary(secret_key) do
    with(
      {:ok, resp} <- do_get_referrals(page_index, page_size, start_time, end_time, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, GetReferralsResponse.new(payload)}
    end
  end

  defp do_get_referral(user_id, api_key, secret_key) do
    params = %{"uid" => user_id}
    signed_request(:get, @get_referral_path, api_key, secret_key, params: params)
  end

  defp do_get_referrals(page_index, page_size, start_time, end_time, api_key, secret_key) do
    params =
      %{
        "pageIndex" => page_index,
        "pageSize" => page_size
      }
      |> maybe_add_param("startTime", start_time)
      |> maybe_add_param("endTime", end_time)

    signed_request(:get, @get_referrals_path, api_key, secret_key, params: params)
  end

  defp maybe_add_param(params, _key, nil), do: params

  defp maybe_add_param(params, key, value) do
    Map.put(params, key, value)
  end
end
