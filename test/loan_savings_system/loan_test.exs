defmodule LoanSavingsSystem.LoanTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Loan

  describe "tbl_loans" do
    alias LoanSavingsSystem.Loan.Loans

    @valid_attrs %{penalty_charges_writtenoff_derived: 120.5, interest_waived_derived: 120.5, rejectedon_date: ~D[2010-04-17], interest_method: "some interest_method", repay_every: 42, withdrawnon_date: ~D[2010-04-17], total_writtenoff_derived: 120.5, approved_principal: 120.5, approvedon_date: ~D[2010-04-17], principal_disbursed_derived: 120.5, annual_nominal_interest_rate: 120.5, principal_amount_proposed: 120.5, "": "some ", fee_charges_writtenoff_derived: 120.5, interest_calculated_from_date: ~D[2010-04-17], fee_charges_charged_derived: 120.5, principal_repaid_derived: 120.5, approvedon_userid: 42, interest_repaid_derived: 120.5, external_id: "some external_id", total_outstanding_derived: 120.5, fee_charges_outstanding_derived: 120.5, fee_charges_repaid_derived: 120.5, disbursedon_userid: 42, total_costofloan_derived: 120.5, principal_writtenoff_derived: 120.5, loan_counter: 42, loan_type: "some loan_type", penalty_charges_charged_derived: 120.5, number_of_repayments: 42, account_no: "some account_no", customer_id: 42, writtenoffon_date: ~D[2010-04-17], penalty_charges_outstanding_derived: 120.5, principal_amount: 120.5, rejectedon_userid: 42, expected_maturity_date: ~D[2010-04-17], term_frequency: 42, penalty_charges_repaid_derived: 120.5, repay_every_type: ~D[2010-04-17], closedon_date: ~D[2010-04-17], penalty_charges_waived_derived: 120.5, interest_writtenoff_derived: 120.5, loan_status: "some loan_status", disbursedon_date: ~D[2010-04-17], term_frequency_type: "some term_frequency_type", closedon_userid: 42, interest_outstanding_derived: 120.5, withdrawnon_userid: 42, total_expected_repayment_derived: 120.5, ...}
    @update_attrs %{penalty_charges_writtenoff_derived: 456.7, interest_waived_derived: 456.7, rejectedon_date: ~D[2011-05-18], interest_method: "some updated interest_method", repay_every: 43, withdrawnon_date: ~D[2011-05-18], total_writtenoff_derived: 456.7, approved_principal: 456.7, approvedon_date: ~D[2011-05-18], principal_disbursed_derived: 456.7, annual_nominal_interest_rate: 456.7, principal_amount_proposed: 456.7, "": "some updated ", fee_charges_writtenoff_derived: 456.7, interest_calculated_from_date: ~D[2011-05-18], fee_charges_charged_derived: 456.7, principal_repaid_derived: 456.7, approvedon_userid: 43, interest_repaid_derived: 456.7, external_id: "some updated external_id", total_outstanding_derived: 456.7, fee_charges_outstanding_derived: 456.7, fee_charges_repaid_derived: 456.7, disbursedon_userid: 43, total_costofloan_derived: 456.7, principal_writtenoff_derived: 456.7, loan_counter: 43, loan_type: "some updated loan_type", penalty_charges_charged_derived: 456.7, number_of_repayments: 43, account_no: "some updated account_no", customer_id: 43, writtenoffon_date: ~D[2011-05-18], penalty_charges_outstanding_derived: 456.7, principal_amount: 456.7, rejectedon_userid: 43, expected_maturity_date: ~D[2011-05-18], term_frequency: 43, penalty_charges_repaid_derived: 456.7, repay_every_type: ~D[2011-05-18], closedon_date: ~D[2011-05-18], penalty_charges_waived_derived: 456.7, interest_writtenoff_derived: 456.7, loan_status: "some updated loan_status", disbursedon_date: ~D[2011-05-18], term_frequency_type: "some updated term_frequency_type", closedon_userid: 43, interest_outstanding_derived: 456.7, withdrawnon_userid: 43, total_expected_repayment_derived: 456.7, ...}
    @invalid_attrs %{penalty_charges_writtenoff_derived: nil, interest_waived_derived: nil, rejectedon_date: nil, interest_method: nil, repay_every: nil, withdrawnon_date: nil, total_writtenoff_derived: nil, approved_principal: nil, approvedon_date: nil, principal_disbursed_derived: nil, annual_nominal_interest_rate: nil, principal_amount_proposed: nil, "": nil, fee_charges_writtenoff_derived: nil, interest_calculated_from_date: nil, fee_charges_charged_derived: nil, principal_repaid_derived: nil, approvedon_userid: nil, interest_repaid_derived: nil, external_id: nil, total_outstanding_derived: nil, fee_charges_outstanding_derived: nil, fee_charges_repaid_derived: nil, disbursedon_userid: nil, total_costofloan_derived: nil, principal_writtenoff_derived: nil, loan_counter: nil, loan_type: nil, penalty_charges_charged_derived: nil, number_of_repayments: nil, account_no: nil, customer_id: nil, writtenoffon_date: nil, penalty_charges_outstanding_derived: nil, principal_amount: nil, rejectedon_userid: nil, expected_maturity_date: nil, term_frequency: nil, penalty_charges_repaid_derived: nil, repay_every_type: nil, closedon_date: nil, penalty_charges_waived_derived: nil, interest_writtenoff_derived: nil, loan_status: nil, disbursedon_date: nil, term_frequency_type: nil, closedon_userid: nil, interest_outstanding_derived: nil, withdrawnon_userid: nil, total_expected_repayment_derived: nil, ...}

    def loans_fixture(attrs \\ %{}) do
      {:ok, loans} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loans()

      loans
    end

    test "list_tbl_loans/0 returns all tbl_loans" do
      loans = loans_fixture()
      assert Loan.list_tbl_loans() == [loans]
    end

    test "get_loans!/1 returns the loans with given id" do
      loans = loans_fixture()
      assert Loan.get_loans!(loans.id) == loans
    end

    test "create_loans/1 with valid data creates a loans" do
      assert {:ok, %Loans{} = loans} = Loan.create_loans(@valid_attrs)
      assert loans.is_npa == true
      assert loans.total_expected_costofloan_derived == 120.5
      assert loans.fee_charges_waived_derived == 120.5
      assert loans.expected_disbursedon_date == ~D[2010-04-17]
      assert loans.total_repayment_derived == 120.5
      assert loans.is_legacyloan == true
      assert loans.interest_charged_derived == 120.5
      assert loans.product_id == "some product_id"
      assert loans.total_overpaid_derived == 120.5
      assert loans.total_waived_derived == 120.5
      assert loans.currency_code == "some currency_code"
      assert loans.principal_outstanding_derived == 120.5
      assert loans.total_charges_due_at_disbursement_derived == 120.5
      assert loans.total_expected_repayment_derived == 120.5
      assert loans.withdrawnon_userid == 42
      assert loans.interest_outstanding_derived == 120.5
      assert loans.closedon_userid == 42
      assert loans.term_frequency_type == "some term_frequency_type"
      assert loans.disbursedon_date == ~D[2010-04-17]
      assert loans.loan_status == "some loan_status"
      assert loans.interest_writtenoff_derived == 120.5
      assert loans.penalty_charges_waived_derived == 120.5
      assert loans.closedon_date == ~D[2010-04-17]
      assert loans.repay_every_type == ~D[2010-04-17]
      assert loans.penalty_charges_repaid_derived == 120.5
      assert loans.term_frequency == 42
      assert loans.expected_maturity_date == ~D[2010-04-17]
      assert loans.rejectedon_userid == 42
      assert loans.principal_amount == 120.5
      assert loans.penalty_charges_outstanding_derived == 120.5
      assert loans.writtenoffon_date == ~D[2010-04-17]
      assert loans.customer_id == 42
      assert loans.account_no == "some account_no"
      assert loans.number_of_repayments == 42
      assert loans.penalty_charges_charged_derived == 120.5
      assert loans.loan_type == "some loan_type"
      assert loans.loan_counter == 42
      assert loans.principal_writtenoff_derived == 120.5
      assert loans.total_costofloan_derived == 120.5
      assert loans.disbursedon_userid == 42
      assert loans.fee_charges_repaid_derived == 120.5
      assert loans.fee_charges_outstanding_derived == 120.5
      assert loans.total_outstanding_derived == 120.5
      assert loans.external_id == "some external_id"
      assert loans.interest_repaid_derived == 120.5
      assert loans.approvedon_userid == 42
      assert loans.principal_repaid_derived == 120.5
      assert loans.fee_charges_charged_derived == 120.5
      assert loans.interest_calculated_from_date == ~D[2010-04-17]
      assert loans.fee_charges_writtenoff_derived == 120.5
      assert loans. == "some "
      assert loans.principal_amount_proposed == 120.5
      assert loans.annual_nominal_interest_rate == 120.5
      assert loans.principal_disbursed_derived == 120.5
      assert loans.approvedon_date == ~D[2010-04-17]
      assert loans.approved_principal == 120.5
      assert loans.total_writtenoff_derived == 120.5
      assert loans.withdrawnon_date == ~D[2010-04-17]
      assert loans.repay_every == 42
      assert loans.interest_method == "some interest_method"
      assert loans.rejectedon_date == ~D[2010-04-17]
      assert loans.interest_waived_derived == 120.5
      assert loans.penalty_charges_writtenoff_derived == 120.5
    end

    test "create_loans/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loans(@invalid_attrs)
    end

    test "update_loans/2 with valid data updates the loans" do
      loans = loans_fixture()
      assert {:ok, %Loans{} = loans} = Loan.update_loans(loans, @update_attrs)
      assert loans.is_npa == false
      assert loans.total_expected_costofloan_derived == 456.7
      assert loans.fee_charges_waived_derived == 456.7
      assert loans.expected_disbursedon_date == ~D[2011-05-18]
      assert loans.total_repayment_derived == 456.7
      assert loans.is_legacyloan == false
      assert loans.interest_charged_derived == 456.7
      assert loans.product_id == "some updated product_id"
      assert loans.total_overpaid_derived == 456.7
      assert loans.total_waived_derived == 456.7
      assert loans.currency_code == "some updated currency_code"
      assert loans.principal_outstanding_derived == 456.7
      assert loans.total_charges_due_at_disbursement_derived == 456.7
      assert loans.total_expected_repayment_derived == 456.7
      assert loans.withdrawnon_userid == 43
      assert loans.interest_outstanding_derived == 456.7
      assert loans.closedon_userid == 43
      assert loans.term_frequency_type == "some updated term_frequency_type"
      assert loans.disbursedon_date == ~D[2011-05-18]
      assert loans.loan_status == "some updated loan_status"
      assert loans.interest_writtenoff_derived == 456.7
      assert loans.penalty_charges_waived_derived == 456.7
      assert loans.closedon_date == ~D[2011-05-18]
      assert loans.repay_every_type == ~D[2011-05-18]
      assert loans.penalty_charges_repaid_derived == 456.7
      assert loans.term_frequency == 43
      assert loans.expected_maturity_date == ~D[2011-05-18]
      assert loans.rejectedon_userid == 43
      assert loans.principal_amount == 456.7
      assert loans.penalty_charges_outstanding_derived == 456.7
      assert loans.writtenoffon_date == ~D[2011-05-18]
      assert loans.customer_id == 43
      assert loans.account_no == "some updated account_no"
      assert loans.number_of_repayments == 43
      assert loans.penalty_charges_charged_derived == 456.7
      assert loans.loan_type == "some updated loan_type"
      assert loans.loan_counter == 43
      assert loans.principal_writtenoff_derived == 456.7
      assert loans.total_costofloan_derived == 456.7
      assert loans.disbursedon_userid == 43
      assert loans.fee_charges_repaid_derived == 456.7
      assert loans.fee_charges_outstanding_derived == 456.7
      assert loans.total_outstanding_derived == 456.7
      assert loans.external_id == "some updated external_id"
      assert loans.interest_repaid_derived == 456.7
      assert loans.approvedon_userid == 43
      assert loans.principal_repaid_derived == 456.7
      assert loans.fee_charges_charged_derived == 456.7
      assert loans.interest_calculated_from_date == ~D[2011-05-18]
      assert loans.fee_charges_writtenoff_derived == 456.7
      assert loans. == "some updated "
      assert loans.principal_amount_proposed == 456.7
      assert loans.annual_nominal_interest_rate == 456.7
      assert loans.principal_disbursed_derived == 456.7
      assert loans.approvedon_date == ~D[2011-05-18]
      assert loans.approved_principal == 456.7
      assert loans.total_writtenoff_derived == 456.7
      assert loans.withdrawnon_date == ~D[2011-05-18]
      assert loans.repay_every == 43
      assert loans.interest_method == "some updated interest_method"
      assert loans.rejectedon_date == ~D[2011-05-18]
      assert loans.interest_waived_derived == 456.7
      assert loans.penalty_charges_writtenoff_derived == 456.7
    end

    test "update_loans/2 with invalid data returns error changeset" do
      loans = loans_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loans(loans, @invalid_attrs)
      assert loans == Loan.get_loans!(loans.id)
    end

    test "delete_loans/1 deletes the loans" do
      loans = loans_fixture()
      assert {:ok, %Loans{}} = Loan.delete_loans(loans)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loans!(loans.id) end
    end

    test "change_loans/1 returns a loans changeset" do
      loans = loans_fixture()
      assert %Ecto.Changeset{} = Loan.change_loans(loans)
    end
  end

  describe "tbl_loan" do
    alias LoanSavingsSystem.Loan.Loanapplication

    @valid_attrs %{app: "some app", company_id: "some company_id", customer_id: "some customer_id", customer_name: "some customer_name", loan_status: "some loan_status"}
    @update_attrs %{app: "some updated app", company_id: "some updated company_id", customer_id: "some updated customer_id", customer_name: "some updated customer_name", loan_status: "some updated loan_status"}
    @invalid_attrs %{app: nil, company_id: nil, customer_id: nil, customer_name: nil, loan_status: nil}

    def loanapplication_fixture(attrs \\ %{}) do
      {:ok, loanapplication} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loanapplication()

      loanapplication
    end

    test "list_tbl_loan/0 returns all tbl_loan" do
      loanapplication = loanapplication_fixture()
      assert Loan.list_tbl_loan() == [loanapplication]
    end

    test "get_loanapplication!/1 returns the loanapplication with given id" do
      loanapplication = loanapplication_fixture()
      assert Loan.get_loanapplication!(loanapplication.id) == loanapplication
    end

    test "create_loanapplication/1 with valid data creates a loanapplication" do
      assert {:ok, %Loanapplication{} = loanapplication} = Loan.create_loanapplication(@valid_attrs)
      assert loanapplication.app == "some app"
      assert loanapplication.company_id == "some company_id"
      assert loanapplication.customer_id == "some customer_id"
      assert loanapplication.customer_name == "some customer_name"
      assert loanapplication.loan_status == "some loan_status"
    end

    test "create_loanapplication/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loanapplication(@invalid_attrs)
    end

    test "update_loanapplication/2 with valid data updates the loanapplication" do
      loanapplication = loanapplication_fixture()
      assert {:ok, %Loanapplication{} = loanapplication} = Loan.update_loanapplication(loanapplication, @update_attrs)
      assert loanapplication.app == "some updated app"
      assert loanapplication.company_id == "some updated company_id"
      assert loanapplication.customer_id == "some updated customer_id"
      assert loanapplication.customer_name == "some updated customer_name"
      assert loanapplication.loan_status == "some updated loan_status"
    end

    test "update_loanapplication/2 with invalid data returns error changeset" do
      loanapplication = loanapplication_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loanapplication(loanapplication, @invalid_attrs)
      assert loanapplication == Loan.get_loanapplication!(loanapplication.id)
    end

    test "delete_loanapplication/1 deletes the loanapplication" do
      loanapplication = loanapplication_fixture()
      assert {:ok, %Loanapplication{}} = Loan.delete_loanapplication(loanapplication)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loanapplication!(loanapplication.id) end
    end

    test "change_loanapplication/1 returns a loanapplication changeset" do
      loanapplication = loanapplication_fixture()
      assert %Ecto.Changeset{} = Loan.change_loanapplication(loanapplication)
    end
  end

  describe "tbl_loan_application" do
    alias LoanSavingsSystem.Loan.Loanapplication

    @valid_attrs %{app: "some app", company_id: "some company_id", customer_id: "some customer_id", customer_name: "some customer_name", loan_status: "some loan_status"}
    @update_attrs %{app: "some updated app", company_id: "some updated company_id", customer_id: "some updated customer_id", customer_name: "some updated customer_name", loan_status: "some updated loan_status"}
    @invalid_attrs %{app: nil, company_id: nil, customer_id: nil, customer_name: nil, loan_status: nil}

    def loanapplication_fixture(attrs \\ %{}) do
      {:ok, loanapplication} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loanapplication()

      loanapplication
    end

    test "list_tbl_loan_application/0 returns all tbl_loan_application" do
      loanapplication = loanapplication_fixture()
      assert Loan.list_tbl_loan_application() == [loanapplication]
    end

    test "get_loanapplication!/1 returns the loanapplication with given id" do
      loanapplication = loanapplication_fixture()
      assert Loan.get_loanapplication!(loanapplication.id) == loanapplication
    end

    test "create_loanapplication/1 with valid data creates a loanapplication" do
      assert {:ok, %Loanapplication{} = loanapplication} = Loan.create_loanapplication(@valid_attrs)
      assert loanapplication.app == "some app"
      assert loanapplication.company_id == "some company_id"
      assert loanapplication.customer_id == "some customer_id"
      assert loanapplication.customer_name == "some customer_name"
      assert loanapplication.loan_status == "some loan_status"
    end

    test "create_loanapplication/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loanapplication(@invalid_attrs)
    end

    test "update_loanapplication/2 with valid data updates the loanapplication" do
      loanapplication = loanapplication_fixture()
      assert {:ok, %Loanapplication{} = loanapplication} = Loan.update_loanapplication(loanapplication, @update_attrs)
      assert loanapplication.app == "some updated app"
      assert loanapplication.company_id == "some updated company_id"
      assert loanapplication.customer_id == "some updated customer_id"
      assert loanapplication.customer_name == "some updated customer_name"
      assert loanapplication.loan_status == "some updated loan_status"
    end

    test "update_loanapplication/2 with invalid data returns error changeset" do
      loanapplication = loanapplication_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loanapplication(loanapplication, @invalid_attrs)
      assert loanapplication == Loan.get_loanapplication!(loanapplication.id)
    end

    test "delete_loanapplication/1 deletes the loanapplication" do
      loanapplication = loanapplication_fixture()
      assert {:ok, %Loanapplication{}} = Loan.delete_loanapplication(loanapplication)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loanapplication!(loanapplication.id) end
    end

    test "change_loanapplication/1 returns a loanapplication changeset" do
      loanapplication = loanapplication_fixture()
      assert %Ecto.Changeset{} = Loan.change_loanapplication(loanapplication)
    end
  end

  describe "tbl_refund_request" do
    alias LoanSavingsSystem.Loan.Refund

    @valid_attrs %{amount: "some amount", company_id: "some company_id", customer_id: "some customer_id", loan_id: "some loan_id", status: "some status", transaction_id: "some transaction_id", user_id: "some user_id"}
    @update_attrs %{amount: "some updated amount", company_id: "some updated company_id", customer_id: "some updated customer_id", loan_id: "some updated loan_id", status: "some updated status", transaction_id: "some updated transaction_id", user_id: "some updated user_id"}
    @invalid_attrs %{amount: nil, company_id: nil, customer_id: nil, loan_id: nil, status: nil, transaction_id: nil, user_id: nil}

    def refund_fixture(attrs \\ %{}) do
      {:ok, refund} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_refund()

      refund
    end

    test "list_tbl_refund_request/0 returns all tbl_refund_request" do
      refund = refund_fixture()
      assert Loan.list_tbl_refund_request() == [refund]
    end

    test "get_refund!/1 returns the refund with given id" do
      refund = refund_fixture()
      assert Loan.get_refund!(refund.id) == refund
    end

    test "create_refund/1 with valid data creates a refund" do
      assert {:ok, %Refund{} = refund} = Loan.create_refund(@valid_attrs)
      assert refund.amount == "some amount"
      assert refund.company_id == "some company_id"
      assert refund.customer_id == "some customer_id"
      assert refund.loan_id == "some loan_id"
      assert refund.status == "some status"
      assert refund.transaction_id == "some transaction_id"
      assert refund.user_id == "some user_id"
    end

    test "create_refund/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_refund(@invalid_attrs)
    end

    test "update_refund/2 with valid data updates the refund" do
      refund = refund_fixture()
      assert {:ok, %Refund{} = refund} = Loan.update_refund(refund, @update_attrs)
      assert refund.amount == "some updated amount"
      assert refund.company_id == "some updated company_id"
      assert refund.customer_id == "some updated customer_id"
      assert refund.loan_id == "some updated loan_id"
      assert refund.status == "some updated status"
      assert refund.transaction_id == "some updated transaction_id"
      assert refund.user_id == "some updated user_id"
    end

    test "update_refund/2 with invalid data returns error changeset" do
      refund = refund_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_refund(refund, @invalid_attrs)
      assert refund == Loan.get_refund!(refund.id)
    end

    test "delete_refund/1 deletes the refund" do
      refund = refund_fixture()
      assert {:ok, %Refund{}} = Loan.delete_refund(refund)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_refund!(refund.id) end
    end

    test "change_refund/1 returns a refund changeset" do
      refund = refund_fixture()
      assert %Ecto.Changeset{} = Loan.change_refund(refund)
    end
  end

  describe "tbl_loan_charge" do
    alias LoanSavingsSystem.Loan.LoanCharge

    @valid_attrs %{amount: 120.5, amount_outstanding_derived: 120.5, amount_paid_derived: 120.5, amount_waived_derived: 120.5, amount_writtenoff_derived: 120.5, calculation_on_amount: 120.5, calculation_percentage: 120.5, charge_amount_or_percentage: 120.5, charge_calculation_enum: "some charge_calculation_enum", charge_id: 42, charge_payment_mode_enum: "some charge_payment_mode_enum", charge_time_enum: "some charge_time_enum", due_for_collection_as_of_date: "some due_for_collection_as_of_date", is_active: true, is_paid_derived: true, is_penalty: true, is_waived: true, loan_id: 42}
    @update_attrs %{amount: 456.7, amount_outstanding_derived: 456.7, amount_paid_derived: 456.7, amount_waived_derived: 456.7, amount_writtenoff_derived: 456.7, calculation_on_amount: 456.7, calculation_percentage: 456.7, charge_amount_or_percentage: 456.7, charge_calculation_enum: "some updated charge_calculation_enum", charge_id: 43, charge_payment_mode_enum: "some updated charge_payment_mode_enum", charge_time_enum: "some updated charge_time_enum", due_for_collection_as_of_date: "some updated due_for_collection_as_of_date", is_active: false, is_paid_derived: false, is_penalty: false, is_waived: false, loan_id: 43}
    @invalid_attrs %{amount: nil, amount_outstanding_derived: nil, amount_paid_derived: nil, amount_waived_derived: nil, amount_writtenoff_derived: nil, calculation_on_amount: nil, calculation_percentage: nil, charge_amount_or_percentage: nil, charge_calculation_enum: nil, charge_id: nil, charge_payment_mode_enum: nil, charge_time_enum: nil, due_for_collection_as_of_date: nil, is_active: nil, is_paid_derived: nil, is_penalty: nil, is_waived: nil, loan_id: nil}

    def loan_charge_fixture(attrs \\ %{}) do
      {:ok, loan_charge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_charge()

      loan_charge
    end

    test "list_tbl_loan_charge/0 returns all tbl_loan_charge" do
      loan_charge = loan_charge_fixture()
      assert Loan.list_tbl_loan_charge() == [loan_charge]
    end

    test "get_loan_charge!/1 returns the loan_charge with given id" do
      loan_charge = loan_charge_fixture()
      assert Loan.get_loan_charge!(loan_charge.id) == loan_charge
    end

    test "create_loan_charge/1 with valid data creates a loan_charge" do
      assert {:ok, %LoanCharge{} = loan_charge} = Loan.create_loan_charge(@valid_attrs)
      assert loan_charge.amount == 120.5
      assert loan_charge.amount_outstanding_derived == 120.5
      assert loan_charge.amount_paid_derived == 120.5
      assert loan_charge.amount_waived_derived == 120.5
      assert loan_charge.amount_writtenoff_derived == 120.5
      assert loan_charge.calculation_on_amount == 120.5
      assert loan_charge.calculation_percentage == 120.5
      assert loan_charge.charge_amount_or_percentage == 120.5
      assert loan_charge.charge_calculation_enum == "some charge_calculation_enum"
      assert loan_charge.charge_id == 42
      assert loan_charge.charge_payment_mode_enum == "some charge_payment_mode_enum"
      assert loan_charge.charge_time_enum == "some charge_time_enum"
      assert loan_charge.due_for_collection_as_of_date == "some due_for_collection_as_of_date"
      assert loan_charge.is_active == true
      assert loan_charge.is_paid_derived == true
      assert loan_charge.is_penalty == true
      assert loan_charge.is_waived == true
      assert loan_charge.loan_id == 42
    end

    test "create_loan_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_charge(@invalid_attrs)
    end

    test "update_loan_charge/2 with valid data updates the loan_charge" do
      loan_charge = loan_charge_fixture()
      assert {:ok, %LoanCharge{} = loan_charge} = Loan.update_loan_charge(loan_charge, @update_attrs)
      assert loan_charge.amount == 456.7
      assert loan_charge.amount_outstanding_derived == 456.7
      assert loan_charge.amount_paid_derived == 456.7
      assert loan_charge.amount_waived_derived == 456.7
      assert loan_charge.amount_writtenoff_derived == 456.7
      assert loan_charge.calculation_on_amount == 456.7
      assert loan_charge.calculation_percentage == 456.7
      assert loan_charge.charge_amount_or_percentage == 456.7
      assert loan_charge.charge_calculation_enum == "some updated charge_calculation_enum"
      assert loan_charge.charge_id == 43
      assert loan_charge.charge_payment_mode_enum == "some updated charge_payment_mode_enum"
      assert loan_charge.charge_time_enum == "some updated charge_time_enum"
      assert loan_charge.due_for_collection_as_of_date == "some updated due_for_collection_as_of_date"
      assert loan_charge.is_active == false
      assert loan_charge.is_paid_derived == false
      assert loan_charge.is_penalty == false
      assert loan_charge.is_waived == false
      assert loan_charge.loan_id == 43
    end

    test "update_loan_charge/2 with invalid data returns error changeset" do
      loan_charge = loan_charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_charge(loan_charge, @invalid_attrs)
      assert loan_charge == Loan.get_loan_charge!(loan_charge.id)
    end

    test "delete_loan_charge/1 deletes the loan_charge" do
      loan_charge = loan_charge_fixture()
      assert {:ok, %LoanCharge{}} = Loan.delete_loan_charge(loan_charge)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_charge!(loan_charge.id) end
    end

    test "change_loan_charge/1 returns a loan_charge changeset" do
      loan_charge = loan_charge_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_charge(loan_charge)
    end
  end

  describe "tbl_loan_charge_payment" do
    alias LoanSavingsSystem.Loan.LoanChargePayment

    @valid_attrs %{amount: 120.5, installment_number: 42, loan_charge_id: 42, loan_id: 42, loan_transaction_id: 42}
    @update_attrs %{amount: 456.7, installment_number: 43, loan_charge_id: 43, loan_id: 43, loan_transaction_id: 43}
    @invalid_attrs %{amount: nil, installment_number: nil, loan_charge_id: nil, loan_id: nil, loan_transaction_id: nil}

    def loan_charge_payment_fixture(attrs \\ %{}) do
      {:ok, loan_charge_payment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_charge_payment()

      loan_charge_payment
    end

    test "list_tbl_loan_charge_payment/0 returns all tbl_loan_charge_payment" do
      loan_charge_payment = loan_charge_payment_fixture()
      assert Loan.list_tbl_loan_charge_payment() == [loan_charge_payment]
    end

    test "get_loan_charge_payment!/1 returns the loan_charge_payment with given id" do
      loan_charge_payment = loan_charge_payment_fixture()
      assert Loan.get_loan_charge_payment!(loan_charge_payment.id) == loan_charge_payment
    end

    test "create_loan_charge_payment/1 with valid data creates a loan_charge_payment" do
      assert {:ok, %LoanChargePayment{} = loan_charge_payment} = Loan.create_loan_charge_payment(@valid_attrs)
      assert loan_charge_payment.amount == 120.5
      assert loan_charge_payment.installment_number == 42
      assert loan_charge_payment.loan_charge_id == 42
      assert loan_charge_payment.loan_id == 42
      assert loan_charge_payment.loan_transaction_id == 42
    end

    test "create_loan_charge_payment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_charge_payment(@invalid_attrs)
    end

    test "update_loan_charge_payment/2 with valid data updates the loan_charge_payment" do
      loan_charge_payment = loan_charge_payment_fixture()
      assert {:ok, %LoanChargePayment{} = loan_charge_payment} = Loan.update_loan_charge_payment(loan_charge_payment, @update_attrs)
      assert loan_charge_payment.amount == 456.7
      assert loan_charge_payment.installment_number == 43
      assert loan_charge_payment.loan_charge_id == 43
      assert loan_charge_payment.loan_id == 43
      assert loan_charge_payment.loan_transaction_id == 43
    end

    test "update_loan_charge_payment/2 with invalid data returns error changeset" do
      loan_charge_payment = loan_charge_payment_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_charge_payment(loan_charge_payment, @invalid_attrs)
      assert loan_charge_payment == Loan.get_loan_charge_payment!(loan_charge_payment.id)
    end

    test "delete_loan_charge_payment/1 deletes the loan_charge_payment" do
      loan_charge_payment = loan_charge_payment_fixture()
      assert {:ok, %LoanChargePayment{}} = Loan.delete_loan_charge_payment(loan_charge_payment)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_charge_payment!(loan_charge_payment.id) end
    end

    test "change_loan_charge_payment/1 returns a loan_charge_payment changeset" do
      loan_charge_payment = loan_charge_payment_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_charge_payment(loan_charge_payment)
    end
  end

  describe "tbl_loan_collateral" do
    alias LoanSavingsSystem.Loan.LoanCollateral

    @valid_attrs %{collateral_type: "some collateral_type", description: "some description", loan_id: 42, valuation: 120.5}
    @update_attrs %{collateral_type: "some updated collateral_type", description: "some updated description", loan_id: 43, valuation: 456.7}
    @invalid_attrs %{collateral_type: nil, description: nil, loan_id: nil, valuation: nil}

    def loan_collateral_fixture(attrs \\ %{}) do
      {:ok, loan_collateral} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_collateral()

      loan_collateral
    end

    test "list_tbl_loan_collateral/0 returns all tbl_loan_collateral" do
      loan_collateral = loan_collateral_fixture()
      assert Loan.list_tbl_loan_collateral() == [loan_collateral]
    end

    test "get_loan_collateral!/1 returns the loan_collateral with given id" do
      loan_collateral = loan_collateral_fixture()
      assert Loan.get_loan_collateral!(loan_collateral.id) == loan_collateral
    end

    test "create_loan_collateral/1 with valid data creates a loan_collateral" do
      assert {:ok, %LoanCollateral{} = loan_collateral} = Loan.create_loan_collateral(@valid_attrs)
      assert loan_collateral.collateral_type == "some collateral_type"
      assert loan_collateral.description == "some description"
      assert loan_collateral.loan_id == 42
      assert loan_collateral.valuation == 120.5
    end

    test "create_loan_collateral/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_collateral(@invalid_attrs)
    end

    test "update_loan_collateral/2 with valid data updates the loan_collateral" do
      loan_collateral = loan_collateral_fixture()
      assert {:ok, %LoanCollateral{} = loan_collateral} = Loan.update_loan_collateral(loan_collateral, @update_attrs)
      assert loan_collateral.collateral_type == "some updated collateral_type"
      assert loan_collateral.description == "some updated description"
      assert loan_collateral.loan_id == 43
      assert loan_collateral.valuation == 456.7
    end

    test "update_loan_collateral/2 with invalid data returns error changeset" do
      loan_collateral = loan_collateral_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_collateral(loan_collateral, @invalid_attrs)
      assert loan_collateral == Loan.get_loan_collateral!(loan_collateral.id)
    end

    test "delete_loan_collateral/1 deletes the loan_collateral" do
      loan_collateral = loan_collateral_fixture()
      assert {:ok, %LoanCollateral{}} = Loan.delete_loan_collateral(loan_collateral)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_collateral!(loan_collateral.id) end
    end

    test "change_loan_collateral/1 returns a loan_collateral changeset" do
      loan_collateral = loan_collateral_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_collateral(loan_collateral)
    end
  end

  describe "tbl_loan_installment_charge" do
    alias LoanSavingsSystem.Loan.LoanInstallmentCharge

    @valid_attrs %{amount: 120.5, amount_outstanding_derived: 120.5, amount_paid_derived: 120.5, amount_waived_derived: 120.5, amount_writtenoff_derived: 120.5, due_date: ~D[2010-04-17], is_paid_derived: true, is_waived: true, loan_charge_id: 42, loan_schedule_id: 42}
    @update_attrs %{amount: 456.7, amount_outstanding_derived: 456.7, amount_paid_derived: 456.7, amount_waived_derived: 456.7, amount_writtenoff_derived: 456.7, due_date: ~D[2011-05-18], is_paid_derived: false, is_waived: false, loan_charge_id: 43, loan_schedule_id: 43}
    @invalid_attrs %{amount: nil, amount_outstanding_derived: nil, amount_paid_derived: nil, amount_waived_derived: nil, amount_writtenoff_derived: nil, due_date: nil, is_paid_derived: nil, is_waived: nil, loan_charge_id: nil, loan_schedule_id: nil}

    def loan_installment_charge_fixture(attrs \\ %{}) do
      {:ok, loan_installment_charge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_installment_charge()

      loan_installment_charge
    end

    test "list_tbl_loan_installment_charge/0 returns all tbl_loan_installment_charge" do
      loan_installment_charge = loan_installment_charge_fixture()
      assert Loan.list_tbl_loan_installment_charge() == [loan_installment_charge]
    end

    test "get_loan_installment_charge!/1 returns the loan_installment_charge with given id" do
      loan_installment_charge = loan_installment_charge_fixture()
      assert Loan.get_loan_installment_charge!(loan_installment_charge.id) == loan_installment_charge
    end

    test "create_loan_installment_charge/1 with valid data creates a loan_installment_charge" do
      assert {:ok, %LoanInstallmentCharge{} = loan_installment_charge} = Loan.create_loan_installment_charge(@valid_attrs)
      assert loan_installment_charge.amount == 120.5
      assert loan_installment_charge.amount_outstanding_derived == 120.5
      assert loan_installment_charge.amount_paid_derived == 120.5
      assert loan_installment_charge.amount_waived_derived == 120.5
      assert loan_installment_charge.amount_writtenoff_derived == 120.5
      assert loan_installment_charge.due_date == ~D[2010-04-17]
      assert loan_installment_charge.is_paid_derived == true
      assert loan_installment_charge.is_waived == true
      assert loan_installment_charge.loan_charge_id == 42
      assert loan_installment_charge.loan_schedule_id == 42
    end

    test "create_loan_installment_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_installment_charge(@invalid_attrs)
    end

    test "update_loan_installment_charge/2 with valid data updates the loan_installment_charge" do
      loan_installment_charge = loan_installment_charge_fixture()
      assert {:ok, %LoanInstallmentCharge{} = loan_installment_charge} = Loan.update_loan_installment_charge(loan_installment_charge, @update_attrs)
      assert loan_installment_charge.amount == 456.7
      assert loan_installment_charge.amount_outstanding_derived == 456.7
      assert loan_installment_charge.amount_paid_derived == 456.7
      assert loan_installment_charge.amount_waived_derived == 456.7
      assert loan_installment_charge.amount_writtenoff_derived == 456.7
      assert loan_installment_charge.due_date == ~D[2011-05-18]
      assert loan_installment_charge.is_paid_derived == false
      assert loan_installment_charge.is_waived == false
      assert loan_installment_charge.loan_charge_id == 43
      assert loan_installment_charge.loan_schedule_id == 43
    end

    test "update_loan_installment_charge/2 with invalid data returns error changeset" do
      loan_installment_charge = loan_installment_charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_installment_charge(loan_installment_charge, @invalid_attrs)
      assert loan_installment_charge == Loan.get_loan_installment_charge!(loan_installment_charge.id)
    end

    test "delete_loan_installment_charge/1 deletes the loan_installment_charge" do
      loan_installment_charge = loan_installment_charge_fixture()
      assert {:ok, %LoanInstallmentCharge{}} = Loan.delete_loan_installment_charge(loan_installment_charge)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_installment_charge!(loan_installment_charge.id) end
    end

    test "change_loan_installment_charge/1 returns a loan_installment_charge changeset" do
      loan_installment_charge = loan_installment_charge_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_installment_charge(loan_installment_charge)
    end
  end

  describe "tbl_loan_officer_assignment" do
    alias LoanSavingsSystem.Loan.LoanOfficerAssignment

    @valid_attrs %{created_date: ~D[2010-04-17], createdby_id: 42, end_date: ~D[2010-04-17], lastmodifiedby_id: 42, loan_id: 42, loan_officer_id: 42, start_date: ~D[2010-04-17], updated_date: ~D[2010-04-17]}
    @update_attrs %{created_date: ~D[2011-05-18], createdby_id: 43, end_date: ~D[2011-05-18], lastmodifiedby_id: 43, loan_id: 43, loan_officer_id: 43, start_date: ~D[2011-05-18], updated_date: ~D[2011-05-18]}
    @invalid_attrs %{created_date: nil, createdby_id: nil, end_date: nil, lastmodifiedby_id: nil, loan_id: nil, loan_officer_id: nil, start_date: nil, updated_date: nil}

    def loan_officer_assignment_fixture(attrs \\ %{}) do
      {:ok, loan_officer_assignment} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_officer_assignment()

      loan_officer_assignment
    end

    test "list_tbl_loan_officer_assignment/0 returns all tbl_loan_officer_assignment" do
      loan_officer_assignment = loan_officer_assignment_fixture()
      assert Loan.list_tbl_loan_officer_assignment() == [loan_officer_assignment]
    end

    test "get_loan_officer_assignment!/1 returns the loan_officer_assignment with given id" do
      loan_officer_assignment = loan_officer_assignment_fixture()
      assert Loan.get_loan_officer_assignment!(loan_officer_assignment.id) == loan_officer_assignment
    end

    test "create_loan_officer_assignment/1 with valid data creates a loan_officer_assignment" do
      assert {:ok, %LoanOfficerAssignment{} = loan_officer_assignment} = Loan.create_loan_officer_assignment(@valid_attrs)
      assert loan_officer_assignment.created_date == ~D[2010-04-17]
      assert loan_officer_assignment.createdby_id == 42
      assert loan_officer_assignment.end_date == ~D[2010-04-17]
      assert loan_officer_assignment.lastmodifiedby_id == 42
      assert loan_officer_assignment.loan_id == 42
      assert loan_officer_assignment.loan_officer_id == 42
      assert loan_officer_assignment.start_date == ~D[2010-04-17]
      assert loan_officer_assignment.updated_date == ~D[2010-04-17]
    end

    test "create_loan_officer_assignment/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_officer_assignment(@invalid_attrs)
    end

    test "update_loan_officer_assignment/2 with valid data updates the loan_officer_assignment" do
      loan_officer_assignment = loan_officer_assignment_fixture()
      assert {:ok, %LoanOfficerAssignment{} = loan_officer_assignment} = Loan.update_loan_officer_assignment(loan_officer_assignment, @update_attrs)
      assert loan_officer_assignment.created_date == ~D[2011-05-18]
      assert loan_officer_assignment.createdby_id == 43
      assert loan_officer_assignment.end_date == ~D[2011-05-18]
      assert loan_officer_assignment.lastmodifiedby_id == 43
      assert loan_officer_assignment.loan_id == 43
      assert loan_officer_assignment.loan_officer_id == 43
      assert loan_officer_assignment.start_date == ~D[2011-05-18]
      assert loan_officer_assignment.updated_date == ~D[2011-05-18]
    end

    test "update_loan_officer_assignment/2 with invalid data returns error changeset" do
      loan_officer_assignment = loan_officer_assignment_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_officer_assignment(loan_officer_assignment, @invalid_attrs)
      assert loan_officer_assignment == Loan.get_loan_officer_assignment!(loan_officer_assignment.id)
    end

    test "delete_loan_officer_assignment/1 deletes the loan_officer_assignment" do
      loan_officer_assignment = loan_officer_assignment_fixture()
      assert {:ok, %LoanOfficerAssignment{}} = Loan.delete_loan_officer_assignment(loan_officer_assignment)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_officer_assignment!(loan_officer_assignment.id) end
    end

    test "change_loan_officer_assignment/1 returns a loan_officer_assignment changeset" do
      loan_officer_assignment = loan_officer_assignment_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_officer_assignment(loan_officer_assignment)
    end
  end

  describe "tbl_loan_overdue_installment_charge" do
    alias LoanSavingsSystem.Loan.LoanOverdueInstallmentCharge

    @valid_attrs %{loan_charge_id: 42, loan_schedule_id: 42, overdue_amount: 120.5}
    @update_attrs %{loan_charge_id: 43, loan_schedule_id: 43, overdue_amount: 456.7}
    @invalid_attrs %{loan_charge_id: nil, loan_schedule_id: nil, overdue_amount: nil}

    def loan_overdue_installment_charge_fixture(attrs \\ %{}) do
      {:ok, loan_overdue_installment_charge} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_overdue_installment_charge()

      loan_overdue_installment_charge
    end

    test "list_tbl_loan_overdue_installment_charge/0 returns all tbl_loan_overdue_installment_charge" do
      loan_overdue_installment_charge = loan_overdue_installment_charge_fixture()
      assert Loan.list_tbl_loan_overdue_installment_charge() == [loan_overdue_installment_charge]
    end

    test "get_loan_overdue_installment_charge!/1 returns the loan_overdue_installment_charge with given id" do
      loan_overdue_installment_charge = loan_overdue_installment_charge_fixture()
      assert Loan.get_loan_overdue_installment_charge!(loan_overdue_installment_charge.id) == loan_overdue_installment_charge
    end

    test "create_loan_overdue_installment_charge/1 with valid data creates a loan_overdue_installment_charge" do
      assert {:ok, %LoanOverdueInstallmentCharge{} = loan_overdue_installment_charge} = Loan.create_loan_overdue_installment_charge(@valid_attrs)
      assert loan_overdue_installment_charge.loan_charge_id == 42
      assert loan_overdue_installment_charge.loan_schedule_id == 42
      assert loan_overdue_installment_charge.overdue_amount == 120.5
    end

    test "create_loan_overdue_installment_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_overdue_installment_charge(@invalid_attrs)
    end

    test "update_loan_overdue_installment_charge/2 with valid data updates the loan_overdue_installment_charge" do
      loan_overdue_installment_charge = loan_overdue_installment_charge_fixture()
      assert {:ok, %LoanOverdueInstallmentCharge{} = loan_overdue_installment_charge} = Loan.update_loan_overdue_installment_charge(loan_overdue_installment_charge, @update_attrs)
      assert loan_overdue_installment_charge.loan_charge_id == 43
      assert loan_overdue_installment_charge.loan_schedule_id == 43
      assert loan_overdue_installment_charge.overdue_amount == 456.7
    end

    test "update_loan_overdue_installment_charge/2 with invalid data returns error changeset" do
      loan_overdue_installment_charge = loan_overdue_installment_charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_overdue_installment_charge(loan_overdue_installment_charge, @invalid_attrs)
      assert loan_overdue_installment_charge == Loan.get_loan_overdue_installment_charge!(loan_overdue_installment_charge.id)
    end

    test "delete_loan_overdue_installment_charge/1 deletes the loan_overdue_installment_charge" do
      loan_overdue_installment_charge = loan_overdue_installment_charge_fixture()
      assert {:ok, %LoanOverdueInstallmentCharge{}} = Loan.delete_loan_overdue_installment_charge(loan_overdue_installment_charge)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_overdue_installment_charge!(loan_overdue_installment_charge.id) end
    end

    test "change_loan_overdue_installment_charge/1 returns a loan_overdue_installment_charge changeset" do
      loan_overdue_installment_charge = loan_overdue_installment_charge_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_overdue_installment_charge(loan_overdue_installment_charge)
    end
  end

  describe "tbl_loan_paid_in_advance" do
    alias LoanSavingsSystem.Loan.LoanPaidInAdvance

    @valid_attrs %{fee_charges_in_advance_derived: 120.5, interest_in_advance_derived: 120.5, loan_id: 42, penalty_charges_in_advance_derived: 120.5, principal_in_advance_derived: 120.5, total_in_advance_derived: 120.5}
    @update_attrs %{fee_charges_in_advance_derived: 456.7, interest_in_advance_derived: 456.7, loan_id: 43, penalty_charges_in_advance_derived: 456.7, principal_in_advance_derived: 456.7, total_in_advance_derived: 456.7}
    @invalid_attrs %{fee_charges_in_advance_derived: nil, interest_in_advance_derived: nil, loan_id: nil, penalty_charges_in_advance_derived: nil, principal_in_advance_derived: nil, total_in_advance_derived: nil}

    def loan_paid_in_advance_fixture(attrs \\ %{}) do
      {:ok, loan_paid_in_advance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_paid_in_advance()

      loan_paid_in_advance
    end

    test "list_tbl_loan_paid_in_advance/0 returns all tbl_loan_paid_in_advance" do
      loan_paid_in_advance = loan_paid_in_advance_fixture()
      assert Loan.list_tbl_loan_paid_in_advance() == [loan_paid_in_advance]
    end

    test "get_loan_paid_in_advance!/1 returns the loan_paid_in_advance with given id" do
      loan_paid_in_advance = loan_paid_in_advance_fixture()
      assert Loan.get_loan_paid_in_advance!(loan_paid_in_advance.id) == loan_paid_in_advance
    end

    test "create_loan_paid_in_advance/1 with valid data creates a loan_paid_in_advance" do
      assert {:ok, %LoanPaidInAdvance{} = loan_paid_in_advance} = Loan.create_loan_paid_in_advance(@valid_attrs)
      assert loan_paid_in_advance.fee_charges_in_advance_derived == 120.5
      assert loan_paid_in_advance.interest_in_advance_derived == 120.5
      assert loan_paid_in_advance.loan_id == 42
      assert loan_paid_in_advance.penalty_charges_in_advance_derived == 120.5
      assert loan_paid_in_advance.principal_in_advance_derived == 120.5
      assert loan_paid_in_advance.total_in_advance_derived == 120.5
    end

    test "create_loan_paid_in_advance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_paid_in_advance(@invalid_attrs)
    end

    test "update_loan_paid_in_advance/2 with valid data updates the loan_paid_in_advance" do
      loan_paid_in_advance = loan_paid_in_advance_fixture()
      assert {:ok, %LoanPaidInAdvance{} = loan_paid_in_advance} = Loan.update_loan_paid_in_advance(loan_paid_in_advance, @update_attrs)
      assert loan_paid_in_advance.fee_charges_in_advance_derived == 456.7
      assert loan_paid_in_advance.interest_in_advance_derived == 456.7
      assert loan_paid_in_advance.loan_id == 43
      assert loan_paid_in_advance.penalty_charges_in_advance_derived == 456.7
      assert loan_paid_in_advance.principal_in_advance_derived == 456.7
      assert loan_paid_in_advance.total_in_advance_derived == 456.7
    end

    test "update_loan_paid_in_advance/2 with invalid data returns error changeset" do
      loan_paid_in_advance = loan_paid_in_advance_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_paid_in_advance(loan_paid_in_advance, @invalid_attrs)
      assert loan_paid_in_advance == Loan.get_loan_paid_in_advance!(loan_paid_in_advance.id)
    end

    test "delete_loan_paid_in_advance/1 deletes the loan_paid_in_advance" do
      loan_paid_in_advance = loan_paid_in_advance_fixture()
      assert {:ok, %LoanPaidInAdvance{}} = Loan.delete_loan_paid_in_advance(loan_paid_in_advance)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_paid_in_advance!(loan_paid_in_advance.id) end
    end

    test "change_loan_paid_in_advance/1 returns a loan_paid_in_advance changeset" do
      loan_paid_in_advance = loan_paid_in_advance_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_paid_in_advance(loan_paid_in_advance)
    end
  end

  describe "tbl_loan_repayment_schedule" do
    alias LoanSavingsSystem.Loan.LoanRepaymentSchedule

    @valid_attrs %{accrual_fee_charges_derived: 120.5, accrual_interest_derived: 120.5, accrual_penalty_charges_derived: 120.5, completed_derived: 120.5, createdby_id: 42, duedate: ~D[2010-04-17], fee_charges_amount: 120.5, fee_charges_completed_derived: 120.5, fee_charges_waived_derived: 120.5, fee_charges_writtenoff_derived: 120.5, fromdate: ~D[2010-04-17], installment: 120.5, interest_amount: 120.5, interest_completed_derived: 120.5, interest_waived_derived: 120.5, interest_writtenoff_derived: 120.5, lastmodifiedby_id: 42, loan_id: 42, obligations_met_on_date: ~D[2010-04-17], penalty_charges_amount: 120.5, penalty_charges_completed_derived: 120.5, penalty_charges_waived_derived: 120.5, penalty_charges_writtenoff_derived: 120.5, principal_amount: 120.5, principal_completed_derived: 120.5, principal_writtenoff_derived: 120.5, total_paid_in_advance_derived: 120.5, total_paid_late_derived: 120.5}
    @update_attrs %{accrual_fee_charges_derived: 456.7, accrual_interest_derived: 456.7, accrual_penalty_charges_derived: 456.7, completed_derived: 456.7, createdby_id: 43, duedate: ~D[2011-05-18], fee_charges_amount: 456.7, fee_charges_completed_derived: 456.7, fee_charges_waived_derived: 456.7, fee_charges_writtenoff_derived: 456.7, fromdate: ~D[2011-05-18], installment: 456.7, interest_amount: 456.7, interest_completed_derived: 456.7, interest_waived_derived: 456.7, interest_writtenoff_derived: 456.7, lastmodifiedby_id: 43, loan_id: 43, obligations_met_on_date: ~D[2011-05-18], penalty_charges_amount: 456.7, penalty_charges_completed_derived: 456.7, penalty_charges_waived_derived: 456.7, penalty_charges_writtenoff_derived: 456.7, principal_amount: 456.7, principal_completed_derived: 456.7, principal_writtenoff_derived: 456.7, total_paid_in_advance_derived: 456.7, total_paid_late_derived: 456.7}
    @invalid_attrs %{accrual_fee_charges_derived: nil, accrual_interest_derived: nil, accrual_penalty_charges_derived: nil, completed_derived: nil, createdby_id: nil, duedate: nil, fee_charges_amount: nil, fee_charges_completed_derived: nil, fee_charges_waived_derived: nil, fee_charges_writtenoff_derived: nil, fromdate: nil, installment: nil, interest_amount: nil, interest_completed_derived: nil, interest_waived_derived: nil, interest_writtenoff_derived: nil, lastmodifiedby_id: nil, loan_id: nil, obligations_met_on_date: nil, penalty_charges_amount: nil, penalty_charges_completed_derived: nil, penalty_charges_waived_derived: nil, penalty_charges_writtenoff_derived: nil, principal_amount: nil, principal_completed_derived: nil, principal_writtenoff_derived: nil, total_paid_in_advance_derived: nil, total_paid_late_derived: nil}

    def loan_repayment_schedule_fixture(attrs \\ %{}) do
      {:ok, loan_repayment_schedule} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_repayment_schedule()

      loan_repayment_schedule
    end

    test "list_tbl_loan_repayment_schedule/0 returns all tbl_loan_repayment_schedule" do
      loan_repayment_schedule = loan_repayment_schedule_fixture()
      assert Loan.list_tbl_loan_repayment_schedule() == [loan_repayment_schedule]
    end

    test "get_loan_repayment_schedule!/1 returns the loan_repayment_schedule with given id" do
      loan_repayment_schedule = loan_repayment_schedule_fixture()
      assert Loan.get_loan_repayment_schedule!(loan_repayment_schedule.id) == loan_repayment_schedule
    end

    test "create_loan_repayment_schedule/1 with valid data creates a loan_repayment_schedule" do
      assert {:ok, %LoanRepaymentSchedule{} = loan_repayment_schedule} = Loan.create_loan_repayment_schedule(@valid_attrs)
      assert loan_repayment_schedule.accrual_fee_charges_derived == 120.5
      assert loan_repayment_schedule.accrual_interest_derived == 120.5
      assert loan_repayment_schedule.accrual_penalty_charges_derived == 120.5
      assert loan_repayment_schedule.completed_derived == 120.5
      assert loan_repayment_schedule.createdby_id == 42
      assert loan_repayment_schedule.duedate == ~D[2010-04-17]
      assert loan_repayment_schedule.fee_charges_amount == 120.5
      assert loan_repayment_schedule.fee_charges_completed_derived == 120.5
      assert loan_repayment_schedule.fee_charges_waived_derived == 120.5
      assert loan_repayment_schedule.fee_charges_writtenoff_derived == 120.5
      assert loan_repayment_schedule.fromdate == ~D[2010-04-17]
      assert loan_repayment_schedule.installment == 120.5
      assert loan_repayment_schedule.interest_amount == 120.5
      assert loan_repayment_schedule.interest_completed_derived == 120.5
      assert loan_repayment_schedule.interest_waived_derived == 120.5
      assert loan_repayment_schedule.interest_writtenoff_derived == 120.5
      assert loan_repayment_schedule.lastmodifiedby_id == 42
      assert loan_repayment_schedule.loan_id == 42
      assert loan_repayment_schedule.obligations_met_on_date == ~D[2010-04-17]
      assert loan_repayment_schedule.penalty_charges_amount == 120.5
      assert loan_repayment_schedule.penalty_charges_completed_derived == 120.5
      assert loan_repayment_schedule.penalty_charges_waived_derived == 120.5
      assert loan_repayment_schedule.penalty_charges_writtenoff_derived == 120.5
      assert loan_repayment_schedule.principal_amount == 120.5
      assert loan_repayment_schedule.principal_completed_derived == 120.5
      assert loan_repayment_schedule.principal_writtenoff_derived == 120.5
      assert loan_repayment_schedule.total_paid_in_advance_derived == 120.5
      assert loan_repayment_schedule.total_paid_late_derived == 120.5
    end

    test "create_loan_repayment_schedule/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_repayment_schedule(@invalid_attrs)
    end

    test "update_loan_repayment_schedule/2 with valid data updates the loan_repayment_schedule" do
      loan_repayment_schedule = loan_repayment_schedule_fixture()
      assert {:ok, %LoanRepaymentSchedule{} = loan_repayment_schedule} = Loan.update_loan_repayment_schedule(loan_repayment_schedule, @update_attrs)
      assert loan_repayment_schedule.accrual_fee_charges_derived == 456.7
      assert loan_repayment_schedule.accrual_interest_derived == 456.7
      assert loan_repayment_schedule.accrual_penalty_charges_derived == 456.7
      assert loan_repayment_schedule.completed_derived == 456.7
      assert loan_repayment_schedule.createdby_id == 43
      assert loan_repayment_schedule.duedate == ~D[2011-05-18]
      assert loan_repayment_schedule.fee_charges_amount == 456.7
      assert loan_repayment_schedule.fee_charges_completed_derived == 456.7
      assert loan_repayment_schedule.fee_charges_waived_derived == 456.7
      assert loan_repayment_schedule.fee_charges_writtenoff_derived == 456.7
      assert loan_repayment_schedule.fromdate == ~D[2011-05-18]
      assert loan_repayment_schedule.installment == 456.7
      assert loan_repayment_schedule.interest_amount == 456.7
      assert loan_repayment_schedule.interest_completed_derived == 456.7
      assert loan_repayment_schedule.interest_waived_derived == 456.7
      assert loan_repayment_schedule.interest_writtenoff_derived == 456.7
      assert loan_repayment_schedule.lastmodifiedby_id == 43
      assert loan_repayment_schedule.loan_id == 43
      assert loan_repayment_schedule.obligations_met_on_date == ~D[2011-05-18]
      assert loan_repayment_schedule.penalty_charges_amount == 456.7
      assert loan_repayment_schedule.penalty_charges_completed_derived == 456.7
      assert loan_repayment_schedule.penalty_charges_waived_derived == 456.7
      assert loan_repayment_schedule.penalty_charges_writtenoff_derived == 456.7
      assert loan_repayment_schedule.principal_amount == 456.7
      assert loan_repayment_schedule.principal_completed_derived == 456.7
      assert loan_repayment_schedule.principal_writtenoff_derived == 456.7
      assert loan_repayment_schedule.total_paid_in_advance_derived == 456.7
      assert loan_repayment_schedule.total_paid_late_derived == 456.7
    end

    test "update_loan_repayment_schedule/2 with invalid data returns error changeset" do
      loan_repayment_schedule = loan_repayment_schedule_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_repayment_schedule(loan_repayment_schedule, @invalid_attrs)
      assert loan_repayment_schedule == Loan.get_loan_repayment_schedule!(loan_repayment_schedule.id)
    end

    test "delete_loan_repayment_schedule/1 deletes the loan_repayment_schedule" do
      loan_repayment_schedule = loan_repayment_schedule_fixture()
      assert {:ok, %LoanRepaymentSchedule{}} = Loan.delete_loan_repayment_schedule(loan_repayment_schedule)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_repayment_schedule!(loan_repayment_schedule.id) end
    end

    test "change_loan_repayment_schedule/1 returns a loan_repayment_schedule changeset" do
      loan_repayment_schedule = loan_repayment_schedule_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_repayment_schedule(loan_repayment_schedule)
    end
  end

  describe "tbl_loans" do
    alias LoanSavingsSystem.Loan.Loans

    @valid_attrs %{rejectedon_userid: 42, disbursedon_date: ~D[2010-04-17], approved_principal: 120.5, principal_outstanding_derived: 120.5, total_waived_derived: 120.5, withdrawnon_date: ~D[2010-04-17], total_overpaid_derived: 120.5, total_repayment_derived: 120.5, interest_repaid_derived: 120.5, principal_disbursed_derived: 120.5, total_expected_costofloan_derived: 120.5, fee_charges_outstanding_derived: 120.5, product_id: "some product_id", writtenoffon_date: ~D[2010-04-17], "": "some ", total_costofloan_derived: 120.5, fee_charges_waived_derived: 120.5, rejectedon_date: ~D[2010-04-17], penalty_charges_outstanding_derived: 120.5, repay_every_type: ~D[2010-04-17], withdrawnon_userid: 42, penalty_charges_charged_derived: 120.5, total_expected_repayment_derived: 120.5, penalty_charges_writtenoff_derived: 120.5, term_frequency: 42, loan_status: "some loan_status", total_outstanding_derived: 120.5, penalty_charges_repaid_derived: 120.5, penalty_charges_waived_derived: 120.5, principal_amount: 120.5, principal_repaid_derived: 120.5, number_of_repayments: 42, term_frequency_type: "some term_frequency_type", closedon_userid: 42, loan_type: "some loan_type", interest_outstanding_derived: 120.5, approvedon_date: ~D[2010-04-17], is_legacyloan: true, total_writtenoff_derived: 120.5, interest_writtenoff_derived: 120.5, disbursedon_userid: 42, fee_charges_writtenoff_derived: 120.5, interest_charged_derived: 120.5, is_npa: true, approvedon_userid: 42, account_no: "some account_no", expected_disbursedon_date: ~D[2010-04-17], annual_nominal_interest_rate: 120.5, external_id: "some external_id", interest_method: "some interest_method", ...}
    @update_attrs %{rejectedon_userid: 43, disbursedon_date: ~D[2011-05-18], approved_principal: 456.7, principal_outstanding_derived: 456.7, total_waived_derived: 456.7, withdrawnon_date: ~D[2011-05-18], total_overpaid_derived: 456.7, total_repayment_derived: 456.7, interest_repaid_derived: 456.7, principal_disbursed_derived: 456.7, total_expected_costofloan_derived: 456.7, fee_charges_outstanding_derived: 456.7, product_id: "some updated product_id", writtenoffon_date: ~D[2011-05-18], "": "some updated ", total_costofloan_derived: 456.7, fee_charges_waived_derived: 456.7, rejectedon_date: ~D[2011-05-18], penalty_charges_outstanding_derived: 456.7, repay_every_type: ~D[2011-05-18], withdrawnon_userid: 43, penalty_charges_charged_derived: 456.7, total_expected_repayment_derived: 456.7, penalty_charges_writtenoff_derived: 456.7, term_frequency: 43, loan_status: "some updated loan_status", total_outstanding_derived: 456.7, penalty_charges_repaid_derived: 456.7, penalty_charges_waived_derived: 456.7, principal_amount: 456.7, principal_repaid_derived: 456.7, number_of_repayments: 43, term_frequency_type: "some updated term_frequency_type", closedon_userid: 43, loan_type: "some updated loan_type", interest_outstanding_derived: 456.7, approvedon_date: ~D[2011-05-18], is_legacyloan: false, total_writtenoff_derived: 456.7, interest_writtenoff_derived: 456.7, disbursedon_userid: 43, fee_charges_writtenoff_derived: 456.7, interest_charged_derived: 456.7, is_npa: false, approvedon_userid: 43, account_no: "some updated account_no", expected_disbursedon_date: ~D[2011-05-18], annual_nominal_interest_rate: 456.7, external_id: "some updated external_id", interest_method: "some updated interest_method", ...}
    @invalid_attrs %{rejectedon_userid: nil, disbursedon_date: nil, approved_principal: nil, principal_outstanding_derived: nil, total_waived_derived: nil, withdrawnon_date: nil, total_overpaid_derived: nil, total_repayment_derived: nil, interest_repaid_derived: nil, principal_disbursed_derived: nil, total_expected_costofloan_derived: nil, fee_charges_outstanding_derived: nil, product_id: nil, writtenoffon_date: nil, "": nil, total_costofloan_derived: nil, fee_charges_waived_derived: nil, rejectedon_date: nil, penalty_charges_outstanding_derived: nil, repay_every_type: nil, withdrawnon_userid: nil, penalty_charges_charged_derived: nil, total_expected_repayment_derived: nil, penalty_charges_writtenoff_derived: nil, term_frequency: nil, loan_status: nil, total_outstanding_derived: nil, penalty_charges_repaid_derived: nil, penalty_charges_waived_derived: nil, principal_amount: nil, principal_repaid_derived: nil, number_of_repayments: nil, term_frequency_type: nil, closedon_userid: nil, loan_type: nil, interest_outstanding_derived: nil, approvedon_date: nil, is_legacyloan: nil, total_writtenoff_derived: nil, interest_writtenoff_derived: nil, disbursedon_userid: nil, fee_charges_writtenoff_derived: nil, interest_charged_derived: nil, is_npa: nil, approvedon_userid: nil, account_no: nil, expected_disbursedon_date: nil, annual_nominal_interest_rate: nil, external_id: nil, interest_method: nil, ...}

    def loans_fixture(attrs \\ %{}) do
      {:ok, loans} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loans()

      loans
    end

    test "list_tbl_loans/0 returns all tbl_loans" do
      loans = loans_fixture()
      assert Loan.list_tbl_loans() == [loans]
    end

    test "get_loans!/1 returns the loans with given id" do
      loans = loans_fixture()
      assert Loan.get_loans!(loans.id) == loans
    end

    test "create_loans/1 with valid data creates a loans" do
      assert {:ok, %Loans{} = loans} = Loan.create_loans(@valid_attrs)
      assert loans.fee_charges_charged_derived == 120.5
      assert loans.closedon_date == ~D[2010-04-17]
      assert loans.repay_every == 42
      assert loans.interest_calculated_from_date == ~D[2010-04-17]
      assert loans.fee_charges_repaid_derived == 120.5
      assert loans.principal_amount_proposed == 120.5
      assert loans.principal_writtenoff_derived == 120.5
      assert loans.total_charges_due_at_disbursement_derived == 120.5
      assert loans.currency_code == "some currency_code"
      assert loans.customer_id == 42
      assert loans.loan_counter == 42
      assert loans.expected_maturity_date == ~D[2010-04-17]
      assert loans.interest_waived_derived == 120.5
      assert loans.interest_method == "some interest_method"
      assert loans.external_id == "some external_id"
      assert loans.annual_nominal_interest_rate == 120.5
      assert loans.expected_disbursedon_date == ~D[2010-04-17]
      assert loans.account_no == "some account_no"
      assert loans.approvedon_userid == 42
      assert loans.is_npa == true
      assert loans.interest_charged_derived == 120.5
      assert loans.fee_charges_writtenoff_derived == 120.5
      assert loans.disbursedon_userid == 42
      assert loans.interest_writtenoff_derived == 120.5
      assert loans.total_writtenoff_derived == 120.5
      assert loans.is_legacyloan == true
      assert loans.approvedon_date == ~D[2010-04-17]
      assert loans.interest_outstanding_derived == 120.5
      assert loans.loan_type == "some loan_type"
      assert loans.closedon_userid == 42
      assert loans.term_frequency_type == "some term_frequency_type"
      assert loans.number_of_repayments == 42
      assert loans.principal_repaid_derived == 120.5
      assert loans.principal_amount == 120.5
      assert loans.penalty_charges_waived_derived == 120.5
      assert loans.penalty_charges_repaid_derived == 120.5
      assert loans.total_outstanding_derived == 120.5
      assert loans.loan_status == "some loan_status"
      assert loans.term_frequency == 42
      assert loans.penalty_charges_writtenoff_derived == 120.5
      assert loans.total_expected_repayment_derived == 120.5
      assert loans.penalty_charges_charged_derived == 120.5
      assert loans.withdrawnon_userid == 42
      assert loans.repay_every_type == ~D[2010-04-17]
      assert loans.penalty_charges_outstanding_derived == 120.5
      assert loans.rejectedon_date == ~D[2010-04-17]
      assert loans.fee_charges_waived_derived == 120.5
      assert loans.total_costofloan_derived == 120.5
      assert loans. == "some "
      assert loans.writtenoffon_date == ~D[2010-04-17]
      assert loans.product_id == "some product_id"
      assert loans.fee_charges_outstanding_derived == 120.5
      assert loans.total_expected_costofloan_derived == 120.5
      assert loans.principal_disbursed_derived == 120.5
      assert loans.interest_repaid_derived == 120.5
      assert loans.total_repayment_derived == 120.5
      assert loans.total_overpaid_derived == 120.5
      assert loans.withdrawnon_date == ~D[2010-04-17]
      assert loans.total_waived_derived == 120.5
      assert loans.principal_outstanding_derived == 120.5
      assert loans.approved_principal == 120.5
      assert loans.disbursedon_date == ~D[2010-04-17]
      assert loans.rejectedon_userid == 42
    end

    test "create_loans/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loans(@invalid_attrs)
    end

    test "update_loans/2 with valid data updates the loans" do
      loans = loans_fixture()
      assert {:ok, %Loans{} = loans} = Loan.update_loans(loans, @update_attrs)
      assert loans.fee_charges_charged_derived == 456.7
      assert loans.closedon_date == ~D[2011-05-18]
      assert loans.repay_every == 43
      assert loans.interest_calculated_from_date == ~D[2011-05-18]
      assert loans.fee_charges_repaid_derived == 456.7
      assert loans.principal_amount_proposed == 456.7
      assert loans.principal_writtenoff_derived == 456.7
      assert loans.total_charges_due_at_disbursement_derived == 456.7
      assert loans.currency_code == "some updated currency_code"
      assert loans.customer_id == 43
      assert loans.loan_counter == 43
      assert loans.expected_maturity_date == ~D[2011-05-18]
      assert loans.interest_waived_derived == 456.7
      assert loans.interest_method == "some updated interest_method"
      assert loans.external_id == "some updated external_id"
      assert loans.annual_nominal_interest_rate == 456.7
      assert loans.expected_disbursedon_date == ~D[2011-05-18]
      assert loans.account_no == "some updated account_no"
      assert loans.approvedon_userid == 43
      assert loans.is_npa == false
      assert loans.interest_charged_derived == 456.7
      assert loans.fee_charges_writtenoff_derived == 456.7
      assert loans.disbursedon_userid == 43
      assert loans.interest_writtenoff_derived == 456.7
      assert loans.total_writtenoff_derived == 456.7
      assert loans.is_legacyloan == false
      assert loans.approvedon_date == ~D[2011-05-18]
      assert loans.interest_outstanding_derived == 456.7
      assert loans.loan_type == "some updated loan_type"
      assert loans.closedon_userid == 43
      assert loans.term_frequency_type == "some updated term_frequency_type"
      assert loans.number_of_repayments == 43
      assert loans.principal_repaid_derived == 456.7
      assert loans.principal_amount == 456.7
      assert loans.penalty_charges_waived_derived == 456.7
      assert loans.penalty_charges_repaid_derived == 456.7
      assert loans.total_outstanding_derived == 456.7
      assert loans.loan_status == "some updated loan_status"
      assert loans.term_frequency == 43
      assert loans.penalty_charges_writtenoff_derived == 456.7
      assert loans.total_expected_repayment_derived == 456.7
      assert loans.penalty_charges_charged_derived == 456.7
      assert loans.withdrawnon_userid == 43
      assert loans.repay_every_type == ~D[2011-05-18]
      assert loans.penalty_charges_outstanding_derived == 456.7
      assert loans.rejectedon_date == ~D[2011-05-18]
      assert loans.fee_charges_waived_derived == 456.7
      assert loans.total_costofloan_derived == 456.7
      assert loans. == "some updated "
      assert loans.writtenoffon_date == ~D[2011-05-18]
      assert loans.product_id == "some updated product_id"
      assert loans.fee_charges_outstanding_derived == 456.7
      assert loans.total_expected_costofloan_derived == 456.7
      assert loans.principal_disbursed_derived == 456.7
      assert loans.interest_repaid_derived == 456.7
      assert loans.total_repayment_derived == 456.7
      assert loans.total_overpaid_derived == 456.7
      assert loans.withdrawnon_date == ~D[2011-05-18]
      assert loans.total_waived_derived == 456.7
      assert loans.principal_outstanding_derived == 456.7
      assert loans.approved_principal == 456.7
      assert loans.disbursedon_date == ~D[2011-05-18]
      assert loans.rejectedon_userid == 43
    end

    test "update_loans/2 with invalid data returns error changeset" do
      loans = loans_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loans(loans, @invalid_attrs)
      assert loans == Loan.get_loans!(loans.id)
    end

    test "delete_loans/1 deletes the loans" do
      loans = loans_fixture()
      assert {:ok, %Loans{}} = Loan.delete_loans(loans)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loans!(loans.id) end
    end

    test "change_loans/1 returns a loans changeset" do
      loans = loans_fixture()
      assert %Ecto.Changeset{} = Loan.change_loans(loans)
    end
  end

  describe "tbl_loan_transaction" do
    alias LoanSavingsSystem.Loan.LoanTransaction

    @valid_attrs %{amount: 120.5, branch_id: 42, external_id: "some external_id", fee_charges_portion_derived: 120.5, interest_portion_derived: 120.5, is_reversed: true, loan_id: 42, manually_adjusted_or_reversed: true, manually_created_by_userid: 42, outstanding_loan_balance_derived: 120.5, overpayment_portion_derived: 120.5, payment_detail_id: 42, penalty_charges_portion_derived: 120.5, principal_portion_derived: 120.5, submitted_on_date: ~D[2010-04-17], transaction_date: ~D[2010-04-17], transaction_type_enum: "some transaction_type_enum", unrecognized_income_portion: 120.5}
    @update_attrs %{amount: 456.7, branch_id: 43, external_id: "some updated external_id", fee_charges_portion_derived: 456.7, interest_portion_derived: 456.7, is_reversed: false, loan_id: 43, manually_adjusted_or_reversed: false, manually_created_by_userid: 43, outstanding_loan_balance_derived: 456.7, overpayment_portion_derived: 456.7, payment_detail_id: 43, penalty_charges_portion_derived: 456.7, principal_portion_derived: 456.7, submitted_on_date: ~D[2011-05-18], transaction_date: ~D[2011-05-18], transaction_type_enum: "some updated transaction_type_enum", unrecognized_income_portion: 456.7}
    @invalid_attrs %{amount: nil, branch_id: nil, external_id: nil, fee_charges_portion_derived: nil, interest_portion_derived: nil, is_reversed: nil, loan_id: nil, manually_adjusted_or_reversed: nil, manually_created_by_userid: nil, outstanding_loan_balance_derived: nil, overpayment_portion_derived: nil, payment_detail_id: nil, penalty_charges_portion_derived: nil, principal_portion_derived: nil, submitted_on_date: nil, transaction_date: nil, transaction_type_enum: nil, unrecognized_income_portion: nil}

    def loan_transaction_fixture(attrs \\ %{}) do
      {:ok, loan_transaction} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_transaction()

      loan_transaction
    end

    test "list_tbl_loan_transaction/0 returns all tbl_loan_transaction" do
      loan_transaction = loan_transaction_fixture()
      assert Loan.list_tbl_loan_transaction() == [loan_transaction]
    end

    test "get_loan_transaction!/1 returns the loan_transaction with given id" do
      loan_transaction = loan_transaction_fixture()
      assert Loan.get_loan_transaction!(loan_transaction.id) == loan_transaction
    end

    test "create_loan_transaction/1 with valid data creates a loan_transaction" do
      assert {:ok, %LoanTransaction{} = loan_transaction} = Loan.create_loan_transaction(@valid_attrs)
      assert loan_transaction.amount == 120.5
      assert loan_transaction.branch_id == 42
      assert loan_transaction.external_id == "some external_id"
      assert loan_transaction.fee_charges_portion_derived == 120.5
      assert loan_transaction.interest_portion_derived == 120.5
      assert loan_transaction.is_reversed == true
      assert loan_transaction.loan_id == 42
      assert loan_transaction.manually_adjusted_or_reversed == true
      assert loan_transaction.manually_created_by_userid == 42
      assert loan_transaction.outstanding_loan_balance_derived == 120.5
      assert loan_transaction.overpayment_portion_derived == 120.5
      assert loan_transaction.payment_detail_id == 42
      assert loan_transaction.penalty_charges_portion_derived == 120.5
      assert loan_transaction.principal_portion_derived == 120.5
      assert loan_transaction.submitted_on_date == ~D[2010-04-17]
      assert loan_transaction.transaction_date == ~D[2010-04-17]
      assert loan_transaction.transaction_type_enum == "some transaction_type_enum"
      assert loan_transaction.unrecognized_income_portion == 120.5
    end

    test "create_loan_transaction/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_transaction(@invalid_attrs)
    end

    test "update_loan_transaction/2 with valid data updates the loan_transaction" do
      loan_transaction = loan_transaction_fixture()
      assert {:ok, %LoanTransaction{} = loan_transaction} = Loan.update_loan_transaction(loan_transaction, @update_attrs)
      assert loan_transaction.amount == 456.7
      assert loan_transaction.branch_id == 43
      assert loan_transaction.external_id == "some updated external_id"
      assert loan_transaction.fee_charges_portion_derived == 456.7
      assert loan_transaction.interest_portion_derived == 456.7
      assert loan_transaction.is_reversed == false
      assert loan_transaction.loan_id == 43
      assert loan_transaction.manually_adjusted_or_reversed == false
      assert loan_transaction.manually_created_by_userid == 43
      assert loan_transaction.outstanding_loan_balance_derived == 456.7
      assert loan_transaction.overpayment_portion_derived == 456.7
      assert loan_transaction.payment_detail_id == 43
      assert loan_transaction.penalty_charges_portion_derived == 456.7
      assert loan_transaction.principal_portion_derived == 456.7
      assert loan_transaction.submitted_on_date == ~D[2011-05-18]
      assert loan_transaction.transaction_date == ~D[2011-05-18]
      assert loan_transaction.transaction_type_enum == "some updated transaction_type_enum"
      assert loan_transaction.unrecognized_income_portion == 456.7
    end

    test "update_loan_transaction/2 with invalid data returns error changeset" do
      loan_transaction = loan_transaction_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_transaction(loan_transaction, @invalid_attrs)
      assert loan_transaction == Loan.get_loan_transaction!(loan_transaction.id)
    end

    test "delete_loan_transaction/1 deletes the loan_transaction" do
      loan_transaction = loan_transaction_fixture()
      assert {:ok, %LoanTransaction{}} = Loan.delete_loan_transaction(loan_transaction)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_transaction!(loan_transaction.id) end
    end

    test "change_loan_transaction/1 returns a loan_transaction changeset" do
      loan_transaction = loan_transaction_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_transaction(loan_transaction)
    end
  end

  describe "tbl_loan_transaction_repayment_schedule_mapping" do
    alias LoanSavingsSystem.Loan.LoanTransactionRepaymentScheduleMapping

    @valid_attrs %{amount: 120.5, fee_charges_portion_derived: 120.5, interest_portion_derived: 120.5, loan_repayment_schedule_id: 42, loan_transaction_id: 42, penalty_charges_portion_derived: 120.5, principal_portion_derived: 120.5}
    @update_attrs %{amount: 456.7, fee_charges_portion_derived: 456.7, interest_portion_derived: 456.7, loan_repayment_schedule_id: 43, loan_transaction_id: 43, penalty_charges_portion_derived: 456.7, principal_portion_derived: 456.7}
    @invalid_attrs %{amount: nil, fee_charges_portion_derived: nil, interest_portion_derived: nil, loan_repayment_schedule_id: nil, loan_transaction_id: nil, penalty_charges_portion_derived: nil, principal_portion_derived: nil}

    def loan_transaction_repayment_schedule_mapping_fixture(attrs \\ %{}) do
      {:ok, loan_transaction_repayment_schedule_mapping} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_transaction_repayment_schedule_mapping()

      loan_transaction_repayment_schedule_mapping
    end

    test "list_tbl_loan_transaction_repayment_schedule_mapping/0 returns all tbl_loan_transaction_repayment_schedule_mapping" do
      loan_transaction_repayment_schedule_mapping = loan_transaction_repayment_schedule_mapping_fixture()
      assert Loan.list_tbl_loan_transaction_repayment_schedule_mapping() == [loan_transaction_repayment_schedule_mapping]
    end

    test "get_loan_transaction_repayment_schedule_mapping!/1 returns the loan_transaction_repayment_schedule_mapping with given id" do
      loan_transaction_repayment_schedule_mapping = loan_transaction_repayment_schedule_mapping_fixture()
      assert Loan.get_loan_transaction_repayment_schedule_mapping!(loan_transaction_repayment_schedule_mapping.id) == loan_transaction_repayment_schedule_mapping
    end

    test "create_loan_transaction_repayment_schedule_mapping/1 with valid data creates a loan_transaction_repayment_schedule_mapping" do
      assert {:ok, %LoanTransactionRepaymentScheduleMapping{} = loan_transaction_repayment_schedule_mapping} = Loan.create_loan_transaction_repayment_schedule_mapping(@valid_attrs)
      assert loan_transaction_repayment_schedule_mapping.amount == 120.5
      assert loan_transaction_repayment_schedule_mapping.fee_charges_portion_derived == 120.5
      assert loan_transaction_repayment_schedule_mapping.interest_portion_derived == 120.5
      assert loan_transaction_repayment_schedule_mapping.loan_repayment_schedule_id == 42
      assert loan_transaction_repayment_schedule_mapping.loan_transaction_id == 42
      assert loan_transaction_repayment_schedule_mapping.penalty_charges_portion_derived == 120.5
      assert loan_transaction_repayment_schedule_mapping.principal_portion_derived == 120.5
    end

    test "create_loan_transaction_repayment_schedule_mapping/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_transaction_repayment_schedule_mapping(@invalid_attrs)
    end

    test "update_loan_transaction_repayment_schedule_mapping/2 with valid data updates the loan_transaction_repayment_schedule_mapping" do
      loan_transaction_repayment_schedule_mapping = loan_transaction_repayment_schedule_mapping_fixture()
      assert {:ok, %LoanTransactionRepaymentScheduleMapping{} = loan_transaction_repayment_schedule_mapping} = Loan.update_loan_transaction_repayment_schedule_mapping(loan_transaction_repayment_schedule_mapping, @update_attrs)
      assert loan_transaction_repayment_schedule_mapping.amount == 456.7
      assert loan_transaction_repayment_schedule_mapping.fee_charges_portion_derived == 456.7
      assert loan_transaction_repayment_schedule_mapping.interest_portion_derived == 456.7
      assert loan_transaction_repayment_schedule_mapping.loan_repayment_schedule_id == 43
      assert loan_transaction_repayment_schedule_mapping.loan_transaction_id == 43
      assert loan_transaction_repayment_schedule_mapping.penalty_charges_portion_derived == 456.7
      assert loan_transaction_repayment_schedule_mapping.principal_portion_derived == 456.7
    end

    test "update_loan_transaction_repayment_schedule_mapping/2 with invalid data returns error changeset" do
      loan_transaction_repayment_schedule_mapping = loan_transaction_repayment_schedule_mapping_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_transaction_repayment_schedule_mapping(loan_transaction_repayment_schedule_mapping, @invalid_attrs)
      assert loan_transaction_repayment_schedule_mapping == Loan.get_loan_transaction_repayment_schedule_mapping!(loan_transaction_repayment_schedule_mapping.id)
    end

    test "delete_loan_transaction_repayment_schedule_mapping/1 deletes the loan_transaction_repayment_schedule_mapping" do
      loan_transaction_repayment_schedule_mapping = loan_transaction_repayment_schedule_mapping_fixture()
      assert {:ok, %LoanTransactionRepaymentScheduleMapping{}} = Loan.delete_loan_transaction_repayment_schedule_mapping(loan_transaction_repayment_schedule_mapping)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_transaction_repayment_schedule_mapping!(loan_transaction_repayment_schedule_mapping.id) end
    end

    test "change_loan_transaction_repayment_schedule_mapping/1 returns a loan_transaction_repayment_schedule_mapping changeset" do
      loan_transaction_repayment_schedule_mapping = loan_transaction_repayment_schedule_mapping_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_transaction_repayment_schedule_mapping(loan_transaction_repayment_schedule_mapping)
    end
  end

  describe "tbl_loan_product_charges" do
    alias LoanSavingsSystem.Loan.LoanProductCharges

    @valid_attrs %{charge_id: 42, loan_product_id: 42}
    @update_attrs %{charge_id: 43, loan_product_id: 43}
    @invalid_attrs %{charge_id: nil, loan_product_id: nil}

    def loan_product_charges_fixture(attrs \\ %{}) do
      {:ok, loan_product_charges} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_product_charges()

      loan_product_charges
    end

    test "list_tbl_loan_product_charges/0 returns all tbl_loan_product_charges" do
      loan_product_charges = loan_product_charges_fixture()
      assert Loan.list_tbl_loan_product_charges() == [loan_product_charges]
    end

    test "get_loan_product_charges!/1 returns the loan_product_charges with given id" do
      loan_product_charges = loan_product_charges_fixture()
      assert Loan.get_loan_product_charges!(loan_product_charges.id) == loan_product_charges
    end

    test "create_loan_product_charges/1 with valid data creates a loan_product_charges" do
      assert {:ok, %LoanProductCharges{} = loan_product_charges} = Loan.create_loan_product_charges(@valid_attrs)
      assert loan_product_charges.charge_id == 42
      assert loan_product_charges.loan_product_id == 42
    end

    test "create_loan_product_charges/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_product_charges(@invalid_attrs)
    end

    test "update_loan_product_charges/2 with valid data updates the loan_product_charges" do
      loan_product_charges = loan_product_charges_fixture()
      assert {:ok, %LoanProductCharges{} = loan_product_charges} = Loan.update_loan_product_charges(loan_product_charges, @update_attrs)
      assert loan_product_charges.charge_id == 43
      assert loan_product_charges.loan_product_id == 43
    end

    test "update_loan_product_charges/2 with invalid data returns error changeset" do
      loan_product_charges = loan_product_charges_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_product_charges(loan_product_charges, @invalid_attrs)
      assert loan_product_charges == Loan.get_loan_product_charges!(loan_product_charges.id)
    end

    test "delete_loan_product_charges/1 deletes the loan_product_charges" do
      loan_product_charges = loan_product_charges_fixture()
      assert {:ok, %LoanProductCharges{}} = Loan.delete_loan_product_charges(loan_product_charges)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_product_charges!(loan_product_charges.id) end
    end

    test "change_loan_product_charges/1 returns a loan_product_charges changeset" do
      loan_product_charges = loan_product_charges_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_product_charges(loan_product_charges)
    end
  end

  describe "tbl_loan_product_document_type" do
    alias LoanSavingsSystem.Loan.LoanProductDocumentType

    @valid_attrs %{documentTypeId: 42, isRequired: true, productId: 42}
    @update_attrs %{documentTypeId: 43, isRequired: false, productId: 43}
    @invalid_attrs %{documentTypeId: nil, isRequired: nil, productId: nil}

    def loan_product_document_type_fixture(attrs \\ %{}) do
      {:ok, loan_product_document_type} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Loan.create_loan_product_document_type()

      loan_product_document_type
    end

    test "list_tbl_loan_product_document_type/0 returns all tbl_loan_product_document_type" do
      loan_product_document_type = loan_product_document_type_fixture()
      assert Loan.list_tbl_loan_product_document_type() == [loan_product_document_type]
    end

    test "get_loan_product_document_type!/1 returns the loan_product_document_type with given id" do
      loan_product_document_type = loan_product_document_type_fixture()
      assert Loan.get_loan_product_document_type!(loan_product_document_type.id) == loan_product_document_type
    end

    test "create_loan_product_document_type/1 with valid data creates a loan_product_document_type" do
      assert {:ok, %LoanProductDocumentType{} = loan_product_document_type} = Loan.create_loan_product_document_type(@valid_attrs)
      assert loan_product_document_type.documentTypeId == 42
      assert loan_product_document_type.isRequired == true
      assert loan_product_document_type.productId == 42
    end

    test "create_loan_product_document_type/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loan_product_document_type(@invalid_attrs)
    end

    test "update_loan_product_document_type/2 with valid data updates the loan_product_document_type" do
      loan_product_document_type = loan_product_document_type_fixture()
      assert {:ok, %LoanProductDocumentType{} = loan_product_document_type} = Loan.update_loan_product_document_type(loan_product_document_type, @update_attrs)
      assert loan_product_document_type.documentTypeId == 43
      assert loan_product_document_type.isRequired == false
      assert loan_product_document_type.productId == 43
    end

    test "update_loan_product_document_type/2 with invalid data returns error changeset" do
      loan_product_document_type = loan_product_document_type_fixture()
      assert {:error, %Ecto.Changeset{}} = Loan.update_loan_product_document_type(loan_product_document_type, @invalid_attrs)
      assert loan_product_document_type == Loan.get_loan_product_document_type!(loan_product_document_type.id)
    end

    test "delete_loan_product_document_type/1 deletes the loan_product_document_type" do
      loan_product_document_type = loan_product_document_type_fixture()
      assert {:ok, %LoanProductDocumentType{}} = Loan.delete_loan_product_document_type(loan_product_document_type)
      assert_raise Ecto.NoResultsError, fn -> Loan.get_loan_product_document_type!(loan_product_document_type.id) end
    end

    test "change_loan_product_document_type/1 returns a loan_product_document_type changeset" do
      loan_product_document_type = loan_product_document_type_fixture()
      assert %Ecto.Changeset{} = Loan.change_loan_product_document_type(loan_product_document_type)
    end
  end

  describe "tbl_loan_repayment" do
    alias LoanSavingsSystem.Loan.LoanRepayment

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
