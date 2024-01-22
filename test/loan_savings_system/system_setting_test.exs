defmodule LoanSavingsSystem.SystemSettingTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.SystemSetting

  describe "tbl_system_settings" do
    alias LoanSavingsSystem.SystemSetting.SystemSettings

    @valid_attrs %{name: "some name", value: "some value"}
    @update_attrs %{name: "some updated name", value: "some updated value"}
    @invalid_attrs %{name: nil, value: nil}

    def system_settings_fixture(attrs \\ %{}) do
      {:ok, system_settings} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSetting.create_system_settings()

      system_settings
    end

    test "list_tbl_system_settings/0 returns all tbl_system_settings" do
      system_settings = system_settings_fixture()
      assert SystemSetting.list_tbl_system_settings() == [system_settings]
    end

    test "get_system_settings!/1 returns the system_settings with given id" do
      system_settings = system_settings_fixture()
      assert SystemSetting.get_system_settings!(system_settings.id) == system_settings
    end

    test "create_system_settings/1 with valid data creates a system_settings" do
      assert {:ok, %SystemSettings{} = system_settings} = SystemSetting.create_system_settings(@valid_attrs)
      assert system_settings.name == "some name"
      assert system_settings.value == "some value"
    end

    test "create_system_settings/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSetting.create_system_settings(@invalid_attrs)
    end

    test "update_system_settings/2 with valid data updates the system_settings" do
      system_settings = system_settings_fixture()
      assert {:ok, %SystemSettings{} = system_settings} = SystemSetting.update_system_settings(system_settings, @update_attrs)
      assert system_settings.name == "some updated name"
      assert system_settings.value == "some updated value"
    end

    test "update_system_settings/2 with invalid data returns error changeset" do
      system_settings = system_settings_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSetting.update_system_settings(system_settings, @invalid_attrs)
      assert system_settings == SystemSetting.get_system_settings!(system_settings.id)
    end

    test "delete_system_settings/1 deletes the system_settings" do
      system_settings = system_settings_fixture()
      assert {:ok, %SystemSettings{}} = SystemSetting.delete_system_settings(system_settings)
      assert_raise Ecto.NoResultsError, fn -> SystemSetting.get_system_settings!(system_settings.id) end
    end

    test "change_system_settings/1 returns a system_settings changeset" do
      system_settings = system_settings_fixture()
      assert %Ecto.Changeset{} = SystemSetting.change_system_settings(system_settings)
    end
  end

  describe "tbl_currency" do
    alias LoanSavingsSystem.SystemSetting.Currency

    @valid_attrs %{countryId: 42, isoCode: "some isoCode", name: "some name"}
    @update_attrs %{countryId: 43, isoCode: "some updated isoCode", name: "some updated name"}
    @invalid_attrs %{countryId: nil, isoCode: nil, name: nil}

    def currency_fixture(attrs \\ %{}) do
      {:ok, currency} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSetting.create_currency()

      currency
    end

    test "list_tbl_currency/0 returns all tbl_currency" do
      currency = currency_fixture()
      assert SystemSetting.list_tbl_currency() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert SystemSetting.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      assert {:ok, %Currency{} = currency} = SystemSetting.create_currency(@valid_attrs)
      assert currency.countryId == 42
      assert currency.isoCode == "some isoCode"
      assert currency.name == "some name"
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSetting.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{} = currency} = SystemSetting.update_currency(currency, @update_attrs)
      assert currency.countryId == 43
      assert currency.isoCode == "some updated isoCode"
      assert currency.name == "some updated name"
    end

    test "update_currency/2 with invalid data returns error changeset" do
      currency = currency_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSetting.update_currency(currency, @invalid_attrs)
      assert currency == SystemSetting.get_currency!(currency.id)
    end

    test "delete_currency/1 deletes the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{}} = SystemSetting.delete_currency(currency)
      assert_raise Ecto.NoResultsError, fn -> SystemSetting.get_currency!(currency.id) end
    end

    test "change_currency/1 returns a currency changeset" do
      currency = currency_fixture()
      assert %Ecto.Changeset{} = SystemSetting.change_currency(currency)
    end
  end

  describe "tbl_country" do
    alias LoanSavingsSystem.SystemSetting.Country

    @valid_attrs %{name: "some name"}
    @update_attrs %{name: "some updated name"}
    @invalid_attrs %{name: nil}

    def country_fixture(attrs \\ %{}) do
      {:ok, country} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSetting.create_country()

      country
    end

    test "list_tbl_country/0 returns all tbl_country" do
      country = country_fixture()
      assert SystemSetting.list_tbl_country() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert SystemSetting.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      assert {:ok, %Country{} = country} = SystemSetting.create_country(@valid_attrs)
      assert country.name == "some name"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSetting.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      assert {:ok, %Country{} = country} = SystemSetting.update_country(country, @update_attrs)
      assert country.name == "some updated name"
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSetting.update_country(country, @invalid_attrs)
      assert country == SystemSetting.get_country!(country.id)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = SystemSetting.delete_country(country)
      assert_raise Ecto.NoResultsError, fn -> SystemSetting.get_country!(country.id) end
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = SystemSetting.change_country(country)
    end
  end

  describe "tbl_district" do
    alias LoanSavingsSystem.SystemSetting.District

    @valid_attrs %{countryId: 42, countryName: "some countryName", name: "some name", provinceId: 42, provinceName: "some provinceName"}
    @update_attrs %{countryId: 43, countryName: "some updated countryName", name: "some updated name", provinceId: 43, provinceName: "some updated provinceName"}
    @invalid_attrs %{countryId: nil, countryName: nil, name: nil, provinceId: nil, provinceName: nil}

    def district_fixture(attrs \\ %{}) do
      {:ok, district} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSetting.create_district()

      district
    end

    test "list_tbl_district/0 returns all tbl_district" do
      district = district_fixture()
      assert SystemSetting.list_tbl_district() == [district]
    end

    test "get_district!/1 returns the district with given id" do
      district = district_fixture()
      assert SystemSetting.get_district!(district.id) == district
    end

    test "create_district/1 with valid data creates a district" do
      assert {:ok, %District{} = district} = SystemSetting.create_district(@valid_attrs)
      assert district.countryId == 42
      assert district.countryName == "some countryName"
      assert district.name == "some name"
      assert district.provinceId == 42
      assert district.provinceName == "some provinceName"
    end

    test "create_district/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSetting.create_district(@invalid_attrs)
    end

    test "update_district/2 with valid data updates the district" do
      district = district_fixture()
      assert {:ok, %District{} = district} = SystemSetting.update_district(district, @update_attrs)
      assert district.countryId == 43
      assert district.countryName == "some updated countryName"
      assert district.name == "some updated name"
      assert district.provinceId == 43
      assert district.provinceName == "some updated provinceName"
    end

    test "update_district/2 with invalid data returns error changeset" do
      district = district_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSetting.update_district(district, @invalid_attrs)
      assert district == SystemSetting.get_district!(district.id)
    end

    test "delete_district/1 deletes the district" do
      district = district_fixture()
      assert {:ok, %District{}} = SystemSetting.delete_district(district)
      assert_raise Ecto.NoResultsError, fn -> SystemSetting.get_district!(district.id) end
    end

    test "change_district/1 returns a district changeset" do
      district = district_fixture()
      assert %Ecto.Changeset{} = SystemSetting.change_district(district)
    end
  end

  describe "tbl_province" do
    alias LoanSavingsSystem.SystemSetting.Province

    @valid_attrs %{countryId: 42, countryName: "some countryName", name: "some name"}
    @update_attrs %{countryId: 43, countryName: "some updated countryName", name: "some updated name"}
    @invalid_attrs %{countryId: nil, countryName: nil, name: nil}

    def province_fixture(attrs \\ %{}) do
      {:ok, province} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSetting.create_province()

      province
    end

    test "list_tbl_province/0 returns all tbl_province" do
      province = province_fixture()
      assert SystemSetting.list_tbl_province() == [province]
    end

    test "get_province!/1 returns the province with given id" do
      province = province_fixture()
      assert SystemSetting.get_province!(province.id) == province
    end

    test "create_province/1 with valid data creates a province" do
      assert {:ok, %Province{} = province} = SystemSetting.create_province(@valid_attrs)
      assert province.countryId == 42
      assert province.countryName == "some countryName"
      assert province.name == "some name"
    end

    test "create_province/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSetting.create_province(@invalid_attrs)
    end

    test "update_province/2 with valid data updates the province" do
      province = province_fixture()
      assert {:ok, %Province{} = province} = SystemSetting.update_province(province, @update_attrs)
      assert province.countryId == 43
      assert province.countryName == "some updated countryName"
      assert province.name == "some updated name"
    end

    test "update_province/2 with invalid data returns error changeset" do
      province = province_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSetting.update_province(province, @invalid_attrs)
      assert province == SystemSetting.get_province!(province.id)
    end

    test "delete_province/1 deletes the province" do
      province = province_fixture()
      assert {:ok, %Province{}} = SystemSetting.delete_province(province)
      assert_raise Ecto.NoResultsError, fn -> SystemSetting.get_province!(province.id) end
    end

    test "change_province/1 returns a province changeset" do
      province = province_fixture()
      assert %Ecto.Changeset{} = SystemSetting.change_province(province)
    end
  end

  describe "tbl_telco" do
    alias LoanSavingsSystem.SystemSetting.Telco

    @valid_attrs %{name: "some name", telcoIP: "some telcoIP"}
    @update_attrs %{name: "some updated name", telcoIP: "some updated telcoIP"}
    @invalid_attrs %{name: nil, telcoIP: nil}

    def telco_fixture(attrs \\ %{}) do
      {:ok, telco} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSetting.create_telco()

      telco
    end

    test "list_tbl_telco/0 returns all tbl_telco" do
      telco = telco_fixture()
      assert SystemSetting.list_tbl_telco() == [telco]
    end

    test "get_telco!/1 returns the telco with given id" do
      telco = telco_fixture()
      assert SystemSetting.get_telco!(telco.id) == telco
    end

    test "create_telco/1 with valid data creates a telco" do
      assert {:ok, %Telco{} = telco} = SystemSetting.create_telco(@valid_attrs)
      assert telco.name == "some name"
      assert telco.telcoIP == "some telcoIP"
    end

    test "create_telco/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSetting.create_telco(@invalid_attrs)
    end

    test "update_telco/2 with valid data updates the telco" do
      telco = telco_fixture()
      assert {:ok, %Telco{} = telco} = SystemSetting.update_telco(telco, @update_attrs)
      assert telco.name == "some updated name"
      assert telco.telcoIP == "some updated telcoIP"
    end

    test "update_telco/2 with invalid data returns error changeset" do
      telco = telco_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSetting.update_telco(telco, @invalid_attrs)
      assert telco == SystemSetting.get_telco!(telco.id)
    end

    test "delete_telco/1 deletes the telco" do
      telco = telco_fixture()
      assert {:ok, %Telco{}} = SystemSetting.delete_telco(telco)
      assert_raise Ecto.NoResultsError, fn -> SystemSetting.get_telco!(telco.id) end
    end

    test "change_telco/1 returns a telco changeset" do
      telco = telco_fixture()
      assert %Ecto.Changeset{} = SystemSetting.change_telco(telco)
    end
  end

  describe "tbl_client_telco" do
    alias LoanSavingsSystem.SystemSetting.ClientTelco

    @valid_attrs %{clientId: 42, telcoId: 42}
    @update_attrs %{clientId: 43, telcoId: 43}
    @invalid_attrs %{clientId: nil, telcoId: nil}

    def client_telco_fixture(attrs \\ %{}) do
      {:ok, client_telco} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSetting.create_client_telco()

      client_telco
    end

    test "list_tbl_client_telco/0 returns all tbl_client_telco" do
      client_telco = client_telco_fixture()
      assert SystemSetting.list_tbl_client_telco() == [client_telco]
    end

    test "get_client_telco!/1 returns the client_telco with given id" do
      client_telco = client_telco_fixture()
      assert SystemSetting.get_client_telco!(client_telco.id) == client_telco
    end

    test "create_client_telco/1 with valid data creates a client_telco" do
      assert {:ok, %ClientTelco{} = client_telco} = SystemSetting.create_client_telco(@valid_attrs)
      assert client_telco.clientId == 42
      assert client_telco.telcoId == 42
    end

    test "create_client_telco/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSetting.create_client_telco(@invalid_attrs)
    end

    test "update_client_telco/2 with valid data updates the client_telco" do
      client_telco = client_telco_fixture()
      assert {:ok, %ClientTelco{} = client_telco} = SystemSetting.update_client_telco(client_telco, @update_attrs)
      assert client_telco.clientId == 43
      assert client_telco.telcoId == 43
    end

    test "update_client_telco/2 with invalid data returns error changeset" do
      client_telco = client_telco_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSetting.update_client_telco(client_telco, @invalid_attrs)
      assert client_telco == SystemSetting.get_client_telco!(client_telco.id)
    end

    test "delete_client_telco/1 deletes the client_telco" do
      client_telco = client_telco_fixture()
      assert {:ok, %ClientTelco{}} = SystemSetting.delete_client_telco(client_telco)
      assert_raise Ecto.NoResultsError, fn -> SystemSetting.get_client_telco!(client_telco.id) end
    end

    test "change_client_telco/1 returns a client_telco changeset" do
      client_telco = client_telco_fixture()
      assert %Ecto.Changeset{} = SystemSetting.change_client_telco(client_telco)
    end
  end
end
