defmodule Loanmanagementsystem.Employment do
  @moduledoc """
  The Employment context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Employment.Income_Details

  @doc """
  Returns the list of employment_type.

  # Loanmanagementsystem.Employment.list_employement(79)

  ## Examples

      iex> list_employment_type()
      [%Employment_Details{}, ...]

  """

  def list_employement(user_id) do
    Employment_Details
    |> where([n], n.userId == ^user_id)
    |> select([n], %{
      area: n.area,
      date_of_joining: n.date_of_joining,
      employee_number: n.employee_number,
      employer: n.employer,
      employer_industry_type: n.employer_industry_type,
      employer_office_building_name: n.employer_office_building_name,
      employer_officer_street_name: n.employer_officer_street_name,
      employment_type: n.employment_type,
      hr_supervisor_email: n.hr_supervisor_email,
      hr_supervisor_mobile_number: n.hr_supervisor_mobile_number,
      hr_supervisor_name: n.hr_supervisor_name,
      job_title: n.job_title,
      occupation: n.occupation,
      province: n.province,
      town: n.town,
      userId: n.userId,
      departmentId: n.departmentId,
      mobile_network_operator: n.mobile_network_operator,
      registered_name_mobile_number: n.registered_name_mobile_number,
      contract_start_date: n.contract_start_date,
      contract_end_date: n.contract_end_date,

    })
    |> limit(1)
    |> Repo.one()
  end

  def list_income_details(user_id) do
    Income_Details
    |> where([n], n.userId == ^user_id)
    |> select([n], %{
      gross_pay: n.gross_pay,
      net_pay: n.net_pay,
      pay_day: n.pay_day,
      total_deductions: n.total_deductions,
      total_expenses: n.total_expenses,
      upload_payslip: n.upload_payslip,
      userId: n.userId,

    })
    |> limit(1)
    |> Repo.one()
  end


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


  @doc """
  Gets a single employment__details.

  Raises `Ecto.NoResultsError` if the Employment  details does not exist.

  ## Examples

      iex> get_employment__details!(123)
      %Employment_Details{}

      iex> get_employment__details!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employment__details!(id), do: Repo.get!(Employment_Details, id)
  # Loanmanagementsystem.Employment.get_employment__details_by_userId
  def get_employment__details_by_userId(userId),
    do: Repo.get_by(Employment_Details, userId: userId)

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


    def get_employee__details_by_userId(userId),
    do: Repo.get_by(Employment_Details, userId: userId)
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
