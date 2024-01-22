defmodule LoanSavingsSystemWeb.UssdLoanController do
	use LoanSavingsSystemWeb, :controller
	alias LoanSavingsSystem.Ussd
	alias LoanSavingsSystem.Ussd.Ussd
	alias LoanSavingsSystem.Accounts.User
	alias LoanSavingsSystem.Companies.Staff
	alias LoanSavingsSystem.Products.Product
	alias LoanSavingsSystem.Loan.LoanProduct
	alias LoanSavingsSystem.Loan.USSDLoanProduct
	alias LoanSavingsSystem.Repo
	alias LoanSavingsSystem.Loan.Loans
	alias LoanSavingsSystem.Loan.LoanCharge
	alias LoanSavingsSystem.Loan.LoanProductCharge
	alias LoanSavingsSystem.Charges.Charge
	alias LoanSavingsSystem.Transactions.Transaction
	alias LoanSavingsSystem.Loan.LoanChargePayment
	alias LoanSavingsSystem.Loan.LoanRepaymentSchedule
	alias LoanSavingsSystem.Ussd.UssdRequest
	require Record
	require Logger
	import Ecto.Query, warn: false


			def index(conn, _params) do
				render(conn, "index.html")
			end


			def initiateUssd(conn, dd) do
					{:ok, body, _conn} = Plug.Conn.read_body(conn)
					Logger.info  "-----------"
					Logger.info  "Debug USSD Controller Starts here"
					Logger.info  body
					IO.inspect dd,label: "Params"
					query_params = conn.query_params;
					session_id = dd["session_id"];
					query_params = conn.query_params;
					Logger.info  Jason.encode!(query_params)
					mobile_number = dd["mobile_number"]
					text = dd["text"]

					cmd = query_params["serviceCode"]
					orginal_short_code = cmd
					Logger.info cmd

					query = from au in LoanSavingsSystem.Accounts.User, where: au.username == ^mobile_number, select: au
					appusers = Repo.all(query)
					Logger.info  Enum.count(appusers)


					tempText = text <> "*"
					text = if String.ends_with?(tempText, "*b*") do
							tempText = "*778#"

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
									account = %LoanSavingsSystem.Accounts.Account{
											accountNo: accountNo,
											clientId: clientId,
											status: status,
											userId: userId,
											accountNo: mobile_number
											}
									case Repo.insert(account) do
											{:ok, appUser} ->

													# appUser = %LoanSavingsSystem.Accounts.User{username: mobile_number, clientId: clientId, status: "ACTIVE"}
													# case Repo.insert(appUser) do
													#     {:ok, appUser} ->

															Logger.info("==2222=================")
															IO.inspect appUser
															welcome_menu(conn, mobile_number, cmd, text)

													#     {:error, changeset} ->
													#         Logger.info("Fail")
													#         IO.inspect changeset
													#         response = %{
													#             Message: "Invalid input provided.",# Press\n\nb. Back\n0. Log Out",
													#             ClientState: 1,
													#             Type: "Response"
													#         }
													#     send_response(conn, response)
													# end

											{:error, changeset} ->
													Logger.info("Fail")
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
					Logger.info text
					orginal_short_code = cmd


					query = from au in LoanSavingsSystem.Accounts.User, where: au.username == ^mobile_number, select: au
					users = Repo.all(query)
					user = Enum.at(users, 0)

							checkMenu = String.split(text, "*")
							checkMenuLength = Enum.count(checkMenu)
							Logger.info(checkMenuLength)

							if checkMenuLength==2 do
									response = %{
											Message: "CON Welcome to MFZ Loans\n\n1. Loan Balance\n2.  Loan Payment\n3. Loan Settlement\n4. Loan Tracking\n5. Loan Affordable \n6. Loan Statement \n0. End",
											ClientState: 1,
											Type: "Response"
									}
									send_response(conn, response)
							end
							if checkMenuLength>2 do
									valueEntered = Enum.at(checkMenu, (2))
									Logger.info (valueEntered);
									case valueEntered do
											"1" ->
													Logger.info ("handleGetBalance")
													handleGetBalance(conn, mobile_number, cmd, text, checkMenu)
											"2" ->
													Logger.info ("handleLoanRepayment")
													handleLoanRepayment(conn, mobile_number, cmd, text, checkMenu)
											"3" ->
													Logger.info ("handleLoanSettlement")
													handleLoanSettlement(conn, mobile_number, cmd, text, checkMenu)
											"4" ->
											    Logger.info ("handleLoanStatusTracking")
											    handleLoanStatusTracking(conn, mobile_number, cmd, text, checkMenu)
											"5" ->
											    Logger.info ("handleLoanAffordable")
											    handleLoanAffordable(conn, mobile_number, cmd, text, checkMenu)
											"6" ->
													Logger.info ("handleStatement")
													handleStatement(conn, mobile_number, cmd, text, checkMenu)
											"0" ->
											    Logger.info ("handleEndSession")
											    text = "Thank you and good bye"
									end
							end
			end

			def end_session(ussdRequests, conn, response) do

			attrs = %{session_ended: 1};
			if(Enum.count(ussdRequests)>0) do
				ussdRequest = Enum.at(ussdRequests, 0);

				ussdRequest
				|> UssdRequests.changesetForUpdate(attrs)
				|> Repo.update()
			end

			send_response(conn, response)
			end

			def handleGetBalance(conn, mobile_number, cmd, text, checkMenu) do
					checkMenuLength = Enum.count(checkMenu)
					valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
					Logger.info("handleGetLoan");
					Logger.info(checkMenuLength);
					Logger.info(valueEntered);
					Logger.info(text);
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

											text = "CON Enter Loan Account Number\n
											\nb. Back \n0. End";
													response = %{
															Message: text,
															ClientState: 1,
															Type: "Response"
													}
											send_response(conn, response)

									4 ->
										reffno = Enum.at(checkMenu, 3)
										params = %{}
										params = Map.put(params, "refnotype", "1")
										params = Map.put(params, "refnumber", reffno)
										# data = Intergrator.Intergrations.pbl_cur_sch_balance(conn, params)

										data =	%{
											loandetail: %{
												nrcnumber: "207280/32/1",
												firstname: "ANNIE",
												lastname: "KATAYA",
												loanaccno: "709MF01190430001",
												loanamount: 18000,
												tenure: 66,
												interestrate: 37.5,
												loandate: "2019-02-12",
												EMIAmount: 782.45,
												status: "Active"
											},
											balances: %{
												arrearbalance: 1506.04,
												settlementbalance: 25348.57,
												casabalance: 0,
												totaldueamount: 8961.99
											},
											duedetail: [
												%{
													scheduleno: 8,
													duedate: "2019-10-12",
													dueamount: 355.04
												},
												%{
													scheduleno: 9,
													duedate: "2019-11-12",
													dueamount: 782.45
												},
											],
											rstmsg: "I-0 : Successfully completed"
										}
										IO.inspect "yyyyyyyyyyyyyyyyyyyyyyyyy"
										IO.inspect data
										IO.inspect data.rstmsg
										IO.inspect data.balances
										rstmsg = data.rstmsg
										case rstmsg do

											"I-0 : Successfully completed" ->

													balances =  data.balances
													totaldueamount = balances.totaldueamount
													arrearbalance = balances.arrearbalance
													settlementbalance = balances.settlementbalance
													casabalance = balances.casabalance

													text = "CON Loan Balance

													totaldueamount: #{Formatter.format_number(:erlang.float_to_binary((totaldueamount), [{:decimals, 2}]))}
													arrearbalance: #{Formatter.format_number(:erlang.float_to_binary((arrearbalance), [{:decimals, 2}]))}
													settlementbalance: #{Formatter.format_number(:erlang.float_to_binary((settlementbalance), [{:decimals, 2}]))}
													casabalance: #{if casabalance == 0 do 0.0 else Formatter.format_number(:erlang.float_to_binary((casabalance), [{:decimals, 2}])) end}

													b. Back \n0. End";
															response = %{
																	Message: text,
																	ClientState: 1,
																	Type: "Response"
															}
													send_response(conn, response)

											_->

												response = %{
														Message: "CON Could Not Process Your request at the moment. Please try again. \nb. Back",
														ClientState: 1,
														Type: "Response",
														key: "CON"
												}
												send_response(conn, response)
										end



									_->
										msg = "CON You entered and invalid value. \nb. Back"
										response = %{
												Message: msg,
												ClientState: 1,
												Type: "Response",
												key: "CON"
										}
										send_response(conn, response)

							end
					end

			end

			def handleLoanRepayment(conn, mobile_number, cmd, text, checkMenu) do
				checkMenuLength = Enum.count(checkMenu)
				valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
				Logger.info("handleGetLoan");
				Logger.info(checkMenuLength);
				Logger.info(valueEntered);
				Logger.info(text);
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
									data =	[
										%{
												loanaccno: "707MF01190440002",
												status: "Active"
											},
										%{
											loanaccno: "707MF01182600009",
											status: "Active"
										},
										%{
											loanaccno: "701MF01161340010",
											status: "Active"
										}
										]
									setcomplainttype = [];
									setcomplainttype = for {k, v} <- Enum.with_index(data) do
											#Logger.info (k.id)

											loanaccno = k.loanaccno
											status = k.status

											qn = "#{v+1}. " <> "Loan Ref ID: #{loanaccno} \n Status: #{status} \n"
											setcomplainttype = setcomplainttype ++ [qn]
											setcomplainttype

									end

									if (Enum.count(setcomplainttype)>0) do
											optionsList = "";
											optionsList = Enum.join(setcomplainttype, "\n");

											IO.inspect optionsList
											msg = "CON Loan Status Tracking. \n" <> optionsList <> "\nb. Back"

											response = %{
													Message: msg,
													ClientState: 1,
													Type: "Response",
													key: "CON"
											}
											# response = msg
											send_response(conn, response)
									else
											response = %{
													Message: "CON They are no loans. \n\nb. Back",
													ClientState: 1,
													Type: "Response",
													key: "CON"
												}
										# response = "They are currently no transactions performed on this mobile number. \n\nb. Back"
										send_response(conn, response)

									end
								4 ->
												response = %{
												Message: "CON Enter Amount",
												ClientState: 1,
												Type: "Response",
												key: "CON"
										}
										send_response(conn, response)

								5 ->
									valueEntered = Enum.at(checkMenu, 4)

										text = "CON You are about to pay ZMW #{valueEntered} on your current running loan.  \n\n1. Comfirm \nb. Back \n0. End";
												response = %{
														Message: text,
														ClientState: 1,
														Type: "Response"
												}
										send_response(conn, response)

									6 ->
										valueEntered = Enum.at(checkMenu, 3)

											text = "CON You will be prompted to enter your mobile money pin to complete the transaction. \n\nb. Back \n0. End";
													response = %{
															Message: text,
															ClientState: 1,
															Type: "Response"
													}
											send_response(conn, response)

						end
				end

		end

		def handleLoanSettlement(conn, mobile_number, cmd, text, checkMenu) do
			checkMenuLength = Enum.count(checkMenu)
			valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
			Logger.info("handleGetLoan");
			Logger.info(checkMenuLength);
			Logger.info(valueEntered);
			Logger.info(text);
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
											Message: "CON You currently dont have any active loans running.
											b. Back",
											ClientState: 1,
											Type: "Response",
											key: "CON"
									}
									send_response(conn, response)

							4 ->

									text = "CON Dear John Banda \nYour Current Balance is 237.0 \n\nb. Back \n0. End";
											response = %{
													Message: text,
													ClientState: 1,
													Type: "Response"
											}
									send_response(conn, response)

					end
			end

		end

		def handleLoanStatusTracking(conn, mobile_number, cmd, text, checkMenu) do
			checkMenuLength = Enum.count(checkMenu)
			valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
			Logger.info("handleGetLoan");
			Logger.info(checkMenuLength);
			Logger.info(valueEntered);
			Logger.info(text);
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
											Message: "CON Enter Your NRC Number \n\nb. Back.",
											ClientState: 1,
											Type: "Response",
											key: "CON"
									}
									send_response(conn, response)

							4 ->
								reffno = Enum.at(checkMenu, 3)
								params = %{}
								params = Map.put(params, "refnotype", "2")
								params = Map.put(params, "refnumber", reffno)
								IO.inspect params

								data = Intergrator.Intergrations.pbl_loan_tracking(conn, params)

								data = data["loanref"]
								IO.inspect "________________________________________________"
								IO.inspect data
								setcomplainttype = [];
								setcomplainttype = for {k, v} <- Enum.with_index(data) do
										#Logger.info (k.id)

										loanaccno = k["loanrefid"]
										status = k["status"]

										qn = "#{v+1}. " <> "Loan Reff ID: #{loanaccno} \n Status: #{status} \n"
										setcomplainttype = setcomplainttype ++ [qn]
										setcomplainttype

								end

								if (Enum.count(setcomplainttype)>0) do
										optionsList = "";
										optionsList = Enum.join(setcomplainttype, "\n");

										IO.inspect optionsList
										msg = "CON Loan Status Tracking. \n" <> optionsList <> "\nb. Back"

										response = %{
												Message: msg,
												ClientState: 1,
												Type: "Response",
												key: "CON"
										}
										# response = msg
										send_response(conn, response)
								else
										response = %{
												Message: "CON They are no loans. \n\nb. Back",
												ClientState: 1,
												Type: "Response",
												key: "CON"
											}
									# response = "They are currently no transactions performed on this mobile number. \n\nb. Back"
									send_response(conn, response)

								end

					end
			end

		end

		def handleLoanAffordable(conn, mobile_number, cmd, text, checkMenu) do
			checkMenuLength = Enum.count(checkMenu)
			valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
			Logger.info("handleGetLoan");
			Logger.info(checkMenuLength);
			Logger.info(valueEntered);
			Logger.info(text);
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
											Message: "CON Enter Your Gross Income",
											ClientState: 1,
											Type: "Response",
											key: "CON"
									}
									send_response(conn, response)

							4 ->

											response = %{
													Message: "CON Enter Total Deductions",
													ClientState: 1,
													Type: "Response"
											}
									send_response(conn, response)

							5 ->

								valueEntered3 = Enum.at(checkMenu, 3)
								valueEntered4 = Enum.at(checkMenu, 4)

								params = %{}
								params = Map.put(params, "gincome", valueEntered3)
								params = Map.put(params, "deduction", valueEntered4)
								params = Map.put(params, "productcode", "dcc7c24c-6d01-4c67-b459-36f073c1235d")
								IO.inspect params

								data = Intergrator.Intergrations.pbl_affordable_amount(conn, params)
								loanamount = data["MaxLoanAmount"]
								maxdeduction = data["MaxDeductionAmount"]
								thpad = data["THPAD"]
								text = "CON Loan Calculator

								Maximum Loan Amount: #{Formatter.format_number(Float.round(loanamount, 2))}
								Max Deduction Amount: #{Formatter.format_number(:erlang.float_to_binary((maxdeduction), [{:decimals, 2}]))}
								thpad: #{Formatter.format_number(:erlang.float_to_binary((thpad), [{:decimals, 2}]))}

								b. Back \n0. End";
										response = %{
												Message: text,
												ClientState: 1,
												Type: "Response"
										}
								send_response(conn, response)

					end
			end

		end

		def handleStatement(conn, mobile_number, cmd, text, checkMenu) do
			checkMenuLength = Enum.count(checkMenu)
			valueEntered = Enum.at(checkMenu, (checkMenuLength-1))
			Logger.info("handleGetLoan");
			Logger.info(checkMenuLength);
			Logger.info(valueEntered);
			Logger.info(text);
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
								msg = "CON Select Option\n1. Mini Statement \n 2. Full Statement\n"

									response = %{
											Message: msg <> "\nb. Back \n0. End",
											ClientState: 1,
											Type: "Response",
											key: "CON"
									}
								send_response(conn, response)

							4 ->

								valueEntered3 = Enum.at(checkMenu, 3)
								case valueEntered3 do

									"1" ->

										msg = "CON Enter NRC Number\n"
										response = %{
												Message: msg,
												ClientState: 1,
												Type: "Response",
												key: "CON"
										}
										send_response(conn, response)


									"2" ->

										msg = "CON Enter Loan Account Number \n"
										response = %{
												Message: msg,
												ClientState: 1,
												Type: "Response",
												key: "CON"
										}
										send_response(conn, response)

									_->

										msg = "CON You entered and invalid value. \nb. Back"
										response = %{
												Message: msg,
												ClientState: 1,
												Type: "Response",
												key: "CON"
										}
										send_response(conn, response)

								end

							5 ->
								valueEntered3 = Enum.at(checkMenu, 3)
								reffno = Enum.at(checkMenu, 4)

								params = %{}
								params = Map.put(params, "refnotype", "2")
								params = Map.put(params, "refnumber", reffno)
								IO.inspect params

								case valueEntered3 do

									"1" ->

									data = Intergrator.Intergrations.pbl_mini_statement(conn, params)

									data = data["loanref"]
									IO.inspect "________________________________________________"
									IO.inspect data
									setcomplainttype = [];
									setcomplainttype = for {k, v} <- Enum.with_index(data) do
											#Logger.info (k.id)

											loanaccno = k["loanaccno"]
											status = k["status"]

											qn = "#{v+1}. " <> "Loan Acc No: #{loanaccno} \n Status: #{status} \n"
											setcomplainttype = setcomplainttype ++ [qn]
											setcomplainttype

									end

									if (Enum.count(setcomplainttype)>0) do
											optionsList = "";
											optionsList = Enum.join(setcomplainttype, "\n");

											IO.inspect optionsList
											msg = "CON Mini Statement. \n" <> optionsList <> "\nb. Back"

											response = %{
													Message: msg,
													ClientState: 1,
													Type: "Response",
													key: "CON"
											}
											# response = msg
											send_response(conn, response)
									else
											response = %{
													Message: "CON They are no loans. \n\nb. Back",
													ClientState: 1,
													Type: "Response",
													key: "CON"
												}
										# response = "They are currently no transactions performed on this mobile number. \n\nb. Back"
										send_response(conn, response)

									end


									"2" ->

										msg = "CON Enter Your Email Address\n"
										response = %{
												Message: msg,
												ClientState: 1,
												Type: "Response",
												key: "CON"
										}
										send_response(conn, response)

									_->

										msg = "CON You entered and invalid value. \nb. Back"
										response = %{
												Message: msg,
												ClientState: 1,
												Type: "Response",
												key: "CON"
										}
										send_response(conn, response)

								end

							6 ->
								valueEntered3 = Enum.at(checkMenu, 3)
								reffno = Enum.at(checkMenu, 4)
								email = Enum.at(checkMenu, 5)

								params = %{}
								params = Map.put(params, "refnotype", "1")
								params = Map.put(params, "refnumber", reffno)
								IO.inspect params

								case valueEntered3 do

									"2" ->

										data = Intergrator.Intergrations.pbl_loan_statement(conn, params)

										response = %{
												Message: "CON Your Loan Statement was sent to #{email}.\nb. Back",
												ClientState: 1,
												Type: "Response",
												key: "CON"
										}
										send_response(conn, response)


									_->

										msg = "CON You entered and invalid value. \nb. Back"
										response = %{
												Message: msg,
												ClientState: 1,
												Type: "Response",
												key: "CON"
										}
										send_response(conn, response)

								end

					end
			end

		end



			def send_response(conn, response) do
					Logger.info  "Test!"
					Logger.info  Jason.encode!(response)
					send_resp(conn, :ok, Jason.encode!(response))
			end


			# LoanSavingsSystemWeb.UssdLoanController.smeprodlist
			def smeprodlist do
				# auth = "Mark:Mfz@123" |> Base.encode64()
				hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "Product List",
							conversationid: "5010"
						},
						body: %{
								shortname: "GRIZZLY"
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
				xml = Jason.encode!(xml)
						header = [
								{"Content-Type", "application/json"},
								{"Authorization", "Basic #{hashkey}"},
								{"Accept", "*/*"}
						]

						url = "http://192.168.218.52/connectcoin/api/sme/smeprodlist"

						case HTTPoison.request(:post, url, xml, header) do
								{:error, %HTTPoison.Error{id: nil, reason: reason}} ->
										IO.inspect "000000000000000000"
										IO.inspect reason

								{:ok, struct} ->
										IO.inspect struct
										# bearerBody =  Jason.decode!(struct.body)
										# IO.inspect bearerBody
										# bearer = bearerBody["access_token"]
										# IO.inspect bearer
										# random_int2 = to_string(Enum.random(11111111..99999999))
							end
    	end


			# LoanSavingsSystemWeb.UssdLoanController.prodlist
			def prodlist do
				# auth = "Mark:Mfz@123" |> Base.encode64()
				hashkey = "SGRwVmZoblcwY0JoTCtHbHJjZWFBdz09"
        xml = %{
						header: %{
							orgcode: "MFZ",
							vendorcode: "VM20202800000000036",
							tag: "Product List",
							conversationid: "#{Timex.now}"
						},
						body: %{
								shortname: "GRIZZLY"
						}
				}
        IO.inspect "xml3"
				IO.inspect xml
				xml = Jason.encode!(xml)
						header = [
								{"Content-Type", "application/json"},
								{"Authorization", "Basic #{hashkey}"},
								{"Accept", "*/*"}
						]

						url = "http://192.168.218.52/ConnectCoin/api/loan/prodlist"

						case HTTPoison.request(:post, url, xml, header) do
								{:error, %HTTPoison.Error{id: nil, reason: reason}} ->
										IO.inspect "000000000000000000"
										IO.inspect reason

								{:ok, struct} ->
										IO.inspect struct.body
										bearerBody =  Jason.decode!(struct.body)
										list = bearerBody["body"]["prodlist"]
										IO.inspect list


										# IO.inspect bearer
										# random_int2 = to_string(Enum.random(11111111..99999999))
							end
    	end

end
