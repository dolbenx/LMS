defmodule Loanmanagementsystem.EmployeeServcies.Employee do
  alias Loanmanagementsystem.Notifications.Messages


  def get_employee_dashboard_details(conn, _params) do
    user_id = try do conn.assigns.current_user.id rescue _-> "" end
    company_id = try do conn.assigns.current_user.company_id rescue _-> nil end
    company_details = Loanmanagementsystem.Operations.Api.Employee.get_employee_company_detail(company_id)
    employee_address_details = Loanmanagementsystem.Operations.Api.Employee.get_address_by_userId(user_id)
    employee_employment_details = Loanmanagementsystem.Operations.Api.Employee.get_employmentdetails_by_userId(user_id)
    no_of_loans = Loanmanagementsystem.Operations.Api.Employee.loan_count(user_id)
   Messages.success_message("Dashboard Information", %{company_details: company_details, employee_address_details: employee_address_details, employee_employment_details: employee_employment_details, no_of_loans: no_of_loans })
 end

 def employee_loan_products(_conn, _params) do
  loan_products =  Loanmanagementsystem.Operations.Api.Employee.get_products_employee
  Messages.success_message("Product List", %{loan_products: loan_products})
 end


 def get_mini_statement_by_user_id(conn, _params) do
  user_id = conn.assigns.current_user.id
  IO.inspect(user_id, label: "---------------------------id")
  loans = Loanmanagementsystem.Operations.get_individual_mini_statement(user_id)
  loan_count = Loanmanagementsystem.Operations.loan_count(user_id)
  Messages.success_message("Employee Mini Statement", %{loans: loans, loan_count: loan_count})
end

def get_historical_statement_by_user_id(conn, _params) do
  user_id = conn.assigns.current_user.id
  IO.inspect(user_id, label: "---------------------------id")
  loans = Loanmanagementsystem.Operations.get_individual_historical_statement(user_id)
  loan_count = Loanmanagementsystem.Operations.loan_count(user_id)
  Messages.success_message("Employee Historical Statement", %{loans: loans, loan_count: loan_count})
end

def get_360_view_by_userid(conn, _params) do
  user_id = conn.assigns.current_user.id
  IO.inspect(user_id, label: "---------------------------id")
  loans = Loanmanagementsystem.Operations.get_loan_by_userid(user_id)
  loan_count = Loanmanagementsystem.Operations.loan_count(user_id)
  loan_info = Loanmanagementsystem.Operations.loan_interest_amount(user_id)
  user_info = Loanmanagementsystem.Operations.get_user_info_by_user_id(user_id)
  Messages.success_message("360 View by User Id", %{loans: loans, loan_count: loan_count, loan_info: loan_info, user_info: user_info})
end


end
