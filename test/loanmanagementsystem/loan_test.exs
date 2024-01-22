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

  describe "tbl_loan_colleteral_documents" do
    alias Loanmanagementsystem.Loan.Loan_Colletral_Documents

    @valid_attrs %{clientID: 42, company_id: 42, docType: "some docType", file: "some file", name: "some name", path: "some path", reference_no: "some reference_no", serialNo: "some serialNo", status: "some status", userID: 42}
    @update_attrs %{clientID: 43, company_id: 43, docType: "some updated docType", file: "some updated file", name: "some updated name", path: "some updated path", reference_no: "some updated reference_no", serialNo: "some updated serialNo", status: "some updated status", userID: 43}
    @invalid_attrs %{clientID: nil, company_id: nil, docType: nil, file: nil, name: nil, path: nil, reference_no: nil, serialNo: nil, status: nil, userID: nil}

    def loan__colletral__documents_fixture(attrs \\ %{}) do
      {:ok, loan__colletral__documents} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan__colletral__documents()

      loan__colletral__documents
    end

    test "list_tbl_loan_colleteral_documents/0 returns all tbl_loan_colleteral_documents" do
      loan__colletral__documents = loan__colletral__documents_fixture()
      assert Loan.list_tbl_loan_colleteral_documents() == [loan__colletral__documents]
    end

    test "get_loan__colletral__documents!/1 returns the loan__colletral__documents with given id" do
      loan__colletral__documents = loan__colletral__documents_fixture()
      assert Loan.get_loan__colletral__documents!(loan__colletral__documents.id) == loan__colletral__documents
    end

    test "create_loan__colletral__documents/1 with valid data creates a loan__colletral__documents" do
      assert {:ok, %Loan_Colletral_Documents{} = loan__colletral__documents} = Loan.create_loan__colletral__documents(@valid_attrs)
      assert loan__colletral__documents.clientID == 42
      assert loan__colletral__documents.company_id == 42
      assert loan__colletral__documents.docType == "some docType"
      assert loan__colletral__documents.file == "some file"
      assert loan__colletral__documents.name == "some name"
      assert loan__colletral__documents.path == "some path"
      assert loan__colletral__documents.reference_no == "some reference_no"
      assert loan__colletral__documents.serialNo == "some serialNo"
      assert loan__colletral__documents.status == "some status"
      assert loan__colletral__documents.userID == 42
    end

    test "create_loan__colletral__documents/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan__colletral__documents(@invalid_attrs)
    end

    test "update_loan__colletral__documents/2 with valid data updates the loan__colletral__documents" do
      loan__colletral__documents = loan__colletral__documents_fixture()
      assert {:ok, %Loan_Colletral_Documents{} = loan__colletral__documents} = Loan.update_loan__colletral__documents(loan__colletral__documents, @update_attrs)
      assert loan__colletral__documents.clientID == 43
      assert loan__colletral__documents.company_id == 43
      assert loan__colletral__documents.docType == "some updated docType"
      assert loan__colletral__documents.file == "some updated file"
      assert loan__colletral__documents.name == "some updated name"
      assert loan__colletral__documents.path == "some updated path"
      assert loan__colletral__documents.reference_no == "some updated reference_no"
      assert loan__colletral__documents.serialNo == "some updated serialNo"
      assert loan__colletral__documents.status == "some updated status"
      assert loan__colletral__documents.userID == 43
    end

    test "update_loan__colletral__documents/2 with invalid data returns error changeset" do
      loan__colletral__documents = loan__colletral__documents_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan__colletral__documents(loan__colletral__documents, @invalid_attrs)
      assert loan__colletral__documents == Loan.get_loan__colletral__documents!(loan__colletral__documents.id)
    end

    test "delete_loan__colletral__documents/1 deletes the loan__colletral__documents" do
      loan__colletral__documents = loan__colletral__documents_fixture()
      assert {:ok, %Loan_Colletral_Documents{}} = Loan.delete_loan__colletral__documents(loan__colletral__documents)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan__colletral__documents!(loan__colletral__documents.id) end
    end

    test "change_loan__colletral__documents/1 returns a loan__colletral__documents changeset" do
      loan__colletral__documents = loan__colletral__documents_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan__colletral__documents(loan__colletral__documents)
    end
  end

  describe "tbl_loan_invoice" do
    alias Loanmanagementsystem.Loan.Loan_invoice

    @valid_attrs %{InvoiceValue: 120.5, PaymentTerms: "some PaymentTerms", customer_id: 42, dateOfIssue: ~D[2010-04-17], invoiceNo: "some invoiceNo", loanID: 42, status: "some status", vendorName: "some vendorName"}
    @update_attrs %{InvoiceValue: 456.7, PaymentTerms: "some updated PaymentTerms", customer_id: 43, dateOfIssue: ~D[2011-05-18], invoiceNo: "some updated invoiceNo", loanID: 43, status: "some updated status", vendorName: "some updated vendorName"}
    @invalid_attrs %{InvoiceValue: nil, PaymentTerms: nil, customer_id: nil, dateOfIssue: nil, invoiceNo: nil, loanID: nil, status: nil, vendorName: nil}

    def loan_invoice_fixture(attrs \\ %{}) do
      {:ok, loan_invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_invoice()

      loan_invoice
    end

    test "list_tbl_loan_invoice/0 returns all tbl_loan_invoice" do
      loan_invoice = loan_invoice_fixture()
      assert Loan.list_tbl_loan_invoice() == [loan_invoice]
    end

    test "get_loan_invoice!/1 returns the loan_invoice with given id" do
      loan_invoice = loan_invoice_fixture()
      assert Loan.get_loan_invoice!(loan_invoice.id) == loan_invoice
    end

    test "create_loan_invoice/1 with valid data creates a loan_invoice" do
      assert {:ok, %Loan_invoice{} = loan_invoice} = Loan.create_loan_invoice(@valid_attrs)
      assert loan_invoice.InvoiceValue == 120.5
      assert loan_invoice.PaymentTerms == "some PaymentTerms"
      assert loan_invoice.customer_id == 42
      assert loan_invoice.dateOfIssue == ~D[2010-04-17]
      assert loan_invoice.invoiceNo == "some invoiceNo"
      assert loan_invoice.loanID == 42
      assert loan_invoice.status == "some status"
      assert loan_invoice.vendorName == "some vendorName"
    end

    test "create_loan_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_invoice(@invalid_attrs)
    end

    test "update_loan_invoice/2 with valid data updates the loan_invoice" do
      loan_invoice = loan_invoice_fixture()
      assert {:ok, %Loan_invoice{} = loan_invoice} = Loan.update_loan_invoice(loan_invoice, @update_attrs)
      assert loan_invoice.InvoiceValue == 456.7
      assert loan_invoice.PaymentTerms == "some updated PaymentTerms"
      assert loan_invoice.customer_id == 43
      assert loan_invoice.dateOfIssue == ~D[2011-05-18]
      assert loan_invoice.invoiceNo == "some updated invoiceNo"
      assert loan_invoice.loanID == 43
      assert loan_invoice.status == "some updated status"
      assert loan_invoice.vendorName == "some updated vendorName"
    end

    test "update_loan_invoice/2 with invalid data returns error changeset" do
      loan_invoice = loan_invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_invoice(loan_invoice, @invalid_attrs)
      assert loan_invoice == Loan.get_loan_invoice!(loan_invoice.id)
    end

    test "delete_loan_invoice/1 deletes the loan_invoice" do
      loan_invoice = loan_invoice_fixture()
      assert {:ok, %Loan_invoice{}} = Loan.delete_loan_invoice(loan_invoice)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_invoice!(loan_invoice.id) end
    end

    test "change_loan_invoice/1 returns a loan_invoice changeset" do
      loan_invoice = loan_invoice_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_invoice(loan_invoice)
    end
  end

  describe "tbl_loan_funder" do
    alias Loanmanagementsystem.Loan.Loan_funder

    @valid_attrs %{FunderID: "some FunderID", TotalAmountFunded: "some TotalAmountFunded", Totalbalance: "some Totalbalance", Totalinterest: "some Totalinterest", accumulated: "some accumulated", status: "some status"}
    @update_attrs %{FunderID: "some updated FunderID", TotalAmountFunded: "some updated TotalAmountFunded", Totalbalance: "some updated Totalbalance", Totalinterest: "some updated Totalinterest", accumulated: "some updated accumulated", status: "some updated status"}
    @invalid_attrs %{FunderID: nil, TotalAmountFunded: nil, Totalbalance: nil, Totalinterest: nil, accumulated: nil, status: nil}

    def loan_funder_fixture(attrs \\ %{}) do
      {:ok, loan_funder} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_funder()

      loan_funder
    end

    test "list_tbl_loan_funder/0 returns all tbl_loan_funder" do
      loan_funder = loan_funder_fixture()
      assert Loan.list_tbl_loan_funder() == [loan_funder]
    end

    test "get_loan_funder!/1 returns the loan_funder with given id" do
      loan_funder = loan_funder_fixture()
      assert Loan.get_loan_funder!(loan_funder.id) == loan_funder
    end

    test "create_loan_funder/1 with valid data creates a loan_funder" do
      assert {:ok, %Loan_funder{} = loan_funder} = Loan.create_loan_funder(@valid_attrs)
      assert loan_funder.FunderID == "some FunderID"
      assert loan_funder.TotalAmountFunded == "some TotalAmountFunded"
      assert loan_funder.Totalbalance == "some Totalbalance"
      assert loan_funder.Totalinterest == "some Totalinterest"
      assert loan_funder.accumulated == "some accumulated"
      assert loan_funder.status == "some status"
    end

    test "create_loan_funder/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_funder(@invalid_attrs)
    end

    test "update_loan_funder/2 with valid data updates the loan_funder" do
      loan_funder = loan_funder_fixture()
      assert {:ok, %Loan_funder{} = loan_funder} = Loan.update_loan_funder(loan_funder, @update_attrs)
      assert loan_funder.FunderID == "some updated FunderID"
      assert loan_funder.TotalAmountFunded == "some updated TotalAmountFunded"
      assert loan_funder.Totalbalance == "some updated Totalbalance"
      assert loan_funder.Totalinterest == "some updated Totalinterest"
      assert loan_funder.accumulated == "some updated accumulated"
      assert loan_funder.status == "some updated status"
    end

    test "update_loan_funder/2 with invalid data returns error changeset" do
      loan_funder = loan_funder_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_funder(loan_funder, @invalid_attrs)
      assert loan_funder == Loan.get_loan_funder!(loan_funder.id)
    end

    test "delete_loan_funder/1 deletes the loan_funder" do
      loan_funder = loan_funder_fixture()
      assert {:ok, %Loan_funder{}} = Loan.delete_loan_funder(loan_funder)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_funder!(loan_funder.id) end
    end

    test "change_loan_funder/1 returns a loan_funder changeset" do
      loan_funder = loan_funder_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_funder(loan_funder)
    end
  end

  describe "tbl_loan_amortization_schedule" do
    alias Loanmanagementsystem.Loan.Loan_amortization_schedule

    @valid_attrs %{beginning_balance: 120.5, customer_id: 42, ending_balance: 120.5, interest: 120.5, interest_rate: 120.5, loan_amount: 120.5, loan_id: 42, month: 42, payment: 120.5, principal: 120.5, reference_no: "some reference_no", term_in_months: 120.5}
    @update_attrs %{beginning_balance: 456.7, customer_id: 43, ending_balance: 456.7, interest: 456.7, interest_rate: 456.7, loan_amount: 456.7, loan_id: 43, month: 43, payment: 456.7, principal: 456.7, reference_no: "some updated reference_no", term_in_months: 456.7}
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
      assert loan_amortization_schedule.customer_id == 42
      assert loan_amortization_schedule.ending_balance == 120.5
      assert loan_amortization_schedule.interest == 120.5
      assert loan_amortization_schedule.interest_rate == 120.5
      assert loan_amortization_schedule.loan_amount == 120.5
      assert loan_amortization_schedule.loan_id == 42
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
      assert loan_amortization_schedule.customer_id == 43
      assert loan_amortization_schedule.ending_balance == 456.7
      assert loan_amortization_schedule.interest == 456.7
      assert loan_amortization_schedule.interest_rate == 456.7
      assert loan_amortization_schedule.loan_amount == 456.7
      assert loan_amortization_schedule.loan_id == 43
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

  describe "tbl_end_of_day" do
    alias Loanmanagementsystem.Loan.End_of_day

    @valid_attrs %{currencyId: 42, currencyName: "some currencyName", date_ran: "2010-04-17T14:00:00Z", end_date: "2010-04-17T14:00:00Z", end_of_day_type: "some end_of_day_type", loan_id: 42, penalties_incurred: 120.5, principal_amount: 120.5, start_date: "2010-04-17T14:00:00Z", status: "some status", total_interest_accrued: 120.5}
    @update_attrs %{currencyId: 43, currencyName: "some updated currencyName", date_ran: "2011-05-18T15:01:01Z", end_date: "2011-05-18T15:01:01Z", end_of_day_type: "some updated end_of_day_type", loan_id: 43, penalties_incurred: 456.7, principal_amount: 456.7, start_date: "2011-05-18T15:01:01Z", status: "some updated status", total_interest_accrued: 456.7}
    @invalid_attrs %{currencyId: nil, currencyName: nil, date_ran: nil, end_date: nil, end_of_day_type: nil, loan_id: nil, penalties_incurred: nil, principal_amount: nil, start_date: nil, status: nil, total_interest_accrued: nil}

    def end_of_day_fixture(attrs \\ %{}) do
      {:ok, end_of_day} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_end_of_day()

      end_of_day
    end

    test "list_tbl_end_of_day/0 returns all tbl_end_of_day" do
      end_of_day = end_of_day_fixture()
      assert Loan.list_tbl_end_of_day() == [end_of_day]
    end

    test "get_end_of_day!/1 returns the end_of_day with given id" do
      end_of_day = end_of_day_fixture()
      assert Loan.get_end_of_day!(end_of_day.id) == end_of_day
    end

    test "create_end_of_day/1 with valid data creates a end_of_day" do
      assert {:ok, %End_of_day{} = end_of_day} = Loan.create_end_of_day(@valid_attrs)
      assert end_of_day.currencyId == 42
      assert end_of_day.currencyName == "some currencyName"
      assert end_of_day.date_ran == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert end_of_day.end_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert end_of_day.end_of_day_type == "some end_of_day_type"
      assert end_of_day.loan_id == 42
      assert end_of_day.penalties_incurred == 120.5
      assert end_of_day.principal_amount == 120.5
      assert end_of_day.start_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert end_of_day.status == "some status"
      assert end_of_day.total_interest_accrued == 120.5
    end

    test "create_end_of_day/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_end_of_day(@invalid_attrs)
    end

    test "update_end_of_day/2 with valid data updates the end_of_day" do
      end_of_day = end_of_day_fixture()
      assert {:ok, %End_of_day{} = end_of_day} = Loan.update_end_of_day(end_of_day, @update_attrs)
      assert end_of_day.currencyId == 43
      assert end_of_day.currencyName == "some updated currencyName"
      assert end_of_day.date_ran == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert end_of_day.end_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert end_of_day.end_of_day_type == "some updated end_of_day_type"
      assert end_of_day.loan_id == 43
      assert end_of_day.penalties_incurred == 456.7
      assert end_of_day.principal_amount == 456.7
      assert end_of_day.start_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert end_of_day.status == "some updated status"
      assert end_of_day.total_interest_accrued == 456.7
    end

    test "update_end_of_day/2 with invalid data returns error changeset" do
      end_of_day = end_of_day_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_end_of_day(end_of_day, @invalid_attrs)
      assert end_of_day == Loan.get_end_of_day!(end_of_day.id)
    end

    test "delete_end_of_day/1 deletes the end_of_day" do
      end_of_day = end_of_day_fixture()
      assert {:ok, %End_of_day{}} = Loan.delete_end_of_day(end_of_day)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_end_of_day!(end_of_day.id) end
    end

    test "change_end_of_day/1 returns a end_of_day changeset" do
      end_of_day = end_of_day_fixture()
      assert %Ecto.Changeset{} = Loan.change_end_of_day(end_of_day)
    end
  end

  describe "tbl_end_of_day_entries" do
    alias Loanmanagementsystem.Loan.End_of_day_entry

    @valid_attrs %{accrual_end_date: "2010-04-17T14:00:00Z", accrual_period: 42, accrual_start_date: "2010-04-17T14:00:00Z", charges_incurred: 120.5, currencyId: 42, currencyName: "some currencyName", end_of_day_date: "2010-04-17T14:00:00Z", end_of_day_id: 42, interest_accrued: 120.5, loan_id: 42, penalties_incurred: 120.5, principal_amount: 120.5, status: "some status"}
    @update_attrs %{accrual_end_date: "2011-05-18T15:01:01Z", accrual_period: 43, accrual_start_date: "2011-05-18T15:01:01Z", charges_incurred: 456.7, currencyId: 43, currencyName: "some updated currencyName", end_of_day_date: "2011-05-18T15:01:01Z", end_of_day_id: 43, interest_accrued: 456.7, loan_id: 43, penalties_incurred: 456.7, principal_amount: 456.7, status: "some updated status"}
    @invalid_attrs %{accrual_end_date: nil, accrual_period: nil, accrual_start_date: nil, charges_incurred: nil, currencyId: nil, currencyName: nil, end_of_day_date: nil, end_of_day_id: nil, interest_accrued: nil, loan_id: nil, penalties_incurred: nil, principal_amount: nil, status: nil}

    def end_of_day_entry_fixture(attrs \\ %{}) do
      {:ok, end_of_day_entry} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_end_of_day_entry()

      end_of_day_entry
    end

    test "list_tbl_end_of_day_entries/0 returns all tbl_end_of_day_entries" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert Loan.list_tbl_end_of_day_entries() == [end_of_day_entry]
    end

    test "get_end_of_day_entry!/1 returns the end_of_day_entry with given id" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert Loan.get_end_of_day_entry!(end_of_day_entry.id) == end_of_day_entry
    end

    test "create_end_of_day_entry/1 with valid data creates a end_of_day_entry" do
      assert {:ok, %End_of_day_entry{} = end_of_day_entry} = Loan.create_end_of_day_entry(@valid_attrs)
      assert end_of_day_entry.accrual_end_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert end_of_day_entry.accrual_period == 42
      assert end_of_day_entry.accrual_start_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert end_of_day_entry.charges_incurred == 120.5
      assert end_of_day_entry.currencyId == 42
      assert end_of_day_entry.currencyName == "some currencyName"
      assert end_of_day_entry.end_of_day_date == DateTime.from_naive!(~N[2010-04-17T14:00:00Z], "Etc/UTC")
      assert end_of_day_entry.end_of_day_id == 42
      assert end_of_day_entry.interest_accrued == 120.5
      assert end_of_day_entry.loan_id == 42
      assert end_of_day_entry.penalties_incurred == 120.5
      assert end_of_day_entry.principal_amount == 120.5
      assert end_of_day_entry.status == "some status"
    end

    test "create_end_of_day_entry/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_end_of_day_entry(@invalid_attrs)
    end

    test "update_end_of_day_entry/2 with valid data updates the end_of_day_entry" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert {:ok, %End_of_day_entry{} = end_of_day_entry} = Loan.update_end_of_day_entry(end_of_day_entry, @update_attrs)
      assert end_of_day_entry.accrual_end_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert end_of_day_entry.accrual_period == 43
      assert end_of_day_entry.accrual_start_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert end_of_day_entry.charges_incurred == 456.7
      assert end_of_day_entry.currencyId == 43
      assert end_of_day_entry.currencyName == "some updated currencyName"
      assert end_of_day_entry.end_of_day_date == DateTime.from_naive!(~N[2011-05-18T15:01:01Z], "Etc/UTC")
      assert end_of_day_entry.end_of_day_id == 43
      assert end_of_day_entry.interest_accrued == 456.7
      assert end_of_day_entry.loan_id == 43
      assert end_of_day_entry.penalties_incurred == 456.7
      assert end_of_day_entry.principal_amount == 456.7
      assert end_of_day_entry.status == "some updated status"
    end

    test "update_end_of_day_entry/2 with invalid data returns error changeset" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_end_of_day_entry(end_of_day_entry, @invalid_attrs)
      assert end_of_day_entry == Loan.get_end_of_day_entry!(end_of_day_entry.id)
    end

    test "delete_end_of_day_entry/1 deletes the end_of_day_entry" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert {:ok, %End_of_day_entry{}} = Loan.delete_end_of_day_entry(end_of_day_entry)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_end_of_day_entry!(end_of_day_entry.id) end
    end

    test "change_end_of_day_entry/1 returns a end_of_day_entry changeset" do
      end_of_day_entry = end_of_day_entry_fixture()
      assert %Ecto.Changeset{} = Loan.change_end_of_day_entry(end_of_day_entry)
  describe "tbl_order_finace_loan_invoice" do
    alias Loanmanagementsystem.Loan.Order_finance_loan_invoice

    @valid_attrs %{customer_id: 42, item_description: "some item_description", loan_id: 42, order_date: ~D[2010-04-17], order_number: "some order_number", order_value: 120.5, status: "some status", tenor: 42}
    @update_attrs %{customer_id: 43, item_description: "some updated item_description", loan_id: 43, order_date: ~D[2011-05-18], order_number: "some updated order_number", order_value: 456.7, status: "some updated status", tenor: 43}
    @invalid_attrs %{customer_id: nil, item_description: nil, loan_id: nil, order_date: nil, order_number: nil, order_value: nil, status: nil, tenor: nil}

    def order_finance_loan_invoice_fixture(attrs \\ %{}) do
      {:ok, order_finance_loan_invoice} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_order_finance_loan_invoice()

      order_finance_loan_invoice
    end

    test "list_tbl_order_finace_loan_invoice/0 returns all tbl_order_finace_loan_invoice" do
      order_finance_loan_invoice = order_finance_loan_invoice_fixture()
      assert Loan.list_tbl_order_finace_loan_invoice() == [order_finance_loan_invoice]
    end

    test "get_order_finance_loan_invoice!/1 returns the order_finance_loan_invoice with given id" do
      order_finance_loan_invoice = order_finance_loan_invoice_fixture()
      assert Loan.get_order_finance_loan_invoice!(order_finance_loan_invoice.id) == order_finance_loan_invoice
    end

    test "create_order_finance_loan_invoice/1 with valid data creates a order_finance_loan_invoice" do
      assert {:ok, %Order_finance_loan_invoice{} = order_finance_loan_invoice} = Loan.create_order_finance_loan_invoice(@valid_attrs)
      assert order_finance_loan_invoice.customer_id == 42
      assert order_finance_loan_invoice.item_description == "some item_description"
      assert order_finance_loan_invoice.loan_id == 42
      assert order_finance_loan_invoice.order_date == ~D[2010-04-17]
      assert order_finance_loan_invoice.order_number == "some order_number"
      assert order_finance_loan_invoice.order_value == 120.5
      assert order_finance_loan_invoice.status == "some status"
      assert order_finance_loan_invoice.tenor == 42
    end

    test "create_order_finance_loan_invoice/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_order_finance_loan_invoice(@invalid_attrs)
    end

    test "update_order_finance_loan_invoice/2 with valid data updates the order_finance_loan_invoice" do
      order_finance_loan_invoice = order_finance_loan_invoice_fixture()
      assert {:ok, %Order_finance_loan_invoice{} = order_finance_loan_invoice} = Loan.update_order_finance_loan_invoice(order_finance_loan_invoice, @update_attrs)
      assert order_finance_loan_invoice.customer_id == 43
      assert order_finance_loan_invoice.item_description == "some updated item_description"
      assert order_finance_loan_invoice.loan_id == 43
      assert order_finance_loan_invoice.order_date == ~D[2011-05-18]
      assert order_finance_loan_invoice.order_number == "some updated order_number"
      assert order_finance_loan_invoice.order_value == 456.7
      assert order_finance_loan_invoice.status == "some updated status"
      assert order_finance_loan_invoice.tenor == 43
    end

    test "update_order_finance_loan_invoice/2 with invalid data returns error changeset" do
      order_finance_loan_invoice = order_finance_loan_invoice_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_order_finance_loan_invoice(order_finance_loan_invoice, @invalid_attrs)
      assert order_finance_loan_invoice == Loan.get_order_finance_loan_invoice!(order_finance_loan_invoice.id)
    end

    test "delete_order_finance_loan_invoice/1 deletes the order_finance_loan_invoice" do
      order_finance_loan_invoice = order_finance_loan_invoice_fixture()
      assert {:ok, %Order_finance_loan_invoice{}} = Loan.delete_order_finance_loan_invoice(order_finance_loan_invoice)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_order_finance_loan_invoice!(order_finance_loan_invoice.id) end
    end

    test "change_order_finance_loan_invoice/1 returns a order_finance_loan_invoice changeset" do
      order_finance_loan_invoice = order_finance_loan_invoice_fixture()
      assert %Ecto.Changeset{} = Loan.change_order_finance_loan_invoice(order_finance_loan_invoice)
    end
  end

  describe "tbl_loan_init_figure" do
    alias Loanmanagementsystem.Loan.Bulk_loan_init_figures

    @valid_attrs %{balance: 120.5, init_arrangement_fee: 120.5, init_expected_repayment: 120.5, init_finance_cost_accrued: 120.5, init_interest_accrued: 120.5, init_principal_amount: 120.5, init_repaid_amount: 120.5, loan_id: 42, product_type: "some product_type", status: "some status"}
    @update_attrs %{balance: 456.7, init_arrangement_fee: 456.7, init_expected_repayment: 456.7, init_finance_cost_accrued: 456.7, init_interest_accrued: 456.7, init_principal_amount: 456.7, init_repaid_amount: 456.7, loan_id: 43, product_type: "some updated product_type", status: "some updated status"}
    @invalid_attrs %{balance: nil, init_arrangement_fee: nil, init_expected_repayment: nil, init_finance_cost_accrued: nil, init_interest_accrued: nil, init_principal_amount: nil, init_repaid_amount: nil, loan_id: nil, product_type: nil, status: nil}

    def bulk_loan_init_figures_fixture(attrs \\ %{}) do
      {:ok, bulk_loan_init_figures} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_bulk_loan_init_figures()

      bulk_loan_init_figures
    end

    test "list_tbl_loan_init_figure/0 returns all tbl_loan_init_figure" do
      bulk_loan_init_figures = bulk_loan_init_figures_fixture()
      assert Loan.list_tbl_loan_init_figure() == [bulk_loan_init_figures]
    end

    test "get_bulk_loan_init_figures!/1 returns the bulk_loan_init_figures with given id" do
      bulk_loan_init_figures = bulk_loan_init_figures_fixture()
      assert Loan.get_bulk_loan_init_figures!(bulk_loan_init_figures.id) == bulk_loan_init_figures
    end

    test "create_bulk_loan_init_figures/1 with valid data creates a bulk_loan_init_figures" do
      assert {:ok, %Bulk_loan_init_figures{} = bulk_loan_init_figures} = Loan.create_bulk_loan_init_figures(@valid_attrs)
      assert bulk_loan_init_figures.balance == 120.5
      assert bulk_loan_init_figures.init_arrangement_fee == 120.5
      assert bulk_loan_init_figures.init_expected_repayment == 120.5
      assert bulk_loan_init_figures.init_finance_cost_accrued == 120.5
      assert bulk_loan_init_figures.init_interest_accrued == 120.5
      assert bulk_loan_init_figures.init_principal_amount == 120.5
      assert bulk_loan_init_figures.init_repaid_amount == 120.5
      assert bulk_loan_init_figures.loan_id == 42
      assert bulk_loan_init_figures.product_type == "some product_type"
      assert bulk_loan_init_figures.status == "some status"
    end

    test "create_bulk_loan_init_figures/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_bulk_loan_init_figures(@invalid_attrs)
    end

    test "update_bulk_loan_init_figures/2 with valid data updates the bulk_loan_init_figures" do
      bulk_loan_init_figures = bulk_loan_init_figures_fixture()
      assert {:ok, %Bulk_loan_init_figures{} = bulk_loan_init_figures} = Loan.update_bulk_loan_init_figures(bulk_loan_init_figures, @update_attrs)
      assert bulk_loan_init_figures.balance == 456.7
      assert bulk_loan_init_figures.init_arrangement_fee == 456.7
      assert bulk_loan_init_figures.init_expected_repayment == 456.7
      assert bulk_loan_init_figures.init_finance_cost_accrued == 456.7
      assert bulk_loan_init_figures.init_interest_accrued == 456.7
      assert bulk_loan_init_figures.init_principal_amount == 456.7
      assert bulk_loan_init_figures.init_repaid_amount == 456.7
      assert bulk_loan_init_figures.loan_id == 43
      assert bulk_loan_init_figures.product_type == "some updated product_type"
      assert bulk_loan_init_figures.status == "some updated status"
    end

    test "update_bulk_loan_init_figures/2 with invalid data returns error changeset" do
      bulk_loan_init_figures = bulk_loan_init_figures_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_bulk_loan_init_figures(bulk_loan_init_figures, @invalid_attrs)
      assert bulk_loan_init_figures == Loan.get_bulk_loan_init_figures!(bulk_loan_init_figures.id)
    end

    test "delete_bulk_loan_init_figures/1 deletes the bulk_loan_init_figures" do
      bulk_loan_init_figures = bulk_loan_init_figures_fixture()
      assert {:ok, %Bulk_loan_init_figures{}} = Loan.delete_bulk_loan_init_figures(bulk_loan_init_figures)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_bulk_loan_init_figures!(bulk_loan_init_figures.id) end
    end

    test "change_bulk_loan_init_figures/1 returns a bulk_loan_init_figures changeset" do
      bulk_loan_init_figures = bulk_loan_init_figures_fixture()
      assert %Ecto.Changeset{} = Loan.change_bulk_loan_init_figures(bulk_loan_init_figures)
    end
  end
end
