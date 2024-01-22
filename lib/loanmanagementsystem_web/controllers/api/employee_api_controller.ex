defmodule LoanmanagementsystemWeb.EmployeeApiController do
  use LoanmanagementsystemWeb, :controller
  # alias Loanmanagementsystem.Security.ParamsValidator

  alias Loanmanagementsystem.EmployeeServcies.Employee


  def employee_dashboard(conn, params) do
    json(conn, Employee.get_employee_dashboard_details(conn, params))
  end

  def employee_loan_products(conn, params) do
    json(conn, Employee.employee_loan_products(conn, params))
  end


  def get_mini_statement_by_user_id(conn, params) do
    json(conn, Employee.get_mini_statement_by_user_id(conn, params))
  end

  def get_historical_statement_by_user_id(conn, params) do
    json(conn, Employee.get_historical_statement_by_user_id(conn, params))
  end

  def get_360_view_by_user_id(conn, params) do
    json(conn, Employee.get_360_view_by_userid(conn, params))
  end
end
