defmodule Loanmanagementsystem.TransactionServices.ListRepayment do
  alias Loanmanagementsystem.Notifications.Messages
  alias Loanmanagementsystem.Core_transaction


  def list_customer_repayment_txn(conn, _params) do
     user_id = try do conn.assigns.current_user.id rescue _-> "" end
     repayments = Core_transaction.list_customer_repayments(user_id)
     Messages.success_message("Loan Transactions", %{loans: repayments})
   end





end
