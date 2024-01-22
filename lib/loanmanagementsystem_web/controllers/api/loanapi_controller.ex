defmodule LoanmanagementsystemWeb.LoanapiController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Security.ParamsValidator
  alias Loanmanagementsystem.LoanServices.Loan
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Products.Product

  def list_all_customer_loans(conn, params) do
    json(conn, Loan.list_loan_details(conn, params))
  end

  def list_company_staff(conn, params) do
    json(conn, Loan.list_all_company_staff(conn, params))
  end



  def loan_counts_details(conn, params) do
    json(conn, Loan.loan_counts_details(conn, params))
  end

  def loan_application(conn, params) do
    ParamsValidator.validate(conn, params, %{
      "requested_amount" => :string,
      "loan_duration_month" => :string,
      "product_id" => :string,
    })
    |> case do
      {:error, conn, message} -> respond(conn, message, :bad_request)
      {:ok, conn} ->
        #  prepared_params = prepare_loan_application_params(conn, params)
         json(conn, Loan.handle_loan_application(conn, params))
    end
  end

  def prepare_loan_application_params(conn, params) do
    customer_id = conn.assigns.current_user.id
    userbio = try do UserBioData.find_by(userId: customer_id) rescue _->  "" end
    product_details = try do Product.find_by(id: params["product_id"]) rescue _->  "" end
    term_in_months = try do
      case String.contains?(String.trim(params["loan_period"]), ".") do
          true ->  String.trim(params["loan_period"]) |> String.to_float()
          false ->  String.trim(params["loan_period"]) |> String.to_integer() end
      rescue _-> 0 end
    loan_amount = try do
      case String.contains?(String.trim(params["loan_amount"]), ".") do
          true ->  String.trim(params["loan_amount"]) |> String.to_float()
          false ->  String.trim(params["loan_amount"]) |> String.to_integer() end
      rescue _-> 0 end
    monthly_interest_rate = product_details.interest / 100
    payment = loan_amount * (monthly_interest_rate / (1 - :math.pow(1 + monthly_interest_rate, -term_in_months)))
    monthly_installment = Float.round(payment, 2)
    total_pay_amount = monthly_installment * term_in_months
    total_interest_amount = total_pay_amount - loan_amount
    %{

      first_name: userbio.firstName,
      last_name: userbio.lastName,
      phone: userbio.mobileNumber,
      email: userbio.emailAddress,
      customer_id: customer_id,
      loan_amount: params["loan_amount"],
      loan_period: params["loan_period"],
      product: product_details.name,
      product_interet_rate: product_details.interest,
      product_id: product_details.id,
      pay_monthly: monthly_installment,
      total_interest: total_interest_amount,
      total_pay_back: total_pay_amount,
      status: "PENDING"
    }
  end



  def get_loans_by_userid(conn, params) do
    json(conn, Loan.get_loans_by_userid(conn, params))
  end

  def get_last_five_loan_by_userid(conn, params) do
    json(conn, Loan.get_last_five_loan_by_userid(conn, params))
  end

  def get_loan_by_loan_id(conn, params) do
    json(conn, Loan.get_loan_by_loan_id(conn, params))
  end

  def get_360_view_by_user_id(conn, params) do
    json(conn, Loan.get_360_view_by_userid(conn, params))
  end

  def get_mini_statement_by_user_id(conn, params) do
    json(conn, Loan.get_mini_statement_by_user_id(conn, params))
  end

  def get_historical_statement_by_user_id(conn, params) do
    json(conn, Loan.get_historical_statement_by_user_id(conn, params))
  end


  def get_customer_relationship_officer(conn, params) do
    json(conn, Loan.get_customer_relationship_officer(conn, params))
  end

  def respond(conn, message, status \\ :bad_request),
  do: put_status(conn, status) |> json(message)

end
