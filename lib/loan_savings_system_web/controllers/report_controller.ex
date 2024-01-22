defmodule LoanSavingsSystemWeb.ReportController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.Repo
  alias LoanSavingsSystem.SystemSetting
  alias LoanSavingsSystem.Companies
  # alias LoanSavingsSystem.FixedDeposit.FixedDeposits
#   alias LoanSavingsSystem.Divestments
#   alias LoanSavingsSystem.FixedDeposit
  require Record
    require Logger
    import Ecto.Query, warn: false

    plug(
    LoanSavingsSystemWeb.Plugs.EnforcePasswordPolicy
      when action not in [:new_password, :change_password]
    )


############################# FIXED DEPOSIT REPORTS ################################
    def fixed_deposit_reports(conn, params) do
        IO.inspect params
        branches = Companies.list_tbl_branch()
        curencies = SystemSetting.list_tbl_currency()
        reports = nil;
        products = LoanSavingsSystem.Products.list_tbl_products()

        render(conn, "fixed_deposit_reports.html", reports: reports, curencies: curencies, branches: branches, products: products, params: params)
    end

    def generate_fixed_deposit_reports(conn, params) do
        params = Map.delete(params, "_csrf_token")

        str =
        "SELECT u.principalAmount, u.fixedPeriod, u.fixedPeriodType, u.interestRate, u.interestRateType, u.expectedInterest, u.accruedInterest, u.currency, u.currencyDecimals,
        u.yearLengthInDays, u.totalDepositCharge, u.totalDepositCharge, u.totalWithdrawalCharge, u.totalPenalties, u.totalAmountPaidOut, u.startDate, u.endDate,
        t.userId, d.divestmentType, u.customerName, b.accountNo, p.name as productName, u.isMatured, u.isWithdrawn, u.isDivested, u.fixedDepositStatus ,
		u.fixedPeriodType, u.fixedPeriod, u.interestRate, u.interestRateType, u.yearLengthInDays, d.divestAmount
        FROM tbl_fixed_deposit u
		 LEFT JOIN tbl_divestments d ON d.fixedDepositId = u.id
		 LEFT JOIN tbl_products p ON u.productId = p.id
		 LEFT JOIN tbl_account b ON u.accountId = b.id
        FULL OUTER JOIN tbl_fixed_deposit_transactions t
        ON u.id = t.fixedDepositId
        "

        paramKeys = Map.keys(params)
        IO.inspect(paramKeys)

        totals =
        for x <- 0..(Enum.count(paramKeys) - 1) do
            qString = nil
            paramKey = Enum.at(paramKeys, x)
            v = params[paramKey]

            qString =
            if(!is_nil(v) and v != -1 and String.length(v) > 0) do
                checker = String.split(paramKey, "__")
                IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>")
                IO.inspect(Enum.count(checker))
                checkerParamName = Enum.at(checker, 0)
                IO.inspect(checkerParamName)
                checkerParamType = Enum.at(checker, 1)
                IO.inspect("checkerParamType" <> checkerParamType)
                checkerParamValExpected = Enum.at(checker, 2)
                IO.inspect(checkerParamValExpected)
                checkerParamValGreater = Enum.at(checker, 3)
                IO.inspect(checkerParamValGreater)

                qString =
                if checkerParamType == "select" do
                    IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>....." <> checkerParamType <> "...." <> v)
                    qString =
                    if "#{v}" == "-1" do
                    else
                        qString =
                        if checkerParamValExpected == "boolean" do
                            qString =
                            if "#{v}" == "true" do
                                qString = "#{checkerParamName}"
                                qString
                            else
                                qString = "not #{checkerParamName}"
                                qString
                            end
                        else
                            IO.inspect(">>.....checkerParamValExpected ...." <> checkerParamValExpected)
                            IO.inspect(">>.....checkerParamValGreater ...." <> checkerParamValGreater)
                            qString =
                            if checkerParamValExpected == "number" do
                                qString =
                                if checkerParamValGreater == "greater" do
                                    qString = "#{checkerParamName} > #{v}"
                                    qString
                                else
                                    qString =
                                    if checkerParamValGreater == "less" do
                                        qString = "#{checkerParamName} < #{v}"
                                        qString
                                    else
                                        qString =
                                        if checkerParamValGreater == "greaterorequals" do
                                            qString = "#{checkerParamName} >= #{v}"
                                            qString
                                        else
                                            qString =
                                            if checkerParamValGreater == "lessorequals" do
                                                qString = "#{checkerParamName} <= #{v}"
                                                qString
                                            else
                                                qString = "#{checkerParamName} = #{v}"
                                                qString
                                            end
                                        end
                                    end
                                end
                            else
                                IO.inspect(">>.....String ...." <> v)
                                qString = "#{checkerParamName} = '#{v}'"
                                qString
                            end
                        end
                    end
                else

                    if checkerParamType == "number" do
                        qString =
                        if checkerParamValGreater == "greater" do
                            qString = "#{checkerParamName} > #{v}"
                            qString
                        else
                            qString =
                            if checkerParamValGreater == "less" do
                                qString = "#{checkerParamName} < #{v}"
                                qString
                            else
                                qString =
                                if checkerParamValGreater == "greaterorequals" do
                                    qString = "#{checkerParamName} >= #{v}"
                                    qString
                                else
                                    qString =
                                    if checkerParamValGreater == "lessorequals" do
                                        qString = "#{checkerParamName} <= #{v}"
                                        qString
                                    else
                                        qString = "#{checkerParamName} = #{v}"
                                        qString
                                    end
                                end
                            end
                        end
                    else
						if checkerParamValExpected == "date" do
							qString =
							if checkerParamValGreater == "greater" do
								qString = "#{checkerParamName} > '#{v}'"
								qString
							else
								qString =
								if checkerParamValGreater == "less" do
									qString = "#{checkerParamName} < '#{v}'"
									qString
								else
									qString =
									if checkerParamValGreater == "greaterorequals" do
										qString = "#{checkerParamName} >= '#{v}'"
										qString
									else
										qString =
										if checkerParamValGreater == "lessorequals" do
											qString = "#{checkerParamName} <= '#{v}'"
											qString
										else
											qString = "#{checkerParamName} = '#{v}'"
											qString
										end
									end
								end
							end
						else
							IO.inspect checkerParamType
							IO.inspect v
							qString =
							if (checkerParamType == "customsql"  and v != "-1") do
								qString = "#{v}"
								qString
							else
								qString =
								if (checkerParamType == "customsql") do
									qString
								else
									qString = "#{checkerParamName} = #{v}"
									qString
								end
							end
						end

                    end

                end

                IO.inspect("*****************************************************")
                IO.inspect(qString)
                qString
            else
            end



            IO.inspect "*****************************************************"
            IO.inspect(qString)
        end

        totals = Enum.filter(totals, &(!is_nil(&1)))
        IO.inspect(totals)

        query = nil

        query =
        if(Enum.count(totals) > 0) do
            qString = Enum.join(totals, " and ")
            query = " where #{qString}"
        end

        str =
        if(!is_nil(query)) do
            str = str <> query
        else
            str
        end

        IO.inspect("totals....")
        IO.inspect(str)

        reports = fixed_deposit_search(str)
        branches = Companies.list_tbl_branch()
        curencies = SystemSetting.list_tbl_currency()
        products = LoanSavingsSystem.Products.list_tbl_products()

        render(conn, "fixed_deposit_reports.html",
            reports: reports,
            curencies: curencies,
            branches: branches,
			products: products,
			params: params
        )
    end


  def fixed_deposit_search(querySQL) do
    IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"
    IO.inspect querySQL
    IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"

      ress = Ecto.Adapters.SQL.query!(Repo, querySQL, []);
      resultColumns = ress.columns
      IO.inspect "Play here"
      IO.inspect resultColumns
      resultRows = ress.rows;
      IO.inspect resultRows
      resultRows
    end
    #############################################################################################

    ############################# TRANSACTION ################################
    def transaction_reports(conn, params) do
        IO.inspect params
        branches = Companies.list_tbl_branch()
        curencies = SystemSetting.list_tbl_currency()
        reports = nil;
		products = LoanSavingsSystem.Products.list_tbl_products()

        render(conn, "transaction_reports.html", reports: reports, curencies: curencies, branches: branches, params: params, products: products)
    end

    def generate_transaction_reports(conn, params) do
        params = Map.delete(params, "_csrf_token")

        str =
        "SELECT b.firstName, b.lastName, b.mobileNumber, t.totalAmount, t.status, t.productType, t.referenceNo, t.inserted_at, t.userRoleId, t.userId,
                t.orderRef, t.transactionType, t.isReversed, t.requestData, t.responseData,
                t.carriedOutByUserId, t.carriedOutByUserRoleId, t.updated_at, t.accountId, t.productId,
                b.firstName, b.lastName, b.otherName, b.dateOfBirth, b.meansOfIdentificationType,
                b.meansOfIdentificationNumber, b.title, b.gender, b.emailAddress, b.clientId, t.currency, t.transactionTypeEnum, t.currencyDecimals
        FROM tbl_transactions t
        LEFT JOIN tbl_user_bio_data b
                ON b.userId = t.userId
		LEFT JOIN tbl_products p
                ON p.id = t.productId
        "

        paramKeys = Map.keys(params)
        IO.inspect(paramKeys)

        totals =
        for x <- 0..(Enum.count(paramKeys) - 1) do
            qString = nil
            paramKey = Enum.at(paramKeys, x)
            v = params[paramKey]

            qString =
            if(!is_nil(v) and v != -1 and String.length(v) > 0) do
                checker = String.split(paramKey, "__")
                IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>")
                IO.inspect(Enum.count(checker))
                checkerParamName = Enum.at(checker, 0)
                IO.inspect(checkerParamName)
                checkerParamType = Enum.at(checker, 1)
                IO.inspect("checkerParamType" <> checkerParamType)
                checkerParamValExpected = Enum.at(checker, 2)
                IO.inspect(checkerParamValExpected)
                checkerParamValGreater = Enum.at(checker, 3)
                IO.inspect(checkerParamValGreater)

                qString =
                if checkerParamType == "select" do
                    IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>....." <> checkerParamType <> "...." <> v)
                    qString =
                    if "#{v}" == "-1" do
                    else
                        qString =
                        if checkerParamValExpected == "boolean" do
                            qString =
                            if "#{v}" == "true" do
                                qString = "#{checkerParamName}"
                                qString
                            else
                                qString = "not #{checkerParamName}"
                                qString
                            end
                        else
                            IO.inspect(">>.....checkerParamValExpected ...." <> checkerParamValExpected)
                            IO.inspect(">>.....checkerParamValGreater ...." <> checkerParamValGreater)
                            qString =
                            if checkerParamValExpected == "number" do
                                qString =
                                if checkerParamValGreater == "greater" do
                                    qString = "#{checkerParamName} > #{v}"
                                    qString
                                else
                                    qString =
                                    if checkerParamValGreater == "less" do
                                        qString = "#{checkerParamName} < #{v}"
                                        qString
                                    else
                                        qString =
                                        if checkerParamValGreater == "greaterorequals" do
                                            qString = "#{checkerParamName} >= #{v}"
                                            qString
                                        else
                                            qString =
                                            if checkerParamValGreater == "lessorequals" do
                                                qString = "#{checkerParamName} <= #{v}"
                                                qString
                                            else
                                                qString = "#{checkerParamName} = #{v}"
                                                qString
                                            end
                                        end
                                    end
                                end
                            else
                                IO.inspect(">>.....String ...." <> v)
                                qString = "#{checkerParamName} = '#{v}'"
                                qString
                            end
                        end
                    end
                else

                    if checkerParamType == "number" do
                        qString =
                        if checkerParamValGreater == "greater" do
                            qString = "#{checkerParamName} > #{v}"
                            qString
                        else
                            qString =
                            if checkerParamValGreater == "less" do
                                qString = "#{checkerParamName} < #{v}"
                                qString
                            else
                                qString =
                                if checkerParamValGreater == "greaterorequals" do
                                    qString = "#{checkerParamName} >= #{v}"
                                    qString
                                else
                                    qString =
                                    if checkerParamValGreater == "lessorequals" do
                                        qString = "#{checkerParamName} <= #{v}"
                                        qString
                                    else
                                        qString = "#{checkerParamName} = #{v}"
                                        qString
                                    end
                                end
                            end
                        end
                    else
                        qString = "#{checkerParamName} = '#{v}'"
                        qString
                    end

                end

                IO.inspect("*****************************************************")
                IO.inspect(qString)
                qString
            else
            end



            IO.inspect "*****************************************************"
            IO.inspect(qString)
        end

        totals = Enum.filter(totals, &(!is_nil(&1)))
        IO.inspect(totals)

        query = nil

        query =
        if(Enum.count(totals) > 0) do
            qString = Enum.join(totals, " and ")
            query = " where #{qString}"
        end

        str =
        if(!is_nil(query)) do
            str = str <> query
        else
            str
        end

        IO.inspect("totals....")
        IO.inspect(str)

        reports = transaction_search(str)
        branches = Companies.list_tbl_branch()
        curencies = SystemSetting.list_tbl_currency()
		products = LoanSavingsSystem.Products.list_tbl_products()

        render(conn, "transaction_reports.html",
            reports: reports,
            curencies: curencies,
            branches: branches,
			params: params,
			products: products
        )
    end


  def transaction_search(querySQL) do
    IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"
    IO.inspect querySQL
    IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"

      ress = Ecto.Adapters.SQL.query!(Repo, querySQL, []);
      resultColumns = ress.columns
      IO.inspect "Play here"
      IO.inspect resultColumns
      resultRows = ress.rows;
      IO.inspect resultRows
      resultRows
    end
    #############################################################################################

    ############################# CUSTOMER REPORTS ################################
    def customer_reports(conn, params) do
        IO.inspect params
        branches = Companies.list_tbl_branch()
        curencies = SystemSetting.list_tbl_currency()
        reports = nil;
        products = LoanSavingsSystem.Products.list_tbl_products()
        render(conn, "customer_reports.html", reports: reports, curencies: curencies, branches: branches, params: params, products: products)
    end

    def generate_customer_reports(conn, params) do
        params = Map.delete(params, "_csrf_token")

        str =
        "SELECT b.firstName, b.lastName, b.mobileNumber, b.meansOfIdentificationNumber, b.dateOfBirth, uR.netPay, b.emailAddress,
                b.gender,uR.status, b.title,  b.clientId, b.inserted_at, b.otherName, b.meansOfIdentificationType,
                b.updated_at, uR.roleType, uR.companyId, b.userId, uR.branchId, a.totalDeposits, a.currencyDecimals, a.currencyName
        FROM tbl_user_bio_data b
        LEFT JOIN tbl_user_roles uR
                ON b.userId = uR.userId
        LEFT JOIN tbl_users u
                ON b.userId = u.id
        LEFT JOIN tbl_account a
                ON b.userId = a.userId
        "

        paramKeys = Map.keys(params)
        IO.inspect(paramKeys)

        totals =
        for x <- 0..(Enum.count(paramKeys) - 1) do
            qString = nil
            paramKey = Enum.at(paramKeys, x)
            v = params[paramKey]
			IO.inspect "ppppppppppppppppp"
			IO.inspect v

            qString =
            if(!is_nil(v) and v != "#{-1}" and String.length(v) > 0) do
                checker = String.split(paramKey, "__")
                IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>")
                IO.inspect(Enum.count(checker))
                checkerParamName = Enum.at(checker, 0)
                IO.inspect(checkerParamName)
                checkerParamType = Enum.at(checker, 1)
                IO.inspect("checkerParamType --- #{checkerParamType}")
                checkerParamValExpected = Enum.at(checker, 2)
                IO.inspect(checkerParamValExpected)
                checkerParamValGreater = Enum.at(checker, 3)
                IO.inspect(checkerParamValGreater)

                qString =
                if checkerParamType == "select" do
                    IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>....." <> checkerParamType <> "...." <> v)
                    qString =
                    if "#{v}" == "-1" do
                    else
                        qString =
                        if checkerParamValExpected == "boolean" do
                            qString =
                            if "#{v}" == "true" do
                                qString = "#{checkerParamName}"
                                qString
                            else
                                qString = "not #{checkerParamName}"
                                qString
                            end
                        else
                            IO.inspect(">>.....checkerParamValExpected ...." <> checkerParamValExpected)
                            IO.inspect(">>.....checkerParamValGreater ...." <> checkerParamValGreater)
                            qString =
                            if checkerParamValExpected == "number" do
                                qString =
                                if checkerParamValGreater == "greater" do
                                    qString = "#{checkerParamName} > #{v}"
                                    qString
                                else
                                    qString =
                                    if checkerParamValGreater == "less" do
                                        qString = "#{checkerParamName} < #{v}"
                                        qString
                                    else
                                        qString =
                                        if checkerParamValGreater == "greaterorequals" do
                                            qString = "#{checkerParamName} >= #{v}"
                                            qString
                                        else
                                            qString =
                                            if checkerParamValGreater == "lessorequals" do
                                                qString = "#{checkerParamName} <= #{v}"
                                                qString
                                            else
                                                qString = "#{checkerParamName} = #{v}"
                                                qString
                                            end
                                        end
                                    end
                                end
                            else
								if checkerParamValExpected == "string" do
									if checkerParamValGreater == "lookslike" do
										qString = "#{checkerParamName} like '%#{v}%'"
										qString
									else
										IO.inspect(">>.....String ...." <> v)
										qString = "#{checkerParamName} = '#{v}'"
										qString
									end
								else
									IO.inspect(">>.....String ...." <> v)
									qString = "#{checkerParamName} = '#{v}'"
									qString
								end
                            end
                        end
                    end
                else

                    if checkerParamType == "number" do
                        qString =
                        if checkerParamValGreater == "greater" do
                            qString = "#{checkerParamName} > #{v}"
                            qString
                        else
                            qString =
                            if checkerParamValGreater == "less" do
                                qString = "#{checkerParamName} < #{v}"
                                qString
                            else
                                qString =
                                if checkerParamValGreater == "greaterorequals" do
                                    qString = "#{checkerParamName} >= #{v}"
                                    qString
                                else
                                    qString =
                                    if checkerParamValGreater == "lessorequals" do
                                        qString = "#{checkerParamName} <= #{v}"
                                        qString
                                    else
                                        qString = "#{checkerParamName} = #{v}"
                                        qString
                                    end
                                end
                            end
                        end
                    else

						if checkerParamValExpected == "date" do
							qString =
							if checkerParamValGreater == "greater" do
								qString = "#{checkerParamName} > '#{v}'"
								qString
							else
								qString =
								if checkerParamValGreater == "less" do
									qString = "#{checkerParamName} < '#{v}'"
									qString
								else
									qString =
									if checkerParamValGreater == "greaterorequals" do
										qString = "#{checkerParamName} >= '#{v}'"
										qString
									else
										qString =
										if checkerParamValGreater == "lessorequals" do
											qString = "#{checkerParamName} <= '#{v}'"
											qString
										else
											qString = "#{checkerParamName} = '#{v}'"
											qString
										end
									end
								end
							end
						else
							IO.inspect "checkerParamValGreater...#{checkerParamValGreater}"
							if checkerParamValGreater == "lookslike" do
								qString = "#{checkerParamName} LIKE '%#{v}%'"
								qString
							else
								qString = "#{checkerParamName} = '#{v}'"
								qString
							end
						end


                    end

                end

                IO.inspect("*****************************************************")
                IO.inspect(qString)
                qString
            else
            end



            IO.inspect "*****************************************************"
            IO.inspect(qString)
        end

        totals = Enum.filter(totals, &(!is_nil(&1)))
        IO.inspect(totals)

        query = nil


        query =
        if(Enum.count(totals) > 0) do
			totals = totals ++ [];
            qString = Enum.join(totals, " and ")
            query = " where #{qString}"
		else

        end



        str =
        if(!is_nil(query)) do
            str = str <> query
        else
            str
        end






        IO.inspect("totals....")
        IO.inspect(str)


		str =
		if(String.length(str)>0) do
			str = str <> " and uR.roleType = 'INDIVIDUAL'"
		else
			str = str <> " where uR.roleType = 'INDIVIDUAL'"
		end

        reports = customer_search(str)
        branches = Companies.list_tbl_branch()
        curencies = SystemSetting.list_tbl_currency()
        products = LoanSavingsSystem.Products.list_tbl_products()

        render(conn, "customer_reports.html",
            reports: reports,
            curencies: curencies,
            branches: branches,
			params: params,
			products: products
        )
    end


  def customer_search(querySQL) do
    IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"
    IO.inspect querySQL
    IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"

      ress = Ecto.Adapters.SQL.query!(Repo, querySQL, []);
      resultColumns = ress.columns
      IO.inspect "Play here"
      IO.inspect resultColumns
      resultRows = ress.rows;
      IO.inspect resultRows
      resultRows
    end
    #############################################################################################

    ############################# DIVESTMENT REPORTS ################################
    def divestment_reports(conn, params) do
		IO.inspect "#############";
        IO.inspect params
        branches = Companies.list_tbl_branch()
        curencies = SystemSetting.list_tbl_currency()
        products = LoanSavingsSystem.Products.list_tbl_products()
		i1 = 1;

        reports = nil;
        render(conn, "divestment_reports.html", reports: reports, curencies: curencies, branches: branches, params: params, products: products, i1: i1)
    end

    def generate_divestment_reports(conn, params) do
        params = Map.delete(params, "_csrf_token")

        str =
        "SELECT d.customerName, d.principalAmount, d.divestAmount, d.interestRate, d.interestAccrued, d.interestRateType, d.fixedPeriod,
                d.divestmentDayCount, d.divestmentValuation, d.divestmentDate,
                d.clientId, d.userId, d.userRoleId, d.fixedDepositId,
                d.inserted_at, d.updated_at, d.divestmentType, d.currencyDecimals, d.currency, p.name as productName, fd.fixedPeriodType, fd.yearLengthInDays
        FROM tbl_divestments d, tbl_fixed_deposit fd, tbl_products p
        "

        paramKeys = Map.keys(params)
        IO.inspect(paramKeys)

        totals =
        for x <- 0..(Enum.count(paramKeys) - 1) do
            qString = nil
            paramKey = Enum.at(paramKeys, x)
            v = params[paramKey]

            qString =
            if(!is_nil(v) and v != -1 and String.length(v) > 0) do
                checker = String.split(paramKey, "__")
                IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>")
                IO.inspect(Enum.count(checker))
                checkerParamName = Enum.at(checker, 0)
                IO.inspect(checkerParamName)
                checkerParamType = Enum.at(checker, 1)
                IO.inspect("checkerParamType" <> checkerParamType)
                checkerParamValExpected = Enum.at(checker, 2)
                IO.inspect(checkerParamValExpected)
                checkerParamValGreater = Enum.at(checker, 3)
                IO.inspect(checkerParamValGreater)

                qString =
                if checkerParamType == "select" do
                    IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>....." <> checkerParamType <> "...." <> v)
                    qString =
                    if "#{v}" == "-1" do
                    else
                        qString =
                        if checkerParamValExpected == "boolean" do
                            qString =
                            if "#{v}" == "true" do
                                qString = "#{checkerParamName}"
                                qString
                            else
                                qString = "not #{checkerParamName}"
                                qString
                            end
                        else
                            IO.inspect(">>.....checkerParamValExpected ...." <> checkerParamValExpected)
                            IO.inspect(">>.....checkerParamValGreater ...." <> checkerParamValGreater)
                            qString =
                            if checkerParamValExpected == "number" do
                                qString =
                                if checkerParamValGreater == "greater" do
                                    qString = "#{checkerParamName} > #{v}"
                                    qString
                                else
                                    qString =
                                    if checkerParamValGreater == "less" do
                                        qString = "#{checkerParamName} < #{v}"
                                        qString
                                    else
                                        qString =
                                        if checkerParamValGreater == "greaterorequals" do
                                            qString = "#{checkerParamName} >= #{v}"
                                            qString
                                        else
                                            qString =
                                            if checkerParamValGreater == "lessorequals" do
                                                qString = "#{checkerParamName} <= #{v}"
                                                qString
                                            else
                                                qString = "#{checkerParamName} = #{v}"
                                                qString
                                            end
                                        end
                                    end
                                end
                            else
                                if checkerParamValExpected == "date" do
									qString =
									if checkerParamValGreater == "greater" do
										qString = "#{checkerParamName} > '#{v}'"
										qString
									else
										qString =
										if checkerParamValGreater == "less" do
											qString = "#{checkerParamName} < '#{v}'"
											qString
										else
											qString =
											if checkerParamValGreater == "greaterorequals" do
												qString = "#{checkerParamName} >= '#{v}'"
												qString
											else
												qString =
												if checkerParamValGreater == "lessorequals" do
													qString = "#{checkerParamName} <= '#{v}'"
													qString
												else
													qString = "#{checkerParamName} = '#{v}'"
													qString
												end
											end
										end
									end
								else
									IO.inspect(">>.....String ...." <> v)
									qString = "#{checkerParamName} = '#{v}'"
									qString
								end
                            end
                        end
                    end
                else

                    if checkerParamType == "number" do
                        qString =
                        if checkerParamValGreater == "greater" do
                            qString = "#{checkerParamName} > #{v}"
                            qString
                        else
                            qString =
                            if checkerParamValGreater == "less" do
                                qString = "#{checkerParamName} < #{v}"
                                qString
                            else
                                qString =
                                if checkerParamValGreater == "greaterorequals" do
                                    qString = "#{checkerParamName} >= #{v}"
                                    qString
                                else
                                    qString =
                                    if checkerParamValGreater == "lessorequals" do
                                        qString = "#{checkerParamName} <= #{v}"
                                        qString
                                    else
                                        qString = "#{checkerParamName} = #{v}"
                                        qString
                                    end
                                end
                            end
                        end
                    else
                        if checkerParamValExpected == "date" do
							qString =
							if checkerParamValGreater == "greater" do
								qString = "#{checkerParamName} > '#{v}'"
								qString
							else
								qString =
								if checkerParamValGreater == "less" do
									qString = "#{checkerParamName} < '#{v}'"
									qString
								else
									qString =
									if checkerParamValGreater == "greaterorequals" do
										qString = "#{checkerParamName} >= '#{v}'"
										qString
									else
										qString =
										if checkerParamValGreater == "lessorequals" do
											qString = "#{checkerParamName} <= '#{v}'"
											qString
										else
											qString = "#{checkerParamName} = '#{v}'"
											qString
										end
									end
								end
							end
						else
							IO.inspect(">>.....String ...." <> v)
							qString = "#{checkerParamName} = '#{v}'"
							qString
						end
                    end

                end

                IO.inspect("*****************************************************")
                IO.inspect(qString)
                qString
            else
            end



            IO.inspect "*****************************************************"
            IO.inspect(qString)
        end

        totals = Enum.filter(totals, &(!is_nil(&1)))
        IO.inspect(totals)

        query = nil

        query =
        if(Enum.count(totals) > 0) do
            qString = Enum.join(totals, " and ")
            query = " where #{qString}"
			query = query <> " AND d.fixedDepositId = fd.id AND fd.productId = p.id "
			query
		else
			query = " WHERE d.fixedDepositId = fd.id AND fd.productId = p.id "
			query
        end

        str =
        if(!is_nil(query)) do
            str = str <> query
        else
            str
        end

        IO.inspect("totals....")
        IO.inspect(str)

        reports = divestment_search(str)
        branches = Companies.list_tbl_branch()
        curencies = SystemSetting.list_tbl_currency()
        products = LoanSavingsSystem.Products.list_tbl_products()


		IO.inspect "#############";
        IO.inspect params
		i1 = 1;
        render(conn, "divestment_reports.html",
            reports: reports,
            curencies: curencies,
            branches: branches,
			products: products,
			params: params,
			i1: i1
        )
    end



	def compareProduct(id1, id2) do
		IO.inspect"......................"
		IO.inspect id1;
		IO.inspect id2;
	end


	def divestment_search(querySQL) do
		IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"
		IO.inspect querySQL
		IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"

		ress = Ecto.Adapters.SQL.query!(Repo, querySQL, []);
		resultColumns = ress.columns
		IO.inspect "Play here"
		IO.inspect resultColumns
		resultRows = ress.rows;
		IO.inspect resultRows
		resultRows
    end

















    #####################################DISBURSED REPORTS##################################

    #   def disbursed_reports(conn, params) do
    #     branches = Companies.list_tbl_branch()
    #     curencies = SystemSetting.list_tbl_currency()
    #     reports = nil;
    #     products = LoanSavingsSystem.Loan.list_tbl_loans()
    #     render(conn, "disbursed_reports.html", reports: reports, curencies: curencies, branches: branches, params: params, products: products)
    # end

    def loans_disbursed_reports(conn, params) do
        IO.inspect params
        branches = Companies.list_tbl_branch()
        curencies = SystemSetting.list_tbl_currency()
        reports = nil;
      #   products = LoanSavingsSystem.Products.list_tbl_products()
        products = LoanSavingsSystem.Loan.list_tbl_loans()
        render(conn, "loans_disbursed_reports.html", reports: reports, curencies: curencies, branches: branches, params: params, products: products)
    end

      def generate_disbursed_reports(conn, params) do
          params = Map.delete(params, "_csrf_token")

          str =
          "SELECT b.firstName, b.lastName, b.mobileNumber, t.totalAmount, t.status, t.productType, t.referenceNo, t.inserted_at, t.userRoleId, t.userId,
                  t.orderRef, t.transactionType, t.isReversed, t.requestData, t.responseData,
                  t.carriedOutByUserId, t.carriedOutByUserRoleId, t.updated_at, t.accountId, t.productId,
                  b.firstName, b.lastName, b.otherName, b.dateOfBirth, b.meansOfIdentificationType,
                  b.meansOfIdentificationNumber, b.title, b.gender, b.emailAddress, b.clientId, t.currency, t.transactionTypeEnum, t.currencyDecimals
          FROM tbl_transactions t
          LEFT JOIN tbl_user_bio_data b
                  ON t.userId = t.userId
          LEFT JOIN tbl_products p
                  ON p.id = t.productId
          "

          paramKeys = Map.keys(params)
          IO.inspect(paramKeys)

          totals =
          for x <- 0..(Enum.count(paramKeys) - 1) do
              qString = nil
              paramKey = Enum.at(paramKeys, x)
              v = params[paramKey]

              qString =
              if(!is_nil(v) and v != -1 and String.length(v) > 0) do
                  checker = String.split(paramKey, "__")
                  IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>")
                  IO.inspect(Enum.count(checker))
                  checkerParamName = Enum.at(checker, 0)
                  IO.inspect(checkerParamName)
                  checkerParamType = Enum.at(checker, 1)
                  IO.inspect("checkerParamType" <> checkerParamType)
                  checkerParamValExpected = Enum.at(checker, 2)
                  IO.inspect(checkerParamValExpected)
                  checkerParamValGreater = Enum.at(checker, 3)
                  IO.inspect(checkerParamValGreater)

                  qString =
                  if checkerParamType == "select" do
                      IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>....." <> checkerParamType <> "...." <> v)
                      qString =
                      if "#{v}" == "-1" do
                      else
                          qString =
                          if checkerParamValExpected == "boolean" do
                              qString =
                              if "#{v}" == "true" do
                                  qString = "#{checkerParamName}"
                                  qString
                              else
                                  qString = "not #{checkerParamName}"
                                  qString
                              end
                          else
                              IO.inspect(">>.....checkerParamValExpected ...." <> checkerParamValExpected)
                              IO.inspect(">>.....checkerParamValGreater ...." <> checkerParamValGreater)
                              qString =
                              if checkerParamValExpected == "number" do
                                  qString =
                                  if checkerParamValGreater == "greater" do
                                      qString = "#{checkerParamName} > #{v}"
                                      qString
                                  else
                                      qString =
                                      if checkerParamValGreater == "less" do
                                          qString = "#{checkerParamName} < #{v}"
                                          qString
                                      else
                                          qString =
                                          if checkerParamValGreater == "greaterorequals" do
                                              qString = "#{checkerParamName} >= #{v}"
                                              qString
                                          else
                                              qString =
                                              if checkerParamValGreater == "lessorequals" do
                                                  qString = "#{checkerParamName} <= #{v}"
                                                  qString
                                              else
                                                  qString = "#{checkerParamName} = #{v}"
                                                  qString
                                              end
                                          end
                                      end
                                  end
                              else
                                  IO.inspect(">>.....String ...." <> v)
                                  qString = "#{checkerParamName} = '#{v}'"
                                  qString
                              end
                          end
                      end
                  else

                      if checkerParamType == "number" do
                          qString =
                          if checkerParamValGreater == "greater" do
                              qString = "#{checkerParamName} > #{v}"
                              qString
                          else
                              qString =
                              if checkerParamValGreater == "less" do
                                  qString = "#{checkerParamName} < #{v}"
                                  qString
                              else
                                  qString =
                                  if checkerParamValGreater == "greaterorequals" do
                                      qString = "#{checkerParamName} >= #{v}"
                                      qString
                                  else
                                      qString =
                                      if checkerParamValGreater == "lessorequals" do
                                          qString = "#{checkerParamName} <= #{v}"
                                          qString
                                      else
                                          qString = "#{checkerParamName} = #{v}"
                                          qString
                                      end
                                  end
                              end
                          end
                      else
                          qString = "#{checkerParamName} = '#{v}'"
                          qString
                      end

                  end

                  IO.inspect("*****************************************************")
                  IO.inspect(qString)
                  qString
              else
              end



              IO.inspect "*****************************************************"
              IO.inspect(qString)
          end

          totals = Enum.filter(totals, &(!is_nil(&1)))
          IO.inspect(totals)

          query = nil

          query =
          if(Enum.count(totals) > 0) do
              qString = Enum.join(totals, " and ")
              query = " where #{qString}"
          end

          str =
          if(!is_nil(query)) do
              str = str <> query
          else
              str
          end

          IO.inspect("totals....")
          IO.inspect(str)

          reports = transaction_search(str)
          branches = Companies.list_tbl_branch()
          curencies = SystemSetting.list_tbl_currency()
          products = LoanSavingsSystem.Products.list_tbl_products()

          render(conn, "disbursed_reports.html",
              reports: reports,
              curencies: curencies,
              branches: branches,
              params: params,
              products: products
          )
      end


    def disbursed_search(querySQL) do
      IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"
      IO.inspect querySQL
      IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"

        ress = Ecto.Adapters.SQL.query!(Repo, querySQL, []);
        resultColumns = ress.columns
        IO.inspect "Play here"
        IO.inspect resultColumns
        resultRows = ress.rows;
        IO.inspect resultRows
        resultRows
      end

       ###########################PENDING DISBURSEMENT REPORTS##################################

       #def pending_disbursment_reports(conn, params) do
         # IO.inspect params
          #branches = Companies.list_tbl_branch()
          #curencies = SystemSetting.list_tbl_currency()
          #reports = nil;
          #products = LoanSavingsSystem.Products.list_tbl_products()

          #render(conn, "loans_pending_disbursment_reports.html", reports: reports, curencies: curencies, branches: branches, params: params, products: products)
      #end

      def loans_disbursement_reports(conn, params) do
        IO.inspect params
        branches = Companies.list_tbl_branch()
        curencies = SystemSetting.list_tbl_currency()
        reports = nil;
        products = LoanSavingsSystem.Loan.list_tbl_loans()

        render(conn, "loans_disbursement_reports.html", reports: reports, curencies: curencies, branches: branches, params: params, products: products)
    end

      def generate_disbursement_reports(conn, params) do
          params = Map.delete(params, "_csrf_token")

          str =
          "SELECT b.firstName, b.lastName, b.mobileNumber, t.totalAmount, t.status, t.productType, t.referenceNo, t.inserted_at, t.userRoleId, t.userId,
                  t.orderRef, t.transactionType, t.isReversed, t.requestData, t.responseData,
                  t.carriedOutByUserId, t.carriedOutByUserRoleId, t.updated_at, t.accountId, t.productId,
                  b.firstName, b.lastName, b.otherName, b.dateOfBirth, b.meansOfIdentificationType,
                  b.meansOfIdentificationNumber, b.title, b.gender, b.emailAddress, b.clientId, t.currency, t.transactionTypeEnum, t.currencyDecimals
          FROM tbl_transactions t
          LEFT JOIN tbl_user_bio_data b
                  ON b.userId = t.userId
          LEFT JOIN tbl_products p
                  ON p.id = t.productId
          "

          paramKeys = Map.keys(params)
          IO.inspect(paramKeys)

          totals =
          for x <- 0..(Enum.count(paramKeys) - 1) do
              qString = nil
              paramKey = Enum.at(paramKeys, x)
              v = params[paramKey]

              qString =
              if(!is_nil(v) and v != -1 and String.length(v) > 0) do
                  checker = String.split(paramKey, "__")
                  IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>")
                  IO.inspect(Enum.count(checker))
                  checkerParamName = Enum.at(checker, 0)
                  IO.inspect(checkerParamName)
                  checkerParamType = Enum.at(checker, 1)
                  IO.inspect("checkerParamType" <> checkerParamType)
                  checkerParamValExpected = Enum.at(checker, 2)
                  IO.inspect(checkerParamValExpected)
                  checkerParamValGreater = Enum.at(checker, 3)
                  IO.inspect(checkerParamValGreater)

                  qString =
                  if checkerParamType == "select" do
                      IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>....." <> checkerParamType <> "...." <> v)
                      qString =
                      if "#{v}" == "-1" do
                      else
                          qString =
                          if checkerParamValExpected == "boolean" do
                              qString =
                              if "#{v}" == "true" do
                                  qString = "#{checkerParamName}"
                                  qString
                              else
                                  qString = "not #{checkerParamName}"
                                  qString
                              end
                          else
                              IO.inspect(">>.....checkerParamValExpected ...." <> checkerParamValExpected)
                              IO.inspect(">>.....checkerParamValGreater ...." <> checkerParamValGreater)
                              qString =
                              if checkerParamValExpected == "number" do
                                  qString =
                                  if checkerParamValGreater == "greater" do
                                      qString = "#{checkerParamName} > #{v}"
                                      qString
                                  else
                                      qString =
                                      if checkerParamValGreater == "less" do
                                          qString = "#{checkerParamName} < #{v}"
                                          qString
                                      else
                                          qString =
                                          if checkerParamValGreater == "greaterorequals" do
                                              qString = "#{checkerParamName} >= #{v}"
                                              qString
                                          else
                                              qString =
                                              if checkerParamValGreater == "lessorequals" do
                                                  qString = "#{checkerParamName} <= #{v}"
                                                  qString
                                              else
                                                  qString = "#{checkerParamName} = #{v}"
                                                  qString
                                              end
                                          end
                                      end
                                  end
                              else
                                  IO.inspect(">>.....String ...." <> v)
                                  qString = "#{checkerParamName} = '#{v}'"
                                  qString
                              end
                          end
                      end
                  else

                      if checkerParamType == "number" do
                          qString =
                          if checkerParamValGreater == "greater" do
                              qString = "#{checkerParamName} > #{v}"
                              qString
                          else
                              qString =
                              if checkerParamValGreater == "less" do
                                  qString = "#{checkerParamName} < #{v}"
                                  qString
                              else
                                  qString =
                                  if checkerParamValGreater == "greaterorequals" do
                                      qString = "#{checkerParamName} >= #{v}"
                                      qString
                                  else
                                      qString =
                                      if checkerParamValGreater == "lessorequals" do
                                          qString = "#{checkerParamName} <= #{v}"
                                          qString
                                      else
                                          qString = "#{checkerParamName} = #{v}"
                                          qString
                                      end
                                  end
                              end
                          end
                      else
                          qString = "#{checkerParamName} = '#{v}'"
                          qString
                      end

                  end

                  IO.inspect("*****************************************************")
                  IO.inspect(qString)
                  qString
              else
              end



              IO.inspect "*****************************************************"
              IO.inspect(qString)
          end

          totals = Enum.filter(totals, &(!is_nil(&1)))
          IO.inspect(totals)

          query = nil

          query =
          if(Enum.count(totals) > 0) do
              qString = Enum.join(totals, " and ")
              query = " where #{qString}"
          end

          str =
          if(!is_nil(query)) do
              str = str <> query
          else
              str
          end

          IO.inspect("totals....")
          IO.inspect(str)

          reports = transaction_search(str)
          branches = Companies.list_tbl_branch()
          curencies = SystemSetting.list_tbl_currency()
          products = LoanSavingsSystem.Products.list_tbl_products()

          render(conn, "pending_disbursement_reports.html",
              reports: reports,
              curencies: curencies,
              branches: branches,
              params: params,
              products: products
          )
      end


    def pending_disbursement_search(querySQL) do
      IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"
      IO.inspect querySQL
      IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"

        ress = Ecto.Adapters.SQL.query!(Repo, querySQL, []);
        resultColumns = ress.columns
        IO.inspect "Play here"
        IO.inspect resultColumns
        resultRows = ress.rows;
        IO.inspect resultRows
        resultRows
      end


       ####################################REJECTED REPORTS#####################################

       #def pending_disbursment_reports(conn, params) do
         # IO.inspect params
          #branches = Companies.list_tbl_branch()
          #curencies = SystemSetting.list_tbl_currency()
          #reports = nil;
          #products = LoanSavingsSystem.Products.list_tbl_products()

          #render(conn, "loans_pending_disbursment_reports.html", reports: reports, curencies: curencies, branches: branches, params: params, products: products)
      #end

      def loans_rejected_reports(conn, params) do
          IO.inspect params
          branches = Companies.list_tbl_branch()
          curencies = SystemSetting.list_tbl_currency()
          reports = nil;
          products = LoanSavingsSystem.Loan.list_tbl_loans()

          render(conn, "loans_rejected_reports.html", reports: reports, curencies: curencies, branches: branches, params: params, products: products)
      end

        def generate_rejected_reports(conn, params) do
            params = Map.delete(params, "_csrf_token")

            str =
            "SELECT b.firstName, b.lastName, b.mobileNumber, t.totalAmount, t.status, t.productType, t.referenceNo, t.inserted_at, t.userRoleId, b.userId,
                    t.orderRef, t.transactionType, t.isReversed, t.requestData, t.responseData,
                    t.carriedOutByUserId, t.carriedOutByUserRoleId, t.updated_at, t.accountId, t.productId,
                    b.firstName, b.lastName, b.otherName, b.dateOfBirth, b.meansOfIdentificationType,
                    b.meansOfIdentificationNumber, b.title, b.gender, b.emailAddress, b.clientId, t.currency, t.transactionTypeEnum, t.currencyDecimals
            FROM tbl_transactions t
            LEFT JOIN tbl_user_bio_data b
                    ON b.userId = b.userId
            LEFT JOIN tbl_products p
                    ON p.id = t.productId
            "

            paramKeys = Map.keys(params)
            IO.inspect(paramKeys)

            totals =
            for x <- 0..(Enum.count(paramKeys) - 1) do
                qString = nil
                paramKey = Enum.at(paramKeys, x)
                v = params[paramKey]

                qString =
                if(!is_nil(v) and v != -1 and String.length(v) > 0) do
                    checker = String.split(paramKey, "__")
                    IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>")
                    IO.inspect(Enum.count(checker))
                    checkerParamName = Enum.at(checker, 0)
                    IO.inspect(checkerParamName)
                    checkerParamType = Enum.at(checker, 1)
                    IO.inspect("checkerParamType" <> checkerParamType)
                    checkerParamValExpected = Enum.at(checker, 2)
                    IO.inspect(checkerParamValExpected)
                    checkerParamValGreater = Enum.at(checker, 3)
                    IO.inspect(checkerParamValGreater)

                    qString =
                    if checkerParamType == "select" do
                        IO.inspect(">>>>>>>>>>>>>>>>>>>>>>>>....." <> checkerParamType <> "...." <> v)
                        qString =
                        if "#{v}" == "-1" do
                        else
                            qString =
                            if checkerParamValExpected == "boolean" do
                                qString =
                                if "#{v}" == "true" do
                                    qString = "#{checkerParamName}"
                                    qString
                                else
                                    qString = "not #{checkerParamName}"
                                    qString
                                end
                            else
                                IO.inspect(">>.....checkerParamValExpected ...." <> checkerParamValExpected)
                                IO.inspect(">>.....checkerParamValGreater ...." <> checkerParamValGreater)
                                qString =
                                if checkerParamValExpected == "number" do
                                    qString =
                                    if checkerParamValGreater == "greater" do
                                        qString = "#{checkerParamName} > #{v}"
                                        qString
                                    else
                                        qString =
                                        if checkerParamValGreater == "less" do
                                            qString = "#{checkerParamName} < #{v}"
                                            qString
                                        else
                                            qString =
                                            if checkerParamValGreater == "greaterorequals" do
                                                qString = "#{checkerParamName} >= #{v}"
                                                qString
                                            else
                                                qString =
                                                if checkerParamValGreater == "lessorequals" do
                                                    qString = "#{checkerParamName} <= #{v}"
                                                    qString
                                                else
                                                    qString = "#{checkerParamName} = #{v}"
                                                    qString
                                                end
                                            end
                                        end
                                    end
                                else
                                    IO.inspect(">>.....String ...." <> v)
                                    qString = "#{checkerParamName} = '#{v}'"
                                    qString
                                end
                            end
                        end
                    else

                        if checkerParamType == "number" do
                            qString =
                            if checkerParamValGreater == "greater" do
                                qString = "#{checkerParamName} > #{v}"
                                qString
                            else
                                qString =
                                if checkerParamValGreater == "less" do
                                    qString = "#{checkerParamName} < #{v}"
                                    qString
                                else
                                    qString =
                                    if checkerParamValGreater == "greaterorequals" do
                                        qString = "#{checkerParamName} >= #{v}"
                                        qString
                                    else
                                        qString =
                                        if checkerParamValGreater == "lessorequals" do
                                            qString = "#{checkerParamName} <= #{v}"
                                            qString
                                        else
                                            qString = "#{checkerParamName} = #{v}"
                                            qString
                                        end
                                    end
                                end
                            end
                        else
                            qString = "#{checkerParamName} = '#{v}'"
                            qString
                        end

                    end

                    IO.inspect("*****************************************************")
                    IO.inspect(qString)
                    qString
                else
                end



                IO.inspect "*****************************************************"
                IO.inspect(qString)
            end

            totals = Enum.filter(totals, &(!is_nil(&1)))
            IO.inspect(totals)

            query = nil

            query =
            if(Enum.count(totals) > 0) do
                qString = Enum.join(totals, " and ")
                query = " where #{qString}"
            end

            str =
            if(!is_nil(query)) do
                str = str <> query
            else
                str
            end

            IO.inspect("totals....")
            IO.inspect(str)

            reports = transaction_search(str)
            branches = Companies.list_tbl_branch()
            curencies = SystemSetting.list_tbl_currency()
            products = LoanSavingsSystem.Products.list_tbl_products()

            render(conn, "rejected_reports.html",
                reports: reports,
                curencies: curencies,
                branches: branches,
                params: params,
                products: products
            )
        end


      def pending_rejected_search(querySQL) do
        IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"
        IO.inspect querySQL
        IO.inspect"++++++++++++++++++++++++++++++++++++++++++++++++"

          ress = Ecto.Adapters.SQL.query!(Repo, querySQL, []);
          resultColumns = ress.columns
          IO.inspect "Play here"
          IO.inspect resultColumns
          resultRows = ress.rows;
          IO.inspect resultRows
          resultRows
        end








    #############################################################################################




  def fixed_deposit_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = LoanSavingsSystem.FixedDeposit.fixed_deposits_report(search_params, start, length)
    total_entries = total_entries(results)
    entries = entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }
    json(conn, results)
  end





  def total_entries(%{total_entries: total_entries}), do: total_entries
  def total_entries(_), do: 0

  def entries(%{entries: entries}), do: entries
  def entries(_), do: []

  def search_options(params) do
    length = calculate_page_size(params["length"])
    page = calculate_page_num(params["start"], length)
    draw = String.to_integer(params["draw"])
    params = Map.put(params, "isearch", params["search"]["value"])

    new_params =
      Enum.reduce(~w(columns order search length draw start _csrf_token), params, fn key, acc ->
        Map.delete(acc, key)
      end)

    {draw, page, length, new_params}
  end

  def calculate_page_num(nil, _), do: 1

  def calculate_page_num(start, length) do
    start = String.to_integer(start)
    round(start / length + 1)
  end

  def calculate_page_size(nil), do: 10
  def calculate_page_size(length), do: String.to_integer(length)




  def divestment_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = LoanSavingsSystem.Divestments.divestment_data_report(search_params, start, length)
    total_entries = total_entries(results)
    entries = entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }
    json(conn, results)
  end


  def all_customer_txn_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = LoanSavingsSystem.Transactions.all_customer_txn_data_report(search_params, start, length)
    total_entries = total_entries(results)
    entries = entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }
    json(conn, results)
  end

  def all_customer_item_lookup(conn, params) do
    {draw, start, length, search_params} = search_options(params)
    results = LoanSavingsSystem.Transactions.all_customer_data_report(search_params, start, length)
    total_entries = total_entries(results)
    entries = entries(results)

    results = %{
      draw: draw,
      recordsTotal: total_entries,
      recordsFiltered: total_entries,
      data: entries
    }
    json(conn, results)
  end






end
