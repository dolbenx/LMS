defmodule LoanmanagementsystemWeb.CompanyControllerTest do
  use LoanmanagementsystemWeb.ConnCase

  alias Loanmanagementsystem.Companies

  @create_attrs %{
    approval_trail: "some approval_trail",
    auth_level: 42,
    companyName: "some companyName",
    companyPhone: "some companyPhone",
    contactEmail: "some contactEmail",
    createdByUserId: 42,
    createdByUserRoleId: 42,
    isEmployer: true,
    isOfftaker: true,
    isSme: true,
    registrationNumber: "some registrationNumber",
    status: "some status",
    taxno: "some taxno"
  }
  @update_attrs %{
    approval_trail: "some updated approval_trail",
    auth_level: 43,
    companyName: "some updated companyName",
    companyPhone: "some updated companyPhone",
    contactEmail: "some updated contactEmail",
    createdByUserId: 43,
    createdByUserRoleId: 43,
    isEmployer: false,
    isOfftaker: false,
    isSme: false,
    registrationNumber: "some updated registrationNumber",
    status: "some updated status",
    taxno: "some updated taxno"
  }
  @invalid_attrs %{
    approval_trail: nil,
    auth_level: nil,
    companyName: nil,
    companyPhone: nil,
    contactEmail: nil,
    createdByUserId: nil,
    createdByUserRoleId: nil,
    isEmployer: nil,
    isOfftaker: nil,
    isSme: nil,
    registrationNumber: nil,
    status: nil,
    taxno: nil
  }

  def fixture(:company) do
    {:ok, company} = Companies.create_company(@create_attrs)
    company
  end

  describe "index" do
    test "lists all tbl_company", %{conn: conn} do
      conn = get(conn, Routes.company_path(conn, :index))
      assert html_response(conn, 200) =~ "Listing Tbl company"
    end
  end

  describe "new company" do
    test "renders form", %{conn: conn} do
      conn = get(conn, Routes.company_path(conn, :new))
      assert html_response(conn, 200) =~ "New Company"
    end
  end

  describe "create company" do
    test "redirects to show when data is valid", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :create), company: @create_attrs)

      assert %{id: id} = redirected_params(conn)
      assert redirected_to(conn) == Routes.company_path(conn, :show, id)

      conn = get(conn, Routes.company_path(conn, :show, id))
      assert html_response(conn, 200) =~ "Show Company"
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post(conn, Routes.company_path(conn, :create), company: @invalid_attrs)
      assert html_response(conn, 200) =~ "New Company"
    end
  end

  describe "edit company" do
    setup [:create_company]

    test "renders form for editing chosen company", %{conn: conn, company: company} do
      conn = get(conn, Routes.company_path(conn, :edit, company))
      assert html_response(conn, 200) =~ "Edit Company"
    end
  end

  describe "update company" do
    setup [:create_company]

    test "redirects when data is valid", %{conn: conn, company: company} do
      conn = put(conn, Routes.company_path(conn, :update, company), company: @update_attrs)
      assert redirected_to(conn) == Routes.company_path(conn, :show, company)

      conn = get(conn, Routes.company_path(conn, :show, company))
      assert html_response(conn, 200) =~ "some updated approval_trail"
    end

    test "renders errors when data is invalid", %{conn: conn, company: company} do
      conn = put(conn, Routes.company_path(conn, :update, company), company: @invalid_attrs)
      assert html_response(conn, 200) =~ "Edit Company"
    end
  end

  describe "delete company" do
    setup [:create_company]

    test "deletes chosen company", %{conn: conn, company: company} do
      conn = delete(conn, Routes.company_path(conn, :delete, company))
      assert redirected_to(conn) == Routes.company_path(conn, :index)

      assert_error_sent 404, fn ->
        get(conn, Routes.company_path(conn, :show, company))
      end
    end
  end

  defp create_company(_) do
    company = fixture(:company)
    %{company: company}
  end
end
