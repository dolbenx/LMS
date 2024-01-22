defmodule LoanSavingsSystem.CustomerPayoutsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.CustomerPayouts

  describe "tbl_customerpayouts" do
    alias LoanSavingsSystem.CustomerPayouts.CustomerPayout

    @valid_attrs %{amount: 120.5, fixedDepositId: 42, orderRef: "some orderRef", payoutRequest: "some payoutRequest", payoutResponse: "some payoutResponse", payoutType: "some payoutType", status: "some status", transactionDate: ~D[2010-04-17], transactionId: 42, userId: 42}
    @update_attrs %{amount: 456.7, fixedDepositId: 43, orderRef: "some updated orderRef", payoutRequest: "some updated payoutRequest", payoutResponse: "some updated payoutResponse", payoutType: "some updated payoutType", status: "some updated status", transactionDate: ~D[2011-05-18], transactionId: 43, userId: 43}
    @invalid_attrs %{amount: nil, fixedDepositId: nil, orderRef: nil, payoutRequest: nil, payoutResponse: nil, payoutType: nil, status: nil, transactionDate: nil, transactionId: nil, userId: nil}

    def customer_payout_fixture(attrs \\ %{}) do
      {:ok, customer_payout} =
        attrs
        |> Enum.into(@valid_attrs)
        |> CustomerPayouts.create_customer_payout()

      customer_payout
    end

    test "list_tbl_customerpayouts/0 returns all tbl_customerpayouts" do
      customer_payout = customer_payout_fixture()
      assert CustomerPayouts.list_tbl_customerpayouts() == [customer_payout]
    end

    test "get_customer_payout!/1 returns the customer_payout with given id" do
      customer_payout = customer_payout_fixture()
      assert CustomerPayouts.get_customer_payout!(customer_payout.id) == customer_payout
    end

    test "create_customer_payout/1 with valid data creates a customer_payout" do
      assert {:ok, %CustomerPayout{} = customer_payout} = CustomerPayouts.create_customer_payout(@valid_attrs)
      assert customer_payout.amount == 120.5
      assert customer_payout.fixedDepositId == 42
      assert customer_payout.orderRef == "some orderRef"
      assert customer_payout.payoutRequest == "some payoutRequest"
      assert customer_payout.payoutResponse == "some payoutResponse"
      assert customer_payout.payoutType == "some payoutType"
      assert customer_payout.status == "some status"
      assert customer_payout.transactionDate == ~D[2010-04-17]
      assert customer_payout.transactionId == 42
      assert customer_payout.userId == 42
    end

    test "create_customer_payout/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = CustomerPayouts.create_customer_payout(@invalid_attrs)
    end

    test "update_customer_payout/2 with valid data updates the customer_payout" do
      customer_payout = customer_payout_fixture()
      assert {:ok, %CustomerPayout{} = customer_payout} = CustomerPayouts.update_customer_payout(customer_payout, @update_attrs)
      assert customer_payout.amount == 456.7
      assert customer_payout.fixedDepositId == 43
      assert customer_payout.orderRef == "some updated orderRef"
      assert customer_payout.payoutRequest == "some updated payoutRequest"
      assert customer_payout.payoutResponse == "some updated payoutResponse"
      assert customer_payout.payoutType == "some updated payoutType"
      assert customer_payout.status == "some updated status"
      assert customer_payout.transactionDate == ~D[2011-05-18]
      assert customer_payout.transactionId == 43
      assert customer_payout.userId == 43
    end

    test "update_customer_payout/2 with invalid data returns error changeset" do
      customer_payout = customer_payout_fixture()
      assert {:error, %Ecto.Changeset{}} = CustomerPayouts.update_customer_payout(customer_payout, @invalid_attrs)
      assert customer_payout == CustomerPayouts.get_customer_payout!(customer_payout.id)
    end

    test "delete_customer_payout/1 deletes the customer_payout" do
      customer_payout = customer_payout_fixture()
      assert {:ok, %CustomerPayout{}} = CustomerPayouts.delete_customer_payout(customer_payout)
      assert_raise Ecto.NoResultsError, fn -> CustomerPayouts.get_customer_payout!(customer_payout.id) end
    end

    test "change_customer_payout/1 returns a customer_payout changeset" do
      customer_payout = customer_payout_fixture()
      assert %Ecto.Changeset{} = CustomerPayouts.change_customer_payout(customer_payout)
    end
  end
end
