defmodule LoanSavingsSystem.DivestmentsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Divestments

  describe "tbl_divestment_package" do
    alias LoanSavingsSystem.Divestments.DivestmentPackage

    @valid_attrs %{clientId: 42, divestmentValuation: 120.5, endPeriodDays: 42, productId: 42, startPeriodDays: 42, status: "some status"}
    @update_attrs %{clientId: 43, divestmentValuation: 456.7, endPeriodDays: 43, productId: 43, startPeriodDays: 43, status: "some updated status"}
    @invalid_attrs %{clientId: nil, divestmentValuation: nil, endPeriodDays: nil, productId: nil, startPeriodDays: nil, status: nil}

    def divestment_package_fixture(attrs \\ %{}) do
      {:ok, divestment_package} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Divestments.create_divestment_package()

      divestment_package
    end

    test "list_tbl_divestment_package/0 returns all tbl_divestment_package" do
      divestment_package = divestment_package_fixture()
      assert Divestments.list_tbl_divestment_package() == [divestment_package]
    end

    test "get_divestment_package!/1 returns the divestment_package with given id" do
      divestment_package = divestment_package_fixture()
      assert Divestments.get_divestment_package!(divestment_package.id) == divestment_package
    end

    test "create_divestment_package/1 with valid data creates a divestment_package" do
      assert {:ok, %DivestmentPackage{} = divestment_package} = Divestments.create_divestment_package(@valid_attrs)
      assert divestment_package.clientId == 42
      assert divestment_package.divestmentValuation == 120.5
      assert divestment_package.endPeriodDays == 42
      assert divestment_package.productId == 42
      assert divestment_package.startPeriodDays == 42
      assert divestment_package.status == "some status"
    end

    test "create_divestment_package/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Divestments.create_divestment_package(@invalid_attrs)
    end

    test "update_divestment_package/2 with valid data updates the divestment_package" do
      divestment_package = divestment_package_fixture()
      assert {:ok, %DivestmentPackage{} = divestment_package} = Divestments.update_divestment_package(divestment_package, @update_attrs)
      assert divestment_package.clientId == 43
      assert divestment_package.divestmentValuation == 456.7
      assert divestment_package.endPeriodDays == 43
      assert divestment_package.productId == 43
      assert divestment_package.startPeriodDays == 43
      assert divestment_package.status == "some updated status"
    end

    test "update_divestment_package/2 with invalid data returns error changeset" do
      divestment_package = divestment_package_fixture()
      assert {:error, %Ecto.Changeset{}} = Divestments.update_divestment_package(divestment_package, @invalid_attrs)
      assert divestment_package == Divestments.get_divestment_package!(divestment_package.id)
    end

    test "delete_divestment_package/1 deletes the divestment_package" do
      divestment_package = divestment_package_fixture()
      assert {:ok, %DivestmentPackage{}} = Divestments.delete_divestment_package(divestment_package)
      assert_raise Ecto.NoResultsError, fn -> Divestments.get_divestment_package!(divestment_package.id) end
    end

    test "change_divestment_package/1 returns a divestment_package changeset" do
      divestment_package = divestment_package_fixture()
      assert %Ecto.Changeset{} = Divestments.change_divestment_package(divestment_package)
    end
  end

  describe "tbl_divestments" do
    alias LoanSavingsSystem.Divestments.Divestment

    @valid_attrs %{clientId: 42, divestAmount: 120.5, divestmentDate: ~D[2010-04-17], divestmentDayCount: 42, divestmentValuation: 120.5, fixedDepositId: 42, fixedPeriod: 42, interestRate: 120.5, interestRateType: "some interestRateType", principalAmount: 120.5}
    @update_attrs %{clientId: 43, divestAmount: 456.7, divestmentDate: ~D[2011-05-18], divestmentDayCount: 43, divestmentValuation: 456.7, fixedDepositId: 43, fixedPeriod: 43, interestRate: 456.7, interestRateType: "some updated interestRateType", principalAmount: 456.7}
    @invalid_attrs %{clientId: nil, divestAmount: nil, divestmentDate: nil, divestmentDayCount: nil, divestmentValuation: nil, fixedDepositId: nil, fixedPeriod: nil, interestRate: nil, interestRateType: nil, principalAmount: nil}

    def divestment_fixture(attrs \\ %{}) do
      {:ok, divestment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Divestments.create_divestment()

      divestment
    end

    test "list_tbl_divestments/0 returns all tbl_divestments" do
      divestment = divestment_fixture()
      assert Divestments.list_tbl_divestments() == [divestment]
    end

    test "get_divestment!/1 returns the divestment with given id" do
      divestment = divestment_fixture()
      assert Divestments.get_divestment!(divestment.id) == divestment
    end

    test "create_divestment/1 with valid data creates a divestment" do
      assert {:ok, %Divestment{} = divestment} = Divestments.create_divestment(@valid_attrs)
      assert divestment.clientId == 42
      assert divestment.divestAmount == 120.5
      assert divestment.divestmentDate == ~D[2010-04-17]
      assert divestment.divestmentDayCount == 42
      assert divestment.divestmentValuation == 120.5
      assert divestment.fixedDepositId == 42
      assert divestment.fixedPeriod == 42
      assert divestment.interestRate == 120.5
      assert divestment.interestRateType == "some interestRateType"
      assert divestment.principalAmount == 120.5
    end

    test "create_divestment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Divestments.create_divestment(@invalid_attrs)
    end

    test "update_divestment/2 with valid data updates the divestment" do
      divestment = divestment_fixture()
      assert {:ok, %Divestment{} = divestment} = Divestments.update_divestment(divestment, @update_attrs)
      assert divestment.clientId == 43
      assert divestment.divestAmount == 456.7
      assert divestment.divestmentDate == ~D[2011-05-18]
      assert divestment.divestmentDayCount == 43
      assert divestment.divestmentValuation == 456.7
      assert divestment.fixedDepositId == 43
      assert divestment.fixedPeriod == 43
      assert divestment.interestRate == 456.7
      assert divestment.interestRateType == "some updated interestRateType"
      assert divestment.principalAmount == 456.7
    end

    test "update_divestment/2 with invalid data returns error changeset" do
      divestment = divestment_fixture()
      assert {:error, %Ecto.Changeset{}} = Divestments.update_divestment(divestment, @invalid_attrs)
      assert divestment == Divestments.get_divestment!(divestment.id)
    end

    test "delete_divestment/1 deletes the divestment" do
      divestment = divestment_fixture()
      assert {:ok, %Divestment{}} = Divestments.delete_divestment(divestment)
      assert_raise Ecto.NoResultsError, fn -> Divestments.get_divestment!(divestment.id) end
    end

    test "change_divestment/1 returns a divestment changeset" do
      divestment = divestment_fixture()
      assert %Ecto.Changeset{} = Divestments.change_divestment(divestment)
    end
  end

  describe "tbl_divestment_transactions" do
    alias LoanSavingsSystem.Divestments.DivestmentTransaction

    @valid_attrs %{amountDivested: 120.5, clientId: 42, divestmentId: 42, interestAccrued: 120.5, transactionId: 42, userId: 42, userRoleId: 42}
    @update_attrs %{amountDivested: 456.7, clientId: 43, divestmentId: 43, interestAccrued: 456.7, transactionId: 43, userId: 43, userRoleId: 43}
    @invalid_attrs %{amountDivested: nil, clientId: nil, divestmentId: nil, interestAccrued: nil, transactionId: nil, userId: nil, userRoleId: nil}

    def divestment_transaction_fixture(attrs \\ %{}) do
      {:ok, divestment_transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Divestments.create_divestment_transaction()

      divestment_transaction
    end

    test "list_tbl_divestment_transactions/0 returns all tbl_divestment_transactions" do
      divestment_transaction = divestment_transaction_fixture()
      assert Divestments.list_tbl_divestment_transactions() == [divestment_transaction]
    end

    test "get_divestment_transaction!/1 returns the divestment_transaction with given id" do
      divestment_transaction = divestment_transaction_fixture()
      assert Divestments.get_divestment_transaction!(divestment_transaction.id) == divestment_transaction
    end

    test "create_divestment_transaction/1 with valid data creates a divestment_transaction" do
      assert {:ok, %DivestmentTransaction{} = divestment_transaction} = Divestments.create_divestment_transaction(@valid_attrs)
      assert divestment_transaction.amountDivested == 120.5
      assert divestment_transaction.clientId == 42
      assert divestment_transaction.divestmentId == 42
      assert divestment_transaction.interestAccrued == 120.5
      assert divestment_transaction.transactionId == 42
      assert divestment_transaction.userId == 42
      assert divestment_transaction.userRoleId == 42
    end

    test "create_divestment_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Divestments.create_divestment_transaction(@invalid_attrs)
    end

    test "update_divestment_transaction/2 with valid data updates the divestment_transaction" do
      divestment_transaction = divestment_transaction_fixture()
      assert {:ok, %DivestmentTransaction{} = divestment_transaction} = Divestments.update_divestment_transaction(divestment_transaction, @update_attrs)
      assert divestment_transaction.amountDivested == 456.7
      assert divestment_transaction.clientId == 43
      assert divestment_transaction.divestmentId == 43
      assert divestment_transaction.interestAccrued == 456.7
      assert divestment_transaction.transactionId == 43
      assert divestment_transaction.userId == 43
      assert divestment_transaction.userRoleId == 43
    end

    test "update_divestment_transaction/2 with invalid data returns error changeset" do
      divestment_transaction = divestment_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Divestments.update_divestment_transaction(divestment_transaction, @invalid_attrs)
      assert divestment_transaction == Divestments.get_divestment_transaction!(divestment_transaction.id)
    end

    test "delete_divestment_transaction/1 deletes the divestment_transaction" do
      divestment_transaction = divestment_transaction_fixture()
      assert {:ok, %DivestmentTransaction{}} = Divestments.delete_divestment_transaction(divestment_transaction)
      assert_raise Ecto.NoResultsError, fn -> Divestments.get_divestment_transaction!(divestment_transaction.id) end
    end

    test "change_divestment_transaction/1 returns a divestment_transaction changeset" do
      divestment_transaction = divestment_transaction_fixture()
      assert %Ecto.Changeset{} = Divestments.change_divestment_transaction(divestment_transaction)
    end
  end

  describe "tbl_divestments" do
    alias LoanSavingsSystem.Divestments.Divestment

    @valid_attrs %{clientId: 42, divestAmount: 120.5, divestmentDate: ~D[2010-04-17], divestmentDayCount: 42, divestmentValuation: 120.5, fixedDepositId: 42, fixedPeriod: 42, interestAccrued: 120.5, interestRate: 120.5, interestRateType: "some interestRateType", principalAmount: 120.5, userId: 42, userRoleId: 42}
    @update_attrs %{clientId: 43, divestAmount: 456.7, divestmentDate: ~D[2011-05-18], divestmentDayCount: 43, divestmentValuation: 456.7, fixedDepositId: 43, fixedPeriod: 43, interestAccrued: 456.7, interestRate: 456.7, interestRateType: "some updated interestRateType", principalAmount: 456.7, userId: 43, userRoleId: 43}
    @invalid_attrs %{clientId: nil, divestAmount: nil, divestmentDate: nil, divestmentDayCount: nil, divestmentValuation: nil, fixedDepositId: nil, fixedPeriod: nil, interestAccrued: nil, interestRate: nil, interestRateType: nil, principalAmount: nil, userId: nil, userRoleId: nil}

    def divestment_fixture(attrs \\ %{}) do
      {:ok, divestment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Divestments.create_divestment()

      divestment
    end

    test "list_tbl_divestments/0 returns all tbl_divestments" do
      divestment = divestment_fixture()
      assert Divestments.list_tbl_divestments() == [divestment]
    end

    test "get_divestment!/1 returns the divestment with given id" do
      divestment = divestment_fixture()
      assert Divestments.get_divestment!(divestment.id) == divestment
    end

    test "create_divestment/1 with valid data creates a divestment" do
      assert {:ok, %Divestment{} = divestment} = Divestments.create_divestment(@valid_attrs)
      assert divestment.clientId == 42
      assert divestment.divestAmount == 120.5
      assert divestment.divestmentDate == ~D[2010-04-17]
      assert divestment.divestmentDayCount == 42
      assert divestment.divestmentValuation == 120.5
      assert divestment.fixedDepositId == 42
      assert divestment.fixedPeriod == 42
      assert divestment.interestAccrued == 120.5
      assert divestment.interestRate == 120.5
      assert divestment.interestRateType == "some interestRateType"
      assert divestment.principalAmount == 120.5
      assert divestment.userId == 42
      assert divestment.userRoleId == 42
    end

    test "create_divestment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Divestments.create_divestment(@invalid_attrs)
    end

    test "update_divestment/2 with valid data updates the divestment" do
      divestment = divestment_fixture()
      assert {:ok, %Divestment{} = divestment} = Divestments.update_divestment(divestment, @update_attrs)
      assert divestment.clientId == 43
      assert divestment.divestAmount == 456.7
      assert divestment.divestmentDate == ~D[2011-05-18]
      assert divestment.divestmentDayCount == 43
      assert divestment.divestmentValuation == 456.7
      assert divestment.fixedDepositId == 43
      assert divestment.fixedPeriod == 43
      assert divestment.interestAccrued == 456.7
      assert divestment.interestRate == 456.7
      assert divestment.interestRateType == "some updated interestRateType"
      assert divestment.principalAmount == 456.7
      assert divestment.userId == 43
      assert divestment.userRoleId == 43
    end

    test "update_divestment/2 with invalid data returns error changeset" do
      divestment = divestment_fixture()
      assert {:error, %Ecto.Changeset{}} = Divestments.update_divestment(divestment, @invalid_attrs)
      assert divestment == Divestments.get_divestment!(divestment.id)
    end

    test "delete_divestment/1 deletes the divestment" do
      divestment = divestment_fixture()
      assert {:ok, %Divestment{}} = Divestments.delete_divestment(divestment)
      assert_raise Ecto.NoResultsError, fn -> Divestments.get_divestment!(divestment.id) end
    end

    test "change_divestment/1 returns a divestment changeset" do
      divestment = divestment_fixture()
      assert %Ecto.Changeset{} = Divestments.change_divestment(divestment)
    end
  end
end
