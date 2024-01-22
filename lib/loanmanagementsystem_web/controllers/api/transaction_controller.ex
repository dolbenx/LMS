defmodule LoanmanagementsystemWeb.TransactionController do
  use LoanmanagementsystemWeb, :controller
  # alias Loanmanagementsystem.Security.ParamsValidator
  alias Loanmanagementsystem.TransactionServices.ListRepayment

  def list_customer_repayments(conn, params) do
    json(conn, ListRepayment.list_customer_repayment_txn(conn, params))
  end

end
