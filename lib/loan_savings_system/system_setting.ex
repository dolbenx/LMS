defmodule LoanSavingsSystem.SystemSetting do
  @moduledoc """
  The SystemSetting context.
  """



  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.SystemSetting.SystemSettings

  @doc """
  Returns the list of tbl_system_settings.

  ## Examples

      iex> list_tbl_system_settings()
      [%SystemSettings{}, ...]

  """
  def list_tbl_system_settings do
    Repo.all(SystemSettings)
  end

  def get_settings_by(name) do
    case SystemSettings.find_by(name: name) do
      nil ->
        []

      setting ->
        setting.value
    end
  end

  @doc """
  Gets a single system_settings.

  Raises `Ecto.NoResultsError` if the System settings does not exist.

  ## Examples

      iex> get_system_settings!(123)
      %SystemSettings{}

      iex> get_system_settings!(456)
      ** (Ecto.NoResultsError)

  """
  def get_system_settings!(id), do: Repo.get!(SystemSettings, id)

  @doc """
  Creates a system_settings.

  ## Examples

      iex> create_system_settings(%{field: value})
      {:ok, %SystemSettings{}}

      iex> create_system_settings(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_system_settings(attrs \\ %{}) do
    %SystemSettings{}
    |> SystemSettings.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a system_settings.

  ## Examples

      iex> update_system_settings(system_settings, %{field: new_value})
      {:ok, %SystemSettings{}}

      iex> update_system_settings(system_settings, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_system_settings(%SystemSettings{} = system_settings, attrs) do
    system_settings
    |> SystemSettings.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a system_settings.

  ## Examples

      iex> delete_system_settings(system_settings)
      {:ok, %SystemSettings{}}

      iex> delete_system_settings(system_settings)
      {:error, %Ecto.Changeset{}}

  """
  def delete_system_settings(%SystemSettings{} = system_settings) do
    Repo.delete(system_settings)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking system_settings changes.

  ## Examples

      iex> change_system_settings(system_settings)
      %Ecto.Changeset{source: %SystemSettings{}}

  """
  def change_system_settings(%SystemSettings{} = system_settings) do
    SystemSettings.changeset(system_settings, %{})
  end

  alias LoanSavingsSystem.SystemSetting.Currency
  alias LoanSavingsSystem.SystemSetting.Country

  @doc """
  Returns the list of tbl_currency.

  ## Examples

      iex> list_tbl_currency()
      [%Currency{}, ...]

  """
  def list_tbl_currency do
    Repo.all(Currency)
  end

  def currency_name do
    Currency
      |> join(:left, [c], u in "tbl_country", on: c.countryId == u.id)
      |> select([c, u], %{
        name: u.name,
        name: c.name,
        isoCode: c.isoCode,
        countryId: c.countryId,
        id: u.id
      })
      |> Repo.all()
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
      %Ecto.Changeset{source: %Currency{}}

  """
  def change_currency(%Currency{} = currency) do
    Currency.changeset(currency, %{})
  end

  alias LoanSavingsSystem.SystemSetting.Country

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
      %Ecto.Changeset{source: %Country{}}

  """
  def change_country(%Country{} = country) do
    Country.changeset(country, %{})
  end

  alias LoanSavingsSystem.SystemSetting.District

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
      %Ecto.Changeset{source: %District{}}

  """
  def change_district(%District{} = district) do
    District.changeset(district, %{})
  end

  alias LoanSavingsSystem.SystemSetting.Province

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
      %Ecto.Changeset{source: %Province{}}

  """
  def change_province(%Province{} = province) do
    Province.changeset(province, %{})
  end

  alias LoanSavingsSystem.SystemSetting.Telco

  @doc """
  Returns the list of tbl_telco.

  ## Examples

      iex> list_tbl_telco()
      [%Telco{}, ...]

  """
  def list_tbl_telco do
    Repo.all(Telco)
  end

  @doc """
  Gets a single telco.

  Raises `Ecto.NoResultsError` if the Telco does not exist.

  ## Examples

      iex> get_telco!(123)
      %Telco{}

      iex> get_telco!(456)
      ** (Ecto.NoResultsError)

  """
  def get_telco!(id), do: Repo.get!(Telco, id)

  @doc """
  Creates a telco.

  ## Examples

      iex> create_telco(%{field: value})
      {:ok, %Telco{}}

      iex> create_telco(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_telco(attrs \\ %{}) do
    %Telco{}
    |> Telco.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a telco.

  ## Examples

      iex> update_telco(telco, %{field: new_value})
      {:ok, %Telco{}}

      iex> update_telco(telco, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_telco(%Telco{} = telco, attrs) do
    telco
    |> Telco.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a telco.

  ## Examples

      iex> delete_telco(telco)
      {:ok, %Telco{}}

      iex> delete_telco(telco)
      {:error, %Ecto.Changeset{}}

  """
  def delete_telco(%Telco{} = telco) do
    Repo.delete(telco)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking telco changes.

  ## Examples

      iex> change_telco(telco)
      %Ecto.Changeset{source: %Telco{}}

  """
  def change_telco(%Telco{} = telco) do
    Telco.changeset(telco, %{})
  end

  alias LoanSavingsSystem.SystemSetting.ClientTelco

  @doc """
  Returns the list of tbl_client_telco.

  ## Examples

      iex> list_tbl_client_telco()
      [%ClientTelco{}, ...]

  """
  def list_tbl_client_telco do
    Repo.all(ClientTelco)
  end

  @doc """
  Gets a single client_telco.

  Raises `Ecto.NoResultsError` if the Client telco does not exist.

  ## Examples

      iex> get_client_telco!(123)
      %ClientTelco{}

      iex> get_client_telco!(456)
      ** (Ecto.NoResultsError)

  """
  def get_client_telco!(id), do: Repo.get!(ClientTelco, id)

  @doc """
  Creates a client_telco.

  ## Examples

      iex> create_client_telco(%{field: value})
      {:ok, %ClientTelco{}}

      iex> create_client_telco(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_client_telco(attrs \\ %{}) do
    %ClientTelco{}
    |> ClientTelco.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a client_telco.

  ## Examples

      iex> update_client_telco(client_telco, %{field: new_value})
      {:ok, %ClientTelco{}}

      iex> update_client_telco(client_telco, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_client_telco(%ClientTelco{} = client_telco, attrs) do
    client_telco
    |> ClientTelco.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a client_telco.

  ## Examples

      iex> delete_client_telco(client_telco)
      {:ok, %ClientTelco{}}

      iex> delete_client_telco(client_telco)
      {:error, %Ecto.Changeset{}}

  """
  def delete_client_telco(%ClientTelco{} = client_telco) do
    Repo.delete(client_telco)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking client_telco changes.

  ## Examples

      iex> change_client_telco(client_telco)
      %Ecto.Changeset{source: %ClientTelco{}}

  """
  def change_client_telco(%ClientTelco{} = client_telco) do
    ClientTelco.changeset(client_telco, %{})
  end
end
