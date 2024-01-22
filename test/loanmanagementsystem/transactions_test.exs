defmodule Loanmanagementsystem.TransactionsTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Transactions

  describe "tbl_transactions" do
    alias Loanmanagementsystem.Transactions.Loan_transactions

    @valid_attrs %{accrued_no_days: "some accrued_no_days", automated: "some automated", bank_account: "some bank_account", bank_branch: "some bank_branch", bank_name: "some bank_name", bank_swift_code: "some bank_swift_code", created_by_id: 42, customer_id: 42, is_disbursement: true, is_repayment: true, loan_id: 42, momo_mobile_no: "some momo_mobile_no", momo_provider: "some momo_provider", momo_type: "some momo_type", narration: "some narration", principal_amount: 120.5, product_type: "some product_type", repaid_amount: 120.5, repayment_type: "some repayment_type", settlement_status: "some settlement_status", status: "some status", total_finance_cost_accrued: 120.5, total_interest_accrued: 120.5, transaction_date: ~D[2010-04-17], txn_amount: 120.5, txn_ref_no: "some txn_ref_no", txn_status: "some txn_status"}
    @update_attrs %{accrued_no_days: "some updated accrued_no_days", automated: "some updated automated", bank_account: "some updated bank_account", bank_branch: "some updated bank_branch", bank_name: "some updated bank_name", bank_swift_code: "some updated bank_swift_code", created_by_id: 43, customer_id: 43, is_disbursement: false, is_repayment: false, loan_id: 43, momo_mobile_no: "some updated momo_mobile_no", momo_provider: "some updated momo_provider", momo_type: "some updated momo_type", narration: "some updated narration", principal_amount: 456.7, product_type: "some updated product_type", repaid_amount: 456.7, repayment_type: "some updated repayment_type", settlement_status: "some updated settlement_status", status: "some updated status", total_finance_cost_accrued: 456.7, total_interest_accrued: 456.7, transaction_date: ~D[2011-05-18], txn_amount: 456.7, txn_ref_no: "some updated txn_ref_no", txn_status: "some updated txn_status"}
    @invalid_attrs %{accrued_no_days: nil, automated: nil, bank_account: nil, bank_branch: nil, bank_name: nil, bank_swift_code: nil, created_by_id: nil, customer_id: nil, is_disbursement: nil, is_repayment: nil, loan_id: nil, momo_mobile_no: nil, momo_provider: nil, momo_type: nil, narration: nil, principal_amount: nil, product_type: nil, repaid_amount: nil, repayment_type: nil, settlement_status: nil, status: nil, total_finance_cost_accrued: nil, total_interest_accrued: nil, transaction_date: nil, txn_amount: nil, txn_ref_no: nil, txn_status: nil}

    def loan_transactions_fixture(attrs \\ %{}) do
      {:ok, loan_transactions} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Transactions.create_loan_transactions()

      loan_transactions
    end

    test "list_tbl_transactions/0 returns all tbl_transactions" do
      loan_transactions = loan_transactions_fixture()
      assert Transactions.list_tbl_transactions() == [loan_transactions]
    end

    test "get_loan_transactions!/1 returns the loan_transactions with given id" do
      loan_transactions = loan_transactions_fixture()
      assert Transactions.get_loan_transactions!(loan_transactions.id) == loan_transactions
    end

    test "create_loan_transactions/1 with valid data creates a loan_transactions" do
      assert {:ok, %Loan_transactions{} = loan_transactions} = Transactions.create_loan_transactions(@valid_attrs)
      assert loan_transactions.accrued_no_days == "some accrued_no_days"
      assert loan_transactions.automated == "some automated"
      assert loan_transactions.bank_account == "some bank_account"
      assert loan_transactions.bank_branch == "some bank_branch"
      assert loan_transactions.bank_name == "some bank_name"
      assert loan_transactions.bank_swift_code == "some bank_swift_code"
      assert loan_transactions.created_by_id == 42
      assert loan_transactions.customer_id == 42
      assert loan_transactions.is_disbursement == true
      assert loan_transactions.is_repayment == true
      assert loan_transactions.loan_id == 42
      assert loan_transactions.momo_mobile_no == "some momo_mobile_no"
      assert loan_transactions.momo_provider == "some momo_provider"
      assert loan_transactions.momo_type == "some momo_type"
      assert loan_transactions.narration == "some narration"
      assert loan_transactions.principal_amount == 120.5
      assert loan_transactions.product_type == "some product_type"
      assert loan_transactions.repaid_amount == 120.5
      assert loan_transactions.repayment_type == "some repayment_type"
      assert loan_transactions.settlement_status == "some settlement_status"
      assert loan_transactions.status == "some status"
      assert loan_transactions.total_finance_cost_accrued == 120.5
      assert loan_transactions.total_interest_accrued == 120.5
      assert loan_transactions.transaction_date == ~D[2010-04-17]
      assert loan_transactions.txn_amount == 120.5
      assert loan_transactions.txn_ref_no == "some txn_ref_no"
      assert loan_transactions.txn_status == "some txn_status"
    end

    test "create_loan_transactions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Transactions.create_loan_transactions(@invalid_attrs)
    end

    test "update_loan_transactions/2 with valid data updates the loan_transactions" do
      loan_transactions = loan_transactions_fixture()
      assert {:ok, %Loan_transactions{} = loan_transactions} = Transactions.update_loan_transactions(loan_transactions, @update_attrs)
      assert loan_transactions.accrued_no_days == "some updated accrued_no_days"
      assert loan_transactions.automated == "some updated automated"
      assert loan_transactions.bank_account == "some updated bank_account"
      assert loan_transactions.bank_branch == "some updated bank_branch"
      assert loan_transactions.bank_name == "some updated bank_name"
      assert loan_transactions.bank_swift_code == "some updated bank_swift_code"
      assert loan_transactions.created_by_id == 43
      assert loan_transactions.customer_id == 43
      assert loan_transactions.is_disbursement == false
      assert loan_transactions.is_repayment == false
      assert loan_transactions.loan_id == 43
      assert loan_transactions.momo_mobile_no == "some updated momo_mobile_no"
      assert loan_transactions.momo_provider == "some updated momo_provider"
      assert loan_transactions.momo_type == "some updated momo_type"
      assert loan_transactions.narration == "some updated narration"
      assert loan_transactions.principal_amount == 456.7
      assert loan_transactions.product_type == "some updated product_type"
      assert loan_transactions.repaid_amount == 456.7
      assert loan_transactions.repayment_type == "some updated repayment_type"
      assert loan_transactions.settlement_status == "some updated settlement_status"
      assert loan_transactions.status == "some updated status"
      assert loan_transactions.total_finance_cost_accrued == 456.7
      assert loan_transactions.total_interest_accrued == 456.7
      assert loan_transactions.transaction_date == ~D[2011-05-18]
      assert loan_transactions.txn_amount == 456.7
      assert loan_transactions.txn_ref_no == "some updated txn_ref_no"
      assert loan_transactions.txn_status == "some updated txn_status"
    end

    test "update_loan_transactions/2 with invalid data returns error changeset" do
      loan_transactions = loan_transactions_fixture()
      assert {:error, %Ecto.Changeset{}} = Transactions.update_loan_transactions(loan_transactions, @invalid_attrs)
      assert loan_transactions == Transactions.get_loan_transactions!(loan_transactions.id)
    end

    test "delete_loan_transactions/1 deletes the loan_transactions" do
      loan_transactions = loan_transactions_fixture()
      assert {:ok, %Loan_transactions{}} = Transactions.delete_loan_transactions(loan_transactions)
      assert_raise Ecto.NoResultsError, fn -> Transactions.get_loan_transactions!(loan_transactions.id) end
    end

    test "change_loan_transactions/1 returns a loan_transactions changeset" do
      loan_transactions = loan_transactions_fixture()
      assert %Ecto.Changeset{} = Transactions.change_loan_transactions(loan_transactions)
    end
  end
end
