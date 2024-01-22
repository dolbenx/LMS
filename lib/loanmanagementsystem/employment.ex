defmodule Loanmanagementsystem.Employment do
  @moduledoc """
  The Employment context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Accounts.Address_Details

  @doc """
  Returns the list of employment_type.

  ## Examples

      iex> list_employment_type()
      [%Employment_Details{}, ...]

  """
  def list_employment_type do
    Repo.all(Employment_Details)
  end


  def list_customer_reference_details(customer_id) do
    Employment_Details
    |> where([l], l.userId == ^customer_id)
    |> select([l], %{
      area: l.area,
      date_of_joining: l.date_of_joining,
      employee_number: l.employee_number,
      employer: l.employer,
      employer_industry_type: l.employer_industry_type,
      employer_office_building_name: l.employer_office_building_name,
      employer_officer_street_name: l.employer_officer_street_name,
      employment_type: l.employment_type,
      hr_supervisor_email: l.hr_supervisor_email,
      hr_supervisor_mobile_number: l.hr_supervisor_mobile_number,
      hr_supervisor_name: l.hr_supervisor_name,
      job_title: l.job_title,
      occupation: l.occupation,
      province: l.province,
      town: l.town,
      userId: l.userId,
      departmentId: l.departmentId,
      mobile_network_operator: l.mobile_network_operator,
      registered_name_mobile_number: l.registered_name_mobile_number,
      contract_start_date: l.contract_start_date,
      contract_end_date: l.contract_end_date,

    })
    |> limit(1)
    |> Repo.one()
  end


  def list_customer_reference_details_validation(userId) do
    try do list_customer_reference_details(userId) ||
    %{
      area: "",
      date_of_joining: "",
      employee_number: "",
      employer: "",
      employer_industry_type: "",
      employer_office_building_name: "",
      employer_officer_street_name: "",
      employment_type: "",
      hr_supervisor_email: "",
      hr_supervisor_mobile_number: "",
      hr_supervisor_name: "",
      job_title: "",
      occupation: "",
      province: "",
      town: "",
      userId: "",
      departmentId: "",
      mobile_network_operator: "",
      registered_name_mobile_number: "",
      contract_start_date: "",
      contract_end_date: "",

    }
    rescue _->
      "FAILED"
    end
  end


  @doc """
  Gets a single employment__details.

  Raises `Ecto.NoResultsError` if the Employment  details does not exist.

  ## Examples

      iex> get_employment__details!(123)
      %Employment_Details{}

      iex> get_employment__details!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Employment.get_employment__details_by_userId(1269)
  def get_employment__details!(id), do: Repo.get!(Employment_Details, id)
  # Loanmanagementsystem.Employment.get_employment__details_by_userId
  def get_employment__details_by_userId(userId) do
    Employment_Details
    |>join(:left, [eD], aD in Address_Details, on: eD.userId == aD.userId)
    |> where([eD, aD], eD.userId == ^userId)
    |> select([eD, aD], %{
      accomodation_status: aD.accomodation_status,
      area: aD.area,
      house_number: aD.house_number,
      street_name: aD.street_name,
      personal_town: aD.town,
      personal_province: aD.province,
      land_mark: aD.land_mark,
      area: eD.area,
      date_of_joining: eD.date_of_joining,
      employee_number: eD.employee_number,
      employer: eD.employer,
      employer_industry_type: eD.employer_industry_type,
      employer_office_building_name: eD.employer_office_building_name,
      employer_officer_street_name: eD.employer_officer_street_name,
      employment_type: eD.employment_type,
      hr_supervisor_email: eD.hr_supervisor_email,
      hr_supervisor_mobile_number: eD.hr_supervisor_mobile_number,
      hr_supervisor_name: eD.hr_supervisor_name,
      job_title: eD.job_title,
      occupation: eD.occupation,
      province: eD.province,
      town: eD.town,
      userId: aD.userId,
      departmentId: eD.departmentId,
      # departmentIdinteger
      mobile_network_operator: eD.mobile_network_operator,
      registered_name_mobile_number: eD.registered_name_mobile_number,
      contract_start_date: eD.contract_start_date,
      contract_end_date: eD.contract_end_date,

    })
    |> Repo.all()

  end




  @doc """
  Creates a employment__details.

  ## Examples

      iex> create_employment__details(%{field: value})
      {:ok, %Employment_Details{}}

      iex> create_employment__details(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employment__details(attrs \\ %{}) do
    %Employment_Details{}
    |> Employment_Details.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employment__details.

  ## Examples

      iex> update_employment__details(employment__details, %{field: new_value})
      {:ok, %Employment_Details{}}

      iex> update_employment__details(employment__details, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employment__details(%Employment_Details{} = employment__details, attrs) do
    employment__details
    |> Employment_Details.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a employment__details.

  ## Examples

      iex> delete_employment__details(employment__details)
      {:ok, %Employment_Details{}}

      iex> delete_employment__details(employment__details)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employment__details(%Employment_Details{} = employment__details) do
    Repo.delete(employment__details)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employment__details changes.

  ## Examples

      iex> change_employment__details(employment__details)
      %Ecto.Changeset{data: %Employment_Details{}}

  """
  def change_employment__details(%Employment_Details{} = employment__details, attrs \\ %{}) do
    Employment_Details.changeset(employment__details, attrs)
  end

  alias Loanmanagementsystem.Employment.Income_Details

  @doc """
  Returns the list of tbl_income_details.

  ## Examples

      iex> list_tbl_income_details()
      [%Income_Details{}, ...]

  """
  def list_tbl_income_details do
    Repo.all(Income_Details)
  end

  @doc """
  Gets a single income__details.

  Raises `Ecto.NoResultsError` if the Income  details does not exist.

  ## Examples

      iex> get_income__details!(123)
      %Income_Details{}

      iex> get_income__details!(456)
      ** (Ecto.NoResultsError)

  """
  def get_income__details!(id), do: Repo.get!(Income_Details, id)

  @doc """
  Creates a income__details.

  ## Examples

      iex> create_income__details(%{field: value})
      {:ok, %Income_Details{}}

      iex> create_income__details(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_income__details(attrs \\ %{}) do
    %Income_Details{}
    |> Income_Details.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a income__details.

  ## Examples

      iex> update_income__details(income__details, %{field: new_value})
      {:ok, %Income_Details{}}

      iex> update_income__details(income__details, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_income__details(%Income_Details{} = income__details, attrs) do
    income__details
    |> Income_Details.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a income__details.

  ## Examples

      iex> delete_income__details(income__details)
      {:ok, %Income_Details{}}

      iex> delete_income__details(income__details)
      {:error, %Ecto.Changeset{}}

  """
  def delete_income__details(%Income_Details{} = income__details) do
    Repo.delete(income__details)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking income__details changes.

  ## Examples

      iex> change_income__details(income__details)
      %Ecto.Changeset{data: %Income_Details{}}

  """
  def change_income__details(%Income_Details{} = income__details, attrs \\ %{}) do
    Income_Details.changeset(income__details, attrs)
  end

  alias Loanmanagementsystem.Employment.Personal_Bank_Details

  @doc """
  Returns the list of tbl_personal_bank_details.

  ## Examples

      iex> list_tbl_personal_bank_details()
      [%Personal_Bank_Details{}, ...]

  """
  def list_tbl_personal_bank_details do
    Repo.all(Personal_Bank_Details)
  end

  @doc """
  Gets a single personal__bank__details.

  Raises `Ecto.NoResultsError` if the Personal  bank  details does not exist.

  ## Examples

      iex> get_personal__bank__details!(123)
      %Personal_Bank_Details{}

      iex> get_personal__bank__details!(456)
      ** (Ecto.NoResultsError)

  """
  def get_personal__bank__details!(id), do: Repo.get!(Personal_Bank_Details, id)
  # Loanmanagementsystem.Employment.get_personal__bank__details_by_userId
  def get_personal__bank__details_by_userId(userId),
    do: Repo.get_by(Personal_Bank_Details, userId: userId)

  @doc """
  Creates a personal__bank__details.

  ## Examples

      iex> create_personal__bank__details(%{field: value})
      {:ok, %Personal_Bank_Details{}}

      iex> create_personal__bank__details(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_personal__bank__details(attrs \\ %{}) do
    %Personal_Bank_Details{}
    |> Personal_Bank_Details.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a personal__bank__details.

  ## Examples

      iex> update_personal__bank__details(personal__bank__details, %{field: new_value})
      {:ok, %Personal_Bank_Details{}}

      iex> update_personal__bank__details(personal__bank__details, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_personal__bank__details(%Personal_Bank_Details{} = personal__bank__details, attrs) do
    personal__bank__details
    |> Personal_Bank_Details.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a personal__bank__details.

  ## Examples

      iex> delete_personal__bank__details(personal__bank__details)
      {:ok, %Personal_Bank_Details{}}

      iex> delete_personal__bank__details(personal__bank__details)
      {:error, %Ecto.Changeset{}}

  """
  def delete_personal__bank__details(%Personal_Bank_Details{} = personal__bank__details) do
    Repo.delete(personal__bank__details)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking personal__bank__details changes.

  ## Examples

      iex> change_personal__bank__details(personal__bank__details)
      %Ecto.Changeset{data: %Personal_Bank_Details{}}

  """
  def change_personal__bank__details(
        %Personal_Bank_Details{} = personal__bank__details,
        attrs \\ %{}
      ) do
    Personal_Bank_Details.changeset(personal__bank__details, attrs)
  end

      # Loanmanagementsystem.Employment.get_user_bank_details_by_user_id(61)
      def get_user_bank_details_by_user_id(userId) do
        Personal_Bank_Details
        |> where([bk], bk.userId == ^userId)
        |> select([bk], %{
          bankName: bk.bankName,
          branchName: bk.branchName,
          accountNumber: bk.accountNumber,
          accountName: bk.accountName,
          upload_bank_statement: bk.upload_bank_statement,
          userId: bk.userId,
          bank_id: bk.bank_id,
          mobile_number: bk.mobile_number,
          bank_name_branch: fragment("CONCAT(?, ' (', ?, ')')", bk.bankName, bk.branchName),
          id: bk.id
        })
        |> Repo.all()
      end

  alias Loanmanagementsystem.Employment.Employee_Maintenance

  @doc """
  Returns the list of tbl_employee_maintenance.

  ## Examples

      iex> list_tbl_employee_maintenance()
      [%Employee_Maintenance{}, ...]

  """
  def list_tbl_employee_maintenance do
    Repo.all(Employee_Maintenance)
  end

  @doc """
  Gets a single employee__maintenance.

  Raises `Ecto.NoResultsError` if the Employee  maintenance does not exist.

  ## Examples

      iex> get_employee__maintenance!(123)
      %Employee_Maintenance{}

      iex> get_employee__maintenance!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Employment.get_employee__maintenance!
  def get_employee__maintenance!(id), do: Repo.get!(Employee_Maintenance, id)
  # Loanmanagementsystem.Employment.get_employee__maintenance_by_userId
  def get_employee__maintenance_by_userId(userId),
    do: Repo.get_by(Employee_Maintenance, userId: userId)

  @doc """
  Creates a employee__maintenance.

  ## Examples

      iex> create_employee__maintenance(%{field: value})
      {:ok, %Employee_Maintenance{}}

      iex> create_employee__maintenance(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee__maintenance(attrs \\ %{}) do
    %Employee_Maintenance{}
    |> Employee_Maintenance.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employee__maintenance.

  ## Examples

      iex> update_employee__maintenance(employee__maintenance, %{field: new_value})
      {:ok, %Employee_Maintenance{}}

      iex> update_employee__maintenance(employee__maintenance, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee__maintenance(%Employee_Maintenance{} = employee__maintenance, attrs) do
    employee__maintenance
    |> Employee_Maintenance.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a employee__maintenance.

  ## Examples

      iex> delete_employee__maintenance(employee__maintenance)
      {:ok, %Employee_Maintenance{}}

      iex> delete_employee__maintenance(employee__maintenance)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee__maintenance(%Employee_Maintenance{} = employee__maintenance) do
    Repo.delete(employee__maintenance)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee__maintenance changes.

  ## Examples

      iex> change_employee__maintenance(employee__maintenance)
      %Ecto.Changeset{data: %Employee_Maintenance{}}

  """
  def change_employee__maintenance(%Employee_Maintenance{} = employee__maintenance, attrs \\ %{}) do
    Employee_Maintenance.changeset(employee__maintenance, attrs)
  end
end
