defmodule LoanSystem.LoanTest do
  use LoanSystem.DataCase

  alias LoanSystem.Loan

  describe "tbl_loan_repayment" do
    alias LoanSystem.Loan.LoanRepayment

    @valid_attrs %{amountRepaid: 120.5, chequeNo: "some chequeNo", dateOfRepayment: "some dateOfRepayment", modeOfRepayment: "some modeOfRepayment", receiptNo: "some receiptNo", recipientUserRoleId: 42, registeredByUserId: 42, repayment: "some repayment"}
    @update_attrs %{amountRepaid: 456.7, chequeNo: "some updated chequeNo", dateOfRepayment: "some updated dateOfRepayment", modeOfRepayment: "some updated modeOfRepayment", receiptNo: "some updated receiptNo", recipientUserRoleId: 43, registeredByUserId: 43, repayment: "some updated repayment"}
    @invalid_attrs %{amountRepaid: nil, chequeNo: nil, dateOfRepayment: nil, modeOfRepayment: nil, receiptNo: nil, recipientUserRoleId: nil, registeredByUserId: nil, repayment: nil}

    def loan_repayment_fixture(attrs \\ %{}) do
      {:ok, loan_repayment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_repayment()

      loan_repayment
    end

    test "list_tbl_loan_repayment/0 returns all tbl_loan_repayment" do
      loan_repayment = loan_repayment_fixture()
      assert Loan.list_tbl_loan_repayment() == [loan_repayment]
    end

    test "get_loan_repayment!/1 returns the loan_repayment with given id" do
      loan_repayment = loan_repayment_fixture()
      assert Loan.get_loan_repayment!(loan_repayment.id) == loan_repayment
    end

    test "create_loan_repayment/1 with valid data creates a loan_repayment" do
      assert {:ok, %LoanRepayment{} = loan_repayment} = Loan.create_loan_repayment(@valid_attrs)
      assert loan_repayment.amountRepaid == 120.5
      assert loan_repayment.chequeNo == "some chequeNo"
      assert loan_repayment.dateOfRepayment == "some dateOfRepayment"
      assert loan_repayment.modeOfRepayment == "some modeOfRepayment"
      assert loan_repayment.receiptNo == "some receiptNo"
      assert loan_repayment.recipientUserRoleId == 42
      assert loan_repayment.registeredByUserId == 42
      assert loan_repayment.repayment == "some repayment"
    end

    test "create_loan_repayment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_repayment(@invalid_attrs)
    end

    test "update_loan_repayment/2 with valid data updates the loan_repayment" do
      loan_repayment = loan_repayment_fixture()
      assert {:ok, %LoanRepayment{} = loan_repayment} = Loan.update_loan_repayment(loan_repayment, @update_attrs)
      assert loan_repayment.amountRepaid == 456.7
      assert loan_repayment.chequeNo == "some updated chequeNo"
      assert loan_repayment.dateOfRepayment == "some updated dateOfRepayment"
      assert loan_repayment.modeOfRepayment == "some updated modeOfRepayment"
      assert loan_repayment.receiptNo == "some updated receiptNo"
      assert loan_repayment.recipientUserRoleId == 43
      assert loan_repayment.registeredByUserId == 43
      assert loan_repayment.repayment == "some updated repayment"
    end

    test "update_loan_repayment/2 with invalid data returns error changeset" do
      loan_repayment = loan_repayment_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_repayment(loan_repayment, @invalid_attrs)
      assert loan_repayment == Loan.get_loan_repayment!(loan_repayment.id)
    end

    test "delete_loan_repayment/1 deletes the loan_repayment" do
      loan_repayment = loan_repayment_fixture()
      assert {:ok, %LoanRepayment{}} = Loan.delete_loan_repayment(loan_repayment)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_repayment!(loan_repayment.id) end
    end

    test "change_loan_repayment/1 returns a loan_repayment changeset" do
      loan_repayment = loan_repayment_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_repayment(loan_repayment)
    end
  end
end
