defmodule Savings.MaintenanceTest do
  use Savings.DataCase

  alias Savings.Maintenance

  describe "tbl_branch" do
    alias Savings.Maintenance.Branch

    import Savings.MaintenanceFixtures

    @invalid_attrs %{branchCode: nil, branchName: nil, isDefaultUSSDBranch: nil, status: nil}

    test "list_tbl_branch/0 returns all tbl_branch" do
      branch = branch_fixture()
      assert Maintenance.list_tbl_branch() == [branch]
    end

    test "get_branch!/1 returns the branch with given id" do
      branch = branch_fixture()
      assert Maintenance.get_branch!(branch.id) == branch
    end

    test "create_branch/1 with valid data creates a branch" do
      valid_attrs = %{branchCode: "some branchCode", branchName: "some branchName", isDefaultUSSDBranch: true, status: "some status"}

      assert {:ok, %Branch{} = branch} = Maintenance.create_branch(valid_attrs)
      assert branch.branchCode == "some branchCode"
      assert branch.branchName == "some branchName"
      assert branch.isDefaultUSSDBranch == true
      assert branch.status == "some status"
    end

    test "create_branch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_branch(@invalid_attrs)
    end

    test "update_branch/2 with valid data updates the branch" do
      branch = branch_fixture()
      update_attrs = %{branchCode: "some updated branchCode", branchName: "some updated branchName", isDefaultUSSDBranch: false, status: "some updated status"}

      assert {:ok, %Branch{} = branch} = Maintenance.update_branch(branch, update_attrs)
      assert branch.branchCode == "some updated branchCode"
      assert branch.branchName == "some updated branchName"
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

  describe "tbl_charge" do
    alias Savings.Maintenance.Charge

    import Savings.MaintenanceFixtures

    @invalid_attrs %{chargeAmount: nil, chargeName: nil, chargeType: nil, currencyId: nil, status: nil}

    test "list_tbl_charge/0 returns all tbl_charge" do
      charge = charge_fixture()
      assert Maintenance.list_tbl_charge() == [charge]
    end

    test "get_charge!/1 returns the charge with given id" do
      charge = charge_fixture()
      assert Maintenance.get_charge!(charge.id) == charge
    end

    test "create_charge/1 with valid data creates a charge" do
      valid_attrs = %{chargeAmount: "120.5", chargeName: "some chargeName", chargeType: "some chargeType", currencyId: 42, status: "some status"}

      assert {:ok, %Charge{} = charge} = Maintenance.create_charge(valid_attrs)
      assert charge.chargeAmount == Decimal.new("120.5")
      assert charge.chargeName == "some chargeName"
      assert charge.chargeType == "some chargeType"
      assert charge.currencyId == 42
      assert charge.status == "some status"
    end

    test "create_charge/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Maintenance.create_charge(@invalid_attrs)
    end

    test "update_charge/2 with valid data updates the charge" do
      charge = charge_fixture()
      update_attrs = %{chargeAmount: "456.7", chargeName: "some updated chargeName", chargeType: "some updated chargeType", currencyId: 43, status: "some updated status"}

      assert {:ok, %Charge{} = charge} = Maintenance.update_charge(charge, update_attrs)
      assert charge.chargeAmount == Decimal.new("456.7")
      assert charge.chargeName == "some updated chargeName"
      assert charge.chargeType == "some updated chargeType"
      assert charge.currencyId == 43
      assert charge.status == "some updated status"
    end

    test "update_charge/2 with invalid data returns error changeset" do
      charge = charge_fixture()
      assert {:error, %Ecto.Changeset{}} = Maintenance.update_charge(charge, @invalid_attrs)
      assert charge == Maintenance.get_charge!(charge.id)
    end

    test "delete_charge/1 deletes the charge" do
      charge = charge_fixture()
      assert {:ok, %Charge{}} = Maintenance.delete_charge(charge)
      assert_raise Ecto.NoResultsError, fn -> Maintenance.get_charge!(charge.id) end
    end

    test "change_charge/1 returns a charge changeset" do
      charge = charge_fixture()
      assert %Ecto.Changeset{} = Maintenance.change_charge(charge)
    end
  end
end
