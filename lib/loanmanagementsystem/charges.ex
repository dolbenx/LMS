defmodule Loanmanagementsystem.Charges do
  @moduledoc """
  The Charges context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Charges.Charge

  #   @doc """
  #   Returns the list of tbl_charges.

  #   ## Examples

  #       iex> list_tbl_charges()
  #       [%Charge{}, ...]

  # Loanmanagementsystem.Charges.list_tbl_charges
  def list_tbl_charges do
    Repo.all(Charge)
  end

  #   @doc """
  #   Gets a single charge.

  #   Raises `Ecto.NoResultsError` if the Charge does not exist.

  #   ## Examples

  #       iex> get_charge!(123)
  #       %Charge{}

  #       iex> get_charge!(456)
  #       ** (Ecto.NoResultsError)

  def get_charge!(id), do: Repo.get!(Charge, id)

  #   @doc """
  #   Creates a charge.

  #   ## Examples

  #       iex> create_charge(%{field: value})
  #       {:ok, %Charge{}}

  #       iex> create_charge(%{field: bad_value})
  #       {:error, %Ecto.Changeset{}}

  #   """
  def create_charge(attrs \\ %{}) do
    %Charge{}
    |> Charge.changeset(attrs)
    |> Repo.insert()
  end

  #   @doc """
  #   Updates a charge.

  #   ## Examples

  #       iex> update_charge(charge, %{field: new_value})
  #       {:ok, %Charge{}}

  #       iex> update_charge(charge, %{field: bad_value})
  #       {:error, %Ecto.Changeset{}}

  #   """
  def update_charge(%Charge{} = charge, attrs) do
    charge
    |> Charge.changeset(attrs)
    |> Repo.update()
  end

  #   @doc """
  #   Deletes a charge.

  #   ## Examples

  #       iex> delete_charge(charge)
  #       {:ok, %Charge{}}

  #       iex> delete_charge(charge)
  #       {:error, %Ecto.Changeset{}}

  #   """
  def delete_charge(%Charge{} = charge) do
    Repo.delete(charge)
  end

  #   @doc """
  #   Returns an `%Ecto.Changeset{}` for tracking charge changes.

  #   ## Examples

  #       iex> change_charge(charge)
  #       %Ecto.Changeset{data: %Charge{}}

  #   """
  def change_charge(%Charge{} = charge, attrs \\ %{}) do
    Charge.changeset(charge, attrs)
  end

  # Loanmanagementsystem.Charges.otc_get_charge_lookup(1)
  def otc_get_charge_lookup(product_charge_id) do
    Charge
    |> where([ch], ch.id == ^product_charge_id)
    |> select([ch], %{
      # product_charge_amount: ch.chargeAmount,
      product_charge_amount: fragment("concat(?, concat(' ', ?))", ch.currency, ch.chargeAmount),
      product_charge_when: ch.chargeWhen,
      product_charge_name: ch.chargeName,
      product_charge_type: ch.chargeType,
      currency: ch.currency,
      currency_id: ch.currencyId,
      is_penalty: ch.isPenalty,
      id: ch.id
    })
    |> Repo.all()
  end

  alias Loanmanagementsystem.Charges.Product_charges

  @doc """
  Returns the list of tbl_product_charges.

  ## Examples

      iex> list_tbl_product_charges()
      [%Product_charges{}, ...]

  """
  def list_tbl_product_charges do
    Repo.all(Product_charges)
  end

  @doc """
  Gets a single product_charges.

  Raises `Ecto.NoResultsError` if the Product charges does not exist.

  ## Examples

      iex> get_product_charges!(123)
      %Product_charges{}

      iex> get_product_charges!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_charges!(id), do: Repo.get!(Product_charges, id)

  @doc """
  Creates a product_charges.

  ## Examples

      iex> create_product_charges(%{field: value})
      {:ok, %Product_charges{}}

      iex> create_product_charges(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_charges(attrs \\ %{}) do
    %Product_charges{}
    |> Product_charges.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_charges.

  ## Examples

      iex> update_product_charges(product_charges, %{field: new_value})
      {:ok, %Product_charges{}}

      iex> update_product_charges(product_charges, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_charges(%Product_charges{} = product_charges, attrs) do
    product_charges
    |> Product_charges.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_charges.

  ## Examples

      iex> delete_product_charges(product_charges)
      {:ok, %Product_charges{}}

      iex> delete_product_charges(product_charges)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_charges(%Product_charges{} = product_charges) do
    Repo.delete(product_charges)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_charges changes.

  ## Examples

      iex> change_product_charges(product_charges)
      %Ecto.Changeset{data: %Product_charges{}}

  """
  def change_product_charges(%Product_charges{} = product_charges, attrs \\ %{}) do
    Product_charges.changeset(product_charges, attrs)
  end
end
