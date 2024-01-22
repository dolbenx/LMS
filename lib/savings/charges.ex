defmodule Savings.Charges do
  @moduledoc """
  The Charges context.
  """

  import Ecto.Query, warn: false
  alias Savings.Repo

  alias Savings.Charges.Charge

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
end
