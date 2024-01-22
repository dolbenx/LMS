defmodule Savings.Accounts do
  @moduledoc """
  The Accounts context.
  """
  #
  import Ecto.Query, warn: false
  alias Savings.Repo

  alias Savings.Accounts.User
  alias Savings.Client.UserBioData
  alias Savings.Accounts.UserRole

  def get_user_email(username) do
    User
    |> where([u], u.username == ^username)
    |> select([u], %{
      username: u.username
    })
    |> Repo.all()
  end

  # Savings.Accounts.get_logged_user_details()

  def get_logged_user_details do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> join(:left, [uA], uRR in Savings.Accounts.Role, on: uA.role_id == uRR.id)
    |> where(
      [uA, uB, uR],
      is_nil(uA.role_id) == false
    )
    |> select([uA, uB, uR, uRR], %{
      id: uA.id,
      bio_id: uB.id,
      status: uA.status,
      username: uA.username,
      firstname: uB.firstName,
      lastname: uB.lastName,
      othername: uB.otherName,
      dateofbirth: uB.dateOfBirth,
      meansofidentificationtype: uB.meansOfIdentificationType,
      meansofidentificationnumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobilenumber: uB.mobileNumber,
      emailaddress: uB.emailAddress,
      roletype: uR.roleType,
      role_desc: uRR.role_desc,
      role_id: uA.role_id
    })
    |> Repo.all()
  end

  def get_savings_customer_details do
    Account
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.userId == u.userId)
    |> join(:left, [a], aU in "tbl_users", on: a.userId == aU.id)
    |> where([a, u, aU], a.accountType == "SAVINGS")
    |> select([a, u, aU], %{
      id: a.id,
      accountType: a.accountType,
      userId: a.userId,
      accountStatus: a.status,
      status: aU.status,
      firstName: u.firstName,
      lastName: u.lastName,
      otherName: u.otherName,
      dateOfBirth: u.dateOfBirth,
      meansOfIdentificationType: u.meansOfIdentificationType,
      meansOfIdentificationNumber: u.meansOfIdentificationNumber,
      title: u.title,
      gender: u.gender,
      mobileNumber: u.mobileNumber,
      emailAddress: u.emailAddress,
      ussdActive: aU.ussdActive
    })
    |> Repo.all()
  end

  @doc """
  Returns the list of tbl_users.

  ## Examples

      iex> list_tbl_users()
      [%User{}, ...]

  """
  def list_tbl_users do
    Repo.all(User)
  end

  def get_client_users(company_id) do
    Company
    |> join(:left, [c], u in "tbl_users", on: c.company_id == u.company_id)
    |> where([c, u], c.company_id == ^company_id)
    |> select([c, u], %{
      company_name: c.company_name,
      first_name: u.first_name,
      id: u.id,
      status: u.status,
      last_name: u.last_name,
      id: u.id,
      company_id: u.company_id,
      email: u.email,
      phone: u.phone,
      address: u.address,
      id_no: u.id_no,
      age: u.age,
      sex: u.sex,
      id_type: u.id_type,
      user_role: u.user_role
    })
    |> Repo.all()
  end

  def get_loan_customer_details do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where([uA, uB, uR], uR.roleType != "BANKOFFICE_ADMIN")
    |> select([uA, uB, uR], %{
      username: uA.username,
      id: uA.id,
      status: uA.status,
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
      roleType: uR.roleType,
      userId: uR.userId
    })
    |> Repo.all()
  end

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """

  def get_user!(id), do: Repo.get!(User, id)

  # Savings.Accounts.get_userss!(30)

  def get_users!(userId), do: Repo.get!(UserRole, userId)

  def get_userss!(userId) do
    UserRole
    |> join(:left, [c], u in "tbl_users", on: c.userId == u.id)
    |> where([c, u], c.userId == ^userId)
    |> select([c, u], %{
      roleType: c.roleType
    })
    |> Repo.get!(UserRole, userId)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{source: %User{}}

  """
  def change_user(%User{} = user) do
    User.changeset(user, %{})
  end

  alias Savings.Accounts.UserRole

  # Savings.Accounts.get_user_role(1)

  @doc """
  Returns the list of tbl_user_roles.

  ## Examples

      iex> list_tbl_user_roles()
      [%UserRole{}, ...]

  """
  def list_tbl_user_roles do
    Repo.all(UserRole)
  end

  @doc """
  Gets a single user_role.

  Raises `Ecto.NoResultsError` if the User role does not exist.

  ## Examples

      iex> get_user_role!(123)
      %UserRole{}

      iex> get_user_role!(456)
      ** (Ecto.NoResultsError)

  """

  # Savings.Accounts.get_user_role!(17)

  def get_user_role!(id), do: Repo.get!(UserRole, id)

  def get_my_user_role!(userId) do
    UserRole
    |> where([uR], uR.userId == ^userId)
    |> select([uR], %{
      id: uR.id,
      roleId: uR.roleId,
      userId: uR.userId,
      roleType: uR.roleType,
      clientId: uR.clientId,
      status: uR.status,
      otp: uR.otp,
      companyId: uR.companyId,
      netPay: uR.netPay,
      branchId: uR.branchId,
      isLoanOfficer: uR.isLoanOfficer
    })
    |> Repo.one()
  end

  @doc """
  Creates a user_role.

  ## Examples

      iex> create_user_role(%{field: value})
      {:ok, %UserRole{}}

      iex> create_user_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_role(attrs \\ %{}) do
    %UserRole{}
    |> UserRole.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_role.

  ## Examples

      iex> update_user_role(user_role, %{field: new_value})
      {:ok, %UserRole{}}

      iex> update_user_role(user_role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_role(%UserRole{} = user_role, attrs) do
    user_role
    |> UserRole.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_role.

  ## Examples

      iex> delete_user_role(user_role)
      {:ok, %UserRole{}}

      iex> delete_user_role(user_role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_role(%UserRole{} = user_role) do
    Repo.delete(user_role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_role changes.

  ## Examples

      iex> change_user_role(user_role)
      %Ecto.Changeset{source: %UserRole{}}

  """
  def change_user_role(%UserRole{} = user_role) do
    UserRole.changeset(user_role, %{})
  end

  alias Savings.Accounts.JournalEntry

  @doc """
  Returns the list of tbl_journal_entry.

  ## Examples

      iex> list_tbl_journal_entry()
      [%JournalEntry{}, ...]

  """
  def list_tbl_journal_entry do
    Repo.all(JournalEntry)
  end

  @doc """
  Gets a single journal_entry.

  Raises `Ecto.NoResultsError` if the Journal entry does not exist.

  ## Examples

      iex> get_journal_entry!(123)
      %JournalEntry{}

      iex> get_journal_entry!(456)
      ** (Ecto.NoResultsError)

  """
  def get_journal_entry!(id), do: Repo.get!(JournalEntry, id)

  @doc """
  Creates a journal_entry.

  ## Examples

      iex> create_journal_entry(%{field: value})
      {:ok, %JournalEntry{}}

      iex> create_journal_entry(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_journal_entry(attrs \\ %{}) do
    %JournalEntry{}
    |> JournalEntry.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a journal_entry.

  ## Examples

      iex> update_journal_entry(journal_entry, %{field: new_value})
      {:ok, %JournalEntry{}}

      iex> update_journal_entry(journal_entry, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_journal_entry(%JournalEntry{} = journal_entry, attrs) do
    journal_entry
    |> JournalEntry.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a journal_entry.

  ## Examples

      iex> delete_journal_entry(journal_entry)
      {:ok, %JournalEntry{}}

      iex> delete_journal_entry(journal_entry)
      {:error, %Ecto.Changeset{}}

  """
  def delete_journal_entry(%JournalEntry{} = journal_entry) do
    Repo.delete(journal_entry)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking journal_entry changes.

  ## Examples

      iex> change_journal_entry(journal_entry)
      %Ecto.Changeset{source: %JournalEntry{}}

  """
  def change_journal_entry(%JournalEntry{} = journal_entry) do
    JournalEntry.changeset(journal_entry, %{})
  end

  alias Savings.Accounts.GLAccount

  @doc """
  Returns the list of tbl_gl_account.

  ## Examples

      iex> list_tbl_gl_account()
      [%GLAccount{}, ...]

  """
  def list_tbl_gl_account do
    Repo.all(GLAccount)
  end

  @doc """
  Gets a single gl_account.

  Raises `Ecto.NoResultsError` if the Gl account does not exist.

  ## Examples

      iex> get_gl_account!(123)
      %GLAccount{}

      iex> get_gl_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_gl_account!(id), do: Repo.get!(GLAccount, id)

  @doc """
  Creates a gl_account.

  ## Examples

      iex> create_gl_account(%{field: value})
      {:ok, %GLAccount{}}

      iex> create_gl_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_gl_account(attrs \\ %{}) do
    %GLAccount{}
    |> GLAccount.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a gl_account.

  ## Examples

      iex> update_gl_account(gl_account, %{field: new_value})
      {:ok, %GLAccount{}}

      iex> update_gl_account(gl_account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_gl_account(%GLAccount{} = gl_account, attrs) do
    gl_account
    |> GLAccount.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a gl_account.

  ## Examples

      iex> delete_gl_account(gl_account)
      {:ok, %GLAccount{}}

      iex> delete_gl_account(gl_account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_gl_account(%GLAccount{} = gl_account) do
    Repo.delete(gl_account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking gl_account changes.

  ## Examples

      iex> change_gl_account(gl_account)
      %Ecto.Changeset{source: %GLAccount{}}

  """
  def change_gl_account(%GLAccount{} = gl_account) do
    GLAccount.changeset(gl_account, %{})
  end

  alias Savings.Accounts.Account
  alias Savings.FixedDeposit.FixedDeposits

  @doc """
  Returns the list of tbl_account.

  ## Examples

      iex> list_tbl_account()
      [%Account{}, ...]

  """
  def list_tbl_account do
    Repo.all(Account)
  end

  def customer_details(userId) do
    Account
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.userId == u.userId)
    |> where([a, u], a.userId == ^userId)
    |> select([a, u], %{
      accountType: a.accountType,
      userId: a.userId,
      status: a.status,
      firstName: u.firstName,
      lastName: u.lastName,
      otherName: u.otherName,
      dateOfBirth: u.dateOfBirth,
      meansOfIdentificationType: u.meansOfIdentificationType,
      meansOfIdentificationNumber: u.meansOfIdentificationNumber,
      title: u.title,
      gender: u.gender,
      mobileNumber: u.mobileNumber,
      emailAddress: u.emailAddress
    })
    |> Repo.all()
  end

  def get_customer_details do
    Account
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.userId == u.userId)
    |> select([a, u], %{
      accountType: a.accountType,
      userId: a.userId,
      status: a.status,
      firstName: u.firstName,
      lastName: u.lastName,
      otherName: u.otherName,
      dateOfBirth: u.dateOfBirth,
      meansOfIdentificationType: u.meansOfIdentificationType,
      meansOfIdentificationNumber: u.meansOfIdentificationNumber,
      title: u.title,
      gender: u.gender,
      mobileNumber: u.mobileNumber,
      emailAddress: u.emailAddress
    })
    |> Repo.all()
  end

  def get_fixed_deposits(userId) do
    Account
    |> join(:left, [a], u in "tbl_fixed_deposit", on: a.userId == u.userId)
    |> where([a, u], a.userId == ^userId)
    |> select([a, u], %{
      accountType: a.accountType,
      userId: a.userId,
      status: a.status,
      principalAmount: u.principalAmount,
      fixedPeriod: u.fixedPeriod,
      fixedPeriodType: u.fixedPeriodType,
      interestRate: u.interestRate,
      interestRateType: u.interestRateType,
      expectedInterest: u.expectedInterest,
      accruedInterest: u.accruedInterest,
      isMatured: u.isMatured,
      isDivested: u.isDivested,
      divestmentPackageId: u.divestmentPackageId,
      currencyId: u.currencyId,
      currency: u.currency,
      currencyDecimals: u.currencyDecimals,
      yearLengthInDays: u.yearLengthInDays,
      totalDepositCharge: u.totalDepositCharge,
      totalWithdrawalCharge: u.totalWithdrawalCharge,
      totalPenalties: u.totalPenalties,
      totalAmountPaidOut: u.totalAmountPaidOut,
      startDate: u.startDate,
      endDate: u.endDate
    })
    |> Repo.all()
  end

  def get_loan_customers(userId) do
    Account
    |> join(:left, [a], u in "tbl_fixed_deposit", on: a.userId == u.userId)
    |> where([a, u], a.userId == ^userId)
    |> select([a, u], %{
      accountType: a.accountType,
      userId: a.userId,
      status: a.status,
      principalAmount: u.principalAmount,
      fixedPeriod: u.fixedPeriod,
      fixedPeriodType: u.fixedPeriodType,
      interestRate: u.interestRate,
      interestRateType: u.interestRateType,
      expectedInterest: u.expectedInterest,
      accruedInterest: u.accruedInterest,
      isMatured: u.isMatured,
      isDivested: u.isDivested,
      divestmentPackageId: u.divestmentPackageId,
      currencyId: u.currencyId,
      currency: u.currency,
      currencyDecimals: u.currencyDecimals,
      yearLengthInDays: u.yearLengthInDays,
      totalDepositCharge: u.totalDepositCharge,
      totalWithdrawalCharge: u.totalWithdrawalCharge,
      totalPenalties: u.totalPenalties,
      totalAmountPaidOut: u.totalAmountPaidOut,
      startDate: u.startDate,
      endDate: u.endDate
    })
    |> Repo.all()
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  @doc """
  Creates a account.

  ## Examples

      iex> create_account(%{field: value})
      {:ok, %Account{}}

      iex> create_account(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account(attrs \\ %{}) do
    %Account{}
    |> Account.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account.

  ## Examples

      iex> update_account(account, %{field: new_value})
      {:ok, %Account{}}

      iex> update_account(account, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account(%Account{} = account, attrs) do
    account
    |> Account.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account.

  ## Examples

      iex> delete_account(account)
      {:ok, %Account{}}

      iex> delete_account(account)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account(%Account{} = account) do
    Repo.delete(account)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account changes.

  ## Examples

      iex> change_account(account)
      %Ecto.Changeset{source: %Account{}}

  """
  def change_account(%Account{} = account) do
    Account.changeset(account, %{})
  end

  alias Savings.Accounts.BankStaffRole

  @doc """
  Returns the list of tbl_bank_staff_role.

  ## Examples

      iex> list_tbl_bank_staff_role()
      [%BankStaffRole{}, ...]

  """
  def list_tbl_bank_staff_role do
    Repo.all(BankStaffRole)
  end

  @doc """
  Gets a single bank_staff_role.

  Raises `Ecto.NoResultsError` if the Bank staff role does not exist.

  ## Examples

      iex> get_bank_staff_role!(123)
      %BankStaffRole{}

      iex> get_bank_staff_role!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bank_staff_role!(id), do: Repo.get!(BankStaffRole, id)

  @doc """
  Creates a bank_staff_role.

  ## Examples

      iex> create_bank_staff_role(%{field: value})
      {:ok, %BankStaffRole{}}

      iex> create_bank_staff_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bank_staff_role(attrs \\ %{}) do
    %BankStaffRole{}
    |> BankStaffRole.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bank_staff_role.

  ## Examples

      iex> update_bank_staff_role(bank_staff_role, %{field: new_value})
      {:ok, %BankStaffRole{}}

      iex> update_bank_staff_role(bank_staff_role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bank_staff_role(%BankStaffRole{} = bank_staff_role, attrs) do
    bank_staff_role
    |> BankStaffRole.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bank_staff_role.

  ## Examples

      iex> delete_bank_staff_role(bank_staff_role)
      {:ok, %BankStaffRole{}}

      iex> delete_bank_staff_role(bank_staff_role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bank_staff_role(%BankStaffRole{} = bank_staff_role) do
    Repo.delete(bank_staff_role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bank_staff_role changes.

  ## Examples

      iex> change_bank_staff_role(bank_staff_role)
      %Ecto.Changeset{source: %BankStaffRole{}}

  """
  def change_bank_staff_role(%BankStaffRole{} = bank_staff_role) do
    BankStaffRole.changeset(bank_staff_role, %{})
  end

  alias Savings.Accounts.SecurityQuestions

  @doc """
  Returns the list of tbl_security_questions.

  ## Examples

      iex> list_tbl_security_questions()
      [%SecurityQuestions{}, ...]

  """
  def list_tbl_security_questions do
    Repo.all(SecurityQuestions)
  end

  @doc """
  Gets a single security_questions.

  Raises `Ecto.NoResultsError` if the Security questions does not exist.

  ## Examples

      iex> get_security_questions!(123)
      %SecurityQuestions{}

      iex> get_security_questions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_security_questions!(id), do: Repo.get!(SecurityQuestions, id)

  @doc """
  Creates a security_questions.

  ## Examples

      iex> create_security_questions(%{field: value})
      {:ok, %SecurityQuestions{}}

      iex> create_security_questions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_security_questions(attrs \\ %{}) do
    %SecurityQuestions{}
    |> SecurityQuestions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a security_questions.

  ## Examples

      iex> update_security_questions(security_questions, %{field: new_value})
      {:ok, %SecurityQuestions{}}

      iex> update_security_questions(security_questions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_security_questions(%SecurityQuestions{} = security_questions, attrs) do
    security_questions
    |> SecurityQuestions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a security_questions.

  ## Examples

      iex> delete_security_questions(security_questions)
      {:ok, %SecurityQuestions{}}

      iex> delete_security_questions(security_questions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_security_questions(%SecurityQuestions{} = security_questions) do
    Repo.delete(security_questions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking security_questions changes.

  ## Examples

      iex> change_security_questions(security_questions)
      %Ecto.Changeset{source: %SecurityQuestions{}}

  """
  def change_security_questions(%SecurityQuestions{} = security_questions) do
    SecurityQuestions.changeset(security_questions, %{})
  end

  alias Savings.Accounts.Role

  @doc """
  Returns the list of tbl_roles.

  ## Examples

      iex> list_tbl_roles()
      [%Role{}, ...]

  """
  def list_tbl_roles do
    Repo.all(Role)
  end

  @doc """
  Gets a single role.

  Raises `Ecto.NoResultsError` if the Role does not exist.

  ## Examples

      iex> get_role!(123)
      %Role{}

      iex> get_role!(456)
      ** (Ecto.NoResultsError)

  """
  # Savings.Accounts.get_role!(1)
  def get_role!(id), do: Repo.get!(Role, id)

  @doc """
  Creates a role.

  ## Examples

      iex> create_role(%{field: value})
      {:ok, %Role{}}

      iex> create_role(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_role(attrs \\ %{}) do
    %Role{}
    |> Role.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a role.

  ## Examples

      iex> update_role(role, %{field: new_value})
      {:ok, %Role{}}

      iex> update_role(role, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_role(%Role{} = role, attrs) do
    role
    |> Role.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a role.

  ## Examples

      iex> delete_role(role)
      {:ok, %Role{}}

      iex> delete_role(role)
      {:error, %Ecto.Changeset{}}

  """
  def delete_role(%Role{} = role) do
    Repo.delete(role)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking role changes.

  ## Examples

      iex> change_role(role)
      %Ecto.Changeset{data: %Role{}}

  """
  def change_role(%Role{} = role, attrs \\ %{}) do
    Role.changeset(role, attrs)
  end

  # Savings.Accounts.get_user_role_by_id(12)

  def get_user_role_by_id(role_id) do
    Savings.Accounts.User
    |> join(:left, [a], ro in Role, on: a.role_id == ro.id)
    |> where([a, ro], a.role_id == ^role_id)
    |> select([a, ro], %{
      role_desc: ro.role_desc,
      role_group: ro.role_group,
      role_str: ro.role_str,
      status: ro.status
    })
    |> Repo.all()
  end

  # Savings.Accounts.get_logged_user_details_by_id(1)

  def get_logged_user_details_by_id(user_id) do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where([uA, uB, uR], uA.id == ^user_id)
    |> select([uA, uB, uR], %{
      id: uA.id,
      status: uA.status,
      username: uA.username,
      firstname: uB.firstName,
      lastname: uB.lastName,
      othername: uB.otherName,
      dateofbirth: uB.dateOfBirth,
      meansofidentificationtype: uB.meansOfIdentificationType,
      meansofidentificationnumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobilenumber: uB.mobileNumber,
      emailaddress: uB.emailAddress,
      roletype: uR.roleType
    })
    |> Repo.one()
  end

  # Savings.Accounts.list_tbl_users_with_roles()

  def list_tbl_users_with_roles do
    User
    |> preload([:role])
    |> Repo.all()
  end

  # Savings.Accounts.get_all_customer_details()

  def get_all_customer_details() do
    Savings.Accounts.User
    |> join(:left, [a], u in Savings.Client.UserBioData, on: a.id == u.userId)
    |> join(:left, [a, u], ro in Savings.Accounts.UserRole, on: u.userId == ro.userId)
    |> join(:left, [a, u, ro], acc in Savings.Accounts.Account, on: ro.userId == acc.userId)
    |> where([a, u, ro, acc], ro.userId == acc.userId)
    |> select([a, u, ro, acc], %{
      # accountType: a.accountType,
      # userId: a.userId,
      id: acc.id,
      status: a.status,
      firstName: u.firstName,
      lastName: u.lastName,
      otherName: u.otherName,
      dateOfBirth: u.dateOfBirth,
      meansOfIdentificationType: u.meansOfIdentificationType,
      meansOfIdentificationNumber: u.meansOfIdentificationNumber,
      title: u.title,
      gender: u.gender,
      mobileNumber: u.mobileNumber,
      emailAddress: u.emailAddress,
      accountType: acc.accountType,
      account_status: acc.status
    })
    |> Repo.all()
  end

  alias Savings.Accounts.User
  alias Savings.Client.UserBioData
  alias Savings.Accounts.UserRole
  alias Savings.Accounts.Account

  # Savings.Accounts.get_all_clients_details(nil, 1, 10)

  def get_all_clients_details(search_params, page, size) do
    Savings.Accounts.User
    # |> handle_client_report_filter(search_params)
    |> order_by([a, u, ro, acc], desc: a.inserted_at)
    |> compose_customer_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def product_list(_source, search_params) do
    Savings.Accounts.User
    |> handle_client_report_filter(search_params)
    |> order_by([a, u, ro, acc], desc: a.inserted_at)
    |> compose_customer_list()
  end

  defp compose_customer_list(query) do
    query
    |> join(:left, [a], u in Savings.Client.UserBioData, on: a.id == u.userId)
    |> join(:left, [a, u], ro in Savings.Accounts.UserRole, on: u.userId == ro.userId)
    |> join(:left, [a, u, ro], acc in Savings.Accounts.Account, on: ro.userId == acc.userId)
    |> where([a, u, ro, acc], a.id == acc.userId and ro.roleType == ^"INDIVIDUAL")
    |> select(
      [a, u, ro, acc],
      %{
        id: acc.id,
        status: a.status,
        firstName: u.firstName,
        lastName: u.lastName,
        otherName: u.otherName,
        dateOfBirth: u.dateOfBirth,
        meansOfIdentificationType: u.meansOfIdentificationType,
        meansOfIdentificationNumber: u.meansOfIdentificationNumber,
        title: u.title,
        gender: u.gender,
        mobileNumber: u.mobileNumber,
        emailAddress: u.emailAddress,
        accountType: acc.accountType,
        total_deposits: acc.totalDeposits,
        total_withdrawals: acc.totalWithdrawals,
        total_interest: acc.totalInterestEarned,
        total_balance: acc.totalDeposits + acc.totalInterestEarned - acc.totalWithdrawals,
        account_status: acc.status,
        acc_inserted_at: acc.inserted_at,
        customer_names: fragment("concat(?, '  ', ?)", u.firstName, u.lastName)
      }
    )
  end

  defp handle_client_report_filter(query, %{"isearch" => search_term} = search_params)
    when search_term == "" or is_nil(search_term) do
      query
      |> handle_client_first_name_filter(search_params)
      |> handle_client_last_name_filter(search_params)
      |> handle_client_phone_number_filter(search_params)
      |> handle_client_acc_status_filter(search_params)
      |> handle_client_minimum_principal_filter(search_params)
      |> handle_client_transaction_date_filter(search_params)
  end

  defp handle_client_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_client_transaction_isearch_filter(query, search_term)
  end

  defp handle_client_first_name_filter(query, %{"txn_client_first_name" => txn_client_first_name})
    when txn_client_first_name == "" or is_nil(txn_client_first_name),
       do: query

  defp handle_client_first_name_filter(query, %{"txn_client_first_name" => txn_client_first_name}) do
    where(
      query,
      [a, u, ro, acc],
      fragment("lower(?) LIKE lower(?)", u.firstName, ^"%#{txn_client_first_name}%")
    )
  end

  defp handle_client_last_name_filter(query, %{"txn_client_last_name" => txn_client_last_name})
       when txn_client_last_name == "" or is_nil(txn_client_last_name),
       do: query

  defp handle_client_last_name_filter(query, %{"txn_client_last_name" => txn_client_last_name}) do
    where(
      query,
      [a, u, ro, acc],
      fragment("lower(?) LIKE lower(?)", u.lastName, ^"%#{txn_client_last_name}%")
    )
  end

  defp handle_client_phone_number_filter(query, %{
         "txn_client_phone_number" => txn_client_phone_number
       })
       when txn_client_phone_number == "" or is_nil(txn_client_phone_number),
       do: query

  defp handle_client_phone_number_filter(query, %{
         "txn_client_phone_number" => txn_client_phone_number
       }) do
    where(
      query,
      [a, u, ro, acc],
      fragment("lower(?) LIKE lower(?)", u.mobileNumber, ^"%#{txn_client_phone_number}%")
    )
  end

  defp handle_client_acc_status_filter(query, %{"client_txn_status" => client_txn_status})
       when client_txn_status == "" or is_nil(client_txn_status),
       do: query

  defp handle_client_acc_status_filter(query, %{"client_txn_status" => client_txn_status}) do
    where(
      query,
      [a, u, ro, acc],
      fragment("lower(?) LIKE lower(?)", u.status, ^"%#{client_txn_status}%")
    )
  end

  defp handle_client_minimum_principal_filter(query, %{
         "txn_product_minimum_amount" => txn_product_minimum_amount,
         "txn_product_maximum_amount" => txn_product_maximum_amount
       })
       when byte_size(txn_product_minimum_amount) > 0 and
              byte_size(txn_product_maximum_amount) > 0 do
    query
    |> where(
      [a, u, ro, acc],
      fragment("? >= ?", acc.totalDeposits, type(^txn_product_minimum_amount, :float)) and
        fragment("? <= ?", acc.totalDeposits, type(^txn_product_maximum_amount, :float))
    )
  end

  defp handle_client_minimum_principal_filter(query, _params), do: query

  defp handle_client_transaction_date_filter(query, %{
         "txn_date_from" => txn_date_from,
         "txn_date_to" => txn_date_to
       })
       when byte_size(txn_date_from) > 0 and byte_size(txn_date_to) > 0 do
    query
    |> where(
      [a, u, ro, acc],
        fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", a.inserted_at, ^txn_date_from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", a.inserted_at, ^txn_date_to)
    )
  end

  defp handle_client_transaction_date_filter(query, _params), do: query

  defp compose_client_transaction_isearch_filter(query, search_term) do
    query
    |> where(
      [a, u, ro, acc],
      fragment("lower(?) LIKE lower(?)", u.firstName, ^search_term) or
      fragment("lower(?) LIKE lower(?)", u.lastName, ^search_term) or
      fragment("lower(?) LIKE lower(?)", u.otherName, ^search_term)
    )
  end



end
