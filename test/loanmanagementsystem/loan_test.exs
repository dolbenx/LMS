defmodule Loanmanagementsystem.LoanTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Loan

  describe "tbl_customer_balance" do
    alias Loanmanagementsystem.Loan.Customer_Balance

    @valid_attrs %{account_number: "some account_number", balance: 120.5}
    @update_attrs %{account_number: "some updated account_number", balance: 456.7}
    @invalid_attrs %{account_number: nil, balance: nil}

    def customer__balance_fixture(attrs \\ %{}) do
      {:ok, customer__balance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_customer__balance()

      customer__balance
    end

    test "list_tbl_customer_balance/0 returns all tbl_customer_balance" do
      customer__balance = customer__balance_fixture()
      assert Loan.list_tbl_customer_balance() == [customer__balance]
    end

    test "get_customer__balance!/1 returns the customer__balance with given id" do
      customer__balance = customer__balance_fixture()
      assert Loan.get_customer__balance!(customer__balance.id) == customer__balance
    end

    test "create_customer__balance/1 with valid data creates a customer__balance" do
      assert {:ok, %Customer_Balance{} = customer__balance} =
               Loan.create_customer__balance(@valid_attrs)

      assert customer__balance.account_number == "some account_number"
      assert customer__balance.balance == 120.5
    end

    test "create_customer__balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_customer__balance(@invalid_attrs)
    end

    test "update_customer__balance/2 with valid data updates the customer__balance" do
      customer__balance = customer__balance_fixture()

      assert {:ok, %Customer_Balance{} = customer__balance} =
               Loan.update_customer__balance(customer__balance, @update_attrs)

      assert customer__balance.account_number == "some updated account_number"
      assert customer__balance.balance == 456.7
    end

    test "update_customer__balance/2 with invalid data returns error changeset" do
      customer__balance = customer__balance_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Loan.update_customer__balance(customer__balance, @invalid_attrs)

      assert customer__balance == Loan.get_customer__balance!(customer__balance.id)
    end

    test "delete_customer__balance/1 deletes the customer__balance" do
      customer__balance = customer__balance_fixture()
      assert {:ok, %Customer_Balance{}} = Loan.delete_customer__balance(customer__balance)

      assert_raise Ecto.NoResultsError, fn ->
        Loan.get_customer__balance!(customer__balance.id)
      end
    end

    test "change_customer__balance/1 returns a customer__balance changeset" do
      customer__balance = customer__balance_fixture()
      assert %Ecto.Changeset{} = Loan.change_customer__balance(customer__balance)
    end
  end

  describe "tbl_customer_balance" do
    alias Loanmanagementsystem.Loan.Customer_Balance

    @valid_attrs %{account_number: "some account_number", balance: 120.5, user_id: 42}
    @update_attrs %{account_number: "some updated account_number", balance: 456.7, user_id: 43}
    @invalid_attrs %{account_number: nil, balance: nil, user_id: nil}

    def customer__balance_fixture(attrs \\ %{}) do
      {:ok, customer__balance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_customer__balance()

      customer__balance
    end

    test "list_tbl_customer_balance/0 returns all tbl_customer_balance" do
      customer__balance = customer__balance_fixture()
      assert Loan.list_tbl_customer_balance() == [customer__balance]
    end

    test "get_customer__balance!/1 returns the customer__balance with given id" do
      customer__balance = customer__balance_fixture()
      assert Loan.get_customer__balance!(customer__balance.id) == customer__balance
    end

    test "create_customer__balance/1 with valid data creates a customer__balance" do
      assert {:ok, %Customer_Balance{} = customer__balance} =
               Loan.create_customer__balance(@valid_attrs)

      assert customer__balance.account_number == "some account_number"
      assert customer__balance.balance == 120.5
      assert customer__balance.user_id == 42
    end

    test "create_customer__balance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_customer__balance(@invalid_attrs)
    end

    test "update_customer__balance/2 with valid data updates the customer__balance" do
      customer__balance = customer__balance_fixture()

      assert {:ok, %Customer_Balance{} = customer__balance} =
               Loan.update_customer__balance(customer__balance, @update_attrs)

      assert customer__balance.account_number == "some updated account_number"
      assert customer__balance.balance == 456.7
      assert customer__balance.user_id == 43
    end

    test "update_customer__balance/2 with invalid data returns error changeset" do
      customer__balance = customer__balance_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Loan.update_customer__balance(customer__balance, @invalid_attrs)

      assert customer__balance == Loan.get_customer__balance!(customer__balance.id)
    end

    test "delete_customer__balance/1 deletes the customer__balance" do
      customer__balance = customer__balance_fixture()
      assert {:ok, %Customer_Balance{}} = Loan.delete_customer__balance(customer__balance)

      assert_raise Ecto.NoResultsError, fn ->
        Loan.get_customer__balance!(customer__balance.id)
      end
    end

    test "change_customer__balance/1 returns a customer__balance changeset" do
      customer__balance = customer__balance_fixture()
      assert %Ecto.Changeset{} = Loan.change_customer__balance(customer__balance)
    end
  end

  describe "tbl_loan_disbursement" do
    alias Loanmanagementsystem.Loan.Loan_disbursement

    @valid_attrs %{
      _comp_bank_account_no: "some _comp_bank_account_no",
      amount: 120.5,
      comp_account_name: "some comp_account_name",
      comp_bank_name: "some comp_bank_name",
      comp_cvv: "some comp_cvv",
      comp_expiry_month: "some comp_expiry_month",
      comp_expiry_year: "some comp_expiry_year",
      comp_mno_type: "some comp_mno_type",
      comp_mobile_no: "some comp_mobile_no",
      comp_swift_code: "some comp_swift_code",
      currency: "some currency",
      customer_id: 42,
      disbursement_dt: "some disbursement_dt",
      loan_id: 42,
      loan_product: "some loan_product",
      maker_id: 42,
      mode_of_disbursement: "some mode_of_disbursement",
      product_id: 42,
      customer_account_name: "some customer_account_name",
      customer_bank_account_no: "some customer_bank_account_no",
      customer_bank_name: "some customer_bank_name",
      customer_cvv: "some customer_cvv",
      customer_expiry_month: "some customer_expiry_month",
      customer_expiry_year: "some customer_expiry_year",
      customer_mno_mobile_no: "some customer_mno_mobile_no",
      customer_mno_type: "some customer_mno_type",
      customer_swift_code: "some customer_swift_code",
      status: "some status"
    }
    @update_attrs %{
      _comp_bank_account_no: "some updated _comp_bank_account_no",
      amount: 456.7,
      comp_account_name: "some updated comp_account_name",
      comp_bank_name: "some updated comp_bank_name",
      comp_cvv: "some updated comp_cvv",
      comp_expiry_month: "some updated comp_expiry_month",
      comp_expiry_year: "some updated comp_expiry_year",
      comp_mno_type: "some updated comp_mno_type",
      comp_mobile_no: "some updated comp_mobile_no",
      comp_swift_code: "some updated comp_swift_code",
      currency: "some updated currency",
      customer_id: 43,
      disbursement_dt: "some updated disbursement_dt",
      loan_id: 43,
      loan_product: "some updated loan_product",
      maker_id: 43,
      mode_of_disbursement: "some updated mode_of_disbursement",
      product_id: 43,
      customer_account_name: "some updated customer_account_name",
      customer_bank_account_no: "some updated customer_bank_account_no",
      customer_bank_name: "some updated customer_bank_name",
      customer_cvv: "some updated customer_cvv",
      customer_expiry_month: "some updated customer_expiry_month",
      customer_expiry_year: "some updated customer_expiry_year",
      customer_mno_mobile_no: "some updated customer_mno_mobile_no",
      customer_mno_type: "some updated customer_mno_type",
      customer_swift_code: "some updated customer_swift_code",
      status: "some updated status"
    }
    @invalid_attrs %{
      _comp_bank_account_no: nil,
      amount: nil,
      comp_account_name: nil,
      comp_bank_name: nil,
      comp_cvv: nil,
      comp_expiry_month: nil,
      comp_expiry_year: nil,
      comp_mno_type: nil,
      comp_mobile_no: nil,
      comp_swift_code: nil,
      currency: nil,
      customer_id: nil,
      disbursement_dt: nil,
      loan_id: nil,
      loan_product: nil,
      maker_id: nil,
      mode_of_disbursement: nil,
      product_id: nil,
      customer_account_name: nil,
      customer_bank_account_no: nil,
      customer_bank_name: nil,
      customer_cvv: nil,
      customer_expiry_month: nil,
      customer_expiry_year: nil,
      customer_mno_mobile_no: nil,
      customer_mno_type: nil,
      customer_swift_code: nil,
      status: nil
    }

    def loan_disbursement_fixture(attrs \\ %{}) do
      {:ok, loan_disbursement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_disbursement()

      loan_disbursement
    end

    test "list_tbl_loan_disbursement/0 returns all tbl_loan_disbursement" do
      loan_disbursement = loan_disbursement_fixture()
      assert Loan.list_tbl_loan_disbursement() == [loan_disbursement]
    end

    test "get_loan_disbursement!/1 returns the loan_disbursement with given id" do
      loan_disbursement = loan_disbursement_fixture()
      assert Loan.get_loan_disbursement!(loan_disbursement.id) == loan_disbursement
    end

    test "create_loan_disbursement/1 with valid data creates a loan_disbursement" do
      assert {:ok, %Loan_disbursement{} = loan_disbursement} =
               Loan.create_loan_disbursement(@valid_attrs)

      assert loan_disbursement._comp_bank_account_no == "some _comp_bank_account_no"
      assert loan_disbursement.amount == 120.5
      assert loan_disbursement.comp_account_name == "some comp_account_name"
      assert loan_disbursement.comp_bank_name == "some comp_bank_name"
      assert loan_disbursement.comp_cvv == "some comp_cvv"
      assert loan_disbursement.comp_expiry_month == "some comp_expiry_month"
      assert loan_disbursement.comp_expiry_year == "some comp_expiry_year"
      assert loan_disbursement.comp_mno_type == "some comp_mno_type"
      assert loan_disbursement.comp_mobile_no == "some comp_mobile_no"
      assert loan_disbursement.comp_swift_code == "some comp_swift_code"
      assert loan_disbursement.currency == "some currency"
      assert loan_disbursement.customer_id == 42
      assert loan_disbursement.disbursement_dt == "some disbursement_dt"
      assert loan_disbursement.loan_id == 42
      assert loan_disbursement.loan_product == "some loan_product"
      assert loan_disbursement.maker_id == 42
      assert loan_disbursement.mode_of_disbursement == "some mode_of_disbursement"
      assert loan_disbursement.product_id == 42
      assert loan_disbursement.customer_account_name == "some customer_account_name"
      assert loan_disbursement.customer_bank_account_no == "some customer_bank_account_no"
      assert loan_disbursement.customer_bank_name == "some customer_bank_name"
      assert loan_disbursement.customer_cvv == "some customer_cvv"
      assert loan_disbursement.customer_expiry_month == "some customer_expiry_month"
      assert loan_disbursement.customer_expiry_year == "some customer_expiry_year"
      assert loan_disbursement.customer_mno_mobile_no == "some customer_mno_mobile_no"
      assert loan_disbursement.customer_mno_type == "some customer_mno_type"
      assert loan_disbursement.customer_swift_code == "some customer_swift_code"
      assert loan_disbursement.status == "some status"
    end

    test "create_loan_disbursement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_disbursement(@invalid_attrs)
    end

    test "update_loan_disbursement/2 with valid data updates the loan_disbursement" do
      loan_disbursement = loan_disbursement_fixture()

      assert {:ok, %Loan_disbursement{} = loan_disbursement} =
               Loan.update_loan_disbursement(loan_disbursement, @update_attrs)

      assert loan_disbursement._comp_bank_account_no == "some updated _comp_bank_account_no"
      assert loan_disbursement.amount == 456.7
      assert loan_disbursement.comp_account_name == "some updated comp_account_name"
      assert loan_disbursement.comp_bank_name == "some updated comp_bank_name"
      assert loan_disbursement.comp_cvv == "some updated comp_cvv"
      assert loan_disbursement.comp_expiry_month == "some updated comp_expiry_month"
      assert loan_disbursement.comp_expiry_year == "some updated comp_expiry_year"
      assert loan_disbursement.comp_mno_type == "some updated comp_mno_type"
      assert loan_disbursement.comp_mobile_no == "some updated comp_mobile_no"
      assert loan_disbursement.comp_swift_code == "some updated comp_swift_code"
      assert loan_disbursement.currency == "some updated currency"
      assert loan_disbursement.customer_id == 43
      assert loan_disbursement.disbursement_dt == "some updated disbursement_dt"
      assert loan_disbursement.loan_id == 43
      assert loan_disbursement.loan_product == "some updated loan_product"
      assert loan_disbursement.maker_id == 43
      assert loan_disbursement.mode_of_disbursement == "some updated mode_of_disbursement"
      assert loan_disbursement.product_id == 43
      assert loan_disbursement.customer_account_name == "some updated customer_account_name"
      assert loan_disbursement.customer_bank_account_no == "some updated customer_bank_account_no"
      assert loan_disbursement.customer_bank_name == "some updated customer_bank_name"
      assert loan_disbursement.customer_cvv == "some updated customer_cvv"
      assert loan_disbursement.customer_expiry_month == "some updated customer_expiry_month"
      assert loan_disbursement.customer_expiry_year == "some updated customer_expiry_year"
      assert loan_disbursement.customer_mno_mobile_no == "some updated customer_mno_mobile_no"
      assert loan_disbursement.customer_mno_type == "some updated customer_mno_type"
      assert loan_disbursement.customer_swift_code == "some updated customer_swift_code"
      assert loan_disbursement.status == "some updated status"
    end

    test "update_loan_disbursement/2 with invalid data returns error changeset" do
      loan_disbursement = loan_disbursement_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Loan.update_loan_disbursement(loan_disbursement, @invalid_attrs)

      assert loan_disbursement == Loan.get_loan_disbursement!(loan_disbursement.id)
    end

    test "delete_loan_disbursement/1 deletes the loan_disbursement" do
      loan_disbursement = loan_disbursement_fixture()
      assert {:ok, %Loan_disbursement{}} = Loan.delete_loan_disbursement(loan_disbursement)

      assert_raise Ecto.NoResultsError, fn ->
        Loan.get_loan_disbursement!(loan_disbursement.id)
      end
    end

    test "change_loan_disbursement/1 returns a loan_disbursement changeset" do
      loan_disbursement = loan_disbursement_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_disbursement(loan_disbursement)
    end
  end

  describe "tbl_loan_provisioning_criteria" do
    alias Loanmanagementsystem.Loan.Loan_Provisioning_Criteria

    @valid_attrs %{
      category: "some category",
      criteriaName: "some criteriaName",
      expense_account_id: "some expense_account_id",
      liability_account_id: "some liability_account_id",
      maxAge: "some maxAge",
      minAge: "some minAge",
      percentage: "some percentage",
      productId: 42
    }
    @update_attrs %{
      category: "some updated category",
      criteriaName: "some updated criteriaName",
      expense_account_id: "some updated expense_account_id",
      liability_account_id: "some updated liability_account_id",
      maxAge: "some updated maxAge",
      minAge: "some updated minAge",
      percentage: "some updated percentage",
      productId: 43
    }
    @invalid_attrs %{
      category: nil,
      criteriaName: nil,
      expense_account_id: nil,
      liability_account_id: nil,
      maxAge: nil,
      minAge: nil,
      percentage: nil,
      productId: nil
    }

    def loan__provisioning__criteria_fixture(attrs \\ %{}) do
      {:ok, loan__provisioning__criteria} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan__provisioning__criteria()

      loan__provisioning__criteria
    end

    test "list_tbl_loan_provisioning_criteria/0 returns all tbl_loan_provisioning_criteria" do
      loan__provisioning__criteria = loan__provisioning__criteria_fixture()
      assert Loan.list_tbl_loan_provisioning_criteria() == [loan__provisioning__criteria]
    end

    test "get_loan__provisioning__criteria!/1 returns the loan__provisioning__criteria with given id" do
      loan__provisioning__criteria = loan__provisioning__criteria_fixture()

      assert Loan.get_loan__provisioning__criteria!(loan__provisioning__criteria.id) ==
               loan__provisioning__criteria
    end

    test "create_loan__provisioning__criteria/1 with valid data creates a loan__provisioning__criteria" do
      assert {:ok, %Loan_Provisioning_Criteria{} = loan__provisioning__criteria} =
               Loan.create_loan__provisioning__criteria(@valid_attrs)

      assert loan__provisioning__criteria.category == "some category"
      assert loan__provisioning__criteria.criteriaName == "some criteriaName"
      assert loan__provisioning__criteria.expense_account_id == "some expense_account_id"
      assert loan__provisioning__criteria.liability_account_id == "some liability_account_id"
      assert loan__provisioning__criteria.maxAge == "some maxAge"
      assert loan__provisioning__criteria.minAge == "some minAge"
      assert loan__provisioning__criteria.percentage == "some percentage"
      assert loan__provisioning__criteria.productId == 42
    end

    test "create_loan__provisioning__criteria/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Loan.create_loan__provisioning__criteria(@invalid_attrs)
    end

    test "update_loan__provisioning__criteria/2 with valid data updates the loan__provisioning__criteria" do
      loan__provisioning__criteria = loan__provisioning__criteria_fixture()

      assert {:ok, %Loan_Provisioning_Criteria{} = loan__provisioning__criteria} =
               Loan.update_loan__provisioning__criteria(
                 loan__provisioning__criteria,
                 @update_attrs
               )

      assert loan__provisioning__criteria.category == "some updated category"
      assert loan__provisioning__criteria.criteriaName == "some updated criteriaName"
      assert loan__provisioning__criteria.expense_account_id == "some updated expense_account_id"

      assert loan__provisioning__criteria.liability_account_id ==
               "some updated liability_account_id"

      assert loan__provisioning__criteria.maxAge == "some updated maxAge"
      assert loan__provisioning__criteria.minAge == "some updated minAge"
      assert loan__provisioning__criteria.percentage == "some updated percentage"
      assert loan__provisioning__criteria.productId == 43
    end

    test "update_loan__provisioning__criteria/2 with invalid data returns error changeset" do
      loan__provisioning__criteria = loan__provisioning__criteria_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Loan.update_loan__provisioning__criteria(
                 loan__provisioning__criteria,
                 @invalid_attrs
               )

      assert loan__provisioning__criteria ==
               Loan.get_loan__provisioning__criteria!(loan__provisioning__criteria.id)
    end

    test "delete_loan__provisioning__criteria/1 deletes the loan__provisioning__criteria" do
      loan__provisioning__criteria = loan__provisioning__criteria_fixture()

      assert {:ok, %Loan_Provisioning_Criteria{}} =
               Loan.delete_loan__provisioning__criteria(loan__provisioning__criteria)

      assert_raise Ecto.NoResultsError, fn ->
        Loan.get_loan__provisioning__criteria!(loan__provisioning__criteria.id)
      end
    end

    test "change_loan__provisioning__criteria/1 returns a loan__provisioning__criteria changeset" do
      loan__provisioning__criteria = loan__provisioning__criteria_fixture()

      assert %Ecto.Changeset{} =
               Loan.change_loan__provisioning__criteria(loan__provisioning__criteria)
    end
  end

  describe "tbl_loan_application_documents" do
    alias Loanmanagementsystem.Loan.Loan_application_documents

    @valid_attrs %{customer_id: 42, doc_name: "some doc_name", doc_type: "some doc_type", path: "some path", status: "some status", user_id: 42}
    @update_attrs %{customer_id: 43, doc_name: "some updated doc_name", doc_type: "some updated doc_type", path: "some updated path", status: "some updated status", user_id: 43}
    @invalid_attrs %{customer_id: nil, doc_name: nil, doc_type: nil, path: nil, status: nil, user_id: nil}

    def loan_application_documents_fixture(attrs \\ %{}) do
      {:ok, loan_application_documents} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_application_documents()

      loan_application_documents
    end

    test "list_tbl_loan_application_documents/0 returns all tbl_loan_application_documents" do
      loan_application_documents = loan_application_documents_fixture()
      assert Loan.list_tbl_loan_application_documents() == [loan_application_documents]
    end

    test "get_loan_application_documents!/1 returns the loan_application_documents with given id" do
      loan_application_documents = loan_application_documents_fixture()
      assert Loan.get_loan_application_documents!(loan_application_documents.id) == loan_application_documents
    end

    test "create_loan_application_documents/1 with valid data creates a loan_application_documents" do
      assert {:ok, %Loan_application_documents{} = loan_application_documents} = Loan.create_loan_application_documents(@valid_attrs)
      assert loan_application_documents.customer_id == 42
      assert loan_application_documents.doc_name == "some doc_name"
      assert loan_application_documents.doc_type == "some doc_type"
      assert loan_application_documents.path == "some path"
      assert loan_application_documents.status == "some status"
      assert loan_application_documents.user_id == 42
    end

    test "create_loan_application_documents/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_application_documents(@invalid_attrs)
    end

    test "update_loan_application_documents/2 with valid data updates the loan_application_documents" do
      loan_application_documents = loan_application_documents_fixture()
      assert {:ok, %Loan_application_documents{} = loan_application_documents} = Loan.update_loan_application_documents(loan_application_documents, @update_attrs)
      assert loan_application_documents.customer_id == 43
      assert loan_application_documents.doc_name == "some updated doc_name"
      assert loan_application_documents.doc_type == "some updated doc_type"
      assert loan_application_documents.path == "some updated path"
      assert loan_application_documents.status == "some updated status"
      assert loan_application_documents.user_id == 43
    end

    test "update_loan_application_documents/2 with invalid data returns error changeset" do
      loan_application_documents = loan_application_documents_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_application_documents(loan_application_documents, @invalid_attrs)
      assert loan_application_documents == Loan.get_loan_application_documents!(loan_application_documents.id)
    end

    test "delete_loan_application_documents/1 deletes the loan_application_documents" do
      loan_application_documents = loan_application_documents_fixture()
      assert {:ok, %Loan_application_documents{}} = Loan.delete_loan_application_documents(loan_application_documents)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_application_documents!(loan_application_documents.id) end
    end

    test "change_loan_application_documents/1 returns a loan_application_documents changeset" do
      loan_application_documents = loan_application_documents_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_application_documents(loan_application_documents)
    end
  end

  describe "tbl_loan_disbursement_method" do
    alias Loanmanagementsystem.Loan.Loan_disbursement_method

    @valid_attrs %{amount: 120.5, currency: "some currency", disbursement_method: "some disbursement_method", loan_id: 42, product_id: 42, userId: 42}
    @update_attrs %{amount: 456.7, currency: "some updated currency", disbursement_method: "some updated disbursement_method", loan_id: 43, product_id: 43, userId: 43}
    @invalid_attrs %{amount: nil, currency: nil, disbursement_method: nil, loan_id: nil, product_id: nil, userId: nil}

    def loan_disbursement_method_fixture(attrs \\ %{}) do
      {:ok, loan_disbursement_method} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_disbursement_method()

      loan_disbursement_method
    end

    test "list_tbl_loan_disbursement_method/0 returns all tbl_loan_disbursement_method" do
      loan_disbursement_method = loan_disbursement_method_fixture()
      assert Loan.list_tbl_loan_disbursement_method() == [loan_disbursement_method]
    end

    test "get_loan_disbursement_method!/1 returns the loan_disbursement_method with given id" do
      loan_disbursement_method = loan_disbursement_method_fixture()
      assert Loan.get_loan_disbursement_method!(loan_disbursement_method.id) == loan_disbursement_method
    end

    test "create_loan_disbursement_method/1 with valid data creates a loan_disbursement_method" do
      assert {:ok, %Loan_disbursement_method{} = loan_disbursement_method} = Loan.create_loan_disbursement_method(@valid_attrs)
      assert loan_disbursement_method.amount == 120.5
      assert loan_disbursement_method.currency == "some currency"
      assert loan_disbursement_method.disbursement_method == "some disbursement_method"
      assert loan_disbursement_method.loan_id == 42
      assert loan_disbursement_method.product_id == 42
      assert loan_disbursement_method.userId == 42
    end

    test "create_loan_disbursement_method/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_disbursement_method(@invalid_attrs)
    end

    test "update_loan_disbursement_method/2 with valid data updates the loan_disbursement_method" do
      loan_disbursement_method = loan_disbursement_method_fixture()
      assert {:ok, %Loan_disbursement_method{} = loan_disbursement_method} = Loan.update_loan_disbursement_method(loan_disbursement_method, @update_attrs)
      assert loan_disbursement_method.amount == 456.7
      assert loan_disbursement_method.currency == "some updated currency"
      assert loan_disbursement_method.disbursement_method == "some updated disbursement_method"
      assert loan_disbursement_method.loan_id == 43
      assert loan_disbursement_method.product_id == 43
      assert loan_disbursement_method.userId == 43
    end

    test "update_loan_disbursement_method/2 with invalid data returns error changeset" do
      loan_disbursement_method = loan_disbursement_method_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_disbursement_method(loan_disbursement_method, @invalid_attrs)
      assert loan_disbursement_method == Loan.get_loan_disbursement_method!(loan_disbursement_method.id)
    end

    test "delete_loan_disbursement_method/1 deletes the loan_disbursement_method" do
      loan_disbursement_method = loan_disbursement_method_fixture()
      assert {:ok, %Loan_disbursement_method{}} = Loan.delete_loan_disbursement_method(loan_disbursement_method)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_disbursement_method!(loan_disbursement_method.id) end
    end

    test "change_loan_disbursement_method/1 returns a loan_disbursement_method changeset" do
      loan_disbursement_method = loan_disbursement_method_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_disbursement_method(loan_disbursement_method)
    end
  end
end
