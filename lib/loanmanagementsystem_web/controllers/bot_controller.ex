defmodule LoanmanagementsystemWeb.BotController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.LoanTransaction
  require Record
  import Ecto.Query, warn: false

  def index(conn, _params) do
    render(conn, "index.html")
  end





  def initiateBot(conn, params) do
    # {:ok, body} = params
    # IO.inspect  "-----------"
    # IO.inspect  "Debug BOT Controller Starts here"
    # IO.inspect  body
    # IO.inspect params,label: "Params"
    # query_params = conn.query_params
    # session_id = dd["session_id"]
    query_params = conn.query_params
    # mobile_number = params["first_name"]
    # text = dd["text"]

    IO.inspect("==2222=================")
    IO.inspect(query_params)
    welcome_menu(conn, params, query_params)
  end

  def welcome_menu(conn, params, query_params) do
    response =
      "Hi! #{query_params["first_name"]} #{query_params["last_name"]} \nWelome to PBS Loans \n\n1. Request Loan\n2. Repay Loan\n3. Check Loan Balance \n4. Check Eligible Loan Amount \n5. Check Loan Requirements \n6. My PIN\n0. End"

    send_response(conn, response)
  end

  def handlePayment(conn, _params) do
    response = "Enter Meter Number"
    send_response(conn, response)
  end

  def handleBalance(conn, _params) do
    response = "Enter Meter Number"
    send_response(conn, response)
  end

  def handleAccountBalance(conn, _params) do
    mobile_number = "260978242442"

    query =
      from cl in Loanmanagementsystem.Loan.LoanTransaction,
        where: cl.mno_mobile_no == ^mobile_number,
        limit: 5,
        order_by: fragment("? DESC", cl.inserted_at),
        select: cl

    sq = Repo.all(query)
    # gettok = Enum.at(gettokens, 0)

    # query = from au in Loanmanagementsystem.Transactions.Transaction, where: au.tnxMobileNumber == ^mobile_number, select: au
    # sq = Repo.all(query);

    setcomplainttype = []

    setcomplainttype =
      for {k, v} <- Enum.with_index(sq) do
        # Logger.info (k.id)

        datetime = k.inserted_at
        datetime = to_string(datetime)
        datetime = String.split(datetime, " ")
        date = Enum.at(datetime, 0)
        time = Enum.at(datetime, 1)
        time = String.slice(time, 0..-4)

        transaction_type_enum = k.transaction_type_enum
        amount = k.amount
        settlementStatus = k.settlementStatus
        outstanding_loan_balance_derived = k.outstanding_loan_balance_derived
        interest_portion_derived = k.interest_portion_derived
        qn =
          "#{v + 1}. " <>
            "Loan ID: 120002321922884 \n     Principal Amount: #{Formatter.format_number(:erlang.float_to_binary(amount, [{:decimals, 2}]))} \n     Interest Amount: #{Formatter.format_number(:erlang.float_to_binary(interest_portion_derived, [{:decimals, 2}]))} \n     Total Amount: #{Formatter.format_number(:erlang.float_to_binary(outstanding_loan_balance_derived, [{:decimals, 2}]))} \n     Date: #{date} #{time} hrs \n     Status: #{settlementStatus} \n"

        setcomplainttype = setcomplainttype ++ [qn]
        setcomplainttype
      end

    if Enum.count(setcomplainttype) > 0 do
      optionsList = ""
      optionsList = Enum.join(setcomplainttype, "\n")

      IO.inspect(optionsList)

      response = "Your current active loans. \n\n" <> optionsList
      send_response(conn, response)
    else
      response =
        "They are currently no transactions performed on this mobile number. \n\nb. Main Menu"

      send_response(conn, response)
    end
  end

  def handleTransactionHistory(conn, _params) do
    mobile_number = "260978242442"

    query =
      from cl in Loanmanagementsystem.Transactions.Transaction,
        where: cl.tnxMobileNumber == ^mobile_number,
        limit: 5,
        order_by: fragment("? DESC", cl.inserted_at),
        select: cl

    sq = Repo.all(query)
    # gettok = Enum.at(gettokens, 0)

    # query = from au in Loanmanagementsystem.Transactions.Transaction, where: au.tnxMobileNumber == ^mobile_number, select: au
    # sq = Repo.all(query);

    setcomplainttype = []

    setcomplainttype =
      for {k, v} <- Enum.with_index(sq) do
        # Logger.info (k.id)

        datetime = k.inserted_at
        datetime = to_string(datetime)
        datetime = String.split(datetime, " ")
        date = Enum.at(datetime, 0)
        time = Enum.at(datetime, 1)
        time = String.slice(time, 0..-4)

        meternumber = k.meternumber
        paymentAmount = k.paymentAmount
        settlementStatus = k.settlementStatus
        # complainttype = k.meternumber
        qn =
          "#{v + 1}. " <>
            "Meter Number: #{meternumber} \n Amount: #{paymentAmount} \n Date: #{date} #{time} hrs \n Status: #{settlementStatus} \n"

        setcomplainttype = setcomplainttype ++ [qn]
        setcomplainttype
      end

    if Enum.count(setcomplainttype) > 0 do
      optionsList = ""
      optionsList = Enum.join(setcomplainttype, "\n")

      IO.inspect(optionsList)

      response = "Your Last 5 Transactions. \n\n" <> optionsList <> "\nb. Main Menu"
      send_response(conn, response)
    else
      response =
        "They are currently no transactions performed on this mobile number. \n\nb. Main Menu"

      send_response(conn, response)
    end
  end

  def end_session(ussdRequests, conn, response) do
    attrs = %{session_ended: 1}

    if(Enum.count(ussdRequests) > 0) do
      ussdRequest = Enum.at(ussdRequests, 0)

      ussdRequest
      |> UssdRequests.changesetForUpdate(attrs)
      |> Repo.update()
    end

    send_response(conn, response)
  end

  # def send_response(conn, response) do
  #     IO.inspect  "Test!"
  #     IO.inspect  Jason.encode!(response)
  #     send_resp(conn, :ok, Jason.encode!(response))
  # end

  def send_response(conn, response) do
    IO.inspect("Test222222!")
    IO.inspect(Jason.encode!(response))
    # IO.inspect response[:Message];
    # send_resp(conn, :ok, Jason.encode!(response))

    # put_resp_header(conn, "Content-type", "text/html; charset=utf-8");
    # put_resp_header(conn, "Freeflow", "FC");
    # send_resp(conn, :ok, response)

    conn
    |> put_status(:ok)
    # |> put_resp_header("Freeflow", "FC")
    |> put_resp_header("Freeflow", "FC")
    # |> text("")
    |> send_resp(:ok, response)
  end
end
