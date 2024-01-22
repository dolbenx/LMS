defmodule LoanSavingsSystem.SettingsTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Settings

  describe "tbl_system_params" do
    alias LoanSavingsSystem.Settings.SystemParams

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

  describe "tbl_system_params" do
    alias LoanSavingsSystem.Settings.SystemParams

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
