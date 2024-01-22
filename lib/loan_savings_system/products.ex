defmodule LoanSavingsSystem.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Products.Product
  alias LoanSavingsSystem.Products.ProductCharge
  alias LoanSavingsSystem.Divestments.DivestmentPackage

  @doc """
  Returns the list of tbl_products.

  ## Examples

      iex> list_tbl_products()
      [%Product{}, ...]

  """
  def list_tbl_products do
    Repo.all(Product)
  end


  def list_loan_products do
    Product
    |> where([u], u.productType == "LOANS")
    |> select([u], %{
      id: u.id,
      name: u.name,
      code: u.code,
      details: u.details,
      currencyid: u.currencyId,
      currencyname: u.currencyName,
      currencydecimals: u.currencyDecimals,
      interest: u.interest,
      interesttype: u.interestType,
      interestmode: u.interestMode,
      defaultperiod: u.defaultPeriod,
      periodtype: u.periodType,
      producttype: u.productType,
      minimumprincipal: u.minimumPrincipal,
      maximumprincipal: u.maximumPrincipal,
      clientid: u.clientId,
      yearlengthindays: u.yearLengthInDays,
      status: u.status,
      minimumperiod: u.minimumPeriod,
      maximumperiod: u.maximumPeriod
    })
    |> Repo.all()
  end

  def list_savings_products do
    Product
      |> join(:left, [p], c in "tbl_currency", on: p.currencyId == c.id)
      # |> join(:left, [p], pG in "tbl_product_charge", on: p.id == pG.productId)
      # |> join(:left, [p], dP in "tbl_divestment_package", on: p.id == dP.productId)
      |> where([p], p.productType == "SAVINGS")
      |> select([p, c], %{
        id: p.id,
        productname: p.name,
        code: p.code,
        details: p.details,
        currencyid: p.currencyId,
        currencyname: p.currencyName,
        currencydecimals: p.currencyDecimals,
        interest: p.interest,
        interesttype: p.interestType,
        interestmode: p.interestMode,
        defaultperiod: p.defaultPeriod,
        periodtype: p.periodType,
        producttype: p.productType,
        minimumprincipal: p.minimumPrincipal,
        maximumprincipal: p.maximumPrincipal,
        clientid: p.clientId,
        yearlengthindays: p.yearLengthInDays,
        status: p.status,
        name: c.name,
        # chargeWhen: pG.chargeWhen,
        # startperioddays: dP.startPeriodDays,
        # endperioddays: dP.endPeriodDays,
        # divestmentvaluation: dP.divestmentValuation,
        # divestmentid: dP.id,
        isoCode: c.isoCode,
      })
      |> Repo.all()
  end


  def list_charges do
    ProductCharge
      |> join(:left, [p], c in "tbl_products", on: p.productId == c.id)
      |> join(:left, [p], pG in "tbl_charge", on: p.chargeId == pG.id)
      |> select([p, c, pG], %{
        id: p.id,
        chargeWhen: p.chargeWhen,
        currency: pG.currency,
        chargeName: pG.chargeName,
        currencyId: pG.currencyId,
        chargeType: pG.chargeType,
        chargeAmount: pG.chargeAmount,
        productId: p.productId
      })
      |> Repo.all()
  end

  def list_divestment_packages do
    DivestmentPackage
      |> join(:left, [p], c in "tbl_products", on: p.productId == c.id)
      |> where([p], p.status == "ACTIVE")
      |> select([p, c], %{
        id: p.id,
        startPeriodDays: p.startPeriodDays,
        endPeriodDays: p.endPeriodDays,
        divestmentValuation: p.divestmentValuation,
        productId: p.productId
      })
      |> Repo.all()
  end

  def list_divestpackae_savings_products do
    Product
      |> join(:left, [p], dP in "tbl_divestment_package", on: p.id == dP.productId)
      |> where([p], p.productType == "SAVINGS")
      |> select([p, dP], %{
        id: p.id,
        productname: p.name,
        code: p.code,
        details: p.details,
        startperioddays: dP.startPeriodDays,
        endperioddays: dP.endPeriodDays,
        divestmentvaluation: dP.divestmentValuation,
        divestmentid: dP.id
      })
      |> Repo.all()
  end

  @doc """
  Gets a single product.

  Raises `Ecto.NoResultsError` if the Product does not exist.

  ## Examples

      iex> get_product!(123)
      %Product{}

      iex> get_product!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product!(id), do: Repo.get!(Product, id)

  @doc """
  Creates a product.

  ## Examples

      iex> create_product(%{field: value})
      {:ok, %Product{}}

      iex> create_product(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product(attrs \\ %{}) do
    %Product{}
    |> Product.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product.

  ## Examples

      iex> update_product(product, %{field: new_value})
      {:ok, %Product{}}

      iex> update_product(product, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product(%Product{} = product, attrs) do
    product
    |> Product.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product.

  ## Examples

      iex> delete_product(product)
      {:ok, %Product{}}

      iex> delete_product(product)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product(%Product{} = product) do
    Repo.delete(product)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product changes.

  ## Examples

      iex> change_product(product)
      %Ecto.Changeset{source: %Product{}}

  """
  def change_product(%Product{} = product) do
    Product.changeset(product, %{})
  end

  alias LoanSavingsSystem.Products.ProductCharge

  @doc """
  Returns the list of tbl_product_charge.

  ## Examples

      iex> list_tbl_product_charge()
      [%ProductCharge{}, ...]

  """
  def list_tbl_product_charge do
    Repo.all(ProductCharge)
  end

  @doc """
  Gets a single product_charge.

  Raises `Ecto.NoResultsError` if the Product charge does not exist.

  ## Examples

      iex> get_product_charge!(123)
      %ProductCharge{}

      iex> get_product_charge!(456)
      ** (Ecto.NoResultsError)

  """
  def get_product_charge!(id), do: Repo.get!(ProductCharge, id)

  @doc """
  Creates a product_charge.

  ## Examples

      iex> create_product_charge(%{field: value})
      {:ok, %ProductCharge{}}

      iex> create_product_charge(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_charge(attrs \\ %{}) do
    %ProductCharge{}
    |> ProductCharge.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_charge.

  ## Examples

      iex> update_product_charge(product_charge, %{field: new_value})
      {:ok, %ProductCharge{}}

      iex> update_product_charge(product_charge, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_charge(%ProductCharge{} = product_charge, attrs) do
    product_charge
    |> ProductCharge.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_charge.

  ## Examples

      iex> delete_product_charge(product_charge)
      {:ok, %ProductCharge{}}

      iex> delete_product_charge(product_charge)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_charge(%ProductCharge{} = product_charge) do
    Repo.delete(product_charge)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_charge changes.

  ## Examples

      iex> change_product_charge(product_charge)
      %Ecto.Changeset{source: %ProductCharge{}}

  """
  def change_product_charge(%ProductCharge{} = product_charge) do
    ProductCharge.changeset(product_charge, %{})
  end
end
