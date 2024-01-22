defmodule LoanmanagementsystemWeb.PaygoController do
 use LoanmanagementsystemWeb, :controller

#  plug LoanmanagementsystemWeb.Plugs.Authenticate,
#       [module_callback: &LoanmanagementsystemWeb.PaygoController.authorize_role/1]
#         when action not in [


#           :airtel_account_balance,
#           :airtel_check_customer_info,
#           :airtel_collections,
#           :airtel_disbursements,
#           :mtn_collections,
#           :mtn_disbursements,
#           :mtn_remittances,
#           :zamtel_business_to_business,
#           :zamtel_customer_account_details,
#           :zamtel_customer_paybills,
#       ]

# use PipeTo.Override

# ---------------------------------AIRTEL DETAILS----------------------------------------
  def airtel_collections(conn, params) do
    json(conn, data: Loanmanagement.Services.Paygo.Airtel.Airtel.disbursements(params))
  end

  def airtel_disbursements(conn, params) do
    json(conn, data: Loanmanagement.Services.Paygo.Airtel.Airtel.disbursements(params))
  end
  def airtel_account_balance(conn, params) do
    json(conn, data: Loanmanagement.Services.Paygo.Airtel.Airtel.account_balance(params))
  end
  def airtel_check_customer_info(conn, params) do
    json(conn, data: Loanmanagement.Services.Paygo.Airtel.Airtel.check_customer_info(params))
  end
# ----------------------------AIRTEL END---------------------------------------------------
# -------------------------------MTN START--------------------------------------------------
  def mtn_collections(conn, params) do
    json(conn, data: Loanmanagement.Services.Paygo.Mtn.Mtn.collections(params))
  end

  def mtn_disbursements(conn, params) do
    json(conn, data: Loanmanagement.Services.Paygo.Mtn.Mtn.disbursements(params))
  end
  def mtn_remittances(conn, params) do
    json(conn, data: Loanmanagement.Services.Paygo.Mtn.Mtn.remittances(params))
  end
# ------------------------MTN END--------------------------------------------------------
# -----------------------ZAMTEL START----------------------------------------------------
  def zamtel_customer_account_details(conn, params) do
    json(conn, data: Loanmanagemet.Services.Paygo.Zamtel.Zamtel.customer_account_details(params))
  end

  def zamtel_business_to_business(conn, params) do
    json(conn, data: Loanmanagemet.Services.Paygo.Zamtel.Zamtel.business_to_business(params))
  end
  def zamtel_customer_paybills(conn, params) do
    json(conn, data: Loanmanagemet.Services.Paygo.Zamtel.Zamtel.customer_paybills(params))
  end

  # def authorize_role(conn) do
  #   case Phoenix.Controller.action_name(conn) do
  #     act when act in ~w(new create)a -> {:mobile_money_txn, :create}
  #     act when act in ~w(index view)a -> {:mobile_money_txn, :view}
  #     act when act in ~w(update edit)a -> {:mobile_money_txn, :edit}
  #     act when act in ~w(change_status)a -> {:mobile_money_txn, :change_status}
  #     _ -> {:mobile_money_txn, :unknown}
  #   end
  # end
  # -----------------------------ZAMTEL END-------------------------------------------
end
