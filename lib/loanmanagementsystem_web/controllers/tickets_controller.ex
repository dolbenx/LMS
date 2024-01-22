defmodule LoanmanagementsystemWeb.TicketsController do
  use LoanmanagementsystemWeb, :controller
  import Ecto.Query, warn: false
  use Ecto.Schema

  alias Loanmanagementsystem.Repo
  # alias Loanmanagementsystem.Accounts.User
  # alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.UserBioData
  # alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Accounts


  def change_request(conn, _params) do
    render(conn, "change_request.html")
  end


  def complaints(conn, _params) do
    render(conn, "complaints.html")
  end


  def incidents(conn, _params) do
    render(conn, "incidents.html")
  end


  def service_request(conn, _params) do
    render(conn, "service_request.html")
  end

  def traverse_errors(errors),
    do: for({key, {msg, _opts}} <- errors, do: "#{String.upcase(to_string(key))} #{msg}")
end
