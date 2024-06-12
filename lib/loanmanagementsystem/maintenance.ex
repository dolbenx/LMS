defmodule Loanmanagementsystem.Maintenance do
  @moduledoc """
  The Maintenance context.
  """
  @pagination [page_size: 10]
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Maintenance.Bank

  @doc """
  Returns the list of tbl_banks.

  ## Examples

      iex> list_tbl_banks()
      [%Bank{}, ...]

  """
  def list_tbl_banks do
    Repo.all(Bank)
  end

  @doc """
  Gets a single bank.

  Raises `Ecto.NoResultsError` if the Bank does not exist.

  ## Examples

      iex> get_bank!(123)
      %Bank{}

      iex> get_bank!(456)
      ** (Ecto.NoResultsError)

  """
  def get_bank!(id), do: Repo.get!(Bank, id)

  @doc """
  Creates a bank.

  ## Examples

      iex> create_bank(%{field: value})
      {:ok, %Bank{}}

      iex> create_bank(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_bank(attrs \\ %{}) do
    %Bank{}
    |> Bank.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a bank.

  ## Examples

      iex> update_bank(bank, %{field: new_value})
      {:ok, %Bank{}}

      iex> update_bank(bank, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_bank(%Bank{} = bank, attrs) do
    bank
    |> Bank.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a bank.

  ## Examples

      iex> delete_bank(bank)
      {:ok, %Bank{}}

      iex> delete_bank(bank)
      {:error, %Ecto.Changeset{}}

  """
  def delete_bank(%Bank{} = bank) do
    Repo.delete(bank)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking bank changes.

  ## Examples

      iex> change_bank(bank)
      %Ecto.Changeset{data: %Bank{}}

  """
  def change_bank(%Bank{} = bank, attrs \\ %{}) do
    Bank.changeset(bank, attrs)
  end

  def list_bank(search_params) do
    Bank
    |> where([b], b.status != "DELETED")
    |> handle_bank_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> compose_bank_select()
    |> Scrivener.paginate(Scrivener.Config.new(Repo, @pagination, search_params))
  end

  defp handle_bank_filter(query, params) do
    Enum.reduce(params, query, fn
      {"isearch", value}, query when byte_size(value) > 0 ->
        bank_isearch_filter(query, Utils.sanitize_term(value))

      {"bank_name", value}, query when byte_size(value) > 0 ->
        where(query, [b], fragment("lower(?) LIKE lower(?)", b.bank_name, ^Utils.sanitize_term(value)))

      {"status", value}, query when byte_size(value) > 0 ->
        where(query, [b], fragment("lower(?) LIKE lower(?)", b.status, ^Utils.sanitize_term(value)))

      {"from", value}, query when byte_size(value) > 0 ->
        where(query, [b], fragment("CAST(? AS DATE) >= ?", b.inserted_at, ^value))

      {"to", value}, query when byte_size(value) > 0 ->
        where(query, [b], fragment("CAST(? AS DATE) <= ?", b.inserted_at, ^value))

      {_, _}, query ->
        # Not a where parameter
        query
    end)
  end


  defp bank_isearch_filter(query, search_term) do
    where(
      query,
      [b],
      fragment("lower(?) LIKE lower(?)", b.bank_name, ^search_term) or
      fragment("lower(?) LIKE lower(?)", b.status, ^search_term)


    )
  end

  defp compose_bank_select(query) do
    query
    |> select(
      [b],
      %{
        id: b.id,
        bank_name: b.bank_name,
        bank_address: b.bank_address,
        country_id: b.country_id,
        acronym: b.acronym,
        status: b.status,
        bank_code: b.bank_code,
        province_id: b.province_id,
        created_by: b.created_by,
        approved_by: b.approved_by,
        inserted_at: b.inserted_at,
        updated_at: b.updated_at,
        process_branch: b.process_branch,
        swift_code: b.swift_code,
        district_id: b.district_id,
        bank_descrip: b.bank_descrip
      }
    )
  end

  alias Loanmanagementsystem.Maintenance.Branch

  @doc """
  Returns the list of tbl_branchs.

  ## Examples

      iex> list_tbl_branchs()
      [%Branch{}, ...]

  """
  def list_tbl_branchs do
    Repo.all(Branch)
  end

  @doc """
  Gets a single branch.

  Raises `Ecto.NoResultsError` if the Branch does not exist.

  ## Examples

      iex> get_branch!(123)
      %Branch{}

      iex> get_branch!(456)
      ** (Ecto.NoResultsError)

  """
  def get_branch!(id), do: Repo.get!(Branch, id)

  @doc """
  Creates a branch.

  ## Examples

      iex> create_branch(%{field: value})
      {:ok, %Branch{}}

      iex> create_branch(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_branch(attrs \\ %{}) do
    %Branch{}
    |> Branch.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a branch.

  ## Examples

      iex> update_branch(branch, %{field: new_value})
      {:ok, %Branch{}}

      iex> update_branch(branch, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_branch(%Branch{} = branch, attrs) do
    branch
    |> Branch.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a branch.

  ## Examples

      iex> delete_branch(branch)
      {:ok, %Branch{}}

      iex> delete_branch(branch)
      {:error, %Ecto.Changeset{}}

  """
  def delete_branch(%Branch{} = branch) do
    Repo.delete(branch)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking branch changes.

  ## Examples

      iex> change_branch(branch)
      %Ecto.Changeset{data: %Branch{}}

  """
  def change_branch(%Branch{} = branch, attrs \\ %{}) do
    Branch.changeset(branch, attrs)
  end


  def list_branch(search_params) do
    Branch
    |> join(:left, [b], bK in "tbl_banks", on: b.bank_id == bK.id)
    |> where([b, bK], b.status != "DELETED")
    |> handle_branch_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> compose_branch_select()
    |> Scrivener.paginate(Scrivener.Config.new(Repo, @pagination, search_params))
  end

  defp handle_branch_filter(query, params) do
    Enum.reduce(params, query, fn
      {"isearch", value}, query when byte_size(value) > 0 ->
        branch_isearch_filter(query, Utils.sanitize_term(value))

      {"branch_name", value}, query when byte_size(value) > 0 ->
        where(query, [b], fragment("lower(?) LIKE lower(?)", b.branch_name, ^Utils.sanitize_term(value)))

      {"status", value}, query when byte_size(value) > 0 ->
        where(query, [b], fragment("lower(?) LIKE lower(?)", b.status, ^Utils.sanitize_term(value)))

      {"from", value}, query when byte_size(value) > 0 ->
        where(query, [b], fragment("CAST(? AS DATE) >= ?", b.inserted_at, ^value))

      {"to", value}, query when byte_size(value) > 0 ->
        where(query, [b], fragment("CAST(? AS DATE) <= ?", b.inserted_at, ^value))

      {_, _}, query ->
        # Not a where parameter
        query
    end)
  end


  defp branch_isearch_filter(query, search_term) do
    where(
      query,
      [b, bK],
      fragment("lower(?) LIKE lower(?)", b.branch_name, ^search_term) or
      fragment("lower(?) LIKE lower(?)", b.status, ^search_term)


    )
  end

  defp compose_branch_select(query) do
    query
    |> select(
      [b, bK],
      %{
        id: b.id,
        bank_name: bK.bank_name,
        branch_address: b.branch_address,
        country_id: b.country_id,
        status: b.status,
        branch_code: b.branch_code,
        province_id: b.province_id,
        created_by: b.created_by,
        approved_by: b.approved_by,
        inserted_at: b.inserted_at,
        updated_at: b.updated_at,
        branch_name: b.branch_name,
        is_default_ussd_branch: b.is_default_ussd_branch,
        district_id: b.district_id,
        bank_id: b.bank_id
      }
    )
  end

  alias Loanmanagementsystem.Maintenance.Country

  @doc """
  Returns the list of tbl_country.

  ## Examples

      iex> list_tbl_country()
      [%Country{}, ...]

  """
  def list_tbl_country do
    Repo.all(Country)
  end

  @doc """
  Gets a single country.

  Raises `Ecto.NoResultsError` if the Country does not exist.

  ## Examples

      iex> get_country!(123)
      %Country{}

      iex> get_country!(456)
      ** (Ecto.NoResultsError)

  """
  def get_country!(id), do: Repo.get!(Country, id)

  @doc """
  Creates a country.

  ## Examples

      iex> create_country(%{field: value})
      {:ok, %Country{}}

      iex> create_country(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_country(attrs \\ %{}) do
    %Country{}
    |> Country.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a country.

  ## Examples

      iex> update_country(country, %{field: new_value})
      {:ok, %Country{}}

      iex> update_country(country, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_country(%Country{} = country, attrs) do
    country
    |> Country.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a country.

  ## Examples

      iex> delete_country(country)
      {:ok, %Country{}}

      iex> delete_country(country)
      {:error, %Ecto.Changeset{}}

  """
  def delete_country(%Country{} = country) do
    Repo.delete(country)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking country changes.

  ## Examples

      iex> change_country(country)
      %Ecto.Changeset{data: %Country{}}

  """
  def change_country(%Country{} = country, attrs \\ %{}) do
    Country.changeset(country, attrs)
  end

  def list_country(search_params) do
    Country
    |> where([c], c.status != "DELETED")
    |> handle_country_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> compose_country_select()
    |> Scrivener.paginate(Scrivener.Config.new(Repo, @pagination, search_params))
  end

  defp handle_country_filter(query, params) do
    Enum.reduce(params, query, fn
      {"isearch", value}, query when byte_size(value) > 0 ->
        country_isearch_filter(query, Utils.sanitize_term(value))

      {"name", value}, query when byte_size(value) > 0 ->
        where(query, [c], fragment("lower(?) LIKE lower(?)", c.name, ^Utils.sanitize_term(value)))

      {"code", value}, query when byte_size(value) > 0 ->
        where(query, [c], fragment("lower(?) LIKE lower(?)", c.code, ^Utils.sanitize_term(value)))

      {"status", value}, query when byte_size(value) > 0 ->
        where(query, [c], fragment("lower(?) LIKE lower(?)", c.status, ^Utils.sanitize_term(value)))

      {"from", value}, query when byte_size(value) > 0 ->
        where(query, [c], fragment("CAST(? AS DATE) >= ?", c.inserted_at, ^value))

      {"to", value}, query when byte_size(value) > 0 ->
        where(query, [c], fragment("CAST(? AS DATE) <= ?", c.inserted_at, ^value))



      {_, _}, query ->
        # Not a where parameter
        query
    end)
  end


  defp country_isearch_filter(query, search_term) do
    where(
      query,
      [c],
      fragment("lower(?) LIKE lower(?)", c.name, ^search_term) or
      fragment("lower(?) LIKE lower(?)", c.code, ^search_term) or
      fragment("lower(?) LIKE lower(?)", c.status, ^search_term)


    )
  end


  defp compose_country_select(query) do
    query
    |> select(
      [c],
      map(c, [
        :id,
        :name,
        :code,
        :country_file_name,
        :status,
        :created_by,
        :approved_by,
        :inserted_at,
        :updated_at
      ])
    )
  end

  alias Loanmanagementsystem.Maintenance.Province

  @doc """
  Returns the list of tbl_province.

  ## Examples

      iex> list_tbl_province()
      [%Province{}, ...]

  """
  def list_tbl_province do
    Repo.all(Province)
  end

  @doc """
  Gets a single province.

  Raises `Ecto.NoResultsError` if the Province does not exist.

  ## Examples

      iex> get_province!(123)
      %Province{}

      iex> get_province!(456)
      ** (Ecto.NoResultsError)

  """
  def get_province!(id), do: Repo.get!(Province, id)

  @doc """
  Creates a province.

  ## Examples

      iex> create_province(%{field: value})
      {:ok, %Province{}}

      iex> create_province(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_province(attrs \\ %{}) do
    %Province{}
    |> Province.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a province.

  ## Examples

      iex> update_province(province, %{field: new_value})
      {:ok, %Province{}}

      iex> update_province(province, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_province(%Province{} = province, attrs) do
    province
    |> Province.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a province.

  ## Examples

      iex> delete_province(province)
      {:ok, %Province{}}

      iex> delete_province(province)
      {:error, %Ecto.Changeset{}}

  """
  def delete_province(%Province{} = province) do
    Repo.delete(province)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking province changes.

  ## Examples

      iex> change_province(province)
      %Ecto.Changeset{data: %Province{}}

  """
  def change_province(%Province{} = province, attrs \\ %{}) do
    Province.changeset(province, attrs)
  end

  def list_province(search_params) do
    Province
    |> join(:left, [p], c in "tbl_country", on: p.country_id == c.id)
    |> where([p, c], p.status != "DELETED")
    |> handle_province_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> compose_province_select()
    |> Scrivener.paginate(Scrivener.Config.new(Repo, @pagination, search_params))
  end

  defp handle_province_filter(query, params) do
    Enum.reduce(params, query, fn
      {"isearch", value}, query when byte_size(value) > 0 ->
        province_isearch_filter(query, Utils.sanitize_term(value))

      {"name", value}, query when byte_size(value) > 0 ->
        where(query, [p], fragment("lower(?) LIKE lower(?)", p.name, ^Utils.sanitize_term(value)))

      {"status", value}, query when byte_size(value) > 0 ->
        where(query, [p], fragment("lower(?) LIKE lower(?)", p.status, ^Utils.sanitize_term(value)))

      {"from", value}, query when byte_size(value) > 0 ->
        where(query, [p], fragment("CAST(? AS DATE) >= ?", p.inserted_at, ^value))

      {"to", value}, query when byte_size(value) > 0 ->
        where(query, [p], fragment("CAST(? AS DATE) <= ?", p.inserted_at, ^value))

      {_, _}, query ->
        # Not a where parameter
        query
    end)
  end


  defp province_isearch_filter(query, search_term) do
    where(
      query,
      [p, c],
      fragment("lower(?) LIKE lower(?)", p.name, ^search_term) or
      fragment("lower(?) LIKE lower(?)", p.status, ^search_term)


    )
  end

  defp compose_province_select(query) do
    query
    |> select(
      [p, c],
      %{
        id: p.id,
        province_name: p.name,
        country_id: p.country_id,
        status: p.status,
        created_by: p.created_by,
        approved_by: p.approved_by,
        inserted_at: p.inserted_at,
        updated_at: p.updated_at,
        country_name: c.name
      }
    )
  end

  alias Loanmanagementsystem.Maintenance.District

  @doc """
  Returns the list of tbl_district.

  ## Examples

      iex> list_tbl_district()
      [%District{}, ...]

  """
  def list_tbl_district do
    Repo.all(District)
  end

  @doc """
  Gets a single district.

  Raises `Ecto.NoResultsError` if the District does not exist.

  ## Examples

      iex> get_district!(123)
      %District{}

      iex> get_district!(456)
      ** (Ecto.NoResultsError)

  """
  def get_district!(id), do: Repo.get!(District, id)

  @doc """
  Creates a district.

  ## Examples

      iex> create_district(%{field: value})
      {:ok, %District{}}

      iex> create_district(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_district(attrs \\ %{}) do
    %District{}
    |> District.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a district.

  ## Examples

      iex> update_district(district, %{field: new_value})
      {:ok, %District{}}

      iex> update_district(district, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_district(%District{} = district, attrs) do
    district
    |> District.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a district.

  ## Examples

      iex> delete_district(district)
      {:ok, %District{}}

      iex> delete_district(district)
      {:error, %Ecto.Changeset{}}

  """
  def delete_district(%District{} = district) do
    Repo.delete(district)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking district changes.

  ## Examples

      iex> change_district(district)
      %Ecto.Changeset{data: %District{}}

  """
  def change_district(%District{} = district, attrs \\ %{}) do
    District.changeset(district, attrs)
  end

  def list_district(search_params) do
    District
    |> join(:left, [d], p in "tbl_province", on: d.province_id == p.id)
    |> join(:left, [d, p], c in "tbl_country", on: d.country_id == c.id)
    |> where([d, p, c], d.status != "DELETED")
    |> handle_district_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> compose_district_select()
    |> Scrivener.paginate(Scrivener.Config.new(Repo, @pagination, search_params))
  end

  defp handle_district_filter(query, params) do
    Enum.reduce(params, query, fn
      {"isearch", value}, query when byte_size(value) > 0 ->
        district_isearch_filter(query, Utils.sanitize_term(value))

      {"name", value}, query when byte_size(value) > 0 ->
        where(query, [d], fragment("lower(?) LIKE lower(?)", d.name, ^Utils.sanitize_term(value)))

      {"status", value}, query when byte_size(value) > 0 ->
        where(query, [d], fragment("lower(?) LIKE lower(?)", d.status, ^Utils.sanitize_term(value)))

      {"from", value}, query when byte_size(value) > 0 ->
        where(query, [d], fragment("CAST(? AS DATE) >= ?", d.inserted_at, ^value))

      {"to", value}, query when byte_size(value) > 0 ->
        where(query, [d], fragment("CAST(? AS DATE) <= ?", d.inserted_at, ^value))

      {_, _}, query ->
        # Not a where parameter
        query
    end)
  end


  defp district_isearch_filter(query, search_term) do
    where(
      query,
      [d, p, c],
      fragment("lower(?) LIKE lower(?)", d.name, ^search_term) or
      fragment("lower(?) LIKE lower(?)", d.status, ^search_term)


    )
  end

  defp compose_district_select(query) do
    query
    |> select(
      [d, p, c],
      %{
        id: d.id,
        district_name: d.name,
        country_id: d.country_id,
        status: d.status,
        created_by: d.created_by,
        approved_by: d.approved_by,
        inserted_at: d.inserted_at,
        updated_at: d.updated_at,
        province_name: p.name,
        country_name: c.name
      }
    )
  end

  alias Loanmanagementsystem.Maintenance.Currency

  @doc """
  Returns the list of tbl_currency.

  ## Examples

      iex> list_tbl_currency()
      [%Currency{}, ...]

  """
  def list_tbl_currency do
    Repo.all(Currency)
  end

  @doc """
  Gets a single currency.

  Raises `Ecto.NoResultsError` if the Currency does not exist.

  ## Examples

      iex> get_currency!(123)
      %Currency{}

      iex> get_currency!(456)
      ** (Ecto.NoResultsError)

  """
  def get_currency!(id), do: Repo.get!(Currency, id)

  @doc """
  Creates a currency.

  ## Examples

      iex> create_currency(%{field: value})
      {:ok, %Currency{}}

      iex> create_currency(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_currency(attrs \\ %{}) do
    %Currency{}
    |> Currency.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a currency.

  ## Examples

      iex> update_currency(currency, %{field: new_value})
      {:ok, %Currency{}}

      iex> update_currency(currency, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_currency(%Currency{} = currency, attrs) do
    currency
    |> Currency.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a currency.

  ## Examples

      iex> delete_currency(currency)
      {:ok, %Currency{}}

      iex> delete_currency(currency)
      {:error, %Ecto.Changeset{}}

  """
  def delete_currency(%Currency{} = currency) do
    Repo.delete(currency)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking currency changes.

  ## Examples

      iex> change_currency(currency)
      %Ecto.Changeset{data: %Currency{}}

  """
  def change_currency(%Currency{} = currency, attrs \\ %{}) do
    Currency.changeset(currency, attrs)
  end

  def list_currency(search_params) do
    Currency
    |> join(:left, [cU], c in "tbl_country", on: cU.country_id == c.id)
    |> where([cU, c], cU.status != "DELETED")
    |> handle_currency_filter(search_params)
    |> order_by(desc: :inserted_at)
    |> compose_currency_select()
    |> Scrivener.paginate(Scrivener.Config.new(Repo, @pagination, search_params))
  end

  defp handle_currency_filter(query, params) do
    Enum.reduce(params, query, fn
      {"isearch", value}, query when byte_size(value) > 0 ->
        currency_isearch_filter(query, Utils.sanitize_term(value))

      {"name", value}, query when byte_size(value) > 0 ->
        where(query, [cU], fragment("lower(?) LIKE lower(?)", cU.name, ^Utils.sanitize_term(value)))

      {"status", value}, query when byte_size(value) > 0 ->
        where(query, [cU], fragment("lower(?) LIKE lower(?)", cU.status, ^Utils.sanitize_term(value)))

      {"from", value}, query when byte_size(value) > 0 ->
        where(query, [cU], fragment("CAST(? AS DATE) >= ?", cU.inserted_at, ^value))

      {"to", value}, query when byte_size(value) > 0 ->
        where(query, [cU], fragment("CAST(? AS DATE) <= ?", cU.inserted_at, ^value))

      {_, _}, query ->
        # Not a where parameter
        query
    end)
  end


  defp currency_isearch_filter(query, search_term) do
    where(
      query,
      [cU, c],
      fragment("lower(?) LIKE lower(?)", cU.name, ^search_term) or
      fragment("lower(?) LIKE lower(?)", cU.status, ^search_term)
    )
  end

  defp compose_currency_select(query) do
    query
    |> select(
      [cU, c],
      %{
        id: cU.id,
        currency_name: cU.name,
        iso_code: cU.iso_code,
        country_id: cU.country_id,
        currency_decimal: cU.currency_decimal,
        acronym: cU.acronym,
        status: cU.status,
        created_by: cU.created_by,
        approved_by: cU.approved_by,
        inserted_at: cU.inserted_at,
        updated_at: cU.updated_at,
        country_name: c.name
      }
    )
  end
end
