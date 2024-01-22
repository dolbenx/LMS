defmodule LoanSystemWeb.UssdController do
    use LoanSystemWeb, :controller
      require Logger
      alias LoanSystem.Ussds
      alias LoanSystem.Ussds.Ussd
      alias LoanSystem.Account.AppUser
      alias LoanSystem.Companies.Staff
      alias LoanSystem.Products.Product
      alias LoanSystem.Loan.LoanProduct
      alias LoanSystem.Loan.USSDLoanProduct
      alias LoanSystem.Repo
      alias LoanSystem.Loan.Loans
      alias LoanSystem.Loan.LoanCharge
      alias LoanSystem.Loan.LoanProductCharge
      alias LoanSystem.Loan.Charge
      alias LoanSystem.Loan.LoanTransaction
      alias LoanSystem.Loan.LoanChargePayment
      alias LoanSystem.Account.AppUser
      alias LoanSystem.Loan.LoanRepaymentSchedule
      alias LoanSystem.Ussds.Ussd_Request
      require Record
      import Ecto.Query, only: [from: 2]
      import MtnMomo


    def index(conn, _params) do
      ussds = Ussds.list_ussds()
      render(conn, "index.html", ussds: ussds)
    end

    def ussd_request(conn, _params) do
      render(conn, "ussd_requests.html")
    end



    def test(conn, dd) do
      testStr = "*244#*12111*"
      testArray = String.split(testStr, "\*");
      Logger.info testArray
      Logger.info Enum.count(testArray)
      render(conn, "index.html", testArray: testArray)
    end

      def initiateUssd(conn, dd) do
          {:ok, body, _conn} = Plug.Conn.read_body(conn)
          Logger.info  "-----------"
          Logger.info  body

          query_params = conn.query_params;
          session_id = query_params["session_id"];
          query_params = conn.query_params;
          Logger.info  Jason.encode!(query_params)
          mobile_number = query_params["mobile_number"]
          text = query_params["text"]

          cmd = query_params["serviceCode"]
          orginal_short_code = cmd


          query = from au in Ussd_Request, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
          ussdRequests = Repo.all(query);

          text = if (Enum.count(ussdRequests) == 0) do

              text = text <> "#*";

              Logger.info  "No Ussd Requests"
              Logger.info  text

              ussdRequest = %Ussd_Request{}
              ussdRequest = %Ussd_Request{mobile_number: mobile_number, request_data: text, session_id: session_id, session_ended: 0}
              case Repo.insert(ussdRequest) do
                  {:ok, ussdRequest} ->
                      query = from au in Ussd_Request, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
                      ussdRequest = Repo.one(query);
                      ussdRequest.request_data
                  {:error, changeset} ->
                      Logger.info("Fail")
                      nil;


              end
          else
              text = String.trim_leading(text, "*");
              ussdRequest = Enum.at(ussdRequests, 0);
              text = ussdRequest.request_data <> text <> "*";

              text = String.replace(text, "*B*", "*b*")

              Logger.info  "Ussd Requests Exist"
              Logger.info ussdRequest.request_data
              Logger.info  text


              attrs = %{request_data: text}

              ussdRequest
              |> Ussd_Request.changeset(attrs)
              |> Repo.update()

              text
          end


          if(is_nil(text)) do
              response = %{
                  message: "Technical issues experienced. Press\n\nb. Back\n",
                  ClientState: 1,
                  Type: "Response",
                  key: "BA2"
              }
              send_response(conn, response)
          else

              activeStatus = "ACTIVE";
              query = from au in LoanSystem.Companies.Staff, where: au.phone == ^mobile_number and au.status == ^activeStatus, select: au
              companyStaff = Repo.one(query)

              if(companyStaff) do

                  query = from au in AppUser, where: au.mobile_number == ^mobile_number, select: au
                  appusers = Repo.all(query)
                  Logger.info  Enum.count(appusers)


                  #tempText = text <> "*";
                  tempText = text;
                  text = if String.ends_with?(tempText, "*b*") do
                      tempText = "*244#*";

                  else
                      b_located = String.contains?(tempText, "*b*")
                      text = if b_located == true do

                          tempCheckMenu = String.split(tempText, "*b*")
                          tempCheckMenuFirst = Enum.at(tempCheckMenu, 0);
                          tempCheckMenuLength = Enum.count(tempCheckMenu);

                          text = if Enum.count(tempCheckMenu) > 1 do

                              tempCheckMenuLast = Enum.at(tempCheckMenu, tempCheckMenuLength-1);
                              text = if String.length(tempCheckMenuLast) > 0 do
                                  strlen_ = String.length(tempCheckMenuLast) - 1;
                                  tempCheckMenuLast = String.slice(tempCheckMenuLast, 0, strlen_);
                                  tempText = "*244#*#{tempCheckMenuLast}*"
                              else
                                  text

                              end
                          end
                      else
                          b_located = String.contains?(tempText, "*0*")
                          text = if b_located == true do

                              text = false
                          else
                              text

                          end


                      end
                  end



                  Logger.info("!!!!!!!")
                  Logger.info(text);


                  if(text) do
                      if (Enum.count(appusers)>0) do
                          query = from au in Ussd_Request, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
                          ussdRequests = Repo.all(query);
                          ussdRequest = Enum.at(ussdRequests, 0);
                          Logger.info (Enum.count(ussdRequests));
                          if(ussdRequest.is_logged_in != 1) do
                              request_user_password(conn, mobile_number, cmd, text, ussdRequests, "Welcome to Chikwama Loans\n\nPlease enter your 4 digit Pin");
                          else
                              welcome_menu(conn, mobile_number, cmd, text, ussdRequests)
                          end

                          #welcome_menu(conn, mobile_number, cmd, text, ussdRequests)
                      else
                          Logger.info  "User does not exist"
                          Logger.info("===================")
                          Logger.info(cmd)
                          Logger.info(mobile_number)


                          Logger.info("short_code...")
                          Logger.info(cmd)
                          Logger.info("text...")
                          Logger.info(text)


                          if text do
                              checkMenu = String.split(text, "\*")
                              checkMenuLength = Enum.count(checkMenu)
                              Logger.info(checkMenuLength)
                              case checkMenuLength do
                                  3 ->
                                      response = %{
                                          message: "Welcome to Chikwama Loans\n\nCreate your password",
                                          ClientState: 1,
                                          Type: "Response",
                                          key: "con"
                                      }
                                      send_response(conn, response)
                                  4 ->
                                      response = %{
                                          message: "Confirm your password",
                                          ClientState: 1,
                                          Type: "Response",
                                          key: "con"
                                      }
                                      send_response(conn, response)
                                  5 ->
                                      password = Enum.at(checkMenu, 2)
                                      cpassword = Enum.at(checkMenu, 3)
                                      Logger.info("password..." <> password)
                                      Logger.info("cpassword..." <> cpassword)

                                      if (password != cpassword) do

                                          response = %{
                                              message: "Passwords dont match. Press\n\nb. Back\n",
                                              ClientState: 1,
                                              Type: "Response",
                                              key: "BA2"
                                          }
                                          send_response(conn, response)
                                      else
                                          activeStatus = "ACTIVE";
                                              query = from au in LoanSystem.Companies.Staff,
                                                  where: au.phone == ^mobile_number and au.status == ^activeStatus, select: au
                                              companyStaff = Repo.one(query)


                                          appUser = %AppUser{status: "Active", mobile_number: mobile_number, password: password, staff_id: companyStaff.id}


                                          case Repo.insert(appUser) do
                                          {:ok, appUser} ->
                                                  response = %{
                                                      message: "Your new Chikwama account has been setup for you. Press\n\nb. Back\n0. Log Out",
                                                      ClientState: 1,
                                                      Type: "Response",
                                                      key: "BA3"
                                                  }
                                                  send_response(conn, response)


                                          {:error, changeset} ->
                                                  Logger.info("Fail")
                                                  response = %{
                                                      message: "Your new Chikwama account could not be setup for you. Press\n\nb. Back\n0. Log Out",
                                                      ClientState: 1,
                                                      Type: "Response",
                                                      key: "BA3"
                                                  }
                                                  send_response(conn, response)
                                          end
                                      end
                                  end
                              else
                                  response = %{
                                      message: "Invalid input provided",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "BA1"
                                  }
                                  send_response(conn, response)
                              end
                          end
                  else
                      response = %{
                          message: "Thank you and Good Bye",
                          ClientState: 1,
                          Type: "Response",
                          key: "end"
                      }
                      end_session(ussdRequests, conn, response);
                  end
              else
                  response = %{
                      message: "This service is not available to you. Contact LAXMI if you would want your company staff to receive loans",
                      ClientState: 1,
                      Type: "Response",
                      key: "end"
                  }
                  end_session(ussdRequests, conn, response);
              end

          end

      end



      def end_session(ussdRequests, conn, response) do

          attrs = %{session_ended: 1};
          if(Enum.count(ussdRequests)>0) do
              ussdRequest = Enum.at(ussdRequests, 0);

              ussdRequest
              |> Ussd_Request.changeset(attrs)
              |> Repo.update()
          end

          #response = %{
          #    message: "Thank you and Good Bye",
          #    ClientState: 1,
          #    Type: "Response",
          #    key: "end"
          #}
          send_response(conn, response)
      end


      def request_user_password(conn, mobile_number, cmd, text, ussdRequests, passwordRequestMessage) do
          Logger.info text
          orginal_short_code = cmd


          activeStatus = "ACTIVE";
          query = from au in LoanSystem.Companies.Staff, where: au.phone == ^mobile_number and au.status == ^activeStatus, select: au
          companyStaff = Repo.one(query)

          if(is_nil(companyStaff)) do
              response = %{
                  message: "This service is not available to you. Contact LAXMI if you would want your company staff to receive loans",
                  ClientState: 1,
                  Type: "Response",
                  key: "end"
              }
              end_session(ussdRequests, conn, response);
          end

          query = from au in AppUser, where: au.mobile_number == ^mobile_number, select: au
          customers = Repo.all(query)

          query = from pd in Product, select: pd
          products = Repo.all(query)


          Logger.info "customers count"
          Logger.info Enum.count(customers)
          Logger.info "customers count"
          Logger.info "Products count..."
          Logger.info Enum.count(products)



          if (Enum.count(customers)>0) do

              checkMenu = String.split(text, "\*")
              checkMenuLength = Enum.count(checkMenu)

              Logger.info("[[[[[[]]]]]]")
              Logger.info(checkMenuLength)

              if checkMenuLength==3 do
                  response = %{
                      message: passwordRequestMessage,
                      ClientState: 1,
                      Type: "Response",
                      key: "con"
                  }
                  send_response(conn, response)
              end
              if checkMenuLength>3 do
                  valueEntered = Enum.at(checkMenu, (Enum.count(checkMenu)-2))
                  Logger.info (valueEntered);
                  handle_validate_password(conn, mobile_number, cmd, text, checkMenu, ussdRequests, valueEntered)
              end

          else
              handle_new_account(conn, mobile_number, cmd, text)
          end
      end

      def handle_validate_password(conn, mobile_number, cmd, text, checkMenu, ussdRequests, valueEntered) do

          query = from au in AppUser, where: au.mobile_number == ^mobile_number, select: au
          loggedInUser = Repo.one(query)


          if(!is_nil(loggedInUser)) do

              if(loggedInUser.status != "Active") do
                  response = %{
                      message: "Your account is no longer active. Please contact LAXMI to reactivate your account. ",
                      ClientState: 1,
                      Type: "Response",
                      key: "end"
                  }
                  end_session(ussdRequests, conn, response);
              else
                  if(loggedInUser.password != valueEntered) do

                      if(loggedInUser.password_fail_count>2) do

                          attrs = %{password_fail_count: 3, status: "Blocked"}

                          loggedInUser
                          |> AppUser.changeset(attrs)
                          |> Repo.update()
                      else

                          attrs = %{password_fail_count: (loggedInUser.password_fail_count + 1)}

                          loggedInUser
                          |> AppUser.changeset(attrs)
                          |> Repo.update()
                      end


                      attrs = %{request_data: "*244#*"}
                      ussdRequest = Enum.at(ussdRequests, 0);
                      session_id = ussdRequest.session_id;

                      ussdRequest
                      |> Ussd_Request.changeset(attrs)
                      |> Repo.update()

                      text = "\*244#\*"
                      request_user_password(conn, mobile_number, cmd, text, ussdRequests, "Invalid credentials. Please log in again. Your account will be locked if you fail to log in after 3 times");

                  else
                      ussdRequest = Enum.at(ussdRequests, 0);
                      session_id = ussdRequest.session_id;

                      Logger.info (ussdRequest.id);

                      {1, [ussdRequest]} =
                          from(p in Ussd_Request, where: p.id == ^ussdRequest.id, select: p)
                          |> Repo.update_all(set: [request_data: "*244#*", is_logged_in: 1]);


                      text = "*244#*";
                      query = from au in Ussd_Request, where: au.mobile_number == ^mobile_number and au.session_id == ^session_id, select: au
                      ussdRequests = Repo.all(query);
                      welcome_menu(conn, mobile_number, cmd, text, ussdRequests)
                  end
              end

          else

              response = %{
                  message: "Invalid credentials.",
                  ClientState: 1,
                  Type: "Response",
                  key: "end"
              }
              end_session(ussdRequests, conn, response);
          end

      end

      def welcome_menu(conn, mobile_number, cmd, text, ussdRequests) do
          Logger.info text
          orginal_short_code = cmd


          activeStatus = "ACTIVE";
          query = from au in LoanSystem.Companies.Staff, where: au.phone == ^mobile_number and au.status == ^activeStatus, select: au
          companyStaff = Repo.one(query)

          if(is_nil(companyStaff)) do
              response = %{
                  message: "This service is not available to you. Contact LAXMI if you would want your company staff to receive loans",
                  ClientState: 1,
                  Type: "Response",
                  key: "end"
              }
              end_session(ussdRequests, conn, response);
          end

          query = from au in AppUser, where: au.mobile_number == ^mobile_number, select: au
          customers = Repo.all(query)

          query = from pd in Product, select: pd
          products = Repo.all(query)


          Logger.info "customers count"
          Logger.info Enum.count(customers)
          Logger.info "customers count"
          Logger.info "Products count..."
          Logger.info Enum.count(products)





          if (Enum.count(customers)>0) do

              checkMenu = String.split(text, "\*")
              checkMenuLength = Enum.count(checkMenu)

              Logger.info("[[[[[[]]]]]]")
              Logger.info(checkMenuLength)

              if checkMenuLength==3 do
                  response = %{
                      message: "Welcome to Chikwama Loans\n\n1. Request Loan\n2. Repay Loan\n3. Loan Balance\n4. Account Status\n5. Terms and Conditions\n0. End",
                      ClientState: 1,
                      Type: "Response",
                      key: "con"
                  }
                  send_response(conn, response)
              end
              if checkMenuLength>3 do
                  #valueEntered = Enum.at(checkMenu, (Enum.count(checkMenu)-2))
                  valueEntered = Enum.at(checkMenu, 2);
                  Logger.info (valueEntered);
                  case valueEntered do
                      "1" ->
                          Logger.info(checkMenu);
                          Logger.info ("1. handleGetLoan");
                          handleGetLoan(conn, mobile_number, cmd, text, checkMenu, ussdRequests)
                      "2" ->
                          Logger.info(checkMenu);
                          Logger.info ("2. handleGetLoan");
                          handleRepayLoanBalance(conn, mobile_number, cmd, text, checkMenu)
                      "3" ->
                          Logger.info ("handleGetLoan");
                          handleGetLoanBalance(conn, mobile_number, cmd, text, checkMenu)
                      "4" ->
                          Logger.info ("handleGetLoan");
                          handleAccountStatus(conn, mobile_number, cmd, text, checkMenu)
                      "5" ->
                          Logger.info ("handleGetLoan");
                          handleTC(conn, mobile_number, cmd, text, checkMenu)
                      "0" ->
                          Logger.info ("endSession");
                          response = %{
                              message: "Thank you and Good Bye",
                              ClientState: 1,
                              Type: "Response",
                              key: "end"
                          }
                          end_session(ussdRequests, conn, response);


                  end
              end

          else
              handle_new_account(conn, mobile_number, cmd, text)
          end

      end

    def handleTC(conn, mobile_number, cmd, text, checkMenu) do
          checkMenuLength = Enum.count(checkMenu)
          valueEntered = Enum.at(checkMenu, (checkMenuLength-2))
          Logger.info(checkMenuLength);
          Logger.info(valueEntered);
          Logger.info(text);
          if valueEntered == "b" do
              tempText = text <> "*";
              tempCheckMenu = String.split(tempText, "*b*")
              tempCheckMenuFirst = Enum.at(tempCheckMenu, 0);
              tempCheckMenuLength = Enum.count(tempCheckMenu);
              tempCheckMenuLast = Enum.at(tempCheckMenu, tempCheckMenuLength-1);

              nText = tempCheckMenuLast
              response = %{
                  message: nText,
                  ClientState: 1,
                  Type: "Response"
              }
              send_response(conn, response)
          else
              tc = "Terms & Conditions\n-------------------------\nTerms and conditions appear here\n\nb: Back\n0: End";
              response = %{
                  message: tc,
                  ClientState: 1,
                  Type: "Response",
                  key: "end"
              }
              send_response(conn, response);
          end
      end


      def handleGetLoanBalance(conn, mobile_number, cmd, text, checkMenu) do
          checkMenuLength = Enum.count(checkMenu)
          valueEntered = Enum.at(checkMenu, (checkMenuLength-2))
          Logger.info("handleGetLoan");
          Logger.info(checkMenuLength);
          Logger.info(valueEntered);
          Logger.info(text);
          if valueEntered == "b" do
              response = %{
                  message: "",
                  ClientState: 1,
                  Type: "Response",
                  key: "BA3"
              }
              send_response(conn, response)
          else
              case checkMenuLength do
                  4 ->
                      query = from au in AppUser,
                          where: (au.mobile_number == type(^mobile_number, :string)),
                          select: au
                      appUsers = Repo.all(query);
                      appUser = Enum.at(appUsers, 0);



                      query = from au in Staff,
                          where: (au.id == type(^appUser.staff_id, :integer)),
                          select: au
                      staffs = Repo.all(query);
                      staff = Enum.at(staffs, 0);


                      status = "Disbursed";
                      statusList = ["Disbursed", "Pending Approval"];

                      query = from au in AppUser, where: au.mobile_number == ^mobile_number, select: au
                      appUs = Repo.one(query)

                      query = from p in Loans,
                        where: p.loan_status in ^statusList and p.customer_id == type(^appUs.staff_id, :integer),
                        select: %{
                            principal_amount: sum(p.principal_amount),
                            interest_outstanding_derived: sum(p.interest_outstanding_derived),
                            fee_charges_outstanding_derived: sum(p.fee_charges_outstanding_derived),
                            penalty_charges_outstanding_derived: sum(p.penalty_charges_outstanding_derived),
                        }

                        loans_principal_amount = Repo.all(query);
                        check_user_sum = loans_principal_amount |> Enum.at(0)

                        amount = check_user_sum
                        %{penalty_charges_outstanding_derived: penalty_charges_outstanding_derived, fee_charges_outstanding_derived: fee_charges_outstanding_derived, interest_outstanding_derived: interest_outstanding_derived, principal_amount: principal_amount} = amount
                        interest_outstanding_amount = interest_outstanding_derived
                        interest_outstanding_amount = if interest_outstanding_amount == nil do
                            interest_outstanding_amount = 0
                            interest_outstanding_amount
                        else
                            interest_outstanding_amount
                        end
                        sum_value_p = principal_amount
                        sum_value_p = if sum_value_p == nil do
                            sum_value_p = 0
                            sum_value_p
                        else
                            sum_value_p
                        end
                        fee_amount = fee_charges_outstanding_derived
                        fee_amount = if fee_amount == nil do
                            fee_amount = 0
                            fee_amount
                        else
                            fee_amount
                        end
                        penalty_fee = penalty_charges_outstanding_derived
                        penalty_fee = if penalty_fee == nil do
                            penalty_fee = 0
                            penalty_fee
                        else
                            penalty_fee

                        end

                      outstanding_Total = interest_outstanding_amount + sum_value_p + fee_amount + penalty_fee


                      status = "Disbursed";
                      query = from au in Loans,
                          where: (au.loan_status == type(^status, :string) and au.app_user_id == type(^appUser.id, :integer)),
                          select: au
                      loans = Repo.all(query);
                      if Enum.count(loans)>0 do
                          loan = Enum.at(loans, 0);

                          balanceoutstandingTotal = loan.principal_outstanding_derived + loan.interest_outstanding_derived + loan.fee_charges_outstanding_derived + loan.penalty_charges_outstanding_derived;
                          Logger.info(outstanding_Total);
                          outstandingTotal = :erlang.float_to_binary(outstanding_Total, [decimals: 2])
                          interest_outstanding = :erlang.float_to_binary((interest_outstanding_amount), [decimals: 2])
                          sum_value = :erlang.float_to_binary((sum_value_p), [decimals: 2])
                          penalty = :erlang.float_to_binary((penalty_fee), [decimals: 2])
                          fee = :erlang.float_to_binary((fee_amount), [decimals: 2])

                        #   principal_outstanding_derived = :erlang.float_to_binary(loan.principal_outstanding_derived, [decimals: 2])
                        #   interest_outstanding_derived = :erlang.float_to_binary(loan.interest_outstanding_derived, [decimals: 2])
                        #   fee_charges_outstanding_derived = :erlang.float_to_binary(loan.fee_charges_outstanding_derived, [decimals: 2])
                        #   penalty_charges_outstanding_derived = :erlang.float_to_binary(loan.penalty_charges_outstanding_derived, [decimals: 2])


                        #   sum_value = elem Float.parse(sum_value), 0

                          #text = "Loan Account ##{loan.loan_identity_number}\nPrincipal: #{loan.currency_code}#{sum_value}\nInterest: #{loan.currency_code}#{interest_outstanding}\nFees: #{loan.currency_code}#{fee}\nPenalties: #{loan.currency_code}#{penalty}\n----------------\nTotal: #{loan.currency_code}#{outstandingTotal}\n\nb. Back \n0. End";
                          text = "Your Current Loan Balance is #{loan.currency_code}#{balanceoutstandingTotal}\n\nb. Back \n0. End";
                          response = %{
                              message: text,
                              ClientState: 1,
                              Type: "Response",
                              key: "con"
                          }
                          send_response(conn, response)
                      else
                          text = "You do not have any approved loan currently running.\n\nb. Back \n0. End";
                          response = %{
                              message: text,
                              ClientState: 1,
                              Type: "Response",
                              key: "con"
                          }
                          send_response(conn, response)
                      end
              end
          end

      end


      def handleRepayLoanBalance(conn, mobile_number, cmd, text, checkMenu) do
          checkMenuLength = Enum.count(checkMenu)
          valueEntered = Enum.at(checkMenu, (checkMenuLength-2))
          Logger.info("handleRepayLoanBalance");
          Logger.info(checkMenu);
          Logger.info(checkMenuLength);
          Logger.info(valueEntered);
          Logger.info(text);
          if valueEntered == "b" do
              response = %{
                  message: "",
                  ClientState: 1,
                  Type: "Response",
                  key: "BA3"
              }
              send_response(conn, response)
          else
              case checkMenuLength do
                  4 ->
                      query = from au in AppUser,
                          where: (au.mobile_number == type(^mobile_number, :string)),
                          select: au
                      appUsers = Repo.all(query);
                      appUser = Enum.at(appUsers, 0);


                      query = from au in Staff,
                          where: (au.id == type(^appUser.staff_id, :integer)),
                          select: au
                      staffs = Repo.all(query);
                      staff = Enum.at(staffs, 0);


                      status = "Disbursed";
                      query = from au in Loans,
                          where: (au.loan_status == type(^status, :string) and au.app_user_id == type(^appUser.id, :integer)),
                          select: au
                      loans = Repo.all(query);

                      if (!is_nil(loans) && Enum.count(loans) > 0) do
                          loan = Enum.at(loans, 0);

                          outstandingTotal = loan.principal_outstanding_derived + loan.interest_outstanding_derived + loan.fee_charges_outstanding_derived + loan.penalty_charges_outstanding_derived;
                          Logger.info(outstandingTotal);
                          outstandingTotalStr = :erlang.float_to_binary(outstandingTotal, [decimals: 2])
                          principal_outstanding_derived = :erlang.float_to_binary(loan.principal_outstanding_derived, [decimals: 2])
                          interest_outstanding_derived = :erlang.float_to_binary(loan.interest_outstanding_derived, [decimals: 2])
                          fee_charges_outstanding_derived = :erlang.float_to_binary(loan.fee_charges_outstanding_derived, [decimals: 2])
                          penalty_charges_outstanding_derived = :erlang.float_to_binary(loan.penalty_charges_outstanding_derived, [decimals: 2])


                        if outstandingTotal>0 do
                            text = "Loan Account ##{loan.loan_identity_number}\n\nOutstanding Balance: #{outstandingTotalStr}\n\n1. Full Repayment\n2. Partial Repayment\n\nb. Back \n0. End";
                            response = %{
                                message: text,
                                ClientState: 1,
                                Type: "Response",
                                key: "con"
                            }
                            send_response(conn, response)
                        else
                            text = "You do not have any active loans at the moment.\nPress \n\nb. Back \n0. End";
                            response = %{
                                message: text,
                                ClientState: 1,
                                Type: "Response",
                                key: "con"
                            }
                            send_response(conn, response)
                        end
                      else
                          text = "You do not have any active loans at the moment.\nPress \n\nb. Back \n0. End";
                          response = %{
                              message: text,
                              ClientState: 1,
                              Type: "Response",
                              key: "con"
                          }
                          send_response(conn, response)
                      end
                  5 ->
                      valueEntered = Enum.at(checkMenu, (Enum.count(checkMenu)-2))
                      Logger.info (valueEntered);
                      case valueEntered do
                          "1" ->
                              Logger.info ("handleGetLoan");
                              payLoanBalance(conn, mobile_number, cmd, text, checkMenu, 1)

						  "2" ->
								Logger.info ("handleGetLoan");
                              payLoanBalance(conn, mobile_number, cmd, text, checkMenu, 2)
                      end
                    6 ->
                        valueEntered = Enum.at(checkMenu, (Enum.count(checkMenu)-2))
                        Logger.info (valueEntered);
                        Logger.info ("payLoanBalancePartial");
						checkMenuLength = Enum.count(checkMenu)
						query = from au in AppUser,
						  where: (au.mobile_number == type(^mobile_number, :string)),
						  select: au
						appUsers = Repo.all(query);
						appUser = Enum.at(appUsers, 0);


						query = from au in Staff,
						  where: (au.id == type(^appUser.staff_id, :integer)),
						  select: au
						staffs = Repo.all(query);
						staff = Enum.at(staffs, 0);


						status = "Disbursed";
						query = from au in Loans,
						  where: (au.loan_status == type(^status, :string) and au.app_user_id == type(^appUser.id, :integer)),
						  select: au
						loans = Repo.all(query);
						if Enum.count(loans)>0 do
							loan = Enum.at(loans, 0);

							outstandingTotal = loan.principal_outstanding_derived + loan.interest_outstanding_derived + loan.fee_charges_outstanding_derived + loan.penalty_charges_outstanding_derived;

							principal_outstanding_derived = :erlang.float_to_binary(loan.principal_outstanding_derived, [decimals: 2])
							interest_outstanding_derived = :erlang.float_to_binary(loan.interest_outstanding_derived, [decimals: 2])
							fee_charges_outstanding_derived = :erlang.float_to_binary(loan.fee_charges_outstanding_derived, [decimals: 2])
							penalty_charges_outstanding_derived = :erlang.float_to_binary(loan.penalty_charges_outstanding_derived, [decimals: 2])

							loan_id = loan.id
							is_reversed = false;
							transaction_type_enum = "LOAN REPAYMENT";
							transaction_date = Date.utc_today;
							principal_portion_derived = loan.principal_outstanding_derived;
							interest_portion_derived = loan.interest_outstanding_derived;
							fee_charges_portion_derived = loan.fee_charges_outstanding_derived;
							penalty_charges_portion_derived = loan.penalty_charges_outstanding_derived;
							overpayment_portion_derived = 0.00;
							unrecognized_income_portion = 0.00;
							outstanding_loan_balance_derived = 0.00;
							submitted_on_date = Date.utc_today;
							manually_adjusted_or_reversed = false;
							manually_created_by_userid = nil;
							amount = outstandingTotal;
							transaction_ref = UUID.uuid4()
							handleMoMoRepayment(conn, mobile_number, cmd, text, checkMenu, 2, valueEntered, loan_id, is_reversed, transaction_type_enum,
								transaction_date, principal_portion_derived, interest_portion_derived, fee_charges_portion_derived, penalty_charges_portion_derived,
								overpayment_portion_derived, unrecognized_income_portion, outstanding_loan_balance_derived, submitted_on_date, manually_adjusted_or_reversed, manually_created_by_userid,
								loan, transaction_ref)
						else
							text = "You do not have any \nb. Back \n0. End";
                            response = %{
                                message: text,
                                ClientState: 1,
                                Type: "Response",
                                key: "con"
                            }
                            send_response(conn, response)
						end
              end
          end

      end



      def handleAccountStatus(conn, mobile_number, cmd, text, checkMenu) do
          checkMenuLength = Enum.count(checkMenu)
          valueEntered = Enum.at(checkMenu, (checkMenuLength-2))
          Logger.info("handleGetLoan");
          Logger.info(checkMenuLength);
          Logger.info(valueEntered);
          Logger.info(text);
          if valueEntered == "b" do
              response = %{
                  message: "",
                  ClientState: 1,
                  Type: "Response",
                  key: "BA3"
              }
              send_response(conn, response)
          else
              case checkMenuLength do
                  4 ->
                      query = from au in AppUser,
                          where: (au.mobile_number == type(^mobile_number, :string)),
                          select: au
                      appUsers = Repo.all(query);
                      appUser = Enum.at(appUsers, 0);


                      query = from au in Staff,
                          where: (au.id == type(^appUser.staff_id, :integer)),
                          select: au
                      staffs = Repo.all(query);
                      staff = Enum.at(staffs, 0);


                      if appUser.status == "Active" do

                          text = "Your account is active\n\nb. Back \n0. End";
                          response = %{
                              message: text,
                              ClientState: 1,
                              Type: "Response",
                              key: "con"
                          }
                          send_response(conn, response)
                      else
                           if appUser.status == "Inactive" do

                              text = "Your account is not active\n\nb. Back \n0. End";
                              response = %{
                                  message: text,
                                  ClientState: 1,
                                  Type: "Response",
                                  key: "con"
                              }
                              send_response(conn, response)
                          else
                              text = "Your account has been blocked\n\nb. Back \n0. End";
                              response = %{
                                  message: text,
                                  ClientState: 1,
                                  Type: "Response",
                                  key: "con"
                              }
                              send_response(conn, response)
                          end
                      end
              end
          end

      end


      def pay_LoanBalance(conn, mobile_number, cmd, text, checkMenu) do
		 checkMenuLength = Enum.count(checkMenu)
          query = from au in AppUser,
              where: (au.mobile_number == type(^mobile_number, :string)),
              select: au
          appUsers = Repo.all(query);
          appUser = Enum.at(appUsers, 0);


          query = from au in Staff,
              where: (au.id == type(^appUser.staff_id, :integer)),
              select: au
          staffs = Repo.all(query);
          staff = Enum.at(staffs, 0);


          status = "Disbursed";
          query = from au in Loans,
              where: (au.loan_status == type(^status, :string) and au.app_user_id == type(^appUser.id, :integer)),
              select: au
          loans = Repo.all(query);
          if Enum.count(loans)>0 do
              loan = Enum.at(loans, 0);

              outstandingTotal = loan.principal_outstanding_derived + loan.interest_outstanding_derived + loan.fee_charges_outstanding_derived + loan.penalty_charges_outstanding_derived;

              principal_outstanding_derived = :erlang.float_to_binary(loan.principal_outstanding_derived, [decimals: 2])
              interest_outstanding_derived = :erlang.float_to_binary(loan.interest_outstanding_derived, [decimals: 2])
              fee_charges_outstanding_derived = :erlang.float_to_binary(loan.fee_charges_outstanding_derived, [decimals: 2])
              penalty_charges_outstanding_derived = :erlang.float_to_binary(loan.penalty_charges_outstanding_derived, [decimals: 2])

              loan_id = loan.id
              is_reversed = false;
              transaction_type_enum = "LOAN REPAYMENT";
              transaction_date = Date.utc_today;
              principal_portion_derived = loan.principal_outstanding_derived;
              interest_portion_derived = loan.interest_outstanding_derived;
              fee_charges_portion_derived = loan.fee_charges_outstanding_derived;
              penalty_charges_portion_derived = loan.penalty_charges_outstanding_derived;
              overpayment_portion_derived = 0.00;
              unrecognized_income_portion = 0.00;
              outstanding_loan_balance_derived = 0.00;
              submitted_on_date = Date.utc_today;
              manually_adjusted_or_reversed = false;
              manually_created_by_userid = nil;
              amount = outstandingTotal;



              Logger.info "Insert Loan Repayment Transaction";
              loanTransaction = %LoanTransaction{loan_id: loan_id, is_reversed: is_reversed, transaction_type_enum: transaction_type_enum,
                  transaction_date: transaction_date, amount: amount, principal_portion_derived: principal_portion_derived, interest_portion_derived: interest_portion_derived,
                  fee_charges_portion_derived: fee_charges_portion_derived,
                  penalty_charges_portion_derived: penalty_charges_portion_derived, overpayment_portion_derived: overpayment_portion_derived, unrecognized_income_portion: unrecognized_income_portion,
                  outstanding_loan_balance_derived: outstanding_loan_balance_derived,
                  submitted_on_date: submitted_on_date, manually_adjusted_or_reversed: manually_adjusted_or_reversed, manually_created_by_userid: manually_created_by_userid}
              Repo.insert(loanTransaction);


              query = from au in LoanRepaymentSchedule,
                  where: (au.loan_id == type(^loan_id, :integer)),
                  select: au
              loanRepaymentSchedules = Repo.all(query)
              for {k, v} <- Enum.with_index(loanRepaymentSchedules) do
                  loanRepaymentSchedule = Enum.at(loanRepaymentSchedules, v);
                  obligations_met_on_date = Date.utc_today;
                  completed_derived = loanRepaymentSchedule.principal_amount
                  LoanRepaymentSchedule.changeset(loanRepaymentSchedule, %{obligations_met_on_date: obligations_met_on_date, completed_derived: completed_derived})
                      |> prepare_update(conn, loanRepaymentSchedule)
                      |> Repo.transaction()

              end

              closedon_date = Date.utc_today;
              completed_derived = loan.total_outstanding_derived;
              principal_repaid_derived = loan.approved_principal;
              interest_repaid_derived = loan.interest_charged_derived;
              fee_charges_repaid_derived = loan.fee_charges_charged_derived;
              Loans.changeset(loan, %{closedon_date: closedon_date, completed_derived: completed_derived,
                  principal_repaid_derived: principal_repaid_derived, interest_repaid_derived: interest_repaid_derived, fee_charges_repaid_derived: fee_charges_repaid_derived
                  })
                  |> prepare_update(conn, loan)
                  |> Repo.transaction()


						text = "Enter Amount\n\nb. Back \n0. End";
							response = %{
							  message: text,
							  ClientState: 1,
							  Type: "Response",
							  key: "con"
						  }
							send_response(conn, response)


          else
              text = "You do not have any approved loans currently running.\n\nb. Back \n0. End";
              response = %{
                  message: text,
                  ClientState: 1,
                  Type: "Response",
                  key: "con"
              }
              send_response(conn, response);
          end
      end

		def payLoanBalance(conn, mobile_number, cmd, text, checkMenu, type) do
			  checkMenuLength = Enum.count(checkMenu)
			  query = from au in AppUser,
				  where: (au.mobile_number == type(^mobile_number, :string)),
				  select: au
			  appUsers = Repo.all(query);
			  appUser = Enum.at(appUsers, 0);


			  query = from au in Staff,
				  where: (au.id == type(^appUser.staff_id, :integer)),
				  select: au
			  staffs = Repo.all(query);
			  staff = Enum.at(staffs, 0);


			  status = "Disbursed";
			  query = from au in Loans,
				  where: (au.loan_status == type(^status, :string) and au.app_user_id == type(^appUser.id, :integer)),
				  select: au
			  loans = Repo.all(query);
			  if Enum.count(loans)>0 do
				  loan = Enum.at(loans, 0);

				  outstandingTotal = loan.principal_outstanding_derived + loan.interest_outstanding_derived + loan.fee_charges_outstanding_derived + loan.penalty_charges_outstanding_derived;

				  principal_outstanding_derived = :erlang.float_to_binary(loan.principal_outstanding_derived, [decimals: 2])
				  interest_outstanding_derived = :erlang.float_to_binary(loan.interest_outstanding_derived, [decimals: 2])
				  fee_charges_outstanding_derived = :erlang.float_to_binary(loan.fee_charges_outstanding_derived, [decimals: 2])
				  penalty_charges_outstanding_derived = :erlang.float_to_binary(loan.penalty_charges_outstanding_derived, [decimals: 2])

				  loan_id = loan.id
				  is_reversed = false;
				  transaction_type_enum = "LOAN REPAYMENT";
				  transaction_date = Date.utc_today;
				  principal_portion_derived = loan.principal_outstanding_derived;
				  interest_portion_derived = loan.interest_outstanding_derived;
				  fee_charges_portion_derived = loan.fee_charges_outstanding_derived;
				  penalty_charges_portion_derived = loan.penalty_charges_outstanding_derived;
				  overpayment_portion_derived = 0.00;
				  unrecognized_income_portion = 0.00;
				  outstanding_loan_balance_derived = 0.00;
				  submitted_on_date = Date.utc_today;
				  manually_adjusted_or_reversed = false;
				  manually_created_by_userid = nil;
				  amount = outstandingTotal;
				  transaction_ref = UUID.uuid4()


				  if type==1 do
						handleMoMoRepayment(conn, mobile_number, cmd, text, checkMenu, type, "#{amount}", loan_id, is_reversed, transaction_type_enum,
							transaction_date, principal_portion_derived, interest_portion_derived, fee_charges_portion_derived, penalty_charges_portion_derived,
							overpayment_portion_derived, unrecognized_income_portion, outstanding_loan_balance_derived, submitted_on_date, manually_adjusted_or_reversed, manually_created_by_userid,
							loan, transaction_ref)
				  else
						text = "Enter amount you are repaying. \n\nb. Back \n0. End";
						response = %{
							message: text,
							ClientState: 1,
							Type: "Response",
							key: "con"
						}
						send_response(conn, response);
				  end




			  else
				  text = "You do not have any approved loans currently running.\n\nb. Back \n0. End";
				  response = %{
					  message: text,
					  ClientState: 1,
					  Type: "Response",
					  key: "con"
				  }
				  send_response(conn, response);
			  end
		end




		def payLoanBalancePartial(conn, mobile_number, cmd, text, checkMenu, valueEntered) do


        end



		def handleMoMoRepayment(conn, mobile_number, cmd, text, checkMenu, type, amountStr, loan_id, is_reversed, transaction_type_enum,
			transaction_date, principal_portion_derived, interest_portion_derived, fee_charges_portion_derived, penalty_charges_portion_derived,
			overpayment_portion_derived, unrecognized_income_portion, outstanding_loan_balance_derived, submitted_on_date, manually_adjusted_or_reversed, manually_created_by_userid,
			loan, transaction_ref) do

                getstring = String.slice(mobile_number, 0..4)
                case getstring do

                string when string in ["26096", "26076"] ->

                    transferResponse = MtnMomo.request_to_pay(transaction_ref, %{
                        "amount" => "#{amountStr}",
                        "currency" => "ZMW",
                        "externalId" => "135791526",
                        "payer" => %{"partyId" => mobile_number, "partyIdType" => "MSISDN"},
                        "payeeNote" => "accepted",
                        "payerMessage" => "Submitted"
                    });


                    amount = elem Float.parse(amountStr), 0

                    case transferResponse do
                        {:ok, transferResponse} ->
                            IO.inspect transferResponse
                            status = transferResponse["status"];
                            IO.inspect transferResponse["status"];
                            mmoneyResponse = Jason.encode!(transferResponse)

                            if status=="SUCCESSFUL" do

                                Logger.info "Insert Loan Repayment Transaction";
                                loanTransaction = %LoanTransaction{loan_id: loan_id, is_reversed: is_reversed, transaction_type_enum: transaction_type_enum,
                                    transaction_date: transaction_date, amount: amount, principal_portion_derived: principal_portion_derived, interest_portion_derived: interest_portion_derived,
                                    fee_charges_portion_derived: fee_charges_portion_derived,
                                    penalty_charges_portion_derived: penalty_charges_portion_derived, overpayment_portion_derived: overpayment_portion_derived, unrecognized_income_portion: unrecognized_income_portion,
                                    outstanding_loan_balance_derived: outstanding_loan_balance_derived,
                                    submitted_on_date: submitted_on_date, manually_adjusted_or_reversed: manually_adjusted_or_reversed, manually_created_by_userid: manually_created_by_userid,
                                    transaction_ref: transaction_ref
                                }
                                Repo.insert(loanTransaction);


                                query = from au in LoanRepaymentSchedule,
                                    where: (au.loan_id == type(^loan_id, :integer)),
                                    select: au
                                loanRepaymentSchedules = Repo.all(query)
                                for {k, v} <- Enum.with_index(loanRepaymentSchedules) do
                                    loanRepaymentSchedule = Enum.at(loanRepaymentSchedules, v);
                                    obligations_met_on_date = Date.utc_today;

                                    if type==1 do
                                        completed_derived = loanRepaymentSchedule.completed_derived + amount
                                        obligations_met_on_date = nil;
                                        if(completed_derived >= (loanRepaymentSchedule.principal_amount + loanRepaymentSchedule.principal_amount)) do

                                            LoanRepaymentSchedule.changeset(loanRepaymentSchedule, %{obligations_met_on_date: obligations_met_on_date, completed_derived: completed_derived})
                                            |> prepare_update(conn, loanRepaymentSchedule)
                                            |> Repo.transaction()
                                        else

                                            LoanRepaymentSchedule.changeset(loanRepaymentSchedule, %{completed_derived: completed_derived})
                                            |> prepare_update(conn, loanRepaymentSchedule)
                                            |> Repo.transaction()
                                        end
                                    else
                                        completed_derived = loanRepaymentSchedule.principal_amount

                                        LoanRepaymentSchedule.changeset(loanRepaymentSchedule, %{completed_derived: completed_derived})
                                        |> prepare_update(conn, loanRepaymentSchedule)
                                        |> Repo.transaction()
                                    end

                                end

                                closedon_date = Date.utc_today;
                                total_repaid = loan.total_repaid + amount;

                                total_principal_repaid = if(loan.total_principal_repaid<loan.principal_outstanding_derived) do
                                    princpal_diff = loan.principal_outstanding_derived - loan.total_principal_repaid
                                    total_principal_repaid = if(amount<=princpal_diff) do
                                        total_principal_repaid = amount
                                        total_principal_repaid
                                    else
                                        total_principal_repaid = princpal_diff
                                        total_principal_repaid
                                    end
                                    total_principal_repaid
                                else
                                    total_principal_repaid = 0.00
                                end

                                total_interest_repaid = if(loan.total_interest_repaid<loan.interest_outstanding_derived) do
                                    interest_diff = loan.interest_outstanding_derived - loan.total_interest_repaid
                                    amountDiff = amount - total_principal_repaid;
                                    total_interest_repaid = if(amountDiff<=interest_diff) do
                                        total_interest_repaid = amountDiff
                                        total_interest_repaid
                                    else
                                        total_interest_repaid = interest_diff
                                        total_interest_repaid
                                    end
                                    total_interest_repaid
                                else
                                    total_interest_repaid = 0.00
                                end

                                total_charges_repaid = if(loan.total_charges_repaid<(loan.fee_charges_outstanding_derived)) do
                                    charges_diff = loan.fee_charges_outstanding_derived - loan.total_charges_repaid
                                    amountDiff = amount - total_principal_repaid - total_interest_repaid;
                                    total_charges_repaid = if(amountDiff<=charges_diff) do
                                        total_charges_repaid = amountDiff
                                        total_charges_repaid
                                    else
                                        total_charges_repaid = charges_diff
                                        total_charges_repaid
                                    end
                                    total_charges_repaid
                                else
                                    total_charges_repaid = 0.00
                                end

                                total_penalties_repaid = if(loan.total_charges_repaid<(loan.penalty_charges_outstanding_derived)) do
                                    penalty_diff = loan.penalty_charges_outstanding_derived - loan.total_penalties_repaid
                                    amountDiff = amount - total_principal_repaid - total_interest_repaid - total_charges_repaid;
                                    total_penalties_repaid = if(amountDiff<=penalty_diff) do
                                        total_penalties_repaid = amountDiff
                                        total_penalties_repaid
                                    else
                                        total_penalties_repaid = penalty_diff
                                        total_penalties_repaid
                                    end
                                    total_penalties_repaid
                                else
                                    total_penalties_repaid = 0.00
                                end



                                overpayment = amount - total_principal_repaid - total_interest_repaid - total_charges_repaid - total_penalties_repaid

                                IO.inspect "total_principal_repaid....#{total_principal_repaid}"
                                IO.inspect "total_interest_repaid....#{total_interest_repaid}"
                                IO.inspect "total_charges_repaid....#{total_charges_repaid}"


                                principal_repaid_derived = loan.principal_repaid_derived + total_principal_repaid;
                                principal_outstanding_derived = loan.principal_outstanding_derived - total_principal_repaid;

                                interest_repaid_derived = loan.interest_repaid_derived + total_interest_repaid;
                                interest_outstanding_derived = loan.interest_outstanding_derived - total_interest_repaid;

                                fee_charges_repaid_derived = loan.fee_charges_repaid_derived + total_charges_repaid;
                                fee_charges_outstanding_derived = loan.fee_charges_outstanding_derived - total_charges_repaid;

                                penalty_charges_repaid_derived = loan.penalty_charges_repaid_derived + total_penalties_repaid;
                                penalty_charges_outstanding_derived = loan.penalty_charges_outstanding_derived - total_penalties_repaid;

                                total_outstanding_derived = loan.total_outstanding_derived - amount;

                                total_repaid = loan.total_repaid + amount;

                                total_overpaid_derived = loan.total_overpaid_derived + overpayment;

                                total_principal_repaid = loan.total_principal_repaid + total_principal_repaid;
                                total_interest_repaid = loan.total_interest_repaid + total_interest_repaid;
                                total_charges_repaid = loan.total_charges_repaid + total_charges_repaid;
                                total_penalties_repaid = loan.total_penalties_repaid + total_penalties_repaid;


                                status = if(total_outstanding_derived>0) do
                                    loan.loan_status;
                                else
                                    "REPAID";
                                end




                                Loans.changesetForUpdate(loan, %{total_principal_repaid: total_principal_repaid, total_interest_repaid: total_interest_repaid,
                                    total_charges_repaid: total_charges_repaid, total_charges_repaid: total_charges_repaid, loan_status: status, total_overpaid_derived: total_overpaid_derived,
                                    total_repaid: total_repaid, total_outstanding_derived: total_outstanding_derived, penalty_charges_outstanding_derived: penalty_charges_outstanding_derived,
                                    penalty_charges_repaid_derived: penalty_charges_repaid_derived,
                                    fee_charges_outstanding_derived: fee_charges_outstanding_derived, fee_charges_repaid_derived: fee_charges_repaid_derived,
                                    principal_repaid_derived: principal_repaid_derived, principal_outstanding_derived: principal_outstanding_derived,
                                    interest_repaid_derived: interest_repaid_derived, interest_outstanding_derived: interest_outstanding_derived,
                                    fee_charges_repaid_derived: fee_charges_repaid_derived, fee_charges_outstanding_derived: fee_charges_outstanding_derived
                                })
                                |> prepare_update(conn, loan)
                                |> Repo.transaction()


                                if (total_outstanding_derived==0) do
                                    text = "Loan ##{loan.loan_identity_number} completely paid. Thank you\n\nb. Back \n0. End";
                                    response = %{
                                        message: text,
                                        ClientState: 1,
                                        Type: "Response",
                                        key: "con"
                                    }
                                    send_response(conn, response)
                                else
                                    total_outstanding_derived_str = :erlang.float_to_binary((total_outstanding_derived), [decimals: 2])
                                    text = "Loan ##{loan.loan_identity_number} has been partially paid. You still have a balance of ZMW #{total_outstanding_derived_str} Thank you\n\nb. Back \n0. End";
                                    response = %{
                                        message: text,
                                        ClientState: 1,
                                        Type: "Response",
                                        key: "con"
                                    }
                                    send_response(conn, response)
                                end

                            else
                                IO.inspect("failed");
                                Logger.info("Fail")
                                response = %{
                                message: "Your repayment for a loan was not successful. Please try again",
                                ClientState: 1,
                                Type: "Response",
                                key: "end"
                                }
                                send_response(conn, response)

                            end

                        {:error, errorMessage} ->

                            IO.inspect("failed");
                            Logger.info("Fail")
                            response = %{
                            message: "Your repayment for a loan was not successful. Please try again",
                            ClientState: 1,
                            Type: "Response",
                            key: "end"
                            }
                            send_response(conn, response)
                        end


                string when string in ["26097", "26077"] ->
                            random_int3 = to_string(Enum.random(11111111..99999999))
                            airtel_mobile = String.slice(mobile_number, 3..12)
                            airteltransferResponse = AirtelMomo.collections_ussd_push(%{
                                :reference => "Testing transaction",
                                :subscriber => %{
                                  :country => "ZM",
                                  :currency => "ZMW",
                                  :msisdn => airtel_mobile
                                },
                                :transaction => %{
                                  :amount => "#{amountStr}",
                                  :country => "ZM",
                                  :currency => "ZMW",
                                  :id => random_int3
                                }
                              })
                              IO.inspect airteltransferResponse


                    amount = elem Float.parse(amountStr), 0

                    case airteltransferResponse do
                        {:ok, airteltransferResponse, status} ->
                            %{"data" => data, "status" => responsestatus} = airteltransferResponse
                            %{"transaction" => datatransaction} = data
                            %{"id" => getairteltransid, "status" => getstatus} = datatransaction
                            IO.inspect getstatus
                            IO.inspect getairteltransid
                            IO.inspect "KILLLLLLLL ZONEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"
                            IO.inspect "CALL of  dutttttttyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
                            airteltransaction_ref = airteltransferResponse["code"]
                            IO.inspect airteltransferResponse
                            mmoneyResponse = Jason.encode!(airteltransferResponse)
                            IO.inspect mmoneyResponse

                            if status==200 do

                                Logger.info "Insert Loan Repayment Transaction";
                                loanTransaction = %LoanTransaction{loan_id: loan_id, is_reversed: is_reversed, transaction_type_enum: transaction_type_enum,
                                    transaction_date: transaction_date, amount: amount, principal_portion_derived: principal_portion_derived, interest_portion_derived: interest_portion_derived,
                                    fee_charges_portion_derived: fee_charges_portion_derived,
                                    penalty_charges_portion_derived: penalty_charges_portion_derived, overpayment_portion_derived: overpayment_portion_derived, unrecognized_income_portion: unrecognized_income_portion,
                                    outstanding_loan_balance_derived: outstanding_loan_balance_derived,
                                    submitted_on_date: submitted_on_date, manually_adjusted_or_reversed: manually_adjusted_or_reversed, manually_created_by_userid: manually_created_by_userid,
                                    transaction_ref: transaction_ref
                                }
                                Repo.insert(loanTransaction);


                                query = from au in LoanRepaymentSchedule,
                                    where: (au.loan_id == type(^loan_id, :integer)),
                                    select: au
                                loanRepaymentSchedules = Repo.all(query)
                                for {k, v} <- Enum.with_index(loanRepaymentSchedules) do
                                    loanRepaymentSchedule = Enum.at(loanRepaymentSchedules, v);
                                    obligations_met_on_date = Date.utc_today;

                                    if type==1 do
                                        completed_derived = loanRepaymentSchedule.completed_derived + amount
                                        obligations_met_on_date = nil;
                                        if(completed_derived >= (loanRepaymentSchedule.principal_amount + loanRepaymentSchedule.principal_amount)) do

                                            LoanRepaymentSchedule.changeset(loanRepaymentSchedule, %{obligations_met_on_date: obligations_met_on_date, completed_derived: completed_derived})
                                            |> prepare_update(conn, loanRepaymentSchedule)
                                            |> Repo.transaction()
                                        else

                                            LoanRepaymentSchedule.changeset(loanRepaymentSchedule, %{completed_derived: completed_derived})
                                            |> prepare_update(conn, loanRepaymentSchedule)
                                            |> Repo.transaction()
                                        end
                                    else
                                        completed_derived = loanRepaymentSchedule.principal_amount

                                        LoanRepaymentSchedule.changeset(loanRepaymentSchedule, %{completed_derived: completed_derived})
                                        |> prepare_update(conn, loanRepaymentSchedule)
                                        |> Repo.transaction()
                                    end

                                end

                                closedon_date = Date.utc_today;
                                total_repaid = loan.total_repaid + amount;

                                total_principal_repaid = if(loan.total_principal_repaid<loan.principal_outstanding_derived) do
                                    princpal_diff = loan.principal_outstanding_derived - loan.total_principal_repaid
                                    total_principal_repaid = if(amount<=princpal_diff) do
                                        total_principal_repaid = amount
                                        total_principal_repaid
                                    else
                                        total_principal_repaid = princpal_diff
                                        total_principal_repaid
                                    end
                                    total_principal_repaid
                                else
                                    total_principal_repaid = 0.00
                                end

                                total_interest_repaid = if(loan.total_interest_repaid<loan.interest_outstanding_derived) do
                                    interest_diff = loan.interest_outstanding_derived - loan.total_interest_repaid
                                    amountDiff = amount - total_principal_repaid;
                                    total_interest_repaid = if(amountDiff<=interest_diff) do
                                        total_interest_repaid = amountDiff
                                        total_interest_repaid
                                    else
                                        total_interest_repaid = interest_diff
                                        total_interest_repaid
                                    end
                                    total_interest_repaid
                                else
                                    total_interest_repaid = 0.00
                                end

                                total_charges_repaid = if(loan.total_charges_repaid<(loan.fee_charges_outstanding_derived)) do
                                    charges_diff = loan.fee_charges_outstanding_derived - loan.total_charges_repaid
                                    amountDiff = amount - total_principal_repaid - total_interest_repaid;
                                    total_charges_repaid = if(amountDiff<=charges_diff) do
                                        total_charges_repaid = amountDiff
                                        total_charges_repaid
                                    else
                                        total_charges_repaid = charges_diff
                                        total_charges_repaid
                                    end
                                    total_charges_repaid
                                else
                                    total_charges_repaid = 0.00
                                end

                                total_penalties_repaid = if(loan.total_charges_repaid<(loan.penalty_charges_outstanding_derived)) do
                                    penalty_diff = loan.penalty_charges_outstanding_derived - loan.total_penalties_repaid
                                    amountDiff = amount - total_principal_repaid - total_interest_repaid - total_charges_repaid;
                                    total_penalties_repaid = if(amountDiff<=penalty_diff) do
                                        total_penalties_repaid = amountDiff
                                        total_penalties_repaid
                                    else
                                        total_penalties_repaid = penalty_diff
                                        total_penalties_repaid
                                    end
                                    total_penalties_repaid
                                else
                                    total_penalties_repaid = 0.00
                                end



                                overpayment = amount - total_principal_repaid - total_interest_repaid - total_charges_repaid - total_penalties_repaid

                                IO.inspect "total_principal_repaid....#{total_principal_repaid}"
                                IO.inspect "total_interest_repaid....#{total_interest_repaid}"
                                IO.inspect "total_charges_repaid....#{total_charges_repaid}"


                                principal_repaid_derived = loan.principal_repaid_derived + total_principal_repaid;
                                principal_outstanding_derived = loan.principal_outstanding_derived - total_principal_repaid;

                                interest_repaid_derived = loan.interest_repaid_derived + total_interest_repaid;
                                interest_outstanding_derived = loan.interest_outstanding_derived - total_interest_repaid;

                                fee_charges_repaid_derived = loan.fee_charges_repaid_derived + total_charges_repaid;
                                fee_charges_outstanding_derived = loan.fee_charges_outstanding_derived - total_charges_repaid;

                                penalty_charges_repaid_derived = loan.penalty_charges_repaid_derived + total_penalties_repaid;
                                penalty_charges_outstanding_derived = loan.penalty_charges_outstanding_derived - total_penalties_repaid;

                                total_outstanding_derived = loan.total_outstanding_derived - amount;

                                total_repaid = loan.total_repaid + amount;

                                total_overpaid_derived = loan.total_overpaid_derived + overpayment;

                                total_principal_repaid = loan.total_principal_repaid + total_principal_repaid;
                                total_interest_repaid = loan.total_interest_repaid + total_interest_repaid;
                                total_charges_repaid = loan.total_charges_repaid + total_charges_repaid;
                                total_penalties_repaid = loan.total_penalties_repaid + total_penalties_repaid;


                                status = if(total_outstanding_derived>0) do
                                    loan.loan_status;
                                else
                                    "REPAID";
                                end




                                Loans.changesetForUpdate(loan, %{total_principal_repaid: total_principal_repaid, total_interest_repaid: total_interest_repaid,
                                    total_charges_repaid: total_charges_repaid, total_charges_repaid: total_charges_repaid, loan_status: status, total_overpaid_derived: total_overpaid_derived,
                                    total_repaid: total_repaid, total_outstanding_derived: total_outstanding_derived, penalty_charges_outstanding_derived: penalty_charges_outstanding_derived,
                                    penalty_charges_repaid_derived: penalty_charges_repaid_derived,
                                    fee_charges_outstanding_derived: fee_charges_outstanding_derived, fee_charges_repaid_derived: fee_charges_repaid_derived,
                                    principal_repaid_derived: principal_repaid_derived, principal_outstanding_derived: principal_outstanding_derived,
                                    interest_repaid_derived: interest_repaid_derived, interest_outstanding_derived: interest_outstanding_derived,
                                    fee_charges_repaid_derived: fee_charges_repaid_derived, fee_charges_outstanding_derived: fee_charges_outstanding_derived
                                })
                                |> prepare_update(conn, loan)
                                |> Repo.transaction()


                                if (total_outstanding_derived==0) do
                                    text = "Loan  ##{loan.loan_identity_number} completely paid. Thank you\n\nb. Back \n0. End";
                                    response = %{
                                        message: text,
                                        ClientState: 1,
                                        Type: "Response",
                                        key: "con"
                                    }
                                    send_response(conn, response)
                                else
                                    total_outstanding_derived_str = :erlang.float_to_binary((total_outstanding_derived), [decimals: 2])
                                    text = "Please Enter Pin to make payment of Loan ##{loan.loan_identity_number}. You still have a balance of ZMW #{total_outstanding_derived_str} Thank you\n\nb. Back \n0. End";
                                    response = %{
                                        message: text,
                                        ClientState: 1,
                                        Type: "Response",
                                        key: "con"
                                    }
                                    send_response(conn, response)
                                end

                            else
                                IO.inspect("failed");
                                Logger.info("Fail")
                                response = %{
                                message: "Your repayment for a loan was not successful. Please try again",
                                ClientState: 1,
                                Type: "Response",
                                key: "end"
                                }
                                send_response(conn, response)

                            end

                        {:error, message, status} ->

                            IO.inspect("failed");
                            Logger.info("Fail")
                            response = %{
                            message: "Your repayment for a loan was not successful. Please try again",
                            ClientState: 1,
                            Type: "Response",
                            key: "end"
                            }
                            send_response(conn, response)
                        end
                end





		end

      def prepare_update(changeset, conn, object) do
          Ecto.Multi.new()
          |> Ecto.Multi.update(:object, changeset)
      end


      def handleGetLoan(conn, mobile_number, cmd, text, checkMenu, ussdRequests) do

          checkMenuLength = Enum.count(checkMenu)
          valueEntered = Enum.at(checkMenu, 3)
          Logger.info("handleGetLoan");
          Logger.info(checkMenuLength);
          Logger.info(valueEntered);
          Logger.info(text);

          year = Timex.today.year;
          month = Timex.today.month;


          if valueEntered == "b" do
              response = %{
                  message: "",
                  ClientState: 1,
                  Type: "Response",
                  key: "BA3"
              }
              send_response(conn, response)
          else
              case checkMenuLength do
                  4 ->

                      activeStatus = "ACTIVE";
                      query = from au in LoanSystem.Companies.Staff, where: au.phone == ^mobile_number and au.status == ^activeStatus, select: au
                      companyStaff = Repo.one(query)

                      staffLoanLimit = companyStaff.loan_limit;

                      query = from au in LoanSystem.Companies.Company, where: au.id == ^companyStaff.company_id, select: au
                      comp = Repo.one(query)
                      companyProductId = comp.product_code
                      get_payday = comp.payday



                      query = from au in LoanProduct, where: au.id == ^companyProductId, select: au
                      lp = Repo.one(query)

                      query = from au in AppUser, where: au.mobile_number == ^mobile_number, select: au
                      appUs = Repo.one(query)
                      status = "Disbursed";
                      statusList = ["Disbursed", "Pending Approval"];
                      query = from au in Loans,
                          where: (au.loan_status in ^statusList and au.app_user_id == type(^appUs.id, :integer)),
                          select: au
                      loans = Repo.all(query);

                    # #   quetotal_amountry = Repo.all(from(u in Loans, select: sum(u.principal_amount), whereid and u.app_user_id == type(^appUs.id, :integer)))



                    query = from p in Loans,
                    where: p.loan_status in ^statusList and p.customer_id == type(^appUs.staff_id, :integer),
                    select: %{
                        principal_amount: sum(p.principal_amount),
                    }

                    loans_principal_amount = Repo.all(query);
                    check_user_sum = loans_principal_amount |> Enum.at(0)

                    p_list = Map.values(check_user_sum)
                    sum_value = p_list |> Enum.at(0)
                    #   [%{principal_amount: 3285.0}]

                    sum_value = if sum_value == nil do
                        sum_value = 0
                        sum_value
                    else
                        sum_value
                    end

                    staffLoanLimit = elem Float.parse(staffLoanLimit), 0
                    IO.inspect "pppppppppppppppjamesphiripppppppppppppppppppp"
                    IO.inspect staffLoanLimit
                    IO.inspect "ppppppppppppppppppppppppppppppppppp"
                    subtractactiveloan = if sum_value == nil do
                            subtractactiveloan = staffLoanLimit
                            subtractactiveloan
                        else
                            subtractactiveloan = staffLoanLimit - sum_value
                            subtractactiveloan
                        end


                    IO.inspect "pppppppppppppppjamesphiripppppppppppppppppppp"
                    IO.inspect subtractactiveloan
                    IO.inspect sum_value
                    IO.inspect "ppppppppppppppppppppppppppppppppppp"
                    todays_date = Timex.today.day
                      IO.inspect Enum.count(loans)
                      if todays_date>get_payday do
                            response = %{
                                message: "You have suppassed the Payday date #{get_payday}-#{month}-#{year}. You can only gat a new loan after the last day on this month. \nPress \n\nb. Back\n0. Exit",
                                ClientState: 1,
                                Type: "Response",
                                key: "con"
                            }
                            end_session(ussdRequests, conn, response);
                      else
                        if (sum_value>staffLoanLimit) do
                            response = %{
                                    message: "You have reached your Loan Limit. You can only get another loan after you have repaid your current outstanding loan. \nPress \n\nb. Back\n0. Exit",
                                    ClientState: 1,
                                    Type: "Response",
                                    key: "con"
                            }
                            end_session(ussdRequests, conn, response);
                        else
                            minprinc = :erlang.float_to_binary((lp.min_principal_amount), [decimals: 2])
                            maxprinc = :erlang.float_to_binary((lp.max_principal_amount), [decimals: 2])

                            # staffLoanLimit = elem Float.parse(staffLoanLimit), 0
                            subtractactiveloan = :erlang.float_to_binary((subtractactiveloan), [decimals: 2])
                            response = %{
                                message: "Enter Amount (ZMW#{minprinc} - ZMW#{subtractactiveloan})",
                                ClientState: 1,
                                Type: "Response",
                                key: "con"
                            }
                            send_response(conn, response)
                        end
                    end

                  5 ->
                      activeStatus = "ACTIVE";
                      query = from au in LoanSystem.Companies.Staff, where: au.phone == ^mobile_number and au.status == ^activeStatus, select: au
                      companyStaff = Repo.one(query)



                      query = from au in LoanSystem.Companies.Company, where: au.id == ^companyStaff.company_id, select: au
                      comp = Repo.one(query)
                      companyProductId = comp.product_code
                      get_payday = comp.payday

                      status = "Disbursed";
                      statusList = ["Disbursed", "Pending Approval"];

                      query = from au in AppUser, where: au.mobile_number == ^mobile_number, select: au
                      appUs = Repo.one(query)

                      query = from p in Loans,
                        where: p.loan_status in ^statusList and p.customer_id == type(^appUs.staff_id, :integer),
                        select: %{
                            principal_amount: sum(p.principal_amount),
                        }

                        loans_principal_amount = Repo.all(query);
                        check_user_sum = loans_principal_amount |> Enum.at(0)

                        p_list = Map.values(check_user_sum)
                        sum_value = p_list |> Enum.at(0)
                        #   [%{principal_amount: 3285.0}]

                        sum_value = if sum_value == nil do
                            sum_value = 0
                            sum_value
                        else
                            sum_value
                        end

                      IO.inspect "((((((((((((((((((Ackson"
                      IO.inspect get_payday
                      IO.inspect "((((((((((((((((((Ackson"
                      amount = Enum.at(checkMenu, 3)
                      amountFloat = elem Float.parse(amount), 0
                      staffLoanLimit = companyStaff.loan_limit;
                      staffLoanLimit = elem Float.parse(staffLoanLimit), 0

                      subtractactiveloan = if sum_value == nil do
                        subtractactiveloan = staffLoanLimit
                        subtractactiveloan
                    else
                        subtractactiveloan = staffLoanLimit - sum_value
                        subtractactiveloan
                    end

                      IO.inspect "???????????????????????????????"
                      IO.inspect amountFloat
                      IO.inspect staffLoanLimit

                        if(amountFloat>staffLoanLimit) do
                            staffLoanLimit = :erlang.float_to_binary((staffLoanLimit), [decimals: 2])
                            response = %{
                                message: "Your loan limit is ZMW #{staffLoanLimit}. You cannot take more than the loan limit assigned to you. \nPress \n\nb. Back\n0. Exit",
                                ClientState: 2,
                                Type: "Response",
                                key: "con"
                            }
                            send_response(conn, response);

                            else
                                if(amountFloat>subtractactiveloan) do
                                    staffLoanLimit = :erlang.float_to_binary((staffLoanLimit), [decimals: 2])
                                    sum_value = :erlang.float_to_binary((sum_value), [decimals: 2])
                                    subtractactiveloan = :erlang.float_to_binary((subtractactiveloan), [decimals: 2])
                                    response = %{
                                        message: "Your loan limit is ZMW #{staffLoanLimit}. You already have an outstanding loan of ZMW #{sum_value}. You can not get more than ZMW #{subtractactiveloan} \nPress \n\nb. Back\n0. Exit",
                                        ClientState: 2,
                                        Type: "Response",
                                        key: "con"
                                    }
                                    send_response(conn, response);

                                else

                                amount = Enum.at(checkMenu, 3)
                                #Logger.info amount
                                query = from au in LoanProduct,
                                    where: (au.min_principal_amount <= type(^amount, :float) and au.id == ^companyProductId and au.max_principal_amount >= type(^amount, :float)),
                                    select: au
                                loanProducts = Repo.all(query)

                                IO.inspect "^^^^^^^^^^^^^^^^^^^^^^james"
                                IO.inspect loanProducts
                                IO.inspect "^^^^^^^^^^^^^^^^^^^^^^james"

                                if Enum.count(loanProducts) == 0 do
                                    response = %{
                                        message: "We do not provide loans for the amount provided. \nPress \n\nb. Back\n0. Exit",
                                        ClientState: 2,
                                        Type: "Response",
                                        key: "con"
                                    }
                                    send_response(conn, response)
                                else
                                    loanProduct = Enum.at(loanProducts, 0);
                                    query = from au in USSDLoanProduct,
                                        where: (au.loan_product_id == type(^loanProduct.id, :integer)),
                                        select: au
                                    ussdLoanProducts = Repo.all(query)

                                    dayOptions = [];
                                    dayOptions = for {k, v} <- Enum.with_index(ussdLoanProducts) do
                                        #Logger.info (k.id)
                                        totalRepayAmount =0.00
                                        if Enum.member?(dayOptions, k.default_period) do

                                        else

                                            default_rate = k.default_interest_rate
                                            default_period = k.default_period
                                            annual_period = loanProduct.days_in_year
                                            amt = elem Integer.parse(amount), 0
                                            no_of_payments = k.repayment_count
                                            monthlyRepayment = calculate_monthly_repayments(amt, default_period/30, default_rate, annual_period, no_of_payments)
                                            Logger.info "Test";
                                            Logger.info ((monthlyRepayment));
                                            totalRepayAmount = monthlyRepayment * no_of_payments

                                            totalRepayAmount = :erlang.float_to_binary((totalRepayAmount), [decimals: 2])
                                            Logger.info "#{totalRepayAmount}"
                                            default_period = :erlang.integer_to_binary(default_period)
                                            get_payday = :erlang.integer_to_binary(get_payday)

                                            repay_entry = "#{v+1}. " <> loanProduct.currency_code <> totalRepayAmount <> " by " <> get_payday <> "-" <> "#{month}" <> "-" <> "#{year}"
                                            Logger.info "#{totalRepayAmount}"
                                            dayOptions = dayOptions ++ [repay_entry]
                                            Logger.info "&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&"
                                            dayOptions
                                        end
                                    end


                                    if (Enum.count(dayOptions)>0) do
                                        optionsList = "";
                                        optionsList = Enum.join(dayOptions, "\n");

                                        Logger.info optionsList

                                        msg = "Choose One. \n" <> optionsList <> "\n\n1. Confirm\nb. Back"
                                        response = %{
                                            message: msg,
                                            ClientState: 2,
                                            Type: "Response",
                                            key: "con"
                                        }
                                        send_response(conn, response)
                                    else
                                        response = %{
                                            message: "There are no loan options available at the moment\n\n1. Choose One\n0. Exit\nb. Back",
                                            ClientState: 2,
                                            Type: "Response",
                                            key: "con"
                                        }
                                        send_response(conn, response)

                                    end
                                end
                            end
                        end
                  6 ->
                      selectedIndex = Enum.at(checkMenu, 4)
                      selectedIndex = elem Integer.parse(selectedIndex), 0
                      Logger.info "<<<<<<"
                      Logger.info selectedIndex
                      amount = Enum.at(checkMenu, 3)
                      Logger.info amount
                      query = from au in LoanProduct,
                          where: (au.min_principal_amount <= type(^amount, :float) and au.max_principal_amount >= type(^amount, :float)),
                          select: au
                      loanProducts = Repo.all(query)

                      IO.inspect "WWWWWWWWWWWWWWWWW"
                      IO.inspect loanProducts
                      IO.inspect "WWWWWWWWWWWWWWWWW"

                      activeStatus = "ACTIVE";
                      query = from au in LoanSystem.Companies.Staff, where: au.phone == ^mobile_number and au.status == ^activeStatus, select: au
                      companyStaff = Repo.one(query)

                      query = from au in LoanSystem.Companies.Company, where: au.id == ^companyStaff.company_id, select: au
                      comp = Repo.one(query)
                      get_payday = comp.payday



                      year = Timex.today.year;
                      month = Timex.today.month;

                      loanProduct = Enum.at(loanProducts, 0);
                      query = from au in USSDLoanProduct,
                          where: (au.loan_product_id == type(^loanProduct.id, :integer)),
                          select: au
                      ussdLoanProducts = Repo.all(query)

                      dayOptions = [];
                      dayOptions = for {k, v} <- Enum.with_index(ussdLoanProducts) do
                          #Logger.info (k.id)
                          totalRepayAmount =0.00
                          if Enum.member?(dayOptions, k.default_period) do

                          else

                              default_rate = loanProduct.min_nominal_interest_rate_per_period
                              default_period = k.default_period
                              annual_period = loanProduct.days_in_year

                              IO.inspect "(((((((((((((((((((((((((((((((((((())))))))))))))))))))))))))))))))))))"
                              IO.inspect default_rate
                              IO.inspect default_period
                              IO.inspect annual_period
                              amt = elem Integer.parse(amount), 0
                              no_of_payments = k.repayment_count
                              monthlyRepayment = calculate_monthly_repayments(amt, default_period/30, default_rate, annual_period, no_of_payments)
                              Logger.info "Test";
                              Logger.info ((monthlyRepayment));
                              totalRepayAmount = monthlyRepayment * no_of_payments

                              totalRepayAmount = :erlang.float_to_binary((totalRepayAmount), [decimals: 2])
                              Logger.info "#{totalRepayAmount}"
                              default_period = :erlang.integer_to_binary(default_period)
                              get_payday = :erlang.integer_to_binary(get_payday)

                              repay_entry = "#{v+1}. " <> loanProduct.currency_code <> totalRepayAmount <> " by " <> get_payday <> "-" <> "#{month}" <> "-" <> "#{year}"
                              Logger.info "#{totalRepayAmount}"
                              dayOptions = dayOptions ++ [repay_entry]


                        end
                     end
                      if (Enum.count(dayOptions)>0) do
                          optionsList = "";
                          optionsList = Enum.join(dayOptions, "\n");

                          Logger.info optionsList
                          msg = "Your repayment schedule. \n" <> optionsList <> "\n\n1. Confirm\nb. Back"

                          response = %{
                              message: msg,
                              ClientState: 2,
                              Type: "Response",
                              key: "con"
                          }
                          send_response(conn, response)
                      else
                          response = %{
                              message: "There are no loan options currently available\n\n1. Choose One\n0. Exit\nb. Back",
                              ClientState: 2,
                              Type: "Response",
                              key: "con"
                          }
                          send_response(conn, response)

                      end
                  7 ->
                      confirmChoice = Enum.at(checkMenu, 5)
                      confirmChoice = elem Integer.parse(confirmChoice), 0
                      if confirmChoice != 0 do
                          amount = Enum.at(checkMenu, 3)
                          amount = elem Float.parse(amount), 0
                          #Logger.info amount
                          query = from au in LoanProduct,
                              where: (au.min_principal_amount <= type(^amount, :float) and au.max_principal_amount >= type(^amount, :float)),
                              select: au
                          loanProducts = Repo.all(query)

                          loanProduct = Enum.at(loanProducts, 0);
                          query = from au in USSDLoanProduct,
                              where: (au.loan_product_id == type(^loanProduct.id, :integer)),
                              offset: ^(confirmChoice - 1),
                              limit: 1,
                              order_by: au.id,
                              select: au
                          ussdLoanProducts = Repo.all(query)
                          ussdLoanProduct = Enum.at(ussdLoanProducts, 0);


                          query = from au in AppUser,
                              where: (au.mobile_number == type(^mobile_number, :string)),
                              select: au
                          appUsers = Repo.all(query);
                          appUser = Enum.at(appUsers, 0);


                          staff = nil;
                          if(!is_nil(appUser.staff_id)) do
                              query = from au in Staff,
                                  where: (au.id == type(^appUser.staff_id, :integer)),
                                  select: au
                              staffs = Repo.all(query);
                              staff = Enum.at(staffs, 0);
                          end


                          Logger.info "Twst ........";
                          Logger.info loanProduct.id;
                          Logger.info ussdLoanProduct.loan_product_id;
                          Logger.info "{confirmChoice}";
                          totalCharges = 0.00;
                          query = from au in LoanProductCharge,
                              where: (au.loan_product_id == type(^loanProduct.id, :integer)),
                              select: au
                          loanProductCharges = Repo.all(query);
                          Logger.info "Loan Charges";
                          Logger.info Enum.count(loanProductCharges);

                          loanProductCharge = nil;
                          charge = nil;
                          charge = if Enum.count(loanProductCharges)>0 do
                              loanProductCharge = Enum.at(loanProductCharges, 0);

                              query = from au in Charge,
                                  where: (au.id == type(^loanProductCharge.charge_id, :integer) and au.applicable_during_disbursement == true),
                                  select: au
                              charges = Repo.all(query);
                              charge = Enum.at(charges, 0);
                          end


                          annual_period = loanProduct.days_in_year
                          account_no = nil;
                          customer_id = appUser.staff_id;
                          branch_id = appUser.staff_id;

                          if(!is_nil(staff)) do
                              branch_id = staff.branch_id;
                              account_no = staff.account_no;
                              customer_id = staff.id;
                          end


                          app_user_id = appUser.id;
                          product_id = ussdLoanProduct.loan_product_id;
                        #   loan_status = "Disbursed";
                          loan_status = "PENDING_MOMO";
						  status = "PENDING_MOMO";
                          loan_type = "Salary Loan";
                          currency_code = loanProduct.currency_code;
                          principal_amount_proposed = amount;
                          principal_amount = amount;          #COMMENT OUT IF APPROVAL PROCESS APPLIES
                          approved_principal = amount;        #COMMENT OUT IF APPROVAL PROCESS APPLIES
                          annual_nominal_interest_rate = loanProduct.min_nominal_interest_rate_per_period;
                          interest_method = "FLAT";
                          term_frequency = ussdLoanProduct.default_period;
                          term_frequency_type = "DAYS";
                          repay_every = 30;
                          repay_every_type = "DAYS";
                          number_of_repayments = ussdLoanProduct.repayment_count;
                          approvedon_date = Date.utc_today;
                          expected_disbursedon_date = Date.utc_today;
                          disbursedon_date = Date.utc_today;  #COMMENT OUT IF APPROVAL PROCESS APPLIES
                          expected_maturity_date = Date.add(Date.utc_today, ((number_of_repayments)*30));
                          interest_calculated_from_date = Date.utc_today;
                          principal_disbursed_derived = amount;
                          interest_waived_derived = 0.00;
                          interest_writtenoff_derived = 0.00;



                          monthylyRepayAmount = calculate_monthly_repayments(amount, term_frequency/30, annual_nominal_interest_rate, annual_period, number_of_repayments)
                          Logger.info "*********"
                          Logger.info monthylyRepayAmount
                          #monthylyRepayAmount = :erlang.float_to_binary(monthylyRepayAmount, [decimals: 2]);
                          totalRepayAmount = monthylyRepayAmount * number_of_repayments;
                          interest_outstanding_derived = totalRepayAmount - amount;
                          fee_charges_charged_derived = totalCharges;
                          fee_charges_repaid_derived = totalCharges;
                          fee_charges_waived_derived = 0.00;
                          fee_charges_writtenoff_derived = 0.00;
                          fee_charges_outstanding_derived = 0.00;
                          penalty_charges_charged_derived = 0.00;
                          penalty_charges_repaid_derived = 0.00;
                          penalty_charges_waived_derived = 0.00;
                          penalty_charges_writtenoff_derived = 0.00;
                          penalty_charges_outstanding_derived = 0.00;
                          total_expected_repayment_derived = totalRepayAmount;
                          total_repayment_derived = totalRepayAmount;
                          total_expected_costofloan_derived = totalCharges;
                          total_costofloan_derived = totalCharges;
                          total_waived_derived = 0.00;
                          total_outstanding_derived = totalRepayAmount;
                          total_overpaid_derived = 0.00;
                          withdrawnon_date = Date.utc_today;
                          loan_counter = 1;
                          is_npa = false;
                          is_legacyloan = false;
                          interest_charged_derived = 0.00;
                          interest_repaid_derived = 0.00;
                          interest_waived_derived = 0.00;
                          interest_writtenoff_derived = 0.00;
                          principal_repaid_derived = 0.00;
                          principal_writtenoff_derived = 0.00;
                          total_writtenoff_derived = 0.00;


                          query = from au in Loans,
                              select: au
                          loans = Repo.all(query);
                          loanIdentityNumber = Enum.count(loans);
                          loanIdentityNumber = "0000000#{loanIdentityNumber}";
                            getstring = String.slice(mobile_number, 0..4)

                            case getstring do

                                string when string in ["26096", "26076"] ->

                                    transaction_ref = UUID.uuid4()

                                    loan = %Loans{app_user_id: app_user_id, account_no: account_no, customer_id: customer_id, product_id: product_id, loan_status: loan_status, loan_type: loan_type,
                                            currency_code: currency_code, principal_amount_proposed: principal_amount_proposed, principal_amount: principal_amount, approved_principal: approved_principal,
                                            annual_nominal_interest_rate: annual_nominal_interest_rate, interest_method: interest_method, term_frequency: term_frequency,
                                            term_frequency_type: term_frequency_type, repay_every: repay_every, repay_every_type: repay_every_type, number_of_repayments: number_of_repayments, approvedon_date: approvedon_date,
                                            expected_disbursedon_date: expected_disbursedon_date, disbursedon_date: disbursedon_date, expected_maturity_date: expected_maturity_date, interest_calculated_from_date: interest_calculated_from_date,
                                            principal_disbursed_derived: principal_disbursed_derived, loan_identity_number: loanIdentityNumber, branch_id: branch_id,
                                            principal_repaid_derived: principal_repaid_derived, principal_writtenoff_derived: principal_writtenoff_derived, principal_outstanding_derived: amount,
                                            interest_charged_derived: interest_charged_derived, interest_repaid_derived: interest_repaid_derived,
                                            interest_waived_derived: interest_waived_derived, interest_writtenoff_derived: interest_writtenoff_derived, interest_outstanding_derived: interest_outstanding_derived,
                                            fee_charges_charged_derived: fee_charges_charged_derived, fee_charges_repaid_derived: fee_charges_repaid_derived,
                                            fee_charges_waived_derived: fee_charges_waived_derived, fee_charges_writtenoff_derived: fee_charges_writtenoff_derived, fee_charges_outstanding_derived: fee_charges_outstanding_derived,
                                            penalty_charges_charged_derived: penalty_charges_charged_derived, penalty_charges_repaid_derived: penalty_charges_repaid_derived,
                                            penalty_charges_waived_derived: penalty_charges_waived_derived, penalty_charges_writtenoff_derived: penalty_charges_writtenoff_derived, penalty_charges_outstanding_derived:
                                            penalty_charges_outstanding_derived, total_expected_repayment_derived: total_expected_repayment_derived, total_repayment_derived: total_repayment_derived,
                                            total_expected_costofloan_derived: total_expected_costofloan_derived, total_costofloan_derived: total_costofloan_derived, total_waived_derived: total_waived_derived, total_writtenoff_derived:
                                            total_writtenoff_derived, total_outstanding_derived: total_outstanding_derived, total_overpaid_derived: total_overpaid_derived,
                                            withdrawnon_date: withdrawnon_date, loan_counter: loan_counter, is_npa: is_npa, is_legacyloan: is_legacyloan, total_charges_due_at_disbursement_derived: totalCharges, status: status}
                                    case Repo.insert(loan) do
                                        {:ok, loan} ->

                                            loan_id = loan.id;

                                            if charge != nil do
                                                Logger.info "Charge";
                                                Logger.info charge.type;

                                                totalCharges = if charge.type=="PERCENT" do
                                                    totalCharges = (amount * charge.valuation)/100;
                                                else
                                                    if charge.type=="FLAT FEE" do
                                                        totalCharges = charge.valuation;
                                                    end
                                                end
                                                Logger.info "totalCharges";
                                                Logger.info totalCharges;
                                                charge_id = charge.id;
                                                is_penalty = charge.is_penalty;
                                                charge_time_enum = "DISBURSEMENT";
                                                due_for_collection_as_of_date = Date.utc_today;
                                                charge_calculation_enum = charge.type;
                                                charge_payment_mode_enum = "MOBILEMONEY";
                                                calculation_percentage = charge.valuation;
                                                calculation_on_amount = amount;
                                                charge_amount_or_percentage = charge.valuation;
                                                amount = amount;
                                                amount_paid_derived = totalCharges;
                                                amount_waived_derived = totalCharges;
                                                amount_writtenoff_derived = 0.00;
                                                amount_writtenoff_derived = 0.00;
                                                amount_outstanding_derived = 0.00;
                                                is_paid_derived = true;
                                                is_waived = false;
                                                is_active = false;

                                                loanCharge = %LoanCharge{loan_id: loan_id, charge_id: charge_id, is_penalty: is_penalty, charge_time_enum: charge_time_enum, due_for_collection_as_of_date: due_for_collection_as_of_date,
                                                    charge_calculation_enum: charge_calculation_enum, charge_payment_mode_enum: charge_payment_mode_enum, calculation_percentage: calculation_percentage,
                                                    calculation_on_amount: calculation_on_amount, charge_amount_or_percentage: charge_amount_or_percentage, amount: amount, amount_paid_derived: amount_paid_derived,
                                                    amount_waived_derived: amount_waived_derived, amount_writtenoff_derived: amount_writtenoff_derived, amount_outstanding_derived: amount_outstanding_derived,
                                                    is_paid_derived: is_paid_derived, is_waived: is_waived, is_active: is_active}
                                                Repo.insert(loanCharge);

                                                is_reversed = false;
                                                transaction_type_enum = "LOAN CHARGE PAYMENT";
                                                transaction_date = Date.utc_today;
                                                principal_portion_derived = 0.00;
                                                interest_portion_derived = 0.00;
                                                fee_charges_portion_derived = totalCharges;
                                                penalty_charges_portion_derived = 0.00;
                                                overpayment_portion_derived = 0.00;
                                                unrecognized_income_portion = 0.00;
                                                outstanding_loan_balance_derived = 0.00;
                                                submitted_on_date = Date.utc_today;
                                                manually_adjusted_or_reversed = false;
                                                manually_created_by_userid = nil;
                                                loanTransaction = %LoanTransaction{loan_id: loan_id, is_reversed: is_reversed, transaction_type_enum: transaction_type_enum,
                                                    transaction_date: transaction_date, amount: totalCharges, principal_portion_derived: principal_portion_derived, interest_portion_derived: interest_portion_derived,
                                                    fee_charges_portion_derived: fee_charges_portion_derived,
                                                    penalty_charges_portion_derived: penalty_charges_portion_derived, overpayment_portion_derived: overpayment_portion_derived, unrecognized_income_portion: unrecognized_income_portion,
                                                    outstanding_loan_balance_derived: outstanding_loan_balance_derived,
                                                    transaction_ref: transaction_ref, submitted_on_date: submitted_on_date, manually_adjusted_or_reversed: manually_adjusted_or_reversed, manually_created_by_userid: manually_created_by_userid}
                                                Repo.insert(loanTransaction);


                                                loanCharge = %LoanChargePayment{loan_transaction_id: loanTransaction.id, loan_id: loan_id, loan_charge_id: loanCharge.id, amount: totalCharges, installment_number: nil}
                                                Repo.insert(loanCharge);




                                            end


                                            is_reversed = false;
                                            transaction_type_enum = "LOAN ISSUED";
                                            transaction_date = Date.utc_today;
                                            principal_portion_derived = amount;
                                            interest_portion_derived = interest_outstanding_derived;
                                            fee_charges_portion_derived = totalCharges;
                                            penalty_charges_portion_derived = 0.00;
                                            overpayment_portion_derived = 0.00;
                                            unrecognized_income_portion = 0.00;
                                            outstanding_loan_balance_derived = amount + interest_outstanding_derived;
                                            submitted_on_date = Date.utc_today;
                                            manually_adjusted_or_reversed = false;
                                            manually_created_by_userid = nil;



                                            Logger.info "Insert Loan Transaction";
                                            loanTransaction = %LoanTransaction{loan_id: loan_id, is_reversed: is_reversed, transaction_type_enum: transaction_type_enum,
                                                transaction_date: transaction_date, amount: amount, principal_portion_derived: principal_portion_derived, interest_portion_derived: interest_portion_derived,
                                                fee_charges_portion_derived: fee_charges_portion_derived,
                                                penalty_charges_portion_derived: penalty_charges_portion_derived, overpayment_portion_derived: overpayment_portion_derived, unrecognized_income_portion: unrecognized_income_portion,
                                                outstanding_loan_balance_derived: outstanding_loan_balance_derived, transaction_ref: UUID.uuid4(),
                                                submitted_on_date: submitted_on_date, manually_adjusted_or_reversed: manually_adjusted_or_reversed, manually_created_by_userid: manually_created_by_userid}
                                            case Repo.insert(loanTransaction) do
                                                {:ok, loanTransaction} ->


                                                    transferResponse = MtnMomo.transfer(transaction_ref, %{
                                                        "amount" => Float.to_string(amount),
                                                        "currency" => "ZMW",
                                                        "externalId" => "135791526",
                                                        "payee" => %{"partyId" => mobile_number, "partyIdType" => "MSISDN"},
                                                        "payeeNote" => "accepted",
                                                        "payerMessage" => "Submitted"
                                                    });

                                                    case transferResponse do
                                                        {:ok, transferResponse} ->
                                                            IO.inspect transferResponse
                                                            status = transferResponse["status"];
                                                            IO.inspect transferResponse["status"];
                                                            mmoneyResponse = Jason.encode!(transferResponse)

                                                            if status=="SUCCESSFUL" do
                                                                attrs = %{loan_status: "Disbursed", mobile_money_response: mmoneyResponse}

                                                                loan
                                                                |> Loans.changesetForUpdate(attrs)
                                                                |> Repo.update()

                                                                IO.inspect ">>>>>>>>>>>>>transferResponse....."
                                                                IO.inspect transferResponse
                                                                IO.inspect transferResponse["status"];



                                                                default_rate = ussdLoanProduct.default_interest_rate
                                                                default_period = ussdLoanProduct.default_period
                                                                no_of_payments = ussdLoanProduct.repayment_count
                                                                annual_period = loanProduct.days_in_year
                                                                Logger.info no_of_payments
                                                                annual_period = loanProduct.days_in_year
                                                                amt = amount
                                                                monthylyRepayAmount = calculate_monthly_repayments(amt, default_period/30, default_rate, annual_period, no_of_payments)
                                                                Logger.info "*********"
                                                                Logger.info monthylyRepayAmount
                                                                #monthylyRepayAmount = :erlang.float_to_binary(monthylyRepayAmount, [decimals: 2])
                                                                #Logger.info monthylyRepayAmount
                                                                Logger.info no_of_payments
                                                                months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                                                                dayOptions = [];
                                                                dayOptions = for _x <- 0..(no_of_payments-1) do
                                                                    dt = Date.add(Date.utc_today, ((_x+1)*30))
                                                                    yr = dt.year
                                                                    Logger.info yr
                                                                    mn = dt.month
                                                                    mn = Enum.at(months, mn)
                                                                    Logger.info mn
                                                                    dd = dt.day
                                                                    dt = "#{yr}-#{mn}-#{dd}"
                                                                    Logger.info dt
                                                                    #repay_entry = "#{dt}: " <> loanProduct.currency_code <> monthylyRepayAmount
                                                                    #Logger.info repay_entry
                                                                    fromdate = Date.add(Date.utc_today, ((_x)*30))
                                                                    duedate = Date.add(Date.utc_today, ((_x+1)*30));
                                                                    date_date = Date.utc_today();
                                                                    installment = (_x + 1);
                                                                    loan_id = loan_id;
                                                                    status = "PENDING"
                                                                    principal_amount = amount;
                                                                    principal_completed_derived = monthylyRepayAmount;
                                                                    principal_writtenoff_derived = 0.00;
                                                                    interest_amount = interest_outstanding_derived;
                                                                    interest_completed_derived = interest_outstanding_derived;
                                                                    interest_writtenoff_derived = 0.00;
                                                                    interest_waived_derived = 0.00;
                                                                    accrual_interest_derived = interest_outstanding_derived;
                                                                    fee_charges_amount = totalCharges;
                                                                    fee_charges_completed_derived = totalCharges;
                                                                    fee_charges_writtenoff_derived = 0.00;
                                                                    fee_charges_waived_derived = 0.00;
                                                                    accrual_fee_charges_derived = 0.00;
                                                                    penalty_charges_amount = 0.00;
                                                                    penalty_charges_completed_derived = 0.00;
                                                                    penalty_charges_writtenoff_derived = 0.00;
                                                                    penalty_charges_waived_derived = 0.00;
                                                                    accrual_penalty_charges_derived = 0.00;
                                                                    total_paid_in_advance_derived = 0.00;
                                                                    total_paid_late_derived = 0.00;
                                                                    completed_derived = 0.00;
                                                                    createdby_id = appUser.id;
                                                                    lastmodifiedby_id = appUser.id;
                                                                    obligations_met_on_date = date_date;

                                                                    loanRepaymentSchedule = %LoanRepaymentSchedule{loan_id: loan_id, fromdate: fromdate, duedate: duedate, installment: installment, principal_amount: principal_amount,
                                                                        principal_completed_derived: principal_completed_derived,
                                                                        principal_writtenoff_derived: principal_writtenoff_derived, interest_amount: interest_amount, interest_completed_derived: interest_completed_derived,
                                                                        interest_writtenoff_derived: interest_writtenoff_derived,
                                                                        interest_waived_derived: interest_waived_derived, accrual_interest_derived: accrual_interest_derived, fee_charges_amount: fee_charges_amount,
                                                                        fee_charges_completed_derived: fee_charges_completed_derived,
                                                                        fee_charges_writtenoff_derived: fee_charges_writtenoff_derived, fee_charges_waived_derived: fee_charges_waived_derived, accrual_fee_charges_derived: accrual_fee_charges_derived,
                                                                        penalty_charges_amount: penalty_charges_amount,
                                                                        penalty_charges_completed_derived: penalty_charges_completed_derived, penalty_charges_writtenoff_derived: penalty_charges_writtenoff_derived,
                                                                        penalty_charges_waived_derived: penalty_charges_waived_derived,
                                                                        accrual_penalty_charges_derived: accrual_penalty_charges_derived, total_paid_in_advance_derived: total_paid_in_advance_derived, total_paid_late_derived: total_paid_late_derived,
                                                                        completed_derived: completed_derived, status: status,
                                                                        createdby_id: createdby_id, lastmodifiedby_id: lastmodifiedby_id, obligations_met_on_date: obligations_met_on_date}
                                                                    Repo.insert(loanRepaymentSchedule);
                                                                    dayOptions = dayOptions ++ [""]
                                                                end

                                                                amountStr = :erlang.float_to_binary((amount), [decimals: 2])
                                                                response = %{
                                                                    message: "Your loan request for ZMW#{amountStr} was successful. We have deposited the sum of ZMW#{amountStr} in your mobile money account. Press\n\nb. Back\n0. End",
                                                                    ClientState: 1,
                                                                    Type: "Response",
                                                                    key: "con"
                                                                }

                                                                #CONNECT TO AIRTEL TO CALL THE SERVICE FOR DEBITING CUSTOMERS WALLET
                                                                send_response(conn, response)

                                                            else
                                                                attrs = %{mobile_money_response: mmoneyResponse}

                                                                Loans.changeset(loan, %{mobile_money_response: mmoneyResponse})
                                                                    |> prepare_update(conn, loan)
                                                                    |> Repo.transaction()

                                                                response = %{
                                                                message: "Your application for a loan was successful. We will deposit the funds to your mobile money account in a few minutes.",
                                                                ClientState: 1,
                                                                Type: "Response",
                                                                key: "end"
                                                                }
                                                                send_response(conn, response)
                                                            end
                                                        {:error, errorMessage} ->
                                                            IO.inspect("Fail")
                                                            nil;

                                                            Loans.changeset(loan, %{mobile_money_response: Jason.encode!(errorMessage)})
                                                            |> prepare_update(conn, loan)
                                                            |> Repo.transaction()

                                                            IO.inspect("failed");
                                                            Logger.info("Fail")
                                                            response = %{
                                                            message: "Your application for a loan was not successful. Please try again",
                                                            ClientState: 1,
                                                            Type: "Response",
                                                            key: "end"
                                                            }
                                                            send_response(conn, response)


                                                    end




                                                {:error, changeset} ->
                                                    Logger.info("Fail")
                                                    response = %{
                                                        message: "Your application for a loan was not successful. Please try again",
                                                        ClientState: 1,
                                                        Type: "Response",
                                                        key: "end"
                                                    }
                                                    send_response(conn, response)
                                            end

                                        {:error, changeset} ->
                                            Logger.info("Fail")
                                            response = %{
                                                message: "Your application for a loan was not successful. Please try again",
                                                ClientState: 1,
                                                Type: "Response",
                                                key: "end"
                                            }
                                            send_response(conn, response)
                                    end

                                    response = %{
                                        message: "Test",
                                        ClientState: 2,
                                        Type: "Response"
                                    }
                                    send_response(conn, response)




























                                string when string in ["26097", "26077"] ->

                                    transaction_ref = UUID.uuid4()

                                    loan = %Loans{app_user_id: app_user_id, account_no: account_no, customer_id: customer_id, product_id: product_id, loan_status: loan_status, loan_type: loan_type,
                                            currency_code: currency_code, principal_amount_proposed: principal_amount_proposed, principal_amount: principal_amount, approved_principal: approved_principal,
                                            annual_nominal_interest_rate: annual_nominal_interest_rate, interest_method: interest_method, term_frequency: term_frequency,
                                            term_frequency_type: term_frequency_type, repay_every: repay_every, repay_every_type: repay_every_type, number_of_repayments: number_of_repayments, approvedon_date: approvedon_date,
                                            expected_disbursedon_date: expected_disbursedon_date, disbursedon_date: disbursedon_date, expected_maturity_date: expected_maturity_date, interest_calculated_from_date: interest_calculated_from_date,
                                            principal_disbursed_derived: principal_disbursed_derived, loan_identity_number: loanIdentityNumber, branch_id: branch_id,
                                            principal_repaid_derived: principal_repaid_derived, principal_writtenoff_derived: principal_writtenoff_derived, principal_outstanding_derived: amount,
                                            interest_charged_derived: interest_charged_derived, interest_repaid_derived: interest_repaid_derived,
                                            interest_waived_derived: interest_waived_derived, interest_writtenoff_derived: interest_writtenoff_derived, interest_outstanding_derived: interest_outstanding_derived,
                                            fee_charges_charged_derived: fee_charges_charged_derived, fee_charges_repaid_derived: fee_charges_repaid_derived,
                                            fee_charges_waived_derived: fee_charges_waived_derived, fee_charges_writtenoff_derived: fee_charges_writtenoff_derived, fee_charges_outstanding_derived: fee_charges_outstanding_derived,
                                            penalty_charges_charged_derived: penalty_charges_charged_derived, penalty_charges_repaid_derived: penalty_charges_repaid_derived,
                                            penalty_charges_waived_derived: penalty_charges_waived_derived, penalty_charges_writtenoff_derived: penalty_charges_writtenoff_derived, penalty_charges_outstanding_derived:
                                            penalty_charges_outstanding_derived, total_expected_repayment_derived: total_expected_repayment_derived, total_repayment_derived: total_repayment_derived,
                                            total_expected_costofloan_derived: total_expected_costofloan_derived, total_costofloan_derived: total_costofloan_derived, total_waived_derived: total_waived_derived, total_writtenoff_derived:
                                            total_writtenoff_derived, total_outstanding_derived: total_outstanding_derived, total_overpaid_derived: total_overpaid_derived,
                                            withdrawnon_date: withdrawnon_date, loan_counter: loan_counter, is_npa: is_npa, is_legacyloan: is_legacyloan, total_charges_due_at_disbursement_derived: totalCharges, status: status}
                                    case Repo.insert(loan) do
                                        {:ok, loan} ->

                                            loan_id = loan.id;

                                            if charge != nil do
                                                Logger.info "Charge";
                                                Logger.info charge.type;

                                                totalCharges = if charge.type=="PERCENT" do
                                                    totalCharges = (amount * charge.valuation)/100;
                                                else
                                                    if charge.type=="FLAT FEE" do
                                                        totalCharges = charge.valuation;
                                                    end
                                                end
                                                Logger.info "totalCharges";
                                                Logger.info totalCharges;
                                                charge_id = charge.id;
                                                is_penalty = charge.is_penalty;
                                                charge_time_enum = "DISBURSEMENT";
                                                due_for_collection_as_of_date = Date.utc_today;
                                                charge_calculation_enum = charge.type;
                                                charge_payment_mode_enum = "MOBILEMONEY";
                                                calculation_percentage = charge.valuation;
                                                calculation_on_amount = amount;
                                                charge_amount_or_percentage = charge.valuation;
                                                amount = amount;
                                                amount_paid_derived = totalCharges;
                                                amount_waived_derived = totalCharges;
                                                amount_writtenoff_derived = 0.00;
                                                amount_writtenoff_derived = 0.00;
                                                amount_outstanding_derived = 0.00;
                                                is_paid_derived = true;
                                                is_waived = false;
                                                is_active = false;

                                                loanCharge = %LoanCharge{loan_id: loan_id, charge_id: charge_id, is_penalty: is_penalty, charge_time_enum: charge_time_enum, due_for_collection_as_of_date: due_for_collection_as_of_date,
                                                    charge_calculation_enum: charge_calculation_enum, charge_payment_mode_enum: charge_payment_mode_enum, calculation_percentage: calculation_percentage,
                                                    calculation_on_amount: calculation_on_amount, charge_amount_or_percentage: charge_amount_or_percentage, amount: amount, amount_paid_derived: amount_paid_derived,
                                                    amount_waived_derived: amount_waived_derived, amount_writtenoff_derived: amount_writtenoff_derived, amount_outstanding_derived: amount_outstanding_derived,
                                                    is_paid_derived: is_paid_derived, is_waived: is_waived, is_active: is_active}
                                                Repo.insert(loanCharge);

                                                is_reversed = false;
                                                transaction_type_enum = "LOAN CHARGE PAYMENT";
                                                transaction_date = Date.utc_today;
                                                principal_portion_derived = 0.00;
                                                interest_portion_derived = 0.00;
                                                fee_charges_portion_derived = totalCharges;
                                                penalty_charges_portion_derived = 0.00;
                                                overpayment_portion_derived = 0.00;
                                                unrecognized_income_portion = 0.00;
                                                outstanding_loan_balance_derived = 0.00;
                                                submitted_on_date = Date.utc_today;
                                                manually_adjusted_or_reversed = false;
                                                manually_created_by_userid = nil;
                                                loanTransaction = %LoanTransaction{loan_id: loan_id, is_reversed: is_reversed, transaction_type_enum: transaction_type_enum,
                                                    transaction_date: transaction_date, amount: totalCharges, principal_portion_derived: principal_portion_derived, interest_portion_derived: interest_portion_derived,
                                                    fee_charges_portion_derived: fee_charges_portion_derived,
                                                    penalty_charges_portion_derived: penalty_charges_portion_derived, overpayment_portion_derived: overpayment_portion_derived, unrecognized_income_portion: unrecognized_income_portion,
                                                    outstanding_loan_balance_derived: outstanding_loan_balance_derived,
                                                    transaction_ref: transaction_ref, submitted_on_date: submitted_on_date, manually_adjusted_or_reversed: manually_adjusted_or_reversed, manually_created_by_userid: manually_created_by_userid}
                                                Repo.insert(loanTransaction);


                                                loanCharge = %LoanChargePayment{loan_transaction_id: loanTransaction.id, loan_id: loan_id, loan_charge_id: loanCharge.id, amount: totalCharges, installment_number: nil}
                                                Repo.insert(loanCharge);




                                            end


                                            is_reversed = false;
                                            transaction_type_enum = "LOAN ISSUED";
                                            transaction_date = Date.utc_today;
                                            principal_portion_derived = amount;
                                            interest_portion_derived = interest_outstanding_derived;
                                            fee_charges_portion_derived = totalCharges;
                                            penalty_charges_portion_derived = 0.00;
                                            overpayment_portion_derived = 0.00;
                                            unrecognized_income_portion = 0.00;
                                            outstanding_loan_balance_derived = amount + interest_outstanding_derived;
                                            submitted_on_date = Date.utc_today;
                                            manually_adjusted_or_reversed = false;
                                            manually_created_by_userid = nil;



                                            Logger.info "Insert Loan Transaction";
                                            loanTransaction = %LoanTransaction{loan_id: loan_id, is_reversed: is_reversed, transaction_type_enum: transaction_type_enum,
                                                transaction_date: transaction_date, amount: amount, principal_portion_derived: principal_portion_derived, interest_portion_derived: interest_portion_derived,
                                                fee_charges_portion_derived: fee_charges_portion_derived,
                                                penalty_charges_portion_derived: penalty_charges_portion_derived, overpayment_portion_derived: overpayment_portion_derived, unrecognized_income_portion: unrecognized_income_portion,
                                                outstanding_loan_balance_derived: outstanding_loan_balance_derived, transaction_ref: UUID.uuid4(),
                                                submitted_on_date: submitted_on_date, manually_adjusted_or_reversed: manually_adjusted_or_reversed, manually_created_by_userid: manually_created_by_userid}
                                            case Repo.insert(loanTransaction) do
                                                {:ok, loanTransaction} ->
                                                    airtelamount = :erlang.float_to_binary(amount, [decimals: 2])
                                                    airtelamount = elem Integer.parse(airtelamount), 0
                                                    IO.inspect "GAME OF THRONESSSSSSSSSSSSS"
                                                    IO.inspect airtelamount
                                                    random_int3 = to_string(Enum.random(11111111..99999999))
                                                    airtel_mobile = String.slice(mobile_number, 3..12)
                                                    airteltransferResponse = AirtelMomo.disbursements_payments(%{
                                                        :payee => %{
                                                          :msisdn => airtel_mobile
                                                        },
                                                        :reference => "LAXMIDISBUR1001",
                                                        :pin => "M0o34n68XEa9HY7McZ+A+HwMxIa2dxecfDtjRow6BT47UC6Lf8+5cfpSSFbfvWDJjOg26qKuWYgok2mDqMzD0cWgU/1DBV3ouc56zKDwKz8/EmIaRFB6D6AEr8A84F/x8yNFUSdx8SiKWt3+0QTWW31P3uQ1Dch84FvLMGo1sPw=",
                                                        :transaction => %{
                                                          :amount => airtelamount,
                                                          :id => random_int3
                                                        }
                                                      })

                                                    case airteltransferResponse do
                                                        {:ok, airteltransferResponse, status} ->
                                                            %{"data" => data, "status" => responsestatus} = airteltransferResponse
                                                            %{"transaction" => datatransaction} = data
                                                            %{"reference_id" => reference_id, "airtel_money_id" => airtel_money_id, "id" => getairteltransid} = datatransaction
                                                            IO.inspect getairteltransid
                                                            IO.inspect "KILLLLLLLL ZONEEEEEEEEEEEEEEEEEEEEEEEEEEEEEE"
                                                            IO.inspect "CALL of  dutttttttyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyyy"
                                                            airteltransaction_ref = airteltransferResponse["code"]
                                                            IO.inspect airteltransferResponse
                                                            mmoneyResponse = Jason.encode!(airteltransferResponse)
                                                            IO.inspect mmoneyResponse

                                                            if status==200 do
                                                                attrs = %{loan_status: "Disbursed", mobile_money_response: mmoneyResponse}

                                                                loan
                                                                |> Loans.changesetForUpdate(attrs)
                                                                |> Repo.update()

                                                                IO.inspect ">>>>>>>>>>>>>transferResponse....."
                                                                IO.inspect airteltransferResponse



                                                                default_rate = ussdLoanProduct.default_interest_rate
                                                                default_period = ussdLoanProduct.default_period
                                                                no_of_payments = ussdLoanProduct.repayment_count
                                                                annual_period = loanProduct.days_in_year
                                                                Logger.info no_of_payments
                                                                annual_period = loanProduct.days_in_year
                                                                amt = amount
                                                                monthylyRepayAmount = calculate_monthly_repayments(amt, default_period/30, default_rate, annual_period, no_of_payments)
                                                                Logger.info "*********"
                                                                Logger.info monthylyRepayAmount
                                                                #monthylyRepayAmount = :erlang.float_to_binary(monthylyRepayAmount, [decimals: 2])
                                                                #Logger.info monthylyRepayAmount
                                                                Logger.info no_of_payments
                                                                months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
                                                                dayOptions = [];
                                                                dayOptions = for _x <- 0..(no_of_payments-1) do
                                                                    dt = Date.add(Date.utc_today, ((_x+1)*30))
                                                                    yr = dt.year
                                                                    Logger.info yr
                                                                    mn = dt.month
                                                                    mn = Enum.at(months, mn)
                                                                    Logger.info mn
                                                                    dd = dt.day
                                                                    dt = "#{yr}-#{mn}-#{dd}"
                                                                    Logger.info dt
                                                                    #repay_entry = "#{dt}: " <> loanProduct.currency_code <> monthylyRepayAmount
                                                                    #Logger.info repay_entry
                                                                    fromdate = Date.add(Date.utc_today, ((_x)*30))
                                                                    duedate = Date.add(Date.utc_today, ((_x+1)*30));
                                                                    date_date = Date.utc_today();
                                                                    installment = (_x + 1);
                                                                    loan_id = loan_id;
                                                                    status = "PENDING"
                                                                    principal_amount = amount;
                                                                    principal_completed_derived = monthylyRepayAmount;
                                                                    principal_writtenoff_derived = 0.00;
                                                                    interest_amount = interest_outstanding_derived;
                                                                    interest_completed_derived = interest_outstanding_derived;
                                                                    interest_writtenoff_derived = 0.00;
                                                                    interest_waived_derived = 0.00;
                                                                    accrual_interest_derived = interest_outstanding_derived;
                                                                    fee_charges_amount = totalCharges;
                                                                    fee_charges_completed_derived = totalCharges;
                                                                    fee_charges_writtenoff_derived = 0.00;
                                                                    fee_charges_waived_derived = 0.00;
                                                                    accrual_fee_charges_derived = 0.00;
                                                                    penalty_charges_amount = 0.00;
                                                                    penalty_charges_completed_derived = 0.00;
                                                                    penalty_charges_writtenoff_derived = 0.00;
                                                                    penalty_charges_waived_derived = 0.00;
                                                                    accrual_penalty_charges_derived = 0.00;
                                                                    total_paid_in_advance_derived = 0.00;
                                                                    total_paid_late_derived = 0.00;
                                                                    completed_derived = 0.00;
                                                                    createdby_id = appUser.id;
                                                                    lastmodifiedby_id = appUser.id;
                                                                    obligations_met_on_date = date_date;

                                                                    loanRepaymentSchedule = %LoanRepaymentSchedule{loan_id: loan_id, fromdate: fromdate, duedate: duedate, installment: installment, principal_amount: principal_amount,
                                                                        principal_completed_derived: principal_completed_derived,
                                                                        principal_writtenoff_derived: principal_writtenoff_derived, interest_amount: interest_amount, interest_completed_derived: interest_completed_derived,
                                                                        interest_writtenoff_derived: interest_writtenoff_derived,
                                                                        interest_waived_derived: interest_waived_derived, accrual_interest_derived: accrual_interest_derived, fee_charges_amount: fee_charges_amount,
                                                                        fee_charges_completed_derived: fee_charges_completed_derived,
                                                                        fee_charges_writtenoff_derived: fee_charges_writtenoff_derived, fee_charges_waived_derived: fee_charges_waived_derived, accrual_fee_charges_derived: accrual_fee_charges_derived,
                                                                        penalty_charges_amount: penalty_charges_amount,
                                                                        penalty_charges_completed_derived: penalty_charges_completed_derived, penalty_charges_writtenoff_derived: penalty_charges_writtenoff_derived,
                                                                        penalty_charges_waived_derived: penalty_charges_waived_derived,
                                                                        accrual_penalty_charges_derived: accrual_penalty_charges_derived, total_paid_in_advance_derived: total_paid_in_advance_derived, total_paid_late_derived: total_paid_late_derived,
                                                                        completed_derived: completed_derived, status: status,
                                                                        createdby_id: createdby_id, lastmodifiedby_id: lastmodifiedby_id, obligations_met_on_date: obligations_met_on_date}
                                                                    Repo.insert(loanRepaymentSchedule);
                                                                    dayOptions = dayOptions ++ [""]
                                                                end

                                                                amountStr = :erlang.float_to_binary((amount), [decimals: 2])
                                                                response = %{
                                                                    message: "Your loan request for ZMW#{amountStr} was successful. We have deposited the sum of ZMW#{amountStr} in your mobile money account. Press\n\nb. Back\n0. End",
                                                                    ClientState: 1,
                                                                    Type: "Response",
                                                                    key: "con"
                                                                }

                                                                #CONNECT TO AIRTEL TO CALL THE SERVICE FOR DEBITING CUSTOMERS WALLET
                                                                send_response(conn, response)

                                                            else
                                                                attrs = %{mobile_money_response: mmoneyResponse}

                                                                Loans.changeset(loan, %{mobile_money_response: mmoneyResponse})
                                                                    |> prepare_update(conn, loan)
                                                                    |> Repo.transaction()

                                                                response = %{
                                                                message: "Your application for a loan was successful. We will deposit the funds to your mobile money account in a few minutes.",
                                                                ClientState: 1,
                                                                Type: "Response",
                                                                key: "end"
                                                                }
                                                                send_response(conn, response)
                                                            end
                                                        {:error, message, status} ->
                                                            IO.inspect("Fail")
                                                            nil;

                                                            Loans.changeset(loan, %{mobile_money_response: Jason.encode!(message)})
                                                            |> prepare_update(conn, loan)
                                                            |> Repo.transaction()

                                                            IO.inspect("failed");
                                                            Logger.info("Fail")
                                                            response = %{
                                                            message: "Your application for a loan was not successful. Please try again",
                                                            ClientState: 1,
                                                            Type: "Response",
                                                            key: "end"
                                                            }
                                                            send_response(conn, response)


                                                    end




                                                {:error, changeset} ->
                                                    Logger.info("Fail")
                                                    response = %{
                                                        message: "Your application for a loan was not successful. Please try again",
                                                        ClientState: 1,
                                                        Type: "Response",
                                                        key: "end"
                                                    }
                                                    send_response(conn, response)
                                            end

                                        {:error, changeset} ->
                                            Logger.info("Fail")
                                            response = %{
                                                message: "Your application for a loan was not successful. Please try again",
                                                ClientState: 1,
                                                Type: "Response",
                                                key: "end"
                                            }
                                            send_response(conn, response)
                                    end

                                    response = %{
                                        message: "Test",
                                        ClientState: 2,
                                        Type: "Response"
                                    }
                                    send_response(conn, response)
                                end


































                      else
						  Logger.info ("endSession");
                          response = %{
                              message: "Thank you and Good Bye",
                              ClientState: 1,
                              Type: "Response",
                              key: "end"
                          }
                          end_session(ussdRequests, conn, response);
                      end
              end




          end
      end




      def handle_new_account(conn, mobile_number, cmd, text) do
          Logger.info("===================")
          Logger.info(cmd)
          Logger.info(mobile_number)


          Logger.info("short_code...")
          Logger.info(cmd)
          Logger.info("text...")
          Logger.info(text)


          if text do
              checkMenu = String.split(text, "\*")
              checkMenuLength = Enum.count(checkMenu)
              Logger.info(checkMenuLength)
              case checkMenuLength do
                  2 ->
                      response = %{
                          message: "Welcome to Bank Name. \n\nEnter a password",
                          ClientState: 1,
                          Type: "Response",
                          key: "con"
                      }
                      send_response(conn, response)
                  3 ->
                      response = %{
                          message: "Confirm your password",
                          ClientState: 1,
                          Type: "Response",
                          key: "con"
                      }
                      send_response(conn, response)
                  4 ->
                      password = Enum.at(checkMenu, 2)
                      cpassword = Enum.at(checkMenu, 3)
                      Logger.info("password..." <> password)
                      Logger.info("cpassword..." <> cpassword)

                      if (password != cpassword) do

                          response = %{
                              message: "Passwords dont match. Press\n\nb. Back\n",
                              ClientState: 1,
                              Type: "Response",
                              key: "BA2"
                          }
                          send_response(conn, response)
                      else

                          appUser = %AppUser{}



                          appUser = %AppUser{mobile_number: mobile_number, password: password, staff_id: 1}
                          case Repo.insert(appUser) do
                            {:ok, appUser} ->
                                  response = %{
                                      message: "Your new Chikwama Loan account has been setup for you.",# Press\n\nb. Back\n0. Log Out",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "BA3"
                                  }
                                  send_response(conn, response)


                            {:error, changeset} ->
                                  Logger.info("Fail")
                                  response = %{
                                      message: "Your new Chikwama Loan account could not be setup for you.",# Press\n\nb. Back\n0. Log Out",
                                      ClientState: 1,
                                      Type: "Response",
                                      key: "BA3"
                                  }
                                  send_response(conn, response)
                          end
                      end
                  end
              else
                  response = %{
                      message: "Invalid input provided",
                      ClientState: 1,
                      Type: "Response",
                      key: "BA1"
                  }
                  send_response(conn, response)
              end

      end


      def calculate_interest_for_days(amount, period, rate, annual_period, number_of_repayments) do
          #Logger.info "################"
          #Logger.info amount
          #Logger.info period
          #Logger.info rate
          #Logger.info annual_period
          #Logger.info number_of_repayments
          rate = rate/100
          nperiod = period/annual_period
          #Logger.info "+++++++++++++++++"
          #Logger.info rate
          #Logger.info nperiod
          #interest = (amount * (period/30) * mrate)
          #interest = ((rate/100)/12) * amount
          totalRepay = amount * (1 + (rate*nperiod))
          interest = totalRepay - amount
      end





      def calculate_monthly_repayments(amount, period, rate, annual_period, number_of_repayments) do
          Logger.info "################"
          Logger.info amount
          #Logger.info period
          #Logger.info "Rate ...#{rate}"
          #Logger.info annual_period
          Logger.info number_of_repayments
          rate = rate/100
          rate_ = (rate/12)
          nperiod = period/12
          Logger.info "+++++++++++++++++"
          Logger.info rate_
          #Logger.info nperiod
          #totalRepay = amount * (1 + (rate*nperiod))
          #interest = totalRepay - amount

          totalRepayable = 0.00;
          y = 1;


          rate__ = (1+rate_);
          raisedVal = :math.pow(rate__, (number_of_repayments))
          Logger.info raisedVal
          a = rate_*raisedVal
          b = raisedVal - 1
          c = a/b
          totalPayableInMonthX = amount * rate;
          Logger.info totalPayableInMonthX
          #realMonthlyRepayment = amount * (rate_) * (1)
          totalPayableInMonthX =  totalPayableInMonthX + amount
          totalPayableInMonthX
      end




      def union(list, p) do
          Enum.map(list, fn(x) ->
              x
          end)
      end


      def test(idx, num, acc, rate_, y, acc1) do
          Logger.info Enum.at(Map.keys(acc), 0);
          tempAmount = Map.get(acc, :amt);
          Logger.info idx
          Logger.info num
          Logger.info "tempAmount...#{tempAmount}"
          rate__ = (1+rate_);
          raisedVal = :math.pow(rate__, (num))
          a = rate_*raisedVal
          b = raisedVal - 1
          #Logger.info a
          #Logger.info b
          c = a/b
          #Logger.info c
          #totalPayableInMonthX=tempAmount * c
          totalPayableInMonthX = tempAmount * ((rate_*(raisedVal))/(raisedVal - 1));
          Logger.info totalPayableInMonthX
          Logger.info "y....#{y}"
          realInterest = tempAmount * (rate_) * (idx+1)
          principalPart = totalPayableInMonthX - realInterest
          tempAmount = tempAmount - principalPart
          Logger.info "Real Interest...#{realInterest}"
          #dayOptions = dayOptions ++ totalPayableInMonthX
          #totalRepayable = totalRepayable + totalPayableInMonthX
          #=$A3*((rate_*(raisedVal))/(raisedVal - 1))
          #=$A3*((($C$2/12)*((1+($C$2/12))^$B3))/((1+($C$2/12))^$B3 - 1))
          Logger.info "principalPart...#{principalPart}";
          Logger.info "tempAmount...#{tempAmount}";
          Map.put(acc, "amt1", %{"tempAmount": tempAmount, "principalPart": principalPart})
          Logger.info Enum.count(Map.keys(acc))
          Map.put(acc1, (idx), tempAmount)
          acc1
      end


      def calculate_monthly_repayment(amount, period, rate, annual_period, number_of_repayments) do
          Logger.info amount
          Logger.info period
          Logger.info rate
          Logger.info annual_period
          Logger.info number_of_repayments
          rate = rate/100
          rate_ = (rate/12)
          nperiod = period/12
          Logger.info "+++++++++++++++++"
          Logger.info rate_
          Logger.info nperiod
          #totalRepay = amount * (1 + (rate*nperiod))
          #interest = totalRepay - amount

          dayOptions = [];
          totalRepayable = 0.00;
          dayOptions = for _x <- number_of_repayments..1 do

              Logger.info "xxxxxxxxxxxxxxxxx"
              Logger.info _x
              rate__ = (1+rate_);
              raisedVal = :math.pow(rate__, _x)
              Logger.info raisedVal
              a = rate_*raisedVal
              b = raisedVal - 1
              Logger.info a
              Logger.info b
              c = a/b
              Logger.info c
              #totalPayableInMonthX=amount * c
              totalPayableInMonthX = amount * ((rate_*(raisedVal))/(raisedVal - 1));
              Logger.info totalPayableInMonthX
              dayOptions = dayOptions ++ totalPayableInMonthX
              #totalRepayable = totalRepayable + totalPayableInMonthX
              #=$A3*((rate_*(raisedVal))/(raisedVal - 1))
              #=$A3*((($C$2/12)*((1+($C$2/12))^$B3))/((1+($C$2/12))^$B3 - 1))
          end

      end


      def handlePaymentConfirmation(x_ref_id) do

        mtn = Application.get_env(:mtn_momo, :mtn_disbursement)
        auth = Http.AccessToken.disbursement_token()

        headers = [
          {"Content-Type", "application/json"},
          {"X-Reference-Id", x_ref_id},
          {"Authorization", "Bearer #{auth["access_token"]}"},
          {"X-Target-Environment", mtn.x_target_env},
          {"Ocp-Apim-Subscription-Key", mtn.ocp_apim_sub_key},
          {"X-Callback-Url", mtn.x_callback_url},
        ]

        case HTTPoison.get(mtn.host<>mtn.transaction_status_path<>x_ref_id, headers, [recv_timeout: 200_000, timeout: 200_000, hackney: [:insecure]]) do
          {status, %HTTPoison.Response{body: body, status_code: status_code}} ->
            body |> JSON.decode!()
          {_status, %HTTPoison.Error{reason: reason}} ->
            %{"message" => reason}
        end
  end



      def send_response(conn, response) do
          Logger.info  "Test!"
          Logger.info  Jason.encode!(response)
          send_resp(conn, :ok, Jason.encode!(response))
      end

  end
