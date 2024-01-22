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

  describe "tbl_nextofkin" do
    alias Loanmanagementsystem.Loan.Loan_applicant_nextofkin

    @valid_attrs %{consent_crb: "some consent_crb", customer_id: 42, firstname: "some firstname", gender: "some gender", mobile_no: "some mobile_no", relationship: "some relationship", surname: "some surname"}
    @update_attrs %{consent_crb: "some updated consent_crb", customer_id: 43, firstname: "some updated firstname", gender: "some updated gender", mobile_no: "some updated mobile_no", relationship: "some updated relationship", surname: "some updated surname"}
    @invalid_attrs %{consent_crb: nil, customer_id: nil, firstname: nil, gender: nil, mobile_no: nil, relationship: nil, surname: nil}

    def loan_applicant_nextofkin_fixture(attrs \\ %{}) do
      {:ok, loan_applicant_nextofkin} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_applicant_nextofkin()

      loan_applicant_nextofkin
    end

    test "list_tbl_nextofkin/0 returns all tbl_nextofkin" do
      loan_applicant_nextofkin = loan_applicant_nextofkin_fixture()
      assert Loan.list_tbl_nextofkin() == [loan_applicant_nextofkin]
    end

    test "get_loan_applicant_nextofkin!/1 returns the loan_applicant_nextofkin with given id" do
      loan_applicant_nextofkin = loan_applicant_nextofkin_fixture()
      assert Loan.get_loan_applicant_nextofkin!(loan_applicant_nextofkin.id) == loan_applicant_nextofkin
    end

    test "create_loan_applicant_nextofkin/1 with valid data creates a loan_applicant_nextofkin" do
      assert {:ok, %Loan_applicant_nextofkin{} = loan_applicant_nextofkin} = Loan.create_loan_applicant_nextofkin(@valid_attrs)
      assert loan_applicant_nextofkin.consent_crb == "some consent_crb"
      assert loan_applicant_nextofkin.customer_id == 42
      assert loan_applicant_nextofkin.firstname == "some firstname"
      assert loan_applicant_nextofkin.gender == "some gender"
      assert loan_applicant_nextofkin.mobile_no == "some mobile_no"
      assert loan_applicant_nextofkin.relationship == "some relationship"
      assert loan_applicant_nextofkin.surname == "some surname"
    end

    test "create_loan_applicant_nextofkin/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_applicant_nextofkin(@invalid_attrs)
    end

    test "update_loan_applicant_nextofkin/2 with valid data updates the loan_applicant_nextofkin" do
      loan_applicant_nextofkin = loan_applicant_nextofkin_fixture()
      assert {:ok, %Loan_applicant_nextofkin{} = loan_applicant_nextofkin} = Loan.update_loan_applicant_nextofkin(loan_applicant_nextofkin, @update_attrs)
      assert loan_applicant_nextofkin.consent_crb == "some updated consent_crb"
      assert loan_applicant_nextofkin.customer_id == 43
      assert loan_applicant_nextofkin.firstname == "some updated firstname"
      assert loan_applicant_nextofkin.gender == "some updated gender"
      assert loan_applicant_nextofkin.mobile_no == "some updated mobile_no"
      assert loan_applicant_nextofkin.relationship == "some updated relationship"
      assert loan_applicant_nextofkin.surname == "some updated surname"
    end

    test "update_loan_applicant_nextofkin/2 with invalid data returns error changeset" do
      loan_applicant_nextofkin = loan_applicant_nextofkin_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_applicant_nextofkin(loan_applicant_nextofkin, @invalid_attrs)
      assert loan_applicant_nextofkin == Loan.get_loan_applicant_nextofkin!(loan_applicant_nextofkin.id)
    end

    test "delete_loan_applicant_nextofkin/1 deletes the loan_applicant_nextofkin" do
      loan_applicant_nextofkin = loan_applicant_nextofkin_fixture()
      assert {:ok, %Loan_applicant_nextofkin{}} = Loan.delete_loan_applicant_nextofkin(loan_applicant_nextofkin)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_applicant_nextofkin!(loan_applicant_nextofkin.id) end
    end

    test "change_loan_applicant_nextofkin/1 returns a loan_applicant_nextofkin changeset" do
      loan_applicant_nextofkin = loan_applicant_nextofkin_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_applicant_nextofkin(loan_applicant_nextofkin)
    end
  end

  describe "tbl_reference" do
    alias Loanmanagementsystem.Loan.Loan_applicant_reference

    @valid_attrs %{contact_no: "some contact_no", customer_id: 42, name: "some name"}
    @update_attrs %{contact_no: "some updated contact_no", customer_id: 43, name: "some updated name"}
    @invalid_attrs %{contact_no: nil, customer_id: nil, name: nil}

    def loan_applicant_reference_fixture(attrs \\ %{}) do
      {:ok, loan_applicant_reference} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_applicant_reference()

      loan_applicant_reference
    end

    test "list_tbl_reference/0 returns all tbl_reference" do
      loan_applicant_reference = loan_applicant_reference_fixture()
      assert Loan.list_tbl_reference() == [loan_applicant_reference]
    end

    test "get_loan_applicant_reference!/1 returns the loan_applicant_reference with given id" do
      loan_applicant_reference = loan_applicant_reference_fixture()
      assert Loan.get_loan_applicant_reference!(loan_applicant_reference.id) == loan_applicant_reference
    end

    test "create_loan_applicant_reference/1 with valid data creates a loan_applicant_reference" do
      assert {:ok, %Loan_applicant_reference{} = loan_applicant_reference} = Loan.create_loan_applicant_reference(@valid_attrs)
      assert loan_applicant_reference.contact_no == "some contact_no"
      assert loan_applicant_reference.customer_id == 42
      assert loan_applicant_reference.name == "some name"
    end

    test "create_loan_applicant_reference/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_applicant_reference(@invalid_attrs)
    end

    test "update_loan_applicant_reference/2 with valid data updates the loan_applicant_reference" do
      loan_applicant_reference = loan_applicant_reference_fixture()
      assert {:ok, %Loan_applicant_reference{} = loan_applicant_reference} = Loan.update_loan_applicant_reference(loan_applicant_reference, @update_attrs)
      assert loan_applicant_reference.contact_no == "some updated contact_no"
      assert loan_applicant_reference.customer_id == 43
      assert loan_applicant_reference.name == "some updated name"
    end

    test "update_loan_applicant_reference/2 with invalid data returns error changeset" do
      loan_applicant_reference = loan_applicant_reference_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_applicant_reference(loan_applicant_reference, @invalid_attrs)
      assert loan_applicant_reference == Loan.get_loan_applicant_reference!(loan_applicant_reference.id)
    end

    test "delete_loan_applicant_reference/1 deletes the loan_applicant_reference" do
      loan_applicant_reference = loan_applicant_reference_fixture()
      assert {:ok, %Loan_applicant_reference{}} = Loan.delete_loan_applicant_reference(loan_applicant_reference)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_applicant_reference!(loan_applicant_reference.id) end
    end

    test "change_loan_applicant_reference/1 returns a loan_applicant_reference changeset" do
      loan_applicant_reference = loan_applicant_reference_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_applicant_reference(loan_applicant_reference)
    end
  end

  describe "tbl_collateral" do
    alias Loanmanagementsystem.Loan.Loan_applicant_collateral

    @valid_attrs %{asset_value: "some asset_value", color: "some color", customer_id: 42, id_number: "some id_number", name_of_collateral: "some name_of_collateral"}
    @update_attrs %{asset_value: "some updated asset_value", color: "some updated color", customer_id: 43, id_number: "some updated id_number", name_of_collateral: "some updated name_of_collateral"}
    @invalid_attrs %{asset_value: nil, color: nil, customer_id: nil, id_number: nil, name_of_collateral: nil}

    def loan_applicant_collateral_fixture(attrs \\ %{}) do
      {:ok, loan_applicant_collateral} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_applicant_collateral()

      loan_applicant_collateral
    end

    test "list_tbl_collateral/0 returns all tbl_collateral" do
      loan_applicant_collateral = loan_applicant_collateral_fixture()
      assert Loan.list_tbl_collateral() == [loan_applicant_collateral]
    end

    test "get_loan_applicant_collateral!/1 returns the loan_applicant_collateral with given id" do
      loan_applicant_collateral = loan_applicant_collateral_fixture()
      assert Loan.get_loan_applicant_collateral!(loan_applicant_collateral.id) == loan_applicant_collateral
    end

    test "create_loan_applicant_collateral/1 with valid data creates a loan_applicant_collateral" do
      assert {:ok, %Loan_applicant_collateral{} = loan_applicant_collateral} = Loan.create_loan_applicant_collateral(@valid_attrs)
      assert loan_applicant_collateral.asset_value == "some asset_value"
      assert loan_applicant_collateral.color == "some color"
      assert loan_applicant_collateral.customer_id == 42
      assert loan_applicant_collateral.id_number == "some id_number"
      assert loan_applicant_collateral.name_of_collateral == "some name_of_collateral"
    end

    test "create_loan_applicant_collateral/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_applicant_collateral(@invalid_attrs)
    end

    test "update_loan_applicant_collateral/2 with valid data updates the loan_applicant_collateral" do
      loan_applicant_collateral = loan_applicant_collateral_fixture()
      assert {:ok, %Loan_applicant_collateral{} = loan_applicant_collateral} = Loan.update_loan_applicant_collateral(loan_applicant_collateral, @update_attrs)
      assert loan_applicant_collateral.asset_value == "some updated asset_value"
      assert loan_applicant_collateral.color == "some updated color"
      assert loan_applicant_collateral.customer_id == 43
      assert loan_applicant_collateral.id_number == "some updated id_number"
      assert loan_applicant_collateral.name_of_collateral == "some updated name_of_collateral"
    end

    test "update_loan_applicant_collateral/2 with invalid data returns error changeset" do
      loan_applicant_collateral = loan_applicant_collateral_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_applicant_collateral(loan_applicant_collateral, @invalid_attrs)
      assert loan_applicant_collateral == Loan.get_loan_applicant_collateral!(loan_applicant_collateral.id)
    end

    test "delete_loan_applicant_collateral/1 deletes the loan_applicant_collateral" do
      loan_applicant_collateral = loan_applicant_collateral_fixture()
      assert {:ok, %Loan_applicant_collateral{}} = Loan.delete_loan_applicant_collateral(loan_applicant_collateral)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_applicant_collateral!(loan_applicant_collateral.id) end
    end

    test "change_loan_applicant_collateral/1 returns a loan_applicant_collateral changeset" do
      loan_applicant_collateral = loan_applicant_collateral_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_applicant_collateral(loan_applicant_collateral)
    end
  end

  describe "tbl_guarantor" do
    alias Loanmanagementsystem.Loan.Loan_applicant_guarantor

    @valid_attrs %{cost_of_sales: "some cost_of_sales", occupation: "some occupation", customer_id: 42, email: "some email", employer: "some employer", gaurantor_sign_date: "some gaurantor_sign_date", gaurantor_signature: "some gaurantor_signature", guarantor_name: "some guarantor_name", guarantor_phone_no: "some guarantor_phone_no", loan_applicant_name: "some loan_applicant_name", name_of_cro_staff: "some name_of_cro_staff", name_of_witness: "some name_of_witness", net_profit_loss: "some net_profit_loss", nrc: "some nrc", other_expenses: "some other_expenses", other_income_bills: "some other_income_bills", relationship: "some relationship", salary_loan: "some salary_loan", sale_business_rentals: "some sale_business_rentals", staff_sign_date: "some staff_sign_date", staff_signature: "some staff_signature", total_income_expense: "some total_income_expense"}
    @update_attrs %{cost_of_sales: "some updated cost_of_sales", occupation: "some updated occupation", customer_id: 43, email: "some updated email", employer: "some updated employer", gaurantor_sign_date: "some updated gaurantor_sign_date", gaurantor_signature: "some updated gaurantor_signature", guarantor_name: "some updated guarantor_name", guarantor_phone_no: "some updated guarantor_phone_no", loan_applicant_name: "some updated loan_applicant_name", name_of_cro_staff: "some updated name_of_cro_staff", name_of_witness: "some updated name_of_witness", net_profit_loss: "some updated net_profit_loss", nrc: "some updated nrc", other_expenses: "some updated other_expenses", other_income_bills: "some updated other_income_bills", relationship: "some updated relationship", salary_loan: "some updated salary_loan", sale_business_rentals: "some updated sale_business_rentals", staff_sign_date: "some updated staff_sign_date", staff_signature: "some updated staff_signature", total_income_expense: "some updated total_income_expense"}
    @invalid_attrs %{cost_of_sales: nil, occupation: nil, customer_id: nil, email: nil, employer: nil, gaurantor_sign_date: nil, gaurantor_signature: nil, guarantor_name: nil, guarantor_phone_no: nil, loan_applicant_name: nil, name_of_cro_staff: nil, name_of_witness: nil, net_profit_loss: nil, nrc: nil, other_expenses: nil, other_income_bills: nil, relationship: nil, salary_loan: nil, sale_business_rentals: nil, staff_sign_date: nil, staff_signature: nil, total_income_expense: nil}

    def loan_applicant_guarantor_fixture(attrs \\ %{}) do
      {:ok, loan_applicant_guarantor} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_applicant_guarantor()

      loan_applicant_guarantor
    end

    test "list_tbl_guarantor/0 returns all tbl_guarantor" do
      loan_applicant_guarantor = loan_applicant_guarantor_fixture()
      assert Loan.list_tbl_guarantor() == [loan_applicant_guarantor]
    end

    test "get_loan_applicant_guarantor!/1 returns the loan_applicant_guarantor with given id" do
      loan_applicant_guarantor = loan_applicant_guarantor_fixture()
      assert Loan.get_loan_applicant_guarantor!(loan_applicant_guarantor.id) == loan_applicant_guarantor
    end

    test "create_loan_applicant_guarantor/1 with valid data creates a loan_applicant_guarantor" do
      assert {:ok, %Loan_applicant_guarantor{} = loan_applicant_guarantor} = Loan.create_loan_applicant_guarantor(@valid_attrs)
      assert loan_applicant_guarantor.cost_of_sales == "some cost_of_sales"
      assert loan_applicant_guarantor.occupation == "some occupation"
      assert loan_applicant_guarantor.customer_id == 42
      assert loan_applicant_guarantor.email == "some email"
      assert loan_applicant_guarantor.employer == "some employer"
      assert loan_applicant_guarantor.gaurantor_sign_date == "some gaurantor_sign_date"
      assert loan_applicant_guarantor.gaurantor_signature == "some gaurantor_signature"
      assert loan_applicant_guarantor.guarantor_name == "some guarantor_name"
      assert loan_applicant_guarantor.guarantor_phone_no == "some guarantor_phone_no"
      assert loan_applicant_guarantor.loan_applicant_name == "some loan_applicant_name"
      assert loan_applicant_guarantor.name_of_cro_staff == "some name_of_cro_staff"
      assert loan_applicant_guarantor.name_of_witness == "some name_of_witness"
      assert loan_applicant_guarantor.net_profit_loss == "some net_profit_loss"
      assert loan_applicant_guarantor.nrc == "some nrc"
      assert loan_applicant_guarantor.other_expenses == "some other_expenses"
      assert loan_applicant_guarantor.other_income_bills == "some other_income_bills"
      assert loan_applicant_guarantor.relationship == "some relationship"
      assert loan_applicant_guarantor.salary_loan == "some salary_loan"
      assert loan_applicant_guarantor.sale_business_rentals == "some sale_business_rentals"
      assert loan_applicant_guarantor.staff_sign_date == "some staff_sign_date"
      assert loan_applicant_guarantor.staff_signature == "some staff_signature"
      assert loan_applicant_guarantor.total_income_expense == "some total_income_expense"
    end

    test "create_loan_applicant_guarantor/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_applicant_guarantor(@invalid_attrs)
    end

    test "update_loan_applicant_guarantor/2 with valid data updates the loan_applicant_guarantor" do
      loan_applicant_guarantor = loan_applicant_guarantor_fixture()
      assert {:ok, %Loan_applicant_guarantor{} = loan_applicant_guarantor} = Loan.update_loan_applicant_guarantor(loan_applicant_guarantor, @update_attrs)
      assert loan_applicant_guarantor.cost_of_sales == "some updated cost_of_sales"
      assert loan_applicant_guarantor.occupation == "some updated occupation"
      assert loan_applicant_guarantor.customer_id == 43
      assert loan_applicant_guarantor.email == "some updated email"
      assert loan_applicant_guarantor.employer == "some updated employer"
      assert loan_applicant_guarantor.gaurantor_sign_date == "some updated gaurantor_sign_date"
      assert loan_applicant_guarantor.gaurantor_signature == "some updated gaurantor_signature"
      assert loan_applicant_guarantor.guarantor_name == "some updated guarantor_name"
      assert loan_applicant_guarantor.guarantor_phone_no == "some updated guarantor_phone_no"
      assert loan_applicant_guarantor.loan_applicant_name == "some updated loan_applicant_name"
      assert loan_applicant_guarantor.name_of_cro_staff == "some updated name_of_cro_staff"
      assert loan_applicant_guarantor.name_of_witness == "some updated name_of_witness"
      assert loan_applicant_guarantor.net_profit_loss == "some updated net_profit_loss"
      assert loan_applicant_guarantor.nrc == "some updated nrc"
      assert loan_applicant_guarantor.other_expenses == "some updated other_expenses"
      assert loan_applicant_guarantor.other_income_bills == "some updated other_income_bills"
      assert loan_applicant_guarantor.relationship == "some updated relationship"
      assert loan_applicant_guarantor.salary_loan == "some updated salary_loan"
      assert loan_applicant_guarantor.sale_business_rentals == "some updated sale_business_rentals"
      assert loan_applicant_guarantor.staff_sign_date == "some updated staff_sign_date"
      assert loan_applicant_guarantor.staff_signature == "some updated staff_signature"
      assert loan_applicant_guarantor.total_income_expense == "some updated total_income_expense"
    end

    test "update_loan_applicant_guarantor/2 with invalid data returns error changeset" do
      loan_applicant_guarantor = loan_applicant_guarantor_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_applicant_guarantor(loan_applicant_guarantor, @invalid_attrs)
      assert loan_applicant_guarantor == Loan.get_loan_applicant_guarantor!(loan_applicant_guarantor.id)
    end

    test "delete_loan_applicant_guarantor/1 deletes the loan_applicant_guarantor" do
      loan_applicant_guarantor = loan_applicant_guarantor_fixture()
      assert {:ok, %Loan_applicant_guarantor{}} = Loan.delete_loan_applicant_guarantor(loan_applicant_guarantor)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_applicant_guarantor!(loan_applicant_guarantor.id) end
    end

    test "change_loan_applicant_guarantor/1 returns a loan_applicant_guarantor changeset" do
      loan_applicant_guarantor = loan_applicant_guarantor_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_applicant_guarantor(loan_applicant_guarantor)
    end
  end

  describe "tbl_loan_customer_details" do
    alias Loanmanagementsystem.Loan.Loan_customer_details

    @valid_attrs %{cell_number: "some cell_number", customer_id: 42, dob: "some dob", email: "some email", firstname: "some firstname", gender: "some gender", id_number: "some id_number", id_type: "some id_type", landmark: "some landmark", marital_status: "some marital_status", othername: "some othername", province: "some province", residential_address: "some residential_address", surname: "some surname", town: "some town"}
    @update_attrs %{cell_number: "some updated cell_number", customer_id: 43, dob: "some updated dob", email: "some updated email", firstname: "some updated firstname", gender: "some updated gender", id_number: "some updated id_number", id_type: "some updated id_type", landmark: "some updated landmark", marital_status: "some updated marital_status", othername: "some updated othername", province: "some updated province", residential_address: "some updated residential_address", surname: "some updated surname", town: "some updated town"}
    @invalid_attrs %{cell_number: nil, customer_id: nil, dob: nil, email: nil, firstname: nil, gender: nil, id_number: nil, id_type: nil, landmark: nil, marital_status: nil, othername: nil, province: nil, residential_address: nil, surname: nil, town: nil}

    def loan_customer_details_fixture(attrs \\ %{}) do
      {:ok, loan_customer_details} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_customer_details()

      loan_customer_details
    end

    test "list_tbl_loan_customer_details/0 returns all tbl_loan_customer_details" do
      loan_customer_details = loan_customer_details_fixture()
      assert Loan.list_tbl_loan_customer_details() == [loan_customer_details]
    end

    test "get_loan_customer_details!/1 returns the loan_customer_details with given id" do
      loan_customer_details = loan_customer_details_fixture()
      assert Loan.get_loan_customer_details!(loan_customer_details.id) == loan_customer_details
    end

    test "create_loan_customer_details/1 with valid data creates a loan_customer_details" do
      assert {:ok, %Loan_customer_details{} = loan_customer_details} = Loan.create_loan_customer_details(@valid_attrs)
      assert loan_customer_details.cell_number == "some cell_number"
      assert loan_customer_details.customer_id == 42
      assert loan_customer_details.dob == "some dob"
      assert loan_customer_details.email == "some email"
      assert loan_customer_details.firstname == "some firstname"
      assert loan_customer_details.gender == "some gender"
      assert loan_customer_details.id_number == "some id_number"
      assert loan_customer_details.id_type == "some id_type"
      assert loan_customer_details.landmark == "some landmark"
      assert loan_customer_details.marital_status == "some marital_status"
      assert loan_customer_details.othername == "some othername"
      assert loan_customer_details.province == "some province"
      assert loan_customer_details.residential_address == "some residential_address"
      assert loan_customer_details.surname == "some surname"
      assert loan_customer_details.town == "some town"
    end

    test "create_loan_customer_details/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_customer_details(@invalid_attrs)
    end

    test "update_loan_customer_details/2 with valid data updates the loan_customer_details" do
      loan_customer_details = loan_customer_details_fixture()
      assert {:ok, %Loan_customer_details{} = loan_customer_details} = Loan.update_loan_customer_details(loan_customer_details, @update_attrs)
      assert loan_customer_details.cell_number == "some updated cell_number"
      assert loan_customer_details.customer_id == 43
      assert loan_customer_details.dob == "some updated dob"
      assert loan_customer_details.email == "some updated email"
      assert loan_customer_details.firstname == "some updated firstname"
      assert loan_customer_details.gender == "some updated gender"
      assert loan_customer_details.id_number == "some updated id_number"
      assert loan_customer_details.id_type == "some updated id_type"
      assert loan_customer_details.landmark == "some updated landmark"
      assert loan_customer_details.marital_status == "some updated marital_status"
      assert loan_customer_details.othername == "some updated othername"
      assert loan_customer_details.province == "some updated province"
      assert loan_customer_details.residential_address == "some updated residential_address"
      assert loan_customer_details.surname == "some updated surname"
      assert loan_customer_details.town == "some updated town"
    end

    test "update_loan_customer_details/2 with invalid data returns error changeset" do
      loan_customer_details = loan_customer_details_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_customer_details(loan_customer_details, @invalid_attrs)
      assert loan_customer_details == Loan.get_loan_customer_details!(loan_customer_details.id)
    end

    test "delete_loan_customer_details/1 deletes the loan_customer_details" do
      loan_customer_details = loan_customer_details_fixture()
      assert {:ok, %Loan_customer_details{}} = Loan.delete_loan_customer_details(loan_customer_details)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_customer_details!(loan_customer_details.id) end
    end

    test "change_loan_customer_details/1 returns a loan_customer_details changeset" do
      loan_customer_details = loan_customer_details_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_customer_details(loan_customer_details)
    end
  end

  describe "tbl_loan_recommendation" do
    alias Loanmanagementsystem.Loan.Loan_recommendation_and_assessment

    @valid_attrs %{comments: "some comments", customer_id: 42, date: "some date", date_received: "some date_received", file_sent_to_sale: "some file_sent_to_sale", name: "some name", on_hold: "some on_hold", position: "some position", recommended: "some recommended", reference_no: "some reference_no", signature: "some signature", time_out: "some time_out", time_received: "some time_received"}
    @update_attrs %{comments: "some updated comments", customer_id: 43, date: "some updated date", date_received: "some updated date_received", file_sent_to_sale: "some updated file_sent_to_sale", name: "some updated name", on_hold: "some updated on_hold", position: "some updated position", recommended: "some updated recommended", reference_no: "some updated reference_no", signature: "some updated signature", time_out: "some updated time_out", time_received: "some updated time_received"}
    @invalid_attrs %{comments: nil, customer_id: nil, date: nil, date_received: nil, file_sent_to_sale: nil, name: nil, on_hold: nil, position: nil, recommended: nil, reference_no: nil, signature: nil, time_out: nil, time_received: nil}

    def loan_recommendation_and_assessment_fixture(attrs \\ %{}) do
      {:ok, loan_recommendation_and_assessment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_recommendation_and_assessment()

      loan_recommendation_and_assessment
    end

    test "list_tbl_loan_recommendation/0 returns all tbl_loan_recommendation" do
      loan_recommendation_and_assessment = loan_recommendation_and_assessment_fixture()
      assert Loan.list_tbl_loan_recommendation() == [loan_recommendation_and_assessment]
    end

    test "get_loan_recommendation_and_assessment!/1 returns the loan_recommendation_and_assessment with given id" do
      loan_recommendation_and_assessment = loan_recommendation_and_assessment_fixture()
      assert Loan.get_loan_recommendation_and_assessment!(loan_recommendation_and_assessment.id) == loan_recommendation_and_assessment
    end

    test "create_loan_recommendation_and_assessment/1 with valid data creates a loan_recommendation_and_assessment" do
      assert {:ok, %Loan_recommendation_and_assessment{} = loan_recommendation_and_assessment} = Loan.create_loan_recommendation_and_assessment(@valid_attrs)
      assert loan_recommendation_and_assessment.comments == "some comments"
      assert loan_recommendation_and_assessment.customer_id == 42
      assert loan_recommendation_and_assessment.date == "some date"
      assert loan_recommendation_and_assessment.date_received == "some date_received"
      assert loan_recommendation_and_assessment.file_sent_to_sale == "some file_sent_to_sale"
      assert loan_recommendation_and_assessment.name == "some name"
      assert loan_recommendation_and_assessment.on_hold == "some on_hold"
      assert loan_recommendation_and_assessment.position == "some position"
      assert loan_recommendation_and_assessment.recommended == "some recommended"
      assert loan_recommendation_and_assessment.reference_no == "some reference_no"
      assert loan_recommendation_and_assessment.signature == "some signature"
      assert loan_recommendation_and_assessment.time_out == "some time_out"
      assert loan_recommendation_and_assessment.time_received == "some time_received"
    end

    test "create_loan_recommendation_and_assessment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_recommendation_and_assessment(@invalid_attrs)
    end

    test "update_loan_recommendation_and_assessment/2 with valid data updates the loan_recommendation_and_assessment" do
      loan_recommendation_and_assessment = loan_recommendation_and_assessment_fixture()
      assert {:ok, %Loan_recommendation_and_assessment{} = loan_recommendation_and_assessment} = Loan.update_loan_recommendation_and_assessment(loan_recommendation_and_assessment, @update_attrs)
      assert loan_recommendation_and_assessment.comments == "some updated comments"
      assert loan_recommendation_and_assessment.customer_id == 43
      assert loan_recommendation_and_assessment.date == "some updated date"
      assert loan_recommendation_and_assessment.date_received == "some updated date_received"
      assert loan_recommendation_and_assessment.file_sent_to_sale == "some updated file_sent_to_sale"
      assert loan_recommendation_and_assessment.name == "some updated name"
      assert loan_recommendation_and_assessment.on_hold == "some updated on_hold"
      assert loan_recommendation_and_assessment.position == "some updated position"
      assert loan_recommendation_and_assessment.recommended == "some updated recommended"
      assert loan_recommendation_and_assessment.reference_no == "some updated reference_no"
      assert loan_recommendation_and_assessment.signature == "some updated signature"
      assert loan_recommendation_and_assessment.time_out == "some updated time_out"
      assert loan_recommendation_and_assessment.time_received == "some updated time_received"
    end

    test "update_loan_recommendation_and_assessment/2 with invalid data returns error changeset" do
      loan_recommendation_and_assessment = loan_recommendation_and_assessment_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_recommendation_and_assessment(loan_recommendation_and_assessment, @invalid_attrs)
      assert loan_recommendation_and_assessment == Loan.get_loan_recommendation_and_assessment!(loan_recommendation_and_assessment.id)
    end

    test "delete_loan_recommendation_and_assessment/1 deletes the loan_recommendation_and_assessment" do
      loan_recommendation_and_assessment = loan_recommendation_and_assessment_fixture()
      assert {:ok, %Loan_recommendation_and_assessment{}} = Loan.delete_loan_recommendation_and_assessment(loan_recommendation_and_assessment)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_recommendation_and_assessment!(loan_recommendation_and_assessment.id) end
    end

    test "change_loan_recommendation_and_assessment/1 returns a loan_recommendation_and_assessment changeset" do
      loan_recommendation_and_assessment = loan_recommendation_and_assessment_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_recommendation_and_assessment(loan_recommendation_and_assessment)
    end
  end

  describe "tbl_loan_market_info" do
    alias Loanmanagementsystem.Loan.Loan_market_info

    @valid_attrs %{customer_id: 42, duration_at_market: "some duration_at_market", location_of_market: "some location_of_market", mobile_of_market_leader: "some mobile_of_market_leader", name_of_market: "some name_of_market", name_of_market_leader: "some name_of_market_leader", name_of_market_vice: "some name_of_market_vice", reference_no: "some reference_no", type_of_business: "some type_of_business"}
    @update_attrs %{customer_id: 43, duration_at_market: "some updated duration_at_market", location_of_market: "some updated location_of_market", mobile_of_market_leader: "some updated mobile_of_market_leader", name_of_market: "some updated name_of_market", name_of_market_leader: "some updated name_of_market_leader", name_of_market_vice: "some updated name_of_market_vice", reference_no: "some updated reference_no", type_of_business: "some updated type_of_business"}
    @invalid_attrs %{customer_id: nil, duration_at_market: nil, location_of_market: nil, mobile_of_market_leader: nil, name_of_market: nil, name_of_market_leader: nil, name_of_market_vice: nil, reference_no: nil, type_of_business: nil}

    def loan_market_info_fixture(attrs \\ %{}) do
      {:ok, loan_market_info} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_market_info()

      loan_market_info
    end

    test "list_tbl_loan_market_info/0 returns all tbl_loan_market_info" do
      loan_market_info = loan_market_info_fixture()
      assert Loan.list_tbl_loan_market_info() == [loan_market_info]
    end

    test "get_loan_market_info!/1 returns the loan_market_info with given id" do
      loan_market_info = loan_market_info_fixture()
      assert Loan.get_loan_market_info!(loan_market_info.id) == loan_market_info
    end

    test "create_loan_market_info/1 with valid data creates a loan_market_info" do
      assert {:ok, %Loan_market_info{} = loan_market_info} = Loan.create_loan_market_info(@valid_attrs)
      assert loan_market_info.customer_id == 42
      assert loan_market_info.duration_at_market == "some duration_at_market"
      assert loan_market_info.location_of_market == "some location_of_market"
      assert loan_market_info.mobile_of_market_leader == "some mobile_of_market_leader"
      assert loan_market_info.name_of_market == "some name_of_market"
      assert loan_market_info.name_of_market_leader == "some name_of_market_leader"
      assert loan_market_info.name_of_market_vice == "some name_of_market_vice"
      assert loan_market_info.reference_no == "some reference_no"
      assert loan_market_info.type_of_business == "some type_of_business"
    end

    test "create_loan_market_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_market_info(@invalid_attrs)
    end

    test "update_loan_market_info/2 with valid data updates the loan_market_info" do
      loan_market_info = loan_market_info_fixture()
      assert {:ok, %Loan_market_info{} = loan_market_info} = Loan.update_loan_market_info(loan_market_info, @update_attrs)
      assert loan_market_info.customer_id == 43
      assert loan_market_info.duration_at_market == "some updated duration_at_market"
      assert loan_market_info.location_of_market == "some updated location_of_market"
      assert loan_market_info.mobile_of_market_leader == "some updated mobile_of_market_leader"
      assert loan_market_info.name_of_market == "some updated name_of_market"
      assert loan_market_info.name_of_market_leader == "some updated name_of_market_leader"
      assert loan_market_info.name_of_market_vice == "some updated name_of_market_vice"
      assert loan_market_info.reference_no == "some updated reference_no"
      assert loan_market_info.type_of_business == "some updated type_of_business"
    end

    test "update_loan_market_info/2 with invalid data returns error changeset" do
      loan_market_info = loan_market_info_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_market_info(loan_market_info, @invalid_attrs)
      assert loan_market_info == Loan.get_loan_market_info!(loan_market_info.id)
    end

    test "delete_loan_market_info/1 deletes the loan_market_info" do
      loan_market_info = loan_market_info_fixture()
      assert {:ok, %Loan_market_info{}} = Loan.delete_loan_market_info(loan_market_info)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_market_info!(loan_market_info.id) end
    end

    test "change_loan_market_info/1 returns a loan_market_info changeset" do
      loan_market_info = loan_market_info_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_market_info(loan_market_info)
    end
  end

  describe "tbl_loan_employment_info" do
    alias Loanmanagementsystem.Loan.Loan_employment_info

    @valid_attrs %{accrued_gratuity: "some accrued_gratuity", address: "some address", applicant_name: "some applicant_name", authorised_signature: "some authorised_signature", company_name: "some company_name", contact_no: "some contact_no", customer_id: 42, date: "some date", date_to: "some date_to", employer: "some employer", employer_email_address: "some employer_email_address", employer_phone: "some employer_phone", employment_date: "some employment_date", employment_status: "some employment_status", granted_loan_amt: "some granted_loan_amt", gross_salary: "some gross_salary", job_title: "some job_title", net_salary: "some net_salary", other_outstanding_loans: "some other_outstanding_loans", province: "some province", reference_no: "some reference_no", supervisor_name: "some supervisor_name", town: "some town"}
    @update_attrs %{accrued_gratuity: "some updated accrued_gratuity", address: "some updated address", applicant_name: "some updated applicant_name", authorised_signature: "some updated authorised_signature", company_name: "some updated company_name", contact_no: "some updated contact_no", customer_id: 43, date: "some updated date", date_to: "some updated date_to", employer: "some updated employer", employer_email_address: "some updated employer_email_address", employer_phone: "some updated employer_phone", employment_date: "some updated employment_date", employment_status: "some updated employment_status", granted_loan_amt: "some updated granted_loan_amt", gross_salary: "some updated gross_salary", job_title: "some updated job_title", net_salary: "some updated net_salary", other_outstanding_loans: "some updated other_outstanding_loans", province: "some updated province", reference_no: "some updated reference_no", supervisor_name: "some updated supervisor_name", town: "some updated town"}
    @invalid_attrs %{accrued_gratuity: nil, address: nil, applicant_name: nil, authorised_signature: nil, company_name: nil, contact_no: nil, customer_id: nil, date: nil, date_to: nil, employer: nil, employer_email_address: nil, employer_phone: nil, employment_date: nil, employment_status: nil, granted_loan_amt: nil, gross_salary: nil, job_title: nil, net_salary: nil, other_outstanding_loans: nil, province: nil, reference_no: nil, supervisor_name: nil, town: nil}

    def loan_employment_info_fixture(attrs \\ %{}) do
      {:ok, loan_employment_info} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_employment_info()

      loan_employment_info
    end

    test "list_tbl_loan_employment_info/0 returns all tbl_loan_employment_info" do
      loan_employment_info = loan_employment_info_fixture()
      assert Loan.list_tbl_loan_employment_info() == [loan_employment_info]
    end

    test "get_loan_employment_info!/1 returns the loan_employment_info with given id" do
      loan_employment_info = loan_employment_info_fixture()
      assert Loan.get_loan_employment_info!(loan_employment_info.id) == loan_employment_info
    end

    test "create_loan_employment_info/1 with valid data creates a loan_employment_info" do
      assert {:ok, %Loan_employment_info{} = loan_employment_info} = Loan.create_loan_employment_info(@valid_attrs)
      assert loan_employment_info.accrued_gratuity == "some accrued_gratuity"
      assert loan_employment_info.address == "some address"
      assert loan_employment_info.applicant_name == "some applicant_name"
      assert loan_employment_info.authorised_signature == "some authorised_signature"
      assert loan_employment_info.company_name == "some company_name"
      assert loan_employment_info.contact_no == "some contact_no"
      assert loan_employment_info.customer_id == 42
      assert loan_employment_info.date == "some date"
      assert loan_employment_info.date_to == "some date_to"
      assert loan_employment_info.employer == "some employer"
      assert loan_employment_info.employer_email_address == "some employer_email_address"
      assert loan_employment_info.employer_phone == "some employer_phone"
      assert loan_employment_info.employment_date == "some employment_date"
      assert loan_employment_info.employment_status == "some employment_status"
      assert loan_employment_info.granted_loan_amt == "some granted_loan_amt"
      assert loan_employment_info.gross_salary == "some gross_salary"
      assert loan_employment_info.job_title == "some job_title"
      assert loan_employment_info.net_salary == "some net_salary"
      assert loan_employment_info.other_outstanding_loans == "some other_outstanding_loans"
      assert loan_employment_info.province == "some province"
      assert loan_employment_info.reference_no == "some reference_no"
      assert loan_employment_info.supervisor_name == "some supervisor_name"
      assert loan_employment_info.town == "some town"
    end

    test "create_loan_employment_info/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_employment_info(@invalid_attrs)
    end

    test "update_loan_employment_info/2 with valid data updates the loan_employment_info" do
      loan_employment_info = loan_employment_info_fixture()
      assert {:ok, %Loan_employment_info{} = loan_employment_info} = Loan.update_loan_employment_info(loan_employment_info, @update_attrs)
      assert loan_employment_info.accrued_gratuity == "some updated accrued_gratuity"
      assert loan_employment_info.address == "some updated address"
      assert loan_employment_info.applicant_name == "some updated applicant_name"
      assert loan_employment_info.authorised_signature == "some updated authorised_signature"
      assert loan_employment_info.company_name == "some updated company_name"
      assert loan_employment_info.contact_no == "some updated contact_no"
      assert loan_employment_info.customer_id == 43
      assert loan_employment_info.date == "some updated date"
      assert loan_employment_info.date_to == "some updated date_to"
      assert loan_employment_info.employer == "some updated employer"
      assert loan_employment_info.employer_email_address == "some updated employer_email_address"
      assert loan_employment_info.employer_phone == "some updated employer_phone"
      assert loan_employment_info.employment_date == "some updated employment_date"
      assert loan_employment_info.employment_status == "some updated employment_status"
      assert loan_employment_info.granted_loan_amt == "some updated granted_loan_amt"
      assert loan_employment_info.gross_salary == "some updated gross_salary"
      assert loan_employment_info.job_title == "some updated job_title"
      assert loan_employment_info.net_salary == "some updated net_salary"
      assert loan_employment_info.other_outstanding_loans == "some updated other_outstanding_loans"
      assert loan_employment_info.province == "some updated province"
      assert loan_employment_info.reference_no == "some updated reference_no"
      assert loan_employment_info.supervisor_name == "some updated supervisor_name"
      assert loan_employment_info.town == "some updated town"
    end

    test "update_loan_employment_info/2 with invalid data returns error changeset" do
      loan_employment_info = loan_employment_info_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_employment_info(loan_employment_info, @invalid_attrs)
      assert loan_employment_info == Loan.get_loan_employment_info!(loan_employment_info.id)
    end

    test "delete_loan_employment_info/1 deletes the loan_employment_info" do
      loan_employment_info = loan_employment_info_fixture()
      assert {:ok, %Loan_employment_info{}} = Loan.delete_loan_employment_info(loan_employment_info)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_employment_info!(loan_employment_info.id) end
    end

    test "change_loan_employment_info/1 returns a loan_employment_info changeset" do
      loan_employment_info = loan_employment_info_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_employment_info(loan_employment_info)
    end
  end

  describe "tbl_loan_disbursement_schedule" do
    alias Loanmanagementsystem.Loan.Loan_disbursement_schedule

    @valid_attrs %{account_number: "some account_number", applicant_name: "some applicant_name", applicant_signature: "some applicant_signature", applied_amount: 120.5, approved_amount: 120.5, bank_name: "some bank_name", branch: "some branch", crb: 120.5, credit_manager: "some credit_manager", customer_id: 42, date: ~D[2010-04-17], finance_manager: "some finance_manager", insurance: 120.5, interet_per_month: 120.5, loan_id: 42, month_installment: 120.5, motor_insurance: 120.5, net_disbiursed: 120.5, prepared_by: "some prepared_by", processing_fee: 120.5, reference_no: "some reference_no", repayment_period: "some repayment_period", senior_operation_officer: "some senior_operation_officer"}
    @update_attrs %{account_number: "some updated account_number", applicant_name: "some updated applicant_name", applicant_signature: "some updated applicant_signature", applied_amount: 456.7, approved_amount: 456.7, bank_name: "some updated bank_name", branch: "some updated branch", crb: 456.7, credit_manager: "some updated credit_manager", customer_id: 43, date: ~D[2011-05-18], finance_manager: "some updated finance_manager", insurance: 456.7, interet_per_month: 456.7, loan_id: 43, month_installment: 456.7, motor_insurance: 456.7, net_disbiursed: 456.7, prepared_by: "some updated prepared_by", processing_fee: 456.7, reference_no: "some updated reference_no", repayment_period: "some updated repayment_period", senior_operation_officer: "some updated senior_operation_officer"}
    @invalid_attrs %{account_number: nil, applicant_name: nil, applicant_signature: nil, applied_amount: nil, approved_amount: nil, bank_name: nil, branch: nil, crb: nil, credit_manager: nil, customer_id: nil, date: nil, finance_manager: nil, insurance: nil, interet_per_month: nil, loan_id: nil, month_installment: nil, motor_insurance: nil, net_disbiursed: nil, prepared_by: nil, processing_fee: nil, reference_no: nil, repayment_period: nil, senior_operation_officer: nil}

    def loan_disbursement_schedule_fixture(attrs \\ %{}) do
      {:ok, loan_disbursement_schedule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_disbursement_schedule()

      loan_disbursement_schedule
    end

    test "list_tbl_loan_disbursement_schedule/0 returns all tbl_loan_disbursement_schedule" do
      loan_disbursement_schedule = loan_disbursement_schedule_fixture()
      assert Loan.list_tbl_loan_disbursement_schedule() == [loan_disbursement_schedule]
    end

    test "get_loan_disbursement_schedule!/1 returns the loan_disbursement_schedule with given id" do
      loan_disbursement_schedule = loan_disbursement_schedule_fixture()
      assert Loan.get_loan_disbursement_schedule!(loan_disbursement_schedule.id) == loan_disbursement_schedule
    end

    test "create_loan_disbursement_schedule/1 with valid data creates a loan_disbursement_schedule" do
      assert {:ok, %Loan_disbursement_schedule{} = loan_disbursement_schedule} = Loan.create_loan_disbursement_schedule(@valid_attrs)
      assert loan_disbursement_schedule.account_number == "some account_number"
      assert loan_disbursement_schedule.applicant_name == "some applicant_name"
      assert loan_disbursement_schedule.applicant_signature == "some applicant_signature"
      assert loan_disbursement_schedule.applied_amount == 120.5
      assert loan_disbursement_schedule.approved_amount == 120.5
      assert loan_disbursement_schedule.bank_name == "some bank_name"
      assert loan_disbursement_schedule.branch == "some branch"
      assert loan_disbursement_schedule.crb == 120.5
      assert loan_disbursement_schedule.credit_manager == "some credit_manager"
      assert loan_disbursement_schedule.customer_id == 42
      assert loan_disbursement_schedule.date == ~D[2010-04-17]
      assert loan_disbursement_schedule.finance_manager == "some finance_manager"
      assert loan_disbursement_schedule.insurance == 120.5
      assert loan_disbursement_schedule.interet_per_month == 120.5
      assert loan_disbursement_schedule.loan_id == 42
      assert loan_disbursement_schedule.month_installment == 120.5
      assert loan_disbursement_schedule.motor_insurance == 120.5
      assert loan_disbursement_schedule.net_disbiursed == 120.5
      assert loan_disbursement_schedule.prepared_by == "some prepared_by"
      assert loan_disbursement_schedule.processing_fee == 120.5
      assert loan_disbursement_schedule.reference_no == "some reference_no"
      assert loan_disbursement_schedule.repayment_period == "some repayment_period"
      assert loan_disbursement_schedule.senior_operation_officer == "some senior_operation_officer"
    end

    test "create_loan_disbursement_schedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_disbursement_schedule(@invalid_attrs)
    end

    test "update_loan_disbursement_schedule/2 with valid data updates the loan_disbursement_schedule" do
      loan_disbursement_schedule = loan_disbursement_schedule_fixture()
      assert {:ok, %Loan_disbursement_schedule{} = loan_disbursement_schedule} = Loan.update_loan_disbursement_schedule(loan_disbursement_schedule, @update_attrs)
      assert loan_disbursement_schedule.account_number == "some updated account_number"
      assert loan_disbursement_schedule.applicant_name == "some updated applicant_name"
      assert loan_disbursement_schedule.applicant_signature == "some updated applicant_signature"
      assert loan_disbursement_schedule.applied_amount == 456.7
      assert loan_disbursement_schedule.approved_amount == 456.7
      assert loan_disbursement_schedule.bank_name == "some updated bank_name"
      assert loan_disbursement_schedule.branch == "some updated branch"
      assert loan_disbursement_schedule.crb == 456.7
      assert loan_disbursement_schedule.credit_manager == "some updated credit_manager"
      assert loan_disbursement_schedule.customer_id == 43
      assert loan_disbursement_schedule.date == ~D[2011-05-18]
      assert loan_disbursement_schedule.finance_manager == "some updated finance_manager"
      assert loan_disbursement_schedule.insurance == 456.7
      assert loan_disbursement_schedule.interet_per_month == 456.7
      assert loan_disbursement_schedule.loan_id == 43
      assert loan_disbursement_schedule.month_installment == 456.7
      assert loan_disbursement_schedule.motor_insurance == 456.7
      assert loan_disbursement_schedule.net_disbiursed == 456.7
      assert loan_disbursement_schedule.prepared_by == "some updated prepared_by"
      assert loan_disbursement_schedule.processing_fee == 456.7
      assert loan_disbursement_schedule.reference_no == "some updated reference_no"
      assert loan_disbursement_schedule.repayment_period == "some updated repayment_period"
      assert loan_disbursement_schedule.senior_operation_officer == "some updated senior_operation_officer"
    end

    test "update_loan_disbursement_schedule/2 with invalid data returns error changeset" do
      loan_disbursement_schedule = loan_disbursement_schedule_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_disbursement_schedule(loan_disbursement_schedule, @invalid_attrs)
      assert loan_disbursement_schedule == Loan.get_loan_disbursement_schedule!(loan_disbursement_schedule.id)
    end

    test "delete_loan_disbursement_schedule/1 deletes the loan_disbursement_schedule" do
      loan_disbursement_schedule = loan_disbursement_schedule_fixture()
      assert {:ok, %Loan_disbursement_schedule{}} = Loan.delete_loan_disbursement_schedule(loan_disbursement_schedule)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_disbursement_schedule!(loan_disbursement_schedule.id) end
    end

    test "change_loan_disbursement_schedule/1 returns a loan_disbursement_schedule changeset" do
      loan_disbursement_schedule = loan_disbursement_schedule_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_disbursement_schedule(loan_disbursement_schedule)
    end
  end

  describe "tbl_loan_amortization_schedule" do
    alias Loanmanagementsystem.Loan.Loan_amortization_schedule

    @valid_attrs %{beginning_balance: 120.5, customer_id: "some customer_id", ending_balance: 120.5, interest: 120.5, interest_rate: 120.5, loan_amount: 120.5, loan_id: "some loan_id", month: 42, payment: 120.5, principal: 120.5, reference_no: "some reference_no", term_in_months: 120.5}
    @update_attrs %{beginning_balance: 456.7, customer_id: "some updated customer_id", ending_balance: 456.7, interest: 456.7, interest_rate: 456.7, loan_amount: 456.7, loan_id: "some updated loan_id", month: 43, payment: 456.7, principal: 456.7, reference_no: "some updated reference_no", term_in_months: 456.7}
    @invalid_attrs %{beginning_balance: nil, customer_id: nil, ending_balance: nil, interest: nil, interest_rate: nil, loan_amount: nil, loan_id: nil, month: nil, payment: nil, principal: nil, reference_no: nil, term_in_months: nil}

    def loan_amortization_schedule_fixture(attrs \\ %{}) do
      {:ok, loan_amortization_schedule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_amortization_schedule()

      loan_amortization_schedule
    end

    test "list_tbl_loan_amortization_schedule/0 returns all tbl_loan_amortization_schedule" do
      loan_amortization_schedule = loan_amortization_schedule_fixture()
      assert Loan.list_tbl_loan_amortization_schedule() == [loan_amortization_schedule]
    end

    test "get_loan_amortization_schedule!/1 returns the loan_amortization_schedule with given id" do
      loan_amortization_schedule = loan_amortization_schedule_fixture()
      assert Loan.get_loan_amortization_schedule!(loan_amortization_schedule.id) == loan_amortization_schedule
    end

    test "create_loan_amortization_schedule/1 with valid data creates a loan_amortization_schedule" do
      assert {:ok, %Loan_amortization_schedule{} = loan_amortization_schedule} = Loan.create_loan_amortization_schedule(@valid_attrs)
      assert loan_amortization_schedule.beginning_balance == 120.5
      assert loan_amortization_schedule.customer_id == "some customer_id"
      assert loan_amortization_schedule.ending_balance == 120.5
      assert loan_amortization_schedule.interest == 120.5
      assert loan_amortization_schedule.interest_rate == 120.5
      assert loan_amortization_schedule.loan_amount == 120.5
      assert loan_amortization_schedule.loan_id == "some loan_id"
      assert loan_amortization_schedule.month == 42
      assert loan_amortization_schedule.payment == 120.5
      assert loan_amortization_schedule.principal == 120.5
      assert loan_amortization_schedule.reference_no == "some reference_no"
      assert loan_amortization_schedule.term_in_months == 120.5
    end

    test "create_loan_amortization_schedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_amortization_schedule(@invalid_attrs)
    end

    test "update_loan_amortization_schedule/2 with valid data updates the loan_amortization_schedule" do
      loan_amortization_schedule = loan_amortization_schedule_fixture()
      assert {:ok, %Loan_amortization_schedule{} = loan_amortization_schedule} = Loan.update_loan_amortization_schedule(loan_amortization_schedule, @update_attrs)
      assert loan_amortization_schedule.beginning_balance == 456.7
      assert loan_amortization_schedule.customer_id == "some updated customer_id"
      assert loan_amortization_schedule.ending_balance == 456.7
      assert loan_amortization_schedule.interest == 456.7
      assert loan_amortization_schedule.interest_rate == 456.7
      assert loan_amortization_schedule.loan_amount == 456.7
      assert loan_amortization_schedule.loan_id == "some updated loan_id"
      assert loan_amortization_schedule.month == 43
      assert loan_amortization_schedule.payment == 456.7
      assert loan_amortization_schedule.principal == 456.7
      assert loan_amortization_schedule.reference_no == "some updated reference_no"
      assert loan_amortization_schedule.term_in_months == 456.7
    end

    test "update_loan_amortization_schedule/2 with invalid data returns error changeset" do
      loan_amortization_schedule = loan_amortization_schedule_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_amortization_schedule(loan_amortization_schedule, @invalid_attrs)
      assert loan_amortization_schedule == Loan.get_loan_amortization_schedule!(loan_amortization_schedule.id)
    end

    test "delete_loan_amortization_schedule/1 deletes the loan_amortization_schedule" do
      loan_amortization_schedule = loan_amortization_schedule_fixture()
      assert {:ok, %Loan_amortization_schedule{}} = Loan.delete_loan_amortization_schedule(loan_amortization_schedule)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_amortization_schedule!(loan_amortization_schedule.id) end
    end

    test "change_loan_amortization_schedule/1 returns a loan_amortization_schedule changeset" do
      loan_amortization_schedule = loan_amortization_schedule_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_amortization_schedule(loan_amortization_schedule)
    end
  end

  describe "tbl_loan_credit_score" do
    alias Loanmanagementsystem.Loan.Loan_credit_score

    @valid_attrs %{applicant_character: "some applicant_character", applicant_name: "some applicant_name", borrowing_history: "some borrowing_history", business_employment_experience: "some business_employment_experience", collateral_assessment: "some collateral_assessment", credit_analyst: "some credit_analyst", cro_staff: "some cro_staff", customer_id: 42, date_of_credit_score: ~D[2010-04-17], dti_ratio: "some dti_ratio", family_situation: "some family_situation", loan_amount: 120.5, number_of_reference: "some number_of_reference", reference_no: "some reference_no", signature: "some signature", total_score: 120.5, type_of_collateral: "some type_of_collateral", type_of_loan: "some type_of_loan", weighted_credit_score: 120.5}
    @update_attrs %{applicant_character: "some updated applicant_character", applicant_name: "some updated applicant_name", borrowing_history: "some updated borrowing_history", business_employment_experience: "some updated business_employment_experience", collateral_assessment: "some updated collateral_assessment", credit_analyst: "some updated credit_analyst", cro_staff: "some updated cro_staff", customer_id: 43, date_of_credit_score: ~D[2011-05-18], dti_ratio: "some updated dti_ratio", family_situation: "some updated family_situation", loan_amount: 456.7, number_of_reference: "some updated number_of_reference", reference_no: "some updated reference_no", signature: "some updated signature", total_score: 456.7, type_of_collateral: "some updated type_of_collateral", type_of_loan: "some updated type_of_loan", weighted_credit_score: 456.7}
    @invalid_attrs %{applicant_character: nil, applicant_name: nil, borrowing_history: nil, business_employment_experience: nil, collateral_assessment: nil, credit_analyst: nil, cro_staff: nil, customer_id: nil, date_of_credit_score: nil, dti_ratio: nil, family_situation: nil, loan_amount: nil, number_of_reference: nil, reference_no: nil, signature: nil, total_score: nil, type_of_collateral: nil, type_of_loan: nil, weighted_credit_score: nil}

    def loan_credit_score_fixture(attrs \\ %{}) do
      {:ok, loan_credit_score} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_credit_score()

      loan_credit_score
    end

    test "list_tbl_loan_credit_score/0 returns all tbl_loan_credit_score" do
      loan_credit_score = loan_credit_score_fixture()
      assert Loan.list_tbl_loan_credit_score() == [loan_credit_score]
    end

    test "get_loan_credit_score!/1 returns the loan_credit_score with given id" do
      loan_credit_score = loan_credit_score_fixture()
      assert Loan.get_loan_credit_score!(loan_credit_score.id) == loan_credit_score
    end

    test "create_loan_credit_score/1 with valid data creates a loan_credit_score" do
      assert {:ok, %Loan_credit_score{} = loan_credit_score} = Loan.create_loan_credit_score(@valid_attrs)
      assert loan_credit_score.applicant_character == "some applicant_character"
      assert loan_credit_score.applicant_name == "some applicant_name"
      assert loan_credit_score.borrowing_history == "some borrowing_history"
      assert loan_credit_score.business_employment_experience == "some business_employment_experience"
      assert loan_credit_score.collateral_assessment == "some collateral_assessment"
      assert loan_credit_score.credit_analyst == "some credit_analyst"
      assert loan_credit_score.cro_staff == "some cro_staff"
      assert loan_credit_score.customer_id == 42
      assert loan_credit_score.date_of_credit_score == ~D[2010-04-17]
      assert loan_credit_score.dti_ratio == "some dti_ratio"
      assert loan_credit_score.family_situation == "some family_situation"
      assert loan_credit_score.loan_amount == 120.5
      assert loan_credit_score.number_of_reference == "some number_of_reference"
      assert loan_credit_score.reference_no == "some reference_no"
      assert loan_credit_score.signature == "some signature"
      assert loan_credit_score.total_score == 120.5
      assert loan_credit_score.type_of_collateral == "some type_of_collateral"
      assert loan_credit_score.type_of_loan == "some type_of_loan"
      assert loan_credit_score.weighted_credit_score == 120.5
    end

    test "create_loan_credit_score/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_credit_score(@invalid_attrs)
    end

    test "update_loan_credit_score/2 with valid data updates the loan_credit_score" do
      loan_credit_score = loan_credit_score_fixture()
      assert {:ok, %Loan_credit_score{} = loan_credit_score} = Loan.update_loan_credit_score(loan_credit_score, @update_attrs)
      assert loan_credit_score.applicant_character == "some updated applicant_character"
      assert loan_credit_score.applicant_name == "some updated applicant_name"
      assert loan_credit_score.borrowing_history == "some updated borrowing_history"
      assert loan_credit_score.business_employment_experience == "some updated business_employment_experience"
      assert loan_credit_score.collateral_assessment == "some updated collateral_assessment"
      assert loan_credit_score.credit_analyst == "some updated credit_analyst"
      assert loan_credit_score.cro_staff == "some updated cro_staff"
      assert loan_credit_score.customer_id == 43
      assert loan_credit_score.date_of_credit_score == ~D[2011-05-18]
      assert loan_credit_score.dti_ratio == "some updated dti_ratio"
      assert loan_credit_score.family_situation == "some updated family_situation"
      assert loan_credit_score.loan_amount == 456.7
      assert loan_credit_score.number_of_reference == "some updated number_of_reference"
      assert loan_credit_score.reference_no == "some updated reference_no"
      assert loan_credit_score.signature == "some updated signature"
      assert loan_credit_score.total_score == 456.7
      assert loan_credit_score.type_of_collateral == "some updated type_of_collateral"
      assert loan_credit_score.type_of_loan == "some updated type_of_loan"
      assert loan_credit_score.weighted_credit_score == 456.7
    end

    test "update_loan_credit_score/2 with invalid data returns error changeset" do
      loan_credit_score = loan_credit_score_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_credit_score(loan_credit_score, @invalid_attrs)
      assert loan_credit_score == Loan.get_loan_credit_score!(loan_credit_score.id)
    end

    test "delete_loan_credit_score/1 deletes the loan_credit_score" do
      loan_credit_score = loan_credit_score_fixture()
      assert {:ok, %Loan_credit_score{}} = Loan.delete_loan_credit_score(loan_credit_score)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_credit_score!(loan_credit_score.id) end
    end

    test "change_loan_credit_score/1 returns a loan_credit_score changeset" do
      loan_credit_score = loan_credit_score_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_credit_score(loan_credit_score)
    end
  end

  describe "tbl_loan_checklist" do
    alias Loanmanagementsystem.Loan.Loan_checklist

    @valid_attrs %{bank_statement: "some bank_statement", insurance_for_motor_vehicle: "some insurance_for_motor_vehicle", social_security_no: "some social_security_no", email_address: "some email_address", bank_standing_payment_order: "some bank_standing_payment_order", loan_verified: "some loan_verified", crb: "some crb", employer_letter: "some employer_letter", board_allow_company_to_borrow: "some board_allow_company_to_borrow", sales_record: "some sales_record", rent_payment: "some rent_payment", passport_size_photo_from_director: "some passport_size_photo_from_director", passport_size_photo: "some passport_size_photo", certificate_of_incorporation: "some certificate_of_incorporation", preferred_loan_repayment_method: "some preferred_loan_repayment_method", completed_application_form: "some completed_application_form", loan_purpose_checklist: "some loan_purpose_checklist", has_running_loan: "some has_running_loan", employment_status: "some employment_status", citizenship_status: "some citizenship_status", loan_id: 42, marital_status: "some marital_status", call_memo: "some call_memo", latest_audited_financial_statement: "some latest_audited_financial_statement", payslip_3months_verified: "some payslip_3months_verified", correct_account_number: "some correct_account_number", customer_id: 42, reference_no: "some reference_no", contract_agreements: "some contract_agreements", telephone: "some telephone", loan_amount_checklist: "some loan_amount_checklist", employer_name: "some employer_name", collateral_pictures: "some collateral_pictures", id_no: "some id_no", trading_license: "some trading_license", bank_name: "some bank_name", company_bank_statement: "some company_bank_statement", desired_term: "some desired_term", latest_pacra_print_out: "some latest_pacra_print_out", home_visit_done: "some home_visit_done", prood_of_resident: "some prood_of_resident", gross_monthly_income: "some gross_monthly_income"}
    @update_attrs %{bank_statement: "some updated bank_statement", insurance_for_motor_vehicle: "some updated insurance_for_motor_vehicle", social_security_no: "some updated social_security_no", email_address: "some updated email_address", bank_standing_payment_order: "some updated bank_standing_payment_order", loan_verified: "some updated loan_verified", crb: "some updated crb", employer_letter: "some updated employer_letter", board_allow_company_to_borrow: "some updated board_allow_company_to_borrow", sales_record: "some updated sales_record", rent_payment: "some updated rent_payment", passport_size_photo_from_director: "some updated passport_size_photo_from_director", passport_size_photo: "some updated passport_size_photo", certificate_of_incorporation: "some updated certificate_of_incorporation", preferred_loan_repayment_method: "some updated preferred_loan_repayment_method", completed_application_form: "some updated completed_application_form", loan_purpose_checklist: "some updated loan_purpose_checklist", has_running_loan: "some updated has_running_loan", employment_status: "some updated employment_status", citizenship_status: "some updated citizenship_status", loan_id: 43, marital_status: "some updated marital_status", call_memo: "some updated call_memo", latest_audited_financial_statement: "some updated latest_audited_financial_statement", payslip_3months_verified: "some updated payslip_3months_verified", correct_account_number: "some updated correct_account_number", customer_id: 43, reference_no: "some updated reference_no", contract_agreements: "some updated contract_agreements", telephone: "some updated telephone", loan_amount_checklist: "some updated loan_amount_checklist", employer_name: "some updated employer_name", collateral_pictures: "some updated collateral_pictures", id_no: "some updated id_no", trading_license: "some updated trading_license", bank_name: "some updated bank_name", company_bank_statement: "some updated company_bank_statement", desired_term: "some updated desired_term", latest_pacra_print_out: "some updated latest_pacra_print_out", home_visit_done: "some updated home_visit_done", prood_of_resident: "some updated prood_of_resident", gross_monthly_income: "some updated gross_monthly_income"}
    @invalid_attrs %{bank_statement: nil, insurance_for_motor_vehicle: nil, social_security_no: nil, email_address: nil, bank_standing_payment_order: nil, loan_verified: nil, crb: nil, employer_letter: nil, board_allow_company_to_borrow: nil, sales_record: nil, rent_payment: nil, passport_size_photo_from_director: nil, passport_size_photo: nil, certificate_of_incorporation: nil, preferred_loan_repayment_method: nil, completed_application_form: nil, loan_purpose_checklist: nil, has_running_loan: nil, employment_status: nil, citizenship_status: nil, loan_id: nil, marital_status: nil, call_memo: nil, latest_audited_financial_statement: nil, payslip_3months_verified: nil, correct_account_number: nil, customer_id: nil, reference_no: nil, contract_agreements: nil, telephone: nil, loan_amount_checklist: nil, employer_name: nil, collateral_pictures: nil, id_no: nil, trading_license: nil, bank_name: nil, company_bank_statement: nil, desired_term: nil, latest_pacra_print_out: nil, home_visit_done: nil, prood_of_resident: nil, gross_monthly_income: nil}

    def loan_checklist_fixture(attrs \\ %{}) do
      {:ok, loan_checklist} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_checklist()

      loan_checklist
    end

    test "list_tbl_loan_checklist/0 returns all tbl_loan_checklist" do
      loan_checklist = loan_checklist_fixture()
      assert Loan.list_tbl_loan_checklist() == [loan_checklist]
    end

    test "get_loan_checklist!/1 returns the loan_checklist with given id" do
      loan_checklist = loan_checklist_fixture()
      assert Loan.get_loan_checklist!(loan_checklist.id) == loan_checklist
    end

    test "create_loan_checklist/1 with valid data creates a loan_checklist" do
      assert {:ok, %Loan_checklist{} = loan_checklist} = Loan.create_loan_checklist(@valid_attrs)
      assert loan_checklist.gross_monthly_income == "some gross_monthly_income"
      assert loan_checklist.prood_of_resident == "some prood_of_resident"
      assert loan_checklist.home_visit_done == "some home_visit_done"
      assert loan_checklist.latest_pacra_print_out == "some latest_pacra_print_out"
      assert loan_checklist.desired_term == "some desired_term"
      assert loan_checklist.company_bank_statement == "some company_bank_statement"
      assert loan_checklist.bank_name == "some bank_name"
      assert loan_checklist.trading_license == "some trading_license"
      assert loan_checklist.id_no == "some id_no"
      assert loan_checklist.collateral_pictures == "some collateral_pictures"
      assert loan_checklist.employer_name == "some employer_name"
      assert loan_checklist.loan_amount_checklist == "some loan_amount_checklist"
      assert loan_checklist.telephone == "some telephone"
      assert loan_checklist.contract_agreements == "some contract_agreements"
      assert loan_checklist.reference_no == "some reference_no"
      assert loan_checklist.customer_id == 42
      assert loan_checklist.correct_account_number == "some correct_account_number"
      assert loan_checklist.payslip_3months_verified == "some payslip_3months_verified"
      assert loan_checklist.latest_audited_financial_statement == "some latest_audited_financial_statement"
      assert loan_checklist.call_memo == "some call_memo"
      assert loan_checklist.marital_status == "some marital_status"
      assert loan_checklist.loan_id == 42
      assert loan_checklist.citizenship_status == "some citizenship_status"
      assert loan_checklist.employment_status == "some employment_status"
      assert loan_checklist.has_running_loan == "some has_running_loan"
      assert loan_checklist.loan_purpose_checklist == "some loan_purpose_checklist"
      assert loan_checklist.completed_application_form == "some completed_application_form"
      assert loan_checklist.preferred_loan_repayment_method == "some preferred_loan_repayment_method"
      assert loan_checklist.certificate_of_incorporation == "some certificate_of_incorporation"
      assert loan_checklist.passport_size_photo == "some passport_size_photo"
      assert loan_checklist.passport_size_photo_from_director == "some passport_size_photo_from_director"
      assert loan_checklist.rent_payment == "some rent_payment"
      assert loan_checklist.sales_record == "some sales_record"
      assert loan_checklist.board_allow_company_to_borrow == "some board_allow_company_to_borrow"
      assert loan_checklist.employer_letter == "some employer_letter"
      assert loan_checklist.crb == "some crb"
      assert loan_checklist.loan_verified == "some loan_verified"
      assert loan_checklist.bank_standing_payment_order == "some bank_standing_payment_order"
      assert loan_checklist.email_address == "some email_address"
      assert loan_checklist.social_security_no == "some social_security_no"
      assert loan_checklist.insurance_for_motor_vehicle == "some insurance_for_motor_vehicle"
      assert loan_checklist.bank_statement == "some bank_statement"
    end

    test "create_loan_checklist/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_checklist(@invalid_attrs)
    end

    test "update_loan_checklist/2 with valid data updates the loan_checklist" do
      loan_checklist = loan_checklist_fixture()
      assert {:ok, %Loan_checklist{} = loan_checklist} = Loan.update_loan_checklist(loan_checklist, @update_attrs)
      assert loan_checklist.gross_monthly_income == "some updated gross_monthly_income"
      assert loan_checklist.prood_of_resident == "some updated prood_of_resident"
      assert loan_checklist.home_visit_done == "some updated home_visit_done"
      assert loan_checklist.latest_pacra_print_out == "some updated latest_pacra_print_out"
      assert loan_checklist.desired_term == "some updated desired_term"
      assert loan_checklist.company_bank_statement == "some updated company_bank_statement"
      assert loan_checklist.bank_name == "some updated bank_name"
      assert loan_checklist.trading_license == "some updated trading_license"
      assert loan_checklist.id_no == "some updated id_no"
      assert loan_checklist.collateral_pictures == "some updated collateral_pictures"
      assert loan_checklist.employer_name == "some updated employer_name"
      assert loan_checklist.loan_amount_checklist == "some updated loan_amount_checklist"
      assert loan_checklist.telephone == "some updated telephone"
      assert loan_checklist.contract_agreements == "some updated contract_agreements"
      assert loan_checklist.reference_no == "some updated reference_no"
      assert loan_checklist.customer_id == 43
      assert loan_checklist.correct_account_number == "some updated correct_account_number"
      assert loan_checklist.payslip_3months_verified == "some updated payslip_3months_verified"
      assert loan_checklist.latest_audited_financial_statement == "some updated latest_audited_financial_statement"
      assert loan_checklist.call_memo == "some updated call_memo"
      assert loan_checklist.marital_status == "some updated marital_status"
      assert loan_checklist.loan_id == 43
      assert loan_checklist.citizenship_status == "some updated citizenship_status"
      assert loan_checklist.employment_status == "some updated employment_status"
      assert loan_checklist.has_running_loan == "some updated has_running_loan"
      assert loan_checklist.loan_purpose_checklist == "some updated loan_purpose_checklist"
      assert loan_checklist.completed_application_form == "some updated completed_application_form"
      assert loan_checklist.preferred_loan_repayment_method == "some updated preferred_loan_repayment_method"
      assert loan_checklist.certificate_of_incorporation == "some updated certificate_of_incorporation"
      assert loan_checklist.passport_size_photo == "some updated passport_size_photo"
      assert loan_checklist.passport_size_photo_from_director == "some updated passport_size_photo_from_director"
      assert loan_checklist.rent_payment == "some updated rent_payment"
      assert loan_checklist.sales_record == "some updated sales_record"
      assert loan_checklist.board_allow_company_to_borrow == "some updated board_allow_company_to_borrow"
      assert loan_checklist.employer_letter == "some updated employer_letter"
      assert loan_checklist.crb == "some updated crb"
      assert loan_checklist.loan_verified == "some updated loan_verified"
      assert loan_checklist.bank_standing_payment_order == "some updated bank_standing_payment_order"
      assert loan_checklist.email_address == "some updated email_address"
      assert loan_checklist.social_security_no == "some updated social_security_no"
      assert loan_checklist.insurance_for_motor_vehicle == "some updated insurance_for_motor_vehicle"
      assert loan_checklist.bank_statement == "some updated bank_statement"
    end

    test "update_loan_checklist/2 with invalid data returns error changeset" do
      loan_checklist = loan_checklist_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_checklist(loan_checklist, @invalid_attrs)
      assert loan_checklist == Loan.get_loan_checklist!(loan_checklist.id)
    end

    test "delete_loan_checklist/1 deletes the loan_checklist" do
      loan_checklist = loan_checklist_fixture()
      assert {:ok, %Loan_checklist{}} = Loan.delete_loan_checklist(loan_checklist)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_checklist!(loan_checklist.id) end
    end

    test "change_loan_checklist/1 returns a loan_checklist changeset" do
      loan_checklist = loan_checklist_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_checklist(loan_checklist)
    end
  end

  describe "tbl_loan_5cs_analysis" do
    alias Loanmanagementsystem.Loan.Loan_5cs

    @valid_attrs %{capacity: "some capacity", capital: "some capital", character: "some character", collateral: "some collateral", condition: "some condition", customer_id: 42, loan_id: 42, reference_no: "some reference_no"}
    @update_attrs %{capacity: "some updated capacity", capital: "some updated capital", character: "some updated character", collateral: "some updated collateral", condition: "some updated condition", customer_id: 43, loan_id: 43, reference_no: "some updated reference_no"}
    @invalid_attrs %{capacity: nil, capital: nil, character: nil, collateral: nil, condition: nil, customer_id: nil, loan_id: nil, reference_no: nil}

    def loan_5cs_fixture(attrs \\ %{}) do
      {:ok, loan_5cs} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_5cs()

      loan_5cs
    end

    test "list_tbl_loan_5cs_analysis/0 returns all tbl_loan_5cs_analysis" do
      loan_5cs = loan_5cs_fixture()
      assert Loan.list_tbl_loan_5cs_analysis() == [loan_5cs]
    end

    test "get_loan_5cs!/1 returns the loan_5cs with given id" do
      loan_5cs = loan_5cs_fixture()
      assert Loan.get_loan_5cs!(loan_5cs.id) == loan_5cs
    end

    test "create_loan_5cs/1 with valid data creates a loan_5cs" do
      assert {:ok, %Loan_5cs{} = loan_5cs} = Loan.create_loan_5cs(@valid_attrs)
      assert loan_5cs.capacity == "some capacity"
      assert loan_5cs.capital == "some capital"
      assert loan_5cs.character == "some character"
      assert loan_5cs.collateral == "some collateral"
      assert loan_5cs.condition == "some condition"
      assert loan_5cs.customer_id == 42
      assert loan_5cs.loan_id == 42
      assert loan_5cs.reference_no == "some reference_no"
    end

    test "create_loan_5cs/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_5cs(@invalid_attrs)
    end

    test "update_loan_5cs/2 with valid data updates the loan_5cs" do
      loan_5cs = loan_5cs_fixture()
      assert {:ok, %Loan_5cs{} = loan_5cs} = Loan.update_loan_5cs(loan_5cs, @update_attrs)
      assert loan_5cs.capacity == "some updated capacity"
      assert loan_5cs.capital == "some updated capital"
      assert loan_5cs.character == "some updated character"
      assert loan_5cs.collateral == "some updated collateral"
      assert loan_5cs.condition == "some updated condition"
      assert loan_5cs.customer_id == 43
      assert loan_5cs.loan_id == 43
      assert loan_5cs.reference_no == "some updated reference_no"
    end

    test "update_loan_5cs/2 with invalid data returns error changeset" do
      loan_5cs = loan_5cs_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_5cs(loan_5cs, @invalid_attrs)
      assert loan_5cs == Loan.get_loan_5cs!(loan_5cs.id)
    end

    test "delete_loan_5cs/1 deletes the loan_5cs" do
      loan_5cs = loan_5cs_fixture()
      assert {:ok, %Loan_5cs{}} = Loan.delete_loan_5cs(loan_5cs)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_5cs!(loan_5cs.id) end
    end

    test "change_loan_5cs/1 returns a loan_5cs changeset" do
      loan_5cs = loan_5cs_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_5cs(loan_5cs)
    end
  end

  describe "tbl_loan_payment_requisition" do
    alias Loanmanagementsystem.Loan.Loan_disbursement

    @valid_attrs %{address_or_designation: "some address_or_designation", amount_paid: 120.5, amount_requested: 120.5, approved_by: "some approved_by", approved_by_position: "some approved_by_position", checked_by: "some checked_by", checked_by_position: "some checked_by_position", cheque_no: "some cheque_no", customer_id: 42, date_paid: ~D[2010-04-17], gl_account: "some gl_account", loan_id: 42, loan_purpose: "some loan_purpose", payable_to: "some payable_to", reference_no: "some reference_no", requested_by: "some requested_by", requested_by_position: "some requested_by_position"}
    @update_attrs %{address_or_designation: "some updated address_or_designation", amount_paid: 456.7, amount_requested: 456.7, approved_by: "some updated approved_by", approved_by_position: "some updated approved_by_position", checked_by: "some updated checked_by", checked_by_position: "some updated checked_by_position", cheque_no: "some updated cheque_no", customer_id: 43, date_paid: ~D[2011-05-18], gl_account: "some updated gl_account", loan_id: 43, loan_purpose: "some updated loan_purpose", payable_to: "some updated payable_to", reference_no: "some updated reference_no", requested_by: "some updated requested_by", requested_by_position: "some updated requested_by_position"}
    @invalid_attrs %{address_or_designation: nil, amount_paid: nil, amount_requested: nil, approved_by: nil, approved_by_position: nil, checked_by: nil, checked_by_position: nil, cheque_no: nil, customer_id: nil, date_paid: nil, gl_account: nil, loan_id: nil, loan_purpose: nil, payable_to: nil, reference_no: nil, requested_by: nil, requested_by_position: nil}

    def loan_disbursement_fixture(attrs \\ %{}) do
      {:ok, loan_disbursement} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_disbursement()

      loan_disbursement
    end

    test "list_tbl_loan_payment_requisition/0 returns all tbl_loan_payment_requisition" do
      loan_disbursement = loan_disbursement_fixture()
      assert Loan.list_tbl_loan_payment_requisition() == [loan_disbursement]
    end

    test "get_loan_disbursement!/1 returns the loan_disbursement with given id" do
      loan_disbursement = loan_disbursement_fixture()
      assert Loan.get_loan_disbursement!(loan_disbursement.id) == loan_disbursement
    end

    test "create_loan_disbursement/1 with valid data creates a loan_disbursement" do
      assert {:ok, %Loan_disbursement{} = loan_disbursement} = Loan.create_loan_disbursement(@valid_attrs)
      assert loan_disbursement.address_or_designation == "some address_or_designation"
      assert loan_disbursement.amount_paid == 120.5
      assert loan_disbursement.amount_requested == 120.5
      assert loan_disbursement.approved_by == "some approved_by"
      assert loan_disbursement.approved_by_position == "some approved_by_position"
      assert loan_disbursement.checked_by == "some checked_by"
      assert loan_disbursement.checked_by_position == "some checked_by_position"
      assert loan_disbursement.cheque_no == "some cheque_no"
      assert loan_disbursement.customer_id == 42
      assert loan_disbursement.date_paid == ~D[2010-04-17]
      assert loan_disbursement.gl_account == "some gl_account"
      assert loan_disbursement.loan_id == 42
      assert loan_disbursement.loan_purpose == "some loan_purpose"
      assert loan_disbursement.payable_to == "some payable_to"
      assert loan_disbursement.reference_no == "some reference_no"
      assert loan_disbursement.requested_by == "some requested_by"
      assert loan_disbursement.requested_by_position == "some requested_by_position"
    end

    test "create_loan_disbursement/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_disbursement(@invalid_attrs)
    end

    test "update_loan_disbursement/2 with valid data updates the loan_disbursement" do
      loan_disbursement = loan_disbursement_fixture()
      assert {:ok, %Loan_disbursement{} = loan_disbursement} = Loan.update_loan_disbursement(loan_disbursement, @update_attrs)
      assert loan_disbursement.address_or_designation == "some updated address_or_designation"
      assert loan_disbursement.amount_paid == 456.7
      assert loan_disbursement.amount_requested == 456.7
      assert loan_disbursement.approved_by == "some updated approved_by"
      assert loan_disbursement.approved_by_position == "some updated approved_by_position"
      assert loan_disbursement.checked_by == "some updated checked_by"
      assert loan_disbursement.checked_by_position == "some updated checked_by_position"
      assert loan_disbursement.cheque_no == "some updated cheque_no"
      assert loan_disbursement.customer_id == 43
      assert loan_disbursement.date_paid == ~D[2011-05-18]
      assert loan_disbursement.gl_account == "some updated gl_account"
      assert loan_disbursement.loan_id == 43
      assert loan_disbursement.loan_purpose == "some updated loan_purpose"
      assert loan_disbursement.payable_to == "some updated payable_to"
      assert loan_disbursement.reference_no == "some updated reference_no"
      assert loan_disbursement.requested_by == "some updated requested_by"
      assert loan_disbursement.requested_by_position == "some updated requested_by_position"
    end

    test "update_loan_disbursement/2 with invalid data returns error changeset" do
      loan_disbursement = loan_disbursement_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_disbursement(loan_disbursement, @invalid_attrs)
      assert loan_disbursement == Loan.get_loan_disbursement!(loan_disbursement.id)
    end

    test "delete_loan_disbursement/1 deletes the loan_disbursement" do
      loan_disbursement = loan_disbursement_fixture()
      assert {:ok, %Loan_disbursement{}} = Loan.delete_loan_disbursement(loan_disbursement)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_disbursement!(loan_disbursement.id) end
    end

    test "change_loan_disbursement/1 returns a loan_disbursement changeset" do
      loan_disbursement = loan_disbursement_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_disbursement(loan_disbursement)
    end
  end

  describe "tbl_loan_client_income_assessment" do
    alias Loanmanagementsystem.Loan.Loan_income_assessment

    @valid_attrs %{available_income: 120.5, average_income: 120.5, business_type: "some business_type", customer_id: 42, dec: 120.5, dec_total: 120.5, dsr: 120.5, dstv: 120.5, food: 120.5, jan: 120.5, jan_total: 120.5, loan_installment: 120.5, loan_installment_total: 120.5, nov: 120.5, nov_total: 120.5, reference_no: "some reference_no", salaries: 120.5, school: 120.5, stationery: 120.5, total_expenses: 120.5, transport: 120.5, utilities: 120.5}
    @update_attrs %{available_income: 456.7, average_income: 456.7, business_type: "some updated business_type", customer_id: 43, dec: 456.7, dec_total: 456.7, dsr: 456.7, dstv: 456.7, food: 456.7, jan: 456.7, jan_total: 456.7, loan_installment: 456.7, loan_installment_total: 456.7, nov: 456.7, nov_total: 456.7, reference_no: "some updated reference_no", salaries: 456.7, school: 456.7, stationery: 456.7, total_expenses: 456.7, transport: 456.7, utilities: 456.7}
    @invalid_attrs %{available_income: nil, average_income: nil, business_type: nil, customer_id: nil, dec: nil, dec_total: nil, dsr: nil, dstv: nil, food: nil, jan: nil, jan_total: nil, loan_installment: nil, loan_installment_total: nil, nov: nil, nov_total: nil, reference_no: nil, salaries: nil, school: nil, stationery: nil, total_expenses: nil, transport: nil, utilities: nil}

    def loan_income_assessment_fixture(attrs \\ %{}) do
      {:ok, loan_income_assessment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_income_assessment()

      loan_income_assessment
    end

    test "list_tbl_loan_client_income_assessment/0 returns all tbl_loan_client_income_assessment" do
      loan_income_assessment = loan_income_assessment_fixture()
      assert Loan.list_tbl_loan_client_income_assessment() == [loan_income_assessment]
    end

    test "get_loan_income_assessment!/1 returns the loan_income_assessment with given id" do
      loan_income_assessment = loan_income_assessment_fixture()
      assert Loan.get_loan_income_assessment!(loan_income_assessment.id) == loan_income_assessment
    end

    test "create_loan_income_assessment/1 with valid data creates a loan_income_assessment" do
      assert {:ok, %Loan_income_assessment{} = loan_income_assessment} = Loan.create_loan_income_assessment(@valid_attrs)
      assert loan_income_assessment.available_income == 120.5
      assert loan_income_assessment.average_income == 120.5
      assert loan_income_assessment.business_type == "some business_type"
      assert loan_income_assessment.customer_id == 42
      assert loan_income_assessment.dec == 120.5
      assert loan_income_assessment.dec_total == 120.5
      assert loan_income_assessment.dsr == 120.5
      assert loan_income_assessment.dstv == 120.5
      assert loan_income_assessment.food == 120.5
      assert loan_income_assessment.jan == 120.5
      assert loan_income_assessment.jan_total == 120.5
      assert loan_income_assessment.loan_installment == 120.5
      assert loan_income_assessment.loan_installment_total == 120.5
      assert loan_income_assessment.nov == 120.5
      assert loan_income_assessment.nov_total == 120.5
      assert loan_income_assessment.reference_no == "some reference_no"
      assert loan_income_assessment.salaries == 120.5
      assert loan_income_assessment.school == 120.5
      assert loan_income_assessment.stationery == 120.5
      assert loan_income_assessment.total_expenses == 120.5
      assert loan_income_assessment.transport == 120.5
      assert loan_income_assessment.utilities == 120.5
    end

    test "create_loan_income_assessment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_income_assessment(@invalid_attrs)
    end

    test "update_loan_income_assessment/2 with valid data updates the loan_income_assessment" do
      loan_income_assessment = loan_income_assessment_fixture()
      assert {:ok, %Loan_income_assessment{} = loan_income_assessment} = Loan.update_loan_income_assessment(loan_income_assessment, @update_attrs)
      assert loan_income_assessment.available_income == 456.7
      assert loan_income_assessment.average_income == 456.7
      assert loan_income_assessment.business_type == "some updated business_type"
      assert loan_income_assessment.customer_id == 43
      assert loan_income_assessment.dec == 456.7
      assert loan_income_assessment.dec_total == 456.7
      assert loan_income_assessment.dsr == 456.7
      assert loan_income_assessment.dstv == 456.7
      assert loan_income_assessment.food == 456.7
      assert loan_income_assessment.jan == 456.7
      assert loan_income_assessment.jan_total == 456.7
      assert loan_income_assessment.loan_installment == 456.7
      assert loan_income_assessment.loan_installment_total == 456.7
      assert loan_income_assessment.nov == 456.7
      assert loan_income_assessment.nov_total == 456.7
      assert loan_income_assessment.reference_no == "some updated reference_no"
      assert loan_income_assessment.salaries == 456.7
      assert loan_income_assessment.school == 456.7
      assert loan_income_assessment.stationery == 456.7
      assert loan_income_assessment.total_expenses == 456.7
      assert loan_income_assessment.transport == 456.7
      assert loan_income_assessment.utilities == 456.7
    end

    test "update_loan_income_assessment/2 with invalid data returns error changeset" do
      loan_income_assessment = loan_income_assessment_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_income_assessment(loan_income_assessment, @invalid_attrs)
      assert loan_income_assessment == Loan.get_loan_income_assessment!(loan_income_assessment.id)
    end

    test "delete_loan_income_assessment/1 deletes the loan_income_assessment" do
      loan_income_assessment = loan_income_assessment_fixture()
      assert {:ok, %Loan_income_assessment{}} = Loan.delete_loan_income_assessment(loan_income_assessment)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_income_assessment!(loan_income_assessment.id) end
    end

    test "change_loan_income_assessment/1 returns a loan_income_assessment changeset" do
      loan_income_assessment = loan_income_assessment_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_income_assessment(loan_income_assessment)
    end
  end

  describe "tbl_writteoff_loans" do
    alias Loanmanagementsystem.Loan.Writtenoff_loans

    @valid_attrs %{amount_writtenoff: "some amount_writtenoff", client_name: "some client_name", customer_id: 42, date_of_writtenoff: ~D[2010-04-17], loan_id: 42, reference_no: "some reference_no", savings_account: "some savings_account", writtenoff_by: "some writtenoff_by"}
    @update_attrs %{amount_writtenoff: "some updated amount_writtenoff", client_name: "some updated client_name", customer_id: 43, date_of_writtenoff: ~D[2011-05-18], loan_id: 43, reference_no: "some updated reference_no", savings_account: "some updated savings_account", writtenoff_by: "some updated writtenoff_by"}
    @invalid_attrs %{amount_writtenoff: nil, client_name: nil, customer_id: nil, date_of_writtenoff: nil, loan_id: nil, reference_no: nil, savings_account: nil, writtenoff_by: nil}

    def writtenoff_loans_fixture(attrs \\ %{}) do
      {:ok, writtenoff_loans} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_writtenoff_loans()

      writtenoff_loans
    end

    test "list_tbl_writteoff_loans/0 returns all tbl_writteoff_loans" do
      writtenoff_loans = writtenoff_loans_fixture()
      assert Loan.list_tbl_writteoff_loans() == [writtenoff_loans]
    end

    test "get_writtenoff_loans!/1 returns the writtenoff_loans with given id" do
      writtenoff_loans = writtenoff_loans_fixture()
      assert Loan.get_writtenoff_loans!(writtenoff_loans.id) == writtenoff_loans
    end

    test "create_writtenoff_loans/1 with valid data creates a writtenoff_loans" do
      assert {:ok, %Writtenoff_loans{} = writtenoff_loans} = Loan.create_writtenoff_loans(@valid_attrs)
      assert writtenoff_loans.amount_writtenoff == "some amount_writtenoff"
      assert writtenoff_loans.client_name == "some client_name"
      assert writtenoff_loans.customer_id == 42
      assert writtenoff_loans.date_of_writtenoff == ~D[2010-04-17]
      assert writtenoff_loans.loan_id == 42
      assert writtenoff_loans.reference_no == "some reference_no"
      assert writtenoff_loans.savings_account == "some savings_account"
      assert writtenoff_loans.writtenoff_by == "some writtenoff_by"
    end

    test "create_writtenoff_loans/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_writtenoff_loans(@invalid_attrs)
    end

    test "update_writtenoff_loans/2 with valid data updates the writtenoff_loans" do
      writtenoff_loans = writtenoff_loans_fixture()
      assert {:ok, %Writtenoff_loans{} = writtenoff_loans} = Loan.update_writtenoff_loans(writtenoff_loans, @update_attrs)
      assert writtenoff_loans.amount_writtenoff == "some updated amount_writtenoff"
      assert writtenoff_loans.client_name == "some updated client_name"
      assert writtenoff_loans.customer_id == 43
      assert writtenoff_loans.date_of_writtenoff == ~D[2011-05-18]
      assert writtenoff_loans.loan_id == 43
      assert writtenoff_loans.reference_no == "some updated reference_no"
      assert writtenoff_loans.savings_account == "some updated savings_account"
      assert writtenoff_loans.writtenoff_by == "some updated writtenoff_by"
    end

    test "update_writtenoff_loans/2 with invalid data returns error changeset" do
      writtenoff_loans = writtenoff_loans_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_writtenoff_loans(writtenoff_loans, @invalid_attrs)
      assert writtenoff_loans == Loan.get_writtenoff_loans!(writtenoff_loans.id)
    end

    test "delete_writtenoff_loans/1 deletes the writtenoff_loans" do
      writtenoff_loans = writtenoff_loans_fixture()
      assert {:ok, %Writtenoff_loans{}} = Loan.delete_writtenoff_loans(writtenoff_loans)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_writtenoff_loans!(writtenoff_loans.id) end
    end

    test "change_writtenoff_loans/1 returns a writtenoff_loans changeset" do
      writtenoff_loans = writtenoff_loans_fixture()
      assert %Ecto.Changeset{} = Loan.change_writtenoff_loans(writtenoff_loans)
    end
  end

  describe "tbl_customer_loan_application" do
    alias Loanmanagementsystem.Loan.Customer_loan_application

    @valid_attrs %{customer_id: 42, email: "some email", first_name: "some first_name", last_name: "some last_name", loan_amount: 120.5, loan_period: 120.5, pay_monthly: 120.5, phone: "some phone", product: "some product", product_id: 42, product_interet_rate: 120.5, status: "some status", total_interest: 120.5, total_pay_back: 120.5}
    @update_attrs %{customer_id: 43, email: "some updated email", first_name: "some updated first_name", last_name: "some updated last_name", loan_amount: 456.7, loan_period: 456.7, pay_monthly: 456.7, phone: "some updated phone", product: "some updated product", product_id: 43, product_interet_rate: 456.7, status: "some updated status", total_interest: 456.7, total_pay_back: 456.7}
    @invalid_attrs %{customer_id: nil, email: nil, first_name: nil, last_name: nil, loan_amount: nil, loan_period: nil, pay_monthly: nil, phone: nil, product: nil, product_id: nil, product_interet_rate: nil, status: nil, total_interest: nil, total_pay_back: nil}

    def customer_loan_application_fixture(attrs \\ %{}) do
      {:ok, customer_loan_application} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_customer_loan_application()

      customer_loan_application
    end

    test "list_tbl_customer_loan_application/0 returns all tbl_customer_loan_application" do
      customer_loan_application = customer_loan_application_fixture()
      assert Loan.list_tbl_customer_loan_application() == [customer_loan_application]
    end

    test "get_customer_loan_application!/1 returns the customer_loan_application with given id" do
      customer_loan_application = customer_loan_application_fixture()
      assert Loan.get_customer_loan_application!(customer_loan_application.id) == customer_loan_application
    end

    test "create_customer_loan_application/1 with valid data creates a customer_loan_application" do
      assert {:ok, %Customer_loan_application{} = customer_loan_application} = Loan.create_customer_loan_application(@valid_attrs)
      assert customer_loan_application.customer_id == 42
      assert customer_loan_application.email == "some email"
      assert customer_loan_application.first_name == "some first_name"
      assert customer_loan_application.last_name == "some last_name"
      assert customer_loan_application.loan_amount == 120.5
      assert customer_loan_application.loan_period == 120.5
      assert customer_loan_application.pay_monthly == 120.5
      assert customer_loan_application.phone == "some phone"
      assert customer_loan_application.product == "some product"
      assert customer_loan_application.product_id == 42
      assert customer_loan_application.product_interet_rate == 120.5
      assert customer_loan_application.status == "some status"
      assert customer_loan_application.total_interest == 120.5
      assert customer_loan_application.total_pay_back == 120.5
    end

    test "create_customer_loan_application/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_customer_loan_application(@invalid_attrs)
    end

    test "update_customer_loan_application/2 with valid data updates the customer_loan_application" do
      customer_loan_application = customer_loan_application_fixture()
      assert {:ok, %Customer_loan_application{} = customer_loan_application} = Loan.update_customer_loan_application(customer_loan_application, @update_attrs)
      assert customer_loan_application.customer_id == 43
      assert customer_loan_application.email == "some updated email"
      assert customer_loan_application.first_name == "some updated first_name"
      assert customer_loan_application.last_name == "some updated last_name"
      assert customer_loan_application.loan_amount == 456.7
      assert customer_loan_application.loan_period == 456.7
      assert customer_loan_application.pay_monthly == 456.7
      assert customer_loan_application.phone == "some updated phone"
      assert customer_loan_application.product == "some updated product"
      assert customer_loan_application.product_id == 43
      assert customer_loan_application.product_interet_rate == 456.7
      assert customer_loan_application.status == "some updated status"
      assert customer_loan_application.total_interest == 456.7
      assert customer_loan_application.total_pay_back == 456.7
    end

    test "update_customer_loan_application/2 with invalid data returns error changeset" do
      customer_loan_application = customer_loan_application_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_customer_loan_application(customer_loan_application, @invalid_attrs)
      assert customer_loan_application == Loan.get_customer_loan_application!(customer_loan_application.id)
    end

    test "delete_customer_loan_application/1 deletes the customer_loan_application" do
      customer_loan_application = customer_loan_application_fixture()
      assert {:ok, %Customer_loan_application{}} = Loan.delete_customer_loan_application(customer_loan_application)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_customer_loan_application!(customer_loan_application.id) end
    end

    test "change_customer_loan_application/1 returns a customer_loan_application changeset" do
      customer_loan_application = customer_loan_application_fixture()
      assert %Ecto.Changeset{} = Loan.change_customer_loan_application(customer_loan_application)
    end
  end
end
