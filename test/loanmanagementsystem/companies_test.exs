defmodule Loanmanagementsystem.CompaniesTest do
  use Loanmanagementsystem.DataCase

  alias Loanmanagementsystem.Companies

  describe "tbl_departments" do
    alias Loanmanagementsystem.Companies.Department

    @valid_attrs %{
      companyId: "some companyId",
      deptCode: "some deptCode",
      name: "some name",
      status: "some status"
    }
    @update_attrs %{
      companyId: "some updated companyId",
      deptCode: "some updated deptCode",
      name: "some updated name",
      status: "some updated status"
    }
    @invalid_attrs %{companyId: nil, deptCode: nil, name: nil, status: nil}

    def department_fixture(attrs \\ %{}) do
      {:ok, department} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_department()

      department
    end

    test "list_tbl_departments/0 returns all tbl_departments" do
      department = department_fixture()
      assert Companies.list_tbl_departments() == [department]
    end

    test "get_department!/1 returns the department with given id" do
      department = department_fixture()
      assert Companies.get_department!(department.id) == department
    end

    test "create_department/1 with valid data creates a department" do
      assert {:ok, %Department{} = department} = Companies.create_department(@valid_attrs)
      assert department.companyId == "some companyId"
      assert department.deptCode == "some deptCode"
      assert department.name == "some name"
      assert department.status == "some status"
    end

    test "create_department/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_department(@invalid_attrs)
    end

    test "update_department/2 with valid data updates the department" do
      department = department_fixture()

      assert {:ok, %Department{} = department} =
               Companies.update_department(department, @update_attrs)

      assert department.companyId == "some updated companyId"
      assert department.deptCode == "some updated deptCode"
      assert department.name == "some updated name"
      assert department.status == "some updated status"
    end

    test "update_department/2 with invalid data returns error changeset" do
      department = department_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_department(department, @invalid_attrs)
      assert department == Companies.get_department!(department.id)
    end

    test "delete_department/1 deletes the department" do
      department = department_fixture()
      assert {:ok, %Department{}} = Companies.delete_department(department)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_department!(department.id) end
    end

    test "change_department/1 returns a department changeset" do
      department = department_fixture()
      assert %Ecto.Changeset{} = Companies.change_department(department)
    end
  end

  describe "tbl_company_branches" do
    alias Loanmanagementsystem.Companies.Company_Branch

    @valid_attrs %{
      branchCode: "some branchCode",
      companyId: "some companyId",
      name: "some name",
      status: "some status"
    }
    @update_attrs %{
      branchCode: "some updated branchCode",
      companyId: "some updated companyId",
      name: "some updated name",
      status: "some updated status"
    }
    @invalid_attrs %{branchCode: nil, companyId: nil, name: nil, status: nil}

    def company__branch_fixture(attrs \\ %{}) do
      {:ok, company__branch} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company__branch()

      company__branch
    end

    test "list_tbl_company_branches/0 returns all tbl_company_branches" do
      company__branch = company__branch_fixture()
      assert Companies.list_tbl_company_branches() == [company__branch]
    end

    test "get_company__branch!/1 returns the company__branch with given id" do
      company__branch = company__branch_fixture()
      assert Companies.get_company__branch!(company__branch.id) == company__branch
    end

    test "create_company__branch/1 with valid data creates a company__branch" do
      assert {:ok, %Company_Branch{} = company__branch} =
               Companies.create_company__branch(@valid_attrs)

      assert company__branch.branchCode == "some branchCode"
      assert company__branch.companyId == "some companyId"
      assert company__branch.name == "some name"
      assert company__branch.status == "some status"
    end

    test "create_company__branch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company__branch(@invalid_attrs)
    end

    test "update_company__branch/2 with valid data updates the company__branch" do
      company__branch = company__branch_fixture()

      assert {:ok, %Company_Branch{} = company__branch} =
               Companies.update_company__branch(company__branch, @update_attrs)

      assert company__branch.branchCode == "some updated branchCode"
      assert company__branch.companyId == "some updated companyId"
      assert company__branch.name == "some updated name"
      assert company__branch.status == "some updated status"
    end

    test "update_company__branch/2 with invalid data returns error changeset" do
      company__branch = company__branch_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Companies.update_company__branch(company__branch, @invalid_attrs)

      assert company__branch == Companies.get_company__branch!(company__branch.id)
    end

    test "delete_company__branch/1 deletes the company__branch" do
      company__branch = company__branch_fixture()
      assert {:ok, %Company_Branch{}} = Companies.delete_company__branch(company__branch)

      assert_raise Ecto.NoResultsError, fn ->
        Companies.get_company__branch!(company__branch.id)
      end
    end

    test "change_company__branch/1 returns a company__branch changeset" do
      company__branch = company__branch_fixture()
      assert %Ecto.Changeset{} = Companies.change_company__branch(company__branch)
    end
  end

  describe "tbl_client_company_details" do
    alias Loanmanagementsystem.Companies.Client_company_details

    @valid_attrs %{
      approval_trail: "some approval_trail",
      auth_level: 42,
      bank_id: 42,
      company_account_number: "some company_account_number",
      company_name: "some company_name",
      company_phone: "some company_phone",
      company_registration_date: ~D[2010-04-17],
      contact_email: "some contact_email",
      createdByUserId: 42,
      createdByUserRoleId: 42,
      registration_number: "some registration_number",
      status: "some status",
      taxno: "some taxno"
    }
    @update_attrs %{
      approval_trail: "some updated approval_trail",
      auth_level: 43,
      bank_id: 43,
      company_account_number: "some updated company_account_number",
      company_name: "some updated company_name",
      company_phone: "some updated company_phone",
      company_registration_date: ~D[2011-05-18],
      contact_email: "some updated contact_email",
      createdByUserId: 43,
      createdByUserRoleId: 43,
      registration_number: "some updated registration_number",
      status: "some updated status",
      taxno: "some updated taxno"
    }
    @invalid_attrs %{
      approval_trail: nil,
      auth_level: nil,
      bank_id: nil,
      company_account_number: nil,
      company_name: nil,
      company_phone: nil,
      company_registration_date: nil,
      contact_email: nil,
      createdByUserId: nil,
      createdByUserRoleId: nil,
      registration_number: nil,
      status: nil,
      taxno: nil
    }

    def client_company_details_fixture(attrs \\ %{}) do
      {:ok, client_company_details} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_client_company_details()

      client_company_details
    end

    test "list_tbl_client_company_details/0 returns all tbl_client_company_details" do
      client_company_details = client_company_details_fixture()
      assert Companies.list_tbl_client_company_details() == [client_company_details]
    end

    test "get_client_company_details!/1 returns the client_company_details with given id" do
      client_company_details = client_company_details_fixture()

      assert Companies.get_client_company_details!(client_company_details.id) ==
               client_company_details
    end

    test "create_client_company_details/1 with valid data creates a client_company_details" do
      assert {:ok, %Client_company_details{} = client_company_details} =
               Companies.create_client_company_details(@valid_attrs)

      assert client_company_details.approval_trail == "some approval_trail"
      assert client_company_details.auth_level == 42
      assert client_company_details.bank_id == 42
      assert client_company_details.company_account_number == "some company_account_number"
      assert client_company_details.company_name == "some company_name"
      assert client_company_details.company_phone == "some company_phone"
      assert client_company_details.company_registration_date == ~D[2010-04-17]
      assert client_company_details.contact_email == "some contact_email"
      assert client_company_details.createdByUserId == 42
      assert client_company_details.createdByUserRoleId == 42
      assert client_company_details.registration_number == "some registration_number"
      assert client_company_details.status == "some status"
      assert client_company_details.taxno == "some taxno"
    end

    test "create_client_company_details/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_client_company_details(@invalid_attrs)
    end

    test "update_client_company_details/2 with valid data updates the client_company_details" do
      client_company_details = client_company_details_fixture()

      assert {:ok, %Client_company_details{} = client_company_details} =
               Companies.update_client_company_details(client_company_details, @update_attrs)

      assert client_company_details.approval_trail == "some updated approval_trail"
      assert client_company_details.auth_level == 43
      assert client_company_details.bank_id == 43

      assert client_company_details.company_account_number ==
               "some updated company_account_number"

      assert client_company_details.company_name == "some updated company_name"
      assert client_company_details.company_phone == "some updated company_phone"
      assert client_company_details.company_registration_date == ~D[2011-05-18]
      assert client_company_details.contact_email == "some updated contact_email"
      assert client_company_details.createdByUserId == 43
      assert client_company_details.createdByUserRoleId == 43
      assert client_company_details.registration_number == "some updated registration_number"
      assert client_company_details.status == "some updated status"
      assert client_company_details.taxno == "some updated taxno"
    end

    test "update_client_company_details/2 with invalid data returns error changeset" do
      client_company_details = client_company_details_fixture()

      assert {:error, %Ecto.Changeset{}} =
               Companies.update_client_company_details(client_company_details, @invalid_attrs)

      assert client_company_details ==
               Companies.get_client_company_details!(client_company_details.id)
    end

    test "delete_client_company_details/1 deletes the client_company_details" do
      client_company_details = client_company_details_fixture()

      assert {:ok, %Client_company_details{}} =
               Companies.delete_client_company_details(client_company_details)

      assert_raise Ecto.NoResultsError, fn ->
        Companies.get_client_company_details!(client_company_details.id)
      end
    end

    test "change_client_company_details/1 returns a client_company_details changeset" do
      client_company_details = client_company_details_fixture()
      assert %Ecto.Changeset{} = Companies.change_client_company_details(client_company_details)
    end
  end
end
