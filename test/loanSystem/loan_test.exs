defmodule LoanSystem.LoanTest do
  use LoanSystem.DataCase

  alias LoanSystem.Loan

  describe "tbl_loan_charge" do
    alias LoanSystem.Loan.LoanCharge

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
    alias LoanSystem.Loan.LoanChargePayment

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
    alias LoanSystem.Loan.LoanCollateral

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
    alias LoanSystem.Loan.LoanInstallmentCharge

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
    alias LoanSystem.Loan.LoanOfficerAssignment

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
    alias LoanSystem.Loan.LoanOverdueInstallmentCharge

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
    alias LoanSystem.Loan.LoanPaidInAdvance

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
    alias LoanSystem.Loan.LoanRepaymentSchedule

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
    alias LoanSystem.Loan.Loans

    @valid_attrs %{total_repayment_derived: 120.5, term_frequency: 42, external_id: "some external_id", expected_maturity_date: ~D[2010-04-17], withdrawnon_userid: 42, penalty_charges_repaid_derived: 120.5, total_expected_costofloan_derived: 120.5, penalty_charges_outstanding_derived: 120.5, fee_charges_writtenoff_derived: 120.5, closedon_date: ~D[2010-04-17], expected_disbursedon_date: ~D[2010-04-17], fee_charges_outstanding_derived: 120.5, rejectedon_date: ~D[2010-04-17], interest_repaid_derived: 120.5, total_waived_derived: 120.5, is_legacyloan: true, "": "some ", penalty_charges_charged_derived: 120.5, principal_outstanding_derived: 120.5, total_expected_repayment_derived: 120.5, fee_charges_repaid_derived: 120.5, principal_amount_proposed: 120.5, total_costofloan_derived: 120.5, interest_waived_derived: 120.5, fee_charges_waived_derived: 120.5, fee_charges_charged_derived: 120.5, loan_status: "some loan_status", penalty_charges_writtenoff_derived: 120.5, interest_writtenoff_derived: 120.5, interest_outstanding_derived: 120.5, account_no: "some account_no", disbursedon_date: ~D[2010-04-17], principal_amount: 120.5, loan_type: "some loan_type", approvedon_date: ~D[2010-04-17], rejectedon_userid: 42, principal_disbursed_derived: 120.5, approved_principal: 120.5, total_overpaid_derived: 120.5, penalty_charges_waived_derived: 120.5, total_charges_due_at_disbursement_derived: 120.5, term_frequency_type: "some term_frequency_type", interest_charged_derived: 120.5, loan_counter: 42, interest_calculated_from_date: ~D[2010-04-17], total_outstanding_derived: 120.5, writtenoffon_date: ~D[2010-04-17], annual_nominal_interest_rate: 120.5, interest_method: "some interest_method", customer_id: 42, ...}
    @update_attrs %{total_repayment_derived: 456.7, term_frequency: 43, external_id: "some updated external_id", expected_maturity_date: ~D[2011-05-18], withdrawnon_userid: 43, penalty_charges_repaid_derived: 456.7, total_expected_costofloan_derived: 456.7, penalty_charges_outstanding_derived: 456.7, fee_charges_writtenoff_derived: 456.7, closedon_date: ~D[2011-05-18], expected_disbursedon_date: ~D[2011-05-18], fee_charges_outstanding_derived: 456.7, rejectedon_date: ~D[2011-05-18], interest_repaid_derived: 456.7, total_waived_derived: 456.7, is_legacyloan: false, "": "some updated ", penalty_charges_charged_derived: 456.7, principal_outstanding_derived: 456.7, total_expected_repayment_derived: 456.7, fee_charges_repaid_derived: 456.7, principal_amount_proposed: 456.7, total_costofloan_derived: 456.7, interest_waived_derived: 456.7, fee_charges_waived_derived: 456.7, fee_charges_charged_derived: 456.7, loan_status: "some updated loan_status", penalty_charges_writtenoff_derived: 456.7, interest_writtenoff_derived: 456.7, interest_outstanding_derived: 456.7, account_no: "some updated account_no", disbursedon_date: ~D[2011-05-18], principal_amount: 456.7, loan_type: "some updated loan_type", approvedon_date: ~D[2011-05-18], rejectedon_userid: 43, principal_disbursed_derived: 456.7, approved_principal: 456.7, total_overpaid_derived: 456.7, penalty_charges_waived_derived: 456.7, total_charges_due_at_disbursement_derived: 456.7, term_frequency_type: "some updated term_frequency_type", interest_charged_derived: 456.7, loan_counter: 43, interest_calculated_from_date: ~D[2011-05-18], total_outstanding_derived: 456.7, writtenoffon_date: ~D[2011-05-18], annual_nominal_interest_rate: 456.7, interest_method: "some updated interest_method", customer_id: 43, ...}
    @invalid_attrs %{total_repayment_derived: nil, term_frequency: nil, external_id: nil, expected_maturity_date: nil, withdrawnon_userid: nil, penalty_charges_repaid_derived: nil, total_expected_costofloan_derived: nil, penalty_charges_outstanding_derived: nil, fee_charges_writtenoff_derived: nil, closedon_date: nil, expected_disbursedon_date: nil, fee_charges_outstanding_derived: nil, rejectedon_date: nil, interest_repaid_derived: nil, total_waived_derived: nil, is_legacyloan: nil, "": nil, penalty_charges_charged_derived: nil, principal_outstanding_derived: nil, total_expected_repayment_derived: nil, fee_charges_repaid_derived: nil, principal_amount_proposed: nil, total_costofloan_derived: nil, interest_waived_derived: nil, fee_charges_waived_derived: nil, fee_charges_charged_derived: nil, loan_status: nil, penalty_charges_writtenoff_derived: nil, interest_writtenoff_derived: nil, interest_outstanding_derived: nil, account_no: nil, disbursedon_date: nil, principal_amount: nil, loan_type: nil, approvedon_date: nil, rejectedon_userid: nil, principal_disbursed_derived: nil, approved_principal: nil, total_overpaid_derived: nil, penalty_charges_waived_derived: nil, total_charges_due_at_disbursement_derived: nil, term_frequency_type: nil, interest_charged_derived: nil, loan_counter: nil, interest_calculated_from_date: nil, total_outstanding_derived: nil, writtenoffon_date: nil, annual_nominal_interest_rate: nil, interest_method: nil, customer_id: nil, ...}

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
      assert loans.principal_repaid_derived == 120.5
      assert loans.number_of_repayments == 42
      assert loans.withdrawnon_date == ~D[2010-04-17]
      assert loans.currency_code == "some currency_code"
      assert loans.is_npa == true
      assert loans.repay_every_type == ~D[2010-04-17]
      assert loans.principal_writtenoff_derived == 120.5
      assert loans.disbursedon_userid == 42
      assert loans.approvedon_userid == 42
      assert loans.total_writtenoff_derived == 120.5
      assert loans.repay_every == 42
      assert loans.closedon_userid == 42
      assert loans.product_id == "some product_id"
      assert loans.customer_id == 42
      assert loans.interest_method == "some interest_method"
      assert loans.annual_nominal_interest_rate == 120.5
      assert loans.writtenoffon_date == ~D[2010-04-17]
      assert loans.total_outstanding_derived == 120.5
      assert loans.interest_calculated_from_date == ~D[2010-04-17]
      assert loans.loan_counter == 42
      assert loans.interest_charged_derived == 120.5
      assert loans.term_frequency_type == "some term_frequency_type"
      assert loans.total_charges_due_at_disbursement_derived == 120.5
      assert loans.penalty_charges_waived_derived == 120.5
      assert loans.total_overpaid_derived == 120.5
      assert loans.approved_principal == 120.5
      assert loans.principal_disbursed_derived == 120.5
      assert loans.rejectedon_userid == 42
      assert loans.approvedon_date == ~D[2010-04-17]
      assert loans.loan_type == "some loan_type"
      assert loans.principal_amount == 120.5
      assert loans.disbursedon_date == ~D[2010-04-17]
      assert loans.account_no == "some account_no"
      assert loans.interest_outstanding_derived == 120.5
      assert loans.interest_writtenoff_derived == 120.5
      assert loans.penalty_charges_writtenoff_derived == 120.5
      assert loans.loan_status == "some loan_status"
      assert loans.fee_charges_charged_derived == 120.5
      assert loans.fee_charges_waived_derived == 120.5
      assert loans.interest_waived_derived == 120.5
      assert loans.total_costofloan_derived == 120.5
      assert loans.principal_amount_proposed == 120.5
      assert loans.fee_charges_repaid_derived == 120.5
      assert loans.total_expected_repayment_derived == 120.5
      assert loans.principal_outstanding_derived == 120.5
      assert loans.penalty_charges_charged_derived == 120.5
      assert loans. == "some "
      assert loans.is_legacyloan == true
      assert loans.total_waived_derived == 120.5
      assert loans.interest_repaid_derived == 120.5
      assert loans.rejectedon_date == ~D[2010-04-17]
      assert loans.fee_charges_outstanding_derived == 120.5
      assert loans.expected_disbursedon_date == ~D[2010-04-17]
      assert loans.closedon_date == ~D[2010-04-17]
      assert loans.fee_charges_writtenoff_derived == 120.5
      assert loans.penalty_charges_outstanding_derived == 120.5
      assert loans.total_expected_costofloan_derived == 120.5
      assert loans.penalty_charges_repaid_derived == 120.5
      assert loans.withdrawnon_userid == 42
      assert loans.expected_maturity_date == ~D[2010-04-17]
      assert loans.external_id == "some external_id"
      assert loans.term_frequency == 42
      assert loans.total_repayment_derived == 120.5
    end

    test "create_loans/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Loan.create_loans(@invalid_attrs)
    end

    test "update_loans/2 with valid data updates the loans" do
      loans = loans_fixture()
      assert {:ok, %Loans{} = loans} = Loan.update_loans(loans, @update_attrs)
      assert loans.principal_repaid_derived == 456.7
      assert loans.number_of_repayments == 43
      assert loans.withdrawnon_date == ~D[2011-05-18]
      assert loans.currency_code == "some updated currency_code"
      assert loans.is_npa == false
      assert loans.repay_every_type == ~D[2011-05-18]
      assert loans.principal_writtenoff_derived == 456.7
      assert loans.disbursedon_userid == 43
      assert loans.approvedon_userid == 43
      assert loans.total_writtenoff_derived == 456.7
      assert loans.repay_every == 43
      assert loans.closedon_userid == 43
      assert loans.product_id == "some updated product_id"
      assert loans.customer_id == 43
      assert loans.interest_method == "some updated interest_method"
      assert loans.annual_nominal_interest_rate == 456.7
      assert loans.writtenoffon_date == ~D[2011-05-18]
      assert loans.total_outstanding_derived == 456.7
      assert loans.interest_calculated_from_date == ~D[2011-05-18]
      assert loans.loan_counter == 43
      assert loans.interest_charged_derived == 456.7
      assert loans.term_frequency_type == "some updated term_frequency_type"
      assert loans.total_charges_due_at_disbursement_derived == 456.7
      assert loans.penalty_charges_waived_derived == 456.7
      assert loans.total_overpaid_derived == 456.7
      assert loans.approved_principal == 456.7
      assert loans.principal_disbursed_derived == 456.7
      assert loans.rejectedon_userid == 43
      assert loans.approvedon_date == ~D[2011-05-18]
      assert loans.loan_type == "some updated loan_type"
      assert loans.principal_amount == 456.7
      assert loans.disbursedon_date == ~D[2011-05-18]
      assert loans.account_no == "some updated account_no"
      assert loans.interest_outstanding_derived == 456.7
      assert loans.interest_writtenoff_derived == 456.7
      assert loans.penalty_charges_writtenoff_derived == 456.7
      assert loans.loan_status == "some updated loan_status"
      assert loans.fee_charges_charged_derived == 456.7
      assert loans.fee_charges_waived_derived == 456.7
      assert loans.interest_waived_derived == 456.7
      assert loans.total_costofloan_derived == 456.7
      assert loans.principal_amount_proposed == 456.7
      assert loans.fee_charges_repaid_derived == 456.7
      assert loans.total_expected_repayment_derived == 456.7
      assert loans.principal_outstanding_derived == 456.7
      assert loans.penalty_charges_charged_derived == 456.7
      assert loans. == "some updated "
      assert loans.is_legacyloan == false
      assert loans.total_waived_derived == 456.7
      assert loans.interest_repaid_derived == 456.7
      assert loans.rejectedon_date == ~D[2011-05-18]
      assert loans.fee_charges_outstanding_derived == 456.7
      assert loans.expected_disbursedon_date == ~D[2011-05-18]
      assert loans.closedon_date == ~D[2011-05-18]
      assert loans.fee_charges_writtenoff_derived == 456.7
      assert loans.penalty_charges_outstanding_derived == 456.7
      assert loans.total_expected_costofloan_derived == 456.7
      assert loans.penalty_charges_repaid_derived == 456.7
      assert loans.withdrawnon_userid == 43
      assert loans.expected_maturity_date == ~D[2011-05-18]
      assert loans.external_id == "some updated external_id"
      assert loans.term_frequency == 43
      assert loans.total_repayment_derived == 456.7
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
    alias LoanSystem.Loan.LoanTransaction

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
    alias LoanSystem.Loan.LoanTransactionRepaymentScheduleMapping

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
end
