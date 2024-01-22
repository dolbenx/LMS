defmodule Loanmanagementsystem.Loan do
  #  Loanmanagementsystem.Loan.loan_clear_paid()
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.LoanCharge
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Accounts.{User, UserBioData, UserRole}
  alias Loanmanagementsystem.Loan.LoanCharge
  alias Loanmanagementsystem.Loan.LoanTransaction
  alias Loanmanagementsystem.Loan.LoanRepayment
  alias Loanmanagementsystem.Products.Product
  alias Loanmanagementsystem.Accounts.Customer_account
  alias Loanmanagementsystem.Merchants.Merchant
  alias Loanmanagementsystem.Maintenance.{Branch, Bank}
  alias Loanmanagementsystem.Companies.Company

  @doc """
  Returns the list of tbl_loan_charge.

  ## Examples

      iex> list_tbl_loan_charge()
      [%LoanCharge{}, ...]

  """
  def clients_loans_list_write_off(search_params, start, length) do
    IO.inspect search_params
    IO.inspect start
    IO.inspect length
  end
  # Loanmanagementsystem.Loan.get_loan_by_id!(id).customer_id

  def get_loan_by_id!(id), do: Repo.get!(Loans, id)

  #
  # Loanmanagementsystem.Loan.get_loans!(7)

  def get_loan_over_due do
    datetime = DateTime.utc_now()

    Loans
    |> join(:left, [l], s in "tbl_staff", on: l.customer_id == s.id)
    |> where(
      [l, s],
      l.customer_id == s.id and ^datetime > l.expected_maturity_date and
        l.loan_status == "Disbursed"
    )
    |> select([l, s], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: s.first_name,
      last_name: s.last_name,
      phone: s.phone,
      loan_status: l.loan_status,
      company_id: s.company_id,
      principal_amount: l.principal_amount,
      principal_repaid_derived: l.principal_repaid_derived,
      principal_outstanding_derived: l.principal_outstanding_derived,
      interest_outstanding_derived: l.interest_outstanding_derived,
      expected_maturity_date: l.expected_maturity_date
    })
    |> Repo.all()
  end

  def loan_repayment_schedule do
    Loans
    |> join(:left, [la], uB in "tbl_staff", on: la.customer_id == uB.id)
    |> join(:left, [la], uR in "tbl_loan_repayment_schedule", on: la.id == uR.loan_id)
    |> where([la, uB, uR], uR.status == "PENDING")
    |> select([la, uB, uR], %{
      id: la.id,
      first_name: uB.first_name,
      last_name: uB.last_name,
      id_type: uB.id_type,
      id_no: uB.id_no,
      phone: uB.phone,
      email: uB.email,
      principal_amount: la.principal_amount,
      interest_charged_derived: la.interest_charged_derived,
      total_repayment_derived: la.total_repayment_derived,
      total:
        fragment(
          "? + ? + ?",
          la.principal_amount,
          la.interest_charged_derived,
          la.fee_charges_charged_derived
        ),
      total_outstanding_derived: la.total_outstanding_derived,
      fee_charges_charged_derived: la.fee_charges_charged_derived,
      principal_repaid_derived: la.principal_repaid_derived,
      interest_outstanding_derived: la.interest_outstanding_derived,
      interest_writtenoff_derived: la.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: la.penalty_charges_writtenoff_derived,
      fee_charges_waived_derived: la.fee_charges_waived_derived,
      interest_waived_derived: la.interest_waived_derived,
      total_costofloan_derived: la.total_costofloan_derived,
      fee_charges_repaid_derived: la.fee_charges_repaid_derived,
      total_expected_repayment_derived: la.total_expected_repayment_derived,
      principal_outstanding_derived: la.principal_outstanding_derived,
      penalty_charges_charged_derived: la.penalty_charges_charged_derived,
      total_waived_derived: la.total_waived_derived,
      interest_repaid_derived: la.interest_repaid_derived,
      fee_charges_outstanding_derived: la.fee_charges_outstanding_derived,
      fee_charges_writtenoff_derived: la.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: la.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: la.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: la.penalty_charges_repaid_derived,
      total_repayment_derived: la.total_repayment_derived,
      loan_id: uR.loan_id
    })
    |> Repo.all()
  end











  # Loanmanagementsystem.Loan.get_by_mobile()
  def get_by_mobile() do
    Loans
    # |> where([la], p.id == ^product_id)
    |> select([la, user_id], %{
      id: la.id,
      principal_amount: la.principal_amount,
      interest_charged_derived: la.interest_charged_derived,
      total_repayment_derived: la.total_repayment_derived
    })
    |> Repo.all()
  end












  def get_customer_loan_charge do
    Loans
    |> join(:left, [l], s in "tbl_staff", on: l.customer_id == s.id)
    |> join(:left, [l], c in "tbl_loan_charge", on: l.id == c.loan_id)
    |> select([l, s, c], %{
      id: c.id,
      loan_id: c.loan_id,
      charge_id: c.charge_id,
      is_penalty: c.is_penalty,
      charge_time_enum: c.charge_time_enum,
      due_for_collection_as_of_date: c.due_for_collection_as_of_date,
      charge_calculation_enum: c.charge_calculation_enum,
      charge_payment_mode_enum: c.charge_payment_mode_enum,
      calculation_percentage: c.calculation_percentage,
      calculation_on_amount: c.calculation_on_amount,
      charge_amount_or_percentage: c.charge_amount_or_percentage,
      amount: c.amount,
      amount_paid_derived: c.amount_paid_derived,
      amount_waived_derived: c.amount_waived_derived,
      amount_writtenoff_derived: c.amount_writtenoff_derived,
      amount_outstanding_derived: c.amount_outstanding_derived,
      is_paid_derived: c.is_paid_derived,
      is_waived: c.is_waived,
      is_active: c.is_active,
      product_id: l.product_id,
      customer_id: l.customer_id,
      first_name: s.first_name,
      last_name: s.last_name,
      phone: s.phone
    })
    |> Repo.all()
  end

  def get_disbursed_loans do
    Loans
    |> join(:left, [l], s in "tbl_staff", on: l.customer_id == s.id)
    |> where([l, s], l.customer_id == s.id and l.loan_status == "Disbursed")
    |> select([l, s], %{
      customer_id: l.customer_id,
      first_name: s.first_name,
      last_name: s.last_name,
      phone: s.phone,
      id_no: s.id_no,
      status: s.status,
      loan_status: l.loan_status,
      principal_amount_proposed: l.principal_amount_proposed,
      company_id: s.company_id
    })
    |> Repo.all()
  end

  def get_customer_paid_in_advance do
    Loans
    |> join(:left, [l], s in "tbl_staff", on: l.customer_id == s.id)
    |> join(:left, [l], p in "tbl_loan_paid_in_advance", on: l.id == p.loan_id)
    |> where([l, s, p], l.customer_id == s.id and l.id == p.loan_id)
    |> select([l, s, p], %{
      id: p.id,
      loan_id: p.loan_id,
      principal_in_advance_derived: p.principal_in_advance_derived,
      interest_in_advance_derived: p.interest_in_advance_derived,
      fee_charges_in_advance_derived: p.fee_charges_in_advance_derived,
      penalty_charges_in_advance_derived: p.penalty_charges_in_advance_derived,
      total_in_advance_derived: p.total_in_advance_derived,
      customer_id: l.customer_id,
      first_name: s.first_name,
      last_name: s.last_name,
      phone: s.phone,
      status: s.status,
      loan_status: l.loan_status,
      company_id: s.company_id
    })
    |> Repo.all()
  end

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

  alias Loanmanagementsystem.Loan.LoanChargePayment

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

  alias Loanmanagementsystem.Loan.LoanCollateral

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

  alias Loanmanagementsystem.Loan.LoanPaidInAdvance

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

  alias Loanmanagementsystem.Loan.LoanRepaymentSchedule

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

  @doc """
  Returns the list of tbl_loans.

  ## Examples

      iex> list_tbl_loans()
      [%Loans{}, ...]

  """
  def list_tbl_loans do
    Repo.all(Loans)
  end

  def loan_repayment_schedule(company_id) do
    Loans
    |> join(:left, [la], uB in "tbl_staff", on: la.customer_id == uB.id)
    |> join(:left, [la], uR in "tbl_loan_repayment_schedule", on: la.id == uR.loan_id)
    |> where([la, uB, uR], uR.status == "PENDING" and uB.company_id == ^company_id)
    |> select([la, uB, uR], %{
      id: la.id,
      first_name: uB.first_name,
      last_name: uB.last_name,
      id_type: uB.id_type,
      id_no: uB.id_no,
      phone: uB.phone,
      email: uB.email,
      principal_amount: la.principal_amount,
      interest_charged_derived: la.interest_charged_derived,
      total_repayment_derived: la.total_repayment_derived,
      total:
        fragment(
          "? + ? + ?",
          la.principal_amount,
          la.interest_charged_derived,
          la.fee_charges_charged_derived
        ),
      total_outstanding_derived: la.total_outstanding_derived,
      fee_charges_charged_derived: la.fee_charges_charged_derived,
      principal_repaid_derived: la.principal_repaid_derived,
      interest_outstanding_derived: la.interest_outstanding_derived,
      interest_writtenoff_derived: la.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: la.penalty_charges_writtenoff_derived,
      fee_charges_waived_derived: la.fee_charges_waived_derived,
      interest_waived_derived: la.interest_waived_derived,
      total_costofloan_derived: la.total_costofloan_derived,
      fee_charges_repaid_derived: la.fee_charges_repaid_derived,
      total_expected_repayment_derived: la.total_expected_repayment_derived,
      principal_outstanding_derived: la.principal_outstanding_derived,
      penalty_charges_charged_derived: la.penalty_charges_charged_derived,
      total_waived_derived: la.total_waived_derived,
      interest_repaid_derived: la.interest_repaid_derived,
      fee_charges_outstanding_derived: la.fee_charges_outstanding_derived,
      fee_charges_writtenoff_derived: la.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: la.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: la.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: la.penalty_charges_repaid_derived,
      total_repayment_derived: la.total_repayment_derived,
      loan_id: uR.loan_id
    })
    |> Repo.all()
  end

  def get_loan_repayment_schedule(userId) do
    Loans
    |> join(:left, [la], uB in "tbl_user_bio_data", on: la.customer_id == uB.id)
    |> join(:left, [la], uR in "tbl_loan_repayment_schedule", on: la.id == uR.loan_id)
    |> where([la, uB, uR], uR.status == "PENDING" and uB.userId == ^userId)
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
      repayment_schedule_principal_amount: uR.principal_amount,
      loan_principal_amount: la.principal_amount,
      interest_charged_derived: la.interest_charged_derived,
      total_repayment_derived: la.total_repayment_derived,
      total:
        fragment(
          "? + ? + ?",
          la.principal_amount,
          la.interest_charged_derived,
          la.fee_charges_charged_derived
        ),
      total_outstanding_derived: la.total_outstanding_derived,
      fee_charges_charged_derived: la.fee_charges_charged_derived,
      principal_repaid_derived: la.principal_repaid_derived,
      interest_outstanding_derived: la.interest_outstanding_derived,
      interest_writtenoff_derived: la.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: la.penalty_charges_writtenoff_derived,
      fee_charges_waived_derived: la.fee_charges_waived_derived,
      interest_waived_derived: la.interest_waived_derived,
      total_costofloan_derived: la.total_costofloan_derived,
      fee_charges_repaid_derived: la.fee_charges_repaid_derived,
      total_expected_repayment_derived: la.total_expected_repayment_derived,
      principal_outstanding_derived: la.principal_outstanding_derived,
      penalty_charges_charged_derived: la.penalty_charges_charged_derived,
      total_waived_derived: la.total_waived_derived,
      interest_repaid_derived: la.interest_repaid_derived,
      fee_charges_outstanding_derived: la.fee_charges_outstanding_derived,
      fee_charges_writtenoff_derived: la.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: la.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: la.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: la.penalty_charges_repaid_derived,
      total_repayment_derived: la.total_repayment_derived,
      loan_id: uR.loan_id
    })
    |> Repo.all()
  end

  def approve_loan_repayment_schedule(company_id) do
    Loans
    |> join(:left, [la], uB in "tbl_staff", on: la.customer_id == uB.id)
    |> join(:left, [la], uR in "tbl_loan_repayment_schedule", on: la.id == uR.loan_id)
    |> where([la, uB, uR], uR.status == "PENDING_APPROVAL" and uB.company_id == ^company_id)
    |> select([la, uB, uR], %{
      id: la.id,
      first_name: uB.first_name,
      last_name: uB.last_name,
      id_type: uB.id_type,
      id_no: uB.id_no,
      phone: uB.phone,
      email: uB.email,
      repayment_schedule_principal_amount: uR.principal_amount,
      loan_principal_amount: la.principal_amount,
      interest_charged_derived: la.interest_charged_derived,
      total_repayment_derived: la.total_repayment_derived,
      total:
        fragment(
          "? + ? + ?",
          la.principal_amount,
          la.interest_charged_derived,
          la.fee_charges_charged_derived
        ),
      total_outstanding_derived: la.total_outstanding_derived,
      fee_charges_charged_derived: la.fee_charges_charged_derived,
      principal_repaid_derived: la.principal_repaid_derived,
      interest_outstanding_derived: la.interest_outstanding_derived,
      interest_writtenoff_derived: la.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: la.penalty_charges_writtenoff_derived,
      fee_charges_waived_derived: la.fee_charges_waived_derived,
      interest_waived_derived: la.interest_waived_derived,
      total_costofloan_derived: la.total_costofloan_derived,
      fee_charges_repaid_derived: la.fee_charges_repaid_derived,
      total_expected_repayment_derived: la.total_expected_repayment_derived,
      principal_outstanding_derived: la.principal_outstanding_derived,
      penalty_charges_charged_derived: la.penalty_charges_charged_derived,
      total_waived_derived: la.total_waived_derived,
      interest_repaid_derived: la.interest_repaid_derived,
      fee_charges_outstanding_derived: la.fee_charges_outstanding_derived,
      fee_charges_writtenoff_derived: la.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: la.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: la.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: la.penalty_charges_repaid_derived,
      total_repayment_derived: la.total_repayment_derived,
      loan_id: uR.loan_id
    })
    |> Repo.all()
  end

  def get_loan_entries_third(id) do
    LoanTransaction
    |> join(:left, [a], b in "tbl_loan_repayment", on: a.payment_detail_id == b.id)
    |> join(:left, [a, b], c in "tbl_loans", on: c.id == a.loan_id)
    |> join(:left, [a, b, c], d in "tbl_staff", on: c.customer_id == d.id)
    |> join(:left, [a, b, c, d, e], a in "tbl_loan_repayment_schedule", on: a.loan_id == e.loan_id)
    |> where(
      [a, b, c, d, e],
      c.status == "PENDING_PAYMENT_APPROVAL" and a.payment_detail_id == ^id
    )
    |> select([a, b, c, d, e], %{
      id: c.id,
      amount: a.amount,
      phone: d.phone,
      first_name: d.first_name,
      last_name: d.last_name,
      principal_amount: c.principal_amount,
      loan_rep_schudule_principal_amount: e.principal_amount,
      status: c.status,
      total_outstanding_derived: c.total_outstanding_derived,
      account_no: c.account_no,
      term_frequency: c.term_frequency,
      interest_charged_derived: c.interest_charged_derived,
      closedon_date: c.closedon_date,
      principal_repaid_derived: c.principal_repaid_derived,
      total:
        fragment(
          "? + ? + ?",
          c.principal_amount,
          c.interest_charged_derived,
          c.fee_charges_charged_derived
        )
    })
    |> Repo.all()
  end

  def get_loan_repayments_scheduled_entries(id) do
    LoanTransaction
    |> join(:left, [a], b in "tbl_loan_repayment", on: a.payment_detail_id == b.id)
    |> join(:left, [a, b], c in "tbl_loans", on: c.id == a.loan_id)
    |> join(:left, [a, b, c], d in "tbl_staff", on: c.customer_id == d.id)
    |> join(:left, [a, b, c, d, e], a in "tbl_loan_repayment_schedule", on: a.loan_id == e.loan_id)
    |> where(
      [a, b, c, d, e],
      c.status == "PENDING_REPAYENT_CONFIRMATION" and a.payment_detail_id == ^id
    )
    |> select([a, b, c, d, e], %{
      id: c.id,
      amount: a.amount,
      phone: d.phone,
      first_name: d.first_name,
      last_name: d.last_name,
      principal_amount: c.principal_amount,
      loan_status: c.loan_status,
      total_outstanding_derived: c.total_outstanding_derived,
      interest_outstanding_derived: c.interest_outstanding_derived,
      interest_writtenoff_derived: c.interest_writtenoff_derived,
      fee_charges_waived_derived: c.fee_charges_waived_derived,
      total_costofloan_derived: c.total_costofloan_derived,
      total_expected_repayment_derived: c.total_expected_repayment_derived,
      principal_outstanding_derived: c.principal_outstanding_derived,
      penalty_charges_charged_derived: c.penalty_charges_charged_derived,
      total_waived_derived: c.total_waived_derived,
      interest_repaid_derived: c.interest_repaid_derived,
      fee_charges_outstanding_derived: c.fee_charges_outstanding_derived,
      fee_charges_writtenoff_derived: c.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: c.penalty_charges_outstanding_derived,
      penalty_charges_repaid_derived: c.penalty_charges_repaid_derived,
      fee_charges_charged_derived: c.fee_charges_charged_derived,
      loan_rep_schudule_principal_amount: e.principal_amount,
      status: c.status,
      loan_rep_schudule_principal_amount: e.principal_amount,
      account_no: c.account_no,
      term_frequency: c.term_frequency,
      interest_charged_derived: c.interest_charged_derived,
      closedon_date: c.closedon_date,
      principal_repaid_derived: c.principal_repaid_derived,
      total:
        fragment(
          "? + ? + ?",
          c.principal_amount,
          c.interest_charged_derived,
          c.fee_charges_charged_derived
        )
    })
    |> Repo.all()
  end

  def second_approve_loan_repayments_scheduled_entries(id) do
    LoanTransaction
    |> join(:left, [a], b in "tbl_loan_repayment", on: a.payment_detail_id == b.id)
    |> join(:left, [a, b], c in "tbl_loans", on: c.id == a.loan_id)
    |> join(:left, [a, b, c], d in "tbl_staff", on: c.customer_id == d.id)
    |> join(:left, [a, b, c, d, e], a in "tbl_loan_repayment_schedule", on: a.loan_id == e.loan_id)
    |> where([a, b, c, d], c.status == "PENDING_APPROVAL" and a.payment_detail_id == ^id)
    |> select([a, b, c, d, e], %{
      id: c.id,
      amount: a.amount,
      phone: d.phone,
      first_name: d.first_name,
      last_name: d.last_name,
      principal_amount: c.principal_amount,
      loan_rp_schul_principal_amount: e.principal_amount,
      loan_status: c.loan_status,
      total_outstanding_derived: c.total_outstanding_derived,
      account_no: c.account_no,
      term_frequency: c.term_frequency,
      interest_charged_derived: c.interest_charged_derived,
      closedon_date: c.closedon_date,
      principal_repaid_derived: c.principal_repaid_derived,
      total:
        fragment(
          "? + ? + ?",
          c.principal_amount,
          c.interest_charged_derived,
          c.fee_charges_charged_derived
        ),
      fee_charges_charged_derived: c.fee_charges_charged_derived
    })
    |> Repo.all()
  end

  def initiator_loan_payroll_repayment do
    Loans
    |> join(:left, [la], uB in "tbl_staff", on: la.customer_id == uB.id)
    |> join(:left, [la], uR in "tbl_loan_repayment_schedule", on: la.id == uR.loan_id)
    |> where([la, uB, uR], uR.status == "PENDING_PAYMENT_APPROVAL")
    |> select([la, uB, uR], %{
      id: la.id,
      first_name: uB.first_name,
      last_name: uB.last_name,
      id_type: uB.id_type,
      id_no: uB.id_no,
      address: uB.address,
      phone: uB.phone,
      email: uB.email,
      principal_amount: uR.principal_amount,
      loan_id: uR.loan_id,
      status: uR.status,
      interest_amount: uR.interest_amount,
      total_paid_in_advance_derived: uR.total_paid_in_advance_derived,
      obligations_met_on_date: uR.obligations_met_on_date
    })
    |> Repo.all()
  end

  def loan_transaction_details do
    Loans
    |> join(:left, [la], uB in "tbl_loan_transaction_repayment_schedule_mapping",
      on: la.id == uB.loan_transaction_id
    )
    |> join(:left, [la], uR in "tbl_staff", on: la.customer_id == uR.id)
    |> join(:left, [la], rS in "tbl_loan_repayment_schedule", on: rS.loan_id == la.id)
    |> where([la, uB, uR, rS], rS.status == "PENDING_PAYMENT_APPROVAL")
    |> select([la, uB, uR, rS], %{
      id: la.id,
      first_name: uR.first_name,
      last_name: uR.last_name,
      id_type: uR.id_type,
      id_no: uR.id_no,
      address: uR.address,
      phone: uR.phone,
      email: uR.email,
      principal_amount: la.principal_amount,
      status: rS.status,
      amount: uB.amount
    })
    |> Repo.all()
  end

  def loan_clear_paid do
    Loans
    |> join(:left, [la], uB in "tbl_staff", on: la.customer_id == uB.id)
    |> join(:left, [la], uR in "tbl_loan_repayment_schedule", on: la.id == uR.loan_id)
    |> where([la, uB, uR], la.loan_status == "REPAID")
    |> select([la, uB, uR], %{
      id: la.id,
      first_name: uB.first_name,
      last_name: uB.last_name,
      id_type: uB.id_type,
      id_no: uB.id_no,
      address: uB.address,
      phone: uB.phone,
      email: uB.email,
      principal_amount: uR.principal_amount,
      loan_id: uR.loan_id,
      status: uR.status,
      loan_status: la.loan_status,
      interest_amount: uR.interest_amount,
      total_paid_in_advance_derived: uR.total_paid_in_advance_derived,
      obligations_met_on_date: uR.obligations_met_on_date,
      term_frequency_type: la.term_frequency_type,
      total_expected_repayment_derived: la.total_expected_repayment_derived,
      total_repayment_derived: la.total_repayment_derived,
      interest_charged_derived: la.interest_charged_derived
    })
    |> Repo.all()
  end

  #  Loanmanagementsystem.Loan.loan_clear_paid()

  def cleared_loans do
    Loans
    |> join(:left, [la], uB in "tbl_staff", on: la.customer_id == uB.id)
    |> where([la, uB], la.loan_status == "REPAID")
    |> select([la, uB], %{
      id: la.id,
      first_name: uB.first_name,
      last_name: uB.last_name,
      id_type: uB.id_type,
      id_no: uB.id_no,
      address: uB.address,
      phone: uB.phone,
      email: uB.email
    })
    |> Repo.all()
  end

  def loan_mobile_repayment do
    Loans
    |> join(:left, [l], s in "tbl_staff", on: l.customer_id == s.id)
    |> join(:left, [l], t in "tbl_loan_transaction", on: l.id == t.loan_id)
    |> select([l, s, t], %{
      status: l.status,
      total_repayment_derived: l.total_repayment_derived,
      first_name: s.first_name,
      closedon_date: l.closedon_date,
      phone: s.phone,
      term_frequency_type: l.term_frequency_type,
      last_name: s.last_name,
      amount: t.amount,
      interest_portion_derived: t.interest_portion_derived
    })
    |> Repo.all()
  end

  def balance_loan_repayment(company_id) do
    Loans
    |> join(:left, [la], uB in "tbl_staff", on: la.customer_id == uB.id)
    |> where([la, uB], la.loan_status == "Disbursed" and uB.company_id == ^company_id)
    |> select([la, uB], %{
      id: la.id,
      total_outstanding_derived: la.total_outstanding_derived,
      principal_amount: la.principal_amount,
      annual_nominal_interest_rate: la.annual_nominal_interest_rate,
      first_name: uB.first_name,
      last_name: uB.last_name,
      loan_limit: uB.loan_limit,
      id_type: uB.id_type,
      id_no: uB.id_no,
      address: uB.address,
      phone: uB.phone,
      email: uB.email
    })
    |> Repo.all()
  end

  def get_all do
    Repo.one(
      from p in Loans, join: u in User, on: p.external_id == u.company_id, select: count("*")
    )
  end

  def get_client_pending_loans(customer_no) do
    query = """
    SELECT SUM(available_bal)
    FROM [funds_mgt_dev].[dbo].[tbac_cust_account]
    WHERE customer_no = #{customer_no}
    AND currency = 'USD';
    """

    {:ok, %{columns: columns, rows: rows}} = Repo.query(query)
    total = rows |> Enum.map(&Enum.zip(columns, &1)) |> Enum.map(&Enum.into(&1, %{}))
    [%{"" => sum}] = total
    sum
  end
# Loanmanagementsystem.get_loan_info
  def get_loan_info do
    Repo.all(Loans)
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

  # Loanmanagementsystem.Loan.get_loans!
  def get_loans!(id), do: Repo.get!(Loans, id)
  # Loanmanagementsystem.Loan.get_loans_by_customer_id
  def get_loans_by_loan_id(id), do: Repo.get_by(Loans, id: id)

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

  alias Loanmanagementsystem.Loan.LoanTransaction

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

  alias Loanmanagementsystem.Loan.LoanRepayment

  @doc """
  Returns the list of tbl_loan_repayment.

  ## Examples

      iex> list_tbl_loan_repayment()
      [%LoanRepayment{}, ...]

  """
  def list_tbl_loan_repayment(company_id) do
    LoanRepayment
    |> join(:left, [lR], uB in "tbl_user_bio_data", on: lR.company_id == uB.id)
    |> join(:left, [lR], uL in "tbl_loans", on: lR.company_id == uL.customer_id)
    |> where([lR, uB, uL], lR.company_id == ^company_id)
    |> select([lR, uB, uL], %{
      id: lR.id,
      repayment: lR.repayment,
      dateOfRepayment: lR.dateOfRepayment,
      modeOfRepayment: lR.modeOfRepayment,
      amountRepaid: lR.amountRepaid,
      chequeNo: lR.chequeNo,
      receiptNo: lR.receiptNo,
      registeredByUserId: lR.registeredByUserId,
      recipientUserRoleId: lR.recipientUserRoleId,
      company_id: lR.company_id,
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
      principal_amount: uL.principal_amount,
      interest_charged_derived: uL.interest_charged_derived,
      fee_charges_charged_derived: uL.fee_charges_charged_derived,
      total_outstanding_derived: uL.total_outstanding_derived,
      fee_charges_charged_derived: uL.fee_charges_charged_derived,
      principal_repaid_derived: uL.principal_repaid_derived,
      interest_outstanding_derived: uL.interest_outstanding_derived,
      interest_writtenoff_derived: uL.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: uL.penalty_charges_writtenoff_derived,
      fee_charges_waived_derived: uL.fee_charges_waived_derived,
      interest_waived_derived: uL.interest_waived_derived,
      total_costofloan_derived: uL.total_costofloan_derived,
      fee_charges_repaid_derived: uL.fee_charges_repaid_derived,
      total_expected_repayment_derived: uL.total_expected_repayment_derived,
      principal_outstanding_derived: uL.principal_outstanding_derived,
      penalty_charges_charged_derived: uL.penalty_charges_charged_derived,
      total_waived_derived: uL.total_waived_derived,
      interest_repaid_derived: uL.interest_repaid_derived,
      fee_charges_outstanding_derived: uL.fee_charges_outstanding_derived,
      fee_charges_writtenoff_derived: uL.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: uL.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: uL.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: uL.penalty_charges_repaid_derived,
      total_repayment_derived: uL.total_repayment_derived
    })
    |> Repo.all()
  end

  def get_list_tbl_loan_repayment do
    Repo.all(LoanRepayment)
  end

  def get_successful_loan_repayment do
    Repo.all(from p in Loans, where: p.loan_status == "APPROVED")
  end

  # def get_successful_loan_repayment do
  #   Loans
  #   |> join(:left, [l], r in "tbl_loan_repayment", on: l.id == r.loan_id)
  #   |> where([l, r], l.id == r.loan_id and r.status == "SUCCESS")
  #   |> select([l, r], %{
  #     id: l.id,
  #     product_id: l.product_id,
  #     balance: l.balance,
  #     status: r.status,
  #     amountRepaid: r.amountRepaid
  #   })
  #   |> Repo.all()
  # end

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

  ################################################################## RUSSELL ###########################################################
  def total_repaid_loans() do
    query = """
      SELECT sum(total_repayment_derived) as Total_REPAID
      FROM tbl_loans
      WHERE(tbl_loans.loan_status = 'REPAID')

    """

    {:ok, %{columns: columns, rows: rows}} = Repo.query(query, [])
    rows |> Enum.map(&Enum.zip(columns, &1)) |> Enum.map(&Enum.into(&1, %{})) |> Enum.at(0)
  end

  def total_disbursed_loans() do
    query = """
      SELECT sum(principal_disbursed_derived) as Total_DISBURSED
      FROM tbl_loans
      WHERE(tbl_loans.loan_status = 'Disbursed')

    """

    {:ok, %{columns: columns, rows: rows}} = Repo.query(query, [])
    rows |> Enum.map(&Enum.zip(columns, &1)) |> Enum.map(&Enum.into(&1, %{})) |> Enum.at(0)
  end

  # def list_staff_with_company_id(company_id) do
  #   Loanmanagementsystem.Companies.Staff
  #   |> join(:left, [sT], lo in "tbl_loans", on: sT.company_id == lo.customer_id)
  #   |> where([sT, lo], sT.company_id == ^company_id)
  #   |> select([sT, lo], %{
  #     count: count(lo.id)

  #   })

  #   |> Repo.all()
  # end

  def client_pending_loans(company_id) do
    Loanmanagementsystem.Accounts.User
    |> join(:left, [u], lo in "tbl_loans", on: u.id == lo.customer_id)
    |> where([u, lo], lo.company_id == ^company_id and lo.loan_status == "PENDING_MOMO")
    |> select([u, lo], %{
      count: count(lo.id),
      amount: sum(lo.total_expected_repayment_derived)
    })
    |> Repo.all()
  end

  def client_repaid_loans(company_id) do
    start_date = Timex.beginning_of_month(Timex.today())
    start_end = Timex.end_of_month(Timex.today())

    Loanmanagementsystem.Accounts.User
    |> join(:left, [u], lo in "tbl_loans", on: u.id == lo.customer_id)
    |> where(
      [u, lo],
      lo.company_id == ^company_id and lo.loan_status == "REPAID" and
        lo.inserted_at >= ^start_date and lo.inserted_at <= ^start_end
    )
    |> select([u, lo], %{
      count: count(lo.id),
      amount: sum(lo.total_expected_repayment_derived)
    })
    |> Repo.all()
  end

  def client_disbursed_loans(company_id) do
    start_date = Timex.beginning_of_month(Timex.today())
    start_end = Timex.end_of_month(Timex.today())

    Loanmanagementsystem.Accounts.User
    |> join(:left, [u], lo in "tbl_loans", on: u.id == lo.customer_id)
    |> where(
      [u, lo],
      lo.company_id == ^company_id and lo.loan_status == "Disbursed" and
        lo.inserted_at >= ^start_date and lo.inserted_at <= ^start_end
    )
    |> select([u, lo], %{
      count: count(lo.id),
      amount: sum(lo.total_expected_repayment_derived)
    })
    |> Repo.all()
  end

  # def client_total_loans(company_id) do

  #   start_date = Timex.beginning_of_month(Timex.today)
  #   start_end = Timex.end_of_month(Timex.today)

  #   Loanmanagementsystem.Accounts.User
  #   |> join(:left, [u], lo in "tbl_loans", on: u.id == lo.customer_id)
  #   |> where([u, lo], lo.company_id == ^company_id and lo.loan_status == "Disbursed" and lo.inserted_at >= ^start_date and lo.inserted_at <= ^start_end)
  #   |> select([u, lo], %{
  #     count: count(lo.id),
  #     amount: sum(lo.total_expected_repayment_derived)
  #   })
  #   |> Repo.all()
  # end

  def client_total_loans(company_id) do
    strt_date = Timex.beginning_of_month(Timex.today())
    end_date = Timex.end_of_month(Timex.today())

    start_date = Timex.to_naive_datetime(strt_date)
    start_end = Timex.to_naive_datetime(end_date)

    #  company_id = Integer.to_string(company_id)

    Loanmanagementsystem.Loan.Loans
    |> join(:full, [lo], u in "tbl_users", on: lo.customer_id == u.id)
    |> where(
      [lo, u],
      lo.company_id == ^company_id and lo.loan_status == "Disbursed" and
        lo.inserted_at >= ^start_date and lo.inserted_at <= ^start_end
    )
    |> select([lo, u], %{
      count: count(lo.id),
      amount: sum(lo.total_expected_repayment_derived)
    })
    |> Repo.all()
  end

  def client_staff(company_id) do
    Loanmanagementsystem.Companies.Staff
    |> where([u], u.company_id == ^company_id)
    |> select([u], %{
      staff_count: count(u.id)
    })
    |> Repo.all()
  end

  def loan_profit() do
    Loanmanagementsystem.Loan.Loans
    |> where([lo], lo.loan_status == "REPAID")
    |> select([lo], %{
      count: count(lo.id),
      amount: sum(lo.interest_outstanding_derived)
    })
    |> Repo.all()
  end

  def loan_profit_2() do
    Loanmanagementsystem.Loan.Loans
    |> where([lo], lo.loan_status == "Disbursed")
    |> select([lo], %{
      count: count(lo.id),
      amount: sum(lo.interest_outstanding_derived)
    })
    |> Repo.all()
  end

  #    def get_all_loan_report() do
  #   LoanTransaction
  #   |> join(:left, [a], b in "tbl_loans", on:  a.loan_id == b.id)
  #   |> join(:left, [a, b], s in "tbl_staff", on: b.customer_id == d.id)
  #   |> join(:left, [a, b, s], com in "tbl_companies", on: s.company_id == com.id)
  #   |> select([a, b, s, com], %{
  #       id: c.id,
  #       amount: a.amount,
  #       phone: d.phone,
  #       first_name: d.first_name,
  #       last_name: d.last_name,
  #       principal_amount: c.principal_amount,
  #       loan_rep_schudule_principal_amount: b.principal_amount,
  #       status: a.status,
  #       total_outstanding_derived: b.total_outstanding_derived,
  #       account_no: b.account_no,
  #       term_frequency: b.term_frequency,
  #       interest_charged_derived: b.interest_charged_derived,
  #       closedon_date: b.closedon_date,
  #       principal_repaid_derived: b.principal_repaid_derived,
  #       total: fragment("? + ? + ?", b.principal_amount, b.interest_charged_derived, b.fee_charges_charged_derived),
  #       company_name: com.company_name

  #   })
  #   |> Repo.all()
  # end

  # Loanmanagementsystem.Loan.loan_report_logs(nil, 5, 1)

  def loan_report_logs(_source, search_params) do
    Loanmanagementsystem.Loan.Loans
    |> handle_report_filter(search_params)
    |> order_by([a, s, com], asc: a.approvedon_date)
    |> compose_loan_report_select()
  end

  defp handle_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_first_name_filter(search_params)
    |> handle_last_name_filter(search_params)
    |> handle_company_name_filter(search_params)
    |> handle_phone_number_filter(search_params)
    |> handle_loan_status_filter(search_params)
    |> handle_loan_type_filter(search_params)
    |> handle_principal_amount_filter(search_params)
    |> handle_total_expected_repayment_filter(search_params)
    |> handle_loan_report_date_filter(search_params)
  end

  defp handle_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_isearch_filter(query, search_term)
  end

  defp handle_first_name_filter(query, %{"firstname" => firstname})
       when firstname == "" or is_nil(firstname),
       do: query

  defp handle_first_name_filter(query, %{"firstname" => firstname}) do
    where(query, [a, s, com], fragment("lower(?) LIKE lower(?)", s.first_name, ^"%#{firstname}%"))
  end

  defp handle_last_name_filter(query, %{"lastname" => lastname})
       when lastname == "" or is_nil(lastname),
       do: query

  defp handle_last_name_filter(query, %{"lastname" => lastname}) do
    where(query, [a, s, com], fragment("lower(?) LIKE lower(?)", s.last_name, ^"%#{lastname}%"))
  end

  defp handle_company_name_filter(query, %{"company_name" => company_name})
       when company_name == "" or is_nil(company_name),
       do: query

  defp handle_company_name_filter(query, %{"company_name" => company_name}) do
    where(
      query,
      [a, s, com],
      fragment("lower(?) LIKE lower(?)", com.company_name, ^"%#{company_name}%")
    )
  end

  defp handle_phone_number_filter(query, %{"phone_number" => phone_number})
       when phone_number == "" or is_nil(phone_number),
       do: query

  defp handle_phone_number_filter(query, %{"phone_number" => phone_number}) do
    where(query, [a, s, com], fragment("lower(?) LIKE lower(?)", s.phone, ^"%#{phone_number}%"))
  end

  defp handle_loan_status_filter(query, %{"loan_status" => loan_status})
       when loan_status == "" or is_nil(loan_status),
       do: query

  defp handle_loan_status_filter(query, %{"loan_status" => loan_status}) do
    where(
      query,
      [a, s, com],
      fragment("lower(?) LIKE lower(?)", a.loan_status, ^"%#{loan_status}%")
    )
  end

  defp handle_loan_type_filter(query, %{"loan_type" => loan_type})
       when loan_type == "" or is_nil(loan_type),
       do: query

  defp handle_loan_type_filter(query, %{"loan_type" => loan_type}) do
    where(query, [a, s, com], fragment("lower(?) LIKE lower(?)", a.loan_type, ^"%#{loan_type}%"))
  end

  defp handle_principal_amount_filter(query, %{"principal_amount" => principal_amount})
       when principal_amount == "" or is_nil(principal_amount),
       do: query

  defp handle_principal_amount_filter(query, %{"principal_amount" => principal_amount}) do
    where(
      query,
      [a, s, com],
      fragment("lower(?) LIKE lower(?)", a.principal_amount, ^"%#{principal_amount}%")
    )
  end

  defp handle_total_expected_repayment_filter(query, %{
         "total_expected_repayment" => total_expected_repayment
       })
       when total_expected_repayment == "" or is_nil(total_expected_repayment),
       do: query

  defp handle_total_expected_repayment_filter(query, %{
         "total_expected_repayment" => total_expected_repayment
       }) do
    where(
      query,
      [a, s, com],
      fragment(
        "lower(?) LIKE lower(?)",
        a.total_expected_repayment_derived,
        ^"%#{total_expected_repayment}%"
      )
    )
  end

  defp handle_loan_report_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [a],
      fragment("CAST(? AS DATE) >= ?", a.approvedon_date, ^from) and
        fragment("CAST(? AS DATE) <= ?", a.approvedon_date, ^to)
    )
  end

  defp handle_loan_report_date_filter(query, _params), do: query

  defp compose_isearch_filter(query, search_term) do
    query
    |> where(
      [a, s, com],
      fragment("lower(?) LIKE lower(?)", a.approvedon_date, ^search_term) or
        fragment("lower(?) LIKE lower(?)", com.company_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.principal_amount, ^search_term) or
        fragment("lower(?) LIKE lower(?)", s.first_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", s.last_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", s.phone, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.loan_status, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.loan_type, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.principal_amount, ^search_term) or
        fragment("lower(?) LIKE lower(?)", a.total_expected_repayment_derived, ^search_term)
    )
  end

  def compose_loan_report_select(query) do
    query
    |> join(:left, [a], s in "tbl_staff", on: a.customer_id == s.id)
    |> join(:left, [a, s], com in "tbl_companies", on: s.company_id == com.id)
    |> select([a, s, com], %{
      id: a.id,
      phone: s.phone,
      first_name: s.first_name,
      last_name: s.last_name,
      principal_amount: a.principal_amount,
      status: a.status,
      total_outstanding_derived: a.total_outstanding_derived,
      interest_charged_derived: a.interest_charged_derived,
      principal_repaid_derived: a.principal_repaid_derived,
      total:
        fragment(
          "? + ? + ?",
          a.principal_amount,
          a.interest_charged_derived,
          a.fee_charges_charged_derived
        ),
      company_name: com.company_name,
      company_id: com.id,
      transacation_date: a.approvedon_date,
      loan_status: a.loan_status,
      loan_type: a.loan_type,
      currency_code: a.currency_code,
      total_expected_repayment: a.total_expected_repayment_derived,
      phone_number: s.phone
    })
  end

  def get_comp_monthly_loans_2() do
    Loanmanagementsystem.Loan.Loans
    |> join(:left, [lo], u in "tbl_companies", on: lo.company_id == u.id)
    # |> where([lo, u],  lo.sms_status != "sms_sent")
    |> group_by([lo, u], [u.id])
    |> select([lo, u], %{
      company_id: u.id,
      principal_disbursed_derived: sum(lo.principal_disbursed_derived),
      total_repayment_derived: sum(lo.total_repayment_derived)
      # date: lo.inserted_ats
    })
    |> Repo.all()
  end

  #  Loanmanagementsystem.Loan.get_comp_monthly_loans_fragm()

  #  def get_comp_monthly_loans_fragm(month, year) do
  #     Loanmanagementsystem.Loan.Loans
  #     |> where([lo], lo.sms_status != "sms_sent")
  #     |> join(:left, [lo], u in "tbl_companies", on: lo.company_id == u.id)
  #     # |> order_by([lo, u], desc: [b.description])
  #     |> group_by([lo, u], [fragment("""
  #     CASE

  #       WHEN ? = 1  THEN 'Jan'
  #       WHEN ? = 2  THEN 'Feb'
  #       WHEN ? = 3  THEN 'Mar'
  #       WHEN ? = 4  THEN 'Apr'
  #       WHEN ? = 5  THEN 'May'
  #       WHEN ? = 6  THEN 'Jun'
  #       WHEN ? = 7  THEN 'Jul'
  #       WHEN ? = 8  THEN 'Aug'
  #       WHEN ? = 9  THEN 'Sep'
  #       WHEN ? = 10 THEN 'Oct'
  #       WHEN ? = 11 THEN 'Nov'
  #       WHEN ? = 12 THEN 'Dec'
  #       ELSE 'Week 5'
  #     END
  #     """, a.date, a.date, a.date, a.date), b.category, b.description, a.fuel_rate, a.refuel_type, a.fuel_consumed])
  #     |> select([a, b, c],
  #       # count: count(a.id),
  #       count: fragment("count(1)"),
  #       avarage: fragment("select avg(fuel_rate) from tbl_fuel_monitoring"),
  #       monthly_total: a.fuel_consumed,
  #       category: b.category,
  #       total_fuel_rate: sum(a.fuel_rate),
  #       total_consumed: sum(a.fuel_consumed),
  #       total_payment: (sum(a.fuel_consumed) * sum(a.fuel_rate)),
  #       refuel_type: b.description,
  #       distance: sum(a.km_to_destin),
  #       # date: fragment("DATEPART(week, ?)%MONTH(?)", a.date, a.date),
  #       date: fragment("""
  #       CASE

  #         WHEN DAY(?) BETWEEN 1 and 7 THEN 'Week 1'
  #         WHEN DAY(?) BETWEEN 7 and 14 THEN 'Week 2'
  #         WHEN DAY(?) BETWEEN 14 and 21 THEN 'Week 3'
  #         WHEN DAY(?) BETWEEN 21 and 29 THEN 'Week 4'
  #         ELSE 'Week 5'
  #       END
  #       """, a.date, a.date, a.date, a.date)

  #     )
  #       |> Repo.all()
  #       |> Enum.map(&Enum.into(&1, %{}))
  #   end

  #  Loanmanagementsystem.Loan.get_comp_monthly_loans_fragm()

  def get_comp_monthly_loans_fragm() do
    # start_date = Timex.beginning_of_day(Timex.now)
    # start_end = Timex.end_of_day(Timex.now)
    this_year = Timex.today().year

    Loanmanagementsystem.Loan.Loans
    |> join(:left, [lo], u in "tbl_companies", on: lo.company_id == u.id)
    |> order_by([lo, u],
      asc: [
        fragment("DATEPART(YEAR, ?)", lo.inserted_at),
        fragment("DATEPART(MONTH, ?)", lo.inserted_at)
      ]
    )
    |> group_by([lo, u], [
      fragment("DATEPART(YEAR, ?)", lo.inserted_at),
      fragment("DATEPART(MONTH, ?)", lo.inserted_at),
      fragment(
        "CONCAT(DATENAME(mm, (?)), '-', DATEPART(yy, (?)))",
        lo.inserted_at,
        lo.inserted_at
      ),
      lo.loan_status
    ])
    |> where(
      [lo, u],
      lo.loan_status != "PENDING_MOMO" and lo.loan_status != "FAILED" and
        fragment("DATEPART(YEAR, ?)", lo.inserted_at) == ^this_year
    )
    |> select([lo, u],
      year:
        fragment(
          "CONCAT(DATENAME(mm, (?)), '-', DATEPART(yy, (?)))",
          lo.inserted_at,
          lo.inserted_at
        ),
      period: fragment("DATEPART(MONTH, ?)", lo.inserted_at),
      principal_disbursed_derived: sum(lo.principal_disbursed_derived),
      total_repayment_amount:
        fragment(
          "select sum(total_repayment_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'REPAID' ",
          lo.inserted_at
        ),
      total_outstanding_derived:
        fragment(
          "select sum(total_expected_repayment_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'Disbursed' ",
          lo.inserted_at
        ),
      interest_outstanding_derived:
        fragment(
          "select sum(interest_outstanding_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'Disbursed' ",
          lo.inserted_at
        ),
      count_companies: count(fragment("DISTINCT ?", lo.company_id))
    )
    |> Repo.all()
    |> Enum.map(&Enum.into(&1, %{}))
  end

  #  Loanmanagementsystem.Loan.get_monthly_loans_by_companies()

  def get_monthly_loans_by_companies() do
    # start_date = Timex.beginning_of_day(Timex.now)
    # start_end = Timex.end_of_day(Timex.now)
    this_year = Timex.today().year

    Loanmanagementsystem.Loan.Loans
    |> join(:left, [lo], u in "tbl_companies", on: lo.company_id == u.id)
    # |> where([a], a.status == "COMPLETE" and fragment("DATEPART(MONTH, ?) = ? and YEAR(?) = ?", a.date, ^month, a.date, ^year))
    |> order_by([lo, u],
      asc: [
        fragment("DATEPART(YEAR, ?)", lo.inserted_at),
        fragment("DATEPART(MONTH, ?)", lo.inserted_at)
      ]
    )
    |> group_by([lo, u], [
      fragment("DATEPART(YEAR, ?)", lo.inserted_at),
      fragment("DATEPART(MONTH, ?)", lo.inserted_at),
      fragment(
        "CONCAT(DATENAME(mm, (?)), '-', DATEPART(yy, (?)))",
        lo.inserted_at,
        lo.inserted_at
      ),
      u.id,
      u.company_name,
      lo.loan_status
    ])
    |> where(
      [lo, u],
      lo.loan_status != "PENDING_MOMO" and lo.loan_status != "FAILED" and
        fragment("DATEPART(YEAR, ?)", lo.inserted_at) == ^this_year
    )
    |> select([lo, u],
      year:
        fragment(
          "CONCAT(DATENAME(mm, (?)), '-', DATEPART(yy, (?)))",
          lo.inserted_at,
          lo.inserted_at
        ),
      period: fragment("DATEPART(MONTH, ?)", lo.inserted_at),
      count_companies: count(fragment("DISTINCT ?", lo.company_id)),
      principal_disbursed_derived: sum(lo.principal_disbursed_derived),
      total_repayment_derived: sum(lo.total_repayment_derived),
      company_name: u.company_name,
      company_id: count(u.id),
      total_repayment_amount:
        fragment(
          "select sum(total_repayment_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'REPAID' ",
          lo.inserted_at
        ),
      total_outstanding_derived:
        fragment(
          "select sum(total_expected_repayment_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'Disbursed' ",
          lo.inserted_at
        ),
      interest_outstanding_derived:
        fragment(
          "select sum(interest_outstanding_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'Disbursed' ",
          lo.inserted_at
        )
    )
    |> Repo.all()
    |> Enum.map(&Enum.into(&1, %{}))
  end

  # Loanmanagementsystem.Loan.get_monthly_loans_tatols()

  def get_monthly_loans_tatols() do
    # start_date = Timex.beginning_of_day(Timex.now)
    # start_end = Timex.end_of_day(Timex.now)
    this_year = Timex.today().year

    Loanmanagementsystem.Loan.Loans
    |> join(:left, [lo], u in "tbl_companies", on: lo.company_id == u.id)
    |> where(
      [lo, u],
      lo.loan_status != "PENDING_MOMO" and lo.loan_status != "FAILED" and
        fragment("DATEPART(YEAR, ?)", lo.inserted_at) == ^this_year
    )
    |> group_by([lo, u], [fragment("DATEPART(YEAR, ?)", lo.inserted_at), lo.loan_status])
    |> select([lo, u],
      count_companies: count(fragment("DISTINCT ?", lo.company_id)),
      principal_disbursed_derived: sum(lo.principal_disbursed_derived),
      count_companies_test: count(lo.company_id),
      total_repayment_amount:
        fragment(
          "select sum(total_repayment_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'REPAID' ",
          lo.inserted_at
        ),
      total_outstanding_derived:
        fragment(
          "select sum(total_expected_repayment_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'Disbursed' ",
          lo.inserted_at
        ),
      interest_outstanding_derived:
        fragment(
          "select sum(interest_outstanding_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'Disbursed' ",
          lo.inserted_at
        )
    )
    |> Repo.all()
    |> Enum.map(&Enum.into(&1, %{}))
  end

  # Loanmanagementsystem.Loan.get_loan_com()

  ################################################################## RUSSELL ###########################################################

  #  Loanmanagementsystem.Loan.get_monthly_loans_by_count_companies()
  #  Loanmanagementsystem.Loan.get_all_loan_report()

  def get_monthly_loans_by_count_companies() do
    # start_date = Timex.beginning_of_day(Timex.now)
    # start_end = Timex.end_of_day(Timex.now)
    # this_year = Timex.today.year

    Loanmanagementsystem.Loan.Loans
    |> join(:left, [lo], u in "tbl_companies", on: lo.company_id == u.id)
    # |> where([a], a.status == "COMPLETE" and fragment("DATEPART(MONTH, ?) = ? and YEAR(?) = ?", a.date, ^month, a.date, ^year))
    |> order_by([lo, u],
      asc: [
        fragment("DATEPART(YEAR, ?)", lo.inserted_at),
        fragment("DATEPART(MONTH, ?)", lo.inserted_at)
      ]
    )
    |> group_by([lo, u], [
      fragment("DATEPART(YEAR, ?)", lo.inserted_at),
      fragment("DATEPART(MONTH, ?)", lo.inserted_at),
      fragment("DATEPART(YEAR, ?)", lo.inserted_at),
      u.id
    ])
    |> where([lo, u], lo.loan_status != "PENDING_MOMO" or lo.loan_status != "FAILED")
    |> select([lo, u],
      year: fragment("DATEPART(YEAR, ?)", lo.inserted_at),
      period: fragment("DATEPART(MONTH, ?)", lo.inserted_at),
      company_id: count(u.id)
    )
    |> Repo.all()
    |> Enum.map(&Enum.into(&1, %{}))

    # |> Enum.group_by(& &1.year)

    # |> Enum.group_by((& &1.year), (& &1.period))
    # |> Map.values
    # |> Enum.map(&Map.new(&1))
  end

  def oct_loan_customer() do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Loan.get_loan_by_userId(28)

  # Loanmanagementsystem.Loan.get_all_loans()

  def get_all_loans() do
    Loans
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> select([l, uB, p], %{
      loan_id: l.id,
      principal_repaid_derived: l.principal_repaid_derived,
      number_of_repayments: l.number_of_repayments,
      withdrawnon_date: l.withdrawnon_date,
      currency_code: l.currency_code,
      is_npa: l.is_npa,
      repay_every_type: l.repay_every_type,
      principal_writtenoff_derived: l.principal_writtenoff_derived,
      disbursedon_userid: l.disbursedon_userid,
      approvedon_userid: l.approvedon_userid,
      total_writtenoff_derived: l.total_writtenoff_derived,
      repay_every: l.repay_every,
      closedon_userid: l.closedon_userid,
      product_id: l.product_id,
      customer_id: l.customer_id,
      interest_method: l.interest_method,
      annual_nominal_interest_rate: l.annual_nominal_interest_rate,
      writtenoffon_date: l.writtenoffon_date,
      total_outstanding_derived: l.total_outstanding_derived,
      interest_calculated_from_date: l.interest_calculated_from_date,
      loan_counter: l.loan_counter,
      interest_charged_derived: l.interest_charged_derived,
      term_frequency_type: l.term_frequency_type,
      total_charges_due_at_disbursement_derived: l.total_charges_due_at_disbursement_derived,
      penalty_charges_waived_derived: l.penalty_charges_waived_derived,
      total_overpaid_derived: l.total_overpaid_derived,
      approved_principal: l.approved_principal,
      principal_disbursed_derived: l.principal_disbursed_derived,
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      interest_outstanding_derived: l.interest_outstanding_derived,
      interest_writtenoff_derived: l.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: l.penalty_charges_writtenoff_derived,
      loan_status: l.loan_status,
      fee_charges_charged_derived: l.fee_charges_charged_derived,
      fee_charges_waived_derived: l.fee_charges_waived_derived,
      interest_waived_derived: l.interest_waived_derived,
      total_costofloan_derived: l.total_costofloan_derived,
      principal_amount_proposed: l.principal_amount_proposed,
      fee_charges_repaid_derived: l.fee_charges_repaid_derived,
      total_expected_repayment_derived: l.total_expected_repayment_derived,
      principal_outstanding_derived: l.principal_outstanding_derived,
      penalty_charges_charged_derived: l.penalty_charges_charged_derived,
      is_legacyloan: l.is_legacyloan,
      total_waived_derived: l.total_waived_derived,
      interest_repaid_derived: l.interest_repaid_derived,
      rejectedon_date: l.rejectedon_date,
      fee_charges_outstanding_derived: l.fee_charges_outstanding_derived,
      expected_disbursedon_date: l.expected_disbursedon_date,
      closedon_date: l.closedon_date,
      fee_charges_writtenoff_derived: l.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: l.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: l.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: l.penalty_charges_repaid_derived,
      withdrawnon_userid: l.withdrawnon_userid,
      expected_maturity_date: l.expected_maturity_date,
      external_id: l.external_id,
      term_frequency: l.term_frequency,
      total_repayment_derived: l.total_repayment_derived,
      loan_identity_number: l.loan_identity_number,
      branch_id: l.branch_id,
      status: l.status,
      app_user_id: l.app_user_id,
      mobile_money_response: l.mobile_money_response,
      total_principal_repaid: l.total_principal_repaid,
      total_interest_repaid: l.total_interest_repaid,
      total_charges_repaid: l.total_charges_repaid,
      total_penalties_repaid: l.total_penalties_repaid,
      total_repaid: l.total_repaid,
      momoProvider: l.momoProvider,
      company_id: l.company_id,
      loan_userroleid: l.loan_userroleid,
      disbursement_method: l.disbursement_method,
      bank_name: l.bank_name,
      bank_account_no: l.bank_account_no,
      account_name: l.account_name,
      bevura_wallet_no: l.bevura_wallet_no,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.inserted_at,
      # expiry_date: l.expiry_date,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      title: uB.title,
      userId: uB.userId,
      idNo: uB.idNo,
      clientId: p.clientId,
      code: p.code,
      currencyDecimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currencyName: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,
      maximumPrincipal: p.maximumPrincipal,
      minimumPrincipal: p.minimumPrincipal,
      name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      principle_account_id: p.principle_account_id,
      interest_account_id: p.interest_account_id,
      charges_account_id: p.charges_account_id,
      classification_id: p.classification_id
    })
    |> Repo.all()
  end

  def get_loan_by_userId(user_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |>join(:left, [l, s, uB], uR in "tbl_user_roles", on: uB.userId == uR.userId)
    |> join(:left, [l, s, uB, uR], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, u], l.customer_id == ^user_id)
    |> select([l, s, uB,uR, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount,
      repayment_frequency: l.repayment_frequency,
      tenor: l.tenor,
      principal_amount: l.principal_amount,
      account_name: l.account_name,
      bank_account_no: l.bank_account_no,
      # expiry_date: l.expiry_date,
      cvv: l.cvv,
      disbursement_method: l.disbursement_method,
      receipient_number: l.receipient_number,
      product_id: p.id,
      closedon_date: l.closedon_date,
      total_repaid: l.total_repaid,
      reference_no: l.reference_no,
      disbursedon_date: l.disbursedon_date,
      inserted_at: l.inserted_at,
      user_role_id: uR.id,
      total_repayment_derived: l.total_repayment_derived
    })
    |> Repo.all()
  end

  def get_loan_by_userId_and_loanId(user_id, loan_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, s, uB, p], l.customer_id == ^user_id and l.id == ^loan_id)
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount,
      repayment_frequency: l.repayment_frequency,
      tenor: l.tenor,
      principal_amount: l.principal_amount,
      account_name: l.account_name,
      bank_account_no: l.bank_account_no,
      expiry_month: l.expiry_month,
      expiry_year: l.expiry_year,
      cvv: l.cvv,
      disbursement_method: l.disbursement_method,
      receipient_number: l.receipient_number
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Loan.get_loan_by_userId_individualview(3)
  def get_loan_by_userId_individualview_pending_loan(user_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, s, uB, p], l.customer_id == ^user_id and l.loan_status == "PENDING_APPROVAL")
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      currency: p.currencyName,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      closedon_date: l.closedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount
    })
    |> Repo.all()
  end

  def get_loan_by_userId_individualview_reject(user_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, s, uB, p], l.customer_id == ^user_id and l.loan_status == "REJECTED")
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      currency: p.currencyName,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      closedon_date: l.closedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount
    })
    |> Repo.all()
  end

  def get_loan_by_userId_individualview_repayment(user_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, s, uB, p], l.customer_id == ^user_id and l.loan_status == "DISBURSED")
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      currency: p.currencyName,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      closedon_date: l.closedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount
    })
    |> Repo.all()
  end

  def get_loan_by_userId_individualview_loan_tracking(user_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      currency: p.currencyName,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      closedon_date: l.closedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount
    })
    |> Repo.all()
  end

  def get_loan_by_userId_individualloan_repayment(user_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: p.id == l.product_id)
    |> where([l, s, uB, p], l.customer_id == ^user_id and p.id == l.product_id)
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      product_id: l.product_id,
      currency: l.currency_code,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      closedon_date: l.closedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount
    })
    |> Repo.all()
  end

  def get_loan_by_userId_loan_repayment(user_id, loan_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, s, uB, p], l.customer_id == ^user_id and l.id == ^loan_id)
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      currency: p.currencyName,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      closedon_date: l.closedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount
    })
    |> Repo.all()
  end

  def get_loan_by_userId_for_repayment(user_id, product_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, s, uB, p], l.customer_id == ^user_id and l.loan_status == "DISBURSED")
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      product_id: p.id,
      currency: p.currencyName,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      closedon_date: l.closedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount
    })
    |> Repo.all()
  end

  # ------------------------------
  def get_quick_advanced_loan_list() do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    # |> where([l, s , uB, p],  l.loan_status == "PENDING_APPROVAL")
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      currency: p.currencyName,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      closedon_date: l.closedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount
    })
    |> Repo.all()
  end

  # handle pending disbursement
  # Airtel
  def pending_disbursement_via_airtel() do
    Loans
    |> compose_query_airtel()
    |> Repo.all()
  end

  defp compose_query_airtel(query) do
    query
    |> handle_where_airtel()
    |> limit(30)
    |> order_by([s], asc: s.inserted_at)
    |> handle_get_pending_loans_airtel()
  end

  def pending_repayment_via_mnos do
    Repo.all(
      from n in LoanRepayment, where: n.status == "PENDING_PAYMENT" and is_nil(n.bank_account_no)
    )
  end

  defp handle_where_airtel(query) do
    query
    |> where(
      [s],
      s.status == "PENDING_APPROVAL" and
        s.disbursement_method == "Airtel"
    )
  end

  defp handle_get_pending_loans_airtel(query) do
    query
    |> select(
      [s],
      map(s, [
        :reference_no,
        :disbursement_method,
        :receipient_number,
        :currency_code,
        :principal_amount
      ])
    )
  end

  # momo
  def pending_disbursement_via_momo() do
    Loans
    |> compose_query_momo()
    |> Repo.all()
  end

  defp compose_query_momo(query) do
    query
    |> handle_where_momo()
    |> limit(30)
    |> order_by([s], asc: s.inserted_at)
    |> handle_get_pending_loans_momo()
  end

  defp handle_where_momo(query) do
    query
    |> where(
      [s],
      s.status == "PENDING_APPROVAL" and
        s.disbursement_method == "MTN"
    )
  end

  defp handle_get_pending_loans_momo(query) do
    query
    |> select(
      [s],
      map(s, [
        :reference_no,
        :disbursement_method,
        :receipient_number,
        :currency_code,
        :principal_amount
      ])
    )
  end

  # Loanmanagementsystem.Loan.customer_loans(nil, 1, 10)

  def customer_loans(_search_params, page, size) do
    Loans
    # |> handle_product_filter(search_params)
    |> order_by([l, s, uB, p], desc: l.inserted_at)
    |> compose_otc_loans_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def customer_loans(_source, _search_params) do
    Loans
    # |> handle_product_filter(search_params)
    |> order_by([l, s, uB, p], desc: l.inserted_at)
    |> compose_otc_loans_list()
  end

  defp compose_otc_loans_list(query) do
    query
    # |> where([a], a.studentInfosStatus == "Student")
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    |> select(
      [l, s, uB, p],
      %{
        id: l.id,
        customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
        customer_id: l.customer_id,
        first_name: uB.firstName,
        last_name: uB.lastName,
        phone: uB.mobileNumber,
        email_address: uB.emailAddress,
        loan_status: l.loan_status,
        company_id: l.company_id,
        principal_amount: l.principal_amount,
        product_name: p.name,
        product_code: p.code,
        principal_amount: l.principal_amount,
        interest_outstanding_derived: l.interest_outstanding_derived,
        total_principal_repaid: l.total_principal_repaid,
        principal_outstanding_derived: l.principal_outstanding_derived,
        inserted_at: l.inserted_at,
        updated_at: l.updated_at
      }
    )
  end

  # Loanmanagementsystem.Loan.customer_loans_list(nil, 1, 10)

  def customer_loans_list(search_params, page, size) do
    Loans
    |> handle_customer_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_customer_loans_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def customer_loans_list(_source, search_params) do
    Loans
    |> handle_customer_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_customer_loans_list()
  end

  defp compose_customer_loans_list(query) do
    query
    # |> where([a], a.studentInfosStatus == "Student")

    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> select([l, uB, p], %{
      loan_id: l.id,
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      principal_repaid_derived: l.principal_repaid_derived,
      number_of_repayments: l.number_of_repayments,
      withdrawnon_date: l.withdrawnon_date,
      currency_code: l.currency_code,
      is_npa: l.is_npa,
      repay_every_type: l.repay_every_type,
      principal_writtenoff_derived: l.principal_writtenoff_derived,
      disbursedon_userid: l.disbursedon_userid,
      approvedon_userid: l.approvedon_userid,
      total_writtenoff_derived: l.total_writtenoff_derived,
      repay_every: l.repay_every,
      closedon_userid: l.closedon_userid,
      product_id: l.product_id,
      customer_id: l.customer_id,
      interest_method: l.interest_method,
      annual_nominal_interest_rate: l.annual_nominal_interest_rate,
      writtenoffon_date: l.writtenoffon_date,
      total_outstanding_derived: l.total_outstanding_derived,
      interest_calculated_from_date: l.interest_calculated_from_date,
      loan_counter: l.loan_counter,
      interest_charged_derived: l.interest_charged_derived,
      term_frequency_type: l.term_frequency_type,
      total_charges_due_at_disbursement_derived: l.total_charges_due_at_disbursement_derived,
      penalty_charges_waived_derived: l.penalty_charges_waived_derived,
      total_overpaid_derived: l.total_overpaid_derived,
      approved_principal: l.approved_principal,
      principal_disbursed_derived: l.principal_disbursed_derived,
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      interest_outstanding_derived: l.interest_outstanding_derived,
      interest_writtenoff_derived: l.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: l.penalty_charges_writtenoff_derived,
      loan_status: l.loan_status,
      fee_charges_charged_derived: l.fee_charges_charged_derived,
      fee_charges_waived_derived: l.fee_charges_waived_derived,
      interest_waived_derived: l.interest_waived_derived,
      total_costofloan_derived: l.total_costofloan_derived,
      principal_amount_proposed: l.principal_amount_proposed,
      fee_charges_repaid_derived: l.fee_charges_repaid_derived,
      total_expected_repayment_derived: l.total_expected_repayment_derived,
      principal_outstanding_derived: l.principal_outstanding_derived,
      penalty_charges_charged_derived: l.penalty_charges_charged_derived,
      is_legacyloan: l.is_legacyloan,
      total_waived_derived: l.total_waived_derived,
      interest_repaid_derived: l.interest_repaid_derived,
      rejectedon_date: l.rejectedon_date,
      fee_charges_outstanding_derived: l.fee_charges_outstanding_derived,
      expected_disbursedon_date: l.expected_disbursedon_date,
      closedon_date: l.closedon_date,
      fee_charges_writtenoff_derived: l.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: l.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: l.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: l.penalty_charges_repaid_derived,
      withdrawnon_userid: l.withdrawnon_userid,
      expected_maturity_date: l.expected_maturity_date,
      external_id: l.external_id,
      term_frequency: l.term_frequency,
      total_repayment_derived: l.total_repayment_derived,
      loan_identity_number: l.loan_identity_number,
      branch_id: l.branch_id,
      status: l.status,
      app_user_id: l.app_user_id,
      mobile_money_response: l.mobile_money_response,
      total_principal_repaid: l.total_principal_repaid,
      total_interest_repaid: l.total_interest_repaid,
      total_charges_repaid: l.total_charges_repaid,
      total_penalties_repaid: l.total_penalties_repaid,
      total_repaid: l.total_repaid,
      momoProvider: l.momoProvider,
      company_id: l.company_id,
      loan_userroleid: l.loan_userroleid,
      disbursement_method: l.disbursement_method,
      bank_name: l.bank_name,
      bank_account_no: l.bank_account_no,
      account_name: l.account_name,
      bevura_wallet_no: l.bevura_wallet_no,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.inserted_at,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      title: uB.title,
      userId: uB.userId,
      idNo: uB.idNo,
      clientId: p.clientId,
      code: p.code,
      currencyDecimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currencyName: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,
      maximumPrincipal: p.maximumPrincipal,
      minimumPrincipal: p.minimumPrincipal,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      principle_account_id: p.principle_account_id,
      interest_account_id: p.interest_account_id,
      charges_account_id: p.charges_account_id,
      classification_id: p.classification_id
    })
  end

  def customer_pending_list(search_params, page, size) do
    Loans
    # |> handle_product_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_customer_pending_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def customer_pending_list(_source, search_params) do
    Loans
    # |> handle_product_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_customer_pending_list()
  end

  defp handle_customer_loans_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_customer_first_name_filter(search_params)
    |> handle_customer_last_name_filter(search_params)
    |> handle_product_name_filter(search_params)
    |> handle_minimum_principal_filter(search_params)
    |> handle_maximum_principal_filter(search_params)
    |> handle_product_type_filter(search_params)
    |> handle_created_date_filter(search_params)
  end

  defp handle_customer_loans_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_customer_loans_isearch_filter(query, search_term)
  end

  defp handle_customer_first_name_filter(query, %{
         "filter_customer_first_name" => filter_customer_first_name
       }) do
    where(
      query,
      [l, uB, p],
      fragment("lower(?) LIKE lower(?)", uB.firstName, ^"%#{filter_customer_first_name}%")
    )
  end

  defp handle_customer_first_name_filter(query, %{
         "filter_customer_first_name" => filter_customer_first_name
       })
       when filter_customer_first_name == "" or is_nil(filter_customer_first_name),
       do: query

  defp handle_customer_last_name_filter(query, %{
         "filter_customer_last_name" => filter_customer_last_name
       }) do
    where(
      query,
      [l, uB, p],
      fragment("lower(?) LIKE lower(?)", uB.lastName, ^"%#{filter_customer_last_name}%")
    )
  end

  defp handle_customer_last_name_filter(query, %{
         "filter_customer_last_name" => filter_customer_last_name
       })
       when filter_customer_last_name == "" or is_nil(filter_customer_last_name),
       do: query

  defp handle_product_name_filter(query, %{"filter_product_name" => filter_product_name}) do
    where(
      query,
      [l, uB, p],
      fragment("lower(?) LIKE lower(?)", p.name, ^"%#{filter_product_name}%")
    )
  end

  defp handle_product_name_filter(query, %{"filter_product_name" => filter_product_name})
       when filter_product_name == "" or is_nil(filter_product_name),
       do: query

  defp handle_minimum_principal_filter(query, %{
         "filter_minimum_principal" => filter_minimum_principal
       }) do
    where(
      query,
      [l, uB, p],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        l.principal_amount,
        ^"%#{filter_minimum_principal}%"
      )
    )
  end

  defp handle_minimum_principal_filter(query, %{
         "filter_minimum_principal" => filter_minimum_principal
       })
       when filter_minimum_principal == "" or is_nil(filter_minimum_principal),
       do: query

  defp handle_maximum_principal_filter(query, %{
         "filter_maximum_principal" => filter_maximum_principal
       }) do
    where(
      query,
      [l, uB, p],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        l.principal_amount,
        ^"%#{filter_maximum_principal}%"
      )
    )
  end

  defp handle_maximum_principal_filter(query, %{
         "filter_maximum_principal" => filter_maximum_principal
       })
       when filter_maximum_principal == "" or is_nil(filter_maximum_principal),
       do: query

  defp handle_product_type_filter(query, %{"filter_product_type" => filter_product_type}) do
    where(
      query,
      [l, uB, p],
      fragment("lower(?) LIKE lower(?)", p.productType, ^"%#{filter_product_type}%")
    )
  end

  defp handle_product_type_filter(query, %{"filter_product_type" => filter_product_type})
       when filter_product_type == "" or is_nil(filter_product_type),
       do: query

  defp handle_created_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l, uB, p],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.inserted_at, ^to)
    )
  end

  defp handle_created_date_filter(query, _params), do: query

  defp compose_customer_loans_isearch_filter(query, search_term) do
    query
    |> where(
      [l, uB, p],
      fragment("lower(?) LIKE lower(?)", p.product_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", p.period_type, ^search_term) or
        fragment("lower(?) LIKE lower(?)", p.status, ^search_term)
    )
  end

  defp compose_customer_pending_list(query) do
    query
    # |> where([a], a.studentInfosStatus == "Student")

    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> where([l, uB, p], l.loan_status == ^"PENDING_APPROVAL")
    |> select([l, uB, p], %{
      loan_id: l.id,
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      principal_repaid_derived: l.principal_repaid_derived,
      number_of_repayments: l.number_of_repayments,
      withdrawnon_date: l.withdrawnon_date,
      currency_code: l.currency_code,
      is_npa: l.is_npa,
      repay_every_type: l.repay_every_type,
      principal_writtenoff_derived: l.principal_writtenoff_derived,
      disbursedon_userid: l.disbursedon_userid,
      approvedon_userid: l.approvedon_userid,
      total_writtenoff_derived: l.total_writtenoff_derived,
      repay_every: l.repay_every,
      closedon_userid: l.closedon_userid,
      product_id: l.product_id,
      customer_id: l.customer_id,
      interest_method: l.interest_method,
      annual_nominal_interest_rate: l.annual_nominal_interest_rate,
      writtenoffon_date: l.writtenoffon_date,
      total_outstanding_derived: l.total_outstanding_derived,
      interest_calculated_from_date: l.interest_calculated_from_date,
      loan_counter: l.loan_counter,
      interest_charged_derived: l.interest_charged_derived,
      term_frequency_type: l.term_frequency_type,
      total_charges_due_at_disbursement_derived: l.total_charges_due_at_disbursement_derived,
      penalty_charges_waived_derived: l.penalty_charges_waived_derived,
      total_overpaid_derived: l.total_overpaid_derived,
      approved_principal: l.approved_principal,
      principal_disbursed_derived: l.principal_disbursed_derived,
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      interest_outstanding_derived: l.interest_outstanding_derived,
      interest_writtenoff_derived: l.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: l.penalty_charges_writtenoff_derived,
      loan_status: l.loan_status,
      fee_charges_charged_derived: l.fee_charges_charged_derived,
      fee_charges_waived_derived: l.fee_charges_waived_derived,
      interest_waived_derived: l.interest_waived_derived,
      total_costofloan_derived: l.total_costofloan_derived,
      principal_amount_proposed: l.principal_amount_proposed,
      fee_charges_repaid_derived: l.fee_charges_repaid_derived,
      total_expected_repayment_derived: l.total_expected_repayment_derived,
      principal_outstanding_derived: l.principal_outstanding_derived,
      penalty_charges_charged_derived: l.penalty_charges_charged_derived,
      is_legacyloan: l.is_legacyloan,
      total_waived_derived: l.total_waived_derived,
      interest_repaid_derived: l.interest_repaid_derived,
      rejectedon_date: l.rejectedon_date,
      fee_charges_outstanding_derived: l.fee_charges_outstanding_derived,
      expected_disbursedon_date: l.expected_disbursedon_date,
      closedon_date: l.closedon_date,
      fee_charges_writtenoff_derived: l.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: l.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: l.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: l.penalty_charges_repaid_derived,
      withdrawnon_userid: l.withdrawnon_userid,
      expected_maturity_date: l.expected_maturity_date,
      external_id: l.external_id,
      term_frequency: l.term_frequency,
      total_repayment_derived: l.total_repayment_derived,
      loan_identity_number: l.loan_identity_number,
      branch_id: l.branch_id,
      status: l.status,
      app_user_id: l.app_user_id,
      mobile_money_response: l.mobile_money_response,
      total_principal_repaid: l.total_principal_repaid,
      total_interest_repaid: l.total_interest_repaid,
      total_charges_repaid: l.total_charges_repaid,
      total_penalties_repaid: l.total_penalties_repaid,
      total_repaid: l.total_repaid,
      momoProvider: l.momoProvider,
      company_id: l.company_id,
      loan_userroleid: l.loan_userroleid,
      disbursement_method: l.disbursement_method,
      bank_name: l.bank_name,
      bank_account_no: l.bank_account_no,
      account_name: l.account_name,
      bevura_wallet_no: l.bevura_wallet_no,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.inserted_at
    })
  end

  # Loanmanagementsystem.Products.product_list(nil, 1, 10)

  def product_list(_source, _search_params) do
    Product
    # |> handle_product_filter(search_params)
    |> order_by([p], desc: p.inserted_at)
    |> compose_product_list()
  end

  defp compose_product_list(query) do
    query
    # |> where([a], a.studentInfosStatus == "Student")
    |> select(
      [p],
      %{
        clientId: p.clientId,
        product_code: p.code,
        currency_decimals: p.currencyDecimals,
        currencyId: p.currencyId,
        currency_name: p.currencyName,
        defaultPeriod: p.defaultPeriod,
        details: p.details,
        interest: p.interest,
        interestMode: p.interestMode,
        interestType: p.interestType,
        max_amount: p.maximumPrincipal,
        min_amount: p.minimumPrincipal,
        profit: fragment("concat(?, concat(' To ', ?))", p.minimumPrincipal, p.minimumPrincipal),
        product_name: p.name,
        period_type: p.periodType,
        product_type: p.productType,
        status: p.status,
        yearLengthInDays: p.yearLengthInDays,
        product_id: p.id,
        id: p.id,
        inserted_at: p.inserted_at,
        updated_at: p.updated_at
      }
    )
  end

  # Loanmanagementsystem.Loan.sme_lookup(nil, 1, 10)

  def sme_lookup(search_params, page, size) do
    Loans
    |> handle_smes_filter(search_params)
    |> order_by([l], desc: l.inserted_at)
    |> compose_sme_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def sme_lookup(_source, search_params) do
    Loans
    |> handle_smes_filter(search_params)
    |> order_by([l], desc: l.inserted_at)
    |> compose_sme_select()
  end

  defp compose_sme_select(query) do
    query
    # |> where([a], a.studentInfosStatus == "Student")
    |> select(
      [l],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at
      }
    )
  end

  defp handle_smes_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_disbursedon_date_filter(search_params)
  end

  defp handle_disbursedon_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^from) and
      fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^to)
    )
  end

  defp handle_disbursedon_date_filter(query, _params), do: query

  #         dateOfBirth: uB.dateOfBirth,
  #         emailAddress: uB.emailAddress,
  #         firstName: uB.firstName,
  #         gender: uB.gender,
  #         lastName: uB.lastName,
  #         meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
  #         meansOfIdentificationType: uB.meansOfIdentificationType,
  #         mobileNumber: uB.mobileNumber,
  #         otherName: uB.otherName,
  #         title: uB.title,
  #         userId: uB.userId,
  #         idNo: uB.idNo,

  #         clientId: p.clientId,
  #         code: p.code,
  #         currencyDecimals: p.currencyDecimals,
  #         currencyId: p.currencyId,
  #         currencyName: p.currencyName,
  #         defaultPeriod: p.defaultPeriod,
  #         details: p.details,
  #         interest: p.interest,
  #         interestMode: p.interestMode,
  #         interestType: p.interestType,
  #         maximumPrincipal: p.maximumPrincipal,
  #         minimumPrincipal: p.minimumPrincipal,
  #         product_name: p.name,
  #         periodType: p.periodType,
  #         productType: p.productType,
  #         status: p.status,
  #         yearLengthInDays: p.yearLengthInDays,
  #         principle_account_id: p.principle_account_id,
  #         interest_account_id: p.interest_account_id,
  #         charges_account_id: p.charges_account_id,
  #         classification_id: p.classification_id
  #        })

  # end

  def customer_disbursed_list(_search_params, page, size) do
    Loans
    # |> handle_product_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_customer_disbursed_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def customer_disbursed_list(_source, search_params) do
    Loans
    # |> handle_product_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_customer_disbursed_list()
  end

  defp compose_customer_disbursed_list(query) do
    query
    # |> where([a], a.studentInfosStatus == "Student")

    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> where([l, uB, p], l.loan_status == ^"DISBURSED")
    |> select([l, uB, p], %{
      loan_id: l.id,
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      principal_repaid_derived: l.principal_repaid_derived,
      number_of_repayments: l.number_of_repayments,
      withdrawnon_date: l.withdrawnon_date,
      currency_code: l.currency_code,
      is_npa: l.is_npa,
      repay_every_type: l.repay_every_type,
      principal_writtenoff_derived: l.principal_writtenoff_derived,
      disbursedon_userid: l.disbursedon_userid,
      approvedon_userid: l.approvedon_userid,
      total_writtenoff_derived: l.total_writtenoff_derived,
      repay_every: l.repay_every,
      closedon_userid: l.closedon_userid,
      product_id: l.product_id,
      customer_id: l.customer_id,
      interest_method: l.interest_method,
      annual_nominal_interest_rate: l.annual_nominal_interest_rate,
      writtenoffon_date: l.writtenoffon_date,
      total_outstanding_derived: l.total_outstanding_derived,
      interest_calculated_from_date: l.interest_calculated_from_date,
      loan_counter: l.loan_counter,
      interest_charged_derived: l.interest_charged_derived,
      term_frequency_type: l.term_frequency_type,
      total_charges_due_at_disbursement_derived: l.total_charges_due_at_disbursement_derived,
      penalty_charges_waived_derived: l.penalty_charges_waived_derived,
      total_overpaid_derived: l.total_overpaid_derived,
      approved_principal: l.approved_principal,
      principal_disbursed_derived: l.principal_disbursed_derived,
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      interest_outstanding_derived: l.interest_outstanding_derived,
      interest_writtenoff_derived: l.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: l.penalty_charges_writtenoff_derived,
      loan_status: l.loan_status,
      fee_charges_charged_derived: l.fee_charges_charged_derived,
      fee_charges_waived_derived: l.fee_charges_waived_derived,
      interest_waived_derived: l.interest_waived_derived,
      total_costofloan_derived: l.total_costofloan_derived,
      principal_amount_proposed: l.principal_amount_proposed,
      fee_charges_repaid_derived: l.fee_charges_repaid_derived,
      total_expected_repayment_derived: l.total_expected_repayment_derived,
      principal_outstanding_derived: l.principal_outstanding_derived,
      penalty_charges_charged_derived: l.penalty_charges_charged_derived,
      is_legacyloan: l.is_legacyloan,
      total_waived_derived: l.total_waived_derived,
      interest_repaid_derived: l.interest_repaid_derived,
      rejectedon_date: l.rejectedon_date,
      fee_charges_outstanding_derived: l.fee_charges_outstanding_derived,
      expected_disbursedon_date: l.expected_disbursedon_date,
      closedon_date: l.closedon_date,
      fee_charges_writtenoff_derived: l.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: l.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: l.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: l.penalty_charges_repaid_derived,
      withdrawnon_userid: l.withdrawnon_userid,
      expected_maturity_date: l.expected_maturity_date,
      external_id: l.external_id,
      term_frequency: l.term_frequency,
      total_repayment_derived: l.total_repayment_derived,
      loan_identity_number: l.loan_identity_number,
      branch_id: l.branch_id,
      status: l.status,
      app_user_id: l.app_user_id,
      mobile_money_response: l.mobile_money_response,
      total_principal_repaid: l.total_principal_repaid,
      total_interest_repaid: l.total_interest_repaid,
      total_charges_repaid: l.total_charges_repaid,
      total_penalties_repaid: l.total_penalties_repaid,
      total_repaid: l.total_repaid,
      momoProvider: l.momoProvider,
      company_id: l.company_id,
      loan_userroleid: l.loan_userroleid,
      disbursement_method: l.disbursement_method,
      bank_name: l.bank_name,
      bank_account_no: l.bank_account_no,
      account_name: l.account_name,
      bevura_wallet_no: l.bevura_wallet_no,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.inserted_at,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      title: uB.title,
      userId: uB.userId,
      idNo: uB.idNo,
      clientId: p.clientId,
      code: p.code,
      currencyDecimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currencyName: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,
      maximumPrincipal: p.maximumPrincipal,
      minimumPrincipal: p.minimumPrincipal,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      principle_account_id: p.principle_account_id,
      interest_account_id: p.interest_account_id,
      charges_account_id: p.charges_account_id,
      classification_id: p.classification_id
    })
  end

  alias Loanmanagementsystem.Loan.Customer_Balance

  @doc """
  Returns the list of tbl_customer_balance.

  ## Examples

      iex> list_tbl_customer_balance()
      [%Customer_Balance{}, ...]

  """
  def list_tbl_customer_balance do
    Repo.all(Customer_Balance)
  end

  @doc """
  Gets a single customer__balance.

  Raises `Ecto.NoResultsError` if the Customer  balance does not exist.

  ## Examples

      iex> get_customer__balance!(123)
      %Customer_Balance{}

      iex> get_customer__balance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_customer__balance!(id), do: Repo.get!(Customer_Balance, id)

  @doc """
  Creates a customer__balance.

  ## Examples

      iex> create_customer__balance(%{field: value})
      {:ok, %Customer_Balance{}}

      iex> create_customer__balance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer__balance(attrs \\ %{}) do
    %Customer_Balance{}
    |> Customer_Balance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a customer__balance.

  ## Examples

      iex> update_customer__balance(customer__balance, %{field: new_value})
      {:ok, %Customer_Balance{}}

      iex> update_customer__balance(customer__balance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_customer__balance(%Customer_Balance{} = customer__balance, attrs) do
    customer__balance
    |> Customer_Balance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a customer__balance.

  ## Examples

      iex> delete_customer__balance(customer__balance)
      {:ok, %Customer_Balance{}}

      iex> delete_customer__balance(customer__balance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_customer__balance(%Customer_Balance{} = customer__balance) do
    Repo.delete(customer__balance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking customer__balance changes.

  ## Examples

      iex> change_customer__balance(customer__balance)
      %Ecto.Changeset{data: %Customer_Balance{}}

  """
  def change_customer__balance(%Customer_Balance{} = customer__balance, attrs \\ %{}) do
    Customer_Balance.changeset(customer__balance, attrs)
  end

  # ----------------------------------------------------------------
  def quick_advance_loan_list(search_params, page, size) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Quick Advance")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def quick_advance_loan_list(_source, search_params) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Quick Advance")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
  end

  # ---------------------------------------------------------------------
  def quick_loan_list(search_params, page, size) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Quick Loan")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def quick_loan_list(_source, search_params) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Quick Loan")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
  end

  # ----------------------------------------------------------------------
  def float_advance_list(search_params, page, size) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Float Advance")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def float_advance_list(_source, search_params) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Float Advance")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
  end

  # ----------------------------------------------------------------------
  def order_finance_list(search_params, page, size) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Order Finance")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def order_finance_list(_source, search_params) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Order Finance")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
  end

  # --------------------------------------------------------------
  def trade_advance_list(search_params, page, size) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Trade Advance")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def trade_advance_list(_source, search_params) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Trade Advance")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
  end

  # --------------------------------------------------------------------------

  def invoice_discounting_list(search_params, page, size) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Invoice Discounting")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def invoice_discounting_list(_source, search_params) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> where([p, lp], p.loan_type == "Invoice Discounting")
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
  end

  # ----------------------------------------------------------------------------
  def loan_approval_and_disbursement_list(search_params, page, size) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def loan_approval_and_disbursement_list(_source, search_params) do
    Loans
    |> join(:left, [p], lp in "tbl_products", on: p.product_id == lp.id)
    # |> handle_product_filter(search_params)
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_list()
  end

  # ----------------------------------------------------------------------
  def loan_portifolio_list(search_params, page, size) do
    Loans
    |> where([p], p.loan_status == "DISBURSED")
    |> group_by([p], [p.product_id, p.approvedon_date] )
    |> compose_loan_portifolio_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def loan_portifolio_list(_source, search_params) do
    Loans
    |> where([p], p.loan_status == "DISBURSED")
    |> group_by([p], [p.product_id, p.approvedon_date] )
    |> compose_loan_portifolio_list()
  end


  # -----------------------------------------------------------------------
  alias Loanmanagementsystem.Loan.LoanRepayment

  def loan_repayment_list(search_params, page, size) do
    LoanRepayment
    # |> handle_product_filter(search_params)
    |> order_by([p], desc: p.inserted_at)
    |> compose_loan_repayment_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def loan_repayment_list(_source, search_params) do
    LoanRepayment
    # |> handle_product_filter(search_params)
    |> order_by([a], desc: a.inserted_at)
    |> compose_loan_repayment_list()
  end

  defp compose_loan_repayment_list(query) do
    query
    |> select(
      [a],
      %{
        id: a.id,
        amountRepaid: a.amountRepaid,
        dateOfRepayment: a.dateOfRepayment,
        modeOfRepayment: a.modeOfRepayment,
        account_name: a.account_name,
        company_id: a.company_id,
        loan_product: a.loan_product,
        repayment_type: a.repayment_type,
        repayment_method: a.repayment_method,
        bank_name: a.bank_name,
        branch_name: a.branch_name,
        swift_code: a.swift_code,
        mno_mobile_no: a.mno_mobile_no,
        status: a.status
      }
    )
  end

  defp compose_loan_list(query) do
    query
    |> select(
      [p, lp],
      %{
        id: p.id,
        customer_id: p.customer_id,
        product_id: p.product_id,
        loan_status: p.loan_status,
        company_id: p.company_id,
        product_name: lp.name,
        principal_amount: p.principal_amount,
        principal_amount: p.principal_amount,
        interest_outstanding_derived: p.interest_outstanding_derived,
        total_principal_repaid: p.total_principal_repaid,
        principal_outstanding_derived: p.principal_outstanding_derived,
        repayment_type: p.repayment_type,
        approvedon_date: p.approvedon_date,
        closedon_date: p.closedon_date,
        repayment_amount: p.repayment_amount,
        balance: p.balance,
        interest_amount: p.interest_amount
      }
    )
  end

  defp compose_loan_portifolio_list(query) do
    query
    |> select(
      [p],
      %{

        product_id: p.product_id,
        product_name:  fragment("select name from tbl_products where id = ? ", p.product_id ),
        principal_amount: sum(p.principal_amount),
        approvedon_date: p.approvedon_date,
        repayment_amount: sum(p.repayment_amount),
        balance: sum(p.balance),
        interest_amount: sum(p.interest_amount)
      }
    )
  end

  defp handle_product_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_product_name_filter(search_params)
    |> handle_product_type_filter(search_params)
    |> handle_minimum_principal_filter(search_params)
    |> handle_maximum_principal_filter(search_params)
    |> handle_created_date_filter(search_params)
  end

  defp handle_product_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_product_isearch_filter(query, search_term)
  end

  defp handle_product_name_filter(query, %{"filter_product_name" => filter_product_name}) do
    where(query, [p], fragment("lower(?) LIKE lower(?)", p.name, ^"%#{filter_product_name}%"))
  end

  defp handle_product_name_filter(query, %{"filter_product_name" => filter_product_name})
       when filter_product_name == "" or is_nil(filter_product_name),
       do: query

  defp handle_product_type_filter(query, %{"filter_product_type" => filter_product_type}) do
    where(
      query,
      [p],
      fragment("lower(?) LIKE lower(?)", p.productType, ^"%#{filter_product_type}%")
    )
  end

  defp handle_product_type_filter(query, %{"filter_product_type" => filter_product_type})
       when filter_product_type == "" or is_nil(filter_product_type),
       do: query

  defp handle_minimum_principal_filter(query, %{
         "filter_minimum_principal" => filter_minimum_principal
       }) do
    where(
      query,
      [p],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        p.minimumPrincipal,
        ^"%#{filter_minimum_principal}%"
      )
    )
  end

  defp handle_minimum_principal_filter(query, %{
         "filter_minimum_principal" => filter_minimum_principal
       })
       when filter_minimum_principal == "" or is_nil(filter_minimum_principal),
       do: query

  defp handle_maximum_principal_filter(query, %{
         "filter_maximum_principal" => filter_maximum_principal
       }) do
    where(
      query,
      [p],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        p.maximumPrincipal,
        ^"%#{filter_maximum_principal}%"
      )
    )
  end

  defp handle_maximum_principal_filter(query, %{
         "filter_maximum_principal" => filter_maximum_principal
       })
       when filter_maximum_principal == "" or is_nil(filter_maximum_principal),
       do: query

  defp handle_created_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [p],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", p.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", p.inserted_at, ^to)
    )
  end

  defp handle_created_date_filter(query, _params), do: query

  defp compose_product_isearch_filter(query, search_term) do
    query
    |> where(
      [p],
      fragment("lower(?) LIKE lower(?)", p.name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", p.period_type, ^search_term) or
        fragment("lower(?) LIKE lower(?)", p.status, ^search_term)
    )
  end

  alias Loanmanagementsystem.Loan.Loan_disbursement

  @doc """
  Returns the list of tbl_loan_disbursement.

  ## Examples

      iex> list_tbl_loan_disbursement()
      [%Loan_disbursement{}, ...]

  """
  def list_tbl_loan_disbursement do
    Repo.all(Loan_disbursement)
  end

  @doc """
  Gets a single loan_disbursement.

  Raises `Ecto.NoResultsError` if the Loan disbursement does not exist.

  ## Examples

      iex> get_loan_disbursement!(123)
      %Loan_disbursement{}

      iex> get_loan_disbursement!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_disbursement!(id), do: Repo.get!(Loan_disbursement, id)

  @doc """
  Creates a loan_disbursement.

  ## Examples

      iex> create_loan_disbursement(%{field: value})
      {:ok, %Loan_disbursement{}}

      iex> create_loan_disbursement(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_disbursement(attrs \\ %{}) do
    %Loan_disbursement{}
    |> Loan_disbursement.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_disbursement.

  ## Examples

      iex> update_loan_disbursement(loan_disbursement, %{field: new_value})
      {:ok, %Loan_disbursement{}}

      iex> update_loan_disbursement(loan_disbursement, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_disbursement(%Loan_disbursement{} = loan_disbursement, attrs) do
    loan_disbursement
    |> Loan_disbursement.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_disbursement.

  ## Examples

      iex> delete_loan_disbursement(loan_disbursement)
      {:ok, %Loan_disbursement{}}

      iex> delete_loan_disbursement(loan_disbursement)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_disbursement(%Loan_disbursement{} = loan_disbursement) do
    Repo.delete(loan_disbursement)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_disbursement changes.

  ## Examples

      iex> change_loan_disbursement(loan_disbursement)
      %Ecto.Changeset{data: %Loan_disbursement{}}

  """
  def change_loan_disbursement(%Loan_disbursement{} = loan_disbursement, attrs \\ %{}) do
    Loan_disbursement.changeset(loan_disbursement, attrs)
  end

  alias Loanmanagementsystem.Loan.Loan_Provisioning_Criteria

  @doc """
  Returns the list of tbl_loan_provisioning_criteria.

  ## Examples

      iex> list_tbl_loan_provisioning_criteria()
      [%Loan_Provisioning_Criteria{}, ...]

  """
  def list_tbl_loan_provisioning_criteria do
    Repo.all(Loan_Provisioning_Criteria)
  end

  @doc """
  Gets a single loan__provisioning__criteria.

  Raises `Ecto.NoResultsError` if the Loan  provisioning  criteria does not exist.

  ## Examples

      iex> get_loan__provisioning__criteria!(123)
      %Loan_Provisioning_Criteria{}

      iex> get_loan__provisioning__criteria!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan__provisioning__criteria!(id), do: Repo.get!(Loan_Provisioning_Criteria, id)

  @doc """
  Creates a loan__provisioning__criteria.

  ## Examples

      iex> create_loan__provisioning__criteria(%{field: value})
      {:ok, %Loan_Provisioning_Criteria{}}

      iex> create_loan__provisioning__criteria(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan__provisioning__criteria(attrs \\ %{}) do
    %Loan_Provisioning_Criteria{}
    |> Loan_Provisioning_Criteria.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan__provisioning__criteria.

  ## Examples

      iex> update_loan__provisioning__criteria(loan__provisioning__criteria, %{field: new_value})
      {:ok, %Loan_Provisioning_Criteria{}}

      iex> update_loan__provisioning__criteria(loan__provisioning__criteria, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan__provisioning__criteria(
        %Loan_Provisioning_Criteria{} = loan__provisioning__criteria,
        attrs
      ) do
    loan__provisioning__criteria
    |> Loan_Provisioning_Criteria.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan__provisioning__criteria.

  ## Examples

      iex> delete_loan__provisioning__criteria(loan__provisioning__criteria)
      {:ok, %Loan_Provisioning_Criteria{}}

      iex> delete_loan__provisioning__criteria(loan__provisioning__criteria)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan__provisioning__criteria(
        %Loan_Provisioning_Criteria{} = loan__provisioning__criteria
      ) do
    Repo.delete(loan__provisioning__criteria)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan__provisioning__criteria changes.

  ## Examples

      iex> change_loan__provisioning__criteria(loan__provisioning__criteria)
      %Ecto.Changeset{data: %Loan_Provisioning_Criteria{}}

  """
  def change_loan__provisioning__criteria(
        %Loan_Provisioning_Criteria{} = loan__provisioning__criteria,
        attrs \\ %{}
      ) do
    Loan_Provisioning_Criteria.changeset(loan__provisioning__criteria, attrs)
  end

  ########################################## RUSSKAY ####################################
  # Loanmanagementsystem.Loan.clients_loan_portfolio(nil, 1, 10)

  def clients_loan_portfolio(_search_params, page, size) do
    Loanmanagementsystem.Loan.Loans
    # |> handle_product_filter(search_params)
    |> order_by([l, uR], desc: l.disbursedon_date)
    |> compose_clients_loan_portfolio()
    |> Repo.paginate(page: page, page_size: size)
  end

  def clients_loan_portfolio(_source, search_params) do
    Loanmanagementsystem.Loan.Loans
    # |> handle_product_filter(search_params)
    |> order_by([l, uR], desc: l.disbursedon_date)
    |> compose_clients_loan_portfolio()
  end

  defp compose_clients_loan_portfolio(query) do
    query
    # |> where([a], a.studentInfosStatus == "Student")

    |> join(:left, [l], uR in Loanmanagementsystem.Accounts.UserRole,
      on: l.customer_id == uR.userId
    )
    |> where([l, uR], l.loan_status != "REJECTED")
    |> group_by([l, uR], [uR.roleType, l.loan_status, l.disbursedon_date])
    |> select([l, uR], %{
      roleType: uR.roleType,
      loan_status: l.loan_status,
      disbursedon_date: l.disbursedon_date,
      principal_amount: sum(l.principal_amount),
      principal_repaid: sum(l.principal_repaid_derived),
      principal_outstanding: sum(l.principal_outstanding_derived),
      interest_outstanding: sum(l.interest_outstanding_derived),
      total_expected_repayment: sum(l.total_expected_repayment_derived)
    })
  end

  # Loanmanagementsystem.Loan.employer_employee_loans_list(nil, 1, 10, 1, "DISBURSED")

  def employer_employee_loans_list(search_params, page, size, companyId, status) do
    Loans
    # |> handle_customer_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_employee_loans_list(companyId, status)
    |> Repo.paginate(page: page, page_size: size)
  end

  def employer_employee_loans_list(_source, search_params, companyId, status) do
    Loans
    # |> handle_customer_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_employee_loans_list(companyId, status)
  end

  defp compose_employee_loans_list(query, companyId, status) do
    query
    # |> where([a], a.studentInfosStatus == "Student")

    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cA in Loanmanagementsystem.Accounts.Customer_account,
      on: l.customer_id == cA.user_id
    )
    |> join(:left, [l, uB, p, cA], comp in Loanmanagementsystem.Companies.Company,
      on: l.company_id == comp.id
    )
    |> where([l, uB, p, cA, comp], l.company_id == ^companyId and l.loan_status == ^status)
    |> select([l, uB, p, cA, comp], %{
      id: l.id,
      company_name: comp.companyName,
      loan_id: l.id,
      loan_account_no: cA.account_number,
      customer_principal_amount:
        fragment("concat(?, concat(' ', ?))", l.currency_code, l.principal_amount),
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      customer_identification_number:
        fragment(
          "concat(?, concat(' - ', ?))",
          uB.meansOfIdentificationType,
          uB.meansOfIdentificationNumber
        ),
      principal_repaid_derived: l.principal_repaid_derived,
      number_of_repayments: l.number_of_repayments,
      withdrawnon_date: l.withdrawnon_date,
      currency_code: l.currency_code,
      is_npa: l.is_npa,
      repay_every_type: l.repay_every_type,
      principal_writtenoff_derived: l.principal_writtenoff_derived,
      disbursedon_userid: l.disbursedon_userid,
      approvedon_userid: l.approvedon_userid,
      total_writtenoff_derived: l.total_writtenoff_derived,
      repay_every: l.repay_every,
      closedon_userid: l.closedon_userid,
      product_id: l.product_id,
      customer_id: l.customer_id,
      interest_method: l.interest_method,
      annual_nominal_interest_rate: l.annual_nominal_interest_rate,
      writtenoffon_date: l.writtenoffon_date,
      total_outstanding_derived: l.total_outstanding_derived,
      interest_calculated_from_date: l.interest_calculated_from_date,
      loan_counter: l.loan_counter,
      interest_charged_derived: l.interest_charged_derived,
      term_frequency_type: l.term_frequency_type,
      total_charges_due_at_disbursement_derived: l.total_charges_due_at_disbursement_derived,
      penalty_charges_waived_derived: l.penalty_charges_waived_derived,
      total_overpaid_derived: l.total_overpaid_derived,
      approved_principal: l.approved_principal,
      principal_disbursed_derived: l.principal_disbursed_derived,
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      interest_outstanding_derived: l.interest_outstanding_derived,
      interest_writtenoff_derived: l.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: l.penalty_charges_writtenoff_derived,
      loan_status: l.loan_status,
      fee_charges_charged_derived: l.fee_charges_charged_derived,
      fee_charges_waived_derived: l.fee_charges_waived_derived,
      interest_waived_derived: l.interest_waived_derived,
      total_costofloan_derived: l.total_costofloan_derived,
      principal_amount_proposed: l.principal_amount_proposed,
      fee_charges_repaid_derived: l.fee_charges_repaid_derived,
      total_expected_repayment_derived: l.total_expected_repayment_derived,
      principal_outstanding_derived: l.principal_outstanding_derived,
      penalty_charges_charged_derived: l.penalty_charges_charged_derived,
      is_legacyloan: l.is_legacyloan,
      total_waived_derived: l.total_waived_derived,
      interest_repaid_derived: l.interest_repaid_derived,
      rejectedon_date: l.rejectedon_date,
      fee_charges_outstanding_derived: l.fee_charges_outstanding_derived,
      expected_disbursedon_date: l.expected_disbursedon_date,
      closedon_date: l.closedon_date,
      fee_charges_writtenoff_derived: l.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: l.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: l.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: l.penalty_charges_repaid_derived,
      withdrawnon_userid: l.withdrawnon_userid,
      expected_maturity_date: l.expected_maturity_date,
      external_id: l.external_id,
      term_frequency: l.term_frequency,
      total_repayment_derived: l.total_repayment_derived,
      loan_identity_number: l.loan_identity_number,
      branch_id: l.branch_id,
      status: l.status,
      app_user_id: l.app_user_id,
      mobile_money_response: l.mobile_money_response,
      total_principal_repaid: l.total_principal_repaid,
      total_interest_repaid: l.total_interest_repaid,
      total_charges_repaid: l.total_charges_repaid,
      total_penalties_repaid: l.total_penalties_repaid,
      total_repaid: l.total_repaid,
      momoProvider: l.momoProvider,
      company_id: l.company_id,
      loan_userroleid: l.loan_userroleid,
      disbursement_method: l.disbursement_method,
      bank_name: l.bank_name,
      bank_account_no: l.bank_account_no,
      account_name: l.account_name,
      bevura_wallet_no: l.bevura_wallet_no,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.inserted_at,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      title: uB.title,
      userId: uB.userId,
      idNo: uB.idNo,
      clientId: p.clientId,
      product_code: p.code,
      currencyDecimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currencyName: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,
      maximumPrincipal: p.maximumPrincipal,
      minimumPrincipal: p.minimumPrincipal,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      principle_account_id: p.principle_account_id,
      interest_account_id: p.interest_account_id,
      charges_account_id: p.charges_account_id,
      classification_id: p.classification_id
    })
  end

  def all_employer_employee_loans_list(search_params, page, size, companyId) do
    Loans
    |> handle_employer_employee_report_filter(search_params)
    |> order_by([l, uB, p, cA, comp], desc: l.inserted_at)
    |> compose_all_employee_loans_list(companyId)
    |> Repo.paginate(page: page, page_size: size)
  end

  def all_employer_employee_loans_list(_source, search_params, companyId) do
    Loans
    |> handle_employer_employee_report_filter(search_params)
    |> order_by([l, uB, p, cA, comp], desc: l.inserted_at)
    |> compose_all_employee_loans_list(companyId)
  end

  defp handle_employer_employee_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_emp_first_name_filter(search_params)
    |> handle_emp_last_name_filter(search_params)
    |> handle_emp_id_number_filter(search_params)
    |> handle_emp_phone_number_filter(search_params)
    |> handle_loan_date_filter(search_params)
  end

  defp handle_employer_employee_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_employer_employee_loans_isearch_filter(query, search_term)
  end

  defp handle_emp_first_name_filter(query, %{"emp_first_name" => emp_first_name}) do
    where(
      query,
      [l, uB, p, cA, comp],
      fragment("lower(?) LIKE lower(?)", uB.firstName, ^"%#{emp_first_name}%")
    )
  end

  defp handle_emp_first_name_filter(query, %{"emp_first_name" => emp_first_name})
       when emp_first_name == "" or is_nil(emp_first_name),
       do: query

  defp handle_emp_last_name_filter(query, %{"emp_last_name" => emp_last_name}) do
    where(
      query,
      [l, uB, p, cA, comp],
      fragment("lower(?) LIKE lower(?)", uB.lastName, ^"%#{emp_last_name}%")
    )
  end

  defp handle_emp_last_name_filter(query, %{"emp_last_name" => emp_last_name})
       when emp_last_name == "" or is_nil(emp_last_name),
       do: query

  defp handle_emp_id_number_filter(query, %{"emp_id_number" => emp_id_number}) do
    where(
      query,
      [l, uB, p, cA, comp],
      fragment("lower(?) LIKE lower(?)", uB.meansOfIdentificationNumber, ^"%#{emp_id_number}%")
    )
  end

  defp handle_emp_phone_number_filter(query, %{"emp_phone_number" => emp_phone_number})
       when emp_phone_number == "" or is_nil(emp_phone_number),
       do: query

  defp handle_emp_phone_number_filter(query, %{"emp_phone_number" => emp_phone_number}) do
    where(
      query,
      [l, uB, p, cA, comp],
      fragment("lower(?) LIKE lower(?)", uB.mobileNumber, ^"%#{emp_phone_number}%")
    )
  end

  defp handle_emp_id_number_filter(query, %{"emp_id_number" => emp_id_number})
       when emp_id_number == "" or is_nil(emp_id_number),
       do: query

  defp handle_loan_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l, uB, p, cA, comp],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.inserted_at, ^to)
    )
  end

  defp handle_loan_date_filter(query, _params), do: query

  defp compose_employer_employee_loans_isearch_filter(query, search_term) do
    query
    |> where(
      [l, uB, p, cA, comp],
      fragment("lower(?) LIKE lower(?)", uB.firstName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", uB.lastName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", uB.meansOfIdentificationNumber, ^search_term) or
        fragment("lower(?) LIKE lower(?)", uB.mobileNumber, ^search_term) or
        fragment("lower(?) LIKE lower(?)", l.inserted_at, ^search_term)
    )
  end

  defp compose_all_employee_loans_list(query, companyId) do
    query
    # |> where([a], a.studentInfosStatus == "Student")

    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cA in Loanmanagementsystem.Accounts.Customer_account,
      on: l.customer_id == cA.user_id
    )
    |> join(:left, [l, uB, p, cA], comp in Loanmanagementsystem.Companies.Company,
      on: l.company_id == comp.id
    )
    |> where([l, uB, p, cA, comp], l.company_id == ^companyId)
    |> select([l, uB, p, cA, comp], %{
      id: l.id,
      company_name: comp.companyName,
      loan_id: l.id,
      loan_account_no: cA.account_number,
      customer_principal_amount:
        fragment("concat(?, concat(' ', ?))", l.currency_code, l.principal_amount),
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      customer_identification_number:
        fragment(
          "concat(?, concat(' - ', ?))",
          uB.meansOfIdentificationType,
          uB.meansOfIdentificationNumber
        ),
      principal_repaid_derived: l.principal_repaid_derived,
      number_of_repayments: l.number_of_repayments,
      withdrawnon_date: l.withdrawnon_date,
      currency_code: l.currency_code,
      is_npa: l.is_npa,
      repay_every_type: l.repay_every_type,
      principal_writtenoff_derived: l.principal_writtenoff_derived,
      disbursedon_userid: l.disbursedon_userid,
      approvedon_userid: l.approvedon_userid,
      total_writtenoff_derived: l.total_writtenoff_derived,
      repay_every: l.repay_every,
      closedon_userid: l.closedon_userid,
      product_id: l.product_id,
      customer_id: l.customer_id,
      interest_method: l.interest_method,
      annual_nominal_interest_rate: l.annual_nominal_interest_rate,
      writtenoffon_date: l.writtenoffon_date,
      total_outstanding_derived: l.total_outstanding_derived,
      interest_calculated_from_date: l.interest_calculated_from_date,
      loan_counter: l.loan_counter,
      interest_charged_derived: l.interest_charged_derived,
      term_frequency_type: l.term_frequency_type,
      total_charges_due_at_disbursement_derived: l.total_charges_due_at_disbursement_derived,
      penalty_charges_waived_derived: l.penalty_charges_waived_derived,
      total_overpaid_derived: l.total_overpaid_derived,
      approved_principal: l.approved_principal,
      principal_disbursed_derived: l.principal_disbursed_derived,
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      interest_outstanding_derived: l.interest_outstanding_derived,
      interest_writtenoff_derived: l.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: l.penalty_charges_writtenoff_derived,
      loan_status: l.loan_status,
      fee_charges_charged_derived: l.fee_charges_charged_derived,
      fee_charges_waived_derived: l.fee_charges_waived_derived,
      interest_waived_derived: l.interest_waived_derived,
      total_costofloan_derived: l.total_costofloan_derived,
      principal_amount_proposed: l.principal_amount_proposed,
      fee_charges_repaid_derived: l.fee_charges_repaid_derived,
      total_expected_repayment_derived: l.total_expected_repayment_derived,
      principal_outstanding_derived: l.principal_outstanding_derived,
      penalty_charges_charged_derived: l.penalty_charges_charged_derived,
      is_legacyloan: l.is_legacyloan,
      total_waived_derived: l.total_waived_derived,
      interest_repaid_derived: l.interest_repaid_derived,
      rejectedon_date: l.rejectedon_date,
      fee_charges_outstanding_derived: l.fee_charges_outstanding_derived,
      expected_disbursedon_date: l.expected_disbursedon_date,
      closedon_date: l.closedon_date,
      fee_charges_writtenoff_derived: l.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: l.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: l.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: l.penalty_charges_repaid_derived,
      withdrawnon_userid: l.withdrawnon_userid,
      expected_maturity_date: l.expected_maturity_date,
      external_id: l.external_id,
      term_frequency: l.term_frequency,
      total_repayment_derived: l.total_repayment_derived,
      loan_identity_number: l.loan_identity_number,
      branch_id: l.branch_id,
      status: l.status,
      app_user_id: l.app_user_id,
      mobile_money_response: l.mobile_money_response,
      total_principal_repaid: l.total_principal_repaid,
      total_interest_repaid: l.total_interest_repaid,
      total_charges_repaid: l.total_charges_repaid,
      total_penalties_repaid: l.total_penalties_repaid,
      total_repaid: l.total_repaid,
      momoProvider: l.momoProvider,
      company_id: l.company_id,
      loan_userroleid: l.loan_userroleid,
      disbursement_method: l.disbursement_method,
      bank_name: l.bank_name,
      bank_account_no: l.bank_account_no,
      account_name: l.account_name,
      bevura_wallet_no: l.bevura_wallet_no,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.inserted_at,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      title: uB.title,
      userId: uB.userId,
      idNo: uB.idNo,
      clientId: p.clientId,
      product_code: p.code,
      currencyDecimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currencyName: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,
      maximumPrincipal: p.maximumPrincipal,
      minimumPrincipal: p.minimumPrincipal,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      principle_account_id: p.principle_account_id,
      interest_account_id: p.interest_account_id,
      charges_account_id: p.charges_account_id,
      classification_id: p.classification_id
    })
  end

  ########################################## RUSSKAY ####################################


  # --------------------------------------------------miz---------------------loan apraisal look up start-----------------

  # Loanmanagementsystem.Loan.customer_loans_list(nil, 1, 10)

  def customer_loan_apraisals_list(search_params, page, size, userId) do
    Loans
    # |> handle_customer_loan_apraisals_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_customer_loan_apraisals_list(userId)
    |> Repo.paginate(page: page, page_size: size)
  end

  def customer_loan_apraisals_list(_source, search_params, userId) do
    Loans
    # |> handle_customer_loan_apraisals_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_customer_loan_apraisals_list(userId)
  end

  defp compose_customer_loan_apraisals_list(query, userId) do
    query
    # |> where([a], a.studentInfosStatus == "Student")

    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> where([l, uB, p], uB.userId == ^userId)
    |> select([l, uB, p], %{
      loan_id: l.id,
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      principal_repaid_derived: l.principal_repaid_derived,
      number_of_repayments: l.number_of_repayments,
      withdrawnon_date: l.withdrawnon_date,
      currency_code: l.currency_code,
      is_npa: l.is_npa,
      repay_every_type: l.repay_every_type,
      principal_writtenoff_derived: l.principal_writtenoff_derived,
      disbursedon_userid: l.disbursedon_userid,
      approvedon_userid: l.approvedon_userid,
      total_writtenoff_derived: l.total_writtenoff_derived,
      repay_every: l.repay_every,
      closedon_userid: l.closedon_userid,
      product_id: l.product_id,
      customer_id: l.customer_id,
      interest_method: l.interest_method,
      annual_nominal_interest_rate: l.annual_nominal_interest_rate,
      writtenoffon_date: l.writtenoffon_date,
      total_outstanding_derived: l.total_outstanding_derived,
      interest_calculated_from_date: l.interest_calculated_from_date,
      loan_counter: l.loan_counter,
      interest_charged_derived: l.interest_charged_derived,
      term_frequency_type: l.term_frequency_type,
      total_charges_due_at_disbursement_derived: l.total_charges_due_at_disbursement_derived,
      penalty_charges_waived_derived: l.penalty_charges_waived_derived,
      total_overpaid_derived: l.total_overpaid_derived,
      approved_principal: l.approved_principal,
      principal_disbursed_derived: l.principal_disbursed_derived,
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      interest_outstanding_derived: l.interest_outstanding_derived,
      interest_writtenoff_derived: l.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: l.penalty_charges_writtenoff_derived,
      loan_status: l.loan_status,
      fee_charges_charged_derived: l.fee_charges_charged_derived,
      fee_charges_waived_derived: l.fee_charges_waived_derived,
      interest_waived_derived: l.interest_waived_derived,
      total_costofloan_derived: l.total_costofloan_derived,
      principal_amount_proposed: l.principal_amount_proposed,
      fee_charges_repaid_derived: l.fee_charges_repaid_derived,
      total_expected_repayment_derived: l.total_expected_repayment_derived,
      principal_outstanding_derived: l.principal_outstanding_derived,
      penalty_charges_charged_derived: l.penalty_charges_charged_derived,
      is_legacyloan: l.is_legacyloan,
      total_waived_derived: l.total_waived_derived,
      interest_repaid_derived: l.interest_repaid_derived,
      rejectedon_date: l.rejectedon_date,
      fee_charges_outstanding_derived: l.fee_charges_outstanding_derived,
      expected_disbursedon_date: l.expected_disbursedon_date,
      closedon_date: l.closedon_date,
      fee_charges_writtenoff_derived: l.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: l.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: l.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: l.penalty_charges_repaid_derived,
      withdrawnon_userid: l.withdrawnon_userid,
      expected_maturity_date: l.expected_maturity_date,
      external_id: l.external_id,
      term_frequency: l.term_frequency,
      total_repayment_derived: l.total_repayment_derived,
      loan_identity_number: l.loan_identity_number,
      branch_id: l.branch_id,
      status: l.status,
      app_user_id: l.app_user_id,
      mobile_money_response: l.mobile_money_response,
      total_principal_repaid: l.total_principal_repaid,
      total_interest_repaid: l.total_interest_repaid,
      total_charges_repaid: l.total_charges_repaid,
      total_penalties_repaid: l.total_penalties_repaid,
      total_repaid: l.total_repaid,
      momoProvider: l.momoProvider,
      company_id: l.company_id,
      loan_userroleid: l.loan_userroleid,
      disbursement_method: l.disbursement_method,
      bank_name: l.bank_name,
      bank_account_no: l.bank_account_no,
      account_name: l.account_name,
      bevura_wallet_no: l.bevura_wallet_no,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.inserted_at,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      title: uB.title,
      userId: uB.userId,
      idNo: uB.idNo,
      clientId: p.clientId,
      code: p.code,
      currencyDecimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currencyName: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,
      maximumPrincipal: p.maximumPrincipal,
      minimumPrincipal: p.minimumPrincipal,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      principle_account_id: p.principle_account_id,
      interest_account_id: p.interest_account_id,
      charges_account_id: p.charges_account_id,
      classification_id: p.classification_id
    })
  end

  defp handle_customer_loan_apraisals_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_customer_loans_isearch_filter(query, search_term)
  end

  #   defp handle_customer_loans_filter(query, %{"isearch" => search_term} = search_params)
  #   when search_term == "" or is_nil(search_term) do
  #   query

  #     |> handle_customer_first_name_filter(search_params)
  #     |> handle_customer_last_name_filter(search_params)
  #     |> handle_product_name_filter(search_params)
  #     |> handle_minimum_principal_filter(search_params)
  #     |> handle_maximum_principal_filter(search_params)
  #     |> handle_product_type_filter(search_params)
  #     |> handle_created_date_filter(search_params)

  # end



   # Loanmanagementsystem.Loan.customer_loans_list(nil, 1, 10)
 # Loanmanagementsystem.Loan.customer_loan_user_item_lookup(nil, 1, 10)


  def customer_loan_user_item_lookup(search_params, page, size, userId) do
    UserBioData
    |> order_by([uB, rM], desc: uB.inserted_at)
    |> compose_customer_loan_user_item_lookup(userId)
    |> Repo.paginate(page: page, page_size: size)
  end

  def customer_loan_user_item_lookup(_source, search_params, userId) do
    UserBioData
    |> order_by([uB, rM], desc: uB.inserted_at)
    |> compose_customer_loan_user_item_lookup(userId)
  end

  defp compose_customer_loan_user_item_lookup(query, userId) do
    query
    |> join(:left, [uB], rM in Customer_account, on: uB.userId == rM.user_id)
    |> where([uB, rM], rM.loan_officer_id == ^userId)
    |> select([uB, rM], %{
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      assignment_date: rM.assignment_date
    })
  end

  defp handle_customer_loan_user_item_lookup_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_customer_loans_isearch_filter(query, search_term)
  end

  # Loanmanagementsystem.Loan.count_disbursed_loans()

  def count_disbursed_loans() do
    datetime = DateTime.utc_now()
    Loans
    |> where(
      [l], l.loan_status == "Disbursed"
    )
    |> select([l], %{
      principal_amount: sum(l.principal_amount)
    })
    |> Repo.one()
  end


  def count_pending_loans() do
    datetime = DateTime.utc_now()
    Loans
    |> where(
      [l], l.loan_status == "PENDING"
    )
    |> select([l], %{
      principal_amount: sum(l.principal_amount)
    })
    |> Repo.one()
  end


  # ---------------------------------loan apraisal end---------------------------------------------------------------------

  alias Loanmanagementsystem.Loan.Loan_application_documents

  @doc """
  Returns the list of tbl_loan_application_documents.

  ## Examples

      iex> list_tbl_loan_application_documents()
      [%Loan_application_documents{}, ...]

  """
  def list_tbl_loan_application_documents do
    Repo.all(Loan_application_documents)
  end

  @doc """
  Gets a single loan_application_documents.

  Raises `Ecto.NoResultsError` if the Loan application documents does not exist.

  ## Examples

      iex> get_loan_application_documents!(123)
      %Loan_application_documents{}

      iex> get_loan_application_documents!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_application_documents!(id), do: Repo.get!(Loan_application_documents, id)

  @doc """
  Creates a loan_application_documents.

  ## Examples

      iex> create_loan_application_documents(%{field: value})
      {:ok, %Loan_application_documents{}}

      iex> create_loan_application_documents(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_application_documents(attrs \\ %{}) do
    %Loan_application_documents{}
    |> Loan_application_documents.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_application_documents.

  ## Examples

      iex> update_loan_application_documents(loan_application_documents, %{field: new_value})
      {:ok, %Loan_application_documents{}}

      iex> update_loan_application_documents(loan_application_documents, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_application_documents(%Loan_application_documents{} = loan_application_documents, attrs) do
    loan_application_documents
    |> Loan_application_documents.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_application_documents.

  ## Examples

      iex> delete_loan_application_documents(loan_application_documents)
      {:ok, %Loan_application_documents{}}

      iex> delete_loan_application_documents(loan_application_documents)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_application_documents(%Loan_application_documents{} = loan_application_documents) do
    Repo.delete(loan_application_documents)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_application_documents changes.

  ## Examples

      iex> change_loan_application_documents(loan_application_documents)
      %Ecto.Changeset{data: %Loan_application_documents{}}

  """
  def change_loan_application_documents(%Loan_application_documents{} = loan_application_documents, attrs \\ %{}) do
    Loan_application_documents.changeset(loan_application_documents, attrs)
  end

  def active_loans_employer_lookup(search_params, page, size) do
    Loans
    |> handle_active_loans_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_active_loans_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def active_loans_employer_lookup(_source, search_params) do
    Loans
    |> handle_active_loans_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_active_loans_select()
  end

  defp compose_active_loans_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> where([l, uB, uC], uB.roleType == "EMPLOYER")
    |> select(
      [l, uB, uC],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName
      }
    )
  end

  defp handle_active_loans_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_disbursedon_date_loans_filter(search_params)
  end

  defp handle_disbursedon_date_loans_filter(query, %{"from" => from, "to" => to, "role_type" => role_type})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l, uB, uD],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^from) and
      fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^to) and
      fragment("lower(?) LIKE lower(?)", uB.roleType, ^role_type)
    )
  end
  defp handle_disbursedon_date_loans_filter(query, _params), do: query


  def active_loans_product_lookup(search_params, page, size) do
    Loans
    |> handle_active_loans_product_filter(search_params)
    |> order_by([l, uB, uC, uD], desc: l.inserted_at)
    |> compose_active_loans_product_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def active_loans_product_lookup(_source, search_params) do
    Loans
    |> handle_active_loans_product_filter(search_params)
    |> order_by([l, uB, uC, uD], desc: l.inserted_at)
    |> compose_active_loans_product_select()
  end

  defp compose_active_loans_product_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> join(:left, [l], uD in Product, on: l.product_id == uD.id)
    # |> where([l, uB, uC uD], l.loan_type == "EMPLOYER")
    |> select(
      [l, uB, uC, uD],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        productType: uD.productType
      }
    )
  end

  defp handle_active_loans_product_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_disbursedon_date_loans_product_filter(search_params)
  end

  defp handle_disbursedon_date_loans_product_filter(query, %{"from" => from, "to" => to, "loan_product" => loan_product})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l, uB, uD],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^from) and
      fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^to) and
      fragment("lower(?) LIKE lower(?)", l.loan_type, ^loan_product)
    )
  end
  defp handle_disbursedon_date_loans_product_filter(query, _params), do: query


  def active_loans_emoney_lookup(search_params, page, size) do
    Loans
    |> handle_active_loans_emoney_filter(search_params)
    |> order_by([l, uB, uC, uD], desc: l.inserted_at)
    |> compose_active_loans_emoney_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def active_loans_emoney_lookup(_source, search_params) do
    Loans
    |> handle_active_loans_emoney_filter(search_params)
    |> order_by([l, uB, uC, uD], desc: l.inserted_at)
    |> compose_active_loans_emoney_select()
  end

  defp compose_active_loans_emoney_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> join(:left, [l], uD in Merchant, on: l.customer_id == uD.createdByUserId)
    # |> where([l, uB, uC uD], l.loan_type == "EMPLOYER")
    |> select(
      [l, uB, uC, uD],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        companyName: uD.companyName,
        taxno: uD.taxno
      }
    )
  end

  defp handle_active_loans_emoney_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_taxno_emoney_filter(search_params)
  end

  defp handle_taxno_emoney_filter(query, %{"company" => company, "taxno" => taxno})
       when byte_size(company) > 0 and byte_size(taxno) > 0 do
    query
    |> where(
      [l, uB, uC, uD],
      fragment("lower(?) LIKE lower(?)", uD.companyName, ^company)and
      fragment("lower(?) LIKE lower(?)", uD.taxno, ^taxno)
    )
  end
  defp handle_taxno_emoney_filter(query, _params), do: query


  def loan_pending_approval_lookup(search_params, page, size) do
    Loans
    |> handle_pending_approval_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_pending_approval_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def loan_pending_approval_lookup(_source, search_params) do
    Loans
    |> handle_pending_approval_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_pending_approval_select()
  end

  defp compose_pending_approval_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> where([l, uB, uC], l.loan_status == "PENDING_APPROVAL")
    |> select(
      [l, uB, uC],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName
      }
    )
  end

  defp handle_pending_approval_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_pending_approval_type_filter(search_params)
    |> handle_loan_pending_approval_fname_filter(search_params)
    |> handle_loan_pending_approval_lname_filter(search_params)
    |> handle_loan_pending_approval_amount_filter(search_params)
  end

  defp handle_loan_pending_approval_type_filter(query, %{"loan_type" => loan_type})
       when byte_size(loan_type) > 0 and byte_size(loan_type) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", l.loan_type, ^loan_type)
    )
  end
  defp handle_loan_pending_approval_type_filter(query, _params), do: query

  defp handle_loan_pending_approval_fname_filter(query, %{"f_name" => f_name})
      when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_pending_approval_fname_filter(query, _params), do: query

  defp handle_loan_pending_approval_lname_filter(query, %{"l_name" => l_name})
      when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_pending_approval_lname_filter(query, _params), do: query

  defp handle_loan_pending_approval_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_pending_approval_amount_filter(query, _params), do: query


  def loan_offtaker_lookup(search_params, page, size) do
    Loans
    |> handle_offtaker_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_offtaker_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def loan_offtaker_lookup(_source, search_params) do
    Loans
    |> handle_offtaker_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_offtaker_select()
  end

  defp compose_offtaker_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> where([l, uB, uC], uB.roleType == "OFFTAKER")
    |> select(
      [l, uB, uC],
      %{
        id: l.id,
        role_id: uB.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        emailAddress: uC.emailAddress,
        meansOfIdentificationNumber: uC.meansOfIdentificationNumber,
        mobileNumber: uC.mobileNumber
      }
    )
  end

  defp handle_offtaker_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_offtaker_nrc_filter(search_params)
    |> handle_loan_offtaker_cell_filter(search_params)
    |> handle_loan_offtaker_fname_filter(search_params)
    |> handle_loan_offtaker_lname_filter(search_params)
  end

  defp handle_loan_offtaker_nrc_filter(query, %{"nrc" => nrc})
       when byte_size(nrc) > 0 and byte_size(nrc) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.meansOfIdentificationNumber, ^nrc)
    )
       end
  defp handle_loan_offtaker_nrc_filter(query, _params), do: query

  defp handle_loan_offtaker_cell_filter(query, %{"cell" => cell})
       when byte_size(cell) > 0 and byte_size(cell) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.mobileNumber, ^cell)
    )
  end
  defp handle_loan_offtaker_cell_filter(query, _params), do: query

  defp handle_loan_offtaker_fname_filter(query, %{"f_name" => f_name})
       when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_offtaker_fname_filter(query, _params), do: query

  defp handle_loan_offtaker_lname_filter(query, %{"l_name" => l_name})
       when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_offtaker_lname_filter(query, _params), do: query


  def loan_client_summary_lookup(search_params, page, size) do
    Loans
    |> handle_client_summary_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_client_summary_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def loan_client_summary_lookup(_source, search_params) do
    Loans
    |> handle_client_summary_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_client_summary_select()
  end

  defp compose_client_summary_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    # |> where([l, uB, uC], uB.roleType == "OFFTAKER")
    |> select(
      [l, uB, uC],
      %{
        id: l.id,
        role_id: uB.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        emailAddress: uC.emailAddress,
        meansOfIdentificationNumber: uC.meansOfIdentificationNumber,
        mobileNumber: uC.mobileNumber
      }
    )
  end

  defp handle_client_summary_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_summary_nrc_filter(search_params)
    |> handle_loan_summary_cell_filter(search_params)
    |> handle_loan_summary_fname_filter(search_params)
    |> handle_loan_summary_lname_filter(search_params)
    |> handle_loan_summary_amount_filter(search_params)
  end

  defp handle_loan_summary_nrc_filter(query, %{"nrc" => nrc})
       when byte_size(nrc) > 0 and byte_size(nrc) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.meansOfIdentificationNumber, ^nrc)
    )
       end
  defp handle_loan_summary_nrc_filter(query, _params), do: query

  defp handle_loan_summary_cell_filter(query, %{"cell" => cell})
       when byte_size(cell) > 0 and byte_size(cell) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.mobileNumber, ^cell)
    )
  end
  defp handle_loan_summary_cell_filter(query, _params), do: query

  defp handle_loan_summary_fname_filter(query, %{"f_name" => f_name})
       when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_summary_fname_filter(query, _params), do: query

  defp handle_loan_summary_lname_filter(query, %{"l_name" => l_name})
       when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_summary_lname_filter(query, _params), do: query

  defp handle_loan_summary_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_summary_amount_filter(query, _params), do: query



  def loan_waiting_disbursement_lookup(search_params, page, size) do
    Loans
    |> handle_waiting_disbursement_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_waiting_disbursement_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def loan_waiting_disbursement_lookup(_source, search_params) do
    Loans
    |> handle_waiting_disbursement_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_waiting_disbursement_select()
  end

  defp compose_waiting_disbursement_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> where([l, uB, uC], is_nil(l.disbursedon_date))
    |> select(
      [l, uB, uC],
      %{
        id: l.id,
        role_id: uB.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        emailAddress: uC.emailAddress,
        meansOfIdentificationNumber: uC.meansOfIdentificationNumber,
        mobileNumber: uC.mobileNumber
      }
    )
  end

  defp handle_waiting_disbursement_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_disbursement_nrc_filter(search_params)
    |> handle_loan_disbursement_cell_filter(search_params)
    |> handle_loan_disbursement_fname_filter(search_params)
    |> handle_loan_disbursement_lname_filter(search_params)
    |> handle_loan_disbursement_loan_type_filter(search_params)
    |> handle_loan_disbursement_amount_filter(search_params)
  end

  defp handle_loan_disbursement_nrc_filter(query, %{"nrc" => nrc})
       when byte_size(nrc) > 0 and byte_size(nrc) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.meansOfIdentificationNumber, ^nrc)
    )
       end
  defp handle_loan_disbursement_nrc_filter(query, _params), do: query

  defp handle_loan_disbursement_cell_filter(query, %{"cell" => cell})
       when byte_size(cell) > 0 and byte_size(cell) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.mobileNumber, ^cell)
    )
  end
  defp handle_loan_disbursement_cell_filter(query, _params), do: query

  defp handle_loan_disbursement_fname_filter(query, %{"f_name" => f_name})
       when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_disbursement_fname_filter(query, _params), do: query

  defp handle_loan_disbursement_lname_filter(query, %{"l_name" => l_name})
       when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_disbursement_lname_filter(query, _params), do: query

  defp handle_loan_disbursement_loan_type_filter(query, %{"loan_type" => loan_type})
       when byte_size(loan_type) > 0 and byte_size(loan_type) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.loan_type, ^loan_type)
    )
  end
  defp handle_loan_disbursement_loan_type_filter(query, _params), do: query

  defp handle_loan_disbursement_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_disbursement_amount_filter(query, _params), do: query


  def loan_sol_brunch_lookup(search_params, page, size) do
    Loans
    |> handle_sol_brunch_filter(search_params)
    |> order_by([l, uB, uC, uD], desc: l.inserted_at)
    |> compose_sol_brunch_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def loan_sol_brunch_lookup(_source, search_params) do
    Loans
    |> handle_sol_brunch_filter(search_params)
    |> order_by([l, uB, uC, uD], desc: l.inserted_at)
    |> compose_sol_brunch_select()
  end

  defp compose_sol_brunch_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> join(:left, [l], uD in Branch, on: l.customer_id == uD.clientId)
    |> where([l, uB, uC, uD], uD.status == "ACTIVE")
    |> select(
      [l, uB, uC, uD],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        balance: l.balance,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        branchName: uD.branchName
      }
    )
  end

  defp handle_sol_brunch_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_sol_brunch_type_filter(search_params)
    |> handle_loan_sol_brunch_fname_filter(search_params)
    |> handle_loan_sol_brunch_lname_filter(search_params)
    |> handle_loan_sol_brunch_amount_filter(search_params)
    |> handle_loan_sol_brunch_name_filter(search_params)
  end

  defp handle_loan_sol_brunch_type_filter(query, %{"loan_type" => loan_type})
       when byte_size(loan_type) > 0 and byte_size(loan_type) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", l.loan_type, ^loan_type)
    )
  end
  defp handle_loan_sol_brunch_type_filter(query, _params), do: query

  defp handle_loan_sol_brunch_fname_filter(query, %{"f_name" => f_name})
      when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_sol_brunch_fname_filter(query, _params), do: query

  defp handle_loan_sol_brunch_lname_filter(query, %{"l_name" => l_name})
      when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_sol_brunch_lname_filter(query, _params), do: query

  defp handle_loan_sol_brunch_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_sol_brunch_amount_filter(query, _params), do: query

  defp handle_loan_sol_brunch_name_filter(query, %{"branch" => branch})
       when byte_size(branch) > 0 and byte_size(branch) > 0 do
    query
    |> where(
      [l, uB, uC, uD],
      fragment("lower(?) LIKE lower(?)", uD.branchName, ^branch)
    )
  end
  defp handle_loan_sol_brunch_name_filter(query, _params), do: query


  def loan_balance_lookup(search_params, page, size) do
    Loans
    |> handle_balance_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_balance_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def loan_balance_lookup(_source, search_params) do
    Loans
    |> handle_balance_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_balance_select()
  end

  defp compose_balance_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    # |> where([l, uB, uC, uD], uD.status == "ACTIVE")
    |> select(
      [l, uB, uC],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        balance: l.balance,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName
      }
    )
  end

  defp handle_balance_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_balance_fname_filter(search_params)
    |> handle_loan_balance_lname_filter(search_params)
    |> handle_loan_balance_amount_filter(search_params)
    |> handle_loan_balance_type_filter(search_params)
    |> handle_disbursedon_date_balance_filter(search_params)
  end

  defp handle_loan_balance_fname_filter(query, %{"f_name" => f_name})
      when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_balance_fname_filter(query, _params), do: query

  defp handle_loan_balance_lname_filter(query, %{"l_name" => l_name})
      when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_balance_lname_filter(query, _params), do: query

  defp handle_loan_balance_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_balance_amount_filter(query, _params), do: query

  defp handle_loan_balance_type_filter(query, %{"loan_type" => loan_type})
       when byte_size(loan_type) > 0 and byte_size(loan_type) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", l.loan_type, ^loan_type)
    )
  end
  defp handle_loan_balance_type_filter(query, _params), do: query

  defp handle_disbursedon_date_balance_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l, uB, uD],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^from) and
      fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^to)
    )
  end
  defp handle_disbursedon_date_balance_filter(query, _params), do: query


  def loan_classification_product_lookup(search_params, page, size) do
    Loans
    |> handle_classification_product_filter(search_params)
    |> order_by([l, uB, uC, uD], desc: l.inserted_at)
    |> compose_classification_product_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def loan_classification_product_lookup(_source, search_params) do
    Loans
    |> handle_classification_product_filter(search_params)
    |> order_by([l, uB, uC, uD], desc: l.inserted_at)
    |> compose_classification_product_select()
  end

  defp compose_classification_product_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> join(:left, [l], uD in Branch, on: l.customer_id == uD.clientId)
    # |> where([l, uB, uC, uD], uD.status == "ACTIVE")
    |> select(
      [l, uB, uC, uD],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        balance: l.balance,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        branchName: uD.branchName
      }
    )
  end

  defp handle_classification_product_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_classification_product_type_filter(search_params)
    |> handle_loan_classification_product_fname_filter(search_params)
    |> handle_loan_classification_product_lname_filter(search_params)
    |> handle_loan_classification_product_amount_filter(search_params)
    |> handle_loan_sol_brunch_name_filter(search_params)
  end

  defp handle_loan_classification_product_type_filter(query, %{"loan_type" => loan_type})
       when byte_size(loan_type) > 0 and byte_size(loan_type) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(?) LIKE lower(?)", l.loan_type, ^loan_type)
    )
  end
  defp handle_loan_classification_product_type_filter(query, _params), do: query

  defp handle_loan_classification_product_fname_filter(query, %{"f_name" => f_name})
      when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_classification_product_fname_filter(query, _params), do: query

  defp handle_loan_classification_product_lname_filter(query, %{"l_name" => l_name})
      when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_classification_product_lname_filter(query, _params), do: query

  defp handle_loan_classification_product_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_classification_product_amount_filter(query, _params), do: query


  def active_loans_dvc_employer_lookup(search_params, page, size) do
    Loans
    |> handle_loans_dvc_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_dvc_loans_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def active_loans_dvc_employer_lookup(_source, search_params) do
    Loans
    |> handle_loans_dvc_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_dvc_loans_select()
  end

  defp compose_dvc_loans_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> where([l, uB, uC], uB.roleType == "EMPLOYER")
    |> select(
      [l, uB, uC],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        repayment_amount: l.repayment_amount,
        balance: l.balance,
        total_repayment_derived: l.total_repayment_derived,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName
      }
    )
  end

  defp handle_loans_dvc_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loans_dvc_date_employer_filter(search_params)
    |> handle_loans_dvc_loan_type_employer_filter(search_params)
    |> handle_loan_dvc_amount_filter(search_params)
    |> handle_loan_dvc_fname_filter(search_params)
    |> handle_loan_dvc_lname_filter(search_params)
  end

  defp handle_loans_dvc_date_employer_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l, uB, uD],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^from) and
      fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^to)
    )
  end
  defp handle_loans_dvc_date_employer_filter(query, _params), do: query

  defp handle_loans_dvc_loan_type_employer_filter(query, %{"loan_type" => loan_type})
       when byte_size(loan_type) > 0 and byte_size(loan_type) > 0 do
    query
    |> where(
      [l, uB, uD],
      fragment("lower(?) LIKE lower(?)", l.loan_type, ^loan_type)
    )
  end
  defp handle_loans_dvc_loan_type_employer_filter(query, _params), do: query

  defp handle_loan_dvc_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_dvc_amount_filter(query, _params), do: query

  defp handle_loan_dvc_fname_filter(query, %{"f_name" => f_name})
      when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_dvc_fname_filter(query, _params), do: query

  defp handle_loan_dvc_lname_filter(query, %{"l_name" => l_name})
      when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_dvc_lname_filter(query, _params), do: query


  def active_loans_dvc_emoney_lookup(search_params, page, size) do
    Loans
    |> handle_loans_dvc_emoney_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_dvc_emoney_loans_select()
    |> Repo.paginate(page: page, page_size: size)
  end
  def active_loans_dvc_emoney_lookup(_source, search_params) do
    Loans
    |> handle_loans_dvc_emoney_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_dvc_emoney_loans_select()
  end

  defp compose_dvc_emoney_loans_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> join(:left, [l], uD in Merchant, on: l.customer_id == uD.createdByUserId)
    |> where([l, uB, uC, uD], uB.roleType == "Merchant")
    |> select(
      [l, uB, uC, uD],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        repayment_amount: l.repayment_amount,
        balance: l.balance,
        total_repayment_derived: l.total_repayment_derived,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        companyName: uD.companyName,
        taxno: uD.taxno
      }
    )
  end

  defp handle_loans_dvc_emoney_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loans_dvc_date_emoney_filter(search_params)
    |> handle_loans_dvc_emoney_loan_type_employer_filter(search_params)
    |> handle_loan_dvc_emoney_amount_filter(search_params)
    |> handle_loan_dvc_amount_filter(search_params)
    |> handle_loan_dvc_emoney_fname_filter(search_params)
    |> handle_loan_dvc_emoney_lname_filter(search_params)
  end

  defp handle_loans_dvc_date_emoney_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l, uB, uD],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^from) and
      fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^to)
    )
  end
  defp handle_loans_dvc_date_emoney_filter(query, _params), do: query

  defp handle_loans_dvc_emoney_loan_type_employer_filter(query, %{"loan_type" => loan_type})
      when byte_size(loan_type) > 0 and byte_size(loan_type) > 0 do
    query
    |> where(
    [l, uB, uD],
    fragment("lower(?) LIKE lower(?)", l.loan_type, ^loan_type)
    )
  end
  defp handle_loans_dvc_emoney_loan_type_employer_filter(query, _params), do: query

  defp handle_loan_dvc_emoney_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_dvc_emoney_amount_filter(query, _params), do: query

  defp handle_loan_dvc_emoney_fname_filter(query, %{"f_name" => f_name})
      when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_dvc_emoney_fname_filter(query, _params), do: query

  defp handle_loan_dvc_emoney_lname_filter(query, %{"l_name" => l_name})
      when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_dvc_emoney_lname_filter(query, _params), do: query


  def active_loans_dvc_corporate_lookup(search_params, page, size) do
    Loans
    |> handle_loans_dvc_corporate_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_dvc_coporate_loans_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def active_loans_dvc_corporate_lookup(_source, search_params) do
    Loans
    |> handle_loans_dvc_corporate_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_dvc_coporate_loans_select()
  end

  defp compose_dvc_coporate_loans_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> join(:left, [l], uD in Company, on: l.customer_id == uD.createdByUserId)
    |> where([l, uB, uC, uD], uD.isSme == ^true or uD.isOfftaker == ^true)

    |> select(
      [l, uB, uC, uD],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        repayment_amount: l.repayment_amount,
        balance: l.balance,
        total_repayment_derived: l.total_repayment_derived,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        companyName: uD.companyName,
        taxno: uD.taxno
      }
    )
  end

  defp handle_loans_dvc_corporate_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loans_dvc_date_corporate_filter(search_params)
    |> handle_loans_dvc_corporate_loan_type_employer_filter(search_params)
    |> handle_loan_dvc_corporate_amount_filter(search_params)
    |> handle_loan_dvc_corporate_fname_filter(search_params)
    |> handle_loan_dvc_corporate_lname_filter(search_params)
  end

  defp handle_loans_dvc_date_corporate_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l, uB, uD],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^from) and
      fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^to)
    )
  end
  defp handle_loans_dvc_date_corporate_filter(query, _params), do: query

  defp handle_loans_dvc_corporate_loan_type_employer_filter(query, %{"loan_type" => loan_type})
      when byte_size(loan_type) > 0 and byte_size(loan_type) > 0 do
    query
    |> where(
    [l, uB, uD],
    fragment("lower(?) LIKE lower(?)", l.loan_type, ^loan_type)
    )
  end
  defp handle_loans_dvc_corporate_loan_type_employer_filter(query, _params), do: query

  defp handle_loan_dvc_corporate_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_dvc_corporate_amount_filter(query, _params), do: query

  defp handle_loan_dvc_corporate_fname_filter(query, %{"f_name" => f_name})
      when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_dvc_corporate_fname_filter(query, _params), do: query

  defp handle_loan_dvc_corporate_lname_filter(query, %{"l_name" => l_name})
      when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_dvc_corporate_lname_filter(query, _params), do: query


  def active_loans_corporate_buyer_lookup(search_params, page, size) do
    Loans
    |> handle_active_loans_corporate_buyer_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_corporate_buyer_loans_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def active_loans_corporate_buyer_lookup(_source, search_params) do
    Loans
    |> handle_active_loans_corporate_buyer_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_corporate_buyer_loans_select()
  end

  defp compose_corporate_buyer_loans_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> join(:left, [l], uD in Company, on: l.customer_id == uD.createdByUserId)
    |> where([l, uB, uC, uD], uD.isSme == ^true or uD.isEmployer == ^true)

    |> select(
      [l, uB, uC, uD],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        repayment_amount: l.repayment_amount,
        balance: l.balance,
        total_repayment_derived: l.total_repayment_derived,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        companyName: uD.companyName,
        taxno: uD.taxno
      }
    )
  end

  defp handle_active_loans_corporate_buyer_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_active_loans_date_corporate_buyer_filter(search_params)
    |> handle_active_loans_corporate_buyer_loan_type_filter(search_params)
    |> handle_active_loan_corporate_buyer_amount_filter(search_params)
    |> handle_active_loan_corporate_buyer_fname_filter(search_params)
    |> handle_avtive_loan_corporate_buyer_lname_filter(search_params)
  end

  defp handle_active_loans_date_corporate_buyer_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l, uB, uD],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^from) and
      fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^to)
    )
  end
  defp handle_active_loans_date_corporate_buyer_filter(query, _params), do: query

  defp handle_active_loans_corporate_buyer_loan_type_filter(query, %{"loan_type" => loan_type})
      when byte_size(loan_type) > 0 and byte_size(loan_type) > 0 do
    query
    |> where(
    [l, uB, uD],
    fragment("lower(?) LIKE lower(?)", l.loan_type, ^loan_type)
    )
  end
  defp handle_active_loans_corporate_buyer_loan_type_filter(query, _params), do: query

  defp handle_active_loan_corporate_buyer_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_active_loan_corporate_buyer_amount_filter(query, _params), do: query

  defp handle_active_loan_corporate_buyer_fname_filter(query, %{"f_name" => f_name})
      when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_active_loan_corporate_buyer_fname_filter(query, _params), do: query

  defp handle_avtive_loan_corporate_buyer_lname_filter(query, %{"l_name" => l_name})
      when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_avtive_loan_corporate_buyer_lname_filter(query, _params), do: query



  def loans_employer_collection_lookup(search_params, page, size) do
    Loans
    |> handle_loans_employer_collection_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_employer_collection_loans_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def loans_employer_collection_lookup(_source, search_params) do
    Loans
    |> handle_loans_employer_collection_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_employer_collection_loans_select()
  end

  defp compose_employer_collection_loans_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> join(:left, [l], uD in LoanRepaymentSchedule, on: l.id == uD.loan_id)
    |> where([l, uB, uC, uD], uB.roleType == "EMPLOYER")

    |> select(
      [l, uB, uC, uD],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        repayment_amount: l.repayment_amount,
        total_repaid: l.total_repaid,
        balance: l.balance,
        total_repayment_derived: l.total_repayment_derived,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        mobileNumber: uC.mobileNumber,
        interest_amount: uD.interest_amount,
        duedate: uD.duedate
      }
    )
  end

  defp handle_loans_employer_collection_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loans_employer_collection_mobile_filter(search_params)
    |> handle_loan_employer_collection_amount_filter(search_params)
    |> handle_loan_employer_collection_fname_filter(search_params)
    |> handle_loan_employer_collection_lname_filter(search_params)
  end

  defp handle_loans_employer_collection_mobile_filter(query, %{"cell" => cell})
      when byte_size(cell) > 0 and byte_size(cell) > 0 do
    query
    |> where(
    [l, uB, uC, uD],
    fragment("lower(?) LIKE lower(?)", uC.mobileNumber, ^cell)
    )
  end
  defp handle_loans_employer_collection_mobile_filter(query, _params), do: query

  defp handle_loan_employer_collection_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_employer_collection_amount_filter(query, _params), do: query

  defp handle_loan_employer_collection_fname_filter(query, %{"f_name" => f_name})
      when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_employer_collection_fname_filter(query, _params), do: query

  defp handle_loan_employer_collection_lname_filter(query, %{"l_name" => l_name})
      when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_employer_collection_lname_filter(query, _params), do: query



  def loans_corporate_buyer_collection_lookup(search_params, page, size) do
    Loans
    |> handle_loans_corporate_buyer_collection_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_corporate_buyer_collection_loans_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def loans_corporate_buyer_collection_lookup(_source, search_params) do
    Loans
    |> handle_loans_corporate_buyer_collection_filter(search_params)
    |> order_by([l, uB, uC], desc: l.inserted_at)
    |> compose_corporate_buyer_collection_loans_select()
  end

  defp compose_corporate_buyer_collection_loans_select(query) do
    query
    |> join(:left, [l], uB in UserRole, on: l.customer_id == uB.userId)
    |> join(:left, [l], uC in UserBioData, on: l.customer_id == uC.userId)
    |> join(:left, [l], uD in LoanRepaymentSchedule, on: l.id == uD.loan_id)
    |> join(:left, [l], uE in Company, on: l.customer_id == uE.createdByUserId)
    |> where([l, uB, uC, uD, uE], uE.isEmployer == ^true or uE.isSme == ^true)

    |> select(
      [l, uB, uC, uD, uE],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        repayment_amount: l.repayment_amount,
        total_repaid: l.total_repaid,
        balance: l.balance,
        total_repayment_derived: l.total_repayment_derived,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        mobileNumber: uC.mobileNumber,
        interest_amount: uD.interest_amount,
        duedate: uD.duedate,
        companyName: uE.companyName,
        taxno: uE.taxno
      }
    )
  end

  defp handle_loans_corporate_buyer_collection_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loans_corporate_buyer_collection_mobile_filter(search_params)
    |> handle_loan_corporate_buyer_collection_amount_filter(search_params)
    |> handle_loan_corporate_buyer_collection_fname_filter(search_params)
    |> handle_loan_corporate_buyer_collection_lname_filter(search_params)
  end

  defp handle_loans_corporate_buyer_collection_mobile_filter(query, %{"cell" => cell})
      when byte_size(cell) > 0 and byte_size(cell) > 0 do
    query
    |> where(
    [l, uB, uC, uD],
    fragment("lower(?) LIKE lower(?)", uC.mobileNumber, ^cell)
    )
  end
  defp handle_loans_corporate_buyer_collection_mobile_filter(query, _params), do: query

  defp handle_loan_corporate_buyer_collection_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [l, uB, uC],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.principal_amount, ^amount)
    )
  end
  defp handle_loan_corporate_buyer_collection_amount_filter(query, _params), do: query

  defp handle_loan_corporate_buyer_collection_fname_filter(query, %{"f_name" => f_name})
      when byte_size(f_name) > 0 and byte_size(f_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.firstName, ^f_name)
    )
  end
  defp handle_loan_corporate_buyer_collection_fname_filter(query, _params), do: query

  defp handle_loan_corporate_buyer_collection_lname_filter(query, %{"l_name" => l_name})
      when byte_size(l_name) > 0 and byte_size(l_name) > 0 do
    query
    |> where(
    [l, uB, uC],
    fragment("lower(?) LIKE lower(?)", uC.lastName, ^l_name)
    )
  end
  defp handle_loan_corporate_buyer_collection_lname_filter(query, _params), do: query




  alias Loanmanagementsystem.Loan.Loan_disbursement_method

  @doc """
  Returns the list of tbl_loan_disbursement_method.

  ## Examples

      iex> list_tbl_loan_disbursement_method()
      [%Loan_disbursement_method{}, ...]

  """
  def list_tbl_loan_disbursement_method do
    Repo.all(Loan_disbursement_method)
  end

  @doc """
  Gets a single loan_disbursement_method.

  Raises `Ecto.NoResultsError` if the Loan disbursement method does not exist.

  ## Examples

      iex> get_loan_disbursement_method!(123)
      %Loan_disbursement_method{}

      iex> get_loan_disbursement_method!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_disbursement_method!(id), do: Repo.get!(Loan_disbursement_method, id)

  @doc """
  Creates a loan_disbursement_method.

  ## Examples

      iex> create_loan_disbursement_method(%{field: value})
      {:ok, %Loan_disbursement_method{}}

      iex> create_loan_disbursement_method(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_disbursement_method(attrs \\ %{}) do
    %Loan_disbursement_method{}
    |> Loan_disbursement_method.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_disbursement_method.

  ## Examples

      iex> update_loan_disbursement_method(loan_disbursement_method, %{field: new_value})
      {:ok, %Loan_disbursement_method{}}

      iex> update_loan_disbursement_method(loan_disbursement_method, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_disbursement_method(%Loan_disbursement_method{} = loan_disbursement_method, attrs) do
    loan_disbursement_method
    |> Loan_disbursement_method.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_disbursement_method.

  ## Examples

      iex> delete_loan_disbursement_method(loan_disbursement_method)
      {:ok, %Loan_disbursement_method{}}

      iex> delete_loan_disbursement_method(loan_disbursement_method)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_disbursement_method(%Loan_disbursement_method{} = loan_disbursement_method) do
    Repo.delete(loan_disbursement_method)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_disbursement_method changes.

  ## Examples

      iex> change_loan_disbursement_method(loan_disbursement_method)
      %Ecto.Changeset{data: %Loan_disbursement_method{}}

  """
  def change_loan_disbursement_method(%Loan_disbursement_method{} = loan_disbursement_method, attrs \\ %{}) do
    Loan_disbursement_method.changeset(loan_disbursement_method, attrs)
  end
end
