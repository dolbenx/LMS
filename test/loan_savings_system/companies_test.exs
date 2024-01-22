defmodule LoanSavingsSystem.CompaniesTest do
  use LoanSavingsSystem.DataCase

  alias LoanSavingsSystem.Companies

  describe "tbl_companies" do
    alias LoanSavingsSystem.Companies.Company

    @valid_attrs %{address: "some address", city: "some city", company_id: "some company_id", company_name: "some company_name", country: "some country", date_of_incorporation: "some date_of_incorporation", email: "some email", is_employee: "some is_employee", phone: "some phone", staff_id: "some staff_id", tpin_no: "some tpin_no"}
    @update_attrs %{address: "some updated address", city: "some updated city", company_id: "some updated company_id", company_name: "some updated company_name", country: "some updated country", date_of_incorporation: "some updated date_of_incorporation", email: "some updated email", is_employee: "some updated is_employee", phone: "some updated phone", staff_id: "some updated staff_id", tpin_no: "some updated tpin_no"}
    @invalid_attrs %{address: nil, city: nil, company_id: nil, company_name: nil, country: nil, date_of_incorporation: nil, email: nil, is_employee: nil, phone: nil, staff_id: nil, tpin_no: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "list_tbl_companies/0 returns all tbl_companies" do
      company = company_fixture()
      assert Companies.list_tbl_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
      assert company.address == "some address"
      assert company.city == "some city"
      assert company.company_id == "some company_id"
      assert company.company_name == "some company_name"
      assert company.country == "some country"
      assert company.date_of_incorporation == "some date_of_incorporation"
      assert company.email == "some email"
      assert company.is_employee == "some is_employee"
      assert company.phone == "some phone"
      assert company.staff_id == "some staff_id"
      assert company.tpin_no == "some tpin_no"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Companies.update_company(company, @update_attrs)
      assert company.address == "some updated address"
      assert company.city == "some updated city"
      assert company.company_id == "some updated company_id"
      assert company.company_name == "some updated company_name"
      assert company.country == "some updated country"
      assert company.date_of_incorporation == "some updated date_of_incorporation"
      assert company.email == "some updated email"
      assert company.is_employee == "some updated is_employee"
      assert company.phone == "some updated phone"
      assert company.staff_id == "some updated staff_id"
      assert company.tpin_no == "some updated tpin_no"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end

  describe "tbl_companies" do
    alias LoanSavingsSystem.Companies.Company

    @valid_attrs %{address: "some address", city: "some city", company_id: "some company_id", company_name: "some company_name", country: "some country", date_of_incorporation: "some date_of_incorporation", email: "some email", is_employee: "some is_employee", phone: "some phone", staff_id: "some staff_id", tpin_no: "some tpin_no"}
    @update_attrs %{address: "some updated address", city: "some updated city", company_id: "some updated company_id", company_name: "some updated company_name", country: "some updated country", date_of_incorporation: "some updated date_of_incorporation", email: "some updated email", is_employee: "some updated is_employee", phone: "some updated phone", staff_id: "some updated staff_id", tpin_no: "some updated tpin_no"}
    @invalid_attrs %{address: nil, city: nil, company_id: nil, company_name: nil, country: nil, date_of_incorporation: nil, email: nil, is_employee: nil, phone: nil, staff_id: nil, tpin_no: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "list_tbl_companies/0 returns all tbl_companies" do
      company = company_fixture()
      assert Companies.list_tbl_companies() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
      assert company.address == "some address"
      assert company.city == "some city"
      assert company.company_id == "some company_id"
      assert company.company_name == "some company_name"
      assert company.country == "some country"
      assert company.date_of_incorporation == "some date_of_incorporation"
      assert company.email == "some email"
      assert company.is_employee == "some is_employee"
      assert company.phone == "some phone"
      assert company.staff_id == "some staff_id"
      assert company.tpin_no == "some tpin_no"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Companies.update_company(company, @update_attrs)
      assert company.address == "some updated address"
      assert company.city == "some updated city"
      assert company.company_id == "some updated company_id"
      assert company.company_name == "some updated company_name"
      assert company.country == "some updated country"
      assert company.date_of_incorporation == "some updated date_of_incorporation"
      assert company.email == "some updated email"
      assert company.is_employee == "some updated is_employee"
      assert company.phone == "some updated phone"
      assert company.staff_id == "some updated staff_id"
      assert company.tpin_no == "some updated tpin_no"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end

  describe "tbl_staff" do
    alias LoanSavingsSystem.Companies.Staff

    @valid_attrs %{city: "some city", company_id: "some company_id", country: "some country", email: "some email", first_name: "some first_name", id_no: "some id_no", id_type: "some id_type", last_name: "some last_name", other_name: "some other_name", phone: "some phone", staff_id: "some staff_id"}
    @update_attrs %{city: "some updated city", company_id: "some updated company_id", country: "some updated country", email: "some updated email", first_name: "some updated first_name", id_no: "some updated id_no", id_type: "some updated id_type", last_name: "some updated last_name", other_name: "some updated other_name", phone: "some updated phone", staff_id: "some updated staff_id"}
    @invalid_attrs %{city: nil, company_id: nil, country: nil, email: nil, first_name: nil, id_no: nil, id_type: nil, last_name: nil, other_name: nil, phone: nil, staff_id: nil}

    def staff_fixture(attrs \\ %{}) do
      {:ok, staff} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_staff()

      staff
    end

    test "list_tbl_staff/0 returns all tbl_staff" do
      staff = staff_fixture()
      assert Companies.list_tbl_staff() == [staff]
    end

    test "get_staff!/1 returns the staff with given id" do
      staff = staff_fixture()
      assert Companies.get_staff!(staff.id) == staff
    end

    test "create_staff/1 with valid data creates a staff" do
      assert {:ok, %Staff{} = staff} = Companies.create_staff(@valid_attrs)
      assert staff.city == "some city"
      assert staff.company_id == "some company_id"
      assert staff.country == "some country"
      assert staff.email == "some email"
      assert staff.first_name == "some first_name"
      assert staff.id_no == "some id_no"
      assert staff.id_type == "some id_type"
      assert staff.last_name == "some last_name"
      assert staff.other_name == "some other_name"
      assert staff.phone == "some phone"
      assert staff.staff_id == "some staff_id"
    end

    test "create_staff/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_staff(@invalid_attrs)
    end

    test "update_staff/2 with valid data updates the staff" do
      staff = staff_fixture()
      assert {:ok, %Staff{} = staff} = Companies.update_staff(staff, @update_attrs)
      assert staff.city == "some updated city"
      assert staff.company_id == "some updated company_id"
      assert staff.country == "some updated country"
      assert staff.email == "some updated email"
      assert staff.first_name == "some updated first_name"
      assert staff.id_no == "some updated id_no"
      assert staff.id_type == "some updated id_type"
      assert staff.last_name == "some updated last_name"
      assert staff.other_name == "some updated other_name"
      assert staff.phone == "some updated phone"
      assert staff.staff_id == "some updated staff_id"
    end

    test "update_staff/2 with invalid data returns error changeset" do
      staff = staff_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_staff(staff, @invalid_attrs)
      assert staff == Companies.get_staff!(staff.id)
    end

    test "delete_staff/1 deletes the staff" do
      staff = staff_fixture()
      assert {:ok, %Staff{}} = Companies.delete_staff(staff)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_staff!(staff.id) end
    end

    test "change_staff/1 returns a staff changeset" do
      staff = staff_fixture()
      assert %Ecto.Changeset{} = Companies.change_staff(staff)
    end
  end

  describe "tbl_company" do
    alias LoanSavingsSystem.Companies.Company

    @valid_attrs %{addressLine1: "some addressLine1", addressLine2: "some addressLine2", city: "some city", companyName: "some companyName", countryId: 42, countryName: "some countryName", districtId: 42, districtName: "some districtName", provinceId: 42, provinceName: "some provinceName"}
    @update_attrs %{addressLine1: "some updated addressLine1", addressLine2: "some updated addressLine2", city: "some updated city", companyName: "some updated companyName", countryId: 43, countryName: "some updated countryName", districtId: 43, districtName: "some updated districtName", provinceId: 43, provinceName: "some updated provinceName"}
    @invalid_attrs %{addressLine1: nil, addressLine2: nil, city: nil, companyName: nil, countryId: nil, countryName: nil, districtId: nil, districtName: nil, provinceId: nil, provinceName: nil}

    def company_fixture(attrs \\ %{}) do
      {:ok, company} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_company()

      company
    end

    test "list_tbl_company/0 returns all tbl_company" do
      company = company_fixture()
      assert Companies.list_tbl_company() == [company]
    end

    test "get_company!/1 returns the company with given id" do
      company = company_fixture()
      assert Companies.get_company!(company.id) == company
    end

    test "create_company/1 with valid data creates a company" do
      assert {:ok, %Company{} = company} = Companies.create_company(@valid_attrs)
      assert company.addressLine1 == "some addressLine1"
      assert company.addressLine2 == "some addressLine2"
      assert company.city == "some city"
      assert company.companyName == "some companyName"
      assert company.countryId == 42
      assert company.countryName == "some countryName"
      assert company.districtId == 42
      assert company.districtName == "some districtName"
      assert company.provinceId == 42
      assert company.provinceName == "some provinceName"
    end

    test "create_company/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_company(@invalid_attrs)
    end

    test "update_company/2 with valid data updates the company" do
      company = company_fixture()
      assert {:ok, %Company{} = company} = Companies.update_company(company, @update_attrs)
      assert company.addressLine1 == "some updated addressLine1"
      assert company.addressLine2 == "some updated addressLine2"
      assert company.city == "some updated city"
      assert company.companyName == "some updated companyName"
      assert company.countryId == 43
      assert company.countryName == "some updated countryName"
      assert company.districtId == 43
      assert company.districtName == "some updated districtName"
      assert company.provinceId == 43
      assert company.provinceName == "some updated provinceName"
    end

    test "update_company/2 with invalid data returns error changeset" do
      company = company_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_company(company, @invalid_attrs)
      assert company == Companies.get_company!(company.id)
    end

    test "delete_company/1 deletes the company" do
      company = company_fixture()
      assert {:ok, %Company{}} = Companies.delete_company(company)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_company!(company.id) end
    end

    test "change_company/1 returns a company changeset" do
      company = company_fixture()
      assert %Ecto.Changeset{} = Companies.change_company(company)
    end
  end

  describe "tbl" do
    alias LoanSavingsSystem.Companies.Employer

    @valid_attrs %{_employer: "some _employer", companyId: 42, status: "some status"}
    @update_attrs %{_employer: "some updated _employer", companyId: 43, status: "some updated status"}
    @invalid_attrs %{_employer: nil, companyId: nil, status: nil}

    def employer_fixture(attrs \\ %{}) do
      {:ok, employer} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_employer()

      employer
    end

    test "list_tbl/0 returns all tbl" do
      employer = employer_fixture()
      assert Companies.list_tbl() == [employer]
    end

    test "get_employer!/1 returns the employer with given id" do
      employer = employer_fixture()
      assert Companies.get_employer!(employer.id) == employer
    end

    test "create_employer/1 with valid data creates a employer" do
      assert {:ok, %Employer{} = employer} = Companies.create_employer(@valid_attrs)
      assert employer._employer == "some _employer"
      assert employer.companyId == 42
      assert employer.status == "some status"
    end

    test "create_employer/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_employer(@invalid_attrs)
    end

    test "update_employer/2 with valid data updates the employer" do
      employer = employer_fixture()
      assert {:ok, %Employer{} = employer} = Companies.update_employer(employer, @update_attrs)
      assert employer._employer == "some updated _employer"
      assert employer.companyId == 43
      assert employer.status == "some updated status"
    end

    test "update_employer/2 with invalid data returns error changeset" do
      employer = employer_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_employer(employer, @invalid_attrs)
      assert employer == Companies.get_employer!(employer.id)
    end

    test "delete_employer/1 deletes the employer" do
      employer = employer_fixture()
      assert {:ok, %Employer{}} = Companies.delete_employer(employer)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_employer!(employer.id) end
    end

    test "change_employer/1 returns a employer changeset" do
      employer = employer_fixture()
      assert %Ecto.Changeset{} = Companies.change_employer(employer)
    end
  end

  describe "tbl_employee" do
    alias LoanSavingsSystem.Companies.Employee

    @valid_attrs %{companyId: 42, employerId: 42, status: "some status", userId: 42, userRoleId: 42}
    @update_attrs %{companyId: 43, employerId: 43, status: "some updated status", userId: 43, userRoleId: 43}
    @invalid_attrs %{companyId: nil, employerId: nil, status: nil, userId: nil, userRoleId: nil}

    def employee_fixture(attrs \\ %{}) do
      {:ok, employee} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_employee()

      employee
    end

    test "list_tbl_employee/0 returns all tbl_employee" do
      employee = employee_fixture()
      assert Companies.list_tbl_employee() == [employee]
    end

    test "get_employee!/1 returns the employee with given id" do
      employee = employee_fixture()
      assert Companies.get_employee!(employee.id) == employee
    end

    test "create_employee/1 with valid data creates a employee" do
      assert {:ok, %Employee{} = employee} = Companies.create_employee(@valid_attrs)
      assert employee.companyId == 42
      assert employee.employerId == 42
      assert employee.status == "some status"
      assert employee.userId == 42
      assert employee.userRoleId == 42
    end

    test "create_employee/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_employee(@invalid_attrs)
    end

    test "update_employee/2 with valid data updates the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{} = employee} = Companies.update_employee(employee, @update_attrs)
      assert employee.companyId == 43
      assert employee.employerId == 43
      assert employee.status == "some updated status"
      assert employee.userId == 43
      assert employee.userRoleId == 43
    end

    test "update_employee/2 with invalid data returns error changeset" do
      employee = employee_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_employee(employee, @invalid_attrs)
      assert employee == Companies.get_employee!(employee.id)
    end

    test "delete_employee/1 deletes the employee" do
      employee = employee_fixture()
      assert {:ok, %Employee{}} = Companies.delete_employee(employee)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_employee!(employee.id) end
    end

    test "change_employee/1 returns a employee changeset" do
      employee = employee_fixture()
      assert %Ecto.Changeset{} = Companies.change_employee(employee)
    end
  end

  describe "tbl_branch" do
    alias LoanSavingsSystem.Companies.Branch

    @valid_attrs %{branchCode: "some branchCode", branchName: "some branchName", clientId: 42, isDefaultUSSDBranch: true}
    @update_attrs %{branchCode: "some updated branchCode", branchName: "some updated branchName", clientId: 43, isDefaultUSSDBranch: false}
    @invalid_attrs %{branchCode: nil, branchName: nil, clientId: nil, isDefaultUSSDBranch: nil}

    def branch_fixture(attrs \\ %{}) do
      {:ok, branch} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Companies.create_branch()

      branch
    end

    test "list_tbl_branch/0 returns all tbl_branch" do
      branch = branch_fixture()
      assert Companies.list_tbl_branch() == [branch]
    end

    test "get_branch!/1 returns the branch with given id" do
      branch = branch_fixture()
      assert Companies.get_branch!(branch.id) == branch
    end

    test "create_branch/1 with valid data creates a branch" do
      assert {:ok, %Branch{} = branch} = Companies.create_branch(@valid_attrs)
      assert branch.branchCode == "some branchCode"
      assert branch.branchName == "some branchName"
      assert branch.clientId == 42
      assert branch.isDefaultUSSDBranch == true
    end

    test "create_branch/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Companies.create_branch(@invalid_attrs)
    end

    test "update_branch/2 with valid data updates the branch" do
      branch = branch_fixture()
      assert {:ok, %Branch{} = branch} = Companies.update_branch(branch, @update_attrs)
      assert branch.branchCode == "some updated branchCode"
      assert branch.branchName == "some updated branchName"
      assert branch.clientId == 43
      assert branch.isDefaultUSSDBranch == false
    end

    test "update_branch/2 with invalid data returns error changeset" do
      branch = branch_fixture()
      assert {:error, %Ecto.Changeset{}} = Companies.update_branch(branch, @invalid_attrs)
      assert branch == Companies.get_branch!(branch.id)
    end

    test "delete_branch/1 deletes the branch" do
      branch = branch_fixture()
      assert {:ok, %Branch{}} = Companies.delete_branch(branch)
      assert_raise Ecto.NoResultsError, fn -> Companies.get_branch!(branch.id) end
    end

    test "change_branch/1 returns a branch changeset" do
      branch = branch_fixture()
      assert %Ecto.Changeset{} = Companies.change_branch(branch)
    end
  end
end
