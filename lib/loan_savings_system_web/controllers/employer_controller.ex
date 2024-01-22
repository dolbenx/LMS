defmodule LoanSavingsSystemWeb.EmployerController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.Repo

    plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password, :loan_details]
    )


  def employer_staff_loan(conn, _params) do
    render(conn, "employer_staff_loan.html")
  end

  def employer_staff_repayment(conn, _params) do
    render(conn, "employer_staff_repayment.html")
  end

  def employer_staff(conn, _params) do
    render(conn, "employer_staff.html")
  end

  def employer_admin(conn, _params) do
    render(conn, "employer_admin.html")
  end

  def employer_staff_report(conn, _params) do
    render(conn, "employer_staff_report.html")
  end

end
