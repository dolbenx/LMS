defmodule LoanSavingsSystem.Withdrawals do
  @moduledoc """
  The Withdrawals context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Withdrawals.MaturedWithdrawal

  @doc """
  Returns the list of maturedwithdrawals.

  ## Examples

      iex> list_maturedwithdrawals()
      [%MaturedWithdrawal{}, ...]

  """
  def list_maturedwithdrawals do
    Repo.all(MaturedWithdrawal)
  end

  @doc """
  Gets a single matured_withdrawal.

  Raises `Ecto.NoResultsError` if the Matured withdrawal does not exist.

  ## Examples

      iex> get_matured_withdrawal!(123)
      %MaturedWithdrawal{}

      iex> get_matured_withdrawal!(456)
      ** (Ecto.NoResultsError)

  """
  def get_matured_withdrawal!(id), do: Repo.get!(MaturedWithdrawal, id)

  @doc """
  Creates a matured_withdrawal.

  ## Examples

      iex> create_matured_withdrawal(%{field: value})
      {:ok, %MaturedWithdrawal{}}

      iex> create_matured_withdrawal(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_matured_withdrawal(attrs \\ %{}) do
    %MaturedWithdrawal{}
    |> MaturedWithdrawal.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a matured_withdrawal.

  ## Examples

      iex> update_matured_withdrawal(matured_withdrawal, %{field: new_value})
      {:ok, %MaturedWithdrawal{}}

      iex> update_matured_withdrawal(matured_withdrawal, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_matured_withdrawal(%MaturedWithdrawal{} = matured_withdrawal, attrs) do
    matured_withdrawal
    |> MaturedWithdrawal.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a matured_withdrawal.

  ## Examples

      iex> delete_matured_withdrawal(matured_withdrawal)
      {:ok, %MaturedWithdrawal{}}

      iex> delete_matured_withdrawal(matured_withdrawal)
      {:error, %Ecto.Changeset{}}

  """
  def delete_matured_withdrawal(%MaturedWithdrawal{} = matured_withdrawal) do
    Repo.delete(matured_withdrawal)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking matured_withdrawal changes.

  ## Examples

      iex> change_matured_withdrawal(matured_withdrawal)
      %Ecto.Changeset{source: %MaturedWithdrawal{}}

  """
  def change_matured_withdrawal(%MaturedWithdrawal{} = matured_withdrawal) do
    MaturedWithdrawal.changeset(matured_withdrawal, %{})
  end
end
