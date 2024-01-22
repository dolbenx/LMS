defmodule Loanmanagementsystem.EmploymentTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Employment

  describe "tbl_employee_maintenance" do
    alias Loanmanagementsystem.Employment.Employee_Maintenance

    @valid_attrs %{
      branchId: 42,
      departmentId: 42,
      employee_number: "some employee_number",
      employee_status: "some employee_status",
      mobile_network_operator: "some mobile_network_operator",
      nrc_image: "some nrc_image",
      registered_name_mobile_number: "some registered_name_mobile_number",
      roleTypeId: 42,
      userId: 42
    }
    @update_attrs %{
      branchId: 43,
      departmentId: 43,
      employee_number: "some updated employee_number",
      employee_status: "some updated employee_status",
      mobile_network_operator: "some updated mobile_network_operator",
      nrc_image: "some updated nrc_image",
      registered_name_mobile_number: "some updated registered_name_mobile_number",
      roleTypeId: 43,
      userId: 43
    }
    @invalid_attrs %{
      branchId: nil,
      departmentId: nil,
      employee_number: nil,
      employee_status: nil,
      mobile_network_operator: nil,
      nrc_image: nil,
      registered_name_mobile_number: nil,
      roleTypeId: nil,
      userId: nil
    }

    def employee__maintenance_fixture(attrs \\ %{}) do
      {:ok, employee__maintenance} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Employment.create_employee__maintenance()

      employee__maintenance
    end

    test "list_tbl_employee_maintenance/0 returns all tbl_employee_maintenance" do
      employee__maintenance = employee__maintenance_fixture()
      assert Employment.list_tbl_employee_maintenance() == [employee__maintenance]
    end

    test "get_employee__maintenance!/1 returns the employee__maintenance with given id" do
      employee__maintenance = employee__maintenance_fixture()

      assert Employment.get_employee__maintenance!(employee__maintenance.id) ==
               employee__maintenance
    end

    test "create_employee__maintenance/1 with valid data creates a employee__maintenance" do
      assert {:ok, %Employee_Maintenance{} = employee__maintenance} =
               Employment.create_employee__maintenance(@valid_attrs)

      assert employee__maintenance.branchId == 42
      assert employee__maintenance.departmentId == 42
      assert employee__maintenance.employee_number == "some employee_number"
      assert employee__maintenance.employee_status == "some employee_status"
      assert employee__maintenance.mobile_network_operator == "some mobile_network_operator"
      assert employee__maintenance.nrc_image == "some nrc_image"

      assert employee__maintenance.registered_name_mobile_number ==
               "some registered_name_mobile_number"

      assert employee__maintenance.roleTypeId == 42
      assert employee__maintenance.userId == 42
    end

    test "create_employee__maintenance/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Employment.create_employee__maintenance(@invalid_attrs)
    end

    test "update_employee__maintenance/2 with valid data updates the employee__maintenance" do
      employee__maintenance = employee__maintenance_fixture()

      assert {:ok, %Employee_Maintenance{} = employee__maintenance} =
               Employment.update_employee__maintenance(employee__maintenance, @update_attrs)

      assert employee__maintenance.branchId == 43
      assert employee__maintenance.departmentId == 43
      assert employee__maintenance.employee_number == "some updated employee_number"
      assert employee__maintenance.employee_status == "some updated employee_status"

      assert employee__maintenance.mobile_network_operator ==
               "some updated mobile_network_operator"

      assert employee__maintenance.nrc_image == "some updated nrc_image"

      assert employee__maintenance.registered_name_mobile_number ==
               "some updated registered_name_mobile_number"

      assert employee__maintenance.roleTypeId == 43
      assert employee__maintenance.userId == 43
    end

    test "update_employee__maintenance/2 with invalid data returns error changeset" do
      employee__maintenance = employee__maintenance_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Employment.update_employee__maintenance(employee__maintenance, @invalid_attrs)

      assert employee__maintenance ==
               Employment.get_employee__maintenance!(employee__maintenance.id)
    end

    test "delete_employee__maintenance/1 deletes the employee__maintenance" do
      employee__maintenance = employee__maintenance_fixture()

      assert {:ok, %Employee_Maintenance{}} =
               Employment.delete_employee__maintenance(employee__maintenance)

      assert_raise Ecto.NoResultsError, fn ->
        Employment.get_employee__maintenance!(employee__maintenance.id)
      end
    end

    test "change_employee__maintenance/1 returns a employee__maintenance changeset" do
      employee__maintenance = employee__maintenance_fixture()
      assert %Ecto.Changeset{} = Employment.change_employee__maintenance(employee__maintenance)
    end
  end
end
