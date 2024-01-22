defmodule LoanSavingsSystem.FlexCubeConfigTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.FlexCubeConfig

  describe "flexcubeconfigs" do
    alias LoanSavingsSystem.FlexCubeConfig.FlexCubeConfigs

    @valid_attrs %{action_type: "some action_type", dr_cr: "some dr_cr", flex_cube_gl_code: "some flex_cube_gl_code", flex_cube_gl_id: 42, flex_cube_gl_name: "some flex_cube_gl_name"}
    @update_attrs %{action_type: "some updated action_type", dr_cr: "some updated dr_cr", flex_cube_gl_code: "some updated flex_cube_gl_code", flex_cube_gl_id: 43, flex_cube_gl_name: "some updated flex_cube_gl_name"}
    @invalid_attrs %{action_type: nil, dr_cr: nil, flex_cube_gl_code: nil, flex_cube_gl_id: nil, flex_cube_gl_name: nil}

    def flex_cube_configs_fixture(attrs \\ %{}) do
      {:ok, flex_cube_configs} =
        attrs
        |> Enum.into(@valid_attrs)
        |> FlexCubeConfig.create_flex_cube_configs()

      flex_cube_configs
    end

    test "list_flexcubeconfigs/0 returns all flexcubeconfigs" do
      flex_cube_configs = flex_cube_configs_fixture()
      assert FlexCubeConfig.list_flexcubeconfigs() == [flex_cube_configs]
    end

    test "get_flex_cube_configs!/1 returns the flex_cube_configs with given id" do
      flex_cube_configs = flex_cube_configs_fixture()
      assert FlexCubeConfig.get_flex_cube_configs!(flex_cube_configs.id) == flex_cube_configs
    end

    test "create_flex_cube_configs/1 with valid data creates a flex_cube_configs" do
      assert {:ok, %FlexCubeConfigs{} = flex_cube_configs} = FlexCubeConfig.create_flex_cube_configs(@valid_attrs)
      assert flex_cube_configs.action_type == "some action_type"
      assert flex_cube_configs.dr_cr == "some dr_cr"
      assert flex_cube_configs.flex_cube_gl_code == "some flex_cube_gl_code"
      assert flex_cube_configs.flex_cube_gl_id == 42
      assert flex_cube_configs.flex_cube_gl_name == "some flex_cube_gl_name"
    end

    test "create_flex_cube_configs/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = FlexCubeConfig.create_flex_cube_configs(@invalid_attrs)
    end

    test "update_flex_cube_configs/2 with valid data updates the flex_cube_configs" do
      flex_cube_configs = flex_cube_configs_fixture()
      assert {:ok, %FlexCubeConfigs{} = flex_cube_configs} = FlexCubeConfig.update_flex_cube_configs(flex_cube_configs, @update_attrs)
      assert flex_cube_configs.action_type == "some updated action_type"
      assert flex_cube_configs.dr_cr == "some updated dr_cr"
      assert flex_cube_configs.flex_cube_gl_code == "some updated flex_cube_gl_code"
      assert flex_cube_configs.flex_cube_gl_id == 43
      assert flex_cube_configs.flex_cube_gl_name == "some updated flex_cube_gl_name"
    end

    test "update_flex_cube_configs/2 with invalid data returns error changeset" do
      flex_cube_configs = flex_cube_configs_fixture()
      assert {:error, %Ecto.Changeset{}} = FlexCubeConfig.update_flex_cube_configs(flex_cube_configs, @invalid_attrs)
      assert flex_cube_configs == FlexCubeConfig.get_flex_cube_configs!(flex_cube_configs.id)
    end

    test "delete_flex_cube_configs/1 deletes the flex_cube_configs" do
      flex_cube_configs = flex_cube_configs_fixture()
      assert {:ok, %FlexCubeConfigs{}} = FlexCubeConfig.delete_flex_cube_configs(flex_cube_configs)
      assert_raise Ecto.NoResultsError, fn -> FlexCubeConfig.get_flex_cube_configs!(flex_cube_configs.id) end
    end

    test "change_flex_cube_configs/1 returns a flex_cube_configs changeset" do
      flex_cube_configs = flex_cube_configs_fixture()
      assert %Ecto.Changeset{} = FlexCubeConfig.change_flex_cube_configs(flex_cube_configs)
    end
  end
end
