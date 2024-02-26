defmodule BingX.API.InterpretatorsTest do
  use ExUnit.Case, async: true

  alias BingX.API.Interpretators

  describe "BingX.API.Interpretators to_internal_order_type/1" do
    test "should transform order types from external to internal API properly" do
      assert :market = Interpretators.to_internal_order_type("MARkEt")
      assert :trigger_market = Interpretators.to_internal_order_type("Trigger_Market")
      assert :stop_loss = Interpretators.to_internal_order_type("StOP")
      assert :take_profit = Interpretators.to_internal_order_type("Take_PROFIT")
      assert :limit = Interpretators.to_internal_order_type("LImiT")
      assert :stop_loss_market = Interpretators.to_internal_order_type("STOP_mARKET")
      assert :take_profit_market = Interpretators.to_internal_order_type("TAKE_PrOFIT_mARKET")
    end

    test "should omit unexpected values" do
      assert nil === Interpretators.to_internal_order_type("")
      assert nil === Interpretators.to_internal_order_type("Unknown")
      assert nil === Interpretators.to_internal_order_type(0)
    end
  end

  describe "BingX.API.Interpretators to_external_order_type/1" do
    test "should transform order types from internal to external API properly" do
      assert "MARKET" = Interpretators.to_external_order_type(:market)
      assert "TRIGGER_MARKET" = Interpretators.to_external_order_type(:trigger_market)
      assert "STOP" = Interpretators.to_external_order_type(:stop_loss)
      assert "TAKE_PROFIT" = Interpretators.to_external_order_type(:take_profit)
      assert "LIMIT" = Interpretators.to_external_order_type(:limit)
      assert "STOP_MARKET" = Interpretators.to_external_order_type(:stop_loss_market)
      assert "TAKE_PROFIT_MARKET" = Interpretators.to_external_order_type(:take_profit_market)
    end
  end

  describe "BingX.API.Interpretators to_internal_order_status/1" do
    test "should transform order statuses from external to internal API properly" do
      assert :placed = Interpretators.to_internal_order_status("neW")
      assert :triggered = Interpretators.to_internal_order_status("TriGGERED")
      assert :filled = Interpretators.to_internal_order_status("FillEd")
      assert :partially_filled = Interpretators.to_internal_order_status("PArtiALLY_FillEd")
      assert :canceled = Interpretators.to_internal_order_status("CANCElED")
      assert :expired = Interpretators.to_internal_order_status("EXPIred")
    end

    test "should omit unexpected values" do
      assert nil === Interpretators.to_internal_order_status("")
      assert nil === Interpretators.to_internal_order_status("Unknown")
      assert nil === Interpretators.to_internal_order_status(0)
    end
  end

  describe "BingX.API.Interpretators to_external_order_status/1" do
    test "should transform order statuses from internal to external API properly" do
      assert "NEW" = Interpretators.to_external_order_status(:placed)
      assert "TRIGGERED" = Interpretators.to_external_order_status(:triggered)
      assert "FILLED" = Interpretators.to_external_order_status(:filled)
      assert "PARTIALLY_FILLED" = Interpretators.to_external_order_status(:partially_filled)
      assert "CANCELED" = Interpretators.to_external_order_status(:canceled)
      assert "EXPIRED" = Interpretators.to_external_order_status(:expired)
    end
  end

  describe "BingX.API.Interpretators to_internal_position_side/1" do
    test "should transform position sides from external to internal API properly" do
      assert :long = Interpretators.to_internal_position_side("LOnG")
      assert :short = Interpretators.to_internal_position_side("sHORT")
      assert :both = Interpretators.to_internal_position_side("boTH")
    end

    test "should omit unexpected values" do
      assert nil === Interpretators.to_internal_position_side("")
      assert nil === Interpretators.to_internal_position_side("Unknown")
      assert nil === Interpretators.to_internal_position_side(0)
    end
  end

  describe "BingX.API.Interpretators to_external_position_side/1" do
    test "should transform position sides from internal to external API properly" do
      assert "LONG" = Interpretators.to_external_position_side(:long)
      assert "SHORT" = Interpretators.to_external_position_side(:short)
      assert "BOTH" = Interpretators.to_external_position_side(:both)
    end
  end

  describe "BingX.API.Interpretators to_internal_order_side/1" do
    test "should transform order sides from external to internal API properly" do
      assert :buy = Interpretators.to_internal_order_side("Buy")
      assert :sell = Interpretators.to_internal_order_side("SeLL")
    end

    test "should omit unexpected values" do
      assert nil === Interpretators.to_internal_order_side("")
      assert nil === Interpretators.to_internal_order_side("Unknown")
      assert nil === Interpretators.to_internal_order_side(0)
    end
  end

  describe "BingX.API.Interpretators to_external_order_side/1" do
    test "should transform order sides from internal to external API properly" do
      assert "BUY" = Interpretators.to_external_order_side(:buy)
      assert "SELL" = Interpretators.to_external_order_side(:sell)
    end
  end

  describe "BingX.API.Interpretators to_internal_working_type/1" do
    test "should transform working types from external to internal API properly" do
      assert :index_price = Interpretators.to_internal_working_type("INDEX_PRICE")
      assert :mark_price = Interpretators.to_internal_working_type("MARK_PRICE")
      assert :contract_price = Interpretators.to_internal_working_type("CONTRACT_PRICE")
    end

    test "should omit unexpected values" do
      assert nil === Interpretators.to_internal_working_type("")
      assert nil === Interpretators.to_internal_working_type("Unknown")
      assert nil === Interpretators.to_internal_working_type(0)
    end
  end

  describe "BingX.API.Interpretators to_external_working_types/1" do
    test "should transform working types from internal to external API properly" do
      assert "INDEX_PRICE" = Interpretators.to_external_working_type(:index_price)
      assert "MARK_PRICE" = Interpretators.to_external_working_type(:mark_price)
      assert "CONTRACT_PRICE" = Interpretators.to_external_working_type(:contract_price)
    end
  end

  describe "BingX.API.Interpretators interp_as_float/1" do
    test "should transform numbers to float" do
      assert 25.0 = Interpretators.interp_as_float(25)
    end

    test "should parse binary based numbers to float" do
      assert +0.0 = Interpretators.interp_as_float("0")
      assert 2.001 = Interpretators.interp_as_float("2.001")
    end

    test "should omit unexpected values" do
      assert nil === Interpretators.interp_as_float("_")
      assert nil === Interpretators.interp_as_float("AA25")
      assert nil === Interpretators.interp_as_float(nil)
    end
  end

  describe "BingX.API.Interpretators interp_as_binary/1" do
    test "should return original binaries" do
      assert "25" = Interpretators.interp_as_binary("25")
      assert "" = Interpretators.interp_as_binary("")
    end

    test "should transform numbers as binaries" do
      assert "25.01" = Interpretators.interp_as_binary(25.01)
      assert "25" = Interpretators.interp_as_binary(25)
      assert "-1" = Interpretators.interp_as_binary(-1)
    end
  end

  describe "BingX.API.Interpretators interp_as_binary/2" do
    test "should return original binaries" do
      assert "25" = Interpretators.interp_as_binary("25", empty?: true)
      assert "___" = Interpretators.interp_as_binary("___", empty?: true)
      assert "" = Interpretators.interp_as_binary("", empty?: true)

      assert "25" = Interpretators.interp_as_binary("25", empty?: false)
      assert "___" = Interpretators.interp_as_binary("___", empty?: false)
    end

    test "should return nil when passed not allowed empty binary" do
      assert nil === Interpretators.interp_as_binary("", empty?: false)
    end
  end
end
