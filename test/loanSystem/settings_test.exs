defmodule LoanSystem.SettingsTest do
  use LoanSystem.DataCase

  alias LoanSystem.Settings

  describe "tbl_system_params" do
    alias LoanSystem.Settings.SystemParams

    @valid_attrs %{code: "some code", name: "some name", password: "some password", url: "some url", username: "some username"}
    @update_attrs %{code: "some updated code", name: "some updated name", password: "some updated password", url: "some updated url", username: "some updated username"}
    @invalid_attrs %{code: nil, name: nil, password: nil, url: nil, username: nil}

    def system_params_fixture(attrs \\ %{}) do
      {:ok, system_params} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_system_params()

      system_params
    end

    test "list_tbl_system_params/0 returns all tbl_system_params" do
      system_params = system_params_fixture()
      assert Settings.list_tbl_system_params() == [system_params]
    end

    test "get_system_params!/1 returns the system_params with given id" do
      system_params = system_params_fixture()
      assert Settings.get_system_params!(system_params.id) == system_params
    end

    test "create_system_params/1 with valid data creates a system_params" do
      assert {:ok, %SystemParams{} = system_params} = Settings.create_system_params(@valid_attrs)
      assert system_params.code == "some code"
      assert system_params.name == "some name"
      assert system_params.password == "some password"
      assert system_params.url == "some url"
      assert system_params.username == "some username"
    end

    test "create_system_params/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_system_params(@invalid_attrs)
    end

    test "update_system_params/2 with valid data updates the system_params" do
      system_params = system_params_fixture()
      assert {:ok, %SystemParams{} = system_params} = Settings.update_system_params(system_params, @update_attrs)
      assert system_params.code == "some updated code"
      assert system_params.name == "some updated name"
      assert system_params.password == "some updated password"
      assert system_params.url == "some updated url"
      assert system_params.username == "some updated username"
    end

    test "update_system_params/2 with invalid data returns error changeset" do
      system_params = system_params_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_system_params(system_params, @invalid_attrs)
      assert system_params == Settings.get_system_params!(system_params.id)
    end

    test "delete_system_params/1 deletes the system_params" do
      system_params = system_params_fixture()
      assert {:ok, %SystemParams{}} = Settings.delete_system_params(system_params)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_system_params!(system_params.id) end
    end

    test "change_system_params/1 returns a system_params changeset" do
      system_params = system_params_fixture()
      assert %Ecto.Changeset{} = Settings.change_system_params(system_params)
    end
  end

  describe "tbl_banks" do
    alias LoanSystem.Settings.Bank

    @valid_attrs %{code: "some code", name: "some name", password: "some password", url: "some url", username: "some username"}
    @update_attrs %{code: "some updated code", name: "some updated name", password: "some updated password", url: "some updated url", username: "some updated username"}
    @invalid_attrs %{code: nil, name: nil, password: nil, url: nil, username: nil}

    def bank_fixture(attrs \\ %{}) do
      {:ok, bank} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_bank()

      bank
    end

    test "list_tbl_banks/0 returns all tbl_banks" do
      bank = bank_fixture()
      assert Settings.list_tbl_banks() == [bank]
    end

    test "get_bank!/1 returns the bank with given id" do
      bank = bank_fixture()
      assert Settings.get_bank!(bank.id) == bank
    end

    test "create_bank/1 with valid data creates a bank" do
      assert {:ok, %Bank{} = bank} = Settings.create_bank(@valid_attrs)
      assert bank.code == "some code"
      assert bank.name == "some name"
      assert bank.password == "some password"
      assert bank.url == "some url"
      assert bank.username == "some username"
    end

    test "create_bank/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_bank(@invalid_attrs)
    end

    test "update_bank/2 with valid data updates the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{} = bank} = Settings.update_bank(bank, @update_attrs)
      assert bank.code == "some updated code"
      assert bank.name == "some updated name"
      assert bank.password == "some updated password"
      assert bank.url == "some updated url"
      assert bank.username == "some updated username"
    end

    test "update_bank/2 with invalid data returns error changeset" do
      bank = bank_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_bank(bank, @invalid_attrs)
      assert bank == Settings.get_bank!(bank.id)
    end

    test "delete_bank/1 deletes the bank" do
      bank = bank_fixture()
      assert {:ok, %Bank{}} = Settings.delete_bank(bank)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_bank!(bank.id) end
    end

    test "change_bank/1 returns a bank changeset" do
      bank = bank_fixture()
      assert %Ecto.Changeset{} = Settings.change_bank(bank)
    end
  end

  describe "tbl_mnos" do
    alias LoanSystem.Settings.Mno

    @valid_attrs %{code: "some code", name: "some name", password: "some password", url: "some url", username: "some username"}
    @update_attrs %{code: "some updated code", name: "some updated name", password: "some updated password", url: "some updated url", username: "some updated username"}
    @invalid_attrs %{code: nil, name: nil, password: nil, url: nil, username: nil}

    def mno_fixture(attrs \\ %{}) do
      {:ok, mno} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_mno()

      mno
    end

    test "list_tbl_mnos/0 returns all tbl_mnos" do
      mno = mno_fixture()
      assert Settings.list_tbl_mnos() == [mno]
    end

    test "get_mno!/1 returns the mno with given id" do
      mno = mno_fixture()
      assert Settings.get_mno!(mno.id) == mno
    end

    test "create_mno/1 with valid data creates a mno" do
      assert {:ok, %Mno{} = mno} = Settings.create_mno(@valid_attrs)
      assert mno.code == "some code"
      assert mno.name == "some name"
      assert mno.password == "some password"
      assert mno.url == "some url"
      assert mno.username == "some username"
    end

    test "create_mno/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_mno(@invalid_attrs)
    end

    test "update_mno/2 with valid data updates the mno" do
      mno = mno_fixture()
      assert {:ok, %Mno{} = mno} = Settings.update_mno(mno, @update_attrs)
      assert mno.code == "some updated code"
      assert mno.name == "some updated name"
      assert mno.password == "some updated password"
      assert mno.url == "some updated url"
      assert mno.username == "some updated username"
    end

    test "update_mno/2 with invalid data returns error changeset" do
      mno = mno_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_mno(mno, @invalid_attrs)
      assert mno == Settings.get_mno!(mno.id)
    end

    test "delete_mno/1 deletes the mno" do
      mno = mno_fixture()
      assert {:ok, %Mno{}} = Settings.delete_mno(mno)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_mno!(mno.id) end
    end

    test "change_mno/1 returns a mno changeset" do
      mno = mno_fixture()
      assert %Ecto.Changeset{} = Settings.change_mno(mno)
    end
  end

  describe "tbl_system_params" do
    alias LoanSystem.Settings.SystemParams

    @valid_attrs %{code: "some code", company_description: "some company_description", company_logo: "some company_logo", company_name: "some company_name"}
    @update_attrs %{code: "some updated code", company_description: "some updated company_description", company_logo: "some updated company_logo", company_name: "some updated company_name"}
    @invalid_attrs %{code: nil, company_description: nil, company_logo: nil, company_name: nil}

    def system_params_fixture(attrs \\ %{}) do
      {:ok, system_params} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Settings.create_system_params()

      system_params
    end

    test "list_tbl_system_params/0 returns all tbl_system_params" do
      system_params = system_params_fixture()
      assert Settings.list_tbl_system_params() == [system_params]
    end

    test "get_system_params!/1 returns the system_params with given id" do
      system_params = system_params_fixture()
      assert Settings.get_system_params!(system_params.id) == system_params
    end

    test "create_system_params/1 with valid data creates a system_params" do
      assert {:ok, %SystemParams{} = system_params} = Settings.create_system_params(@valid_attrs)
      assert system_params.code == "some code"
      assert system_params.company_description == "some company_description"
      assert system_params.company_logo == "some company_logo"
      assert system_params.company_name == "some company_name"
    end

    test "create_system_params/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Settings.create_system_params(@invalid_attrs)
    end

    test "update_system_params/2 with valid data updates the system_params" do
      system_params = system_params_fixture()
      assert {:ok, %SystemParams{} = system_params} = Settings.update_system_params(system_params, @update_attrs)
      assert system_params.code == "some updated code"
      assert system_params.company_description == "some updated company_description"
      assert system_params.company_logo == "some updated company_logo"
      assert system_params.company_name == "some updated company_name"
    end

    test "update_system_params/2 with invalid data returns error changeset" do
      system_params = system_params_fixture()
      assert {:error, %Ecto.Changeset{}} = Settings.update_system_params(system_params, @invalid_attrs)
      assert system_params == Settings.get_system_params!(system_params.id)
    end

    test "delete_system_params/1 deletes the system_params" do
      system_params = system_params_fixture()
      assert {:ok, %SystemParams{}} = Settings.delete_system_params(system_params)
      assert_raise Ecto.NoResultsError, fn -> Settings.get_system_params!(system_params.id) end
    end

    test "change_system_params/1 returns a system_params changeset" do
      system_params = system_params_fixture()
      assert %Ecto.Changeset{} = Settings.change_system_params(system_params)
    end
  end
end
