defmodule LoanmanagementsystemWeb.UssdController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Repo
#   alias Loanmanagementsystem.Transactions.Transaction
#   alias Loanmanagementsystem.Notifications.Sms
  alias Loanmanagementsystem.Ussd.UssdRequests
#   alias Loanmanagementsystem.Products.Product
  require Record
  import Ecto.Query, warn: false


  def index(conn, _params) do
      render(conn, "index.html")
  end








  def initiateUssd(conn, dd) do
      {:ok, body, _conn} = Plug.Conn.read_body(conn)
      IO.inspect  "-----------"
      IO.inspect  "Debug USSD Controller Starts here"
      IO.inspect  body
      IO.inspect dd,label: "Params"
    #   query_params = conn.query_params
    #   session_id = dd["session_id"]
      query_params = conn.query_params
      IO.inspect  Jason.encode!(query_params)
      mobile_number = dd["mobile_number"]
      text = dd["text"]

    #  query_params = conn.query_params
     # session_id = query_params["session_id"]
     # query_params = conn.query_params
     # IO.inspect  Jason.encode!(query_params)
     # mobile_number = query_params["mobile_number"]
     # text = query_params["text"]

      cmd = query_params["serviceCode"]
    #   orginal_short_code = cmd
      IO.inspect cmd

      #query = from au in UssdRequests, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
      #ussdRequests = Repo.all(query)

      # text = if (Enum.count(ussdRequests) == 0) do

      #     text = text <> "*"

      #     IO.inspect  "No Ussd Requests"
      #     IO.inspect  text

      #     ussdRequest = %UssdRequests{}
      #     ussdRequest = %UssdRequests{mobile_number: mobile_number, request_data: text, session_id: session_id, session_ended: 0}
      #     case Repo.insert(ussdRequest) do
      #         {:ok, ussdRequest} ->
      #             query = from au in UssdRequests, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
      #             ussdRequest = Repo.one(query)
      #             ussdRequest.request_data
      #         {:error, changeset} ->
      #             IO.inspect("Fail")
      #             nil
      #     end
      # else

      #     IO.inspect  "Ussd Requests Exist"

      #     IO.inspect  text

      #     text = String.trim_leading(text, "*")
      #     ussdRequest = Enum.at(ussdRequests, 0)

      #     IO.inspect ussdRequest.request_data
  # 	reqdat = ussdRequest.request_data

      #     reqdat = String.trim_trailing(reqdat, " ")

      #     text = reqdat <> text <> "*"

      #     text = String.replace(text, "*B*", "*b*")
      #     IO.inspect  text


      #     attrs = %{request_data: text}

      #     ussdRequest
      #     |> UssdRequests.changesetForUpdate(attrs)
      #     |> Repo.update()

      #     text
      # end

      query = from au in Loanmanagementsystem.Accounts.Account, where: au.mobile_number == ^mobile_number, select: au
      appusers = Repo.all(query)
      IO.inspect  Enum.count(appusers)


      tempText = text <> "*"
      text = if String.ends_with?(tempText, "*b*") do
          tempText = "*525#"

      else
          b_located = String.contains?(tempText, "*b*")
          text = if b_located == true do

              tempCheckMenu = String.split(tempText, "*b*")
              tempCheckMenuFirst = Enum.at(tempCheckMenu, 0)
              tempCheckMenuLength = Enum.count(tempCheckMenu)

              text = if Enum.count(tempCheckMenu) > 1 do

                  tempCheckMenuLast = Enum.at(tempCheckMenu, tempCheckMenuLength-1)
                  text = if String.length(tempCheckMenuLast) > 0 do
                      strlen_ = String.length(tempCheckMenuLast) - 1
                      tempCheckMenuLast = String.slice(tempCheckMenuLast, 0, strlen_)
                      tempText = "*244#*#{tempCheckMenuLast}"
                  else
                      text

                  end
              end
          else
              text

          end
      end

          if (Enum.count(appusers)>0) do
              welcome_menu(conn, mobile_number, cmd, text)
          else

              accountgen = Enum.random(1_0000000..9_9999999)
              accountgen = Integer.to_string(accountgen)
              accountNo = accountgen
              clientId = 1
              status = "ACTIVE"
              userId = 1
              mobile_number =  mobile_number
              account = %Loanmanagementsystem.Accounts.Account{
                  accountNo: accountNo,
                  clientId: clientId,
                  status: status,
                  userId: userId,
                  mobile_number: mobile_number
                  }
              case Repo.insert(account) do
                  {:ok, appUser} ->

                      # appUser = %Loanmanagementsystem.Accounts.User{username: mobile_number, clientId: clientId, status: "ACTIVE"}
                      # case Repo.insert(appUser) do
                      #     {:ok, appUser} ->

                          IO.inspect("==2222=================")
                          IO.inspect appUser
                          welcome_menu(conn, mobile_number, cmd, text)

                      #     {:error, changeset} ->
                      #         IO.inspect("Fail")
                      #         IO.inspect changeset
                      #         response = %{
                      #             Message: "Invalid input provided.",# Press\n\nb. Back\n0. Log Out",
                      #             ClientState: 1,
                      #             Type: "Response"
                      #         }
                      #     send_response(conn, response)
                      # end

                  {:error, changeset} ->
                      IO.inspect("Fail")
                      IO.inspect changeset
                      response = %{
                          Message: "CON Invalid input provided.",# Press\n\nb. Back\n0. Log Out",
                          ClientState: 1,
                          Type: "Response"
                      }
                  send_response(conn, response)
          end
      end

  end

  def welcome_menu(conn, mobile_number, cmd, text) do
      IO.inspect text
    #   orginal_short_code = cmd


      query = from au in Loanmanagementsystem.Accounts.User, where: au.username == ^mobile_number, select: au
      _users = Repo.all(query)
    #   user = Enum.at(users, 0)

          checkMenu = String.split(text, "*")
          checkMenuLength = Enum.count(checkMenu)
          IO.inspect(checkMenuLength)

          if checkMenuLength==2 do
              response = %{
                  Message: "CON Welome to Qfin Loans\n\n1. Request Loan\n2. Repay Loan\n3. Check Loan Balance \n4. Check Eligible Loan Amount \n5. Check Loan Requirements \n6. Transaction History\n0. End",
                  ClientState: 1,
                  Type: "Response"
              }
              send_response(conn, response)
          end
          if checkMenuLength>2 do
              valueEntered = Enum.at(checkMenu, (2))
              IO.inspect (valueEntered)
              case valueEntered do
                  "1" ->
                      IO.inspect ("handleLoanRequest")
                      handleLoanRequest(conn, mobile_number, cmd, text, checkMenu)
                  "2" ->
                      IO.inspect ("handleLoanRepayment")
                      handleLoanRepayment(conn, mobile_number, cmd, text, checkMenu)
                  "3" ->
                      IO.inspect ("handleCheckLoanBalance")
                      handleCheckLoanBalance(conn, mobile_number, cmd, text, checkMenu)
                  "4" ->
                      IO.inspect ("handleEligibleCalculator")
                      handleEligibleCalculator(conn, mobile_number, cmd, text, checkMenu)
                  "5" ->
                      IO.inspect ("handleCheckLoanRequirements")
                      handleCheckLoanRequirements(conn, mobile_number, cmd, text, checkMenu)
                  "6" ->
                      IO.inspect ("handleMyPin")
                      handleMyPin(conn, mobile_number, cmd, text, checkMenu)
                  # "0" ->
                  #     IO.inspect ("handleEndSession")
                  #     text = "Thank you and good bye"
        # 	#response = %{
        # 	#	Message: text,
        # 	#	ClientState: 1,
        # 	#	Type: "Response",
        # 	#	key: "END"
        # 	#}
        # 	response = text
        # 	send_response(conn, response)
        # _ ->
                  #     IO.inspect ("handleOtherResponse")
                  #     text = "Invaid number encountered\n\nPress \nb. Back \n0. End"
        # 	#response = %{
        # 	#	Message: text,
        # 	#	ClientState: 1,
        # 	#	Type: "Response",
        # 	#	key: "END"
        # 	#}
        # 	response = text
        # 	send_response(conn, response)


              end
          end
  end

  def end_session(ussdRequests, conn, response) do

  attrs = %{session_ended: 1}
  if(Enum.count(ussdRequests)>0) do
    ussdRequest = Enum.at(ussdRequests, 0)

    ussdRequest
    |> UssdRequests.changesetForUpdate(attrs)
    |> Repo.update()
  end

  send_response(conn, response)
end



  def handleLoanRequest(conn, mobile_number, cmd, text, checkMenu) do
      checkMenuLength = Enum.count(checkMenu)
      valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
      IO.inspect("handleGetLoan")
      IO.inspect(checkMenuLength)
      IO.inspect(valueEntered)
      IO.inspect(text)
      if valueEntered == "b" do
          response = %{
              Message: "BA3",
              ClientState: 1,
              Type: "Response"
          }
          send_response(conn, response)
      else
          # enterdAmount = :erlang.float_to_binary((enterdAmount), [decimals: 2])
          case checkMenuLength do
              3 ->
                  response = %{
                      Message: "CON Select Option \n\n1. Salary Advance \n2. Personal Loan \nb. Back",
                      ClientState: 1,
                      Type: "Response",
                      key: "CON"
                  }
                  send_response(conn, response)
              4 ->
                  valueEntered = Enum.at(checkMenu, (Enum.count(checkMenu)-1))
                  IO.inspect (valueEntered)
                  case valueEntered do
                      "1" ->
                          IO.inspect ("handleLoanRequest")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 1)
                      "2" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 2)
                  end
              5 ->
                  checkpaidtype = Enum.at(checkMenu, 3)
                  IO.inspect (checkpaidtype)
                  amountEntered = Enum.at(checkMenu, 4)

                  code = "QAOO1"
                  queryquickadvance = from au in Loanmanagementsystem.Products.Product, where: au.code == ^code, select: au
                  _getquickadvance = Repo.one(queryquickadvance)

                  case checkpaidtype do
                      "1" ->
                          response = %{
                              Message: "CON
                              Advance Amount: #{amountEntered}
                              Tenor to Pay Day: 1 Month
                              Interest Amount: 10%
                              Total Repayment Amount:  #{String.to_integer(amountEntered) + 10}
                              Repayment Date: 15-01-2023 \n1. Confirm \nb. Back",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      "2" ->
                          response = %{
                              Message: "CON Enter Tenor",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                  end

              6 ->
                  checkpaidtype = Enum.at(checkMenu, 3)
                  IO.inspect (checkpaidtype)

                  amountEntered = Enum.at(checkMenu, 4)
                  tenor = Enum.at(checkMenu, 5)
                  case checkpaidtype do
                      "1" ->
                          response = %{
                              Message: "CON Your loan request was successful. You account will be credited shortly. Thank you.",

                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      "2" ->
                          response = %{
                              Message: "CON
                              Loan Amount: #{amountEntered}
                              Total Interest Amount: K300
                              Total: K800
                              Tenor: #{tenor}
                              Repayment/Month: K267 \n1. Confirm \nb. Back",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                  end
              7 ->

                  checkpaidtype = Enum.at(checkMenu, 3)
                  IO.inspect (checkpaidtype)
                  case checkpaidtype do
                      "1" ->
                          response = %{
                              Message: "CON Your loan request was successful. You account will be credited shortly. Thank you.",

                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      "2" ->
                          response = %{
                              Message: "CON
                              Your loan request was successful. You account will be credited shortly. Thank you.",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                  end

          end
      end
  end

  def handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, type) do
      if type==1 do
          handleQuickLoan(conn, mobile_number, cmd, text, checkMenu)
      else
          handleQuickLoan(conn, mobile_number, cmd, text, checkMenu)
      end
  end

  def handleQuickLoan(conn, _mobile_number, _cmd, text, checkMenu) do
      checkMenuLength = Enum.count(checkMenu)
      valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
      IO.inspect("handleGetLoan")
      IO.inspect(checkMenuLength)
      IO.inspect(valueEntered)
      IO.inspect(text)
      if valueEntered == "b" do
          response = %{
              Message: "BA3",
              ClientState: 1,
              Type: "Response"
          }
          send_response(conn, response)
      else
          case checkMenuLength do
              4 ->
                  checkpaidtype = Enum.at(checkMenu, 3)
                  if checkpaidtype == "1" do
                      response = %{
                          Message: "CON Enter Loan Amount",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)
                  else
                      response = %{
                          Message: "CON Enter Loan Amount",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)
                  end
          end
      end
  end

  def handleLoanRepayment(conn, _mobile_number, _cmd, text, checkMenu) do
      checkMenuLength = Enum.count(checkMenu)
      valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
      IO.inspect("handleGetLoan")
      IO.inspect(checkMenuLength)
      IO.inspect(valueEntered)
      IO.inspect(text)
      if valueEntered == "b" do
          response = %{
              Message: "BA3",
              ClientState: 1,
              Type: "Response"
          }
          send_response(conn, response)
      else
          case checkMenuLength do
              3 ->
                      response = %{
                      Message: "CON LOAN REPAYMENT

                      You Current Loan Balance ZMW110
                      Due Date: 15-01-2023

                      Enter  Repayment Amount",
                      ClientState: 1,
                      Type: "Response",
                      key: "CON"
                  }
                  send_response(conn, response)

              4 ->
                amountEntered = Enum.at(checkMenu, 3)
                  text = "CON Your request to pay back ZMW#{amountEntered} \n1. Proceed \nb. Back"
                      response = %{
                          Message: text,
                          ClientState: 1,
                          Type: "Response"
                      }
                  send_response(conn, response)

              5 ->
                text = "CON A pin prompt has been sent to your mobile number to complete the transaction. Thank you. \nb. Back"
                response = %{
                    Message: text,
                    ClientState: 1,
                    Type: "Response"
                }
            send_response(conn, response)
          end
      end

  end

  def handleRepaymentMode(conn, mobile_number, cmd, text, checkMenu, type) do
      if type==1 do
          handleRepaymentModeOption(conn, mobile_number, cmd, text, checkMenu)
      else
          handleRepaymentModeOption(conn, mobile_number, cmd, text, checkMenu)
      end
  end

  def handleRepaymentModeOption(conn, _mobile_number, _cmd, text, checkMenu) do
      checkMenuLength = Enum.count(checkMenu)
      valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
      IO.inspect("handleGetLoan")
      IO.inspect(checkMenuLength)
      IO.inspect(valueEntered)
      IO.inspect(text)
      if valueEntered == "b" do
          response = %{
              Message: "BA3",
              ClientState: 1,
              Type: "Response"
          }
          send_response(conn, response)
      else
          case checkMenuLength do
              5 ->
                  checkpaidtype = Enum.at(checkMenu, 4)
                  IO.inspect "chekkkkkkkkkkkkkkkkkkks"
                  IO.inspect checkpaidtype
                  if checkpaidtype == "1" do
                      response = %{
                          Message: "CON You Are about to repay ZMW 100 \n1. Comfirm \nb. Back",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)
                  else
                      response = %{
                          Message: "CON Enter Account Number",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)
                  end
          end
      end
  end


  def handleCheckLoanBalance(conn, _mobile_number, _cmd, text, checkMenu) do
      checkMenuLength = Enum.count(checkMenu)
      valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
      IO.inspect("handleGetLoan")
      IO.inspect(checkMenuLength)
      IO.inspect(valueEntered)
      IO.inspect(text)
      if valueEntered == "b" do
          response = %{
              Message: "BA3",
              ClientState: 1,
              Type: "Response"
          }
          send_response(conn, response)
      else
          case checkMenuLength do
              3 ->

                  msg = "CON LOAN BALANCE

                      Loan Balance: K110
                      Due Date: 15-01-2023
                      Debit Mandate ID: PD00000001
                      Loan Account Status: Active."

                  response = %{
                      Message: msg <> "\n\nb. Back",
                      ClientState: 1,
                      Type: "Response",
                      key: "CON"
                  }
                  send_response(conn, response)
          end
      end
  end

  def handleEligibleCalculator(conn, _mobile_number, _cmd, text, checkMenu) do
      checkMenuLength = Enum.count(checkMenu)
      valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
      IO.inspect("handleGetLoan")
      IO.inspect(checkMenuLength)
      IO.inspect(valueEntered)
      IO.inspect(text)
      if valueEntered == "b" do
          response = %{
              Message: "BA3",
              ClientState: 1,
              Type: "Response"
          }
          send_response(conn, response)
      else
          case checkMenuLength do
              3 ->

                  msg = "CON ELIGIBLE LOAN AMOUNT

                  You Are Eligible to get upto Loan Amount: K500"

                  response = %{
                      Message: msg <> "\n\nb. Back",
                      ClientState: 1,
                      Type: "Response",
                      key: "CON"
                  }
                  send_response(conn, response)
          end
      end
  end

  def handleCheckLoanRequirements(conn, _mobile__number, _cmd, text, checkMenu) do
      checkMenuLength = Enum.count(checkMenu)
      valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
      IO.inspect("handleGetLoan")
      IO.inspect(checkMenuLength)
      IO.inspect(valueEntered)
      IO.inspect(text)
      if valueEntered == "b" do
          response = %{
              Message: "BA3",
              ClientState: 1,
              Type: "Response"
          }
          send_response(conn, response)
      else
          case checkMenuLength do
              3 ->
                      msg = "CON LOAN REQUIREMENTS \n
                          1. NRC
                          2. Latest Payslip
                          3. Latest Bank Statement
                          4. Letter of Introduction from Employer

                          Email: info.documents@gmail.com
                          WhatsApp: +260977548025"

                      response = %{
                          Message: msg <> "\nb. Back ",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)
          end
      end
  end

  def handleMyPin(conn, _mobile_number, _cmd, text, checkMenu) do
      checkMenuLength = Enum.count(checkMenu)
      valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
      IO.inspect("handleGetLoan")
      IO.inspect(checkMenuLength)
      IO.inspect(valueEntered)
      IO.inspect(text)
      if valueEntered == "b" do
          response = %{
              Message: "BA3",
              ClientState: 1,
              Type: "Response"
          }
          send_response(conn, response)
      else
          case checkMenuLength do
              # 3 ->
              #     response = %{
              #         Message: "CON Enter Prepaid Meter Number",
              #         ClientState: 1,
              #         Type: "Response",
              #         key: "CON"
              #     }
              #     send_response(conn, response)
              3 ->
                  # checkmeternumber = Enum.at(checkMenu, 3)
                  # query = from cl in Loanmanagementsystem.Tokens.PrepaidTokens,
                  #     where: (cl.mobile_number == ^mobile_number),
                  #     limit: 1,
                  #     order_by: fragment("? DESC", cl.inserted_at),
                  #     select: cl
                  # gettokens = Repo.all(query)
                  # gettok = Enum.at(gettokens, 0)

                  # # gettok = for gettokens <- gettokens do

                  # #         "#{gettokens.token}"
                  # # end
                  # # [a, b, c, d, e] = gettok

                  # # msg = Enum.reduce(gettok, msg, fn t, a->  a<>"#{t},\n" end)
                  # if Enum.count(gettokens)>0 do

                  #     datetime = gettok.inserted_at
                  #     datetime = to_string(datetime)
                  #     datetime = String.split(datetime, " ")
                  #     date = Enum.at(datetime, 0)
                  #     time = Enum.at(datetime, 1)
                  #     time = String.slice(time, 0..-4)

                      msg = "CON LMS Most Recent Transaction
                          Account: 0120012000812
                          Amount: 100
                          Interest: 10%
                          Date: 15-12-2022"

                      response = %{
                          Message: msg <> "\nb. Back \n0. End",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)

                  # else
                  #     response = %{
                  #         Message: "CON They are no tokens for the prepaid meter number provided. \n\nb. Back \n0. End",
                  #         ClientState: 1,
                  #         Type: "Response",
                  #         key: "CON"
                  #     }
                  #     send_response(conn, response)
                  # end
          end
      end
  end

  # LoanmanagementsystemWeb.UssdController.calculate_monthly_repayments(100, 60, 10, 365, 1)
  def calculate_monthly_repayments(amount, period, rate, _annual_period, number_of_repayments) do
      IO.inspect "################"
      IO.inspect amount
      IO.inspect number_of_repayments
      rate = rate/100
      rate_ = (rate/12)
      nperiod = period/12
      IO.inspect "+++++++++++++++++"
      IO.inspect rate_
      totalRepay = amount * (1 + (rate*nperiod))
      _interest = totalRepay - amount

      _totalRepayable = 0.00;
      _y = 1;


      rate__ = (1+rate_);
      raisedVal = :math.pow(rate__, (number_of_repayments))
      IO.inspect raisedVal
      a = rate_*raisedVal
      b = raisedVal - 1
      _c = a/b
      totalPayableInMonthX = amount * rate;
      IO.inspect totalPayableInMonthX
      #realMonthlyRepayment = amount * (rate_) * (1)
      totalPayableInMonthX =  totalPayableInMonthX + amount
      totalPayableInMonthX
  end

  def send_response(conn, response) do
      IO.inspect  "Test!"
      IO.inspect  Jason.encode!(response)
      send_resp(conn, :ok, Jason.encode!(response))
  end

end
