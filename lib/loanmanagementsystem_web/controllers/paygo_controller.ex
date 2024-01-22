defmodule LoanmanagementsystemWeb.PaygoController do\
 use LoanmanagementsystemWeb, :controller
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
  # -----------------------------ZAMTEL END-------------------------------------------
end
