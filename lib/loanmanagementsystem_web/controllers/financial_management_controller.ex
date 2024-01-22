defmodule LoanmanagementsystemWeb.FinancialManagementController do
  use LoanmanagementsystemWeb, :controller

  # ----------------------------financial management --------------------------------------


  plug LoanmanagementsystemWeb.Plugs.Authenticate,
       [module_callback: &LoanmanagementsystemWeb.FinancialManagementController.authorize_role/1]
       when action not in [
	        :acruals,
          :closing_entries,
          :financial_activity_mapping,
          :freqeunt_posting,
          :fund_association,
          :migrate_opening_balances,
          :provisioning_entries,
          :search_transaction,

            ]

  use PipeTo.Override


  def search_transaction(conn, params), do: render(conn, "search_transaction.html")
  def freqeunt_posting(conn, params), do: render(conn, "frequent_postings.html")

  def financial_activity_mapping(conn, params),
    do: render(conn, "financial_activity_mapping.html")

  def fund_association(conn, params), do: render(conn, "fund_association.html")
  def migrate_opening_balances(conn, params), do: render(conn, "migrate_opening_balances.html")
  def acruals(conn, params), do: render(conn, "acruals.html")
  def provisioning_entries(conn, params), do: render(conn, "provisioning_entries.html")
  def closing_entries(conn, params), do: render(conn, "closing_entries.html")


  def authorize_role(conn) do
    case Phoenix.Controller.action_name(conn) do
      act when act in ~w(new create)a -> {:financial_mgt, :create}
      act when act in ~w(index view)a -> {:financial_mgt, :view}
      act when act in ~w(update edit)a -> {:financial_mgt, :edit}
      act when act in ~w(change_status)a -> {:financial_mgt, :change_status}
      _ -> {:financial_mgt, :unknown}
    end
  end

end
