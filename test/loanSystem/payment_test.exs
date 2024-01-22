defmodule LoanSystem.PaymentTest do
  use LoanSystem.DataCase

  alias LoanSystem.Payment

  describe "tbl_loan_transaction" do
    alias LoanSystem.Payment.PaymentDetails

    @valid_attrs %{account_number: "some account_number", bank_number: "some bank_number", cheque_number: "some cheque_number", credit_gl_account_id: 42, debit_gl_account_id: 42, payment_type_id: 42, receipt_number: "some receipt_number", routing_code: "some routing_code"}
    @update_attrs %{account_number: "some updated account_number", bank_number: "some updated bank_number", cheque_number: "some updated cheque_number", credit_gl_account_id: 43, debit_gl_account_id: 43, payment_type_id: 43, receipt_number: "some updated receipt_number", routing_code: "some updated routing_code"}
    @invalid_attrs %{account_number: nil, bank_number: nil, cheque_number: nil, credit_gl_account_id: nil, debit_gl_account_id: nil, payment_type_id: nil, receipt_number: nil, routing_code: nil}

    def payment_details_fixture(attrs \\ %{}) do
      {:ok, payment_details} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payment.create_payment_details()

      payment_details
    end

    test "list_tbl_loan_transaction/0 returns all tbl_loan_transaction" do
      payment_details = payment_details_fixture()
      assert Payment.list_tbl_loan_transaction() == [payment_details]
    end

    test "get_payment_details!/1 returns the payment_details with given id" do
      payment_details = payment_details_fixture()
      assert Payment.get_payment_details!(payment_details.id) == payment_details
    end

    test "create_payment_details/1 with valid data creates a payment_details" do
      assert {:ok, %PaymentDetails{} = payment_details} = Payment.create_payment_details(@valid_attrs)
      assert payment_details.account_number == "some account_number"
      assert payment_details.bank_number == "some bank_number"
      assert payment_details.cheque_number == "some cheque_number"
      assert payment_details.credit_gl_account_id == 42
      assert payment_details.debit_gl_account_id == 42
      assert payment_details.payment_type_id == 42
      assert payment_details.receipt_number == "some receipt_number"
      assert payment_details.routing_code == "some routing_code"
    end

    test "create_payment_details/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payment.create_payment_details(@invalid_attrs)
    end

    test "update_payment_details/2 with valid data updates the payment_details" do
      payment_details = payment_details_fixture()
      assert {:ok, %PaymentDetails{} = payment_details} = Payment.update_payment_details(payment_details, @update_attrs)
      assert payment_details.account_number == "some updated account_number"
      assert payment_details.bank_number == "some updated bank_number"
      assert payment_details.cheque_number == "some updated cheque_number"
      assert payment_details.credit_gl_account_id == 43
      assert payment_details.debit_gl_account_id == 43
      assert payment_details.payment_type_id == 43
      assert payment_details.receipt_number == "some updated receipt_number"
      assert payment_details.routing_code == "some updated routing_code"
    end

    test "update_payment_details/2 with invalid data returns error changeset" do
      payment_details = payment_details_fixture()
      assert {:error, %Ecto.Changeset{}} = Payment.update_payment_details(payment_details, @invalid_attrs)
      assert payment_details == Payment.get_payment_details!(payment_details.id)
    end

    test "delete_payment_details/1 deletes the payment_details" do
      payment_details = payment_details_fixture()
      assert {:ok, %PaymentDetails{}} = Payment.delete_payment_details(payment_details)
      assert_raise Ecto.NoResultsError, fn -> Payment.get_payment_details!(payment_details.id) end
    end

    test "change_payment_details/1 returns a payment_details changeset" do
      payment_details = payment_details_fixture()
      assert %Ecto.Changeset{} = Payment.change_payment_details(payment_details)
    end
  end

  describe "tbl_payment_details" do
    alias LoanSystem.Payment.PaymentDetails

    @valid_attrs %{account_number: "some account_number", bank_number: "some bank_number", cheque_number: "some cheque_number", credit_gl_account_id: 42, debit_gl_account_id: 42, payment_type_id: 42, receipt_number: "some receipt_number", routing_code: "some routing_code"}
    @update_attrs %{account_number: "some updated account_number", bank_number: "some updated bank_number", cheque_number: "some updated cheque_number", credit_gl_account_id: 43, debit_gl_account_id: 43, payment_type_id: 43, receipt_number: "some updated receipt_number", routing_code: "some updated routing_code"}
    @invalid_attrs %{account_number: nil, bank_number: nil, cheque_number: nil, credit_gl_account_id: nil, debit_gl_account_id: nil, payment_type_id: nil, receipt_number: nil, routing_code: nil}

    def payment_details_fixture(attrs \\ %{}) do
      {:ok, payment_details} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Payment.create_payment_details()

      payment_details
    end

    test "list_tbl_payment_details/0 returns all tbl_payment_details" do
      payment_details = payment_details_fixture()
      assert Payment.list_tbl_payment_details() == [payment_details]
    end

    test "get_payment_details!/1 returns the payment_details with given id" do
      payment_details = payment_details_fixture()
      assert Payment.get_payment_details!(payment_details.id) == payment_details
    end

    test "create_payment_details/1 with valid data creates a payment_details" do
      assert {:ok, %PaymentDetails{} = payment_details} = Payment.create_payment_details(@valid_attrs)
      assert payment_details.account_number == "some account_number"
      assert payment_details.bank_number == "some bank_number"
      assert payment_details.cheque_number == "some cheque_number"
      assert payment_details.credit_gl_account_id == 42
      assert payment_details.debit_gl_account_id == 42
      assert payment_details.payment_type_id == 42
      assert payment_details.receipt_number == "some receipt_number"
      assert payment_details.routing_code == "some routing_code"
    end

    test "create_payment_details/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Payment.create_payment_details(@invalid_attrs)
    end

    test "update_payment_details/2 with valid data updates the payment_details" do
      payment_details = payment_details_fixture()
      assert {:ok, %PaymentDetails{} = payment_details} = Payment.update_payment_details(payment_details, @update_attrs)
      assert payment_details.account_number == "some updated account_number"
      assert payment_details.bank_number == "some updated bank_number"
      assert payment_details.cheque_number == "some updated cheque_number"
      assert payment_details.credit_gl_account_id == 43
      assert payment_details.debit_gl_account_id == 43
      assert payment_details.payment_type_id == 43
      assert payment_details.receipt_number == "some updated receipt_number"
      assert payment_details.routing_code == "some updated routing_code"
    end

    test "update_payment_details/2 with invalid data returns error changeset" do
      payment_details = payment_details_fixture()
      assert {:error, %Ecto.Changeset{}} = Payment.update_payment_details(payment_details, @invalid_attrs)
      assert payment_details == Payment.get_payment_details!(payment_details.id)
    end

    test "delete_payment_details/1 deletes the payment_details" do
      payment_details = payment_details_fixture()
      assert {:ok, %PaymentDetails{}} = Payment.delete_payment_details(payment_details)
      assert_raise Ecto.NoResultsError, fn -> Payment.get_payment_details!(payment_details.id) end
    end

    test "change_payment_details/1 returns a payment_details changeset" do
      payment_details = payment_details_fixture()
      assert %Ecto.Changeset{} = Payment.change_payment_details(payment_details)
    end
  end
end
