defmodule LoanSavingsSystem.MaintenanceTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Maintenance

  describe "tbl_country" do
    alias LoanSavingsSystem.Maintenance.Currency

    @valid_attrs %{auth_status: "some auth_status", country: "some country", country_code: "some country_code", country_file_name: "some country_file_name", iso_alpha_2_codes: "some iso_alpha_2_codes", iso_alpha_3_codes: "some iso_alpha_3_codes", modification: "some modification"}
    @update_attrs %{auth_status: "some updated auth_status", country: "some updated country", country_code: "some updated country_code", country_file_name: "some updated country_file_name", iso_alpha_2_codes: "some updated iso_alpha_2_codes", iso_alpha_3_codes: "some updated iso_alpha_3_codes", modification: "some updated modification"}
    @invalid_attrs %{auth_status: nil, country: nil, country_code: nil, country_file_name: nil, iso_alpha_2_codes: nil, iso_alpha_3_codes: nil, modification: nil}

    def currency_fixture(attrs \\ %{}) do
      {:ok, currency} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_currency()

      currency
    end

    test "list_tbl_country/0 returns all tbl_country" do
      currency = currency_fixture()
      assert Maintenance.list_tbl_country() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Maintenance.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      assert {:ok, %Currency{} = currency} = Maintenance.create_currency(@valid_attrs)
      assert currency.auth_status == "some auth_status"
      assert currency.country == "some country"
      assert currency.country_code == "some country_code"
      assert currency.country_file_name == "some country_file_name"
      assert currency.iso_alpha_2_codes == "some iso_alpha_2_codes"
      assert currency.iso_alpha_3_codes == "some iso_alpha_3_codes"
      assert currency.modification == "some modification"
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{} = currency} = Maintenance.update_currency(currency, @update_attrs)
      assert currency.auth_status == "some updated auth_status"
      assert currency.country == "some updated country"
      assert currency.country_code == "some updated country_code"
      assert currency.country_file_name == "some updated country_file_name"
      assert currency.iso_alpha_2_codes == "some updated iso_alpha_2_codes"
      assert currency.iso_alpha_3_codes == "some updated iso_alpha_3_codes"
      assert currency.modification == "some updated modification"
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

  describe "tbl_currency" do
    alias LoanSavingsSystem.Maintenance.Currency

    @valid_attrs %{curr_acronym: "some curr_acronym", curr_code: "some curr_code", curr_descrip: "some curr_descrip", currency_country: "some currency_country", iso_nemurical_code: "some iso_nemurical_code"}
    @update_attrs %{curr_acronym: "some updated curr_acronym", curr_code: "some updated curr_code", curr_descrip: "some updated curr_descrip", currency_country: "some updated currency_country", iso_nemurical_code: "some updated iso_nemurical_code"}
    @invalid_attrs %{curr_acronym: nil, curr_code: nil, curr_descrip: nil, currency_country: nil, iso_nemurical_code: nil}

    def currency_fixture(attrs \\ %{}) do
      {:ok, currency} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_currency()

      currency
    end

    test "list_tbl_currency/0 returns all tbl_currency" do
      currency = currency_fixture()
      assert Maintenance.list_tbl_currency() == [currency]
    end

    test "get_currency!/1 returns the currency with given id" do
      currency = currency_fixture()
      assert Maintenance.get_currency!(currency.id) == currency
    end

    test "create_currency/1 with valid data creates a currency" do
      assert {:ok, %Currency{} = currency} = Maintenance.create_currency(@valid_attrs)
      assert currency.curr_acronym == "some curr_acronym"
      assert currency.curr_code == "some curr_code"
      assert currency.curr_descrip == "some curr_descrip"
      assert currency.currency_country == "some currency_country"
      assert currency.iso_nemurical_code == "some iso_nemurical_code"
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{} = currency} = Maintenance.update_currency(currency, @update_attrs)
      assert currency.curr_acronym == "some updated curr_acronym"
      assert currency.curr_code == "some updated curr_code"
      assert currency.curr_descrip == "some updated curr_descrip"
      assert currency.currency_country == "some updated currency_country"
      assert currency.iso_nemurical_code == "some updated iso_nemurical_code"
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

  describe "tbl_document" do
    alias LoanSavingsSystem.Maintenance.Document

    @valid_attrs %{company_id: "some company_id", customer_id: "some customer_id", name: "some name", off_taker_id: "some off_taker_id", status: "some status", type_of_doc: "some type_of_doc", user_id: "some user_id"}
    @update_attrs %{company_id: "some updated company_id", customer_id: "some updated customer_id", name: "some updated name", off_taker_id: "some updated off_taker_id", status: "some updated status", type_of_doc: "some updated type_of_doc", user_id: "some updated user_id"}
    @invalid_attrs %{company_id: nil, customer_id: nil, name: nil, off_taker_id: nil, status: nil, type_of_doc: nil, user_id: nil}

    def document_fixture(attrs \\ %{}) do
      {:ok, document} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_document()

      document
    end

    test "list_tbl_document/0 returns all tbl_document" do
      document = document_fixture()
      assert Maintenance.list_tbl_document() == [document]
    end

    test "get_document!/1 returns the document with given id" do
      document = document_fixture()
      assert Maintenance.get_document!(document.id) == document
    end

    test "create_document/1 with valid data creates a document" do
      assert {:ok, %Document{} = document} = Maintenance.create_document(@valid_attrs)
      assert document.company_id == "some company_id"
      assert document.customer_id == "some customer_id"
      assert document.name == "some name"
      assert document.off_taker_id == "some off_taker_id"
      assert document.status == "some status"
      assert document.type_of_doc == "some type_of_doc"
      assert document.user_id == "some user_id"
    end

    test "create_document/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_document(@invalid_attrs)
    end

    test "update_document/2 with valid data updates the document" do
      document = document_fixture()
      assert {:ok, %Document{} = document} = Maintenance.update_document(document, @update_attrs)
      assert document.company_id == "some updated company_id"
      assert document.customer_id == "some updated customer_id"
      assert document.name == "some updated name"
      assert document.off_taker_id == "some updated off_taker_id"
      assert document.status == "some updated status"
      assert document.type_of_doc == "some updated type_of_doc"
      assert document.user_id == "some updated user_id"
    end

    test "update_document/2 with invalid data returns error changeset" do
      document = document_fixture()
      assert {:error, %Ecto.Changeset{}} = Maintenance.update_document(document, @invalid_attrs)
      assert document == Maintenance.get_document!(document.id)
    end

    test "delete_document/1 deletes the document" do
      document = document_fixture()
      assert {:ok, %Document{}} = Maintenance.delete_document(document)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_document!(document.id) end
    end

    test "change_document/1 returns a document changeset" do
      document = document_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_document(document)
    end
  end

  describe "tbl_country" do
    alias LoanSavingsSystem.Maintenance.Country

    @valid_attrs %{auth_status: "some auth_status", country: "some country", country_code: "some country_code", country_file_name: "some country_file_name", iso_alpha_2_codes: "some iso_alpha_2_codes", iso_alpha_3_codes: "some iso_alpha_3_codes", modification: "some modification"}
    @update_attrs %{auth_status: "some updated auth_status", country: "some updated country", country_code: "some updated country_code", country_file_name: "some updated country_file_name", iso_alpha_2_codes: "some updated iso_alpha_2_codes", iso_alpha_3_codes: "some updated iso_alpha_3_codes", modification: "some updated modification"}
    @invalid_attrs %{auth_status: nil, country: nil, country_code: nil, country_file_name: nil, iso_alpha_2_codes: nil, iso_alpha_3_codes: nil, modification: nil}

    def country_fixture(attrs \\ %{}) do
      {:ok, country} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_country()

      country
    end

    test "list_tbl_country/0 returns all tbl_country" do
      country = country_fixture()
      assert Maintenance.list_tbl_country() == [country]
    end

    test "get_country!/1 returns the country with given id" do
      country = country_fixture()
      assert Maintenance.get_country!(country.id) == country
    end

    test "create_country/1 with valid data creates a country" do
      assert {:ok, %Country{} = country} = Maintenance.create_country(@valid_attrs)
      assert country.auth_status == "some auth_status"
      assert country.country == "some country"
      assert country.country_code == "some country_code"
      assert country.country_file_name == "some country_file_name"
      assert country.iso_alpha_2_codes == "some iso_alpha_2_codes"
      assert country.iso_alpha_3_codes == "some iso_alpha_3_codes"
      assert country.modification == "some modification"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      assert {:ok, %Country{} = country} = Maintenance.update_country(country, @update_attrs)
      assert country.auth_status == "some updated auth_status"
      assert country.country == "some updated country"
      assert country.country_code == "some updated country_code"
      assert country.country_file_name == "some updated country_file_name"
      assert country.iso_alpha_2_codes == "some updated iso_alpha_2_codes"
      assert country.iso_alpha_3_codes == "some updated iso_alpha_3_codes"
      assert country.modification == "some updated modification"
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

  describe "tbl_branches" do
    alias LoanSavingsSystem.Maintenance.Branch

    @valid_attrs %{branch_address: "some branch_address", branch_district: "some branch_district", branch_name: "some branch_name", branch_province: "some branch_province", opening_date: ~D[2010-04-17], parent_branch_id: 42}
    @update_attrs %{branch_address: "some updated branch_address", branch_district: "some updated branch_district", branch_name: "some updated branch_name", branch_province: "some updated branch_province", opening_date: ~D[2011-05-18], parent_branch_id: 43}
    @invalid_attrs %{branch_address: nil, branch_district: nil, branch_name: nil, branch_province: nil, opening_date: nil, parent_branch_id: nil}

    def branch_fixture(attrs \\ %{}) do
      {:ok, branch} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_branch()

      branch
    end

    test "list_tbl_branches/0 returns all tbl_branches" do
      branch = branch_fixture()
      assert Maintenance.list_tbl_branches() == [branch]
    end

    test "get_branch!/1 returns the branch with given id" do
      branch = branch_fixture()
      assert Maintenance.get_branch!(branch.id) == branch
    end

    test "create_branch/1 with valid data creates a branch" do
      assert {:ok, %Branch{} = branch} = Maintenance.create_branch(@valid_attrs)
      assert branch.branch_address == "some branch_address"
      assert branch.branch_district == "some branch_district"
      assert branch.branch_name == "some branch_name"
      assert branch.branch_province == "some branch_province"
      assert branch.opening_date == ~D[2010-04-17]
      assert branch.parent_branch_id == 42
    end

    test "create_branch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_branch(@invalid_attrs)
    end

    test "update_branch/2 with valid data updates the branch" do
      branch = branch_fixture()
      assert {:ok, %Branch{} = branch} = Maintenance.update_branch(branch, @update_attrs)
      assert branch.branch_address == "some updated branch_address"
      assert branch.branch_district == "some updated branch_district"
      assert branch.branch_name == "some updated branch_name"
      assert branch.branch_province == "some updated branch_province"
      assert branch.opening_date == ~D[2011-05-18]
      assert branch.parent_branch_id == 43
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
end
