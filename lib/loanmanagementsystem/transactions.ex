defmodule Loanmanagementsystem.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Transactions.Loan_transactions

  @doc """
  Returns the list of tbl_transactions.

  ## Examples

      iex> list_tbl_transactions()
      [%Loan_transactions{}, ...]

  """
  def list_tbl_transactions do
    Repo.all(Loan_transactions)
  end

  @doc """
  Gets a single loan_transactions.

  Raises `Ecto.NoResultsError` if the Loan transactions does not exist.

  ## Examples

      iex> get_loan_transactions!(123)
      %Loan_transactions{}

      iex> get_loan_transactions!(456)
      ** (Ecto.NoResultsError)

  """
  def get_loan_transactions!(id), do: Repo.get!(Loan_transactions, id)

  @doc """
  Creates a loan_transactions.

  ## Examples

      iex> create_loan_transactions(%{field: value})
      {:ok, %Loan_transactions{}}

      iex> create_loan_transactions(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_loan_transactions(attrs \\ %{}) do
    %Loan_transactions{}
    |> Loan_transactions.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a loan_transactions.

  ## Examples

      iex> update_loan_transactions(loan_transactions, %{field: new_value})
      {:ok, %Loan_transactions{}}

      iex> update_loan_transactions(loan_transactions, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_loan_transactions(%Loan_transactions{} = loan_transactions, attrs) do
    loan_transactions
    |> Loan_transactions.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a loan_transactions.

  ## Examples

      iex> delete_loan_transactions(loan_transactions)
      {:ok, %Loan_transactions{}}

      iex> delete_loan_transactions(loan_transactions)
      {:error, %Ecto.Changeset{}}

  """
  def delete_loan_transactions(%Loan_transactions{} = loan_transactions) do
    Repo.delete(loan_transactions)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking loan_transactions changes.

  ## Examples

      iex> change_loan_transactions(loan_transactions)
      %Ecto.Changeset{data: %Loan_transactions{}}

  """
  def change_loan_transactions(%Loan_transactions{} = loan_transactions, attrs \\ %{}) do
    Loan_transactions.changeset(loan_transactions, attrs)
  end
end
