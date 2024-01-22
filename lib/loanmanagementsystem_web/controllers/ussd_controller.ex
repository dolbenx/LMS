defmodule LoanmanagementsystemWeb.UssdController do
    use LoanmanagementsystemWeb, :controller
    alias Loanmanagementsystem.Repo
    alias Loanmanagementsystem.Transactions.Transaction
    alias Loanmanagementsystem.Notifications.Sms
    alias Loanmanagementsystem.Ussd.UssdRequests
    alias Loanmanagementsystem.Products.Product
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
        query_params = conn.query_params
        session_id = dd["session_id"]
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
        orginal_short_code = cmd
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
        orginal_short_code = cmd
        IO.inspect(orginal_short_code)


        query = from au in Loanmanagementsystem.Accounts.User, where: au.username == ^mobile_number, select: au
        users = Repo.all(query)
        user = Enum.at(users, 0)

            checkMenu = String.split(text, "*")
            checkMenuLength = Enum.count(checkMenu)
            IO.inspect(checkMenuLength)

            if checkMenuLength==2 do
                response = %{
                    Message: "CON Welcome to Qfin\n\n1. Get Quick Advance\n2. Get Quick Loan\n3. Repay Loan \n4. Check Loan Balance \n5. Request Statement \n6. My PIN \n7. Contact Us \n Do More!",
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
                          handleLoanQickLoan(conn, mobile_number, cmd, text, checkMenu)
                      "3" ->
                          IO.inspect ("handleLoanRepayment")
                          handleLoanRepayment(conn, mobile_number, cmd, text, checkMenu)
                      "4" ->
                          IO.inspect ("handleCheckLoanBalance")
                          handleCheckLoanBalance(conn, mobile_number, cmd, text, checkMenu)
                      "5" ->
                          IO.inspect ("handleLoanStatement")
                          handleLoanStatement(conn, mobile_number, cmd, text, checkMenu)
                      "6" ->
                          IO.inspect ("handleMyPin")
                          handleMyPin(conn, mobile_number, cmd, text, checkMenu)
                      "7" ->
                          IO.inspect ("ContactUs")
                          contactUs(conn, mobile_number, cmd, text, checkMenu)
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
        IO.inspect(cmd)
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
                        Message: "CON Select Option \n\n1. Get Cash \n2. Buy Airtime \n3. Buy Electricity \n4. Pay TV Subscription \n5. Buy Fuel \n6. Buy Groceries \nb. Back",
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

                        "3" ->
                            IO.inspect ("handleLoanRepayment")
                            handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 3)

                        "4" ->
                              IO.inspect ("handleLoanRequest")
                              handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 4)

                        "5" ->
                              IO.inspect ("handleLoanRepayment")
                              handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 5)

                        "6" ->
                              IO.inspect ("handleLoanRepayment")
                              handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 6)
                    end

                5 ->

                  checkpaidtype = Enum.at(checkMenu, 3)
                  case checkpaidtype do

                      "1" ->
                          IO.inspect ("handleLoanRequest")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 1)

                      "2" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 2)

                      "3" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 3)

                      "4" ->
                            IO.inspect ("handleLoanRequest")
                            handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 4)

                      "5" ->
                            IO.inspect ("handleLoanRepayment")
                            handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 5)

                      "6" ->
                            IO.inspect ("handleLoanRepayment")
                            handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 6)
                  end

                6 ->
                  checkpaidtype = Enum.at(checkMenu, 3)
                  case checkpaidtype do
                      "1" ->
                          IO.inspect ("handleLoanRequest")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 1)

                      "2" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 2)

                      "3" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 3)

                      "4" ->
                            IO.inspect ("handleLoanRequest")
                            handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 4)

                      "5" ->
                            IO.inspect ("handleLoanRepayment")
                            handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 5)

                      "6" ->
                            IO.inspect ("handleLoanRepayment")
                            handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 6)
                  end
                7 ->

                  checkpaidtype = Enum.at(checkMenu, 3)
                  case checkpaidtype do
                      "1" ->
                          IO.inspect ("handleLoanRequest")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 1)

                      "2" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 2)

                      "3" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 3)

                      "4" ->
                            IO.inspect ("handleLoanRequest")
                            handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 4)

                      "5" ->
                            IO.inspect ("handleLoanRepayment")
                            handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 5)

                      "6" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 6)
                  end

              8 ->

                  checkpaidtype = Enum.at(checkMenu, 3)
                  case checkpaidtype do
                      "1" ->
                          IO.inspect ("handleLoanRequest")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 1)

                      "2" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 2)

                      "3" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 3)

                      "4" ->
                          IO.inspect ("handleLoanRequest")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 4)

                      "5" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 5)

                      "6" ->
                          IO.inspect ("handleLoanRepayment")
                          handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, 6)
                  end

            end
        end
    end

    def handleQuickLoanRequest(conn, mobile_number, cmd, text, checkMenu, type) do
        case type do
          1 ->
              handleQuickLoan(conn, mobile_number, cmd, text, checkMenu)

          2 ->
              handleLoanAirtime(conn, mobile_number, cmd, text, checkMenu)

          3 ->
              handleLoanElectricity(conn, mobile_number, cmd, text, checkMenu)

          4 ->
              handleLoanAirtime(conn, mobile_number, cmd, text, checkMenu)

          5 ->
              handleLoanAirtime(conn, mobile_number, cmd, text, checkMenu)

          6 ->
              handleLoanAirtime(conn, mobile_number, cmd, text, checkMenu)
        end
    end

    def handleQuickLoan(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(cmd)
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
                      end

                  5 ->
                      checkpaidtype = Enum.at(checkMenu, 3)
                      if checkpaidtype == "1" do
                          response = %{
                              Message: "CON Advance Amount: 500
                              Tenor to Pay Day: 1 Month
                              Interest Amount: 10%
                              Total Repayment Amount:  1000
                              Repayment Date: 15-01-2023 \n1. Request Loan \nb. Cancel",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      end

                  6 ->
                      checkpaidtype = Enum.at(checkMenu, 3)
                      if checkpaidtype == "1" do
                          response = %{
                              Message: "CON Select Account \n1. Bank Account \n2. Mobile Money Wallet \nb. Back",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      end

                  7 ->

                      checkpaidtype = Enum.at(checkMenu, 3)
                      valueEntered = Enum.at(checkMenu, 6)

                      if checkpaidtype == "1" do
                          case valueEntered do

                              "1" ->
                                  response = %{
                                      Message: "CON Enter Bank Account Number \nb. Back",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)

                              "2" ->
                                  response = %{
                                      Message: "CON Enter Mobile Number \nb. Back",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)
                          end
                      end

                  8 ->

                      checkpaidtype = Enum.at(checkMenu, 3)
                      valueEntered = Enum.at(checkMenu, 6)

                      if checkpaidtype == "1" do
                          case valueEntered do

                              "1" ->
                                  response = %{
                                      Message: "CON Your Accoutn XXXX-XXXXX-XXXX-0932 will be credited with K500 \nb. Back",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)

                              "2" ->
                                  response = %{
                                      Message: "CON You mobile #{mobile_number} will be credited with K500 \nb. Back",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)
                          end
                      end
            end
        end
    end


      def handleLoanAirtime(conn, mobile_number, cmd, text, checkMenu) do
          checkMenuLength = Enum.count(checkMenu)
          valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
          IO.inspect("handleGetLoan")
          IO.inspect(checkMenuLength)
          IO.inspect(cmd)
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
                      if checkpaidtype == "2" do
                          response = %{
                              Message: "CON Select Service Provider \n1. MTN \n2. Airtel \n3. Zamtel",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      end

                  5 ->
                      checkpaidtype = Enum.at(checkMenu, 3)
                      checkNetworkProvider = Enum.at(checkMenu, 4)

                      if checkpaidtype == "2" do

                          case checkNetworkProvider do

                              "1" ->
                                  response = %{
                                      Message: "CON Enter MTN Mobile number",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)

                              "2" ->
                                  response = %{
                                      Message: "CON Enter Airtel Mobile number",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)

                              "3" ->
                                  response = %{
                                      Message: "CON Enter Zamtel Mobile number",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)
                          end

                      end

                  6 ->

                      checkpaidtype = Enum.at(checkMenu, 3)
                      if checkpaidtype == "2" do
                          response = %{
                              Message: "CON Enter Amount",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      end

                  7 ->

                      checkpaidtype = Enum.at(checkMenu, 3)
                      checkNetworkProvider = Enum.at(checkMenu, 4)
                      airtimeAmount = Enum.at(checkMenu, 6)
                      airtimeAmount = String.to_integer(airtimeAmount)
                      topupNumber = Enum.at(checkMenu, 6)

                      if checkpaidtype == "2" do

                          case checkNetworkProvider do

                              "1" ->

                                  response = %{
                                      Message: "CON Service Provider: MTN
                                      Mobile Number: #{topupNumber}
                                      Airtime Amount: K#{airtimeAmount}
                                      Facility Fee: K1
                                      Repayment Amount: K#{airtimeAmount + 1}
                                      Repayment Date: 30-06-2023
                                      \n1. Request Loan \n2. Cancel",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)

                              "2" ->

                                  response = %{
                                      Message: "CON Service Provider: Airtel
                                      Mobile Number: #{topupNumber}
                                      Airtime Amount: K#{airtimeAmount}
                                      Facility Fee: K1
                                      Repayment Amount: K#{airtimeAmount + 1}
                                      Repayment Date: 30-06-2023
                                      \n1. Request Loan \n2. Cancel",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)

                              "3" ->

                                  response = %{
                                      Message: "CON Service Provider: Zamtel
                                      Mobile Number: #{topupNumber}
                                      Airtime Amount: K#{airtimeAmount}
                                      Facility Fee: K1
                                      Repayment Amount: K#{airtimeAmount + 1}
                                      Repayment Date: 30-06-2023
                                      \n1. Request Loan \n2. Cancel",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)
                          end
                      end

                  8 ->

                      checkpaidtype = Enum.at(checkMenu, 3)
                      if checkpaidtype == "2" do
                          response = %{
                              Message: "CON Successfully purched airtime.",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      end

              end
          end
      end

      def handleLoanElectricity(conn, mobile_number, cmd, text, checkMenu) do
          checkMenuLength = Enum.count(checkMenu)
          valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
          IO.inspect("handleGetLoan")
          IO.inspect(checkMenuLength)
          IO.inspect(cmd)
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
                      if checkpaidtype == "2" do
                          response = %{
                              Message: "CON Select Service \n1. ZESCO",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      end

                  5 ->
                      checkpaidtype = Enum.at(checkMenu, 3)
                      checkNetworkProvider = Enum.at(checkMenu, 4)

                      if checkpaidtype == "2" do

                          case checkNetworkProvider do

                              "1" ->
                                  response = %{
                                      Message: "CON Enter Meter Number",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)
                          end

                      end

                  6 ->

                      checkpaidtype = Enum.at(checkMenu, 3)
                      if checkpaidtype == "2" do
                          response = %{
                              Message: "CON Enter Amount",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      end

                  7 ->

                      checkpaidtype = Enum.at(checkMenu, 3)
                      checkProvider = Enum.at(checkMenu, 4)
                      electricityAmount = Enum.at(checkMenu, 6)
                      electricityAmount = String.to_integer(electricityAmount)
                      meterNumber = Enum.at(checkMenu, 6)

                      if checkpaidtype == "2" do

                          case checkProvider do

                              "1" ->

                                  response = %{
                                      Message: "CON Service Provider: ZESCO
                                      Meter Number: #{meterNumber}
                                      Electricity Amount: K#{electricityAmount}
                                      Facility Fee: K10
                                      Repayment Amount: K#{electricityAmount + 10}
                                      Repayment Date: 30-06-2023
                                      \n1. Request Loan \n2. Cancel",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "CON"
                                  }
                                  send_response(conn, response)
                          end
                      end

                  8 ->

                      checkpaidtype = Enum.at(checkMenu, 3)
                      meterNumber = Enum.at(checkMenu, 6)
                      if checkpaidtype == "2" do
                          response = %{
                              Message: "CON Successfully purched electricty for #{meterNumber}.",
                              ClientState: 1,
                              Type: "Response",
                              key: "CON"
                          }
                          send_response(conn, response)
                      end

              end
          end
      end

      def handleLoanQickLoan(conn, mobile_number, cmd, text, checkMenu) do
          checkMenuLength = Enum.count(checkMenu)
          valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
          IO.inspect("handleGetLoan")
          IO.inspect(checkMenuLength)
          IO.inspect(cmd)
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
                            Message: "CON Enter Loan Amount",
                            ClientState: 1,
                            Type: "Response",
                            key: "CON"
                        }
                        send_response(conn, response)

                    4 ->
                          text = "CON Select Tenor
                          1. 3 Months Loan
                          2. 6 Months Loan
                          3. 9 Months Loan
                          4. 12 Months Loan
                          \n\nb. Back"
                              response = %{
                                  Message: text,
                                  ClientState: 1,
                                  Type: "Response"
                              }
                          send_response(conn, response)

                    5 ->
                        amountEntered = Enum.at(checkMenu, 3)
                        amountEntered = String.to_integer(amountEntered)
                        selectedOption = Enum.at(checkMenu, 4)

                        case selectedOption do

                            "1" ->
                                  interest = LoanmanagementsystemWeb.UssdController.calculate_loan_interest(amountEntered, 10, 3)
                                  monthlyInstalments = LoanmanagementsystemWeb.UssdController.calculate_monthly_repayment(amountEntered, 10, 3)
                                  totalAmount = Float.to_string(String.to_float(amountEntered + interest))
                                  text = "CON Loan Amount: K#{amountEntered}
                                  Loan Tenor: 3 Months
                                  Monthly Instalment: K#{monthlyInstalments}
                                  Total Repayment Amount: K#{totalAmount}
                                  1. Request Loan
                                  2. Cancel"
                                      response = %{
                                          Message: text,
                                          ClientState: 1,
                                          Type: "Response"
                                      }
                                  send_response(conn, response)

                            "2" ->
                                  interest = LoanmanagementsystemWeb.UssdController.calculate_loan_interest(amountEntered, 10, 6)
                                  monthlyInstalments = LoanmanagementsystemWeb.UssdController.calculate_monthly_repayment(amountEntered, 10, 6)
                                  totalAmount = Float.to_string(String.to_float(amountEntered + interest))
                                  text = "CON Loan Amount: K#{amountEntered}
                                  Loan Tenor: 6 Months
                                  Monthly Instalment: K#{monthlyInstalments}
                                  Total Repayment Amount: K#{totalAmount}
                                  1. Request Loan
                                  2. Cancel"
                                      response = %{
                                          Message: text,
                                          ClientState: 1,
                                          Type: "Response"
                                      }
                                  send_response(conn, response)

                              "3" ->
                                  interest = LoanmanagementsystemWeb.UssdController.calculate_loan_interest(amountEntered, 10, 9)
                                  monthlyInstalments = LoanmanagementsystemWeb.UssdController.calculate_monthly_repayment(amountEntered, 10, 9)
                                  totalAmount = Float.to_string(String.to_float(amountEntered + interest))
                                  text = "CON Loan Amount: K#{amountEntered}
                                  Loan Tenor: 9 Months
                                  Monthly Instalment: K#{monthlyInstalments}
                                  Total Repayment Amount: K#{totalAmount}
                                  1. Request Loan
                                  2. Cancel"
                                      response = %{
                                          Message: text,
                                          ClientState: 1,
                                          Type: "Response"
                                      }
                                  send_response(conn, response)

                              "4" ->
                                  interest = LoanmanagementsystemWeb.UssdController.calculate_loan_interest(amountEntered, 10, 12)
                                  monthlyInstalments = LoanmanagementsystemWeb.UssdController.calculate_monthly_repayment(amountEntered, 10, 12)
                                  totalAmount = Float.to_string(String.to_float(amountEntered + interest))
                                  text = "CON Loan Amount: K#{amountEntered}
                                  Loan Tenor: 12 Months
                                  Monthly Instalment: K#{monthlyInstalments}
                                  Total Repayment Amount: K#{totalAmount}
                                  1. Request Loan
                                  2. Cancel"
                                      response = %{
                                          Message: text,
                                          ClientState: 1,
                                          Type: "Response"
                                      }
                                  send_response(conn, response)
                        end

                    6 ->
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

    def handleLoanRepayment(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(cmd)
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
                          Message: "CON  Select Payment Option

                          1. Outstanding Amount
                          2. Own Amount",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)

                  4 ->
                      selectedOption = Enum.at(checkMenu, 3)

                      case selectedOption do

                          "1" ->

                              text = "CON You are about to repay the balance of K500 \nb. Back"
                                  response = %{
                                      Message: text,
                                      ClientState: 1,
                                      Type: "Response"
                                  }
                              send_response(conn, response)


                          "2" ->
                              text = "CON Enter own amount \nb. Back"
                                  response = %{
                                      Message: text,
                                      ClientState: 1,
                                      Type: "Response"
                                  }
                              send_response(conn, response)
                      end

                  5 ->
                      amountEntered = Enum.at(checkMenu, 4)
                      selectedOption = Enum.at(checkMenu, 3)

                      case selectedOption do

                          "1" ->
                              text = "CON You have requested to pay back K500 \n1. Proceed \nb. Back"
                                  response = %{
                                      Message: text,
                                      ClientState: 1,
                                      Type: "Response"
                                  }
                              send_response(conn, response)

                          "2" ->
                              text = "CON You have requested to pay back K#{amountEntered} \n1. Proceed \nb. Back"
                                  response = %{
                                      Message: text,
                                      ClientState: 1,
                                      Type: "Response"
                                  }
                              send_response(conn, response)
                      end

                  6 ->
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

    def handleRepaymentModeOption(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(cmd)
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


    def handleCheckLoanBalance(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(cmd)
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

                          Loan Balance:  K300
                          Due Date: 30-06-2023
                          Loan Account Status: Active"

                      response = %{
                          Message: msg <> "\n\n1. Request Statement\nb. Back",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)

                  4 ->
                      msg = "CON Enter Your Email Address"

                      response = %{
                          Message: msg <> "\n\nb. Back",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)

                  5 ->

                      emailEntered = Enum.at(checkMenu, 4)

                      msg = "CON Your Loan statement has been sent to the email address #{emailEntered}"

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

    def handleLoanStatement(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(cmd)
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

                      msg = "CON Loan Statement \n1. Current Month \n2. Input Date Range"

                      response = %{
                          Message: msg <> "\n\nb. Back",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)

                  4 ->
                      msg = "CON Enter Your Email Address"

                      response = %{
                          Message: msg <> "\n\nb. Back",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)

                  5 ->

                      emailEntered = Enum.at(checkMenu, 4)

                      msg = "CON Your Loan statement has been sent to the email address #{emailEntered}"

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

    def handleMyPin(conn, mobile_number, cmd, text, checkMenu) do
        checkMenuLength = Enum.count(checkMenu)
        valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
        IO.inspect("handleGetLoan")
        IO.inspect(checkMenuLength)
        IO.inspect(cmd)
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
                        msg = "CON Change Pin \n1. Change Login PIN \n2. Change Transaction PIN"

                        response = %{
                            Message: msg <> "\nb. Back \n0. End",
                            ClientState: 1,
                            Type: "Response",
                            key: "CON"
                        }
                        send_response(conn, response)

                  4 ->

                      checkpaidtype = Enum.at(checkMenu, 3)

                      case checkpaidtype do

                          "1" ->
                              msg = "CON Enter Current Pin"
                              response = %{
                                  Message: msg <> "\nb. Back \n0. End",
                                  ClientState: 1,
                                  Type: "Response",
                                  key: "CON"
                              }
                              send_response(conn, response)

                          "2" ->
                              msg = "CON Enter Current Pin"
                              response = %{
                                  Message: msg <> "\nb. Back \n0. End",
                                  ClientState: 1,
                                  Type: "Response",
                                  key: "CON"
                              }
                              send_response(conn, response)

                      end

                  5 ->

                      checkpaidtype = Enum.at(checkMenu, 3)

                      case checkpaidtype do

                          "1" ->
                              msg = "CON Enter New Pin"
                              response = %{
                                  Message: msg <> "\nb. Back \n0. End",
                                  ClientState: 1,
                                  Type: "Response",
                                  key: "CON"
                              }
                              send_response(conn, response)

                          "2" ->
                              msg = "CON Enter New Pin"
                              response = %{
                                  Message: msg <> "\nb. Back \n0. End",
                                  ClientState: 1,
                                  Type: "Response",
                                  key: "CON"
                              }
                              send_response(conn, response)

                      end

                  6 ->

                      checkpaidtype = Enum.at(checkMenu, 3)

                      case checkpaidtype do

                          "1" ->
                              msg = "CON Confirm New Pin"
                              response = %{
                                  Message: msg <> "\nb. Back \n0. End",
                                  ClientState: 1,
                                  Type: "Response",
                                  key: "CON"
                              }
                              send_response(conn, response)

                          "2" ->
                              msg = "CON Confirm New Pin"
                              response = %{
                                  Message: msg <> "\nb. Back \n0. End",
                                  ClientState: 1,
                                  Type: "Response",
                                  key: "CON"
                              }
                              send_response(conn, response)

                      end
                  7 ->

                      msg = "CON Pin Changed Successfully"
                      response = %{
                          Message: msg <> "\nb. Back \n0. End",
                          ClientState: 1,
                          Type: "Response",
                          key: "CON"
                      }
                      send_response(conn, response)

            end
        end
    end

      def contactUs(conn, mobile_number, cmd, text, checkMenu) do
          checkMenuLength = Enum.count(checkMenu)
          valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
          IO.inspect("handleGetLoan")
          IO.inspect(checkMenuLength)
          IO.inspect(cmd)
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

                          msg =  "CON CONTACT US \n
                                  Call +260975487574
                                  Visit www.qfin.africa/zm
                                  Email info@qfin.africa
                                  Email complaints@qfin.africa"

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


    # LoanmanagementsystemWeb.UssdController.calculate_loan_interest(20000, 10, 3)
    def calculate_loan_interest(principal, annual_interest_rate, loan_term_months) do
      monthly_interest_rate = annual_interest_rate / 12 / 100
      total_interest = principal * monthly_interest_rate * loan_term_months
      total_interest
    end

    # LoanmanagementsystemWeb.UssdController.calculate_monthly_repayment(20000, 10, 3)
    def calculate_monthly_repayment(principal, annual_interest_rate, loan_term_months) do
      monthly_interest_rate = annual_interest_rate / 12 / 100
      denominator = 1 - :math.pow(1 + monthly_interest_rate, -loan_term_months)
      monthly_repayment = (monthly_interest_rate * principal) / denominator
      monthly_repayment
    end

    def send_response(conn, response) do
        IO.inspect  "Test!"
        IO.inspect  Jason.encode!(response)
        send_resp(conn, :ok, Jason.encode!(response))
    end

  end
