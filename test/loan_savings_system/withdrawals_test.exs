defmodule LoanSavingsSystem.WithdrawalsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Withdrawals

  describe "maturedwithdrawals" do
    alias LoanSavingsSystem.Withdrawals.MaturedWithdrawal

    @valid_attrs %{amount: 120.5, clientId: 42, fixedDepositId: 42, fixedPeriod: 42, interestAccrued: 120.5, interestRate: 120.5, interestRateType: "some interestRateType", principalAmount: 120.5, transactionId: 42, userId: 42, userRoleId: 42}
    @update_attrs %{amount: 456.7, clientId: 43, fixedDepositId: 43, fixedPeriod: 43, interestAccrued: 456.7, interestRate: 456.7, interestRateType: "some updated interestRateType", principalAmount: 456.7, transactionId: 43, userId: 43, userRoleId: 43}
    @invalid_attrs %{amount: nil, clientId: nil, fixedDepositId: nil, fixedPeriod: nil, interestAccrued: nil, interestRate: nil, interestRateType: nil, principalAmount: nil, transactionId: nil, userId: nil, userRoleId: nil}

    def matured_withdrawal_fixture(attrs \\ %{}) do
      {:ok, matured_withdrawal} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Withdrawals.create_matured_withdrawal()

      matured_withdrawal
    end

    test "list_maturedwithdrawals/0 returns all maturedwithdrawals" do
      matured_withdrawal = matured_withdrawal_fixture()
      assert Withdrawals.list_maturedwithdrawals() == [matured_withdrawal]
    end

    test "get_matured_withdrawal!/1 returns the matured_withdrawal with given id" do
      matured_withdrawal = matured_withdrawal_fixture()
      assert Withdrawals.get_matured_withdrawal!(matured_withdrawal.id) == matured_withdrawal
    end

    test "create_matured_withdrawal/1 with valid data creates a matured_withdrawal" do
      assert {:ok, %MaturedWithdrawal{} = matured_withdrawal} = Withdrawals.create_matured_withdrawal(@valid_attrs)
      assert matured_withdrawal.amount == 120.5
      assert matured_withdrawal.clientId == 42
      assert matured_withdrawal.fixedDepositId == 42
      assert matured_withdrawal.fixedPeriod == 42
      assert matured_withdrawal.interestAccrued == 120.5
      assert matured_withdrawal.interestRate == 120.5
      assert matured_withdrawal.interestRateType == "some interestRateType"
      assert matured_withdrawal.principalAmount == 120.5
      assert matured_withdrawal.transactionId == 42
      assert matured_withdrawal.userId == 42
      assert matured_withdrawal.userRoleId == 42
    end

    test "create_matured_withdrawal/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Withdrawals.create_matured_withdrawal(@invalid_attrs)
    end

    test "update_matured_withdrawal/2 with valid data updates the matured_withdrawal" do
      matured_withdrawal = matured_withdrawal_fixture()
      assert {:ok, %MaturedWithdrawal{} = matured_withdrawal} = Withdrawals.update_matured_withdrawal(matured_withdrawal, @update_attrs)
      assert matured_withdrawal.amount == 456.7
      assert matured_withdrawal.clientId == 43
      assert matured_withdrawal.fixedDepositId == 43
      assert matured_withdrawal.fixedPeriod == 43
      assert matured_withdrawal.interestAccrued == 456.7
      assert matured_withdrawal.interestRate == 456.7
      assert matured_withdrawal.interestRateType == "some updated interestRateType"
      assert matured_withdrawal.principalAmount == 456.7
      assert matured_withdrawal.transactionId == 43
      assert matured_withdrawal.userId == 43
      assert matured_withdrawal.userRoleId == 43
    end

    test "update_matured_withdrawal/2 with invalid data returns error changeset" do
      matured_withdrawal = matured_withdrawal_fixture()
      assert {:error, %Ecto.Changeset{}} = Withdrawals.update_matured_withdrawal(matured_withdrawal, @invalid_attrs)
      assert matured_withdrawal == Withdrawals.get_matured_withdrawal!(matured_withdrawal.id)
    end

    test "delete_matured_withdrawal/1 deletes the matured_withdrawal" do
      matured_withdrawal = matured_withdrawal_fixture()
      assert {:ok, %MaturedWithdrawal{}} = Withdrawals.delete_matured_withdrawal(matured_withdrawal)
      assert_raise Ecto.NoResultsError, fn -> Withdrawals.get_matured_withdrawal!(matured_withdrawal.id) end
    end

    test "change_matured_withdrawal/1 returns a matured_withdrawal changeset" do
      matured_withdrawal = matured_withdrawal_fixture()
      assert %Ecto.Changeset{} = Withdrawals.change_matured_withdrawal(matured_withdrawal)
    end
  end
end
