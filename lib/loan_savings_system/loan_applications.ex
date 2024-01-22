defmodule LoanSavingsSystem.LoanApplications do
  @moduledoc """
  The LoanApplications context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.LoanApplications.LoanApplicationsSme

  @doc """
  Returns the list of tbl_sme_loan_application.

  ## Examples

      iex> list_tbl_sme_loan_application()
      [%LoanApplicationsSme{}, ...]

  """
  def list_tbl_sme_loan_application do
    Repo.all(LoanApplicationsSme)
  end

  @doc """
  Gets a single loan_applications_sme.

  Raises `Ecto.NoResultsError` if the Loan applications sme does not exist.

  ## Examples

      iex> get_loan_applications_sme!(123)
      %LoanApplicationsSme{}

      iex> get_loan_applications_sme!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_applications_sme!(id), do: Repo.get!(LoanApplicationsSme, id)

  @doc """
  Creates a loan_applications_sme.

  ## Examples

      iex> create_loan_applications_sme(%{field: value})
      {:ok, %LoanApplicationsSme{}}

      iex> create_loan_applications_sme(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_applications_sme(attrs \\ %{}) do
    %LoanApplicationsSme{}
    |> LoanApplicationsSme.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_applications_sme.

  ## Examples

      iex> update_loan_applications_sme(loan_applications_sme, %{field: new_value})
      {:ok, %LoanApplicationsSme{}}

      iex> update_loan_applications_sme(loan_applications_sme, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_applications_sme(%LoanApplicationsSme{} = loan_applications_sme, attrs) do
    loan_applications_sme
    |> LoanApplicationsSme.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_applications_sme.

  ## Examples

      iex> delete_loan_applications_sme(loan_applications_sme)
      {:ok, %LoanApplicationsSme{}}

      iex> delete_loan_applications_sme(loan_applications_sme)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_applications_sme(%LoanApplicationsSme{} = loan_applications_sme) do
    Repo.delete(loan_applications_sme)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_applications_sme changes.

  ## Examples

      iex> change_loan_applications_sme(loan_applications_sme)
      %Ecto.Changeset{data: %LoanApplicationsSme{}}

  """
  def change_loan_applications_sme(%LoanApplicationsSme{} = loan_applications_sme, attrs \\ %{}) do
    LoanApplicationsSme.changeset(loan_applications_sme, attrs)
  end

  alias LoanSavingsSystem.LoanApplications.LoanApplicationsEmployee

  @doc """
  Returns the list of tbl_employee_loan_application.

  ## Examples

      iex> list_tbl_employee_loan_application()
      [%LoanApplicationsEmployee{}, ...]

  """
  def list_tbl_employee_loan_application do
    Repo.all(LoanApplicationsEmployee)
  end

  @doc """
  Gets a single loan_applications_employee.

  Raises `Ecto.NoResultsError` if the Loan applications employee does not exist.

  ## Examples

      iex> get_loan_applications_employee!(123)
      %LoanApplicationsEmployee{}

      iex> get_loan_applications_employee!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_applications_employee!(id), do: Repo.get!(LoanApplicationsEmployee, id)

  @doc """
  Creates a loan_applications_employee.

  ## Examples

      iex> create_loan_applications_employee(%{field: value})
      {:ok, %LoanApplicationsEmployee{}}

      iex> create_loan_applications_employee(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_applications_employee(attrs \\ %{}) do
    %LoanApplicationsEmployee{}
    |> LoanApplicationsEmployee.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_applications_employee.

  ## Examples

      iex> update_loan_applications_employee(loan_applications_employee, %{field: new_value})
      {:ok, %LoanApplicationsEmployee{}}

      iex> update_loan_applications_employee(loan_applications_employee, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_applications_employee(%LoanApplicationsEmployee{} = loan_applications_employee, attrs) do
    loan_applications_employee
    |> LoanApplicationsEmployee.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_applications_employee.

  ## Examples

      iex> delete_loan_applications_employee(loan_applications_employee)
      {:ok, %LoanApplicationsEmployee{}}

      iex> delete_loan_applications_employee(loan_applications_employee)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_applications_employee(%LoanApplicationsEmployee{} = loan_applications_employee) do
    Repo.delete(loan_applications_employee)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_applications_employee changes.

  ## Examples

      iex> change_loan_applications_employee(loan_applications_employee)
      %Ecto.Changeset{data: %LoanApplicationsEmployee{}}

  """
  def change_loan_applications_employee(%LoanApplicationsEmployee{} = loan_applications_employee, attrs \\ %{}) do
    LoanApplicationsEmployee.changeset(loan_applications_employee, attrs)
  end
end
