defmodule LoanmanagementsystemWeb.FinancialManagementController do
  use LoanmanagementsystemWeb, :controller

  # ----------------------------financial management --------------------------------------

  def search_transaction(conn, params), do: render(conn, "search_transaction.html")
  def freqeunt_posting(conn, params), do: render(conn, "frequent_postings.html")

  def financial_activity_mapping(conn, params),
    do: render(conn, "financial_activity_mapping.html")

  def fund_association(conn, params), do: render(conn, "fund_association.html")
  def migrate_opening_balances(conn, params), do: render(conn, "migrate_opening_balances.html")
  def acruals(conn, params), do: render(conn, "acruals.html")
  def provisioning_entries(conn, params), do: render(conn, "provisioning_entries.html")
  def closing_entries(conn, params), do: render(conn, "closing_entries.html")
end
