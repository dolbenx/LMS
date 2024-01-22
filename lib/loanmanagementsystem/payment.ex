defmodule Loanmanagementsystem.Payment do
  @moduledoc """
  The Payment context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Payment.Collection

  @doc """
  Returns the list of tbl_collection_type.
  
  ## Examples
  
      iex> list_tbl_collection_type()
      [%Collection{}, ...]
  
  """
  # Loanmanagementsystem.Payment.list_tbl_collection_type
  def list_tbl_collection_type do
    Repo.all(Collection)
  end

  @doc """
  Gets a single collection.
  
  Raises `Ecto.NoResultsError` if the Collection does not exist.
  
  ## Examples
  
      iex> get_collection!(123)
      %Collection{}
  
      iex> get_collection!(456)
      ** (Ecto.NoResultsError)
  
  """
  # Loanmanagementsystem.Payment.get_collection!
  def get_collection!(id), do: Repo.get!(Collection, id)

  @doc """
  Creates a collection.
  
  ## Examples
  
      iex> create_collection(%{field: value})
      {:ok, %Collection{}}
  
      iex> create_collection(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_collection(attrs \\ %{}) do
    %Collection{}
    |> Collection.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a collection.
  
  ## Examples
  
      iex> update_collection(collection, %{field: new_value})
      {:ok, %Collection{}}
  
      iex> update_collection(collection, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_collection(%Collection{} = collection, attrs) do
    collection
    |> Collection.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a collection.
  
  ## Examples
  
      iex> delete_collection(collection)
      {:ok, %Collection{}}
  
      iex> delete_collection(collection)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_collection(%Collection{} = collection) do
    Repo.delete(collection)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking collection changes.
  
  ## Examples
  
      iex> change_collection(collection)
      %Ecto.Changeset{data: %Collection{}}
  
  """
  def change_collection(%Collection{} = collection, attrs \\ %{}) do
    Collection.changeset(collection, attrs)
  end

  alias Loanmanagementsystem.Payment.Payments

  @doc """
  Returns the list of tbl_payment_type.
  
  ## Examples
  
      iex> list_tbl_payment_type()
      [%Payments{}, ...]
  
  """
  # Loanmanagementsystem.Payment.list_tbl_payment_type
  def list_tbl_payment_type do
    Repo.all(Payments)
  end

  @doc """
  Gets a single payments.
  
  Raises `Ecto.NoResultsError` if the Payments does not exist.
  
  ## Examples
  
      iex> get_payments!(123)
      %Payments{}
  
      iex> get_payments!(456)
      ** (Ecto.NoResultsError)
  
  """

  # Loanmanagementsystem.Payment.get_payments!
  def get_payments!(id), do: Repo.get!(Payments, id)

  @doc """
  Creates a payments.
  
  ## Examples
  
      iex> create_payments(%{field: value})
      {:ok, %Payments{}}
  
      iex> create_payments(%{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def create_payments(attrs \\ %{}) do
    %Payments{}
    |> Payments.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a payments.
  
  ## Examples
  
      iex> update_payments(payments, %{field: new_value})
      {:ok, %Payments{}}
  
      iex> update_payments(payments, %{field: bad_value})
      {:error, %Ecto.Changeset{}}
  
  """
  def update_payments(%Payments{} = payments, attrs) do
    payments
    |> Payments.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a payments.
  
  ## Examples
  
      iex> delete_payments(payments)
      {:ok, %Payments{}}
  
      iex> delete_payments(payments)
      {:error, %Ecto.Changeset{}}
  
  """
  def delete_payments(%Payments{} = payments) do
    Repo.delete(payments)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking payments changes.
  
  ## Examples
  
      iex> change_payments(payments)
      %Ecto.Changeset{data: %Payments{}}
  
  """
  def change_payments(%Payments{} = payments, attrs \\ %{}) do
    Payments.changeset(payments, attrs)
  end
end
