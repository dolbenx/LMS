defmodule Loanmanagementsystem.Products do
  @moduledoc """
  The Products context.
  """

  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Products.Product_rates

  alias Loanmanagementsystem.Products.Product

  @doc """
  Returns the list of tbl_products.

  ## Examples

      iex> list_tbl_products()
      [%Product{}, ...]

  """

  # Loanmanagementsystem.Products.list_tbl_products()

  def list_tbl_products do
    Repo.all(Product)
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
  # Loanmanagementsystem.Products.get_product!
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
      %Ecto.Changeset{data: %Product{}}

  """
  def change_product(%Product{} = product, attrs \\ %{}) do
    Product.changeset(product, attrs)
  end

  # Loanmanagementsystem.Products.otc_product_details_lookup(1)
  def otc_product_details_lookup(product_id) do
    Product
    |> where([p], p.id == ^product_id)
    |> select([p], %{
      clientId: p.clientId,
      product_code: p.code,
      currency_decimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currency_name: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,
      max_amount: p.maximumPrincipal,
      min_amount: p.minimumPrincipal,
      product_name: p.name,
      period_type: p.periodType,
      product_type: p.productType,
      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      product_id: p.id,
      id: p.id
    })
    |> Repo.all()
  end

  def product_details_list(product_id) do
    Product
    |> where([p], p.id == ^product_id)
    |> select([p], %{
      clientId: p.clientId,
      product_code: p.code,
      currency_decimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currency_name: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,
      max_amount: p.maximumPrincipal,
      min_amount: p.minimumPrincipal,
      product_name: p.name,
      period_type: p.periodType,
      product_type: p.productType,
      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      product_id: p.id,
      id: p.id,
      code: p.code
    })
    |> Repo.all()
  end

  # def otc_product_details_lookup(product_id) do
  #   Product
  #   |> join(:left, [p], r  in "tbl_product_rates", on: p.id == r.product_id)
  #   |> where([p, r], p.id == ^product_id and p.id == r.product_id )
  #   |> select([p, r], %{
  #     clientId: p.clientId,
  #     product_code: p.code,
  #     currency_decimals: p.currencyDecimals,
  #     currencyId: p.currencyId,
  #     currency_name: p.currencyName,
  #     defaultPeriod: p.defaultPeriod,
  #     details: p.details,
  #     interest: p.interest,
  #     interestMode: p.interestMode,
  #     interestType: p.interestType,
  #     max_amount: p.maximumPrincipal,
  #     min_amount: p.minimumPrincipal,
  #     product_name: p.name,
  #     period_type: p.periodType,
  #     product_type: p.productType,
  #     status: p.status,
  #     yearLengthInDays: p.yearLengthInDays,
  #     product_id: p.id,
  #     id: p.id,

  #     repayment: r.repayment,
  #     tenor: r.tenor,
  #     interest_rates: r.interest_rates,
  #     processing_fee: r.processing_fee

  #   })
  #   |> Repo.all()
  # end

  # Loanmanagementsystem.Products.product_list(nil, 1, 10)

  def product_list(search_params, page, size) do
    Product
    |> handle_product_filter(search_params)
    |> order_by([p], desc: p.inserted_at)
    |> compose_product_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def product_list(_source, search_params) do
    Product
    |> handle_product_filter(search_params)
    |> order_by([p], desc: p.inserted_at)
    |> compose_product_list()
  end

  defp compose_product_list(query) do
    query
    |>join(:left, [p], pR in Product_rates, on: p.id == pR.product_id)
    # |> where([a], a.studentInfosStatus == "Student")
    |> select(
      [p, pR],
      %{
        clientId: p.clientId,
        product_code: p.code,
        currency_decimals: p.currencyDecimals,
        currencyId: p.currencyId,
        currency_name: p.currencyName,
        defaultPeriod: p.defaultPeriod,
        details: p.details,
        interest: p.interest,
        interestMode: p.interestMode,
        interest_type: p.interestType,
        # max_amount: fragment("SELECT  cast((?) as text) FROM tbl_products", p.maximumPrincipal),
        max_amount: p.maximumPrincipal,
        min_amount: p.minimumPrincipal,
        profit: fragment("concat(?, concat(' To ', ?))", p.maximumPrincipal, p.minimumPrincipal),
        product_name: p.name,
        period_type: p.periodType,
        product_type: p.productType,
        status: p.status,
        yearLengthInDays: p.yearLengthInDays,
        product_id: p.id,
        id: p.id,
        inserted_at: p.inserted_at,
        updated_at: p.updated_at,
        code: p.code,
        principle_account_id: p.principle_account_id,
        interest_account_id: p.interest_account_id,
        charges_account_id: p.charges_account_id,
        classification_id: p.classification_id,
        interest_rates: pR.interest_rates,
        processing_fee: pR.processing_fee,
        repayment: pR.repayment,
        tenor: pR.tenor,
        price_rate_id: pR.id,
        product_charge_id: p.charge_id
      }
    )
  end

  defp handle_product_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_product_name_filter(search_params)
    |> handle_product_type_filter(search_params)
    |> handle_minimum_principal_filter(search_params)
    |> handle_maximum_principal_filter(search_params)
    |> handle_created_date_filter(search_params)
  end

  defp handle_product_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_product_isearch_filter(query, search_term)
  end

  defp handle_product_name_filter(query, %{"filter_product_name" => filter_product_name}) do
    where(query, [p], fragment("lower(?) LIKE lower(?)", p.name, ^"%#{filter_product_name}%"))
  end

  defp handle_product_name_filter(query, %{"filter_product_name" => filter_product_name})
       when filter_product_name == "" or is_nil(filter_product_name),
       do: query

  defp handle_product_type_filter(query, %{"filter_product_type" => filter_product_type}) do
    where(
      query,
      [p],
      fragment("lower(?) LIKE lower(?)", p.productType, ^"%#{filter_product_type}%")
    )
  end

  defp handle_product_type_filter(query, %{"filter_product_type" => filter_product_type})
       when filter_product_type == "" or is_nil(filter_product_type),
       do: query

  defp handle_minimum_principal_filter(query, %{
         "filter_minimum_principal" => filter_minimum_principal
       }) do
    where(
      query,
      [p],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        p.minimumPrincipal,
        ^"%#{filter_minimum_principal}%"
      )
    )
  end

  defp handle_minimum_principal_filter(query, %{
         "filter_minimum_principal" => filter_minimum_principal
       })
       when filter_minimum_principal == "" or is_nil(filter_minimum_principal),
       do: query

  defp handle_maximum_principal_filter(query, %{
         "filter_maximum_principal" => filter_maximum_principal
       }) do
    where(
      query,
      [p],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        p.maximumPrincipal,
        ^"%#{filter_maximum_principal}%"
      )
    )
  end

  defp handle_maximum_principal_filter(query, %{
         "filter_maximum_principal" => filter_maximum_principal
       })
       when filter_maximum_principal == "" or is_nil(filter_maximum_principal),
       do: query

  defp handle_created_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [p],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", p.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", p.inserted_at, ^to)
    )
  end

  defp handle_created_date_filter(query, _params), do: query

  defp compose_product_isearch_filter(query, search_term) do
    query
    |> where(
      [p],
      fragment("lower(?) LIKE lower(?)", p.product_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", p.period_type, ^search_term) or
        fragment("lower(?) LIKE lower(?)", p.status, ^search_term)
    )
  end

  # ----------------------------------------------------------------------------------------------------------------------------

  alias Loanmanagementsystem.Charges.Charge

  # Loanmanagementsystem.Products.admin_charges_lookup(7)

  def admin_charges_lookup(id) do
    Charge
    |> where([cH], cH.id == ^id)
    |> select([cH], %{
      id: cH.id,
      chargeAmount: cH.chargeAmount,
      chargeName: cH.chargeName,
      chargeType: cH.chargeType,
      chargeWhen: cH.chargeWhen,
      currency: cH.currency,
      isPenalty: cH.isPenalty
    })
    |> Repo.all()
  end

  alias Loanmanagementsystem.Products.Product_rates

  @doc """
  Returns the list of tbl_product_rates.

  ## Examples

      iex> list_tbl_product_rates()
      [%Product_rates{}, ...]

  """
  def list_tbl_product_rates do
    Repo.all(Product_rates)
  end

  @doc """
  Gets a single product_rates.

  Raises `Ecto.NoResultsError` if the Product rates does not exist.

  ## Examples

      iex> get_product_rates!(123)
      %Product_rates{}

      iex> get_product_rates!(456)
      ** (Ecto.NoResultsError)

  """
  # Loanmanagementsystem.Products.get_product_rates!
  def get_product_rates!(id), do: Repo.get!(Product_rates, id)


  @doc """
  Creates a product_rates.

  ## Examples

      iex> create_product_rates(%{field: value})
      {:ok, %Product_rates{}}

      iex> create_product_rates(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_product_rates(attrs \\ %{}) do
    %Product_rates{}
    |> Product_rates.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a product_rates.

  ## Examples

      iex> update_product_rates(product_rates, %{field: new_value})
      {:ok, %Product_rates{}}

      iex> update_product_rates(product_rates, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_product_rates(%Product_rates{} = product_rates, attrs) do
    product_rates
    |> Product_rates.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a product_rates.

  ## Examples

      iex> delete_product_rates(product_rates)
      {:ok, %Product_rates{}}

      iex> delete_product_rates(product_rates)
      {:error, %Ecto.Changeset{}}

  """
  def delete_product_rates(%Product_rates{} = product_rates) do
    Repo.delete(product_rates)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking product_rates changes.

  ## Examples

      iex> change_product_rates(product_rates)
      %Ecto.Changeset{data: %Product_rates{}}

  """
  def change_product_rates(%Product_rates{} = product_rates, attrs \\ %{}) do
    Product_rates.changeset(product_rates, attrs)
  end

  def product_rate_details_list(product_id) do
    Product_rates
    |> where([p], p.product_id == ^product_id)
    |> select([p], %{
      interest_rates: p.interest_rates,
      processing_fee: p.processing_fee,
      product_id: p.product_id,
      product_name: p.product_name,
      repayment: p.repayment,
      status: p.status,
      tenor: p.tenor,
      id: p.id
    })
    |> Repo.all()
  end
end
