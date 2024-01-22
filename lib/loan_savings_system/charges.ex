defmodule LoanSavingsSystem.Charges do
  @moduledoc """
  The Charges context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Charges.Charge

  @doc """
  Returns the list of tbl_charge.

  ## Examples

      iex> list_tbl_charge()
      [%Charge{}, ...]

  """
  def list_tbl_charge do
    Repo.all(Charge)
  end

  @doc """
  Gets a single charge.

  Raises `Ecto.NoResultsError` if the Charge does not exist.

  ## Examples

      iex> get_charge!(123)
      %Charge{}

      iex> get_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_charge!(id), do: Repo.get!(Charge, id)

  @doc """
  Creates a charge.

  ## Examples

      iex> create_charge(%{field: value})
      {:ok, %Charge{}}

      iex> create_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_charge(attrs \\ %{}) do
    %Charge{}
    |> Charge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a charge.

  ## Examples

      iex> update_charge(charge, %{field: new_value})
      {:ok, %Charge{}}

      iex> update_charge(charge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_charge(%Charge{} = charge, attrs) do
    charge
    |> Charge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a charge.

  ## Examples

      iex> delete_charge(charge)
      {:ok, %Charge{}}

      iex> delete_charge(charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_charge(%Charge{} = charge) do
    Repo.delete(charge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking charge changes.

  ## Examples

      iex> change_charge(charge)
      %Ecto.Changeset{source: %Charge{}}

  """
  def change_charge(%Charge{} = charge) do
    Charge.changeset(charge, %{})
  end

  alias LoanSavingsSystem.Charges.AccountCharge

  @doc """
  Returns the list of tbl_account_charge.

  ## Examples

      iex> list_tbl_account_charge()
      [%AccountCharge{}, ...]

  """
  def list_tbl_account_charge do
    Repo.all(AccountCharge)
  end

  @doc """
  Gets a single account_charge.

  Raises `Ecto.NoResultsError` if the Account charge does not exist.

  ## Examples

      iex> get_account_charge!(123)
      %AccountCharge{}

      iex> get_account_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account_charge!(id), do: Repo.get!(AccountCharge, id)

  @doc """
  Creates a account_charge.

  ## Examples

      iex> create_account_charge(%{field: value})
      {:ok, %AccountCharge{}}

      iex> create_account_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_account_charge(attrs \\ %{}) do
    %AccountCharge{}
    |> AccountCharge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a account_charge.

  ## Examples

      iex> update_account_charge(account_charge, %{field: new_value})
      {:ok, %AccountCharge{}}

      iex> update_account_charge(account_charge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_account_charge(%AccountCharge{} = account_charge, attrs) do
    account_charge
    |> AccountCharge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a account_charge.

  ## Examples

      iex> delete_account_charge(account_charge)
      {:ok, %AccountCharge{}}

      iex> delete_account_charge(account_charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_account_charge(%AccountCharge{} = account_charge) do
    Repo.delete(account_charge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking account_charge changes.

  ## Examples

      iex> change_account_charge(account_charge)
      %Ecto.Changeset{source: %AccountCharge{}}

  """
  def change_account_charge(%AccountCharge{} = account_charge) do
    AccountCharge.changeset(account_charge, %{})
  end
end
