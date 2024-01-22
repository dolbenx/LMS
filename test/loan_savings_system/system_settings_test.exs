defmodule LoanSavingsSystem.SystemSettingsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.SystemSettings

  describe "tbl_general_ledger_settings" do
    alias LoanSavingsSystem.SystemSettings.GeneralLedger

    @valid_attrs %{client_id: "some client_id", gl_account_name: "some gl_account_name", gl_code: "some gl_code", gl_type: "some gl_type"}
    @update_attrs %{client_id: "some updated client_id", gl_account_name: "some updated gl_account_name", gl_code: "some updated gl_code", gl_type: "some updated gl_type"}
    @invalid_attrs %{client_id: nil, gl_account_name: nil, gl_code: nil, gl_type: nil}

    def general_ledger_fixture(attrs \\ %{}) do
      {:ok, general_ledger} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSettings.create_general_ledger()

      general_ledger
    end

    test "list_tbl_general_ledger_settings/0 returns all tbl_general_ledger_settings" do
      general_ledger = general_ledger_fixture()
      assert SystemSettings.list_tbl_general_ledger_settings() == [general_ledger]
    end

    test "get_general_ledger!/1 returns the general_ledger with given id" do
      general_ledger = general_ledger_fixture()
      assert SystemSettings.get_general_ledger!(general_ledger.id) == general_ledger
    end

    test "create_general_ledger/1 with valid data creates a general_ledger" do
      assert {:ok, %GeneralLedger{} = general_ledger} = SystemSettings.create_general_ledger(@valid_attrs)
      assert general_ledger.client_id == "some client_id"
      assert general_ledger.gl_account_name == "some gl_account_name"
      assert general_ledger.gl_code == "some gl_code"
      assert general_ledger.gl_type == "some gl_type"
    end

    test "create_general_ledger/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSettings.create_general_ledger(@invalid_attrs)
    end

    test "update_general_ledger/2 with valid data updates the general_ledger" do
      general_ledger = general_ledger_fixture()
      assert {:ok, %GeneralLedger{} = general_ledger} = SystemSettings.update_general_ledger(general_ledger, @update_attrs)
      assert general_ledger.client_id == "some updated client_id"
      assert general_ledger.gl_account_name == "some updated gl_account_name"
      assert general_ledger.gl_code == "some updated gl_code"
      assert general_ledger.gl_type == "some updated gl_type"
    end

    test "update_general_ledger/2 with invalid data returns error changeset" do
      general_ledger = general_ledger_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSettings.update_general_ledger(general_ledger, @invalid_attrs)
      assert general_ledger == SystemSettings.get_general_ledger!(general_ledger.id)
    end

    test "delete_general_ledger/1 deletes the general_ledger" do
      general_ledger = general_ledger_fixture()
      assert {:ok, %GeneralLedger{}} = SystemSettings.delete_general_ledger(general_ledger)
      assert_raise Ecto.NoResultsError, fn -> SystemSettings.get_general_ledger!(general_ledger.id) end
    end

    test "change_general_ledger/1 returns a general_ledger changeset" do
      general_ledger = general_ledger_fixture()
      assert %Ecto.Changeset{} = SystemSettings.change_general_ledger(general_ledger)
    end
  end

  describe "tbl_bank_settings" do
    alias LoanSavingsSystem.SystemSettings.Bank

    @valid_attrs %{ac_balance_endpoint: "some ac_balance_endpoint", bank_code: "some bank_code", bank_description: "some bank_description", bank_name: "some bank_name", ft_end_point: "some ft_end_point"}
    @update_attrs %{ac_balance_endpoint: "some updated ac_balance_endpoint", bank_code: "some updated bank_code", bank_description: "some updated bank_description", bank_name: "some updated bank_name", ft_end_point: "some updated ft_end_point"}
    @invalid_attrs %{ac_balance_endpoint: nil, bank_code: nil, bank_description: nil, bank_name: nil, ft_end_point: nil}

    def bank_fixture(attrs \\ %{}) do
      {:ok, bank} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSettings.create_bank()

      bank
    end

    test "list_tbl_bank_settings/0 returns all tbl_bank_settings" do
      bank = bank_fixture()
      assert SystemSettings.list_tbl_bank_settings() == [bank]
    end

    test "get_bank!/1 returns the bank with given id" do
      bank = bank_fixture()
      assert SystemSettings.get_bank!(bank.id) == bank
    end

    test "create_bank/1 with valid data creates a bank" do
      assert {:ok, %Bank{} = bank} = SystemSettings.create_bank(@valid_attrs)
      assert bank.ac_balance_endpoint == "some ac_balance_endpoint"
      assert bank.bank_code == "some bank_code"
      assert bank.bank_description == "some bank_description"
      assert bank.bank_name == "some bank_name"
      assert bank.ft_end_point == "some ft_end_point"
    end

    test "create_bank/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSettings.create_bank(@invalid_attrs)
    end

    test "update_bank/2 with valid data updates the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{} = bank} = SystemSettings.update_bank(bank, @update_attrs)
      assert bank.ac_balance_endpoint == "some updated ac_balance_endpoint"
      assert bank.bank_code == "some updated bank_code"
      assert bank.bank_description == "some updated bank_description"
      assert bank.bank_name == "some updated bank_name"
      assert bank.ft_end_point == "some updated ft_end_point"
    end

    test "update_bank/2 with invalid data returns error changeset" do
      bank = bank_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSettings.update_bank(bank, @invalid_attrs)
      assert bank == SystemSettings.get_bank!(bank.id)
    end

    test "delete_bank/1 deletes the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{}} = SystemSettings.delete_bank(bank)
      assert_raise Ecto.NoResultsError, fn -> SystemSettings.get_bank!(bank.id) end
    end

    test "change_bank/1 returns a bank changeset" do
      bank = bank_fixture()
      assert %Ecto.Changeset{} = SystemSettings.change_bank(bank)
    end
  end

  describe "tbl_telco_settings" do
    alias LoanSavingsSystem.SystemSettings.Telco

    @valid_attrs %{country_code: "some country_code", country_name: "some country_name", telco_ip_whitelist: "some telco_ip_whitelist", telco_name: "some telco_name"}
    @update_attrs %{country_code: "some updated country_code", country_name: "some updated country_name", telco_ip_whitelist: "some updated telco_ip_whitelist", telco_name: "some updated telco_name"}
    @invalid_attrs %{country_code: nil, country_name: nil, telco_ip_whitelist: nil, telco_name: nil}

    def telco_fixture(attrs \\ %{}) do
      {:ok, telco} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSettings.create_telco()

      telco
    end

    test "list_tbl_telco_settings/0 returns all tbl_telco_settings" do
      telco = telco_fixture()
      assert SystemSettings.list_tbl_telco_settings() == [telco]
    end

    test "get_telco!/1 returns the telco with given id" do
      telco = telco_fixture()
      assert SystemSettings.get_telco!(telco.id) == telco
    end

    test "create_telco/1 with valid data creates a telco" do
      assert {:ok, %Telco{} = telco} = SystemSettings.create_telco(@valid_attrs)
      assert telco.country_code == "some country_code"
      assert telco.country_name == "some country_name"
      assert telco.telco_ip_whitelist == "some telco_ip_whitelist"
      assert telco.telco_name == "some telco_name"
    end

    test "create_telco/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSettings.create_telco(@invalid_attrs)
    end

    test "update_telco/2 with valid data updates the telco" do
      telco = telco_fixture()
      assert {:ok, %Telco{} = telco} = SystemSettings.update_telco(telco, @update_attrs)
      assert telco.country_code == "some updated country_code"
      assert telco.country_name == "some updated country_name"
      assert telco.telco_ip_whitelist == "some updated telco_ip_whitelist"
      assert telco.telco_name == "some updated telco_name"
    end

    test "update_telco/2 with invalid data returns error changeset" do
      telco = telco_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSettings.update_telco(telco, @invalid_attrs)
      assert telco == SystemSettings.get_telco!(telco.id)
    end

    test "delete_telco/1 deletes the telco" do
      telco = telco_fixture()
      assert {:ok, %Telco{}} = SystemSettings.delete_telco(telco)
      assert_raise Ecto.NoResultsError, fn -> SystemSettings.get_telco!(telco.id) end
    end

    test "change_telco/1 returns a telco changeset" do
      telco = telco_fixture()
      assert %Ecto.Changeset{} = SystemSettings.change_telco(telco)
    end
  end

  describe "tbl_telco_settings" do
    alias LoanSavingsSystem.SystemSettings.Telco

    @valid_attrs %{country_code: "some country_code", country_name: "some country_name", telco_ip_whitelist: "some telco_ip_whitelist", telco_name: "some telco_name"}
    @update_attrs %{country_code: "some updated country_code", country_name: "some updated country_name", telco_ip_whitelist: "some updated telco_ip_whitelist", telco_name: "some updated telco_name"}
    @invalid_attrs %{country_code: nil, country_name: nil, telco_ip_whitelist: nil, telco_name: nil}

    def telco_fixture(attrs \\ %{}) do
      {:ok, telco} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSettings.create_telco()

      telco
    end

    test "list_tbl_telco_settings/0 returns all tbl_telco_settings" do
      telco = telco_fixture()
      assert SystemSettings.list_tbl_telco_settings() == [telco]
    end

    test "get_telco!/1 returns the telco with given id" do
      telco = telco_fixture()
      assert SystemSettings.get_telco!(telco.id) == telco
    end

    test "create_telco/1 with valid data creates a telco" do
      assert {:ok, %Telco{} = telco} = SystemSettings.create_telco(@valid_attrs)
      assert telco.country_code == "some country_code"
      assert telco.country_name == "some country_name"
      assert telco.telco_ip_whitelist == "some telco_ip_whitelist"
      assert telco.telco_name == "some telco_name"
    end

    test "create_telco/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSettings.create_telco(@invalid_attrs)
    end

    test "update_telco/2 with valid data updates the telco" do
      telco = telco_fixture()
      assert {:ok, %Telco{} = telco} = SystemSettings.update_telco(telco, @update_attrs)
      assert telco.country_code == "some updated country_code"
      assert telco.country_name == "some updated country_name"
      assert telco.telco_ip_whitelist == "some updated telco_ip_whitelist"
      assert telco.telco_name == "some updated telco_name"
    end

    test "update_telco/2 with invalid data returns error changeset" do
      telco = telco_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSettings.update_telco(telco, @invalid_attrs)
      assert telco == SystemSettings.get_telco!(telco.id)
    end

    test "delete_telco/1 deletes the telco" do
      telco = telco_fixture()
      assert {:ok, %Telco{}} = SystemSettings.delete_telco(telco)
      assert_raise Ecto.NoResultsError, fn -> SystemSettings.get_telco!(telco.id) end
    end

    test "change_telco/1 returns a telco changeset" do
      telco = telco_fixture()
      assert %Ecto.Changeset{} = SystemSettings.change_telco(telco)
    end
  end

  describe "tbl_bank_settings" do
    alias LoanSavingsSystem.SystemSettings.Bank

    @valid_attrs %{ac_balance_endpoint: "some ac_balance_endpoint", bank_code: "some bank_code", bank_description: "some bank_description", bank_name: "some bank_name", ft_end_point: "some ft_end_point"}
    @update_attrs %{ac_balance_endpoint: "some updated ac_balance_endpoint", bank_code: "some updated bank_code", bank_description: "some updated bank_description", bank_name: "some updated bank_name", ft_end_point: "some updated ft_end_point"}
    @invalid_attrs %{ac_balance_endpoint: nil, bank_code: nil, bank_description: nil, bank_name: nil, ft_end_point: nil}

    def bank_fixture(attrs \\ %{}) do
      {:ok, bank} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSettings.create_bank()

      bank
    end

    test "list_tbl_bank_settings/0 returns all tbl_bank_settings" do
      bank = bank_fixture()
      assert SystemSettings.list_tbl_bank_settings() == [bank]
    end

    test "get_bank!/1 returns the bank with given id" do
      bank = bank_fixture()
      assert SystemSettings.get_bank!(bank.id) == bank
    end

    test "create_bank/1 with valid data creates a bank" do
      assert {:ok, %Bank{} = bank} = SystemSettings.create_bank(@valid_attrs)
      assert bank.ac_balance_endpoint == "some ac_balance_endpoint"
      assert bank.bank_code == "some bank_code"
      assert bank.bank_description == "some bank_description"
      assert bank.bank_name == "some bank_name"
      assert bank.ft_end_point == "some ft_end_point"
    end

    test "create_bank/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSettings.create_bank(@invalid_attrs)
    end

    test "update_bank/2 with valid data updates the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{} = bank} = SystemSettings.update_bank(bank, @update_attrs)
      assert bank.ac_balance_endpoint == "some updated ac_balance_endpoint"
      assert bank.bank_code == "some updated bank_code"
      assert bank.bank_description == "some updated bank_description"
      assert bank.bank_name == "some updated bank_name"
      assert bank.ft_end_point == "some updated ft_end_point"
    end

    test "update_bank/2 with invalid data returns error changeset" do
      bank = bank_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSettings.update_bank(bank, @invalid_attrs)
      assert bank == SystemSettings.get_bank!(bank.id)
    end

    test "delete_bank/1 deletes the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{}} = SystemSettings.delete_bank(bank)
      assert_raise Ecto.NoResultsError, fn -> SystemSettings.get_bank!(bank.id) end
    end

    test "change_bank/1 returns a bank changeset" do
      bank = bank_fixture()
      assert %Ecto.Changeset{} = SystemSettings.change_bank(bank)
    end
  end

  describe "tbl_general_ledger_settings" do
    alias LoanSavingsSystem.SystemSettings.GeneralLedger

    @valid_attrs %{client_id: "some client_id", gl_account_name: "some gl_account_name", gl_code: "some gl_code", gl_type: "some gl_type"}
    @update_attrs %{client_id: "some updated client_id", gl_account_name: "some updated gl_account_name", gl_code: "some updated gl_code", gl_type: "some updated gl_type"}
    @invalid_attrs %{client_id: nil, gl_account_name: nil, gl_code: nil, gl_type: nil}

    def general_ledger_fixture(attrs \\ %{}) do
      {:ok, general_ledger} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSettings.create_general_ledger()

      general_ledger
    end

    test "list_tbl_general_ledger_settings/0 returns all tbl_general_ledger_settings" do
      general_ledger = general_ledger_fixture()
      assert SystemSettings.list_tbl_general_ledger_settings() == [general_ledger]
    end

    test "get_general_ledger!/1 returns the general_ledger with given id" do
      general_ledger = general_ledger_fixture()
      assert SystemSettings.get_general_ledger!(general_ledger.id) == general_ledger
    end

    test "create_general_ledger/1 with valid data creates a general_ledger" do
      assert {:ok, %GeneralLedger{} = general_ledger} = SystemSettings.create_general_ledger(@valid_attrs)
      assert general_ledger.client_id == "some client_id"
      assert general_ledger.gl_account_name == "some gl_account_name"
      assert general_ledger.gl_code == "some gl_code"
      assert general_ledger.gl_type == "some gl_type"
    end

    test "create_general_ledger/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSettings.create_general_ledger(@invalid_attrs)
    end

    test "update_general_ledger/2 with valid data updates the general_ledger" do
      general_ledger = general_ledger_fixture()
      assert {:ok, %GeneralLedger{} = general_ledger} = SystemSettings.update_general_ledger(general_ledger, @update_attrs)
      assert general_ledger.client_id == "some updated client_id"
      assert general_ledger.gl_account_name == "some updated gl_account_name"
      assert general_ledger.gl_code == "some updated gl_code"
      assert general_ledger.gl_type == "some updated gl_type"
    end

    test "update_general_ledger/2 with invalid data returns error changeset" do
      general_ledger = general_ledger_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSettings.update_general_ledger(general_ledger, @invalid_attrs)
      assert general_ledger == SystemSettings.get_general_ledger!(general_ledger.id)
    end

    test "delete_general_ledger/1 deletes the general_ledger" do
      general_ledger = general_ledger_fixture()
      assert {:ok, %GeneralLedger{}} = SystemSettings.delete_general_ledger(general_ledger)
      assert_raise Ecto.NoResultsError, fn -> SystemSettings.get_general_ledger!(general_ledger.id) end
    end

    test "change_general_ledger/1 returns a general_ledger changeset" do
      general_ledger = general_ledger_fixture()
      assert %Ecto.Changeset{} = SystemSettings.change_general_ledger(general_ledger)
    end
  end

  describe "tbl_telco_settings" do
    alias LoanSavingsSystem.SystemSettings.Telco

    @valid_attrs %{country_code: "some country_code", country_name: "some country_name", telco_ip_whitelist: "some telco_ip_whitelist", telco_name: "some telco_name"}
    @update_attrs %{country_code: "some updated country_code", country_name: "some updated country_name", telco_ip_whitelist: "some updated telco_ip_whitelist", telco_name: "some updated telco_name"}
    @invalid_attrs %{country_code: nil, country_name: nil, telco_ip_whitelist: nil, telco_name: nil}

    def telco_fixture(attrs \\ %{}) do
      {:ok, telco} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSettings.create_telco()

      telco
    end

    test "list_tbl_telco_settings/0 returns all tbl_telco_settings" do
      telco = telco_fixture()
      assert SystemSettings.list_tbl_telco_settings() == [telco]
    end

    test "get_telco!/1 returns the telco with given id" do
      telco = telco_fixture()
      assert SystemSettings.get_telco!(telco.id) == telco
    end

    test "create_telco/1 with valid data creates a telco" do
      assert {:ok, %Telco{} = telco} = SystemSettings.create_telco(@valid_attrs)
      assert telco.country_code == "some country_code"
      assert telco.country_name == "some country_name"
      assert telco.telco_ip_whitelist == "some telco_ip_whitelist"
      assert telco.telco_name == "some telco_name"
    end

    test "create_telco/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSettings.create_telco(@invalid_attrs)
    end

    test "update_telco/2 with valid data updates the telco" do
      telco = telco_fixture()
      assert {:ok, %Telco{} = telco} = SystemSettings.update_telco(telco, @update_attrs)
      assert telco.country_code == "some updated country_code"
      assert telco.country_name == "some updated country_name"
      assert telco.telco_ip_whitelist == "some updated telco_ip_whitelist"
      assert telco.telco_name == "some updated telco_name"
    end

    test "update_telco/2 with invalid data returns error changeset" do
      telco = telco_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSettings.update_telco(telco, @invalid_attrs)
      assert telco == SystemSettings.get_telco!(telco.id)
    end

    test "delete_telco/1 deletes the telco" do
      telco = telco_fixture()
      assert {:ok, %Telco{}} = SystemSettings.delete_telco(telco)
      assert_raise Ecto.NoResultsError, fn -> SystemSettings.get_telco!(telco.id) end
    end

    test "change_telco/1 returns a telco changeset" do
      telco = telco_fixture()
      assert %Ecto.Changeset{} = SystemSettings.change_telco(telco)
    end
  end

  describe "tbl_bank_settings" do
    alias LoanSavingsSystem.SystemSettings.Bank

    @valid_attrs %{ac_balance_endpoint: "some ac_balance_endpoint", bank_code: "some bank_code", bank_description: "some bank_description", bank_name: "some bank_name", ft_end_point: "some ft_end_point"}
    @update_attrs %{ac_balance_endpoint: "some updated ac_balance_endpoint", bank_code: "some updated bank_code", bank_description: "some updated bank_description", bank_name: "some updated bank_name", ft_end_point: "some updated ft_end_point"}
    @invalid_attrs %{ac_balance_endpoint: nil, bank_code: nil, bank_description: nil, bank_name: nil, ft_end_point: nil}

    def bank_fixture(attrs \\ %{}) do
      {:ok, bank} =
        attrs
        |> Enum.into(@valid_attrs)
        |> SystemSettings.create_bank()

      bank
    end

    test "list_tbl_bank_settings/0 returns all tbl_bank_settings" do
      bank = bank_fixture()
      assert SystemSettings.list_tbl_bank_settings() == [bank]
    end

    test "get_bank!/1 returns the bank with given id" do
      bank = bank_fixture()
      assert SystemSettings.get_bank!(bank.id) == bank
    end

    test "create_bank/1 with valid data creates a bank" do
      assert {:ok, %Bank{} = bank} = SystemSettings.create_bank(@valid_attrs)
      assert bank.ac_balance_endpoint == "some ac_balance_endpoint"
      assert bank.bank_code == "some bank_code"
      assert bank.bank_description == "some bank_description"
      assert bank.bank_name == "some bank_name"
      assert bank.ft_end_point == "some ft_end_point"
    end

    test "create_bank/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = SystemSettings.create_bank(@invalid_attrs)
    end

    test "update_bank/2 with valid data updates the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{} = bank} = SystemSettings.update_bank(bank, @update_attrs)
      assert bank.ac_balance_endpoint == "some updated ac_balance_endpoint"
      assert bank.bank_code == "some updated bank_code"
      assert bank.bank_description == "some updated bank_description"
      assert bank.bank_name == "some updated bank_name"
      assert bank.ft_end_point == "some updated ft_end_point"
    end

    test "update_bank/2 with invalid data returns error changeset" do
      bank = bank_fixture()
      assert {:error, %Ecto.Changeset{}} = SystemSettings.update_bank(bank, @invalid_attrs)
      assert bank == SystemSettings.get_bank!(bank.id)
    end

    test "delete_bank/1 deletes the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{}} = SystemSettings.delete_bank(bank)
      assert_raise Ecto.NoResultsError, fn -> SystemSettings.get_bank!(bank.id) end
    end

    test "change_bank/1 returns a bank changeset" do
      bank = bank_fixture()
      assert %Ecto.Changeset{} = SystemSettings.change_bank(bank)
    end
  end
end
