defmodule LoanSavingsSystem.SavingsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Savings

  describe "tbl_fixed_deposits" do
    alias LoanSavingsSystem.Savings.FixedDeposits

    @valid_attrs %{"": "some ", annual_interest: "some annual_interest", c: "some c", currency: "some currency", currency_decimals: "some currency_decimals", deposit_fee_amount: "some deposit_fee_amount", fixed_period_days: "some fixed_period_days", savings_product_id: 42, year_length_days: "some year_length_days"}
    @update_attrs %{"": "some updated ", annual_interest: "some updated annual_interest", c: "some updated c", currency: "some updated currency", currency_decimals: "some updated currency_decimals", deposit_fee_amount: "some updated deposit_fee_amount", fixed_period_days: "some updated fixed_period_days", savings_product_id: 43, year_length_days: "some updated year_length_days"}
    @invalid_attrs %{"": nil, annual_interest: nil, c: nil, currency: nil, currency_decimals: nil, deposit_fee_amount: nil, fixed_period_days: nil, savings_product_id: nil, year_length_days: nil}

    def fixed_deposits_fixture(attrs \\ %{}) do
      {:ok, fixed_deposits} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Savings.create_fixed_deposits()

      fixed_deposits
    end

    test "list_tbl_fixed_deposits/0 returns all tbl_fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert Savings.list_tbl_fixed_deposits() == [fixed_deposits]
    end

    test "get_fixed_deposits!/1 returns the fixed_deposits with given id" do
      fixed_deposits = fixed_deposits_fixture()
      assert Savings.get_fixed_deposits!(fixed_deposits.id) == fixed_deposits
    end

    test "create_fixed_deposits/1 with valid data creates a fixed_deposits" do
      assert {:ok, %FixedDeposits{} = fixed_deposits} = Savings.create_fixed_deposits(@valid_attrs)
      assert fixed_deposits. == "some "
      assert fixed_deposits.annual_interest == "some annual_interest"
      assert fixed_deposits.c == "some c"
      assert fixed_deposits.currency == "some currency"
      assert fixed_deposits.currency_decimals == "some currency_decimals"
      assert fixed_deposits.deposit_fee_amount == "some deposit_fee_amount"
      assert fixed_deposits.fixed_period_days == "some fixed_period_days"
      assert fixed_deposits.savings_product_id == 42
      assert fixed_deposits.year_length_days == "some year_length_days"
    end

    test "create_fixed_deposits/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Savings.create_fixed_deposits(@invalid_attrs)
    end

    test "update_fixed_deposits/2 with valid data updates the fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:ok, %FixedDeposits{} = fixed_deposits} = Savings.update_fixed_deposits(fixed_deposits, @update_attrs)
      assert fixed_deposits. == "some updated "
      assert fixed_deposits.annual_interest == "some updated annual_interest"
      assert fixed_deposits.c == "some updated c"
      assert fixed_deposits.currency == "some updated currency"
      assert fixed_deposits.currency_decimals == "some updated currency_decimals"
      assert fixed_deposits.deposit_fee_amount == "some updated deposit_fee_amount"
      assert fixed_deposits.fixed_period_days == "some updated fixed_period_days"
      assert fixed_deposits.savings_product_id == 43
      assert fixed_deposits.year_length_days == "some updated year_length_days"
    end

    test "update_fixed_deposits/2 with invalid data returns error changeset" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:error, %Ecto.Changeset{}} = Savings.update_fixed_deposits(fixed_deposits, @invalid_attrs)
      assert fixed_deposits == Savings.get_fixed_deposits!(fixed_deposits.id)
    end

    test "delete_fixed_deposits/1 deletes the fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:ok, %FixedDeposits{}} = Savings.delete_fixed_deposits(fixed_deposits)
      assert_raise Ecto.NoResultsError, fn -> Savings.get_fixed_deposits!(fixed_deposits.id) end
    end

    test "change_fixed_deposits/1 returns a fixed_deposits changeset" do
      fixed_deposits = fixed_deposits_fixture()
      assert %Ecto.Changeset{} = Savings.change_fixed_deposits(fixed_deposits)
    end
  end

  describe "tbl_fixed_deposits" do
    alias LoanSavingsSystem.Savings.FixedDeposits

    @valid_attrs %{"": "some ", account_id: 42, annual_interest: "some annual_interest", client_id: "some client_id", currency: "some currency", currency_decimals: "some currency_decimals", customer_id: 42, deposit_fee_amount: "some deposit_fee_amount", divestment_id: 42, fixed_period_days: "some fixed_period_days", number_disburse: "some number_disburse", principal: "some principal", savings_product_id: 42, status: "some status", year_length_days: "some year_length_days"}
    @update_attrs %{"": "some updated ", account_id: 43, annual_interest: "some updated annual_interest", client_id: "some updated client_id", currency: "some updated currency", currency_decimals: "some updated currency_decimals", customer_id: 43, deposit_fee_amount: "some updated deposit_fee_amount", divestment_id: 43, fixed_period_days: "some updated fixed_period_days", number_disburse: "some updated number_disburse", principal: "some updated principal", savings_product_id: 43, status: "some updated status", year_length_days: "some updated year_length_days"}
    @invalid_attrs %{"": nil, account_id: nil, annual_interest: nil, client_id: nil, currency: nil, currency_decimals: nil, customer_id: nil, deposit_fee_amount: nil, divestment_id: nil, fixed_period_days: nil, number_disburse: nil, principal: nil, savings_product_id: nil, status: nil, year_length_days: nil}

    def fixed_deposits_fixture(attrs \\ %{}) do
      {:ok, fixed_deposits} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Savings.create_fixed_deposits()

      fixed_deposits
    end

    test "list_tbl_fixed_deposits/0 returns all tbl_fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert Savings.list_tbl_fixed_deposits() == [fixed_deposits]
    end

    test "get_fixed_deposits!/1 returns the fixed_deposits with given id" do
      fixed_deposits = fixed_deposits_fixture()
      assert Savings.get_fixed_deposits!(fixed_deposits.id) == fixed_deposits
    end

    test "create_fixed_deposits/1 with valid data creates a fixed_deposits" do
      assert {:ok, %FixedDeposits{} = fixed_deposits} = Savings.create_fixed_deposits(@valid_attrs)
      assert fixed_deposits. == "some "
      assert fixed_deposits.account_id == 42
      assert fixed_deposits.annual_interest == "some annual_interest"
      assert fixed_deposits.client_id == "some client_id"
      assert fixed_deposits.currency == "some currency"
      assert fixed_deposits.currency_decimals == "some currency_decimals"
      assert fixed_deposits.customer_id == 42
      assert fixed_deposits.deposit_fee_amount == "some deposit_fee_amount"
      assert fixed_deposits.divestment_id == 42
      assert fixed_deposits.fixed_period_days == "some fixed_period_days"
      assert fixed_deposits.number_disburse == "some number_disburse"
      assert fixed_deposits.principal == "some principal"
      assert fixed_deposits.savings_product_id == 42
      assert fixed_deposits.status == "some status"
      assert fixed_deposits.year_length_days == "some year_length_days"
    end

    test "create_fixed_deposits/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Savings.create_fixed_deposits(@invalid_attrs)
    end

    test "update_fixed_deposits/2 with valid data updates the fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:ok, %FixedDeposits{} = fixed_deposits} = Savings.update_fixed_deposits(fixed_deposits, @update_attrs)
      assert fixed_deposits. == "some updated "
      assert fixed_deposits.account_id == 43
      assert fixed_deposits.annual_interest == "some updated annual_interest"
      assert fixed_deposits.client_id == "some updated client_id"
      assert fixed_deposits.currency == "some updated currency"
      assert fixed_deposits.currency_decimals == "some updated currency_decimals"
      assert fixed_deposits.customer_id == 43
      assert fixed_deposits.deposit_fee_amount == "some updated deposit_fee_amount"
      assert fixed_deposits.divestment_id == 43
      assert fixed_deposits.fixed_period_days == "some updated fixed_period_days"
      assert fixed_deposits.number_disburse == "some updated number_disburse"
      assert fixed_deposits.principal == "some updated principal"
      assert fixed_deposits.savings_product_id == 43
      assert fixed_deposits.status == "some updated status"
      assert fixed_deposits.year_length_days == "some updated year_length_days"
    end

    test "update_fixed_deposits/2 with invalid data returns error changeset" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:error, %Ecto.Changeset{}} = Savings.update_fixed_deposits(fixed_deposits, @invalid_attrs)
      assert fixed_deposits == Savings.get_fixed_deposits!(fixed_deposits.id)
    end

    test "delete_fixed_deposits/1 deletes the fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:ok, %FixedDeposits{}} = Savings.delete_fixed_deposits(fixed_deposits)
      assert_raise Ecto.NoResultsError, fn -> Savings.get_fixed_deposits!(fixed_deposits.id) end
    end

    test "change_fixed_deposits/1 returns a fixed_deposits changeset" do
      fixed_deposits = fixed_deposits_fixture()
      assert %Ecto.Changeset{} = Savings.change_fixed_deposits(fixed_deposits)
    end
  end

  describe "tbl_fixed_deposits" do
    alias LoanSavingsSystem.Savings.FixedDeposits

    @valid_attrs %{account_id: 42, annual_interest: "some annual_interest", client_id: "some client_id", currency: "some currency", currency_decimals: "some currency_decimals", customer_id: 42, deposit_fee_amount: "some deposit_fee_amount", divestment_id: 42, fixed_period_days: "some fixed_period_days", number_disburse: "some number_disburse", principal: "some principal", savings_product_id: 42, status: "some status", year_length_days: "some year_length_days"}
    @update_attrs %{account_id: 43, annual_interest: "some updated annual_interest", client_id: "some updated client_id", currency: "some updated currency", currency_decimals: "some updated currency_decimals", customer_id: 43, deposit_fee_amount: "some updated deposit_fee_amount", divestment_id: 43, fixed_period_days: "some updated fixed_period_days", number_disburse: "some updated number_disburse", principal: "some updated principal", savings_product_id: 43, status: "some updated status", year_length_days: "some updated year_length_days"}
    @invalid_attrs %{account_id: nil, annual_interest: nil, client_id: nil, currency: nil, currency_decimals: nil, customer_id: nil, deposit_fee_amount: nil, divestment_id: nil, fixed_period_days: nil, number_disburse: nil, principal: nil, savings_product_id: nil, status: nil, year_length_days: nil}

    def fixed_deposits_fixture(attrs \\ %{}) do
      {:ok, fixed_deposits} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Savings.create_fixed_deposits()

      fixed_deposits
    end

    test "list_tbl_fixed_deposits/0 returns all tbl_fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert Savings.list_tbl_fixed_deposits() == [fixed_deposits]
    end

    test "get_fixed_deposits!/1 returns the fixed_deposits with given id" do
      fixed_deposits = fixed_deposits_fixture()
      assert Savings.get_fixed_deposits!(fixed_deposits.id) == fixed_deposits
    end

    test "create_fixed_deposits/1 with valid data creates a fixed_deposits" do
      assert {:ok, %FixedDeposits{} = fixed_deposits} = Savings.create_fixed_deposits(@valid_attrs)
      assert fixed_deposits.account_id == 42
      assert fixed_deposits.annual_interest == "some annual_interest"
      assert fixed_deposits.client_id == "some client_id"
      assert fixed_deposits.currency == "some currency"
      assert fixed_deposits.currency_decimals == "some currency_decimals"
      assert fixed_deposits.customer_id == 42
      assert fixed_deposits.deposit_fee_amount == "some deposit_fee_amount"
      assert fixed_deposits.divestment_id == 42
      assert fixed_deposits.fixed_period_days == "some fixed_period_days"
      assert fixed_deposits.number_disburse == "some number_disburse"
      assert fixed_deposits.principal == "some principal"
      assert fixed_deposits.savings_product_id == 42
      assert fixed_deposits.status == "some status"
      assert fixed_deposits.year_length_days == "some year_length_days"
    end

    test "create_fixed_deposits/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Savings.create_fixed_deposits(@invalid_attrs)
    end

    test "update_fixed_deposits/2 with valid data updates the fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:ok, %FixedDeposits{} = fixed_deposits} = Savings.update_fixed_deposits(fixed_deposits, @update_attrs)
      assert fixed_deposits.account_id == 43
      assert fixed_deposits.annual_interest == "some updated annual_interest"
      assert fixed_deposits.client_id == "some updated client_id"
      assert fixed_deposits.currency == "some updated currency"
      assert fixed_deposits.currency_decimals == "some updated currency_decimals"
      assert fixed_deposits.customer_id == 43
      assert fixed_deposits.deposit_fee_amount == "some updated deposit_fee_amount"
      assert fixed_deposits.divestment_id == 43
      assert fixed_deposits.fixed_period_days == "some updated fixed_period_days"
      assert fixed_deposits.number_disburse == "some updated number_disburse"
      assert fixed_deposits.principal == "some updated principal"
      assert fixed_deposits.savings_product_id == 43
      assert fixed_deposits.status == "some updated status"
      assert fixed_deposits.year_length_days == "some updated year_length_days"
    end

    test "update_fixed_deposits/2 with invalid data returns error changeset" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:error, %Ecto.Changeset{}} = Savings.update_fixed_deposits(fixed_deposits, @invalid_attrs)
      assert fixed_deposits == Savings.get_fixed_deposits!(fixed_deposits.id)
    end

    test "delete_fixed_deposits/1 deletes the fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:ok, %FixedDeposits{}} = Savings.delete_fixed_deposits(fixed_deposits)
      assert_raise Ecto.NoResultsError, fn -> Savings.get_fixed_deposits!(fixed_deposits.id) end
    end

    test "change_fixed_deposits/1 returns a fixed_deposits changeset" do
      fixed_deposits = fixed_deposits_fixture()
      assert %Ecto.Changeset{} = Savings.change_fixed_deposits(fixed_deposits)
    end
  end
end
