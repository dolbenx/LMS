defmodule LoanmanagementsystemWeb.LoanController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Loan
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Products.Product_rates
  alias Loanmanagementsystem.Loan.LoanTransaction

  def loans_application(conn, _params) do
    render(conn, "loans_application.html")
 end

  def loans(conn, _params) do
     render(conn, "loans.html")
  end

  def pending_loans(conn, _params) do
    render(conn, "pending_loans.html")
  end

  def tracking_loans(conn, _params) do
    render(conn, "tracking_loans.html")
  end

  def disbursed_loans(conn, _params) do
    render(conn, "disbursed_loans.html")
  end

  def outstanding_loans(conn, _params) do
    render(conn, "outstanding_loans.html")
  end

  def written_off_loans(conn, _params) do
    render(conn, "written_off_loans.html")
  end

end
