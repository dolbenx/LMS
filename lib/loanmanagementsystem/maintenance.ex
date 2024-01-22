defmodule Loanmanagementsystem.Maintenance do
  @moduledoc """
  The Maintenance context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Maintenance.Currency

  @doc """
  Returns the list of tbl_currency.

  ## Examples

      iex> list_tbl_currency()
      [%Currency{}, ...]

  """
  # Loanmanagementsystem.Maintenance.list_tbl_currency
  def list_tbl_currency do
    Repo.all(Currency)
  end

  @doc """
  Gets a single currency.

  Raises `Ecto.NoResultsError` if the Currency does not exist.

  ## Examples

      iex> get_currency!(123)
      %Currency{}

      iex> get_currency!(456)
      ** (Ecto.NoResultsError)

  """
  def get_currency!(id), do: Repo.get!(Currency, id)

  @doc """
  Creates a currency.

  ## Examples

      iex> create_currency(%{field: value})
      {:ok, %Currency{}}

      iex> create_currency(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_currency(attrs \\ %{}) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a currency.

  ## Examples

      iex> update_currency(currency, %{field: new_value})
      {:ok, %Currency{}}

      iex> update_currency(currency, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_currency(%Currency{} = currency, attrs) do
    currency
    |> Currency.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a currency.

  ## Examples

      iex> delete_currency(currency)
      {:ok, %Currency{}}

      iex> delete_currency(currency)
      {:error, %Ecto.Changeset{}}

  """
  def delete_currency(%Currency{} = currency) do
    Repo.delete(currency)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking currency changes.

  ## Examples

      iex> change_currency(currency)
      %Ecto.Changeset{data: %Currency{}}

  """
  def change_currency(%Currency{} = currency, attrs \\ %{}) do
    Currency.changeset(currency, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Country

  @doc """
  Returns the list of tbl_country.

  ## Examples

      iex> list_tbl_country()
      [%Country{}, ...]

  """
  # Loanmanagementsystem.Maintenance.list_tbl_country
  def list_tbl_country do
    Repo.all(Country)
  end

  @doc """
  Gets a single country.

  Raises `Ecto.NoResultsError` if the Country does not exist.

  ## Examples

      iex> get_country!(123)
      %Country{}

      iex> get_country!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Maintenance.get_country!
  def get_country!(id), do: Repo.get!(Country, id)

  @doc """
  Creates a country.

  ## Examples

      iex> create_country(%{field: value})
      {:ok, %Country{}}

      iex> create_country(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a country.

  ## Examples

      iex> update_country(country, %{field: new_value})
      {:ok, %Country{}}

      iex> update_country(country, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a country.

  ## Examples

      iex> delete_country(country)
      {:ok, %Country{}}

      iex> delete_country(country)
      {:error, %Ecto.Changeset{}}

  """
  def delete_country(%Country{} = country) do
    Repo.delete(country)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking country changes.

  ## Examples

      iex> change_country(country)
      %Ecto.Changeset{data: %Country{}}

  """
  def change_country(%Country{} = country, attrs \\ %{}) do
    Country.changeset(country, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Province

  @doc """
  Returns the list of tbl_province.

  ## Examples

      iex> list_tbl_province()
      [%Province{}, ...]

  """
  # Loanmanagementsystem.Maintenance.list_tbl_province
  def list_tbl_province do
    Repo.all(Province)
  end

  @doc """
  Gets a single province.

  Raises `Ecto.NoResultsError` if the Province does not exist.

  ## Examples

      iex> get_province!(123)
      %Province{}

      iex> get_province!(456)
      ** (Ecto.NoResultsError)

  """
  def get_province!(id), do: Repo.get!(Province, id)

  @doc """
  Creates a province.

  ## Examples

      iex> create_province(%{field: value})
      {:ok, %Province{}}

      iex> create_province(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_province(attrs \\ %{}) do
    %Province{}
    |> Province.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a province.

  ## Examples

      iex> update_province(province, %{field: new_value})
      {:ok, %Province{}}

      iex> update_province(province, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_province(%Province{} = province, attrs) do
    province
    |> Province.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a province.

  ## Examples

      iex> delete_province(province)
      {:ok, %Province{}}

      iex> delete_province(province)
      {:error, %Ecto.Changeset{}}

  """
  def delete_province(%Province{} = province) do
    Repo.delete(province)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking province changes.

  ## Examples

      iex> change_province(province)
      %Ecto.Changeset{data: %Province{}}

  """
  def change_province(%Province{} = province, attrs \\ %{}) do
    Province.changeset(province, attrs)
  end

  alias Loanmanagementsystem.Maintenance.District

  @doc """
  Returns the list of tbl_district.

  ## Examples

      iex> list_tbl_district()
      [%District{}, ...]

  """
  # Loanmanagementsystem.Maintenance.list_tbl_district
  def list_tbl_district do
    Repo.all(District)
  end

  @doc """
  Gets a single district.

  Raises `Ecto.NoResultsError` if the District does not exist.

  ## Examples

      iex> get_district!(123)
      %District{}

      iex> get_district!(456)
      ** (Ecto.NoResultsError)

  """
  def get_district!(id), do: Repo.get!(District, id)

  @doc """
  Creates a district.

  ## Examples

      iex> create_district(%{field: value})
      {:ok, %District{}}

      iex> create_district(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_district(attrs \\ %{}) do
    %District{}
    |> District.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a district.

  ## Examples

      iex> update_district(district, %{field: new_value})
      {:ok, %District{}}

      iex> update_district(district, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_district(%District{} = district, attrs) do
    district
    |> District.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a district.

  ## Examples

      iex> delete_district(district)
      {:ok, %District{}}

      iex> delete_district(district)
      {:error, %Ecto.Changeset{}}

  """
  def delete_district(%District{} = district) do
    Repo.delete(district)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking district changes.

  ## Examples

      iex> change_district(district)
      %Ecto.Changeset{data: %District{}}

  """
  def change_district(%District{} = district, attrs \\ %{}) do
    District.changeset(district, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Security_questions

  @doc """
  Returns the list of tbl_security_questions.

  ## Examples

      iex> list_tbl_security_questions()
      [%Security_questions{}, ...]

  """
  # Loanmanagementsystem.Maintenance.list_tbl_security_questions
  def list_tbl_security_questions do
    Repo.all(Security_questions)
  end

  @doc """
  Gets a single security_questions.

  Raises `Ecto.NoResultsError` if the Security questions does not exist.

  ## Examples

      iex> get_security_questions!(123)
      %Security_questions{}

      iex> get_security_questions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_security_questions!(id), do: Repo.get!(Security_questions, id)

  @doc """
  Creates a security_questions.

  ## Examples

      iex> create_security_questions(%{field: value})
      {:ok, %Security_questions{}}

      iex> create_security_questions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_security_questions(attrs \\ %{}) do
    %Security_questions{}
    |> Security_questions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a security_questions.

  ## Examples

      iex> update_security_questions(security_questions, %{field: new_value})
      {:ok, %Security_questions{}}

      iex> update_security_questions(security_questions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_security_questions(%Security_questions{} = security_questions, attrs) do
    security_questions
    |> Security_questions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a security_questions.

  ## Examples

      iex> delete_security_questions(security_questions)
      {:ok, %Security_questions{}}

      iex> delete_security_questions(security_questions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_security_questions(%Security_questions{} = security_questions) do
    Repo.delete(security_questions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking security_questions changes.

  ## Examples

      iex> change_security_questions(security_questions)
      %Ecto.Changeset{data: %Security_questions{}}

  """
  def change_security_questions(%Security_questions{} = security_questions, attrs \\ %{}) do
    Security_questions.changeset(security_questions, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Branch

  @doc """
  Returns the list of tbl_branch.

  ## Examples

      iex> list_tbl_branch()
      [%Branch{}, ...]

  """

  # Loanmanagementsystem.Maintenance.list_tbl_branch
  def list_tbl_branch do
    Repo.all(Branch)
  end

  @doc """
  Gets a single branch.

  Raises `Ecto.NoResultsError` if the Branch does not exist.

  ## Examples

      iex> get_branch!(123)
      %Branch{}

      iex> get_branch!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Maintenance.get_branch!()
  def get_branch!(id), do: Repo.get!(Branch, id)

  @doc """
  Creates a branch.

  ## Examples

      iex> create_branch(%{field: value})
      {:ok, %Branch{}}

      iex> create_branch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_branch(attrs \\ %{}) do
    %Branch{}
    |> Branch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a branch.

  ## Examples

      iex> update_branch(branch, %{field: new_value})
      {:ok, %Branch{}}

      iex> update_branch(branch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_branch(%Branch{} = branch, attrs) do
    branch
    |> Branch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a branch.

  ## Examples

      iex> delete_branch(branch)
      {:ok, %Branch{}}

      iex> delete_branch(branch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_branch(%Branch{} = branch) do
    Repo.delete(branch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking branch changes.

  ## Examples

      iex> change_branch(branch)
      %Ecto.Changeset{data: %Branch{}}

  """
  def change_branch(%Branch{} = branch, attrs \\ %{}) do
    Branch.changeset(branch, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Bank

  @doc """
  Returns the list of tbl_banks.

  ## Examples

      iex> list_tbl_banks()
      [%Bank{}, ...]

  """
  # Loanmanagementsystem.Maintenance.list_tbl_banks
  def list_tbl_banks do
    Repo.all(Bank)
  end

  @doc """
  Gets a single bank.

  Raises `Ecto.NoResultsError` if the Bank does not exist.

  ## Examples

      iex> get_bank!(123)
      %Bank{}

      iex> get_bank!(456)
      ** (Ecto.NoResultsError)

  """

  # Loanmanagementsystem.Maintenance.get_bank!
  def get_bank!(id), do: Repo.get!(Bank, id)

  @doc """
  Creates a bank.

  ## Examples

      iex> create_bank(%{field: value})
      {:ok, %Bank{}}

      iex> create_bank(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bank(attrs \\ %{}) do
    %Bank{}
    |> Bank.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bank.

  ## Examples

      iex> update_bank(bank, %{field: new_value})
      {:ok, %Bank{}}

      iex> update_bank(bank, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bank(%Bank{} = bank, attrs) do
    bank
    |> Bank.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bank.

  ## Examples

      iex> delete_bank(bank)
      {:ok, %Bank{}}

      iex> delete_bank(bank)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bank(%Bank{} = bank) do
    Repo.delete(bank)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bank changes.

  ## Examples

      iex> change_bank(bank)
      %Ecto.Changeset{data: %Bank{}}

  """
  def change_bank(%Bank{} = bank, attrs \\ %{}) do
    Bank.changeset(bank, attrs)
  end



  alias Loanmanagementsystem.Maintenance.Classification

  @doc """
  Returns the list of tbl_classification.

  ## Examples

      iex> list_tbl_classification()
      [%Classification{}, ...]

  """
  # Loanmanagementsystem.Maintenance.list_tbl_classification
  def list_tbl_classification do
    Repo.all(Classification)
  end

  @doc """
  Gets a single classification.

  Raises `Ecto.NoResultsError` if the Classification does not exist.

  ## Examples

      iex> get_classification!(123)
      %Classification{}

      iex> get_classification!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Maintenance.get_classification!(1)
  def get_classification!(id), do: Repo.get!(Classification, id)

  @doc """
  Creates a classification.

  ## Examples

      iex> create_classification(%{field: value})
      {:ok, %Classification{}}

      iex> create_classification(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_classification(attrs \\ %{}) do
    %Classification{}
    |> Classification.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a classification.

  ## Examples

      iex> update_classification(classification, %{field: new_value})
      {:ok, %Classification{}}

      iex> update_classification(classification, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_classification(%Classification{} = classification, attrs) do
    classification
    |> Classification.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a classification.

  ## Examples

      iex> delete_classification(classification)
      {:ok, %Classification{}}

      iex> delete_classification(classification)
      {:error, %Ecto.Changeset{}}

  """
  def delete_classification(%Classification{} = classification) do
    Repo.delete(classification)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking classification changes.

  ## Examples

      iex> change_classification(classification)
      %Ecto.Changeset{data: %Classification{}}

  """
  def change_classification(%Classification{} = classification, attrs \\ %{}) do
    Classification.changeset(classification, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Message_Management

  @doc """
  Returns the list of tbl_msg_mgt.

  ## Examples

      iex> list_tbl_msg_mgt()
      [%Message_Management{}, ...]

  """
  # Loanmanagementsystem.Maintenance.list_tbl_msg_mgt
  def list_tbl_msg_mgt do
    Repo.all(Message_Management)
  end

  @doc """
  Gets a single message__management.

  Raises `Ecto.NoResultsError` if the Message  management does not exist.

  ## Examples

      iex> get_message__management!(123)
      %Message_Management{}

      iex> get_message__management!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Maintenance.get_message__management!
  def get_message__management!(id), do: Repo.get!(Message_Management, id)

  @doc """
  Creates a message__management.

  ## Examples

      iex> create_message__management(%{field: value})
      {:ok, %Message_Management{}}

      iex> create_message__management(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_message__management(attrs \\ %{}) do
    %Message_Management{}
    |> Message_Management.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a message__management.

  ## Examples

      iex> update_message__management(message__management, %{field: new_value})
      {:ok, %Message_Management{}}

      iex> update_message__management(message__management, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_message__management(%Message_Management{} = message__management, attrs) do
    message__management
    |> Message_Management.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a message__management.

  ## Examples

      iex> delete_message__management(message__management)
      {:ok, %Message_Management{}}

      iex> delete_message__management(message__management)
      {:error, %Ecto.Changeset{}}

  """
  def delete_message__management(%Message_Management{} = message__management) do
    Repo.delete(message__management)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking message__management changes.

  ## Examples

      iex> change_message__management(message__management)
      %Ecto.Changeset{data: %Message_Management{}}

  """
  def change_message__management(%Message_Management{} = message__management, attrs \\ %{}) do
    Message_Management.changeset(message__management, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Company_maintenance

  @doc """
  Returns the list of tbl_company_maintanence.

  ## Examples

      iex> list_tbl_company_maintanence()
      [%Company_maintenance{}, ...]

  """
  def list_tbl_company_maintanence do
    Repo.all(Company_maintenance)
  end

  def company_info() do
    Repo.one(Company_maintenance)
  end

  @doc """
  Gets a single company_maintenance.

  Raises `Ecto.NoResultsError` if the Company maintenance does not exist.

  ## Examples

      iex> get_company_maintenance!(123)
      %Company_maintenance{}

      iex> get_company_maintenance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company_maintenance!(id), do: Repo.get!(Company_maintenance, id)

  @doc """
  Creates a company_maintenance.

  ## Examples

      iex> create_company_maintenance(%{field: value})
      {:ok, %Company_maintenance{}}

      iex> create_company_maintenance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company_maintenance(attrs \\ %{}) do
    %Company_maintenance{}
    |> Company_maintenance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company_maintenance.

  ## Examples

      iex> update_company_maintenance(company_maintenance, %{field: new_value})
      {:ok, %Company_maintenance{}}

      iex> update_company_maintenance(company_maintenance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company_maintenance(%Company_maintenance{} = company_maintenance, attrs) do
    company_maintenance
    |> Company_maintenance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company_maintenance.

  ## Examples

      iex> delete_company_maintenance(company_maintenance)
      {:ok, %Company_maintenance{}}

      iex> delete_company_maintenance(company_maintenance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company_maintenance(%Company_maintenance{} = company_maintenance) do
    Repo.delete(company_maintenance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company_maintenance changes.

  ## Examples

      iex> change_company_maintenance(company_maintenance)
      %Ecto.Changeset{data: %Company_maintenance{}}

  """
  def change_company_maintenance(%Company_maintenance{} = company_maintenance, attrs \\ %{}) do
    Company_maintenance.changeset(company_maintenance, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Password_maintenance

  @doc """
  Returns the list of tbl_password_maintenance.

  ## Examples

      iex> list_tbl_password_maintenance()
      [%Password_maintenance{}, ...]

  """
  def list_tbl_password_maintenance do
    Repo.all(Password_maintenance)
  end

  @doc """
  Gets a single password_maintenance.

  Raises `Ecto.NoResultsError` if the Password maintenance does not exist.

  ## Examples

      iex> get_password_maintenance!(123)
      %Password_maintenance{}

      iex> get_password_maintenance!(456)
      ** (Ecto.NoResultsError)

  """
  def get_password_maintenance!(id), do: Repo.get!(Password_maintenance, id)

  @doc """
  Creates a password_maintenance.

  ## Examples

      iex> create_password_maintenance(%{field: value})
      {:ok, %Password_maintenance{}}

      iex> create_password_maintenance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_password_maintenance(attrs \\ %{}) do
    %Password_maintenance{}
    |> Password_maintenance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a password_maintenance.

  ## Examples

      iex> update_password_maintenance(password_maintenance, %{field: new_value})
      {:ok, %Password_maintenance{}}

      iex> update_password_maintenance(password_maintenance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_password_maintenance(%Password_maintenance{} = password_maintenance, attrs) do
    password_maintenance
    |> Password_maintenance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a password_maintenance.

  ## Examples

      iex> delete_password_maintenance(password_maintenance)
      {:ok, %Password_maintenance{}}

      iex> delete_password_maintenance(password_maintenance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_password_maintenance(%Password_maintenance{} = password_maintenance) do
    Repo.delete(password_maintenance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking password_maintenance changes.

  ## Examples

      iex> change_password_maintenance(password_maintenance)
      %Ecto.Changeset{data: %Password_maintenance{}}

  """
  def change_password_maintenance(%Password_maintenance{} = password_maintenance, attrs \\ %{}) do
    Password_maintenance.changeset(password_maintenance, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Working_days

  @doc """
  Returns the list of tbl_workingdays_maintenance.

  ## Examples

      iex> list_tbl_workingdays_maintenance()
      [%Working_days{}, ...]

  """
  def list_tbl_workingdays_maintenance do
    Repo.all(Working_days)
  end

  def workingdays_maintenance_info() do
    Repo.one(Working_days)
  end

  @doc """
  Gets a single working_days.

  Raises `Ecto.NoResultsError` if the Working days does not exist.

  ## Examples

      iex> get_working_days!(123)
      %Working_days{}

      iex> get_working_days!(456)
      ** (Ecto.NoResultsError)

  """
  def get_working_days!(id), do: Repo.get!(Working_days, id)

  @doc """
  Creates a working_days.

  ## Examples

      iex> create_working_days(%{field: value})
      {:ok, %Working_days{}}

      iex> create_working_days(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_working_days(attrs \\ %{}) do
    %Working_days{}
    |> Working_days.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a working_days.

  ## Examples

      iex> update_working_days(working_days, %{field: new_value})
      {:ok, %Working_days{}}

      iex> update_working_days(working_days, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_working_days(%Working_days{} = working_days, attrs) do
    working_days
    |> Working_days.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a working_days.

  ## Examples

      iex> delete_working_days(working_days)
      {:ok, %Working_days{}}

      iex> delete_working_days(working_days)
      {:error, %Ecto.Changeset{}}

  """
  def delete_working_days(%Working_days{} = working_days) do
    Repo.delete(working_days)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking working_days changes.

  ## Examples

      iex> change_working_days(working_days)
      %Ecto.Changeset{data: %Working_days{}}

  """
  def change_working_days(%Working_days{} = working_days, attrs \\ %{}) do
    Working_days.changeset(working_days, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Holiday_mgt

  @doc """
  Returns the list of tbl_holiday_maintenance.

  ## Examples

      iex> list_tbl_holiday_maintenance()
      [%Holiday_mgt{}, ...]

  """
  def list_tbl_holiday_maintenance do
    Repo.all(Holiday_mgt)
  end

  @doc """
  Gets a single holiday_mgt.

  Raises `Ecto.NoResultsError` if the Holiday mgt does not exist.

  ## Examples

      iex> get_holiday_mgt!(123)
      %Holiday_mgt{}

      iex> get_holiday_mgt!(456)
      ** (Ecto.NoResultsError)

  """
  def get_holiday_mgt!(id), do: Repo.get!(Holiday_mgt, id)

  @doc """
  Creates a holiday_mgt.

  ## Examples

      iex> create_holiday_mgt(%{field: value})
      {:ok, %Holiday_mgt{}}

      iex> create_holiday_mgt(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_holiday_mgt(attrs \\ %{}) do
    %Holiday_mgt{}
    |> Holiday_mgt.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a holiday_mgt.

  ## Examples

      iex> update_holiday_mgt(holiday_mgt, %{field: new_value})
      {:ok, %Holiday_mgt{}}

      iex> update_holiday_mgt(holiday_mgt, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_holiday_mgt(%Holiday_mgt{} = holiday_mgt, attrs) do
    holiday_mgt
    |> Holiday_mgt.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a holiday_mgt.

  ## Examples

      iex> delete_holiday_mgt(holiday_mgt)
      {:ok, %Holiday_mgt{}}

      iex> delete_holiday_mgt(holiday_mgt)
      {:error, %Ecto.Changeset{}}

  """
  def delete_holiday_mgt(%Holiday_mgt{} = holiday_mgt) do
    Repo.delete(holiday_mgt)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking holiday_mgt changes.

  ## Examples

      iex> change_holiday_mgt(holiday_mgt)
      %Ecto.Changeset{data: %Holiday_mgt{}}

  """
  def change_holiday_mgt(%Holiday_mgt{} = holiday_mgt, attrs \\ %{}) do
    Holiday_mgt.changeset(holiday_mgt, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Maker_checker

  @doc """
  Returns the list of tbl_maker_checker.

  ## Examples

      iex> list_tbl_maker_checker()
      [%Maker_checker{}, ...]

  """
  def list_tbl_maker_checker do
    Repo.all(Maker_checker)
  end

  @doc """
  Gets a single maker_checker.

  Raises `Ecto.NoResultsError` if the Maker checker does not exist.

  ## Examples

      iex> get_maker_checker!(123)
      %Maker_checker{}

      iex> get_maker_checker!(456)
      ** (Ecto.NoResultsError)

  """
  def get_maker_checker!(id), do: Repo.get!(Maker_checker, id)

  @doc """
  Creates a maker_checker.

  ## Examples

      iex> create_maker_checker(%{field: value})
      {:ok, %Maker_checker{}}

      iex> create_maker_checker(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_maker_checker(attrs \\ %{}) do
    %Maker_checker{}
    |> Maker_checker.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a maker_checker.

  ## Examples

      iex> update_maker_checker(maker_checker, %{field: new_value})
      {:ok, %Maker_checker{}}

      iex> update_maker_checker(maker_checker, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_maker_checker(%Maker_checker{} = maker_checker, attrs) do
    maker_checker
    |> Maker_checker.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a maker_checker.

  ## Examples

      iex> delete_maker_checker(maker_checker)
      {:ok, %Maker_checker{}}

      iex> delete_maker_checker(maker_checker)
      {:error, %Ecto.Changeset{}}

  """
  def delete_maker_checker(%Maker_checker{} = maker_checker) do
    Repo.delete(maker_checker)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking maker_checker changes.

  ## Examples

      iex> change_maker_checker(maker_checker)
      %Ecto.Changeset{data: %Maker_checker{}}

  """
  def change_maker_checker(%Maker_checker{} = maker_checker, attrs \\ %{}) do
    Maker_checker.changeset(maker_checker, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Alert_Maintenance

  @doc """
  Returns the list of tbl_alert_maintenance.

  ## Examples

      iex> list_tbl_alert_maintenance()
      [%Alert_Maintenance{}, ...]

  """
  # Loanmanagementsystem.Maintenance.list_tbl_alert_maintenance
  def list_tbl_alert_maintenance do
    Repo.all(Alert_Maintenance)
  end

  @doc """
  Gets a single alert__maintenance.

  Raises `Ecto.NoResultsError` if the Alert  maintenance does not exist.

  ## Examples

      iex> get_alert__maintenance!(123)
      %Alert_Maintenance{}

      iex> get_alert__maintenance!(456)
      ** (Ecto.NoResultsError)

  """

  # Loanmanagementsystem.Maintenance.get_alert__maintenance!
  def get_alert__maintenance!(id), do: Repo.get!(Alert_Maintenance, id)

  @doc """
  Creates a alert__maintenance.

  ## Examples

      iex> create_alert__maintenance(%{field: value})
      {:ok, %Alert_Maintenance{}}

      iex> create_alert__maintenance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_alert__maintenance(attrs \\ %{}) do
    %Alert_Maintenance{}
    |> Alert_Maintenance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a alert__maintenance.

  ## Examples

      iex> update_alert__maintenance(alert__maintenance, %{field: new_value})
      {:ok, %Alert_Maintenance{}}

      iex> update_alert__maintenance(alert__maintenance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_alert__maintenance(%Alert_Maintenance{} = alert__maintenance, attrs) do
    alert__maintenance
    |> Alert_Maintenance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a alert__maintenance.

  ## Examples

      iex> delete_alert__maintenance(alert__maintenance)
      {:ok, %Alert_Maintenance{}}

      iex> delete_alert__maintenance(alert__maintenance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_alert__maintenance(%Alert_Maintenance{} = alert__maintenance) do
    Repo.delete(alert__maintenance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking alert__maintenance changes.

  ## Examples

      iex> change_alert__maintenance(alert__maintenance)
      %Ecto.Changeset{data: %Alert_Maintenance{}}

  """
  def change_alert__maintenance(%Alert_Maintenance{} = alert__maintenance, attrs \\ %{}) do
    Alert_Maintenance.changeset(alert__maintenance, attrs)
  end

  alias Loanmanagementsystem.Maintenance.Qfin_Brance_maintenance

  @doc """
  Returns the list of tbl_qfin_branches.

  ## Examples

      iex> list_tbl_qfin_branches()
      [%Qfin_Brance_maintenance{}, ...]

  """
  # Loanmanagementsystem.Maintenance.list_tbl_qfin_branches
  def list_tbl_qfin_branches do
    Repo.all(Qfin_Brance_maintenance)
  end

  @doc """
  Gets a single qfin__brance_maintenance.

  Raises `Ecto.NoResultsError` if the Qfin  brance maintenance does not exist.

  ## Examples

      iex> get_qfin__brance_maintenance!(123)
      %Qfin_Brance_maintenance{}

      iex> get_qfin__brance_maintenance!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Maintenance.get_qfin__brance_maintenance!
  def get_qfin__brance_maintenance!(id), do: Repo.get!(Qfin_Brance_maintenance, id)

  @doc """
  Creates a qfin__brance_maintenance.

  ## Examples

      iex> create_qfin__brance_maintenance(%{field: value})
      {:ok, %Qfin_Brance_maintenance{}}

      iex> create_qfin__brance_maintenance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_qfin__brance_maintenance(attrs \\ %{}) do
    %Qfin_Brance_maintenance{}
    |> Qfin_Brance_maintenance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a qfin__brance_maintenance.

  ## Examples

      iex> update_qfin__brance_maintenance(qfin__brance_maintenance, %{field: new_value})
      {:ok, %Qfin_Brance_maintenance{}}

      iex> update_qfin__brance_maintenance(qfin__brance_maintenance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_qfin__brance_maintenance(
        %Qfin_Brance_maintenance{} = qfin__brance_maintenance,
        attrs
      ) do
    qfin__brance_maintenance
    |> Qfin_Brance_maintenance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a qfin__brance_maintenance.

  ## Examples

      iex> delete_qfin__brance_maintenance(qfin__brance_maintenance)
      {:ok, %Qfin_Brance_maintenance{}}

      iex> delete_qfin__brance_maintenance(qfin__brance_maintenance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_qfin__brance_maintenance(%Qfin_Brance_maintenance{} = qfin__brance_maintenance) do
    Repo.delete(qfin__brance_maintenance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking qfin__brance_maintenance changes.

  ## Examples

      iex> change_qfin__brance_maintenance(qfin__brance_maintenance)
      %Ecto.Changeset{data: %Qfin_Brance_maintenance{}}

  """
  def change_qfin__brance_maintenance(
        %Qfin_Brance_maintenance{} = qfin__brance_maintenance,
        attrs \\ %{}
      ) do
    Qfin_Brance_maintenance.changeset(qfin__brance_maintenance, attrs)
  end
end
