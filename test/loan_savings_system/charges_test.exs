defmodule LoanSavingsSystem.ChargesTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Charges

  describe "tbl_charge" do
    alias LoanSavingsSystem.Charges.Charge

    @valid_attrs %{chargeAmount: 120.5, chargeName: "some chargeName", chargeType: "some chargeType", clientId: 42, currency: "some currency", currencyId: 42, isPenalty: true}
    @update_attrs %{chargeAmount: 456.7, chargeName: "some updated chargeName", chargeType: "some updated chargeType", clientId: 43, currency: "some updated currency", currencyId: 43, isPenalty: false}
    @invalid_attrs %{chargeAmount: nil, chargeName: nil, chargeType: nil, clientId: nil, currency: nil, currencyId: nil, isPenalty: nil}

    def charge_fixture(attrs \\ %{}) do
      {:ok, charge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Charges.create_charge()

      charge
    end

    test "list_tbl_charge/0 returns all tbl_charge" do
      charge = charge_fixture()
      assert Charges.list_tbl_charge() == [charge]
    end

    test "get_charge!/1 returns the charge with given id" do
      charge = charge_fixture()
      assert Charges.get_charge!(charge.id) == charge
    end

    test "create_charge/1 with valid data creates a charge" do
      assert {:ok, %Charge{} = charge} = Charges.create_charge(@valid_attrs)
      assert charge.chargeAmount == 120.5
      assert charge.chargeName == "some chargeName"
      assert charge.chargeType == "some chargeType"
      assert charge.clientId == 42
      assert charge.currency == "some currency"
      assert charge.currencyId == 42
      assert charge.isPenalty == true
    end

    test "create_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Charges.create_charge(@invalid_attrs)
    end

    test "update_charge/2 with valid data updates the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{} = charge} = Charges.update_charge(charge, @update_attrs)
      assert charge.chargeAmount == 456.7
      assert charge.chargeName == "some updated chargeName"
      assert charge.chargeType == "some updated chargeType"
      assert charge.clientId == 43
      assert charge.currency == "some updated currency"
      assert charge.currencyId == 43
      assert charge.isPenalty == false
    end

    test "update_charge/2 with invalid data returns error changeset" do
      charge = charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Charges.update_charge(charge, @invalid_attrs)
      assert charge == Charges.get_charge!(charge.id)
    end

    test "delete_charge/1 deletes the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{}} = Charges.delete_charge(charge)
      assert_raise Ecto.NoResultsError, fn -> Charges.get_charge!(charge.id) end
    end

    test "change_charge/1 returns a charge changeset" do
      charge = charge_fixture()
      assert %Ecto.Changeset{} = Charges.change_charge(charge)
    end
  end

  describe "tbl_account_charge" do
    alias LoanSavingsSystem.Charges.AccountCharge

    @valid_attrs %{accountId: 42, amountCharged: 42, balance: 120.5, chargeId: 42, dateCharged: ~D[2010-04-17], datePaid: ~D[2010-04-17], isPaid: true, userId: 42}
    @update_attrs %{accountId: 43, amountCharged: 43, balance: 456.7, chargeId: 43, dateCharged: ~D[2011-05-18], datePaid: ~D[2011-05-18], isPaid: false, userId: 43}
    @invalid_attrs %{accountId: nil, amountCharged: nil, balance: nil, chargeId: nil, dateCharged: nil, datePaid: nil, isPaid: nil, userId: nil}

    def account_charge_fixture(attrs \\ %{}) do
      {:ok, account_charge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Charges.create_account_charge()

      account_charge
    end

    test "list_tbl_account_charge/0 returns all tbl_account_charge" do
      account_charge = account_charge_fixture()
      assert Charges.list_tbl_account_charge() == [account_charge]
    end

    test "get_account_charge!/1 returns the account_charge with given id" do
      account_charge = account_charge_fixture()
      assert Charges.get_account_charge!(account_charge.id) == account_charge
    end

    test "create_account_charge/1 with valid data creates a account_charge" do
      assert {:ok, %AccountCharge{} = account_charge} = Charges.create_account_charge(@valid_attrs)
      assert account_charge.accountId == 42
      assert account_charge.amountCharged == 42
      assert account_charge.balance == 120.5
      assert account_charge.chargeId == 42
      assert account_charge.dateCharged == ~D[2010-04-17]
      assert account_charge.datePaid == ~D[2010-04-17]
      assert account_charge.isPaid == true
      assert account_charge.userId == 42
    end

    test "create_account_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Charges.create_account_charge(@invalid_attrs)
    end

    test "update_account_charge/2 with valid data updates the account_charge" do
      account_charge = account_charge_fixture()
      assert {:ok, %AccountCharge{} = account_charge} = Charges.update_account_charge(account_charge, @update_attrs)
      assert account_charge.accountId == 43
      assert account_charge.amountCharged == 43
      assert account_charge.balance == 456.7
      assert account_charge.chargeId == 43
      assert account_charge.dateCharged == ~D[2011-05-18]
      assert account_charge.datePaid == ~D[2011-05-18]
      assert account_charge.isPaid == false
      assert account_charge.userId == 43
    end

    test "update_account_charge/2 with invalid data returns error changeset" do
      account_charge = account_charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Charges.update_account_charge(account_charge, @invalid_attrs)
      assert account_charge == Charges.get_account_charge!(account_charge.id)
    end

    test "delete_account_charge/1 deletes the account_charge" do
      account_charge = account_charge_fixture()
      assert {:ok, %AccountCharge{}} = Charges.delete_account_charge(account_charge)
      assert_raise Ecto.NoResultsError, fn -> Charges.get_account_charge!(account_charge.id) end
    end

    test "change_account_charge/1 returns a account_charge changeset" do
      account_charge = account_charge_fixture()
      assert %Ecto.Changeset{} = Charges.change_account_charge(account_charge)
    end
  end
end
