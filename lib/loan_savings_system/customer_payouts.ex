defmodule LoanSavingsSystem.CustomerPayouts do
  @moduledoc """
  The CustomerPayouts context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.CustomerPayouts.CustomerPayout

  @doc """
  Returns the list of tbl_customerpayouts.

  ## Examples

      iex> list_tbl_customerpayouts()
      [%CustomerPayout{}, ...]

  """
  def list_tbl_customerpayouts do
    Repo.all(CustomerPayout)
  end

  @doc """
  Gets a single customer_payout.

  Raises `Ecto.NoResultsError` if the Customer payout does not exist.

  ## Examples

      iex> get_customer_payout!(123)
      %CustomerPayout{}

      iex> get_customer_payout!(456)
      ** (Ecto.NoResultsError)

  """
  def get_customer_payout!(id), do: Repo.get!(CustomerPayout, id)

  @doc """
  Creates a customer_payout.

  ## Examples

      iex> create_customer_payout(%{field: value})
      {:ok, %CustomerPayout{}}

      iex> create_customer_payout(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_customer_payout(attrs \\ %{}) do
    %CustomerPayout{}
    |> CustomerPayout.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a customer_payout.

  ## Examples

      iex> update_customer_payout(customer_payout, %{field: new_value})
      {:ok, %CustomerPayout{}}

      iex> update_customer_payout(customer_payout, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_customer_payout(%CustomerPayout{} = customer_payout, attrs) do
    customer_payout
    |> CustomerPayout.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a customer_payout.

  ## Examples

      iex> delete_customer_payout(customer_payout)
      {:ok, %CustomerPayout{}}

      iex> delete_customer_payout(customer_payout)
      {:error, %Ecto.Changeset{}}

  """
  def delete_customer_payout(%CustomerPayout{} = customer_payout) do
    Repo.delete(customer_payout)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking customer_payout changes.

  ## Examples

      iex> change_customer_payout(customer_payout)
      %Ecto.Changeset{source: %CustomerPayout{}}

  """
  def change_customer_payout(%CustomerPayout{} = customer_payout) do
    CustomerPayout.changeset(customer_payout, %{})
  end
end
