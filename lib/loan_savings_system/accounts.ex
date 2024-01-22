defmodule LoanSavingsSystem.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Accounts.User
  alias LoanSavingsSystem.Client.UserBioData
  alias LoanSavingsSystem.Accounts.UserRole


  def get_user_email(username) do
    User
    |> where([u], u.username == ^username)
    |> select([u], %{
      username: u.username
    })
    |> Repo.all()

  end


  def get_logged_user_details do
    User
      |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
      |> join(:left, [uA,uB], uR in "tbl_user_roles", on: uA.id == uR.userId)
      # |> where([uA, uB, uR], uR.roleType == "ADMIN")
      # |> join(:left, [uA,,uB,uR ], uRR in LoanSavingsSystem.Accounts.Role, on: uA.role_id == uRR.id)
      |> where([uA, uB, uR], is_nil(uA.role_id) == false)
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

  def get_users!(userId), do: Repo.get!(UserRole, userId)

  def get_userss!(userId) do
      UserRole
        |> join(:left, [c], u in "tbl_users", on: c.userId == u.id)
        |> where([c, u], c.userId == ^userId)
        |> select([c], %{
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

  alias LoanSavingsSystem.Accounts.UserRole

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
  def get_user_role!(id), do: Repo.get!(UserRole, id)

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

  alias LoanSavingsSystem.Accounts.JournalEntry

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

  alias LoanSavingsSystem.Accounts.GLAccount

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

  alias LoanSavingsSystem.Accounts.Account
  alias LoanSavingsSystem.FixedDeposit.FixedDeposits

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




   def get_savings_customer_details do
     Account
       |> join(:left, [a], u in "tbl_user_bio_data", on: a.userId == u.userId)
       |> join(:left, [a], aU in "tbl_users", on: a.userId == aU.id)
       |> where([a, u, aU], a.accountType == "SAVINGS")
       |> select([a, u, aU], %{
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

  alias LoanSavingsSystem.Accounts.BankStaffRole

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

  alias LoanSavingsSystem.Accounts.SecurityQuestions

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

  alias LoanSavingsSystem.Accounts.Role

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
end
