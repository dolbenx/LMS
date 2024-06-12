defmodule Loanmanagementsystem.MaintenanceTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Maintenance

  describe "tbl_banks" do
    alias Loanmanagementsystem.Maintenance.Bank

    import Loanmanagementsystem.MaintenanceFixtures

    @invalid_attrs %{acronym: nil, approved_by: nil, bank_address: nil, bank_code: nil, bank_descrip: nil, bank_name: nil, city_id: nil, country_id: nil, created_by: nil, district_id: nil, process_branch: nil, province_id: nil, status: nil, swift_code: nil}

    test "list_tbl_banks/0 returns all tbl_banks" do
      bank = bank_fixture()
      assert Maintenance.list_tbl_banks() == [bank]
    end

    test "get_bank!/1 returns the bank with given id" do
      bank = bank_fixture()
      assert Maintenance.get_bank!(bank.id) == bank
    end

    test "create_bank/1 with valid data creates a bank" do
      valid_attrs = %{acronym: "some acronym", approved_by: 42, bank_address: "some bank_address", bank_code: "some bank_code", bank_descrip: "some bank_descrip", bank_name: "some bank_name", city_id: 42, country_id: 42, created_by: 42, district_id: 42, process_branch: "some process_branch", province_id: 42, status: "some status", swift_code: "some swift_code"}

      assert {:ok, %Bank{} = bank} = Maintenance.create_bank(valid_attrs)
      assert bank.acronym == "some acronym"
      assert bank.approved_by == 42
      assert bank.bank_address == "some bank_address"
      assert bank.bank_code == "some bank_code"
      assert bank.bank_descrip == "some bank_descrip"
      assert bank.bank_name == "some bank_name"
      assert bank.city_id == 42
      assert bank.country_id == 42
      assert bank.created_by == 42
      assert bank.district_id == 42
      assert bank.process_branch == "some process_branch"
      assert bank.province_id == 42
      assert bank.status == "some status"
      assert bank.swift_code == "some swift_code"
    end

    test "create_bank/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_bank(@invalid_attrs)
    end

    test "update_bank/2 with valid data updates the bank" do
      bank = bank_fixture()
      update_attrs = %{acronym: "some updated acronym", approved_by: 43, bank_address: "some updated bank_address", bank_code: "some updated bank_code", bank_descrip: "some updated bank_descrip", bank_name: "some updated bank_name", city_id: 43, country_id: 43, created_by: 43, district_id: 43, process_branch: "some updated process_branch", province_id: 43, status: "some updated status", swift_code: "some updated swift_code"}

      assert {:ok, %Bank{} = bank} = Maintenance.update_bank(bank, update_attrs)
      assert bank.acronym == "some updated acronym"
      assert bank.approved_by == 43
      assert bank.bank_address == "some updated bank_address"
      assert bank.bank_code == "some updated bank_code"
      assert bank.bank_descrip == "some updated bank_descrip"
      assert bank.bank_name == "some updated bank_name"
      assert bank.city_id == 43
      assert bank.country_id == 43
      assert bank.created_by == 43
      assert bank.district_id == 43
      assert bank.process_branch == "some updated process_branch"
      assert bank.province_id == 43
      assert bank.status == "some updated status"
      assert bank.swift_code == "some updated swift_code"
    end

    test "update_bank/2 with invalid data returns error changeset" do
      bank = bank_fixture()
      assert {:error, %Ecto.Changeset{}} = Maintenance.update_bank(bank, @invalid_attrs)
      assert bank == Maintenance.get_bank!(bank.id)
    end

    test "delete_bank/1 deletes the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{}} = Maintenance.delete_bank(bank)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_bank!(bank.id) end
    end

    test "change_bank/1 returns a bank changeset" do
      bank = bank_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_bank(bank)
    end
  end

  describe "tbl_branchs" do
    alias Loanmanagementsystem.Maintenance.Branch

    import Loanmanagementsystem.MaintenanceFixtures

    @invalid_attrs %{"": nil, approved_by: nil, bank_id: nil, branch_address: nil, branch_code: nil, branch_name: nil, city_id: nil, country_id: nil, created_by: nil, district_id: nil, is_default_ussd_branch: nil, province_id: nil, status: nil}

    test "list_tbl_branchs/0 returns all tbl_branchs" do
      branch = branch_fixture()
      assert Maintenance.list_tbl_branchs() == [branch]
    end

    test "get_branch!/1 returns the branch with given id" do
      branch = branch_fixture()
      assert Maintenance.get_branch!(branch.id) == branch
    end

    test "create_branch/1 with valid data creates a branch" do
      valid_attrs = %{"": 42, approved_by: 42, bank_id: "some bank_id", branch_address: "some branch_address", branch_code: "some branch_code", branch_name: "some branch_name", city_id: 42, country_id: 42, created_by: 42, district_id: 42, is_default_ussd_branch: true, province_id: 42, status: "some status"}

      assert {:ok, %Branch{} = branch} = Maintenance.create_branch(valid_attrs)
      assert branch. == 42
      assert branch.approved_by == 42
      assert branch.bank_id == "some bank_id"
      assert branch.branch_address == "some branch_address"
      assert branch.branch_code == "some branch_code"
      assert branch.branch_name == "some branch_name"
      assert branch.city_id == 42
      assert branch.country_id == 42
      assert branch.created_by == 42
      assert branch.district_id == 42
      assert branch.is_default_ussd_branch == true
      assert branch.province_id == 42
      assert branch.status == "some status"
    end

    test "create_branch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_branch(@invalid_attrs)
    end

    test "update_branch/2 with valid data updates the branch" do
      branch = branch_fixture()
      update_attrs = %{"": 43, approved_by: 43, bank_id: "some updated bank_id", branch_address: "some updated branch_address", branch_code: "some updated branch_code", branch_name: "some updated branch_name", city_id: 43, country_id: 43, created_by: 43, district_id: 43, is_default_ussd_branch: false, province_id: 43, status: "some updated status"}

      assert {:ok, %Branch{} = branch} = Maintenance.update_branch(branch, update_attrs)
      assert branch. == 43
      assert branch.approved_by == 43
      assert branch.bank_id == "some updated bank_id"
      assert branch.branch_address == "some updated branch_address"
      assert branch.branch_code == "some updated branch_code"
      assert branch.branch_name == "some updated branch_name"
      assert branch.city_id == 43
      assert branch.country_id == 43
      assert branch.created_by == 43
      assert branch.district_id == 43
      assert branch.is_default_ussd_branch == false
      assert branch.province_id == 43
      assert branch.status == "some updated status"
    end

    test "update_branch/2 with invalid data returns error changeset" do
      branch = branch_fixture()
      assert {:error, %Ecto.Changeset{}} = Maintenance.update_branch(branch, @invalid_attrs)
      assert branch == Maintenance.get_branch!(branch.id)
    end

    test "delete_branch/1 deletes the branch" do
      branch = branch_fixture()
      assert {:ok, %Branch{}} = Maintenance.delete_branch(branch)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_branch!(branch.id) end
    end

    test "change_branch/1 returns a branch changeset" do
      branch = branch_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_branch(branch)
    end
  end

  describe "tbl_country" do
    alias Loanmanagementsystem.Maintenance.Country

    import Loanmanagementsystem.MaintenanceFixtures

    @invalid_attrs %{approved_by: nil, code: nil, country_file_name: nil, created_by: nil, name: nil, status: nil}

    test "list_tbl_country/0 returns all tbl_country" do
      country = country_fixture()
      assert Maintenance.list_tbl_country() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert Maintenance.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      valid_attrs = %{approved_by: 42, code: "some code", country_file_name: "some country_file_name", created_by: 42, name: "some name", status: "some status"}

      assert {:ok, %Country{} = country} = Maintenance.create_country(valid_attrs)
      assert country.approved_by == 42
      assert country.code == "some code"
      assert country.country_file_name == "some country_file_name"
      assert country.created_by == 42
      assert country.name == "some name"
      assert country.status == "some status"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      update_attrs = %{approved_by: 43, code: "some updated code", country_file_name: "some updated country_file_name", created_by: 43, name: "some updated name", status: "some updated status"}

      assert {:ok, %Country{} = country} = Maintenance.update_country(country, update_attrs)
      assert country.approved_by == 43
      assert country.code == "some updated code"
      assert country.country_file_name == "some updated country_file_name"
      assert country.created_by == 43
      assert country.name == "some updated name"
      assert country.status == "some updated status"
    end

    test "update_country/2 with invalid data returns error changeset" do
      country = country_fixture()
      assert {:error, %Ecto.Changeset{}} = Maintenance.update_country(country, @invalid_attrs)
      assert country == Maintenance.get_country!(country.id)
    end

    test "delete_country/1 deletes the country" do
      country = country_fixture()
      assert {:ok, %Country{}} = Maintenance.delete_country(country)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_country!(country.id) end
    end

    test "change_country/1 returns a country changeset" do
      country = country_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_country(country)
    end
  end

  describe "tbl_province" do
    alias Loanmanagementsystem.Maintenance.Province

    import Loanmanagementsystem.MaintenanceFixtures

    @invalid_attrs %{approved_by: nil, country_id: nil, created_by: nil, name: nil, status: nil}

    test "list_tbl_province/0 returns all tbl_province" do
      province = province_fixture()
      assert Maintenance.list_tbl_province() == [province]
    end

    test "get_province!/1 returns the province with given id" do
      province = province_fixture()
      assert Maintenance.get_province!(province.id) == province
    end

    test "create_province/1 with valid data creates a province" do
      valid_attrs = %{approved_by: 42, country_id: 42, created_by: 42, name: "some name", status: "some status"}

      assert {:ok, %Province{} = province} = Maintenance.create_province(valid_attrs)
      assert province.approved_by == 42
      assert province.country_id == 42
      assert province.created_by == 42
      assert province.name == "some name"
      assert province.status == "some status"
    end

    test "create_province/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_province(@invalid_attrs)
    end

    test "update_province/2 with valid data updates the province" do
      province = province_fixture()
      update_attrs = %{approved_by: 43, country_id: 43, created_by: 43, name: "some updated name", status: "some updated status"}

      assert {:ok, %Province{} = province} = Maintenance.update_province(province, update_attrs)
      assert province.approved_by == 43
      assert province.country_id == 43
      assert province.created_by == 43
      assert province.name == "some updated name"
      assert province.status == "some updated status"
    end

    test "update_province/2 with invalid data returns error changeset" do
      province = province_fixture()
      assert {:error, %Ecto.Changeset{}} = Maintenance.update_province(province, @invalid_attrs)
      assert province == Maintenance.get_province!(province.id)
    end

    test "delete_province/1 deletes the province" do
      province = province_fixture()
      assert {:ok, %Province{}} = Maintenance.delete_province(province)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_province!(province.id) end
    end

    test "change_province/1 returns a province changeset" do
      province = province_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_province(province)
    end
  end

  describe "tbl_district" do
    alias Loanmanagementsystem.Maintenance.District

    import Loanmanagementsystem.MaintenanceFixtures

    @invalid_attrs %{approved_by: nil, country_id: nil, created_by: nil, name: nil, province_id: nil, status: nil}

    test "list_tbl_district/0 returns all tbl_district" do
      district = district_fixture()
      assert Maintenance.list_tbl_district() == [district]
    end

    test "get_district!/1 returns the district with given id" do
      district = district_fixture()
      assert Maintenance.get_district!(district.id) == district
    end

    test "create_district/1 with valid data creates a district" do
      valid_attrs = %{approved_by: 42, country_id: 42, created_by: 42, name: "some name", province_id: 42, status: "some status"}

      assert {:ok, %District{} = district} = Maintenance.create_district(valid_attrs)
      assert district.approved_by == 42
      assert district.country_id == 42
      assert district.created_by == 42
      assert district.name == "some name"
      assert district.province_id == 42
      assert district.status == "some status"
    end

    test "create_district/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_district(@invalid_attrs)
    end

    test "update_district/2 with valid data updates the district" do
      district = district_fixture()
      update_attrs = %{approved_by: 43, country_id: 43, created_by: 43, name: "some updated name", province_id: 43, status: "some updated status"}

      assert {:ok, %District{} = district} = Maintenance.update_district(district, update_attrs)
      assert district.approved_by == 43
      assert district.country_id == 43
      assert district.created_by == 43
      assert district.name == "some updated name"
      assert district.province_id == 43
      assert district.status == "some updated status"
    end

    test "update_district/2 with invalid data returns error changeset" do
      district = district_fixture()
      assert {:error, %Ecto.Changeset{}} = Maintenance.update_district(district, @invalid_attrs)
      assert district == Maintenance.get_district!(district.id)
    end

    test "delete_district/1 deletes the district" do
      district = district_fixture()
      assert {:ok, %District{}} = Maintenance.delete_district(district)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_district!(district.id) end
    end

    test "change_district/1 returns a district changeset" do
      district = district_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_district(district)
    end
  end

  describe "tbl_currency" do
    alias Loanmanagementsystem.Maintenance.Currency

    import Loanmanagementsystem.MaintenanceFixtures

    @invalid_attrs %{acronym: nil, approved_by: nil, country_id: nil, created_by: nil, currency_decimal: nil, iso_code: nil, name: nil, status: nil}

    test "list_tbl_currency/0 returns all tbl_currency" do
      currency = currency_fixture()
      assert Maintenance.list_tbl_currency() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Maintenance.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      valid_attrs = %{acronym: "some acronym", approved_by: 42, country_id: 42, created_by: 42, currency_decimal: 42, iso_code: "some iso_code", name: "some name", status: "some status"}

      assert {:ok, %Currency{} = currency} = Maintenance.create_currency(valid_attrs)
      assert currency.acronym == "some acronym"
      assert currency.approved_by == 42
      assert currency.country_id == 42
      assert currency.created_by == 42
      assert currency.currency_decimal == 42
      assert currency.iso_code == "some iso_code"
      assert currency.name == "some name"
      assert currency.status == "some status"
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      update_attrs = %{acronym: "some updated acronym", approved_by: 43, country_id: 43, created_by: 43, currency_decimal: 43, iso_code: "some updated iso_code", name: "some updated name", status: "some updated status"}

      assert {:ok, %Currency{} = currency} = Maintenance.update_currency(currency, update_attrs)
      assert currency.acronym == "some updated acronym"
      assert currency.approved_by == 43
      assert currency.country_id == 43
      assert currency.created_by == 43
      assert currency.currency_decimal == 43
      assert currency.iso_code == "some updated iso_code"
      assert currency.name == "some updated name"
      assert currency.status == "some updated status"
    end

    test "update_currency/2 with invalid data returns error changeset" do
      currency = currency_fixture()
      assert {:error, %Ecto.Changeset{}} = Maintenance.update_currency(currency, @invalid_attrs)
      assert currency == Maintenance.get_currency!(currency.id)
    end

    test "delete_currency/1 deletes the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{}} = Maintenance.delete_currency(currency)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_currency!(currency.id) end
    end

    test "change_currency/1 returns a currency changeset" do
      currency = currency_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_currency(currency)
    end
  end
end
