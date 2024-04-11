defmodule Loanmanagementsystem.MaintenanceTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Maintenance

  describe "tbl_currency" do
    alias Loanmanagementsystem.Maintenance.Currency

    @valid_attrs %{countryId: 42, isoCode: "some isoCode", name: "some name"}
    @update_attrs %{countryId: 43, isoCode: "some updated isoCode", name: "some updated name"}
    @invalid_attrs %{countryId: nil, isoCode: nil, name: nil}

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
      assert currency.countryId == 42
      assert currency.isoCode == "some isoCode"
      assert currency.name == "some name"
    end

    test "create_currency/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_currency(@invalid_attrs)
    end

    test "update_currency/2 with valid data updates the currency" do
      currency = currency_fixture()
      assert {:ok, %Currency{} = currency} = Maintenance.update_currency(currency, @update_attrs)
      assert currency.countryId == 43
      assert currency.isoCode == "some updated isoCode"
      assert currency.name == "some updated name"
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

  describe "tbl_country" do
    alias Loanmanagementsystem.Maintenance.Country

    @valid_attrs %{country_file_name: "some country_file_name", name: "some name"}
    @update_attrs %{
      country_file_name: "some updated country_file_name",
      name: "some updated name"
    }
    @invalid_attrs %{country_file_name: nil, name: nil}

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
      assert country.country_file_name == "some country_file_name"
      assert country.name == "some name"
    end

    test "create_country/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_country(@invalid_attrs)
    end

    test "update_country/2 with valid data updates the country" do
      country = country_fixture()
      assert {:ok, %Country{} = country} = Maintenance.update_country(country, @update_attrs)
      assert country.country_file_name == "some updated country_file_name"
      assert country.name == "some updated name"
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

    @valid_attrs %{countryId: 42, countryName: "some countryName", name: "some name"}
    @update_attrs %{
      countryId: 43,
      countryName: "some updated countryName",
      name: "some updated name"
    }
    @invalid_attrs %{countryId: nil, countryName: nil, name: nil}

    def province_fixture(attrs \\ %{}) do
      {:ok, province} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_province()

      province
    end

    test "list_tbl_province/0 returns all tbl_province" do
      province = province_fixture()
      assert Maintenance.list_tbl_province() == [province]
    end

    test "get_province!/1 returns the province with given id" do
      province = province_fixture()
      assert Maintenance.get_province!(province.id) == province
    end

    test "create_province/1 with valid data creates a province" do
      assert {:ok, %Province{} = province} = Maintenance.create_province(@valid_attrs)
      assert province.countryId == 42
      assert province.countryName == "some countryName"
      assert province.name == "some name"
    end

    test "create_province/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_province(@invalid_attrs)
    end

    test "update_province/2 with valid data updates the province" do
      province = province_fixture()
      assert {:ok, %Province{} = province} = Maintenance.update_province(province, @update_attrs)
      assert province.countryId == 43
      assert province.countryName == "some updated countryName"
      assert province.name == "some updated name"
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

    @valid_attrs %{
      countryId: 42,
      countryName: "some countryName",
      name: "some name",
      provinceId: 42,
      provinceName: "some provinceName"
    }
    @update_attrs %{
      countryId: 43,
      countryName: "some updated countryName",
      name: "some updated name",
      provinceId: 43,
      provinceName: "some updated provinceName"
    }
    @invalid_attrs %{
      countryId: nil,
      countryName: nil,
      name: nil,
      provinceId: nil,
      provinceName: nil
    }

    def district_fixture(attrs \\ %{}) do
      {:ok, district} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_district()

      district
    end

    test "list_tbl_district/0 returns all tbl_district" do
      district = district_fixture()
      assert Maintenance.list_tbl_district() == [district]
    end

    test "get_district!/1 returns the district with given id" do
      district = district_fixture()
      assert Maintenance.get_district!(district.id) == district
    end

    test "create_district/1 with valid data creates a district" do
      assert {:ok, %District{} = district} = Maintenance.create_district(@valid_attrs)
      assert district.countryId == 42
      assert district.countryName == "some countryName"
      assert district.name == "some name"
      assert district.provinceId == 42
      assert district.provinceName == "some provinceName"
    end

    test "create_district/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_district(@invalid_attrs)
    end

    test "update_district/2 with valid data updates the district" do
      district = district_fixture()
      assert {:ok, %District{} = district} = Maintenance.update_district(district, @update_attrs)
      assert district.countryId == 43
      assert district.countryName == "some updated countryName"
      assert district.name == "some updated name"
      assert district.provinceId == 43
      assert district.provinceName == "some updated provinceName"
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

  describe "tbl_security_questions" do
    alias Loanmanagementsystem.Maintenance.Security_questions

    @valid_attrs %{
      productType: "some productType",
      question: "some question",
      status: "some status"
    }
    @update_attrs %{
      productType: "some updated productType",
      question: "some updated question",
      status: "some updated status"
    }
    @invalid_attrs %{productType: nil, question: nil, status: nil}

    def security_questions_fixture(attrs \\ %{}) do
      {:ok, security_questions} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_security_questions()

      security_questions
    end

    test "list_tbl_security_questions/0 returns all tbl_security_questions" do
      security_questions = security_questions_fixture()
      assert Maintenance.list_tbl_security_questions() == [security_questions]
    end

    test "get_security_questions!/1 returns the security_questions with given id" do
      security_questions = security_questions_fixture()
      assert Maintenance.get_security_questions!(security_questions.id) == security_questions
    end

    test "create_security_questions/1 with valid data creates a security_questions" do
      assert {:ok, %Security_questions{} = security_questions} =
               Maintenance.create_security_questions(@valid_attrs)

      assert security_questions.productType == "some productType"
      assert security_questions.question == "some question"
      assert security_questions.status == "some status"
    end

    test "create_security_questions/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_security_questions(@invalid_attrs)
    end

    test "update_security_questions/2 with valid data updates the security_questions" do
      security_questions = security_questions_fixture()

      assert {:ok, %Security_questions{} = security_questions} =
               Maintenance.update_security_questions(security_questions, @update_attrs)

      assert security_questions.productType == "some updated productType"
      assert security_questions.question == "some updated question"
      assert security_questions.status == "some updated status"
    end

    test "update_security_questions/2 with invalid data returns error changeset" do
      security_questions = security_questions_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maintenance.update_security_questions(security_questions, @invalid_attrs)

      assert security_questions == Maintenance.get_security_questions!(security_questions.id)
    end

    test "delete_security_questions/1 deletes the security_questions" do
      security_questions = security_questions_fixture()

      assert {:ok, %Security_questions{}} =
               Maintenance.delete_security_questions(security_questions)

      assert_raise Ecto.NoResultsError, fn ->
        Maintenance.get_security_questions!(security_questions.id)
      end
    end

    test "change_security_questions/1 returns a security_questions changeset" do
      security_questions = security_questions_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_security_questions(security_questions)
    end
  end

  describe "tbl_branch" do
    alias Loanmanagementsystem.Maintenance.Branch

    @valid_attrs %{
      approved_by: 42,
      branchCode: "some branchCode",
      branchName: "some branchName",
      clientId: 42,
      created_by: 42,
      isDefaultUSSDBranch: true,
      status: "some status"
    }
    @update_attrs %{
      approved_by: 43,
      branchCode: "some updated branchCode",
      branchName: "some updated branchName",
      clientId: 43,
      created_by: 43,
      isDefaultUSSDBranch: false,
      status: "some updated status"
    }
    @invalid_attrs %{
      approved_by: nil,
      branchCode: nil,
      branchName: nil,
      clientId: nil,
      created_by: nil,
      isDefaultUSSDBranch: nil,
      status: nil
    }

    def branch_fixture(attrs \\ %{}) do
      {:ok, branch} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_branch()

      branch
    end

    test "list_tbl_branch/0 returns all tbl_branch" do
      branch = branch_fixture()
      assert Maintenance.list_tbl_branch() == [branch]
    end

    test "get_branch!/1 returns the branch with given id" do
      branch = branch_fixture()
      assert Maintenance.get_branch!(branch.id) == branch
    end

    test "create_branch/1 with valid data creates a branch" do
      assert {:ok, %Branch{} = branch} = Maintenance.create_branch(@valid_attrs)
      assert branch.approved_by == 42
      assert branch.branchCode == "some branchCode"
      assert branch.branchName == "some branchName"
      assert branch.clientId == 42
      assert branch.created_by == 42
      assert branch.isDefaultUSSDBranch == true
      assert branch.status == "some status"
    end

    test "create_branch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_branch(@invalid_attrs)
    end

    test "update_branch/2 with valid data updates the branch" do
      branch = branch_fixture()
      assert {:ok, %Branch{} = branch} = Maintenance.update_branch(branch, @update_attrs)
      assert branch.approved_by == 43
      assert branch.branchCode == "some updated branchCode"
      assert branch.branchName == "some updated branchName"
      assert branch.clientId == 43
      assert branch.created_by == 43
      assert branch.isDefaultUSSDBranch == false
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

  describe "tbl_banks" do
    alias Loanmanagementsystem.Maintenance.Bank

    @valid_attrs %{
      acronym: "some acronym",
      bank_code: "some bank_code",
      bank_descrip: "some bank_descrip",
      center_code: "some center_code",
      process_branch: "some process_branch",
      swift_code: "some swift_code"
    }
    @update_attrs %{
      acronym: "some updated acronym",
      bank_code: "some updated bank_code",
      bank_descrip: "some updated bank_descrip",
      center_code: "some updated center_code",
      process_branch: "some updated process_branch",
      swift_code: "some updated swift_code"
    }
    @invalid_attrs %{
      acronym: nil,
      bank_code: nil,
      bank_descrip: nil,
      center_code: nil,
      process_branch: nil,
      swift_code: nil
    }

    def bank_fixture(attrs \\ %{}) do
      {:ok, bank} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_bank()

      bank
    end

    test "list_tbl_banks/0 returns all tbl_banks" do
      bank = bank_fixture()
      assert Maintenance.list_tbl_banks() == [bank]
    end

    test "get_bank!/1 returns the bank with given id" do
      bank = bank_fixture()
      assert Maintenance.get_bank!(bank.id) == bank
    end

    test "create_bank/1 with valid data creates a bank" do
      assert {:ok, %Bank{} = bank} = Maintenance.create_bank(@valid_attrs)
      assert bank.acronym == "some acronym"
      assert bank.bank_code == "some bank_code"
      assert bank.bank_descrip == "some bank_descrip"
      assert bank.center_code == "some center_code"
      assert bank.process_branch == "some process_branch"
      assert bank.swift_code == "some swift_code"
    end

    test "create_bank/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_bank(@invalid_attrs)
    end

    test "update_bank/2 with valid data updates the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{} = bank} = Maintenance.update_bank(bank, @update_attrs)
      assert bank.acronym == "some updated acronym"
      assert bank.bank_code == "some updated bank_code"
      assert bank.bank_descrip == "some updated bank_descrip"
      assert bank.center_code == "some updated center_code"
      assert bank.process_branch == "some updated process_branch"
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

  describe "tbl_classification" do
    alias Loanmanagementsystem.Maintenance.Classification

    @valid_attrs %{
      classification: "some classification",
      loan_maximum: 120.5,
      loan_minimum: 120.5,
      status: "some status"
    }
    @update_attrs %{
      classification: "some updated classification",
      loan_maximum: 456.7,
      loan_minimum: 456.7,
      status: "some updated status"
    }
    @invalid_attrs %{classification: nil, loan_maximum: nil, loan_minimum: nil, status: nil}

    def classification_fixture(attrs \\ %{}) do
      {:ok, classification} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_classification()

      classification
    end

    test "list_tbl_classification/0 returns all tbl_classification" do
      classification = classification_fixture()
      assert Maintenance.list_tbl_classification() == [classification]
    end

    test "get_classification!/1 returns the classification with given id" do
      classification = classification_fixture()
      assert Maintenance.get_classification!(classification.id) == classification
    end

    test "create_classification/1 with valid data creates a classification" do
      assert {:ok, %Classification{} = classification} =
               Maintenance.create_classification(@valid_attrs)

      assert classification.classification == "some classification"
      assert classification.loan_maximum == 120.5
      assert classification.loan_minimum == 120.5
      assert classification.status == "some status"
    end

    test "create_classification/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_classification(@invalid_attrs)
    end

    test "update_classification/2 with valid data updates the classification" do
      classification = classification_fixture()

      assert {:ok, %Classification{} = classification} =
               Maintenance.update_classification(classification, @update_attrs)

      assert classification.classification == "some updated classification"
      assert classification.loan_maximum == 456.7
      assert classification.loan_minimum == 456.7
      assert classification.status == "some updated status"
    end

    test "update_classification/2 with invalid data returns error changeset" do
      classification = classification_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maintenance.update_classification(classification, @invalid_attrs)

      assert classification == Maintenance.get_classification!(classification.id)
    end

    test "delete_classification/1 deletes the classification" do
      classification = classification_fixture()
      assert {:ok, %Classification{}} = Maintenance.delete_classification(classification)

      assert_raise Ecto.NoResultsError, fn ->
        Maintenance.get_classification!(classification.id)
      end
    end

    test "change_classification/1 returns a classification changeset" do
      classification = classification_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_classification(classification)
    end
  end

  describe "tbl_msg_mgt" do
    alias Loanmanagementsystem.Maintenance.Message_Management

    @valid_attrs %{msg: "some msg", msg_type: "some msg_type", status: "some status"}
    @update_attrs %{
      msg: "some updated msg",
      msg_type: "some updated msg_type",
      status: "some updated status"
    }
    @invalid_attrs %{msg: nil, msg_type: nil, status: nil}

    def message__management_fixture(attrs \\ %{}) do
      {:ok, message__management} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_message__management()

      message__management
    end

    test "list_tbl_msg_mgt/0 returns all tbl_msg_mgt" do
      message__management = message__management_fixture()
      assert Maintenance.list_tbl_msg_mgt() == [message__management]
    end

    test "get_message__management!/1 returns the message__management with given id" do
      message__management = message__management_fixture()
      assert Maintenance.get_message__management!(message__management.id) == message__management
    end

    test "create_message__management/1 with valid data creates a message__management" do
      assert {:ok, %Message_Management{} = message__management} =
               Maintenance.create_message__management(@valid_attrs)

      assert message__management.msg == "some msg"
      assert message__management.msg_type == "some msg_type"
      assert message__management.status == "some status"
    end

    test "create_message__management/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_message__management(@invalid_attrs)
    end

    test "update_message__management/2 with valid data updates the message__management" do
      message__management = message__management_fixture()

      assert {:ok, %Message_Management{} = message__management} =
               Maintenance.update_message__management(message__management, @update_attrs)

      assert message__management.msg == "some updated msg"
      assert message__management.msg_type == "some updated msg_type"
      assert message__management.status == "some updated status"
    end

    test "update_message__management/2 with invalid data returns error changeset" do
      message__management = message__management_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maintenance.update_message__management(message__management, @invalid_attrs)

      assert message__management == Maintenance.get_message__management!(message__management.id)
    end

    test "delete_message__management/1 deletes the message__management" do
      message__management = message__management_fixture()

      assert {:ok, %Message_Management{}} =
               Maintenance.delete_message__management(message__management)

      assert_raise Ecto.NoResultsError, fn ->
        Maintenance.get_message__management!(message__management.id)
      end
    end

    test "change_message__management/1 returns a message__management changeset" do
      message__management = message__management_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_message__management(message__management)
    end
  end

  describe "tbl_company_maintanence" do
    alias Loanmanagementsystem.Maintenance.Company_maintenance

    @valid_attrs %{
      address: "some address",
      company_logo: "some company_logo",
      company_name: "some company_name",
      company_reg_no: "some company_reg_no",
      country: "some country",
      currency: "some currency",
      phone_no: "some phone_no",
      town: "some town",
      tpin: "some tpin"
    }
    @update_attrs %{
      address: "some updated address",
      company_logo: "some updated company_logo",
      company_name: "some updated company_name",
      company_reg_no: "some updated company_reg_no",
      country: "some updated country",
      currency: "some updated currency",
      phone_no: "some updated phone_no",
      town: "some updated town",
      tpin: "some updated tpin"
    }
    @invalid_attrs %{
      address: nil,
      company_logo: nil,
      company_name: nil,
      company_reg_no: nil,
      country: nil,
      currency: nil,
      phone_no: nil,
      town: nil,
      tpin: nil
    }

    def company_maintenance_fixture(attrs \\ %{}) do
      {:ok, company_maintenance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_company_maintenance()

      company_maintenance
    end

    test "list_tbl_company_maintanence/0 returns all tbl_company_maintanence" do
      company_maintenance = company_maintenance_fixture()
      assert Maintenance.list_tbl_company_maintanence() == [company_maintenance]
    end

    test "get_company_maintenance!/1 returns the company_maintenance with given id" do
      company_maintenance = company_maintenance_fixture()
      assert Maintenance.get_company_maintenance!(company_maintenance.id) == company_maintenance
    end

    test "create_company_maintenance/1 with valid data creates a company_maintenance" do
      assert {:ok, %Company_maintenance{} = company_maintenance} =
               Maintenance.create_company_maintenance(@valid_attrs)

      assert company_maintenance.address == "some address"
      assert company_maintenance.company_logo == "some company_logo"
      assert company_maintenance.company_name == "some company_name"
      assert company_maintenance.company_reg_no == "some company_reg_no"
      assert company_maintenance.country == "some country"
      assert company_maintenance.currency == "some currency"
      assert company_maintenance.phone_no == "some phone_no"
      assert company_maintenance.town == "some town"
      assert company_maintenance.tpin == "some tpin"
    end

    test "create_company_maintenance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_company_maintenance(@invalid_attrs)
    end

    test "update_company_maintenance/2 with valid data updates the company_maintenance" do
      company_maintenance = company_maintenance_fixture()

      assert {:ok, %Company_maintenance{} = company_maintenance} =
               Maintenance.update_company_maintenance(company_maintenance, @update_attrs)

      assert company_maintenance.address == "some updated address"
      assert company_maintenance.company_logo == "some updated company_logo"
      assert company_maintenance.company_name == "some updated company_name"
      assert company_maintenance.company_reg_no == "some updated company_reg_no"
      assert company_maintenance.country == "some updated country"
      assert company_maintenance.currency == "some updated currency"
      assert company_maintenance.phone_no == "some updated phone_no"
      assert company_maintenance.town == "some updated town"
      assert company_maintenance.tpin == "some updated tpin"
    end

    test "update_company_maintenance/2 with invalid data returns error changeset" do
      company_maintenance = company_maintenance_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maintenance.update_company_maintenance(company_maintenance, @invalid_attrs)

      assert company_maintenance == Maintenance.get_company_maintenance!(company_maintenance.id)
    end

    test "delete_company_maintenance/1 deletes the company_maintenance" do
      company_maintenance = company_maintenance_fixture()

      assert {:ok, %Company_maintenance{}} =
               Maintenance.delete_company_maintenance(company_maintenance)

      assert_raise Ecto.NoResultsError, fn ->
        Maintenance.get_company_maintenance!(company_maintenance.id)
      end
    end

    test "change_company_maintenance/1 returns a company_maintenance changeset" do
      company_maintenance = company_maintenance_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_company_maintenance(company_maintenance)
    end
  end

  describe "tbl_password_maintenance" do
    alias Loanmanagementsystem.Maintenance.Password_maintenance

    @valid_attrs %{
      max_length: "some max_length",
      min_length: "some min_length",
      password_format: "some password_format",
      user_id: 42
    }
    @update_attrs %{
      max_length: "some updated max_length",
      min_length: "some updated min_length",
      password_format: "some updated password_format",
      user_id: 43
    }
    @invalid_attrs %{max_length: nil, min_length: nil, password_format: nil, user_id: nil}

    def password_maintenance_fixture(attrs \\ %{}) do
      {:ok, password_maintenance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_password_maintenance()

      password_maintenance
    end

    test "list_tbl_password_maintenance/0 returns all tbl_password_maintenance" do
      password_maintenance = password_maintenance_fixture()
      assert Maintenance.list_tbl_password_maintenance() == [password_maintenance]
    end

    test "get_password_maintenance!/1 returns the password_maintenance with given id" do
      password_maintenance = password_maintenance_fixture()

      assert Maintenance.get_password_maintenance!(password_maintenance.id) ==
               password_maintenance
    end

    test "create_password_maintenance/1 with valid data creates a password_maintenance" do
      assert {:ok, %Password_maintenance{} = password_maintenance} =
               Maintenance.create_password_maintenance(@valid_attrs)

      assert password_maintenance.max_length == "some max_length"
      assert password_maintenance.min_length == "some min_length"
      assert password_maintenance.password_format == "some password_format"
      assert password_maintenance.user_id == 42
    end

    test "create_password_maintenance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_password_maintenance(@invalid_attrs)
    end

    test "update_password_maintenance/2 with valid data updates the password_maintenance" do
      password_maintenance = password_maintenance_fixture()

      assert {:ok, %Password_maintenance{} = password_maintenance} =
               Maintenance.update_password_maintenance(password_maintenance, @update_attrs)

      assert password_maintenance.max_length == "some updated max_length"
      assert password_maintenance.min_length == "some updated min_length"
      assert password_maintenance.password_format == "some updated password_format"
      assert password_maintenance.user_id == 43
    end

    test "update_password_maintenance/2 with invalid data returns error changeset" do
      password_maintenance = password_maintenance_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maintenance.update_password_maintenance(password_maintenance, @invalid_attrs)

      assert password_maintenance ==
               Maintenance.get_password_maintenance!(password_maintenance.id)
    end

    test "delete_password_maintenance/1 deletes the password_maintenance" do
      password_maintenance = password_maintenance_fixture()

      assert {:ok, %Password_maintenance{}} =
               Maintenance.delete_password_maintenance(password_maintenance)

      assert_raise Ecto.NoResultsError, fn ->
        Maintenance.get_password_maintenance!(password_maintenance.id)
      end
    end

    test "change_password_maintenance/1 returns a password_maintenance changeset" do
      password_maintenance = password_maintenance_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_password_maintenance(password_maintenance)
    end
  end

  describe "tbl_workingdays_maintenance" do
    alias Loanmanagementsystem.Maintenance.Working_days

    @valid_attrs %{
      friday: "some friday",
      monday: "some monday",
      saturday: "some saturday",
      sunday: "some sunday",
      thursday: "some thursday",
      tuesday: "some tuesday",
      wednesday: "some wednesday"
    }
    @update_attrs %{
      friday: "some updated friday",
      monday: "some updated monday",
      saturday: "some updated saturday",
      sunday: "some updated sunday",
      thursday: "some updated thursday",
      tuesday: "some updated tuesday",
      wednesday: "some updated wednesday"
    }
    @invalid_attrs %{
      friday: nil,
      monday: nil,
      saturday: nil,
      sunday: nil,
      thursday: nil,
      tuesday: nil,
      wednesday: nil
    }

    def working_days_fixture(attrs \\ %{}) do
      {:ok, working_days} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_working_days()

      working_days
    end

    test "list_tbl_workingdays_maintenance/0 returns all tbl_workingdays_maintenance" do
      working_days = working_days_fixture()
      assert Maintenance.list_tbl_workingdays_maintenance() == [working_days]
    end

    test "get_working_days!/1 returns the working_days with given id" do
      working_days = working_days_fixture()
      assert Maintenance.get_working_days!(working_days.id) == working_days
    end

    test "create_working_days/1 with valid data creates a working_days" do
      assert {:ok, %Working_days{} = working_days} = Maintenance.create_working_days(@valid_attrs)
      assert working_days.friday == "some friday"
      assert working_days.monday == "some monday"
      assert working_days.saturday == "some saturday"
      assert working_days.sunday == "some sunday"
      assert working_days.thursday == "some thursday"
      assert working_days.tuesday == "some tuesday"
      assert working_days.wednesday == "some wednesday"
    end

    test "create_working_days/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_working_days(@invalid_attrs)
    end

    test "update_working_days/2 with valid data updates the working_days" do
      working_days = working_days_fixture()

      assert {:ok, %Working_days{} = working_days} =
               Maintenance.update_working_days(working_days, @update_attrs)

      assert working_days.friday == "some updated friday"
      assert working_days.monday == "some updated monday"
      assert working_days.saturday == "some updated saturday"
      assert working_days.sunday == "some updated sunday"
      assert working_days.thursday == "some updated thursday"
      assert working_days.tuesday == "some updated tuesday"
      assert working_days.wednesday == "some updated wednesday"
    end

    test "update_working_days/2 with invalid data returns error changeset" do
      working_days = working_days_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maintenance.update_working_days(working_days, @invalid_attrs)

      assert working_days == Maintenance.get_working_days!(working_days.id)
    end

    test "delete_working_days/1 deletes the working_days" do
      working_days = working_days_fixture()
      assert {:ok, %Working_days{}} = Maintenance.delete_working_days(working_days)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_working_days!(working_days.id) end
    end

    test "change_working_days/1 returns a working_days changeset" do
      working_days = working_days_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_working_days(working_days)
    end
  end

  describe "tbl_holiday_maintenance" do
    alias Loanmanagementsystem.Maintenance.Holiday_mgt

    @valid_attrs %{
      holiday_date: ~D[2010-04-17],
      holiday_description: "some holiday_description",
      month: "some month",
      year: "some year"
    }
    @update_attrs %{
      holiday_date: ~D[2011-05-18],
      holiday_description: "some updated holiday_description",
      month: "some updated month",
      year: "some updated year"
    }
    @invalid_attrs %{holiday_date: nil, holiday_description: nil, month: nil, year: nil}

    def holiday_mgt_fixture(attrs \\ %{}) do
      {:ok, holiday_mgt} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_holiday_mgt()

      holiday_mgt
    end

    test "list_tbl_holiday_maintenance/0 returns all tbl_holiday_maintenance" do
      holiday_mgt = holiday_mgt_fixture()
      assert Maintenance.list_tbl_holiday_maintenance() == [holiday_mgt]
    end

    test "get_holiday_mgt!/1 returns the holiday_mgt with given id" do
      holiday_mgt = holiday_mgt_fixture()
      assert Maintenance.get_holiday_mgt!(holiday_mgt.id) == holiday_mgt
    end

    test "create_holiday_mgt/1 with valid data creates a holiday_mgt" do
      assert {:ok, %Holiday_mgt{} = holiday_mgt} = Maintenance.create_holiday_mgt(@valid_attrs)
      assert holiday_mgt.holiday_date == ~D[2010-04-17]
      assert holiday_mgt.holiday_description == "some holiday_description"
      assert holiday_mgt.month == "some month"
      assert holiday_mgt.year == "some year"
    end

    test "create_holiday_mgt/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_holiday_mgt(@invalid_attrs)
    end

    test "update_holiday_mgt/2 with valid data updates the holiday_mgt" do
      holiday_mgt = holiday_mgt_fixture()

      assert {:ok, %Holiday_mgt{} = holiday_mgt} =
               Maintenance.update_holiday_mgt(holiday_mgt, @update_attrs)

      assert holiday_mgt.holiday_date == ~D[2011-05-18]
      assert holiday_mgt.holiday_description == "some updated holiday_description"
      assert holiday_mgt.month == "some updated month"
      assert holiday_mgt.year == "some updated year"
    end

    test "update_holiday_mgt/2 with invalid data returns error changeset" do
      holiday_mgt = holiday_mgt_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maintenance.update_holiday_mgt(holiday_mgt, @invalid_attrs)

      assert holiday_mgt == Maintenance.get_holiday_mgt!(holiday_mgt.id)
    end

    test "delete_holiday_mgt/1 deletes the holiday_mgt" do
      holiday_mgt = holiday_mgt_fixture()
      assert {:ok, %Holiday_mgt{}} = Maintenance.delete_holiday_mgt(holiday_mgt)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_holiday_mgt!(holiday_mgt.id) end
    end

    test "change_holiday_mgt/1 returns a holiday_mgt changeset" do
      holiday_mgt = holiday_mgt_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_holiday_mgt(holiday_mgt)
    end
  end

  describe "tbl_maker_checker" do
    alias Loanmanagementsystem.Maintenance.Maker_checker

    @valid_attrs %{
      checker: "some checker",
      maker: "some maker",
      module: "some module",
      module_code: "some module_code"
    }
    @update_attrs %{
      checker: "some updated checker",
      maker: "some updated maker",
      module: "some updated module",
      module_code: "some updated module_code"
    }
    @invalid_attrs %{checker: nil, maker: nil, module: nil, module_code: nil}

    def maker_checker_fixture(attrs \\ %{}) do
      {:ok, maker_checker} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_maker_checker()

      maker_checker
    end

    test "list_tbl_maker_checker/0 returns all tbl_maker_checker" do
      maker_checker = maker_checker_fixture()
      assert Maintenance.list_tbl_maker_checker() == [maker_checker]
    end

    test "get_maker_checker!/1 returns the maker_checker with given id" do
      maker_checker = maker_checker_fixture()
      assert Maintenance.get_maker_checker!(maker_checker.id) == maker_checker
    end

    test "create_maker_checker/1 with valid data creates a maker_checker" do
      assert {:ok, %Maker_checker{} = maker_checker} =
               Maintenance.create_maker_checker(@valid_attrs)

      assert maker_checker.checker == "some checker"
      assert maker_checker.maker == "some maker"
      assert maker_checker.module == "some module"
      assert maker_checker.module_code == "some module_code"
    end

    test "create_maker_checker/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_maker_checker(@invalid_attrs)
    end

    test "update_maker_checker/2 with valid data updates the maker_checker" do
      maker_checker = maker_checker_fixture()

      assert {:ok, %Maker_checker{} = maker_checker} =
               Maintenance.update_maker_checker(maker_checker, @update_attrs)

      assert maker_checker.checker == "some updated checker"
      assert maker_checker.maker == "some updated maker"
      assert maker_checker.module == "some updated module"
      assert maker_checker.module_code == "some updated module_code"
    end

    test "update_maker_checker/2 with invalid data returns error changeset" do
      maker_checker = maker_checker_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maintenance.update_maker_checker(maker_checker, @invalid_attrs)

      assert maker_checker == Maintenance.get_maker_checker!(maker_checker.id)
    end

    test "delete_maker_checker/1 deletes the maker_checker" do
      maker_checker = maker_checker_fixture()
      assert {:ok, %Maker_checker{}} = Maintenance.delete_maker_checker(maker_checker)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_maker_checker!(maker_checker.id) end
    end

    test "change_maker_checker/1 returns a maker_checker changeset" do
      maker_checker = maker_checker_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_maker_checker(maker_checker)
    end
  end

  describe "tbl_alert_maintenance" do
    alias Loanmanagementsystem.Maintenance.Alert_Maintenance

    @valid_attrs %{
      alert_description: "some alert_description",
      alert_type: "some alert_type",
      message: "some message",
      status: "some status"
    }
    @update_attrs %{
      alert_description: "some updated alert_description",
      alert_type: "some updated alert_type",
      message: "some updated message",
      status: "some updated status"
    }
    @invalid_attrs %{alert_description: nil, alert_type: nil, message: nil, status: nil}

    def alert__maintenance_fixture(attrs \\ %{}) do
      {:ok, alert__maintenance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_alert__maintenance()

      alert__maintenance
    end

    test "list_tbl_alert_maintenance/0 returns all tbl_alert_maintenance" do
      alert__maintenance = alert__maintenance_fixture()
      assert Maintenance.list_tbl_alert_maintenance() == [alert__maintenance]
    end

    test "get_alert__maintenance!/1 returns the alert__maintenance with given id" do
      alert__maintenance = alert__maintenance_fixture()
      assert Maintenance.get_alert__maintenance!(alert__maintenance.id) == alert__maintenance
    end

    test "create_alert__maintenance/1 with valid data creates a alert__maintenance" do
      assert {:ok, %Alert_Maintenance{} = alert__maintenance} =
               Maintenance.create_alert__maintenance(@valid_attrs)

      assert alert__maintenance.alert_description == "some alert_description"
      assert alert__maintenance.alert_type == "some alert_type"
      assert alert__maintenance.message == "some message"
      assert alert__maintenance.status == "some status"
    end

    test "create_alert__maintenance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_alert__maintenance(@invalid_attrs)
    end

    test "update_alert__maintenance/2 with valid data updates the alert__maintenance" do
      alert__maintenance = alert__maintenance_fixture()

      assert {:ok, %Alert_Maintenance{} = alert__maintenance} =
               Maintenance.update_alert__maintenance(alert__maintenance, @update_attrs)

      assert alert__maintenance.alert_description == "some updated alert_description"
      assert alert__maintenance.alert_type == "some updated alert_type"
      assert alert__maintenance.message == "some updated message"
      assert alert__maintenance.status == "some updated status"
    end

    test "update_alert__maintenance/2 with invalid data returns error changeset" do
      alert__maintenance = alert__maintenance_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maintenance.update_alert__maintenance(alert__maintenance, @invalid_attrs)

      assert alert__maintenance == Maintenance.get_alert__maintenance!(alert__maintenance.id)
    end

    test "delete_alert__maintenance/1 deletes the alert__maintenance" do
      alert__maintenance = alert__maintenance_fixture()

      assert {:ok, %Alert_Maintenance{}} =
               Maintenance.delete_alert__maintenance(alert__maintenance)

      assert_raise Ecto.NoResultsError, fn ->
        Maintenance.get_alert__maintenance!(alert__maintenance.id)
      end
    end

    test "change_alert__maintenance/1 returns a alert__maintenance changeset" do
      alert__maintenance = alert__maintenance_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_alert__maintenance(alert__maintenance)
    end
  end

  describe "tbl_qfin_branches" do
    alias Loanmanagementsystem.Maintenance.Qfin_Brance_maintenance

    @valid_attrs %{
      branchAddress: "some branchAddress",
      branchCode: "some branchCode",
      city: "some city",
      name: "some name",
      province: "some province",
      status: "some status"
    }
    @update_attrs %{
      branchAddress: "some updated branchAddress",
      branchCode: "some updated branchCode",
      city: "some updated city",
      name: "some updated name",
      province: "some updated province",
      status: "some updated status"
    }
    @invalid_attrs %{
      branchAddress: nil,
      branchCode: nil,
      city: nil,
      name: nil,
      province: nil,
      status: nil
    }

    def qfin__brance_maintenance_fixture(attrs \\ %{}) do
      {:ok, qfin__brance_maintenance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Maintenance.create_qfin__brance_maintenance()

      qfin__brance_maintenance
    end

    test "list_tbl_qfin_branches/0 returns all tbl_qfin_branches" do
      qfin__brance_maintenance = qfin__brance_maintenance_fixture()
      assert Maintenance.list_tbl_qfin_branches() == [qfin__brance_maintenance]
    end

    test "get_qfin__brance_maintenance!/1 returns the qfin__brance_maintenance with given id" do
      qfin__brance_maintenance = qfin__brance_maintenance_fixture()

      assert Maintenance.get_qfin__brance_maintenance!(qfin__brance_maintenance.id) ==
               qfin__brance_maintenance
    end

    test "create_qfin__brance_maintenance/1 with valid data creates a qfin__brance_maintenance" do
      assert {:ok, %Qfin_Brance_maintenance{} = qfin__brance_maintenance} =
               Maintenance.create_qfin__brance_maintenance(@valid_attrs)

      assert qfin__brance_maintenance.branchAddress == "some branchAddress"
      assert qfin__brance_maintenance.branchCode == "some branchCode"
      assert qfin__brance_maintenance.city == "some city"
      assert qfin__brance_maintenance.name == "some name"
      assert qfin__brance_maintenance.province == "some province"
      assert qfin__brance_maintenance.status == "some status"
    end

    test "create_qfin__brance_maintenance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} =
               Maintenance.create_qfin__brance_maintenance(@invalid_attrs)
    end

    test "update_qfin__brance_maintenance/2 with valid data updates the qfin__brance_maintenance" do
      qfin__brance_maintenance = qfin__brance_maintenance_fixture()

      assert {:ok, %Qfin_Brance_maintenance{} = qfin__brance_maintenance} =
               Maintenance.update_qfin__brance_maintenance(
                 qfin__brance_maintenance,
                 @update_attrs
               )

      assert qfin__brance_maintenance.branchAddress == "some updated branchAddress"
      assert qfin__brance_maintenance.branchCode == "some updated branchCode"
      assert qfin__brance_maintenance.city == "some updated city"
      assert qfin__brance_maintenance.name == "some updated name"
      assert qfin__brance_maintenance.province == "some updated province"
      assert qfin__brance_maintenance.status == "some updated status"
    end

    test "update_qfin__brance_maintenance/2 with invalid data returns error changeset" do
      qfin__brance_maintenance = qfin__brance_maintenance_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Maintenance.update_qfin__brance_maintenance(
                 qfin__brance_maintenance,
                 @invalid_attrs
               )

      assert qfin__brance_maintenance ==
               Maintenance.get_qfin__brance_maintenance!(qfin__brance_maintenance.id)
    end

    test "delete_qfin__brance_maintenance/1 deletes the qfin__brance_maintenance" do
      qfin__brance_maintenance = qfin__brance_maintenance_fixture()

      assert {:ok, %Qfin_Brance_maintenance{}} =
               Maintenance.delete_qfin__brance_maintenance(qfin__brance_maintenance)

      assert_raise Ecto.NoResultsError, fn ->
        Maintenance.get_qfin__brance_maintenance!(qfin__brance_maintenance.id)
      end
    end

    test "change_qfin__brance_maintenance/1 returns a qfin__brance_maintenance changeset" do
      qfin__brance_maintenance = qfin__brance_maintenance_fixture()

      assert %Ecto.Changeset{} =
               Maintenance.change_qfin__brance_maintenance(qfin__brance_maintenance)
    end
  end
end
