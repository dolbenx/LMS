defmodule LoanSavingsSystem.Loan do
  @moduledoc """
  The Loan context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Loan.LoanCharge

  @doc """
  Returns the list of tbl_loan_charge.

  ## Examples

      iex> list_tbl_loan_charge()
      [%LoanCharge{}, ...]

  """
  def list_tbl_loan_charge do
    Repo.all(LoanCharge)
  end

  @doc """
  Gets a single loan_charge.

  Raises `Ecto.NoResultsError` if the Loan charge does not exist.

  ## Examples

      iex> get_loan_charge!(123)
      %LoanCharge{}

      iex> get_loan_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_charge!(id), do: Repo.get!(LoanCharge, id)

  @doc """
  Creates a loan_charge.

  ## Examples

      iex> create_loan_charge(%{field: value})
      {:ok, %LoanCharge{}}

      iex> create_loan_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_charge(attrs \\ %{}) do
    %LoanCharge{}
    |> LoanCharge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_charge.

  ## Examples

      iex> update_loan_charge(loan_charge, %{field: new_value})
      {:ok, %LoanCharge{}}

      iex> update_loan_charge(loan_charge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_charge(%LoanCharge{} = loan_charge, attrs) do
    loan_charge
    |> LoanCharge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_charge.

  ## Examples

      iex> delete_loan_charge(loan_charge)
      {:ok, %LoanCharge{}}

      iex> delete_loan_charge(loan_charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_charge(%LoanCharge{} = loan_charge) do
    Repo.delete(loan_charge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_charge changes.

  ## Examples

      iex> change_loan_charge(loan_charge)
      %Ecto.Changeset{source: %LoanCharge{}}

  """
  def change_loan_charge(%LoanCharge{} = loan_charge) do
    LoanCharge.changeset(loan_charge, %{})
  end

  alias LoanSavingsSystem.Loan.LoanChargePayment

  @doc """
  Returns the list of tbl_loan_charge_payment.

  ## Examples

      iex> list_tbl_loan_charge_payment()
      [%LoanChargePayment{}, ...]

  """
  def list_tbl_loan_charge_payment do
    Repo.all(LoanChargePayment)
  end

  @doc """
  Gets a single loan_charge_payment.

  Raises `Ecto.NoResultsError` if the Loan charge payment does not exist.

  ## Examples

      iex> get_loan_charge_payment!(123)
      %LoanChargePayment{}

      iex> get_loan_charge_payment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_charge_payment!(id), do: Repo.get!(LoanChargePayment, id)

  @doc """
  Creates a loan_charge_payment.

  ## Examples

      iex> create_loan_charge_payment(%{field: value})
      {:ok, %LoanChargePayment{}}

      iex> create_loan_charge_payment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_charge_payment(attrs \\ %{}) do
    %LoanChargePayment{}
    |> LoanChargePayment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_charge_payment.

  ## Examples

      iex> update_loan_charge_payment(loan_charge_payment, %{field: new_value})
      {:ok, %LoanChargePayment{}}

      iex> update_loan_charge_payment(loan_charge_payment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_charge_payment(%LoanChargePayment{} = loan_charge_payment, attrs) do
    loan_charge_payment
    |> LoanChargePayment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_charge_payment.

  ## Examples

      iex> delete_loan_charge_payment(loan_charge_payment)
      {:ok, %LoanChargePayment{}}

      iex> delete_loan_charge_payment(loan_charge_payment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_charge_payment(%LoanChargePayment{} = loan_charge_payment) do
    Repo.delete(loan_charge_payment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_charge_payment changes.

  ## Examples

      iex> change_loan_charge_payment(loan_charge_payment)
      %Ecto.Changeset{source: %LoanChargePayment{}}

  """
  def change_loan_charge_payment(%LoanChargePayment{} = loan_charge_payment) do
    LoanChargePayment.changeset(loan_charge_payment, %{})
  end

  alias LoanSavingsSystem.Loan.LoanCollateral

  @doc """
  Returns the list of tbl_loan_collateral.

  ## Examples

      iex> list_tbl_loan_collateral()
      [%LoanCollateral{}, ...]

  """
  def list_tbl_loan_collateral do
    Repo.all(LoanCollateral)
  end

  @doc """
  Gets a single loan_collateral.

  Raises `Ecto.NoResultsError` if the Loan collateral does not exist.

  ## Examples

      iex> get_loan_collateral!(123)
      %LoanCollateral{}

      iex> get_loan_collateral!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_collateral!(id), do: Repo.get!(LoanCollateral, id)

  @doc """
  Creates a loan_collateral.

  ## Examples

      iex> create_loan_collateral(%{field: value})
      {:ok, %LoanCollateral{}}

      iex> create_loan_collateral(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_collateral(attrs \\ %{}) do
    %LoanCollateral{}
    |> LoanCollateral.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_collateral.

  ## Examples

      iex> update_loan_collateral(loan_collateral, %{field: new_value})
      {:ok, %LoanCollateral{}}

      iex> update_loan_collateral(loan_collateral, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_collateral(%LoanCollateral{} = loan_collateral, attrs) do
    loan_collateral
    |> LoanCollateral.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_collateral.

  ## Examples

      iex> delete_loan_collateral(loan_collateral)
      {:ok, %LoanCollateral{}}

      iex> delete_loan_collateral(loan_collateral)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_collateral(%LoanCollateral{} = loan_collateral) do
    Repo.delete(loan_collateral)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_collateral changes.

  ## Examples

      iex> change_loan_collateral(loan_collateral)
      %Ecto.Changeset{source: %LoanCollateral{}}

  """
  def change_loan_collateral(%LoanCollateral{} = loan_collateral) do
    LoanCollateral.changeset(loan_collateral, %{})
  end

  alias LoanSavingsSystem.Loan.LoanInstallmentCharge

  @doc """
  Returns the list of tbl_loan_installment_charge.

  ## Examples

      iex> list_tbl_loan_installment_charge()
      [%LoanInstallmentCharge{}, ...]

  """
  def list_tbl_loan_installment_charge do
    Repo.all(LoanInstallmentCharge)
  end

  @doc """
  Gets a single loan_installment_charge.

  Raises `Ecto.NoResultsError` if the Loan installment charge does not exist.

  ## Examples

      iex> get_loan_installment_charge!(123)
      %LoanInstallmentCharge{}

      iex> get_loan_installment_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_installment_charge!(id), do: Repo.get!(LoanInstallmentCharge, id)

  @doc """
  Creates a loan_installment_charge.

  ## Examples

      iex> create_loan_installment_charge(%{field: value})
      {:ok, %LoanInstallmentCharge{}}

      iex> create_loan_installment_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_installment_charge(attrs \\ %{}) do
    %LoanInstallmentCharge{}
    |> LoanInstallmentCharge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_installment_charge.

  ## Examples

      iex> update_loan_installment_charge(loan_installment_charge, %{field: new_value})
      {:ok, %LoanInstallmentCharge{}}

      iex> update_loan_installment_charge(loan_installment_charge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_installment_charge(%LoanInstallmentCharge{} = loan_installment_charge, attrs) do
    loan_installment_charge
    |> LoanInstallmentCharge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_installment_charge.

  ## Examples

      iex> delete_loan_installment_charge(loan_installment_charge)
      {:ok, %LoanInstallmentCharge{}}

      iex> delete_loan_installment_charge(loan_installment_charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_installment_charge(%LoanInstallmentCharge{} = loan_installment_charge) do
    Repo.delete(loan_installment_charge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_installment_charge changes.

  ## Examples

      iex> change_loan_installment_charge(loan_installment_charge)
      %Ecto.Changeset{source: %LoanInstallmentCharge{}}

  """
  def change_loan_installment_charge(%LoanInstallmentCharge{} = loan_installment_charge) do
    LoanInstallmentCharge.changeset(loan_installment_charge, %{})
  end

  alias LoanSavingsSystem.Loan.LoanOfficerAssignment

  @doc """
  Returns the list of tbl_loan_officer_assignment.

  ## Examples

      iex> list_tbl_loan_officer_assignment()
      [%LoanOfficerAssignment{}, ...]

  """
  def list_tbl_loan_officer_assignment do
    Repo.all(LoanOfficerAssignment)
  end

  @doc """
  Gets a single loan_officer_assignment.

  Raises `Ecto.NoResultsError` if the Loan officer assignment does not exist.

  ## Examples

      iex> get_loan_officer_assignment!(123)
      %LoanOfficerAssignment{}

      iex> get_loan_officer_assignment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_officer_assignment!(id), do: Repo.get!(LoanOfficerAssignment, id)

  @doc """
  Creates a loan_officer_assignment.

  ## Examples

      iex> create_loan_officer_assignment(%{field: value})
      {:ok, %LoanOfficerAssignment{}}

      iex> create_loan_officer_assignment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_officer_assignment(attrs \\ %{}) do
    %LoanOfficerAssignment{}
    |> LoanOfficerAssignment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_officer_assignment.

  ## Examples

      iex> update_loan_officer_assignment(loan_officer_assignment, %{field: new_value})
      {:ok, %LoanOfficerAssignment{}}

      iex> update_loan_officer_assignment(loan_officer_assignment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_officer_assignment(%LoanOfficerAssignment{} = loan_officer_assignment, attrs) do
    loan_officer_assignment
    |> LoanOfficerAssignment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_officer_assignment.

  ## Examples

      iex> delete_loan_officer_assignment(loan_officer_assignment)
      {:ok, %LoanOfficerAssignment{}}

      iex> delete_loan_officer_assignment(loan_officer_assignment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_officer_assignment(%LoanOfficerAssignment{} = loan_officer_assignment) do
    Repo.delete(loan_officer_assignment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_officer_assignment changes.

  ## Examples

      iex> change_loan_officer_assignment(loan_officer_assignment)
      %Ecto.Changeset{source: %LoanOfficerAssignment{}}

  """
  def change_loan_officer_assignment(%LoanOfficerAssignment{} = loan_officer_assignment) do
    LoanOfficerAssignment.changeset(loan_officer_assignment, %{})
  end

  alias LoanSavingsSystem.Loan.LoanOverdueInstallmentCharge

  @doc """
  Returns the list of tbl_loan_overdue_installment_charge.

  ## Examples

      iex> list_tbl_loan_overdue_installment_charge()
      [%LoanOverdueInstallmentCharge{}, ...]

  """
  def list_tbl_loan_overdue_installment_charge do
    Repo.all(LoanOverdueInstallmentCharge)
  end

  @doc """
  Gets a single loan_overdue_installment_charge.

  Raises `Ecto.NoResultsError` if the Loan overdue installment charge does not exist.

  ## Examples

      iex> get_loan_overdue_installment_charge!(123)
      %LoanOverdueInstallmentCharge{}

      iex> get_loan_overdue_installment_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_overdue_installment_charge!(id), do: Repo.get!(LoanOverdueInstallmentCharge, id)

  @doc """
  Creates a loan_overdue_installment_charge.

  ## Examples

      iex> create_loan_overdue_installment_charge(%{field: value})
      {:ok, %LoanOverdueInstallmentCharge{}}

      iex> create_loan_overdue_installment_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_overdue_installment_charge(attrs \\ %{}) do
    %LoanOverdueInstallmentCharge{}
    |> LoanOverdueInstallmentCharge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_overdue_installment_charge.

  ## Examples

      iex> update_loan_overdue_installment_charge(loan_overdue_installment_charge, %{field: new_value})
      {:ok, %LoanOverdueInstallmentCharge{}}

      iex> update_loan_overdue_installment_charge(loan_overdue_installment_charge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_overdue_installment_charge(%LoanOverdueInstallmentCharge{} = loan_overdue_installment_charge, attrs) do
    loan_overdue_installment_charge
    |> LoanOverdueInstallmentCharge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_overdue_installment_charge.

  ## Examples

      iex> delete_loan_overdue_installment_charge(loan_overdue_installment_charge)
      {:ok, %LoanOverdueInstallmentCharge{}}

      iex> delete_loan_overdue_installment_charge(loan_overdue_installment_charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_overdue_installment_charge(%LoanOverdueInstallmentCharge{} = loan_overdue_installment_charge) do
    Repo.delete(loan_overdue_installment_charge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_overdue_installment_charge changes.

  ## Examples

      iex> change_loan_overdue_installment_charge(loan_overdue_installment_charge)
      %Ecto.Changeset{source: %LoanOverdueInstallmentCharge{}}

  """
  def change_loan_overdue_installment_charge(%LoanOverdueInstallmentCharge{} = loan_overdue_installment_charge) do
    LoanOverdueInstallmentCharge.changeset(loan_overdue_installment_charge, %{})
  end

  alias LoanSavingsSystem.Loan.LoanPaidInAdvance

  @doc """
  Returns the list of tbl_loan_paid_in_advance.

  ## Examples

      iex> list_tbl_loan_paid_in_advance()
      [%LoanPaidInAdvance{}, ...]

  """
  def list_tbl_loan_paid_in_advance do
    Repo.all(LoanPaidInAdvance)
  end

  @doc """
  Gets a single loan_paid_in_advance.

  Raises `Ecto.NoResultsError` if the Loan paid in advance does not exist.

  ## Examples

      iex> get_loan_paid_in_advance!(123)
      %LoanPaidInAdvance{}

      iex> get_loan_paid_in_advance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_paid_in_advance!(id), do: Repo.get!(LoanPaidInAdvance, id)

  @doc """
  Creates a loan_paid_in_advance.

  ## Examples

      iex> create_loan_paid_in_advance(%{field: value})
      {:ok, %LoanPaidInAdvance{}}

      iex> create_loan_paid_in_advance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_paid_in_advance(attrs \\ %{}) do
    %LoanPaidInAdvance{}
    |> LoanPaidInAdvance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_paid_in_advance.

  ## Examples

      iex> update_loan_paid_in_advance(loan_paid_in_advance, %{field: new_value})
      {:ok, %LoanPaidInAdvance{}}

      iex> update_loan_paid_in_advance(loan_paid_in_advance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_paid_in_advance(%LoanPaidInAdvance{} = loan_paid_in_advance, attrs) do
    loan_paid_in_advance
    |> LoanPaidInAdvance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_paid_in_advance.

  ## Examples

      iex> delete_loan_paid_in_advance(loan_paid_in_advance)
      {:ok, %LoanPaidInAdvance{}}

      iex> delete_loan_paid_in_advance(loan_paid_in_advance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_paid_in_advance(%LoanPaidInAdvance{} = loan_paid_in_advance) do
    Repo.delete(loan_paid_in_advance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_paid_in_advance changes.

  ## Examples

      iex> change_loan_paid_in_advance(loan_paid_in_advance)
      %Ecto.Changeset{source: %LoanPaidInAdvance{}}

  """
  def change_loan_paid_in_advance(%LoanPaidInAdvance{} = loan_paid_in_advance) do
    LoanPaidInAdvance.changeset(loan_paid_in_advance, %{})
  end

  alias LoanSavingsSystem.Loan.LoanRepaymentSchedule

  @doc """
  Returns the list of tbl_loan_repayment_schedule.

  ## Examples

      iex> list_tbl_loan_repayment_schedule()
      [%LoanRepaymentSchedule{}, ...]

  """
  def list_tbl_loan_repayment_schedule do
    Repo.all(LoanRepaymentSchedule)
  end

  @doc """
  Gets a single loan_repayment_schedule.

  Raises `Ecto.NoResultsError` if the Loan repayment schedule does not exist.

  ## Examples

      iex> get_loan_repayment_schedule!(123)
      %LoanRepaymentSchedule{}

      iex> get_loan_repayment_schedule!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_repayment_schedule!(id), do: Repo.get!(LoanRepaymentSchedule, id)

  @doc """
  Creates a loan_repayment_schedule.

  ## Examples

      iex> create_loan_repayment_schedule(%{field: value})
      {:ok, %LoanRepaymentSchedule{}}

      iex> create_loan_repayment_schedule(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_repayment_schedule(attrs \\ %{}) do
    %LoanRepaymentSchedule{}
    |> LoanRepaymentSchedule.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_repayment_schedule.

  ## Examples

      iex> update_loan_repayment_schedule(loan_repayment_schedule, %{field: new_value})
      {:ok, %LoanRepaymentSchedule{}}

      iex> update_loan_repayment_schedule(loan_repayment_schedule, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_repayment_schedule(%LoanRepaymentSchedule{} = loan_repayment_schedule, attrs) do
    loan_repayment_schedule
    |> LoanRepaymentSchedule.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_repayment_schedule.

  ## Examples

      iex> delete_loan_repayment_schedule(loan_repayment_schedule)
      {:ok, %LoanRepaymentSchedule{}}

      iex> delete_loan_repayment_schedule(loan_repayment_schedule)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_repayment_schedule(%LoanRepaymentSchedule{} = loan_repayment_schedule) do
    Repo.delete(loan_repayment_schedule)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_repayment_schedule changes.

  ## Examples

      iex> change_loan_repayment_schedule(loan_repayment_schedule)
      %Ecto.Changeset{source: %LoanRepaymentSchedule{}}

  """
  def change_loan_repayment_schedule(%LoanRepaymentSchedule{} = loan_repayment_schedule) do
    LoanRepaymentSchedule.changeset(loan_repayment_schedule, %{})
  end

  alias LoanSavingsSystem.Loan.Loans

  @doc """
  Returns the list of tbl_loans.

  ## Examples

      iex> list_tbl_loans()
      [%Loans{}, ...]

  """
  def list_tbl_loans do
    Repo.all(Loans)
  end

  def get_loan_repayment_schedule do
    Loans
      |> join(:left, [la], uB in "tbl_user_bio_data", on: la.loan_userid == uB.userId)
      |> join(:left, [la], uR in "tbl_loan_repayment_schedule", on: la.id == uR.loan_id)
      |> where([la, uB, uR], uR.status == "PENDING")
      |> select([la, uB, uR], %{
        id: la.id,
        firstName: uB.firstName,
        lastName: uB.lastName,
        otherName: uB.otherName,
        dateOfBirth: uB.dateOfBirth,
        meansOfIdentificationType: uB.meansOfIdentificationType,
        meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
        title: uB.title,
        gender: uB.gender,
        mobileNumber: uB.mobileNumber,
        emailAddress: uB.emailAddress,
        principal_amount: uR.principal_amount
      })
      |> Repo.all()
   end
  @doc """
  Gets a single loans.

  Raises `Ecto.NoResultsError` if the Loans does not exist.

  ## Examples

      iex> get_loans!(123)
      %Loans{}

      iex> get_loans!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loans!(id), do: Repo.get!(Loans, id)

  @doc """
  Creates a loans.

  ## Examples

      iex> create_loans(%{field: value})
      {:ok, %Loans{}}

      iex> create_loans(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loans(attrs \\ %{}) do
    %Loans{}
    |> Loans.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loans.

  ## Examples

      iex> update_loans(loans, %{field: new_value})
      {:ok, %Loans{}}

      iex> update_loans(loans, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loans(%Loans{} = loans, attrs) do
    loans
    |> Loans.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loans.

  ## Examples

      iex> delete_loans(loans)
      {:ok, %Loans{}}

      iex> delete_loans(loans)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loans(%Loans{} = loans) do
    Repo.delete(loans)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loans changes.

  ## Examples

      iex> change_loans(loans)
      %Ecto.Changeset{source: %Loans{}}

  """
  def change_loans(%Loans{} = loans) do
    Loans.changeset(loans, %{})
  end

  alias LoanSavingsSystem.Loan.LoanTransaction

  @doc """
  Returns the list of tbl_loan_transaction.

  ## Examples

      iex> list_tbl_loan_transaction()
      [%LoanTransaction{}, ...]

  """
  def list_tbl_loan_transaction do
    Repo.all(LoanTransaction)
  end

  @doc """
  Gets a single loan_transaction.

  Raises `Ecto.NoResultsError` if the Loan transaction does not exist.

  ## Examples

      iex> get_loan_transaction!(123)
      %LoanTransaction{}

      iex> get_loan_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_transaction!(id), do: Repo.get!(LoanTransaction, id)

  @doc """
  Creates a loan_transaction.

  ## Examples

      iex> create_loan_transaction(%{field: value})
      {:ok, %LoanTransaction{}}

      iex> create_loan_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_transaction(attrs \\ %{}) do
    %LoanTransaction{}
    |> LoanTransaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_transaction.

  ## Examples

      iex> update_loan_transaction(loan_transaction, %{field: new_value})
      {:ok, %LoanTransaction{}}

      iex> update_loan_transaction(loan_transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_transaction(%LoanTransaction{} = loan_transaction, attrs) do
    loan_transaction
    |> LoanTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_transaction.

  ## Examples

      iex> delete_loan_transaction(loan_transaction)
      {:ok, %LoanTransaction{}}

      iex> delete_loan_transaction(loan_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_transaction(%LoanTransaction{} = loan_transaction) do
    Repo.delete(loan_transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_transaction changes.

  ## Examples

      iex> change_loan_transaction(loan_transaction)
      %Ecto.Changeset{source: %LoanTransaction{}}

  """
  def change_loan_transaction(%LoanTransaction{} = loan_transaction) do
    LoanTransaction.changeset(loan_transaction, %{})
  end

  alias LoanSavingsSystem.Loan.LoanTransactionRepaymentScheduleMapping

  @doc """
  Returns the list of tbl_loan_transaction_repayment_schedule_mapping.

  ## Examples

      iex> list_tbl_loan_transaction_repayment_schedule_mapping()
      [%LoanTransactionRepaymentScheduleMapping{}, ...]

  """
  def list_tbl_loan_transaction_repayment_schedule_mapping do
    Repo.all(LoanTransactionRepaymentScheduleMapping)
  end

  @doc """
  Gets a single loan_transaction_repayment_schedule_mapping.

  Raises `Ecto.NoResultsError` if the Loan transaction repayment schedule mapping does not exist.

  ## Examples

      iex> get_loan_transaction_repayment_schedule_mapping!(123)
      %LoanTransactionRepaymentScheduleMapping{}

      iex> get_loan_transaction_repayment_schedule_mapping!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_transaction_repayment_schedule_mapping!(id), do: Repo.get!(LoanTransactionRepaymentScheduleMapping, id)

  @doc """
  Creates a loan_transaction_repayment_schedule_mapping.

  ## Examples

      iex> create_loan_transaction_repayment_schedule_mapping(%{field: value})
      {:ok, %LoanTransactionRepaymentScheduleMapping{}}

      iex> create_loan_transaction_repayment_schedule_mapping(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_transaction_repayment_schedule_mapping(attrs \\ %{}) do
    %LoanTransactionRepaymentScheduleMapping{}
    |> LoanTransactionRepaymentScheduleMapping.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_transaction_repayment_schedule_mapping.

  ## Examples

      iex> update_loan_transaction_repayment_schedule_mapping(loan_transaction_repayment_schedule_mapping, %{field: new_value})
      {:ok, %LoanTransactionRepaymentScheduleMapping{}}

      iex> update_loan_transaction_repayment_schedule_mapping(loan_transaction_repayment_schedule_mapping, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_transaction_repayment_schedule_mapping(%LoanTransactionRepaymentScheduleMapping{} = loan_transaction_repayment_schedule_mapping, attrs) do
    loan_transaction_repayment_schedule_mapping
    |> LoanTransactionRepaymentScheduleMapping.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_transaction_repayment_schedule_mapping.

  ## Examples

      iex> delete_loan_transaction_repayment_schedule_mapping(loan_transaction_repayment_schedule_mapping)
      {:ok, %LoanTransactionRepaymentScheduleMapping{}}

      iex> delete_loan_transaction_repayment_schedule_mapping(loan_transaction_repayment_schedule_mapping)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_transaction_repayment_schedule_mapping(%LoanTransactionRepaymentScheduleMapping{} = loan_transaction_repayment_schedule_mapping) do
    Repo.delete(loan_transaction_repayment_schedule_mapping)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_transaction_repayment_schedule_mapping changes.

  ## Examples

      iex> change_loan_transaction_repayment_schedule_mapping(loan_transaction_repayment_schedule_mapping)
      %Ecto.Changeset{source: %LoanTransactionRepaymentScheduleMapping{}}

  """
  def change_loan_transaction_repayment_schedule_mapping(%LoanTransactionRepaymentScheduleMapping{} = loan_transaction_repayment_schedule_mapping) do
    LoanTransactionRepaymentScheduleMapping.changeset(loan_transaction_repayment_schedule_mapping, %{})
  end

  alias LoanSavingsSystem.Loan.LoanProductCharges

  @doc """
  Returns the list of tbl_loan_product_charges.

  ## Examples

      iex> list_tbl_loan_product_charges()
      [%LoanProductCharges{}, ...]

  """
  def list_tbl_loan_product_charges do
    Repo.all(LoanProductCharges)
  end

  @doc """
  Gets a single loan_product_charges.

  Raises `Ecto.NoResultsError` if the Loan product charges does not exist.

  ## Examples

      iex> get_loan_product_charges!(123)
      %LoanProductCharges{}

      iex> get_loan_product_charges!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_product_charges!(id), do: Repo.get!(LoanProductCharges, id)

  @doc """
  Creates a loan_product_charges.

  ## Examples

      iex> create_loan_product_charges(%{field: value})
      {:ok, %LoanProductCharges{}}

      iex> create_loan_product_charges(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_product_charges(attrs \\ %{}) do
    %LoanProductCharges{}
    |> LoanProductCharges.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_product_charges.

  ## Examples

      iex> update_loan_product_charges(loan_product_charges, %{field: new_value})
      {:ok, %LoanProductCharges{}}

      iex> update_loan_product_charges(loan_product_charges, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_product_charges(%LoanProductCharges{} = loan_product_charges, attrs) do
    loan_product_charges
    |> LoanProductCharges.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_product_charges.

  ## Examples

      iex> delete_loan_product_charges(loan_product_charges)
      {:ok, %LoanProductCharges{}}

      iex> delete_loan_product_charges(loan_product_charges)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_product_charges(%LoanProductCharges{} = loan_product_charges) do
    Repo.delete(loan_product_charges)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_product_charges changes.

  ## Examples

      iex> change_loan_product_charges(loan_product_charges)
      %Ecto.Changeset{source: %LoanProductCharges{}}

  """
  def change_loan_product_charges(%LoanProductCharges{} = loan_product_charges) do
    LoanProductCharges.changeset(loan_product_charges, %{})
  end

  alias LoanSavingsSystem.Loan.LoanProductDocumentType

  @doc """
  Returns the list of tbl_loan_product_document_type.

  ## Examples

      iex> list_tbl_loan_product_document_type()
      [%LoanProductDocumentType{}, ...]

  """
  def list_tbl_loan_product_document_type do
    Repo.all(LoanProductDocumentType)
  end

  @doc """
  Gets a single loan_product_document_type.

  Raises `Ecto.NoResultsError` if the Loan product document type does not exist.

  ## Examples

      iex> get_loan_product_document_type!(123)
      %LoanProductDocumentType{}

      iex> get_loan_product_document_type!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_product_document_type!(id), do: Repo.get!(LoanProductDocumentType, id)

  @doc """
  Creates a loan_product_document_type.

  ## Examples

      iex> create_loan_product_document_type(%{field: value})
      {:ok, %LoanProductDocumentType{}}

      iex> create_loan_product_document_type(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_product_document_type(attrs \\ %{}) do
    %LoanProductDocumentType{}
    |> LoanProductDocumentType.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_product_document_type.

  ## Examples

      iex> update_loan_product_document_type(loan_product_document_type, %{field: new_value})
      {:ok, %LoanProductDocumentType{}}

      iex> update_loan_product_document_type(loan_product_document_type, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_product_document_type(%LoanProductDocumentType{} = loan_product_document_type, attrs) do
    loan_product_document_type
    |> LoanProductDocumentType.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_product_document_type.

  ## Examples

      iex> delete_loan_product_document_type(loan_product_document_type)
      {:ok, %LoanProductDocumentType{}}

      iex> delete_loan_product_document_type(loan_product_document_type)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_product_document_type(%LoanProductDocumentType{} = loan_product_document_type) do
    Repo.delete(loan_product_document_type)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_product_document_type changes.

  ## Examples

      iex> change_loan_product_document_type(loan_product_document_type)
      %Ecto.Changeset{source: %LoanProductDocumentType{}}

  """
  def change_loan_product_document_type(%LoanProductDocumentType{} = loan_product_document_type) do
    LoanProductDocumentType.changeset(loan_product_document_type, %{})
  end

  alias LoanSavingsSystem.Loan.LoanRepayment

  @doc """
  Returns the list of tbl_loan_repayment.

  ## Examples

      iex> list_tbl_loan_repayment()
      [%LoanRepayment{}, ...]

  """
  def list_tbl_loan_repayment do
    Repo.all(LoanRepayment)
  end

  @doc """
  Gets a single loan_repayment.

  Raises `Ecto.NoResultsError` if the Loan repayment does not exist.

  ## Examples

      iex> get_loan_repayment!(123)
      %LoanRepayment{}

      iex> get_loan_repayment!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_repayment!(id), do: Repo.get!(LoanRepayment, id)

  @doc """
  Creates a loan_repayment.

  ## Examples

      iex> create_loan_repayment(%{field: value})
      {:ok, %LoanRepayment{}}

      iex> create_loan_repayment(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_repayment(attrs \\ %{}) do
    %LoanRepayment{}
    |> LoanRepayment.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_repayment.

  ## Examples

      iex> update_loan_repayment(loan_repayment, %{field: new_value})
      {:ok, %LoanRepayment{}}

      iex> update_loan_repayment(loan_repayment, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_repayment(%LoanRepayment{} = loan_repayment, attrs) do
    loan_repayment
    |> LoanRepayment.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_repayment.

  ## Examples

      iex> delete_loan_repayment(loan_repayment)
      {:ok, %LoanRepayment{}}

      iex> delete_loan_repayment(loan_repayment)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_repayment(%LoanRepayment{} = loan_repayment) do
    Repo.delete(loan_repayment)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_repayment changes.

  ## Examples

      iex> change_loan_repayment(loan_repayment)
      %Ecto.Changeset{source: %LoanRepayment{}}

  """
  def change_loan_repayment(%LoanRepayment{} = loan_repayment) do
    LoanRepayment.changeset(loan_repayment, %{})
  end
end
