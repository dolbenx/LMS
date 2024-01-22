defmodule LoanSavingsSystem.FixedDepositTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.FixedDeposit

  describe "tbl_fixed_deposit" do
    alias LoanSavingsSystem.FixedDeposit.FixedDeposits

    @valid_attrs %{accountId: 42, accruedInterest: 120.5, clientId: 42, currency: "some currency", currencyDecimals: 42, currencyId: 42, divestmentPackageId: 42, endDate: ~D[2010-04-17], expectedInterest: 120.5, fixedPeriod: 42, fixedPeriodType: "some fixedPeriodType", interestRate: 120.5, interestRateType: "some interestRateType", isDivested: true, isMatured: true, principalAmount: 120.5, productId: 42, startDate: ~D[2010-04-17], totalAmountPaidOut: 120.5, totalDepositCharge: 120.5, totalPenalties: 120.5, totalWithdrawalCharge: 120.5, userId: 42, userRoleId: 42, yearLengthInDays: 42}
    @update_attrs %{accountId: 43, accruedInterest: 456.7, clientId: 43, currency: "some updated currency", currencyDecimals: 43, currencyId: 43, divestmentPackageId: 43, endDate: ~D[2011-05-18], expectedInterest: 456.7, fixedPeriod: 43, fixedPeriodType: "some updated fixedPeriodType", interestRate: 456.7, interestRateType: "some updated interestRateType", isDivested: false, isMatured: false, principalAmount: 456.7, productId: 43, startDate: ~D[2011-05-18], totalAmountPaidOut: 456.7, totalDepositCharge: 456.7, totalPenalties: 456.7, totalWithdrawalCharge: 456.7, userId: 43, userRoleId: 43, yearLengthInDays: 43}
    @invalid_attrs %{accountId: nil, accruedInterest: nil, clientId: nil, currency: nil, currencyDecimals: nil, currencyId: nil, divestmentPackageId: nil, endDate: nil, expectedInterest: nil, fixedPeriod: nil, fixedPeriodType: nil, interestRate: nil, interestRateType: nil, isDivested: nil, isMatured: nil, principalAmount: nil, productId: nil, startDate: nil, totalAmountPaidOut: nil, totalDepositCharge: nil, totalPenalties: nil, totalWithdrawalCharge: nil, userId: nil, userRoleId: nil, yearLengthInDays: nil}

    def fixed_deposits_fixture(attrs \\ %{}) do
      {:ok, fixed_deposits} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FixedDeposit.create_fixed_deposits()

      fixed_deposits
    end

    test "list_tbl_fixed_deposit/0 returns all tbl_fixed_deposit" do
      fixed_deposits = fixed_deposits_fixture()
      assert FixedDeposit.list_tbl_fixed_deposit() == [fixed_deposits]
    end

    test "get_fixed_deposits!/1 returns the fixed_deposits with given id" do
      fixed_deposits = fixed_deposits_fixture()
      assert FixedDeposit.get_fixed_deposits!(fixed_deposits.id) == fixed_deposits
    end

    test "create_fixed_deposits/1 with valid data creates a fixed_deposits" do
      assert {:ok, %FixedDeposits{} = fixed_deposits} = FixedDeposit.create_fixed_deposits(@valid_attrs)
      assert fixed_deposits.accountId == 42
      assert fixed_deposits.accruedInterest == 120.5
      assert fixed_deposits.clientId == 42
      assert fixed_deposits.currency == "some currency"
      assert fixed_deposits.currencyDecimals == 42
      assert fixed_deposits.currencyId == 42
      assert fixed_deposits.divestmentPackageId == 42
      assert fixed_deposits.endDate == ~D[2010-04-17]
      assert fixed_deposits.expectedInterest == 120.5
      assert fixed_deposits.fixedPeriod == 42
      assert fixed_deposits.fixedPeriodType == "some fixedPeriodType"
      assert fixed_deposits.interestRate == 120.5
      assert fixed_deposits.interestRateType == "some interestRateType"
      assert fixed_deposits.isDivested == true
      assert fixed_deposits.isMatured == true
      assert fixed_deposits.principalAmount == 120.5
      assert fixed_deposits.productId == 42
      assert fixed_deposits.startDate == ~D[2010-04-17]
      assert fixed_deposits.totalAmountPaidOut == 120.5
      assert fixed_deposits.totalDepositCharge == 120.5
      assert fixed_deposits.totalPenalties == 120.5
      assert fixed_deposits.totalWithdrawalCharge == 120.5
      assert fixed_deposits.userId == 42
      assert fixed_deposits.userRoleId == 42
      assert fixed_deposits.yearLengthInDays == 42
    end

    test "create_fixed_deposits/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FixedDeposit.create_fixed_deposits(@invalid_attrs)
    end

    test "update_fixed_deposits/2 with valid data updates the fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:ok, %FixedDeposits{} = fixed_deposits} = FixedDeposit.update_fixed_deposits(fixed_deposits, @update_attrs)
      assert fixed_deposits.accountId == 43
      assert fixed_deposits.accruedInterest == 456.7
      assert fixed_deposits.clientId == 43
      assert fixed_deposits.currency == "some updated currency"
      assert fixed_deposits.currencyDecimals == 43
      assert fixed_deposits.currencyId == 43
      assert fixed_deposits.divestmentPackageId == 43
      assert fixed_deposits.endDate == ~D[2011-05-18]
      assert fixed_deposits.expectedInterest == 456.7
      assert fixed_deposits.fixedPeriod == 43
      assert fixed_deposits.fixedPeriodType == "some updated fixedPeriodType"
      assert fixed_deposits.interestRate == 456.7
      assert fixed_deposits.interestRateType == "some updated interestRateType"
      assert fixed_deposits.isDivested == false
      assert fixed_deposits.isMatured == false
      assert fixed_deposits.principalAmount == 456.7
      assert fixed_deposits.productId == 43
      assert fixed_deposits.startDate == ~D[2011-05-18]
      assert fixed_deposits.totalAmountPaidOut == 456.7
      assert fixed_deposits.totalDepositCharge == 456.7
      assert fixed_deposits.totalPenalties == 456.7
      assert fixed_deposits.totalWithdrawalCharge == 456.7
      assert fixed_deposits.userId == 43
      assert fixed_deposits.userRoleId == 43
      assert fixed_deposits.yearLengthInDays == 43
    end

    test "update_fixed_deposits/2 with invalid data returns error changeset" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:error, %Ecto.Changeset{}} = FixedDeposit.update_fixed_deposits(fixed_deposits, @invalid_attrs)
      assert fixed_deposits == FixedDeposit.get_fixed_deposits!(fixed_deposits.id)
    end

    test "delete_fixed_deposits/1 deletes the fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:ok, %FixedDeposits{}} = FixedDeposit.delete_fixed_deposits(fixed_deposits)
      assert_raise Ecto.NoResultsError, fn -> FixedDeposit.get_fixed_deposits!(fixed_deposits.id) end
    end

    test "change_fixed_deposits/1 returns a fixed_deposits changeset" do
      fixed_deposits = fixed_deposits_fixture()
      assert %Ecto.Changeset{} = FixedDeposit.change_fixed_deposits(fixed_deposits)
    end
  end

  describe "tbl_fixed_deposit_transactions" do
    alias LoanSavingsSystem.FixedDeposit.FixedDepositTransaction

    @valid_attrs %{amountDeposited: 120.5, clientId: 42, fixedDepositId: 42, transactionId: 42, userId: 42, userRoleId: 42}
    @update_attrs %{amountDeposited: 456.7, clientId: 43, fixedDepositId: 43, transactionId: 43, userId: 43, userRoleId: 43}
    @invalid_attrs %{amountDeposited: nil, clientId: nil, fixedDepositId: nil, transactionId: nil, userId: nil, userRoleId: nil}

    def fixed_deposit_transaction_fixture(attrs \\ %{}) do
      {:ok, fixed_deposit_transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FixedDeposit.create_fixed_deposit_transaction()

      fixed_deposit_transaction
    end

    test "list_tbl_fixed_deposit_transactions/0 returns all tbl_fixed_deposit_transactions" do
      fixed_deposit_transaction = fixed_deposit_transaction_fixture()
      assert FixedDeposit.list_tbl_fixed_deposit_transactions() == [fixed_deposit_transaction]
    end

    test "get_fixed_deposit_transaction!/1 returns the fixed_deposit_transaction with given id" do
      fixed_deposit_transaction = fixed_deposit_transaction_fixture()
      assert FixedDeposit.get_fixed_deposit_transaction!(fixed_deposit_transaction.id) == fixed_deposit_transaction
    end

    test "create_fixed_deposit_transaction/1 with valid data creates a fixed_deposit_transaction" do
      assert {:ok, %FixedDepositTransaction{} = fixed_deposit_transaction} = FixedDeposit.create_fixed_deposit_transaction(@valid_attrs)
      assert fixed_deposit_transaction.amountDeposited == 120.5
      assert fixed_deposit_transaction.clientId == 42
      assert fixed_deposit_transaction.fixedDepositId == 42
      assert fixed_deposit_transaction.transactionId == 42
      assert fixed_deposit_transaction.userId == 42
      assert fixed_deposit_transaction.userRoleId == 42
    end

    test "create_fixed_deposit_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FixedDeposit.create_fixed_deposit_transaction(@invalid_attrs)
    end

    test "update_fixed_deposit_transaction/2 with valid data updates the fixed_deposit_transaction" do
      fixed_deposit_transaction = fixed_deposit_transaction_fixture()
      assert {:ok, %FixedDepositTransaction{} = fixed_deposit_transaction} = FixedDeposit.update_fixed_deposit_transaction(fixed_deposit_transaction, @update_attrs)
      assert fixed_deposit_transaction.amountDeposited == 456.7
      assert fixed_deposit_transaction.clientId == 43
      assert fixed_deposit_transaction.fixedDepositId == 43
      assert fixed_deposit_transaction.transactionId == 43
      assert fixed_deposit_transaction.userId == 43
      assert fixed_deposit_transaction.userRoleId == 43
    end

    test "update_fixed_deposit_transaction/2 with invalid data returns error changeset" do
      fixed_deposit_transaction = fixed_deposit_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = FixedDeposit.update_fixed_deposit_transaction(fixed_deposit_transaction, @invalid_attrs)
      assert fixed_deposit_transaction == FixedDeposit.get_fixed_deposit_transaction!(fixed_deposit_transaction.id)
    end

    test "delete_fixed_deposit_transaction/1 deletes the fixed_deposit_transaction" do
      fixed_deposit_transaction = fixed_deposit_transaction_fixture()
      assert {:ok, %FixedDepositTransaction{}} = FixedDeposit.delete_fixed_deposit_transaction(fixed_deposit_transaction)
      assert_raise Ecto.NoResultsError, fn -> FixedDeposit.get_fixed_deposit_transaction!(fixed_deposit_transaction.id) end
    end

    test "change_fixed_deposit_transaction/1 returns a fixed_deposit_transaction changeset" do
      fixed_deposit_transaction = fixed_deposit_transaction_fixture()
      assert %Ecto.Changeset{} = FixedDeposit.change_fixed_deposit_transaction(fixed_deposit_transaction)
    end
  end

  describe "tbl_fixed_deposit" do
    alias LoanSavingsSystem.FixedDeposit.FixedDeposits

    @valid_attrs %{accountId: 42, accruedInterest: 120.5, clientId: 42, currency: "some currency", currencyDecimals: 42, currencyId: 42, divestmentId: 42, divestmentPackageId: 42, endDate: ~D[2010-04-17], expectedInterest: 120.5, fixedPeriod: 42, fixedPeriodType: "some fixedPeriodType", interestRate: 120.5, interestRateType: "some interestRateType", isDivested: true, isMatured: true, principalAmount: 120.5, productId: 42, startDate: ~D[2010-04-17], totalAmountPaidOut: 120.5, totalDepositCharge: 120.5, totalPenalties: 120.5, totalWithdrawalCharge: 120.5, userId: 42, userRoleId: 42, yearLengthInDays: 42}
    @update_attrs %{accountId: 43, accruedInterest: 456.7, clientId: 43, currency: "some updated currency", currencyDecimals: 43, currencyId: 43, divestmentId: 43, divestmentPackageId: 43, endDate: ~D[2011-05-18], expectedInterest: 456.7, fixedPeriod: 43, fixedPeriodType: "some updated fixedPeriodType", interestRate: 456.7, interestRateType: "some updated interestRateType", isDivested: false, isMatured: false, principalAmount: 456.7, productId: 43, startDate: ~D[2011-05-18], totalAmountPaidOut: 456.7, totalDepositCharge: 456.7, totalPenalties: 456.7, totalWithdrawalCharge: 456.7, userId: 43, userRoleId: 43, yearLengthInDays: 43}
    @invalid_attrs %{accountId: nil, accruedInterest: nil, clientId: nil, currency: nil, currencyDecimals: nil, currencyId: nil, divestmentId: nil, divestmentPackageId: nil, endDate: nil, expectedInterest: nil, fixedPeriod: nil, fixedPeriodType: nil, interestRate: nil, interestRateType: nil, isDivested: nil, isMatured: nil, principalAmount: nil, productId: nil, startDate: nil, totalAmountPaidOut: nil, totalDepositCharge: nil, totalPenalties: nil, totalWithdrawalCharge: nil, userId: nil, userRoleId: nil, yearLengthInDays: nil}

    def fixed_deposits_fixture(attrs \\ %{}) do
      {:ok, fixed_deposits} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FixedDeposit.create_fixed_deposits()

      fixed_deposits
    end

    test "list_tbl_fixed_deposit/0 returns all tbl_fixed_deposit" do
      fixed_deposits = fixed_deposits_fixture()
      assert FixedDeposit.list_tbl_fixed_deposit() == [fixed_deposits]
    end

    test "get_fixed_deposits!/1 returns the fixed_deposits with given id" do
      fixed_deposits = fixed_deposits_fixture()
      assert FixedDeposit.get_fixed_deposits!(fixed_deposits.id) == fixed_deposits
    end

    test "create_fixed_deposits/1 with valid data creates a fixed_deposits" do
      assert {:ok, %FixedDeposits{} = fixed_deposits} = FixedDeposit.create_fixed_deposits(@valid_attrs)
      assert fixed_deposits.accountId == 42
      assert fixed_deposits.accruedInterest == 120.5
      assert fixed_deposits.clientId == 42
      assert fixed_deposits.currency == "some currency"
      assert fixed_deposits.currencyDecimals == 42
      assert fixed_deposits.currencyId == 42
      assert fixed_deposits.divestmentId == 42
      assert fixed_deposits.divestmentPackageId == 42
      assert fixed_deposits.endDate == ~D[2010-04-17]
      assert fixed_deposits.expectedInterest == 120.5
      assert fixed_deposits.fixedPeriod == 42
      assert fixed_deposits.fixedPeriodType == "some fixedPeriodType"
      assert fixed_deposits.interestRate == 120.5
      assert fixed_deposits.interestRateType == "some interestRateType"
      assert fixed_deposits.isDivested == true
      assert fixed_deposits.isMatured == true
      assert fixed_deposits.principalAmount == 120.5
      assert fixed_deposits.productId == 42
      assert fixed_deposits.startDate == ~D[2010-04-17]
      assert fixed_deposits.totalAmountPaidOut == 120.5
      assert fixed_deposits.totalDepositCharge == 120.5
      assert fixed_deposits.totalPenalties == 120.5
      assert fixed_deposits.totalWithdrawalCharge == 120.5
      assert fixed_deposits.userId == 42
      assert fixed_deposits.userRoleId == 42
      assert fixed_deposits.yearLengthInDays == 42
    end

    test "create_fixed_deposits/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FixedDeposit.create_fixed_deposits(@invalid_attrs)
    end

    test "update_fixed_deposits/2 with valid data updates the fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:ok, %FixedDeposits{} = fixed_deposits} = FixedDeposit.update_fixed_deposits(fixed_deposits, @update_attrs)
      assert fixed_deposits.accountId == 43
      assert fixed_deposits.accruedInterest == 456.7
      assert fixed_deposits.clientId == 43
      assert fixed_deposits.currency == "some updated currency"
      assert fixed_deposits.currencyDecimals == 43
      assert fixed_deposits.currencyId == 43
      assert fixed_deposits.divestmentId == 43
      assert fixed_deposits.divestmentPackageId == 43
      assert fixed_deposits.endDate == ~D[2011-05-18]
      assert fixed_deposits.expectedInterest == 456.7
      assert fixed_deposits.fixedPeriod == 43
      assert fixed_deposits.fixedPeriodType == "some updated fixedPeriodType"
      assert fixed_deposits.interestRate == 456.7
      assert fixed_deposits.interestRateType == "some updated interestRateType"
      assert fixed_deposits.isDivested == false
      assert fixed_deposits.isMatured == false
      assert fixed_deposits.principalAmount == 456.7
      assert fixed_deposits.productId == 43
      assert fixed_deposits.startDate == ~D[2011-05-18]
      assert fixed_deposits.totalAmountPaidOut == 456.7
      assert fixed_deposits.totalDepositCharge == 456.7
      assert fixed_deposits.totalPenalties == 456.7
      assert fixed_deposits.totalWithdrawalCharge == 456.7
      assert fixed_deposits.userId == 43
      assert fixed_deposits.userRoleId == 43
      assert fixed_deposits.yearLengthInDays == 43
    end

    test "update_fixed_deposits/2 with invalid data returns error changeset" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:error, %Ecto.Changeset{}} = FixedDeposit.update_fixed_deposits(fixed_deposits, @invalid_attrs)
      assert fixed_deposits == FixedDeposit.get_fixed_deposits!(fixed_deposits.id)
    end

    test "delete_fixed_deposits/1 deletes the fixed_deposits" do
      fixed_deposits = fixed_deposits_fixture()
      assert {:ok, %FixedDeposits{}} = FixedDeposit.delete_fixed_deposits(fixed_deposits)
      assert_raise Ecto.NoResultsError, fn -> FixedDeposit.get_fixed_deposits!(fixed_deposits.id) end
    end

    test "change_fixed_deposits/1 returns a fixed_deposits changeset" do
      fixed_deposits = fixed_deposits_fixture()
      assert %Ecto.Changeset{} = FixedDeposit.change_fixed_deposits(fixed_deposits)
    end
  end
end
