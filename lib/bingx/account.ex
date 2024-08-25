defmodule BingX.Account do
  import BingX.HTTP.Client, only: [signed_request: 5]

  alias BingX.Account.GetReferralsResponse
  alias BingX.HTTP.Response

  @invite_account_list_path "/openApi/agent/v1/account/inviteAccountList"

  def get_referrals(
    page_index \\ 0, 
    page_size \\ 200, 
    start_time \\ nil, 
    end_time \\ nil,
    api_key, 
    secret_key
  ) when is_binary(api_key) and is_binary(secret_key) do
    args = %{
      page_index: page_index,
      page_size: page_size,
      start_time: start_time,
      end_time: end_time
    }
    
    with(
      {:ok, resp} <- do_get_account_invite_list(args, api_key, secret_key),
      {:ok, payload} <- Response.process_response(resp)
    ) do
      {:ok, GetReferralsResponse.new(payload)}
    end
  end

  defp do_get_account_invite_list(args, api_key, secret_key) do
    params = 
      %{
        "pageIndex" => args.page_index, 
        "pageSize" => args.page_size
      }
      |> maybe_add_param("startTime", args, :start_time)
      |> maybe_add_param("endTime", args, :end_time)

    signed_request(:get, @invite_account_list_path, api_key, secret_key, params: params)
  end

  defp maybe_add_param(params, param, args, key) do
    value = Map.get(args, key)
  
    if value == nil do
      params
    else
      Map.put(params, param, value)
    end
  end
end

