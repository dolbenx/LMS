defmodule LoanSavingsSystem.Companies do
  @moduledoc """
  The Companies context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Companies.Company

  @doc """
  Returns the list of tbl_company.

  ## Examples

      iex> list_tbl_company()
      [%Company{}, ...]

  """
  def list_tbl_company do
    Repo.all(Company)
  end

  def comp_id(company_id) do
    Company
    |> where([a], a.company_id == ^company_id)
    |> select(
      [a],
      map(a, [:company_id, :company_id, :company_name])
    )
    |> Repo.one()
 end

  @doc """
  Gets a single company.

  Raises `Ecto.NoResultsError` if the Company does not exist.

  ## Examples

      iex> get_company!(123)
      %Company{}

      iex> get_company!(456)
      ** (Ecto.NoResultsError)

  """
  def get_company!(id), do: Repo.get!(Company, id)

  @doc """
  Creates a company.

  ## Examples

      iex> create_company(%{field: value})
      {:ok, %Company{}}

      iex> create_company(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_company(attrs \\ %{}) do
    %Company{}
    |> Company.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a company.

  ## Examples

      iex> update_company(company, %{field: new_value})
      {:ok, %Company{}}

      iex> update_company(company, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_company(%Company{} = company, attrs) do
    company
    |> Company.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a company.

  ## Examples

      iex> delete_company(company)
      {:ok, %Company{}}

      iex> delete_company(company)
      {:error, %Ecto.Changeset{}}

  """
  def delete_company(%Company{} = company) do
    Repo.delete(company)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking company changes.

  ## Examples

      iex> change_company(company)
      %Ecto.Changeset{source: %Company{}}

  """
  def change_company(%Company{} = company) do
    Company.changeset(company, %{})
  end

  alias LoanSavingsSystem.Companies.Employer

  @doc """
  Returns the list of tbl.

  ## Examples

      iex> list_tbl()
      [%Employer{}, ...]

  """
  def list_tbl do
    Repo.all(Employer)
  end

  @doc """
  Gets a single employer.

  Raises `Ecto.NoResultsError` if the Employer does not exist.

  ## Examples

      iex> get_employer!(123)
      %Employer{}

      iex> get_employer!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employer!(id), do: Repo.get!(Employer, id)

  @doc """
  Creates a employer.

  ## Examples

      iex> create_employer(%{field: value})
      {:ok, %Employer{}}

      iex> create_employer(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employer(attrs \\ %{}) do
    %Employer{}
    |> Employer.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employer.

  ## Examples

      iex> update_employer(employer, %{field: new_value})
      {:ok, %Employer{}}

      iex> update_employer(employer, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employer(%Employer{} = employer, attrs) do
    employer
    |> Employer.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a employer.

  ## Examples

      iex> delete_employer(employer)
      {:ok, %Employer{}}

      iex> delete_employer(employer)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employer(%Employer{} = employer) do
    Repo.delete(employer)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employer changes.

  ## Examples

      iex> change_employer(employer)
      %Ecto.Changeset{source: %Employer{}}

  """
  def change_employer(%Employer{} = employer) do
    Employer.changeset(employer, %{})
  end

  alias LoanSavingsSystem.Companies.Employee
  alias LoanSavingsSystem.Companies.Company

  @doc """
  Returns the list of tbl_employee.

  ## Examples

      iex> list_tbl_employee()
      [%Employee{}, ...]

  """
  def list_tbl_employee do
    Repo.all(Employee)
  end

  def list_employee_with_company_id(company_id) do
    Company
      |> join(:left, [c], u in "tbl_employee", on: c.company_id == u.company_id)
      |> where([c, u], c.company_id == ^company_id)
      |> select([c, u], %{
        company_name: c.company_name,
        first_name: u.first_name,
        last_name: u.last_name,
        other_name: u.other_name,
        id: u.id,
        status: u.status,
        last_name: u.last_name,
        id: u.id,
        company_id: u.company_id,
        email: u.email,
        phone: u.phone,
        id_no: u.id_no,
        status: u.status,
        city: u.city,
        country: u.country,
        staff_id: u.staff_id,
        id_type: u.id_type
      })
      |> Repo.all()
  end

  def get_employee_data do
    Company
      |> join(:left, [c], u in "tbl_employee", on: c.company_id == u.company_id)
      |> select([c, u], %{
        company_name: c.company_name,
        first_name: u.first_name,
        last_name: u.last_name,
        other_name: u.other_name,
        id: u.id,
        status: u.status,
        last_name: u.last_name,
        id: u.id,
        company_id: u.company_id,
        email: u.email,
        phone: u.phone,
        id_no: u.id_no,
        status: u.status,
        city: u.city,
        country: u.country,
        staff_id: u.staff_id,
        id_type: u.id_type
      })
      |> Repo.all()
   end

  @doc """
  Gets a single employee.

  Raises `Ecto.NoResultsError` if the Employee does not exist.

  ## Examples

      iex> get_employee!(123)
      %Employee{}

      iex> get_employee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_employee!(id), do: Repo.get!(Employee, id)

  @doc """
  Creates a employee.

  ## Examples

      iex> create_employee(%{field: value})
      {:ok, %Employee{}}

      iex> create_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_employee(attrs \\ %{}) do
    %Employee{}
    |> Employee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a employee.

  ## Examples

      iex> update_employee(employee, %{field: new_value})
      {:ok, %Employee{}}

      iex> update_employee(employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_employee(%Employee{} = employee, attrs) do
    employee
    |> Employee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a employee.

  ## Examples

      iex> delete_employee(employee)
      {:ok, %Employee{}}

      iex> delete_employee(employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_employee(%Employee{} = employee) do
    Repo.delete(employee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking employee changes.

  ## Examples

      iex> change_employee(employee)
      %Ecto.Changeset{source: %Employee{}}

  """
  def change_employee(%Employee{} = employee) do
    Employee.changeset(employee, %{})
  end

  alias LoanSavingsSystem.Companies.Branch

  @doc """
  Returns the list of tbl_branch.

  ## Examples

      iex> list_tbl_branch()
      [%Branch{}, ...]

  """
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
      %Ecto.Changeset{source: %Branch{}}

  """
  def change_branch(%Branch{} = branch) do
    Branch.changeset(branch, %{})
  end
end
