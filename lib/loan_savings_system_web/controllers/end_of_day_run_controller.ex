defmodule LoanSavingsSystemWeb.EndOfDayRunController do
  use LoanSavingsSystemWeb, :controller

  alias LoanSavingsSystem.EndOfDay
  alias LoanSavingsSystem.EndOfDay.EndOfDayRun

    alias LoanSavingsSystem.Repo
    alias LoanSavingsSystem.EndOfDay.EndOfDayEntry
    alias LoanSavingsSystem.FixedDeposit.FixedDeposits
	alias LoanSavingsSystem.EndOfDay.FlexCubeConfig
	alias LoanSavingsSystem.EndOfDay.Calendar
	alias LoanSavingsSystem.EndOfDay.Holiday
	alias LoanSavingsSystem.Notifications.Sms

    require Record
    require Logger
    import Ecto.Query, warn: false
	import SweetXml

  def index(conn, _params) do
    tbl_end_of_day = EndOfDay.list_tbl_end_of_day()
	host = conn.host

    query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: cl.domain == ^host, select: cl
	clientTelco = Repo.one(query);

	query = from cl in LoanSavingsSystem.Client.Clients, where: cl.id == 1, select: cl
	client = Repo.one(query);

	IO.inspect client

    render(conn, "index.html", tbl_end_of_day: tbl_end_of_day, client: client)
  end

	def new1(conn, _params) do
		date_ran = DateTime.utc_now();
		IO.inspect date_ran;
		#IO.inspect actualAccrualEndDate;
		summary = DateTime.add(date_ran, (30*24*60*60), :second) |> DateTime.truncate(:second)
		summary = "Summary. ....#{summary}\n\n";
		resp = [summary];
		resp = for x <- 1..30 do
			actualAccrualEndDate = DateTime.add(date_ran, (x*24*60*60), :second) |> DateTime.truncate(:second)
			resp1 = "#{(x)}. ....#{actualAccrualEndDate}\n\n"
			resp = resp ++ resp1
		end

		resp = Enum.join(resp, "\n");





        send_response_with_header(conn, resp)
	end


	def send_response_with_header(conn, response) do
        Logger.info  "Test!"
        Logger.info  Jason.encode!(response)
        #Logger.info response[:Message];
        #send_resp(conn, :ok, Jason.encode!(response))
        #put_resp_header(conn, "Content-type", "text/html; charset=utf-8");
        #put_resp_header(conn, "Freeflow", "FB");
        #send_resp(conn, :ok, response)
        conn
        |> put_status(:ok)
        |> put_resp_header("Freeflow", "FB")
        |> send_resp(:ok, response)
    end

	def new(conn, _params) do
		IO.inspect "Create End Of Day"
		isDivested = false
		isMatured = false
		query = from au in FixedDeposits,
				where: au.isMatured == type(^isMatured, :boolean),
				where: au.isDivested == type(^isDivested, :boolean),
				order_by: [desc: :inserted_at],
				select: au
		fixedDepositsList = Repo.all(query);





		#if Enum.count(fixedDepositsList)==0 do
		#	conn
		#		|> put_flash(:error, "You can not run an end-of-day at the moment. There are no fixed deposits to run end-of-day for")
		#		|> redirect(to: Routes.loan_path(conn, :fixed_deps))
		#else
			type_str = "FIXED DEPOSITS"
			query = from au in LoanSavingsSystem.EndOfDay.EndOfDayRun,
				where: (au.end_of_day_type == "FIXED DEPOSITS"),
				order_by: [desc: :inserted_at],
				select: au

			lastEndOfDays = Repo.all(query);
			startDate = nil;
			lastDateRan = nil;

			startDate = if Enum.count(lastEndOfDays)>0 do
				lastEndOfDay = Enum.at(lastEndOfDays, 0)
				startDate = lastEndOfDay.end_date
				startDate = DateTime.to_date(startDate)
				startDate = Date.add(startDate, 1)
				startDate
			else
				startDate = DateTime.utc_now
				startDate = DateTime.to_date(startDate)
				startDate
			end


			lastDateRan = if Enum.count(lastEndOfDays)>0 do
				lastEndOfDay = Enum.at(lastEndOfDays, 0)
				lastDateRan = lastEndOfDay.end_date
				lastDateRan = DateTime.to_date(lastDateRan)
				lastDateRan
			else
				lastDateRan = "Never Ran Previously"
			end

			endDate = nil;
			endDate = case Date.compare(startDate, Date.utc_today) do
				:lt ->
					IO.inspect "lt"
					endDate = nil
				:gt ->
					conn
					|> put_flash(:error, "You can not run an end-of-day at the moment. There are no fixed deposits to run end-of-day for")
					|> redirect(to: "/Savings/End-Of-Day-History")
				:eq ->
					IO.inspect "eq"
					endDate = nil;
			end

			startDateStr = Date.to_string(startDate);
			startDateStr

			IO.inspect startDateStr
			render(conn, "new.html", startDateStr: startDateStr, lastDateRan: lastDateRan)
		#end
	end

  def create(conn, params) do
    handleEndOfDayForFixedDepositsAccruedInterest(conn, params);
  end




	def handleEndOfDayForFixedDepositsAccruedInterest(conn, params) do
		IO.inspect "Create End Of Day"
		host = conn.host

		query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: cl.domain == ^host, select: cl
		clientTelco = Repo.one(query);

		query = from cl in LoanSavingsSystem.Client.Clients, where: cl.id == 1, select: cl
		client = Repo.one(query);

		type_str = "FIXED DEPOSITS"
		query = from au in LoanSavingsSystem.EndOfDay.EndOfDayRun,
			where: (au.end_of_day_type == "FIXED DEPOSITS"),
			order_by: [desc: :inserted_at],
			select: au

		lastEndOfDays = Repo.all(query);
		lastDateRan = nil;

		startDate = if Enum.count(lastEndOfDays)>0 do
			lastDateRan = Enum.at(lastEndOfDays, 0)
			lastDateRan = lastDateRan.end_date
			#lastDateRan = DateTime.to_date(lastDateRan)
			#startDate = Date.add(lastDateRan, 0)
			#startDate
			lastDateRan
		else
			nil
		end

		IO.inspect startDate



		eodDateStr = params["startdate"];
		eodDateStr = String.split(eodDateStr, "-");
		eodDateStrYr = Enum.at(eodDateStr, 2);
		eodDateStrMn = Enum.at(eodDateStr, 0);
		eodDateStrDd = Enum.at(eodDateStr, 1);
		#eodDateStr = eodDateStrYr <> "-" <> eodDateStrMn <> "-" <> eodDateStrDd
		eodDateStr = params["startdate"];
		#startdate = params["startdate"] <> "T00:00:00Z"
		currentDate = DateTime.utc_now;
		currentDate = DateTime.to_iso8601(currentDate)
		IO.inspect currentDate
		currentTime = String.slice(currentDate, 10, 9);
		startdate1 = params["startdate"] <> "#{currentTime}Z";	#T23:59:59Z



		startdate1 = case DateTime.from_iso8601(startdate1) do
		   {:ok, startdate1, 0} ->
			startdate1
		  {:error, :invalid_format} ->
			  nil
		end
		IO.inspect startdate1

		type_str = "FIXED DEPOSITS"

		isMatured = false
		isDivested = false

		fixedDepositsList = if(is_nil(startDate)) do
			query = from au in FixedDeposits,
				where: au.isMatured == type(^isMatured, :boolean),
				where: au.isDivested == type(^isDivested, :boolean),
				where: au.startDate <= (^startdate1),
				order_by: [desc: :inserted_at],
				select: au
			fixedDepositsList = Repo.all(query);
			fixedDepositsList
		else
			#startDate = case DateTime.from_iso8601(startDate) do
			#	{:ok, startDate, 0} ->
			#		startDate
			#	{:error, :invalid_format} ->
			#		nil
			#end
			IO.inspect startDate


			query = from au in FixedDeposits,
				where: au.isMatured == type(^isMatured, :boolean),
				where: au.isDivested == type(^isDivested, :boolean),
				where: au.startDate >= (^startDate),
				where: au.startDate <= (^startdate1),
				order_by: [desc: :inserted_at],
				select: au
			fixedDepositsList = Repo.all(query);
			fixedDepositsList
		end

		IO.inspect "fixedDepositsList";
		IO.inspect Enum.count(fixedDepositsList);
		IO.inspect (fixedDepositsList);






		divestmentsList = if(is_nil(startDate)) do
			query = from au in LoanSavingsSystem.Divestments.Divestment,
				where: au.divestmentDate <= (^startdate1),
				order_by: [desc: :inserted_at],
				select: au
			divestmentsList = Repo.all(query);
			divestmentsList
		else
			#startDate = case DateTime.from_iso8601(startDate) do
			#   {:ok, startDate, 0} ->
			#	startDate
			#  {:error, :invalid_format} ->
			#	  nil
			#end
			#IO.inspect startDate


			query = from au in LoanSavingsSystem.Divestments.Divestment,
				where: au.divestmentDate >= (^startDate),
				where: au.divestmentDate <= (^startdate1),
				order_by: [desc: :inserted_at],
				select: au
			divestmentsList = Repo.all(query);
			divestmentsList
		end
		IO.inspect "divestmentsList";
		IO.inspect Enum.count(divestmentsList);
		IO.inspect (divestmentsList);



		withdrawalList = if(is_nil(startDate)) do
			query = from au in LoanSavingsSystem.Withdrawals.MaturedWithdrawal,
				where: au.inserted_at <= (^startdate1),
				order_by: [desc: :inserted_at],
				select: au
			withdrawalList = Repo.all(query);
			withdrawalList
		else


			query = from au in LoanSavingsSystem.Withdrawals.MaturedWithdrawal,
				where: au.inserted_at >= (^startDate),
				where: au.inserted_at <= (^startdate1),
				order_by: [desc: :inserted_at],
				select: au
			withdrawalList = Repo.all(query);
			withdrawalList
		end
		IO.inspect "withdrawalList";
		IO.inspect Enum.count(withdrawalList);
		IO.inspect (withdrawalList);


		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_DEPOSIT" and cl.dr_cr == "DR", select: cl
		flexCubeConfigPrincipalDR = Repo.one(query);
		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_DEPOSIT" and cl.dr_cr == "CR", select: cl
		flexCubeConfigPrincipalCR = Repo.one(query);

		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_DEPOSIT" and cl.dr_cr == "DR", select: cl
		flexCubeConfigInterestDR = Repo.one(query);
		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_DEPOSIT" and cl.dr_cr == "CR", select: cl
		flexCubeConfigInterestCR = Repo.one(query);

		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "DEPOSIT_CHARGE" and cl.dr_cr == "DR", select: cl
		flexCubeConfigChargeDR = Repo.one(query);
		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "DEPOSIT_CHARGE" and cl.dr_cr == "CR", select: cl
		flexCubeConfigChargeCR = Repo.one(query);

		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_DIVESTMENT" and cl.dr_cr == "DR", select: cl
		flexCubeConfigDivestPrincipalDR = Repo.one(query);
		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_DIVESTMENT" and cl.dr_cr == "CR", select: cl
		flexCubeConfigDivestPrincipalCR = Repo.one(query);

		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_DIVESTMENT" and cl.dr_cr == "DR", select: cl
		flexCubeConfigDivestInterestDR = Repo.one(query);
		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_DIVESTMENT" and cl.dr_cr == "CR", select: cl
		flexCubeConfigDivestInterestCR = Repo.one(query);

		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_WITHDRAWAL" and cl.dr_cr == "DR", select: cl
		flexCubeConfigWithdrawPrincipalDR = Repo.one(query);
		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_WITHDRAWAL" and cl.dr_cr == "CR", select: cl
		flexCubeConfigWithdrawPrincipalCR = Repo.one(query);

		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_WITHDRAWAL" and cl.dr_cr == "DR", select: cl
		flexCubeConfigWithdrawInterestDR = Repo.one(query);
		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_WITHDRAWAL" and cl.dr_cr == "CR", select: cl
		flexCubeConfigWithdrawInterestCR = Repo.one(query);

		if (Enum.count(fixedDepositsList)==0) do

			IO.inspect "::::::::::::::::::::::::::::::::::::"
			IO.inspect "No new Fixed Deposits"

			#conn
			#	|> put_flash(:info, "You can not run an end-of-day at the moment. There are no fixed deposits or divestments to run end-of-day for")
			#	|> redirect(to: Routes.loan_path(conn, :fixed_deps))

			#There are no new fixed deposits so handle for all fixed deposits
			query = from au in FixedDeposits,
				where: au.isMatured == type(^isMatured, :boolean),
				where: au.isDivested == type(^isDivested, :boolean),
				order_by: [desc: :inserted_at],
				select: au
			fixedDepositsList = Repo.all(query);
			fdPrincipalTotal = 0.00;
			fdChargeTotal = 0.00;


			fdInterestTotal = if(Enum.count(fixedDepositsList)>0) do
				fdInterestTotal = for x <- 0..(Enum.count(fixedDepositsList)-1) do
					fixedDeposit = Enum.at(fixedDepositsList, x);
					default_period = 1


					endDate = nil;
					endDate = case DateTime.compare(fixedDeposit.endDate, (startdate1)) do
						:lt ->
							IO.inspect "lt"
							endDate = nil;
						:gt ->
							IO.inspect "gt"
							endDate = startdate1
						:eq ->
							IO.inspect "eq"
							endDate = startdate1;
					end


					fdStartDateFrom = if is_nil(fixedDeposit.lastEndOfDayDate) do
						startDate = if(is_nil(startDate)) do
							fixedDeposit.startDate
						else
							startDate
						end
					else
						fixedDeposit.lastEndOfDayDate
					end




					days = if(is_nil(endDate)) do

						query = from au in LoanSavingsSystem.EndOfDay.EndOfDayEntry,
							where: au.fixed_deposit_id == type(^fixedDeposit.id, :integer),
							select: sum(au.accrual_period)
						allEndOfDayEntry = Repo.one(query);
						IO.inspect allEndOfDayEntry
						days = if(is_nil(allEndOfDayEntry)) do
							days = fixedDeposit.fixedPeriod - 0;
							days
						else
							days = fixedDeposit.fixedPeriod - allEndOfDayEntry;
							days
						end

						days
					else
						daysSeconds = DateTime.diff(endDate, fdStartDateFrom)
						days = daysSeconds / (24*60*60);
						IO.inspect "days----"
						IO.inspect days
						days = trunc(days);
						IO.inspect "days"
						IO.inspect days
						days
					end


					fdPrincipal = fixedDeposit.principalAmount;
					default_rate = fixedDeposit.interestRate
					annual_period = fixedDeposit.yearLengthInDays
					interestType = fixedDeposit.interestRateType
					interestMode = fixedDeposit.productInterestMode
					periodType = fixedDeposit.fixedPeriodType
					currencyId = fixedDeposit.currencyId
					currencyName = fixedDeposit.currency



					totalRepaymentInPeriod = if(is_nil(endDate)) do

						query = from au in LoanSavingsSystem.EndOfDay.EndOfDayEntry,
							where: au.fixed_deposit_id == type(^fixedDeposit.id, :integer),
							select: sum(au.interest_accrued)
						totalInterestAccruedSoFar = Repo.one(query);
						IO.inspect totalInterestAccruedSoFar
						IO.inspect fixedDeposit.expectedInterest
						totalRepaymentInPeriod = if(is_nil(totalInterestAccruedSoFar)) do
							totalRepaymentInPeriod = fixedDeposit.expectedInterest - 0.00;
							totalRepaymentInPeriod
						else
							totalRepaymentInPeriod = fixedDeposit.expectedInterest - totalInterestAccruedSoFar;
							totalRepaymentInPeriod
						end
						IO.inspect totalRepaymentInPeriod
						totalRepaymentInPeriod
					else
						totalRepaymentInPeriod = LoanSavingsSystemWeb.UssdController.calculate_maturity_repayments(fdPrincipal, days, default_rate, annual_period, interestMode, interestType, periodType)
						totalRepaymentInPeriod = totalRepaymentInPeriod - fdPrincipal;
						totalRepaymentInPeriod
					end
					totalRepaymentInPeriod
				end



				IO.inspect "....fdInterestTotal"
				IO.inspect fdInterestTotal
				fdInterestTotal = Enum.sum(fdInterestTotal);
				IO.inspect fdInterestTotal
				fdInterestTotal = Decimal.round(Decimal.from_float(fdInterestTotal), 2)
				fdInterestTotal
			else
				fdInterestTotal = Decimal.round(Decimal.from_float(0.00), 2);
				fdInterestTotal
			end







			divestmentPrincipalTotal = 0.00;
			divestmentInterestTotal = 0.00;

			divestmentPrincipalTotal = if(Enum.count(divestmentsList)>0) do
				divestmentPrincipalTotal = for x <- 0..(Enum.count(divestmentsList)-1) do
					divestment = Enum.at(divestmentsList, x);
					divestmentPrincipalTotal = divestment.principalAmount;
					divestmentPrincipalTotal
				end
				divestmentPrincipalTotal = Enum.sum(divestmentPrincipalTotal);
				divestmentPrincipalTotal
			else
				divestmentPrincipalTotal = 0.00;
				divestmentPrincipalTotal
			end

			divestmentInterestTotal = if(Enum.count(divestmentsList)>0) do
				divestmentInterestTotal = for x <- 0..(Enum.count(divestmentsList)-1) do
					divestment = Enum.at(divestmentsList, x);
					divestmentInterestTotal = divestment.interestAccrued;
					divestmentInterestTotal
				end
				divestmentInterestTotal = Enum.sum(divestmentInterestTotal);
				divestmentInterestTotal;
			else
				divestmentInterestTotal = 0.00;
				divestmentInterestTotal
			end



			withdrawPrincipalTotal = 0.00;
			withdrawInterestTotal = 0.00;

			withdrawPrincipalTotal = if(Enum.count(withdrawalList)>0) do
				withdrawPrincipalTotal = for x <- 0..(Enum.count(withdrawalList)-1) do
					withdrawal = Enum.at(withdrawalList, x);
					withdrawPrincipalTotal = withdrawal.principalAmount;
					withdrawPrincipalTotal
				end
				withdrawPrincipalTotal = Enum.sum(withdrawPrincipalTotal);
				withdrawPrincipalTotal
			else
				withdrawPrincipalTotal=0.00;
				withdrawPrincipalTotal
			end

			withdrawInterestTotal = if(Enum.count(withdrawalList)>0) do
				withdrawInterestTotal = for x <- 0..(Enum.count(withdrawalList)-1) do
					withdrawal = Enum.at(withdrawalList, x);
					withdrawInterestTotal = withdrawal.interestAccrued;
					withdrawInterestTotal
				end
				withdrawInterestTotal = Enum.sum(withdrawInterestTotal);
				withdrawInterestTotal;
			else
				withdrawInterestTotal=0.00;
				withdrawInterestTotal
			end





			IO.inspect fdInterestTotal;
			date_ran = DateTime.utc_now() |> DateTime.truncate(:second)
			#total_interest_accrued = Decimal.to_float(fdInterestTotal);
			total_interest_accrued = Decimal.to_float(fdInterestTotal);
			#total_interest_accrued = fdInterestTotal;
			penalties_incurred = 0.00;
			end_of_day_type = "FIXED DEPOSITS";
			start_date = startDate;
			end_date = startdate1;
			status = "VALID";
			currencyId = client.defaultCurrencyId;
			currencyName = client.defaultCurrencyName;
			total_principal_deposited = fdPrincipalTotal;







			proceed = true;
			if(!is_nil(flexCubeConfigPrincipalDR) && !is_nil(flexCubeConfigPrincipalCR)
				&& !is_nil(flexCubeConfigInterestDR) && !is_nil(flexCubeConfigInterestCR)
				&& !is_nil(flexCubeConfigChargeDR) && !is_nil(flexCubeConfigChargeCR)
				&& !is_nil(flexCubeConfigDivestPrincipalDR) && !is_nil(flexCubeConfigDivestPrincipalCR)
				&& !is_nil(flexCubeConfigDivestInterestDR) && !is_nil(flexCubeConfigDivestInterestCR)
				&& !is_nil(flexCubeConfigWithdrawPrincipalDR) && !is_nil(flexCubeConfigWithdrawPrincipalCR)
				&& !is_nil(flexCubeConfigWithdrawInterestDR) && !is_nil(flexCubeConfigWithdrawInterestCR)) do

				IO.inspect [0, proceed, fdPrincipalTotal]
				proceed = if(fdPrincipalTotal>0) do
					uniqueMessageId = String.upcase(randomizer(25));
					IO.inspect uniqueMessageId
					#POST TO FLXCB INTEREST
					#fdInterestTotalFormatted = Decimal.to_string((fdInterestTotal), :normal)
					fdInterestTotalFormatted = :erlang.float_to_binary((fdInterestTotal), [{:decimals, client.defaultCurrencyDecimals}])
					proceed = handlePostToFCube(uniqueMessageId, flexCubeConfigInterestDR.flex_cube_gl_code, flexCubeConfigInterestCR.flex_cube_gl_code, eodDateStr, fdInterestTotalFormatted, "FIXED_DEPOSIT_INTEREST", "Interest on Fixed Deposit - ZIPAKE")
					IO.inspect [proceed]

					proceed
				else
					proceed
				end



				IO.inspect [1, proceed, divestmentPrincipalTotal]
				proceed = if(divestmentPrincipalTotal>0) do
					uniqueMessageId = String.upcase(randomizer(25));
					IO.inspect uniqueMessageId
					#POST TO FLXCB CHARGE
					#divestmentPrincipalTotalFormatted = Decimal.to_string((divestmentPrincipalTotal), :normal)
					divestmentPrincipalTotalFormatted = :erlang.float_to_binary((divestmentPrincipalTotal), [{:decimals, client.defaultCurrencyDecimals}])
					proceed = handlePostToFCube(uniqueMessageId, flexCubeConfigDivestPrincipalDR.flex_cube_gl_code, flexCubeConfigDivestPrincipalDR.flex_cube_gl_code, eodDateStr, divestmentPrincipalTotalFormatted, "DIVESTMENT_PRINCIPAL", "Principal on Divestment - ZIPAKE")
					IO.inspect [proceed]

					proceed
				else
					proceed
				end


				IO.inspect [2, proceed, divestmentInterestTotal]

				proceed = if(divestmentInterestTotal>0) do
					uniqueMessageId = String.upcase(randomizer(25));
					IO.inspect uniqueMessageId
					#POST TO FLXCB CHARGE
					#divestmentInterestTotalFormatted = Decimal.to_string((divestmentInterestTotal), :normal)
					divestmentInterestTotalFormatted = :erlang.float_to_binary((divestmentInterestTotal), [{:decimals, client.defaultCurrencyDecimals}])
					proceed = handlePostToFCube(uniqueMessageId, flexCubeConfigDivestInterestDR.flex_cube_gl_code, flexCubeConfigDivestInterestCR.flex_cube_gl_code, eodDateStr, divestmentInterestTotalFormatted, "DIVESTMENT_INTEREST", "Interest on Divestment - ZIPAKE")
					IO.inspect [4, proceed]
					proceed
				else
					proceed
				end

				IO.inspect [3, proceed, withdrawPrincipalTotal]
				proceed = if(withdrawPrincipalTotal>0) do
					uniqueMessageId = String.upcase(randomizer(25));
					IO.inspect uniqueMessageId
					#POST TO FLXCB CHARGE
					#withdrawPrincipalTotalFormatted = Decimal.to_string((withdrawPrincipalTotal), :normal)
					withdrawPrincipalTotalFormatted = :erlang.float_to_binary((withdrawPrincipalTotal), [{:decimals, client.defaultCurrencyDecimals}])
					proceed = handlePostToFCube(uniqueMessageId, flexCubeConfigWithdrawPrincipalDR.flex_cube_gl_code, flexCubeConfigWithdrawPrincipalCR.flex_cube_gl_code, eodDateStr, withdrawPrincipalTotalFormatted, "WITHDRAWAL_INTEREST", "Principal on Withdrawal - ZIPAKE")
					IO.inspect [5, proceed]
					proceed
				else
					proceed
				end


				IO.inspect [4, proceed, withdrawInterestTotal]
				proceed = if(withdrawInterestTotal>0) do
					uniqueMessageId = String.upcase(randomizer(25));
					IO.inspect uniqueMessageId
					#POST TO FLXCB CHARGE
					#withdrawInterestTotalFormatted = Decimal.to_string((withdrawInterestTotal), :normal)
					withdrawInterestTotalFormatted = :erlang.float_to_binary((withdrawInterestTotal), [{:decimals, client.defaultCurrencyDecimals}])
					proceed = handlePostToFCube(uniqueMessageId, flexCubeConfigWithdrawInterestDR.flex_cube_gl_code, flexCubeConfigWithdrawInterestCR.flex_cube_gl_code, eodDateStr, withdrawInterestTotalFormatted, "WITHDRAWAL_INTEREST", "Interest on Withdrawal - ZIPAKE")
					IO.inspect [6, proceed]
					proceed
				else
					proceed
				end


				IO.inspect [7, proceed]
				endOfDayRun = %LoanSavingsSystem.EndOfDay.EndOfDayRun{date_ran: date_ran, total_interest_accrued: total_interest_accrued, penalties_incurred: penalties_incurred, end_of_day_type: end_of_day_type,
					start_date: start_date, end_date: end_date, status: status, currencyId: currencyId, currencyName: currencyName, total_principal_deposited: total_principal_deposited,
					total_charge_deposit: fdChargeTotal, divestment_principal_total: divestmentPrincipalTotal, divestment_interest_total: divestmentInterestTotal
				}
				endOfDayRun = case Repo.insert(endOfDayRun) do
					{:ok, endOfDayRun} ->
						if(Enum.count(fixedDepositsList)>0) do
							for x <- 0..(Enum.count(fixedDepositsList)-1) do
								fd = Enum.at(fixedDepositsList, x);
								fd = Repo.get!(LoanSavingsSystem.FixedDeposit.FixedDeposits, fd.id)
								IO.inspect (fd);

								fdPrincipal = fd.principalAmount;
								IO.inspect (fdPrincipal);
								fdRate = fd.interestRate;
								fdAnnualPeriod = fd.yearLengthInDays;
								fdIterestMode = fd.productInterestMode;
								fdInterestType = fd.interestRateType;
								fdPeriodType = fd.fixedPeriodType;



								accrualStartDate = nil;
								#accrualStartDate = if(!is_nil(endOfDayRun.start_date)) do
								#	accrualStartDate = case DateTime.compare(fd.startDate, endOfDayRun.start_date) do
								#		:lt ->
								#			IO.inspect "lt"
								#			accrualStartDate = endOfDayRun.start_date
								#		:gt ->
								#			IO.inspect "gt"
								#			accrualStartDate = fd.startDate
								#		:eq ->
								#			IO.inspect "eq"
								#			accrualStartDate = fd.startDate;
								#	end
								#	accrualStartDate
								#else
								#	accrualStartDate = fd.startDate
								#	accrualStartDate
								#end

								accrualStartDate = if is_nil(fd.lastEndOfDayDate) do
									accrualStartDate = if(!is_nil(endOfDayRun.start_date)) do
										accrualStartDate = case DateTime.compare(fd.startDate, endOfDayRun.start_date) do
											:lt ->
												IO.inspect "lt"
												accrualStartDate = endOfDayRun.start_date
											:gt ->
												IO.inspect "gt"
												accrualStartDate = fd.startDate
											:eq ->
												IO.inspect "eq"
												accrualStartDate = fd.startDate;
										end
										accrualStartDate
									else
										accrualStartDate = fd.startDate
										accrualStartDate
									end

									accrualStartDate
								else
									fd.lastEndOfDayDate
								end








								accrualEndDate = nil;
								accrualEndDate = case DateTime.compare(fd.endDate, (startdate1)) do
									:lt ->
										IO.inspect "lt"
										accrualEndDate = nil
									:gt ->
										IO.inspect "gt"
										accrualEndDate = startdate1
									:eq ->
										IO.inspect "eq"
										accrualEndDate = startdate1;
								end




								accrualDays = if(is_nil(accrualEndDate)) do

									query = from au in LoanSavingsSystem.EndOfDay.EndOfDayEntry,
										where: au.fixed_deposit_id == type(^fd.id, :integer),
										select: sum(au.accrual_period)
									allEndOfDayEntry = Repo.one(query);
									IO.inspect allEndOfDayEntry
									accrualDays = if(is_nil(allEndOfDayEntry)) do
										accrualDays = fd.fixedPeriod - 0;
										accrualDays
									else
										accrualDays = fd.fixedPeriod - allEndOfDayEntry;
										accrualDays
									end
								else
									IO.inspect [accrualEndDate, accrualStartDate];
									accrualDays = DateTime.diff(accrualEndDate, accrualStartDate)
									accrualDays = accrualDays / (24*60*60)
									accrualDays = trunc(accrualDays);
									accrualDays
								end


								actualAccrualEndDate = DateTime.add(accrualStartDate, (accrualDays*24*60*60), :second) |> DateTime.truncate(:second)



								totalFdInterest = if(is_nil(accrualEndDate)) do

									query = from au in LoanSavingsSystem.EndOfDay.EndOfDayEntry,
										where: au.fixed_deposit_id == type(^fd.id, :integer),
										select: sum(au.interest_accrued)
									totalInterestAccruedSoFar = Repo.one(query);
									IO.inspect totalInterestAccruedSoFar

									totalFdInterest = if(is_nil(totalInterestAccruedSoFar)) do
										totalFdInterest = fd.expectedInterest - 0.00;
										totalFdInterest
									else
										totalFdInterest = fd.expectedInterest - totalInterestAccruedSoFar;
										totalFdInterest
									end
									totalFdInterest = Decimal.round(Decimal.from_float(totalFdInterest), 2)
									totalFdInterest
								else
									totalFdWithInterest = LoanSavingsSystemWeb.UssdController.calculate_maturity_repayments(fdPrincipal, accrualDays, fdRate, fdAnnualPeriod, fdIterestMode, fdInterestType, fdPeriodType)
									totalFdInterest = totalFdWithInterest - fdPrincipal;
									totalFdInterest = Decimal.round(Decimal.from_float(totalFdInterest), 2)

									IO.inspect [totalFdWithInterest,  fdPrincipal, totalFdInterest]
									totalFdInterest
								end



								fdId = fd.id;
								tempAccruedInterest = Decimal.add(Decimal.from_float(fd.accruedInterest), totalFdInterest);
								tempAccruedInterest = Decimal.to_float(tempAccruedInterest);
								isMatured = if(tempAccruedInterest==fd.expectedInterest) do
									isMatured = true;
									isMatured
								else
									isMatured = fd.isMatured
									isMatured
								end


								fixedDepositStatus = if(tempAccruedInterest==fd.expectedInterest) do
									fixedDepositStatus = "MATURED";
									fixedDepositStatus
								else
									fixedDepositStatus = fd.fixedDepositStatus
									fixedDepositStatus
								end

								fdUserId = fd.userId
								fdIdStr = "#{fd.id}";
								currency = fd.currency;
								principalFormatted = Decimal.round(Decimal.from_float(fd.principalAmount), 2)

								fd = LoanSavingsSystem.FixedDeposit.FixedDeposits.changeset(fd,
									%{
										accountId: fd.accountId, productId: fd.productId, principalAmount: fd.principalAmount, fixedPeriod: fd.fixedPeriod, fixedPeriodType: fd.fixedPeriodType,
										interestRate: fd.interestRate, interestRateType: fd.interestRateType, expectedInterest: fd.expectedInterest, accruedInterest: tempAccruedInterest,
										isMatured: isMatured, isDivested: fd.isDivested, divestmentPackageId: fd.divestmentPackageId, currencyId: fd.currencyId,
										currency: fd.currency, currencyDecimals: fd.currencyDecimals, yearLengthInDays: fd.yearLengthInDays, totalDepositCharge: fd.totalDepositCharge,
										totalWithdrawalCharge: fd.totalWithdrawalCharge, totalPenalties: fd.totalPenalties, userRoleId: fd.userRoleId, userId: fd.userId,
										totalAmountPaidOut: fd.totalAmountPaidOut, startDate: fd.startDate, endDate: fd.endDate, clientId: fd.clientId, divestmentId: fd.divestmentId,
										productInterestMode: fd.productInterestMode, branchId: fd.branchId,
										divestedInterestRate: fd.divestedInterestRate, divestedInterestRateType: fd.divestedInterestRateType,
										amountDivested: fd.amountDivested, divestedInterestAmount: fd.divestedInterestAmount, divestedPeriod: fd.divestedPeriod,
										lastEndOfDayDate: actualAccrualEndDate, fixedDepositStatus: fixedDepositStatus
									})
								Repo.update!(fd);

								endOfDayEntry = %LoanSavingsSystem.EndOfDay.EndOfDayEntry{
									end_of_day_id: endOfDayRun.id,
									interest_accrued: Decimal.to_float(totalFdInterest),
									penalties_incurred: 0.00,
									fixed_deposit_id: fdId,
									status: "ACCRUED",
									currencyId: currencyId,
									currencyName: currencyName,
									end_of_day_date: date_ran,
									accrual_start_date: accrualStartDate,
									accrual_end_date: actualAccrualEndDate,
									accrual_period: accrualDays,
								}
								endOfDayEntry = Repo.insert!(endOfDayEntry);


								if(isMatured==true) do
									query = from au in LoanSavingsSystem.Accounts.User, where: au.id == ^fdUserId, select: au
									appUser = Repo.one(query)



									query = from au in LoanSavingsSystem.Client.UserBioData, where: au.userId == ^appUser.id, select: au
									userBioData = Repo.one(query)


									idLen = String.length(fdIdStr);
									fixedDepositNumber = String.pad_leading(fdIdStr, (6 - idLen), "0");
									principalFormatted = Decimal.to_string((principalFormatted), :normal)


									totalFundsDueFormatted = Decimal.round(Decimal.from_float(tempAccruedInterest), 2)
									totalFundsDueFormatted = Decimal.to_string((totalFundsDueFormatted), :normal)

									naive_datetime = Timex.now
									#mobile: appUser.username,
									sms = %{
										mobile: userBioData.mobileNumber,
										msg: "Dear #{userBioData.firstName},\nYour fixed deposit ##{fixedDepositNumber} of #{currency}" <> principalFormatted <> " is matured and due for withdrawal.\nTotal funds due is #{currency}" <> totalFundsDueFormatted <> "\nPlease dial *254*540# to withdraw your funds.",
										status: "READY",
										type: "SMS",
										msg_count: "1",
										date_sent: naive_datetime
									}
									Sms.changeset(%Sms{}, sms)
									|> Repo.insert()
								end
							end



							conn
							|> put_flash(:success, "End of Day was run successfully")
							|> redirect(to: "/Savings/End-Of-Day-History")
						else

							conn
							|> put_flash(:success, "End of Day was run successfully")
							|> redirect(to: "/Savings/End-Of-Day-History")
						end
					{:error, changeset} ->
						Logger.info("Fail")
						conn
						|> put_flash(:success, "End of Day was not run successfully. Kindly report this issue")
						|> redirect(to: "/Savings/End-Of-Day-History")
				end

				proceed
			else

				conn
				|> put_flash(:success, "End of Day was not run successfully. Configurations for End of Day is not complete")
				|> redirect(to: "/Savings/End-Of-Day-History")
			end


		else

			IO.inspect "::::::::::::::::::::::::::::::::::::"
			IO.inspect "New Fixed Deposits Exist"


			query = from au in FixedDeposits,
				where: au.isMatured == type(^isMatured, :boolean),
				where: au.isDivested == type(^isDivested, :boolean),
				order_by: [desc: :inserted_at],
				select: au
			fixedDepositsList = Repo.all(query);



			fdPrincipalTotal = for x <- 0..(Enum.count(fixedDepositsList)-1) do
				fixedDeposit = Enum.at(fixedDepositsList, x);
				fdPrincipal = if (is_nil(fixedDeposit.lastEndOfDayDate)) do
					fdPrincipal = case DateTime.compare(fixedDeposit.startDate, (startdate1)) do
						:lt ->
							IO.inspect "lt"
							fdPrincipal = fixedDeposit.principalAmount;
						:gt ->
							IO.inspect "gt"
							fdPrincipal = 0.00
						:eq ->
							IO.inspect "eq"
							fdPrincipal = fixedDeposit.principalAmount;
					end

					fdPrincipal
				else
					fdPrincipal = 0.00;
				end
			end

			fdPrincipalTotal = Enum.sum(fdPrincipalTotal);
			fdPrincipalTotal = Decimal.round(Decimal.from_float(fdPrincipalTotal), 2)



			fdInterestTotal = for x <- 0..(Enum.count(fixedDepositsList)-1) do
				fixedDeposit = Enum.at(fixedDepositsList, x);
				default_period = 1


				endDate = nil;
				endDate = case DateTime.compare(fixedDeposit.endDate, (startdate1)) do
					:lt ->
						IO.inspect "lt"
						#endDate = nil;
						endDate = fixedDeposit.endDate;
					:gt ->
						IO.inspect "gt"
						endDate = startdate1
					:eq ->
						IO.inspect "eq"
						endDate = startdate1;
				end

				fdStartDateFrom = if is_nil(fixedDeposit.lastEndOfDayDate) do
					fixedDeposit.startDate
				else
					fixedDeposit.lastEndOfDayDate
				end

				IO.inspect [fixedDeposit.endDate, (startdate1), endDate]

				days = if(is_nil(endDate)) do

					query = from au in LoanSavingsSystem.EndOfDay.EndOfDayEntry,
						where: au.fixed_deposit_id == type(^fixedDeposit.id, :integer),
						select: sum(au.accrual_period)
					allEndOfDayEntry = Repo.one(query);
					IO.inspect allEndOfDayEntry
					days = if(is_nil(allEndOfDayEntry)) do
						days = fixedDeposit.fixedPeriod - 0;
						days
					else
						days = fixedDeposit.fixedPeriod - allEndOfDayEntry;
						days
					end

					days

				else
					IO.inspect [endDate, fdStartDateFrom]
					daysSeconds = DateTime.diff(endDate, fdStartDateFrom)
					days = daysSeconds / (24*60*60);
					IO.inspect "days----"
					IO.inspect days
					days = trunc(days);
					IO.inspect "days"
					IO.inspect days
					days
				end







				fdPrincipal = fixedDeposit.principalAmount;
				default_rate = fixedDeposit.interestRate
				annual_period = fixedDeposit.yearLengthInDays
				interestType = fixedDeposit.interestRateType
				interestMode = fixedDeposit.productInterestMode
				periodType = fixedDeposit.fixedPeriodType
				currencyId = fixedDeposit.currencyId
				currencyName = fixedDeposit.currency

				totalRepaymentInPeriod = if(is_nil(endDate)) do

					query = from au in LoanSavingsSystem.EndOfDay.EndOfDayEntry,
						where: au.fixed_deposit_id == type(^fixedDeposit.id, :integer),
						select: sum(au.interest_accrued)
					totalInterestAccruedSoFar = Repo.one(query);
					IO.inspect totalInterestAccruedSoFar
					#totalRepaymentInPeriod = fixedDeposit.expectedInterest - totalInterestAccruedSoFar;
					#totalRepaymentInPeriod

					totalRepaymentInPeriod = if(is_nil(totalInterestAccruedSoFar)) do
						totalRepaymentInPeriod = fixedDeposit.expectedInterest - 0.00;
						totalRepaymentInPeriod
					else
						totalRepaymentInPeriod = fixedDeposit.expectedInterest - totalInterestAccruedSoFar;
						totalRepaymentInPeriod
					end
				else
					totalRepaymentInPeriod = LoanSavingsSystemWeb.UssdController.calculate_maturity_repayments(fdPrincipal, days, default_rate, annual_period, interestMode, interestType, periodType)
					totalRepaymentInPeriod = totalRepaymentInPeriod - fdPrincipal;
					totalRepaymentInPeriod
				end
				totalRepaymentInPeriod
			end

			fdInterestTotal = Enum.sum(fdInterestTotal);
			fdInterestTotal = Decimal.round(Decimal.from_float(fdInterestTotal), 2)



			fdChargeTotal = for x <- 0..(Enum.count(fixedDepositsList)-1) do
				fixedDeposit = Enum.at(fixedDepositsList, x);
				fdChargeTotal = fixedDeposit.totalDepositCharge;
				fdChargeTotal
			end

			fdChargeTotal = Enum.sum(fdChargeTotal);
			fdChargeTotal = Decimal.from_float(fdChargeTotal);

			divestmentPrincipalTotal = 0.00;
			divestmentInterestTotal = 0.00;

			divestmentPrincipalTotal = if(Enum.count(divestmentsList)>0) do
				divestmentPrincipalTotal = for x <- 0..(Enum.count(divestmentsList)-1) do
					divestment = Enum.at(divestmentsList, x);
					divestmentPrincipalTotal = divestment.principalAmount;
					divestmentPrincipalTotal
				end
				divestmentPrincipalTotal = Enum.sum(divestmentPrincipalTotal);
				divestmentPrincipalTotal = Decimal.round(Decimal.new(divestmentPrincipalTotal), 2)
				divestmentPrincipalTotal
			else
				divestmentPrincipalTotal = 0.00
				# divestmentPrincipalTotal = Decimal.round(Decimal.new(divestmentPrincipalTotal), 2)
				divestmentPrincipalTotal = divestmentPrincipalTotal
				divestmentPrincipalTotal
			end
			IO.inspect "divestmentPrincipalTotal"
			IO.inspect divestmentPrincipalTotal


			divestmentInterestTotal = if(Enum.count(divestmentsList)>0) do
				divestmentInterestTotal = for x <- 0..(Enum.count(divestmentsList)-1) do
					divestment = Enum.at(divestmentsList, x);
					divestmentInterestTotal = divestment.interestAccrued;
					divestmentInterestTotal
				end
				divestmentInterestTotal = Enum.sum(divestmentInterestTotal);
				divestmentInterestTotal = Decimal.round(Decimal.new(divestmentInterestTotal), 2);
				divestmentInterestTotal
			else
				divestmentInterestTotal = 0.00;
				# divestmentInterestTotal = Decimal.round(Decimal.new(divestmentInterestTotal), 2)
				divestmentInterestTotal = divestmentInterestTotal
				divestmentInterestTotal
			end






			date_ran = DateTime.utc_now() |> DateTime.truncate(:second)
			total_interest_accrued = fdInterestTotal;
			penalties_incurred = 0.00;
			end_of_day_type = "FIXED DEPOSITS";
			start_date = startDate;
			end_date = startdate1;
			status = "VALID";
			currencyId = Enum.at(fixedDepositsList, 0).currencyId;
			currencyName = Enum.at(fixedDepositsList, 0).currency;
			total_principal_deposited = fdPrincipalTotal;







			if(!is_nil(flexCubeConfigPrincipalDR) && !is_nil(flexCubeConfigPrincipalCR)
				&& !is_nil(flexCubeConfigInterestDR) && !is_nil(flexCubeConfigInterestCR)
				&& !is_nil(flexCubeConfigChargeDR) && !is_nil(flexCubeConfigChargeCR)
				&& !is_nil(flexCubeConfigDivestPrincipalDR) && !is_nil(flexCubeConfigDivestPrincipalCR)
				&& !is_nil(flexCubeConfigDivestInterestDR) && !is_nil(flexCubeConfigDivestInterestCR)) do

				proceed = true;
				proceed = if(proceed==true && fdPrincipalTotal>0) do
					uniqueMessageId = String.upcase(randomizer(25));
					IO.inspect uniqueMessageId
					#POST TO FLXCB PRINCIPAL
					#fdPrincipalTotalFormatted = Decimal.to_string((fdPrincipalTotal), :normal)
					fdPrincipalTotalFormatted = Decimal.to_float(fdPrincipalTotal);
					fdPrincipalTotalFormatted = :erlang.float_to_binary((fdPrincipalTotalFormatted), [{:decimals, client.defaultCurrencyDecimals}]);
					proceed = handlePostToFCube(uniqueMessageId, flexCubeConfigPrincipalDR.flex_cube_gl_code, flexCubeConfigPrincipalCR.flex_cube_gl_code, eodDateStr, fdPrincipalTotalFormatted, "FIXED_DEPOSIT_PRINCIPAL", "Principal on Fixed Deposit - ZIPAKE")


					IO.inspect [0, proceed, fdInterestTotal]

					proceed
				else
					proceed
				end

				proceed = if(fdInterestTotal>0) do
					uniqueMessageId = String.upcase(randomizer(25));
					IO.inspect uniqueMessageId
					#POST TO FLXCB INTEREST
					#fdInterestTotalFormatted = Decimal.to_string((fdInterestTotal), :normal)

					fdInterestTotalFormatted = Decimal.to_float(fdInterestTotal);
					fdInterestTotalFormatted = :erlang.float_to_binary((fdInterestTotalFormatted), [{:decimals, client.defaultCurrencyDecimals}]);
					proceed = handlePostToFCube(uniqueMessageId, flexCubeConfigInterestDR.flex_cube_gl_code, flexCubeConfigInterestCR.flex_cube_gl_code, eodDateStr, fdInterestTotalFormatted, "FIXED_DEPOSIT_INTEREST", "Interest on Fixed Deposit - ZIPAKE")

					IO.inspect [1, proceed, fdChargeTotal]

					proceed
				else
					proceed
				end


				proceed = if(fdChargeTotal>0) do
					uniqueMessageId = String.upcase(randomizer(25));
					IO.inspect uniqueMessageId
					#POST TO FLXCB CHARGE
					#fdChargeTotalFormatted = Decimal.to_string((fdChargeTotal), :normal)

					fdChargeTotalFormatted = Decimal.to_float(fdChargeTotal);
					fdChargeTotalFormatted = :erlang.float_to_binary((fdChargeTotalFormatted), [{:decimals, client.defaultCurrencyDecimals}]);
					proceed = handlePostToFCube(uniqueMessageId, flexCubeConfigChargeDR.flex_cube_gl_code, flexCubeConfigChargeCR.flex_cube_gl_code, eodDateStr, fdChargeTotalFormatted, "FIXED_DEPOSIT_CHARGE", "Charge on Fixed Deposit - ZIPAKE")
				else
					proceed
				end
				proceed



				IO.inspect [2, proceed, divestmentPrincipalTotal]

				proceed = if(!is_nil(divestmentPrincipalTotal) && divestmentPrincipalTotal>0) do
					uniqueMessageId = String.upcase(randomizer(25));
					IO.inspect uniqueMessageId
					#POST TO FLXCB DIVESTMENT PRINCIPAL
					#divestmentPrincipalTotalFormatted = Decimal.to_string((divestmentPrincipalTotal), :normal)

					divestmentPrincipalTotalFormatted = Decimal.to_float(divestmentPrincipalTotal);
					divestmentPrincipalTotalFormatted = :erlang.float_to_binary((divestmentPrincipalTotalFormatted), [{:decimals, client.defaultCurrencyDecimals}]);
					proceed = handlePostToFCube(uniqueMessageId, flexCubeConfigDivestPrincipalDR.flex_cube_gl_code, flexCubeConfigDivestPrincipalDR.flex_cube_gl_code, eodDateStr, divestmentPrincipalTotalFormatted, "DIVESTMENT_PRINCIPAL", "Principal on Divestment - ZIPAKE")

					IO.inspect [3, proceed, divestmentInterestTotal]

					proceed
				else
					proceed
				end

				proceed = if(!is_nil(divestmentInterestTotal) && divestmentInterestTotal>0) do
					uniqueMessageId = String.upcase(randomizer(25));
					IO.inspect uniqueMessageId
					#POST TO DIVESTMENT INTEREST
					#divestmentInterestTotalFormatted = Decimal.to_string((divestmentInterestTotal), :normal)

					divestmentInterestTotalFormatted = Decimal.to_float(divestmentInterestTotal);
					divestmentInterestTotalFormatted = :erlang.float_to_binary((divestmentInterestTotalFormatted), [{:decimals, client.defaultCurrencyDecimals}]);
					proceed = handlePostToFCube(uniqueMessageId, flexCubeConfigDivestInterestDR.flex_cube_gl_code, flexCubeConfigDivestInterestCR.flex_cube_gl_code, eodDateStr, divestmentInterestTotalFormatted, "DIVESTMENT_INTEREST", "Interest on Divestment - ZIPAKE")
					IO.inspect [4, proceed]
					proceed
				else
					proceed
				end





				endOfDayRun = %LoanSavingsSystem.EndOfDay.EndOfDayRun{date_ran: date_ran, total_interest_accrued: Decimal.to_float(total_interest_accrued),
					penalties_incurred: (penalties_incurred), end_of_day_type: end_of_day_type,
					start_date: start_date, end_date: end_date, status: status, currencyId: currencyId, currencyName: currencyName, total_principal_deposited: Decimal.to_float(total_principal_deposited),
					total_charge_deposit: Decimal.to_float(fdChargeTotal),
					# divestment_principal_total: Decimal.to_float(divestmentPrincipalTotal),
					divestment_principal_total: divestmentPrincipalTotal,
					# divestment_interest_total: Decimal.to_float(divestmentInterestTotal)
					divestment_interest_total: divestmentInterestTotal
				}
				endOfDayRun = case Repo.insert(endOfDayRun) do
					{:ok, endOfDayRun} ->

						for x <- 0..(Enum.count(fixedDepositsList)-1) do
							fd = Enum.at(fixedDepositsList, x);
							fd = Repo.get!(LoanSavingsSystem.FixedDeposit.FixedDeposits, fd.id)
							IO.inspect (fd);

							fdPrincipal = fd.principalAmount;
							IO.inspect (fdPrincipal);
							fdRate = fd.interestRate;
							fdAnnualPeriod = fd.yearLengthInDays;
							fdIterestMode = fd.productInterestMode;
							fdInterestType = fd.interestRateType;
							fdPeriodType = fd.fixedPeriodType;


							accrualStartDate = nil;
							accrualStartDate = if(!is_nil(endOfDayRun.start_date)) do
								accrualStartDate = case DateTime.compare(fd.startDate, endOfDayRun.start_date) do
									:lt ->
										IO.inspect "lt"
										accrualStartDate = endOfDayRun.start_date
									:gt ->
										IO.inspect "gt"
										accrualStartDate = fd.startDate
									:eq ->
										IO.inspect "eq"
										accrualStartDate = fd.startDate;
								end
								accrualStartDate
							else
								accrualStartDate = fd.startDate
								accrualStartDate
							end


							accrualEndDate = nil;
							accrualEndDate = case DateTime.compare(fd.endDate, (startdate1)) do
								:lt ->
									IO.inspect "lt"
									accrualEndDate = nil
								:gt ->
									IO.inspect "gt"
									accrualEndDate = startdate1
								:eq ->
									IO.inspect "eq"
									accrualEndDate = startdate1;
							end




							accrualDays = if(is_nil(accrualEndDate)) do

								query = from au in LoanSavingsSystem.EndOfDay.EndOfDayEntry,
									where: au.fixed_deposit_id == type(^fd.id, :integer),
									select: sum(au.accrual_period)
								allEndOfDayEntry = Repo.one(query);
								IO.inspect allEndOfDayEntry
								allEndOfDayEntry = if is_nil(allEndOfDayEntry) do
									allEndOfDayEntry = 0;
									allEndOfDayEntry
								else
									allEndOfDayEntry
								end
								accrualDays = fd.fixedPeriod - allEndOfDayEntry;
								accrualDays
							else
								IO.inspect [accrualEndDate, accrualStartDate];
								accrualDays = DateTime.diff(accrualEndDate, accrualStartDate)
								accrualDays = accrualDays / (24*60*60)
								accrualDays = trunc(accrualDays);
								accrualDays
							end



							actualAccrualEndDate = DateTime.add(accrualStartDate, (accrualDays*24*60*60), :second) |> DateTime.truncate(:second)






							totalFdInterest = if(is_nil(accrualEndDate)) do

								query = from au in LoanSavingsSystem.EndOfDay.EndOfDayEntry,
									where: au.fixed_deposit_id == type(^fd.id, :integer),
									select: sum(au.interest_accrued)
								totalInterestAccruedSoFar = Repo.one(query);
								IO.inspect totalInterestAccruedSoFar

								totalFdInterest = if(is_nil(totalInterestAccruedSoFar)) do
									totalFdInterest = fd.expectedInterest - 0.00;
									totalFdInterest;
								else
									totalFdInterest = fd.expectedInterest - totalInterestAccruedSoFar;
									totalFdInterest
								end

								totalFdInterest = Decimal.round(Decimal.from_float(totalFdInterest), 2)
								totalFdInterest
							else
								totalFdWithInterest = LoanSavingsSystemWeb.UssdController.calculate_maturity_repayments(fdPrincipal, accrualDays, fdRate, fdAnnualPeriod, fdIterestMode, fdInterestType, fdPeriodType)
								totalFdInterest = totalFdWithInterest - fdPrincipal;
								IO.inspect [totalFdWithInterest,  fdPrincipal, totalFdInterest]
								totalFdInterest = Decimal.round(Decimal.from_float(totalFdInterest), 2)
								totalFdInterest
							end


							fdId = fd.id;
							tempAccruedInterest = Decimal.add(Decimal.from_float(fd.accruedInterest), totalFdInterest);
							tempAccruedInterest = Decimal.to_float(tempAccruedInterest);
							isMatured = if(tempAccruedInterest==fd.expectedInterest) do
								isMatured = true;
								isMatured
							else
								isMatured = fd.isMatured
								isMatured
							end




							fixedDepositStatus = if(tempAccruedInterest==fd.expectedInterest) do
								fixedDepositStatus = fd.fixedDepositStatus;
								fixedDepositStatus
							else
								fixedDepositStatus = fd.fixedDepositStatus
								fixedDepositStatus
							end



							fdUserId = fd.userId
							fdIdStr = "#{fd.id}";
							currency = fd.currency;

							principalAmount = fd.principalAmount
							fd = LoanSavingsSystem.FixedDeposit.FixedDeposits.changeset(fd,
								%{
									accountId: fd.accountId, productId: fd.productId, principalAmount: fd.principalAmount, fixedPeriod: fd.fixedPeriod, fixedPeriodType: fd.fixedPeriodType,
									interestRate: fd.interestRate, interestRateType: fd.interestRateType, expectedInterest: fd.expectedInterest, accruedInterest: Decimal.to_float(Decimal.add(Decimal.from_float(fd.accruedInterest), totalFdInterest)),
									isMatured: isMatured, isDivested: fd.isDivested, divestmentPackageId: fd.divestmentPackageId, currencyId: fd.currencyId,
									currency: fd.currency, currencyDecimals: fd.currencyDecimals, yearLengthInDays: fd.yearLengthInDays, totalDepositCharge: fd.totalDepositCharge,
									totalWithdrawalCharge: fd.totalWithdrawalCharge, totalPenalties: fd.totalPenalties, userRoleId: fd.userRoleId, userId: fd.userId,
									totalAmountPaidOut: fd.totalAmountPaidOut, startDate: fd.startDate, endDate: fd.endDate, clientId: fd.clientId, divestmentId: fd.divestmentId,
									productInterestMode: fd.productInterestMode, branchId: fd.branchId,
									divestedInterestRate: fd.divestedInterestRate, divestedInterestRateType: fd.divestedInterestRateType,
									amountDivested: fd.amountDivested, divestedInterestAmount: fd.divestedInterestAmount, divestedPeriod: fd.divestedPeriod,
									lastEndOfDayDate: actualAccrualEndDate, fixedDepositStatus: fixedDepositStatus
								})
							Repo.update!(fd);


							endOfDayEntry = %LoanSavingsSystem.EndOfDay.EndOfDayEntry{
								end_of_day_id: endOfDayRun.id,
								interest_accrued: Decimal.to_float(totalFdInterest),
								penalties_incurred: 0.00,
								fixed_deposit_id: fdId,
								status: "ACCRUED",
								currencyId: currencyId,
								currencyName: currencyName,
								end_of_day_date: date_ran,
								accrual_start_date: accrualStartDate,
								accrual_end_date: actualAccrualEndDate,
								accrual_period: accrualDays,
							}
							endOfDayEntry = Repo.insert!(endOfDayEntry);


							if(isMatured==true) do
								query = from au in LoanSavingsSystem.Accounts.User, where: au.id == ^fdUserId, select: au
								appUser = Repo.one(query)



								query = from au in LoanSavingsSystem.Client.UserBioData, where: au.userId == ^appUser.id, select: au
								userBioData = Repo.one(query)


								idLen = String.length(fdIdStr);
								fixedDepositNumber = String.pad_leading(fdIdStr, (6 - idLen), "0");
								principalFormatted = Decimal.round(Decimal.from_float(principalAmount), 2)
								principalFormatted = Decimal.to_string((principalFormatted), :normal)


								totalFundsDueFormatted = Decimal.round(Decimal.from_float(tempAccruedInterest), 2)
								totalFundsDueFormatted = Decimal.to_string((totalFundsDueFormatted), :normal)

								naive_datetime = Timex.now
								#mobile: appUser.username,
								sms = %{
									mobile: "260967307151",
									msg: "Dear #{userBioData.firstName},\nYour fixed deposit ##{fixedDepositNumber} of #{currency}" <> principalFormatted <> " is matured and due for withdrawal.\nTotal funds due is #{currency}" <> totalFundsDueFormatted <> "\nPlease dial *254*540# to withdraw your funds.",
									status: "READY",
									type: "SMS",
									msg_count: "1",
									date_sent: naive_datetime
								}
								Sms.changeset(%Sms{}, sms)
								|> Repo.insert()
							end
						end

						conn
						|> put_flash(:success, "End of Day was run successfully")
						|> redirect(to: "/Savings/End-Of-Day-History")
					{:error, changeset} ->
						Logger.info("Fail")
						conn
						|> put_flash(:success, "End of Day was not run successfully. Kindly report this issue")
						|> redirect(to: "/Savings/End-Of-Day-History")
				end



				IO.inspect [10, proceed];


				proceed
			else

				conn
				|> put_flash(:success, "End of Day was not run successfully. Configurations for End of Day is not complete")
				|> redirect(to: "/Savings/End-Of-Day-History")
			end


		end
	end




	def handlePostToFCube(uniqueMessageId, flex_cube_gl_code_dr, flex_cube_gl_code_cr, valueDate, amount, type, additionalText) do
		IO.inspect "handlePostToFCube"
		IO.inspect amount
		IO.inspect type
		proceed1 = true;

		IO.inspect [uniqueMessageId, flex_cube_gl_code_dr, flex_cube_gl_code_cr, valueDate, amount, type, additionalText]



		xml = "<soapenv:Envelope xmlns:soapenv=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:fcub=\"http://fcubs.ofss.com/service/FCUBSDEService\">\n   <soapenv:Header/>\n   <soapenv:Body>\n      <fcub:CREATEDEMULTIOFFSET_FSFS_REQ>\n         <fcub:FCUBS_HEADER>\n            <fcub:SOURCE>PROBASE</fcub:SOURCE>\n            <fcub:UBSCOMP>FCUBS</fcub:UBSCOMP>\n            <fcub:MSGID>#{uniqueMessageId}</fcub:MSGID>\n            <fcub:USERID>ZIPAKE</fcub:USERID>\n            <fcub:BRANCH>700</fcub:BRANCH>\n            <fcub:MODULEID>DE</fcub:MODULEID>\n            <fcub:SERVICE>FCUBSDEService</fcub:SERVICE>\n            <fcub:OPERATION>CreateDEMultiOffset</fcub:OPERATION>\n         </fcub:FCUBS_HEADER>\n         <fcub:FCUBS_BODY>\n            <fcub:Multioffsetmaster-Full>\n               <fcub:DE_BATCH_NUMBER>efgh</fcub:DE_BATCH_NUMBER>\n               <fcub:DE_ACCNO>#{flex_cube_gl_code_dr}</fcub:DE_ACCNO>\n               <fcub:DE_CCY_CD>ZMW</fcub:DE_CCY_CD>\n               <fcub:DE_MAIN>AAT</fcub:DE_MAIN>\n               <fcub:DE_OFFSET>MSC</fcub:DE_OFFSET>\n               <fcub:DE_VALUE_DATE>#{valueDate}</fcub:DE_VALUE_DATE>\n               <fcub:DE_AMOUNT>#{amount}</fcub:DE_AMOUNT>\n               <fcub:DE_DR_CR>D</fcub:DE_DR_CR>\n               <fcub:DE_ADDL_TEXT>{#additionalText}</fcub:DE_ADDL_TEXT>\n               <fcub:Mltoffsetdetail>\n                  <fcub:DE_ACCNO>" <> flex_cube_gl_code_cr <> "</fcub:DE_ACCNO>\n                  <fcub:DE_AMOUNT>#{amount}</fcub:DE_AMOUNT>\n                  <fcub:DE_BRANCH_CODE>700</fcub:DE_BRANCH_CODE>\n                  <fcub:DE_SERIAL_NUMBER>1</fcub:DE_SERIAL_NUMBER>\n               </fcub:Mltoffsetdetail>\n               <fcub:Devws-Batch-Master-1>\n                  <fcub:BRANCH_CODE>700</fcub:BRANCH_CODE>\n                  <fcub:BATCH_NUMBER>efgh</fcub:BATCH_NUMBER>\n                  <fcub:DESCRIPTION>Principal On Fixed Deposits - ZIPAKE</fcub:DESCRIPTION>\n                  <fcub:BALANCING>Y</fcub:BALANCING>\n               </fcub:Devws-Batch-Master-1>\n               <fcub:Misdetails>\n                  <fcub:TXNMIS4>CC5103</fcub:TXNMIS4>\n               </fcub:Misdetails>\n            </fcub:Multioffsetmaster-Full>\n         </fcub:FCUBS_BODY>\n      </fcub:CREATEDEMULTIOFFSET_FSFS_REQ>\n   </soapenv:Body>\n</soapenv:Envelope>"
		url = "http://192.168.17.35:7003/FCUBSDEService/FCUBSDEService"
		IO.inspect "xml"
		IO.inspect xml
		#options = [ssl: [{:versions, [:'tlsv1']}], recv_timeout: 5000]
		header = [{"Content-Type", "text/xml"}]

		#case HTTPoison.post(url, xml, header, options) do


		proceed1 = case HTTPoison.post(url, xml, header) do
			{:error, %HTTPoison.Error{id: nil, reason: reason}} ->
				IO.inspect ">>>>>>>>>>>>>>>>>"
				IO.inspect reason
				proceed1 = false;

				flexCubeConfig1 = %LoanSavingsSystem.FlexcubeLogs.FlexcubeLog{
					action_type: type,
					endpoint: url,
					request: xml,
					response_data: "#{reason}",
					status: "FAILED"
				}
				Repo.insert!(flexCubeConfig1);
				proceed1
			{:ok, struct} ->
				IO.inspect "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<"
				IO.inspect  (struct)
				t = struct
				|> Map.get(:body)

				IO.inspect t

				IO.inspect "Create End Of Day"
				#t = "<?xml version='1.0' encoding='UTF-8'?><S:Envelope xmlns:S=\"http://schemas.xmlsoap.org/soap/envelope/\"><S:Header><work:WorkContext xmlns:work=\"http://oracle.com/weblogic/soap/workarea/\">rO0ABXehABt3ZWJsb2dpYy5hcHAuRkNVQlNERVNlcnZpY2UAAADWAAAAI3dlYmxvZ2ljLndvcmthcmVhLlN0cmluZ1dvcmtDb250ZXh0AAoxMi4wLjMuNS43ABJ3ZWJsb2dpYy5hcHAuR1dFSkIAAADWAAAAI3dlYmxvZ2ljLndvcmthcmVhLlN0cmluZ1dvcmtDb250ZXh0AAoxMi4wLjMuNS43AAA=</work:WorkContext></S:Header><S:Body><CREATEDEMULTIOFFSET_FSFS_RES xmlns=\"http://fcubs.ofss.com/service/FCUBSDEService\"><FCUBS_HEADER><SOURCE>FLEXCUBE</SOURCE><UBSCOMP>FCUBS</UBSCOMP><MSGID>FEKOVEWRQWMLRGCEE9AMJBJQ4</MSGID><CORRELID></CORRELID><USERID>ZIPAKE</USERID><BRANCH>700</BRANCH><SERVICE>FCUBSDEService</SERVICE><OPERATION>CreateDEMultiOffset</OPERATION><SOURCE_OPERATION></SOURCE_OPERATION><DESTINATION>PROBASE</DESTINATION><FUNCTIONID>DEDMJONL</FUNCTIONID><ACTION>NEW</ACTION><MSGSTAT>SUCCESS</MSGSTAT><ADDL/></FCUBS_HEADER><FCUBS_BODY><Multioffsetmaster-Full><DE_REF_NO>700abcd211140002</DE_REF_NO><DE_BATCH_NUMBER>abcd</DE_BATCH_NUMBER><DE_CURRNO>2</DE_CURRNO><DE_ACCNO>103035108</DE_ACCNO><DE_CCY_CD>ZMW</DE_CCY_CD><DE_TOTOFFSET_AMT>4300</DE_TOTOFFSET_AMT><DE_MAIN>AAT</DE_MAIN><DE_OFFSET>MSC</DE_OFFSET><DE_VALUE_DATE>2021-06-19</DE_VALUE_DATE><DE_DR_CR>D</DE_DR_CR><DE_AMOUNT>4300</DE_AMOUNT><MAKERID>ZIPAKE</MAKERID><AUTHSTAT>U</AUTHSTAT><DE_MAKER_DATETIME>2021-04-24 17:14:19</DE_MAKER_DATETIME><DE_ADDL_TEXT>Principal on Fixed Deposits - ZIPAKE</DE_ADDL_TEXT><DE_BATCH_DESC>TEST UPLOAD PROBASE</DE_BATCH_DESC><Mltoffsetdetail><DE_ACCNO>111405057</DE_ACCNO><DE_AMOUNT>4300</DE_AMOUNT><DE_BRANCH_CODE>700</DE_BRANCH_CODE><DE_SERIAL_NUMBER>1</DE_SERIAL_NUMBER></Mltoffsetdetail><Devws-Batch-Master-1><BATCH_NUMBER>abcd</BATCH_NUMBER><DESCRIPTION>TEST UPLOAD PROBASE</DESCRIPTION><BALANCING>Y</BALANCING></Devws-Batch-Master-1><Acc-SVCSIGVR/><Misdetails><CONREFNO>700abcd211140002</CONREFNO><TXNMIS4>CC5103</TXNMIS4><TRANMIS1>BRANCHES</TRANMIS1><TRANMIS2>CHANNEL</TRANMIS2><TRANMIS3>CLAS_LOAN</TRANMIS3><TRANMIS4>COSTCENTR</TRANMIS4><TRANMIS5>FOREX_TXN</TRANMIS5><TRANMIS6>LINEOFBUS</TRANMIS6><TRANMIS7>PURPOSE</TRANMIS7></Misdetails></Multioffsetmaster-Full><FCUBS_WARNING_RESP><WARNING><WCODE>DE-MLT25</WCODE><WDESC>Value Date Is After Next Working Day</WDESC></WARNING><WARNING><WCODE>ST-SAVE-052</WCODE><WDESC>Successfully Saved and Authorized</WDESC></WARNING></FCUBS_WARNING_RESP></FCUBS_BODY></CREATEDEMULTIOFFSET_FSFS_RES></S:Body></S:Envelope>"
				status = t
					|> xpath(~x"//S:Envelope/S:Body/CREATEDEMULTIOFFSET_FSFS_RES/FCUBS_HEADER/MSGSTAT/text()")

				IO.inspect status

				status = "#{status}"
				status = String.downcase(status, :default);
				if(String.equivalent?(status, "success")) do


					amountFloat = elem Float.parse(amount), 0
					flexCubeConfig1 = %LoanSavingsSystem.FlexcubeLogs.FlexcubeLog{
						action_type: type,
						endpoint: url,
						request: xml,
						response_data: t,
						status: "SUCCESS",
						dr_gl_account_code: flex_cube_gl_code_dr,
						cr_gl_account_code: flex_cube_gl_code_cr,
						amount_posted: amountFloat,
						value_date: valueDate
					}
					Repo.insert!(flexCubeConfig1);
					proceed1
				else

					amountFloat = elem Float.parse(amount), 0
					flexCubeConfig1 = %LoanSavingsSystem.FlexcubeLogs.FlexcubeLog{
						action_type: type,
						endpoint: url,
						request: xml,
						response_data: t,
						status: "FAILED",
						dr_gl_account_code: flex_cube_gl_code_dr,
						cr_gl_account_code: flex_cube_gl_code_cr,
						amount_posted: amountFloat,
						value_date: valueDate
					}
					Repo.insert!(flexCubeConfig1);
					proceed1 = false;
					proceed1
				end
				proceed1
		end

		#t = "<?xml version='1.0' encoding='UTF-8'?><S:Envelope xmlns:S=\"http://schemas.xmlsoap.org/soap/envelope/\"><S:Header><work:WorkContext xmlns:work=\"http://oracle.com/weblogic/soap/workarea/\">rO0ABXehABt3ZWJsb2dpYy5hcHAuRkNVQlNERVNlcnZpY2UAAADWAAAAI3dlYmxvZ2ljLndvcmthcmVhLlN0cmluZ1dvcmtDb250ZXh0AAoxMi4wLjMuNS43ABJ3ZWJsb2dpYy5hcHAuR1dFSkIAAADWAAAAI3dlYmxvZ2ljLndvcmthcmVhLlN0cmluZ1dvcmtDb250ZXh0AAoxMi4wLjMuNS43AAA=</work:WorkContext></S:Header><S:Body><CREATEDEMULTIOFFSET_FSFS_RES xmlns=\"http://fcubs.ofss.com/service/FCUBSDEService\"><FCUBS_HEADER><SOURCE>FLEXCUBE</SOURCE><UBSCOMP>FCUBS</UBSCOMP><MSGID>FEKOVEWRQWMLRGCEE9AMJBJQ4</MSGID><CORRELID></CORRELID><USERID>ZIPAKE</USERID><BRANCH>700</BRANCH><SERVICE>FCUBSDEService</SERVICE><OPERATION>CreateDEMultiOffset</OPERATION><SOURCE_OPERATION></SOURCE_OPERATION><DESTINATION>PROBASE</DESTINATION><FUNCTIONID>DEDMJONL</FUNCTIONID><ACTION>NEW</ACTION><MSGSTAT>SUCCESS</MSGSTAT><ADDL/></FCUBS_HEADER><FCUBS_BODY><Multioffsetmaster-Full><DE_REF_NO>700abcd211140002</DE_REF_NO><DE_BATCH_NUMBER>abcd</DE_BATCH_NUMBER><DE_CURRNO>2</DE_CURRNO><DE_ACCNO>103035108</DE_ACCNO><DE_CCY_CD>ZMW</DE_CCY_CD><DE_TOTOFFSET_AMT>4300</DE_TOTOFFSET_AMT><DE_MAIN>AAT</DE_MAIN><DE_OFFSET>MSC</DE_OFFSET><DE_VALUE_DATE>2021-06-19</DE_VALUE_DATE><DE_DR_CR>D</DE_DR_CR><DE_AMOUNT>4300</DE_AMOUNT><MAKERID>ZIPAKE</MAKERID><AUTHSTAT>U</AUTHSTAT><DE_MAKER_DATETIME>2021-04-24 17:14:19</DE_MAKER_DATETIME><DE_ADDL_TEXT>Principal on Fixed Deposits - ZIPAKE</DE_ADDL_TEXT><DE_BATCH_DESC>TEST UPLOAD PROBASE</DE_BATCH_DESC><Mltoffsetdetail><DE_ACCNO>111405057</DE_ACCNO><DE_AMOUNT>4300</DE_AMOUNT><DE_BRANCH_CODE>700</DE_BRANCH_CODE><DE_SERIAL_NUMBER>1</DE_SERIAL_NUMBER></Mltoffsetdetail><Devws-Batch-Master-1><BATCH_NUMBER>abcd</BATCH_NUMBER><DESCRIPTION>TEST UPLOAD PROBASE</DESCRIPTION><BALANCING>Y</BALANCING></Devws-Batch-Master-1><Acc-SVCSIGVR/><Misdetails><CONREFNO>700abcd211140002</CONREFNO><TXNMIS4>CC5103</TXNMIS4><TRANMIS1>BRANCHES</TRANMIS1><TRANMIS2>CHANNEL</TRANMIS2><TRANMIS3>CLAS_LOAN</TRANMIS3><TRANMIS4>COSTCENTR</TRANMIS4><TRANMIS5>FOREX_TXN</TRANMIS5><TRANMIS6>LINEOFBUS</TRANMIS6><TRANMIS7>PURPOSE</TRANMIS7></Misdetails></Multioffsetmaster-Full><FCUBS_WARNING_RESP><WARNING><WCODE>DE-MLT25</WCODE><WDESC>Value Date Is After Next Working Day</WDESC></WARNING><WARNING><WCODE>ST-SAVE-052</WCODE><WDESC>Successfully Saved and Authorized</WDESC></WARNING></FCUBS_WARNING_RESP></FCUBS_BODY></CREATEDEMULTIOFFSET_FSFS_RES></S:Body></S:Envelope>"
		#status = t
		#	|> xpath(~x"//S:Envelope/S:Body/CREATEDEMULTIOFFSET_FSFS_RES/FCUBS_HEADER/MSGSTAT/text()")

		#IO.inspect status
		#status = "#{status}"
		#status = String.downcase(status, :default);
		#proceed1 = if(String.equivalent?(status, "success")) do
		#	flexCubeConfig1 = %LoanSavingsSystem.FlexcubeLogs.FlexcubeLog{
		#		action_type: type,
		#		endpoint: url,
		#		request: xml,
		#		response_data: t,
		#		status: "SUCCESS"
		#	}
		#	Repo.insert!(flexCubeConfig1);
		#	proceed1
		#else
		#	flexCubeConfig1 = %LoanSavingsSystem.FlexcubeLogs.FlexcubeLog{
		#		action_type: type,
		#		endpoint: url,
		#		request: xml,
		#		response_data: t,
		#		status: "FAILED"
		#	}
		#	Repo.insert!(flexCubeConfig1);
		#	proceed1 = false;
		#end
		proceed1

	end




	def randomizer(length, type \\ :all) do
		alphabets = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
		numbers = "0123456789"

		lists =
		  cond do
			type == :alpha -> alphabets <> String.downcase(alphabets, :default)
			type == :numeric -> numbers
			type == :upcase -> alphabets
			type == :downcase -> String.downcase(alphabets, :default)
			true -> alphabets <> String.downcase(alphabets, :default) <> numbers
		  end
		  |> String.split("", trim: true)

		do_randomizer(length, lists)
	end

	@doc false
	defp get_range(length) when length > 1, do: (1..length)
	defp get_range(length), do: [1]

	@doc false
	defp do_randomizer(length, lists) do
		get_range(length)
		|> Enum.reduce([], fn(_, acc) -> [Enum.random(lists) | acc] end)
		|> Enum.join("")
	end




  def show(conn, %{"id" => id}) do
    end_of_day_run = EndOfDay.get_end_of_day_run!(id)
    render(conn, "show.html", end_of_day_run: end_of_day_run)
  end

  def edit(conn, %{"id" => id}) do
    end_of_day_run = EndOfDay.get_end_of_day_run!(id)
    changeset = EndOfDay.change_end_of_day_run(end_of_day_run)
    render(conn, "edit.html", end_of_day_run: end_of_day_run, changeset: changeset)
  end

  def update(conn, %{"id" => id, "end_of_day_run" => end_of_day_run_params}) do
    end_of_day_run = EndOfDay.get_end_of_day_run!(id)

    case EndOfDay.update_end_of_day_run(end_of_day_run, end_of_day_run_params) do
      {:ok, end_of_day_run} ->
        conn
        |> put_flash(:info, "End of day run updated successfully.")
        |> redirect(to: Routes.end_of_day_run_path(conn, :show, end_of_day_run))

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "edit.html", end_of_day_run: end_of_day_run, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    end_of_day_run = EndOfDay.get_end_of_day_run!(id)
    {:ok, _end_of_day_run} = EndOfDay.delete_end_of_day_run(end_of_day_run)

    conn
    |> put_flash(:info, "End of day run deleted successfully.")
    |> redirect(to: Routes.end_of_day_run_path(conn, :index))
  end




	def end_of_day_entries(conn, %{"endofdayid" => endofdayid}) do
		host = conn.host

		query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: cl.domain == ^host, select: cl
		clientTelco = Repo.one(query);

		query = from cl in LoanSavingsSystem.Client.Clients, where: cl.id == 1, select: cl
		client = Repo.one(query);

		query = from cl in LoanSavingsSystem.EndOfDay.EndOfDayRun, where: cl.id == ^endofdayid, select: cl
		endOfDay = Repo.one(query);

		query = from cl in LoanSavingsSystem.EndOfDay.EndOfDayEntry,
			join: fd in LoanSavingsSystem.FixedDeposit.FixedDeposits,
			join: edr in LoanSavingsSystem.EndOfDay.EndOfDayRun,
			join: fdp in LoanSavingsSystem.Products.Product,
			join: u in LoanSavingsSystem.Client.UserBioData,
			on:
			cl.fixed_deposit_id == fd.id and
			cl.end_of_day_id == edr.id and
			fd.productId == fdp.id and
			fd.userId == u.userId,

		where: (edr.id == ^endofdayid),
		select: %{cl: cl, fd: fd, edr: edr, fdp: fdp, u: u}
		endOfDayEntries = Repo.all(query);

		IO.inspect endOfDayEntries
		render(conn, "index_entries.html", endOfDayEntries: endOfDayEntries, client: client, endOfDay: endOfDay)
	end



	def create_end_of_day_configurations(conn, params) do
		host = conn.host

		query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: cl.domain == ^host, select: cl
		clientTelco = Repo.one(query);

		query = from cl in LoanSavingsSystem.Client.Clients, where: cl.id == 1, select: cl
		client = Repo.one(query);

		query = from cl in LoanSavingsSystem.EndOfDay.FcubeGeneralLedger, select: cl
		glAccounts = Repo.all(query);

		query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, select: cl
		flexCubeConfigs = Repo.all(query);

		existingConfig = []
		if existingConfig == [] do

			existingConfig = []

		else

			existingConfig = for x <- 0..(Enum.count(flexCubeConfigs)-1) do
				Logger.info ">>>>>>>>>>>>"
				fcc = Enum.at(flexCubeConfigs, x);
				IO.inspect fcc;
				existingConfig = existingConfig ++ ("#{fcc.action_type}_#{fcc.dr_cr}#{fcc.flex_cube_gl_id}#{fcc.flex_cube_gl_code}")
				existingConfig
			end

		end
		IO.inspect existingConfig;

		render(conn, "create_end_of_day_configurations.html", client: client, glAccounts: glAccounts, existingConfig: existingConfig)
	end

	def post_create_end_of_day_configurations(conn, params) do

		IO.inspect params
		user = conn.assigns.user

		deposit_principal_dr = params["deposit_principal_dr"];
		deposit_principal_cr = params["deposit_principal_cr"];
		deposit_interest_dr = params["deposit_interest_dr"];
		deposit_interest_cr = params["deposit_interest_cr"];
		deposit_charge_dr = params["deposit_charge_dr"];
		deposit_charge_cr = params["deposit_charge_cr"];
		divestment_principal_dr = params["divestment_principal_dr"];
		divestment_principal_cr = params["divestment_principal_cr"];
		divestment_interest_dr = params["divestment_interest_dr"];
		divestment_interest_cr = params["divestment_interest_cr"];
		withdrawal_principal_dr = params["withdrawal_principal_dr"];
		withdrawal_principal_cr = params["withdrawal_principal_cr"];
		withdrawal_interest_dr = params["withdrawal_interest_dr"];
		withdrawal_interest_cr = params["withdrawal_interest_cr"];

		IO.inspect deposit_principal_dr
		#PRINCIPAL_DEPOSIT + DR
		if deposit_principal_dr!= -1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_DEPOSIT" and cl.dr_cr == "DR", select: cl
			flexCubeConfig1 = Repo.one(query);

				deposit_principal_dr = String.split(deposit_principal_dr, "|||");
				flex_cube_gl_id = Enum.at(deposit_principal_dr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(deposit_principal_dr, 1);
				flex_cube_gl_name = Enum.at(deposit_principal_dr, 2);

			if !is_nil(flexCubeConfig1) do
				IO.inspect flexCubeConfig1
				attrs = %{
					action_type: flexCubeConfig1.action_type,
					dr_cr: flexCubeConfig1.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig1
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				IO.inspect "Create New"
				flexCubeConfig1 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "PRINCIPAL_DEPOSIT",
					dr_cr: "DR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig1);
			end
		end



		#PRINCIPAL_DEPOSIT + CR
		if deposit_principal_cr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_DEPOSIT" and cl.dr_cr == "CR", select: cl
			flexCubeConfig2 = Repo.one(query);

				deposit_principal_cr = String.split(deposit_principal_cr, "|||");
				flex_cube_gl_id = Enum.at(deposit_principal_cr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(deposit_principal_cr, 1);
				flex_cube_gl_name = Enum.at(deposit_principal_cr, 2);
			if !is_nil(flexCubeConfig2) do
				attrs = %{
					action_type: flexCubeConfig2.action_type,
					dr_cr: flexCubeConfig2.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig2
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig2 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "PRINCIPAL_DEPOSIT",
					dr_cr: "CR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig2);
			end
		end



		#INTEREST_DEPOSIT + DR
		if deposit_interest_dr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_DEPOSIT" and cl.dr_cr == "DR", select: cl
			flexCubeConfig3 = Repo.one(query);

				deposit_interest_dr = String.split(deposit_interest_dr, "|||");
				flex_cube_gl_id = Enum.at(deposit_interest_dr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(deposit_interest_dr, 1);
				flex_cube_gl_name = Enum.at(deposit_interest_dr, 2);
			if !is_nil(flexCubeConfig3) do
				attrs = %{
					action_type: flexCubeConfig3.action_type,
					dr_cr: flexCubeConfig3.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig3
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig3 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "INTEREST_DEPOSIT",
					dr_cr: "DR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig3);
			end
		end



		#INTEREST_DEPOSIT + CR
		if deposit_interest_cr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_DEPOSIT" and cl.dr_cr == "CR", select: cl
			flexCubeConfig4 = Repo.one(query);
			deposit_interest_cr = String.split(deposit_interest_cr, "|||");
				flex_cube_gl_id = Enum.at(deposit_interest_cr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(deposit_interest_cr, 1);
				flex_cube_gl_name = Enum.at(deposit_interest_cr, 2);

			if !is_nil(flexCubeConfig4) do
				attrs = %{
					action_type: flexCubeConfig4.action_type,
					dr_cr: flexCubeConfig4.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig4
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig4 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "INTEREST_DEPOSIT",
					dr_cr: "CR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig4);
			end
		end



		#DEPOSIT_CHARGE + DR
		if deposit_charge_dr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "DEPOSIT_CHARGE" and cl.dr_cr == "DR", select: cl
			flexCubeConfig3 = Repo.one(query);

				deposit_charge_dr = String.split(deposit_charge_dr, "|||");
				flex_cube_gl_id = Enum.at(deposit_charge_dr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(deposit_charge_dr, 1);
				flex_cube_gl_name = Enum.at(deposit_charge_dr, 2);
			if !is_nil(flexCubeConfig3) do
				attrs = %{
					action_type: flexCubeConfig3.action_type,
					dr_cr: flexCubeConfig3.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig3
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig3 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "DEPOSIT_CHARGE",
					dr_cr: "DR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig3);
			end
		end



		#DEPOSIT_CHARGE + CR
		if deposit_charge_cr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "DEPOSIT_CHARGE" and cl.dr_cr == "CR", select: cl
			flexCubeConfig4 = Repo.one(query);
			deposit_charge_cr = String.split(deposit_charge_cr, "|||");
				flex_cube_gl_id = Enum.at(deposit_charge_cr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(deposit_charge_cr, 1);
				flex_cube_gl_name = Enum.at(deposit_charge_cr, 2);

			if !is_nil(flexCubeConfig4) do
				attrs = %{
					action_type: flexCubeConfig4.action_type,
					dr_cr: flexCubeConfig4.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig4
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig4 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "DEPOSIT_CHARGE",
					dr_cr: "CR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig4);
			end
		end



		#PRINCIPAL_DIVESTMENT + DR
		if divestment_principal_dr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_DIVESTMENT" and cl.dr_cr == "DR", select: cl
			flexCubeConfig5 = Repo.one(query);
				divestment_principal_dr = String.split(divestment_principal_dr, "|||");
				flex_cube_gl_id = Enum.at(divestment_principal_dr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(divestment_principal_dr, 1);
				flex_cube_gl_name = Enum.at(divestment_principal_dr, 2);

			if !is_nil(flexCubeConfig5) do
				attrs = %{
					action_type: flexCubeConfig5.action_type,
					dr_cr: flexCubeConfig5.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig5
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig5 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "PRINCIPAL_DIVESTMENT",
					dr_cr: "DR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig5);
			end
		end


		#PRINCIPAL_DIVESTMENT + CR
		if divestment_principal_cr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_DIVESTMENT" and cl.dr_cr == "CR", select: cl
			flexCubeConfig6 = Repo.one(query);
				divestment_principal_cr = String.split(divestment_principal_cr, "|||");
				flex_cube_gl_id = Enum.at(divestment_principal_cr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(divestment_principal_cr, 1);
				flex_cube_gl_name = Enum.at(divestment_principal_cr, 2);

			if !is_nil(flexCubeConfig6) do
				attrs = %{
					action_type: flexCubeConfig6.action_type,
					dr_cr: flexCubeConfig6.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig6
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig6 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "PRINCIPAL_DIVESTMENT",
					dr_cr: "CR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig6);
			end
		end


		#INTEREST_DIVESTMENT + DR
		if divestment_interest_dr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_DIVESTMENT" and cl.dr_cr == "DR", select: cl
			flexCubeConfig7 = Repo.one(query);
				divestment_interest_dr = String.split(divestment_interest_dr, "|||");
				flex_cube_gl_id = Enum.at(divestment_interest_dr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(divestment_interest_dr, 1);
				flex_cube_gl_name = Enum.at(divestment_interest_dr, 2);

			if !is_nil(flexCubeConfig7) do
				attrs = %{
					action_type: flexCubeConfig7.action_type,
					dr_cr: flexCubeConfig7.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig7
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig7 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "INTEREST_DIVESTMENT",
					dr_cr: "DR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig7);
			end
		end



		#INTEREST_DIVESTMENT + CR
		if divestment_interest_cr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_DIVESTMENT" and cl.dr_cr == "CR", select: cl
			flexCubeConfig8 = Repo.one(query);
				divestment_interest_cr = String.split(divestment_interest_cr, "|||");
				flex_cube_gl_id = Enum.at(divestment_interest_cr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(divestment_interest_cr, 1);
				flex_cube_gl_name = Enum.at(divestment_interest_cr, 2);

			if !is_nil(flexCubeConfig8) do
				attrs = %{
					action_type: flexCubeConfig8.action_type,
					dr_cr: flexCubeConfig8.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig8
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig8 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "INTEREST_DIVESTMENT",
					dr_cr: "CR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig8);
			end
		end

















		#PRINCIPAL_WITHDRAWAL + DR
		if withdrawal_principal_dr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_WITHDRAWAL" and cl.dr_cr == "DR", select: cl
			flexCubeConfig5 = Repo.one(query);
				withdrawal_principal_dr = String.split(withdrawal_principal_dr, "|||");
				flex_cube_gl_id = Enum.at(withdrawal_principal_dr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(withdrawal_principal_dr, 1);
				flex_cube_gl_name = Enum.at(withdrawal_principal_dr, 2);

			if !is_nil(flexCubeConfig5) do
				attrs = %{
					action_type: flexCubeConfig5.action_type,
					dr_cr: flexCubeConfig5.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig5
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig5 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "PRINCIPAL_WITHDRAWAL",
					dr_cr: "DR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig5);
			end
		end


		#PRINCIPAL_WITHDRAWAL + CR
		if withdrawal_principal_cr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "PRINCIPAL_WITHDRAWAL" and cl.dr_cr == "CR", select: cl
			flexCubeConfig6 = Repo.one(query);
				withdrawal_principal_cr = String.split(withdrawal_principal_cr, "|||");
				flex_cube_gl_id = Enum.at(withdrawal_principal_cr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(withdrawal_principal_cr, 1);
				flex_cube_gl_name = Enum.at(withdrawal_principal_cr, 2);

			if !is_nil(flexCubeConfig6) do
				attrs = %{
					action_type: flexCubeConfig6.action_type,
					dr_cr: flexCubeConfig6.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig6
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig6 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "PRINCIPAL_WITHDRAWAL",
					dr_cr: "CR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig6);
			end
		end


		#INTEREST_WITHDRAWAL + DR
		if withdrawal_interest_dr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_WITHDRAWAL" and cl.dr_cr == "DR", select: cl
			flexCubeConfig7 = Repo.one(query);
				withdrawal_interest_dr = String.split(withdrawal_interest_dr, "|||");
				flex_cube_gl_id = Enum.at(withdrawal_interest_dr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(withdrawal_interest_dr, 1);
				flex_cube_gl_name = Enum.at(withdrawal_interest_dr, 2);

			if !is_nil(flexCubeConfig7) do
				attrs = %{
					action_type: flexCubeConfig7.action_type,
					dr_cr: flexCubeConfig7.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig7
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig7 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "INTEREST_WITHDRAWAL",
					dr_cr: "DR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig7);
			end
		end



		#INTEREST_WITHDRAWAL + CR
		if withdrawal_interest_cr!=-1 do
			query = from cl in LoanSavingsSystem.EndOfDay.FlexCubeConfig, where: cl.action_type == "INTEREST_WITHDRAWAL" and cl.dr_cr == "CR", select: cl
			flexCubeConfig8 = Repo.one(query);
				withdrawal_interest_cr = String.split(withdrawal_interest_cr, "|||");
				flex_cube_gl_id = Enum.at(withdrawal_interest_cr, 0);
				flex_cube_gl_id = elem Integer.parse(flex_cube_gl_id), 0;
				flex_cube_gl_code = Enum.at(withdrawal_interest_cr, 1);
				flex_cube_gl_name = Enum.at(withdrawal_interest_cr, 2);

			if !is_nil(flexCubeConfig8) do
				attrs = %{
					action_type: flexCubeConfig8.action_type,
					dr_cr: flexCubeConfig8.dr_cr,
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				flexCubeConfig8
				|> FlexCubeConfig.changeset(attrs)
				|> Repo.update()
			else
				flexCubeConfig8 = %LoanSavingsSystem.EndOfDay.FlexCubeConfig{
					action_type: "INTEREST_WITHDRAWAL",
					dr_cr: "CR",
					flex_cube_gl_code: flex_cube_gl_code,
					flex_cube_gl_id: flex_cube_gl_id,
					flex_cube_gl_name: flex_cube_gl_name
				}
				Repo.insert!(flexCubeConfig8);
			end
		end

        current_user_role = get_session(conn, :current_user_role);
        current_user = get_session(conn, :current_user);
        Logger.info "Test....."



        conn
		|> put_flash(:info, "Configuration updated successfully")
		|> redirect(to: "/Savings/End-Of-Day-Configurations")
	end





	def index_calendar(conn, _params) do
		host = conn.host
		query = from cl in LoanSavingsSystem.EndOfDay.Calendar
		calendars = Repo.all(query);

		query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: cl.domain == ^host, select: cl
		clientTelco = Repo.one(query);

		query = from cl in LoanSavingsSystem.Client.Clients, where: cl.id == 1, select: cl
		client = Repo.one(query);

		IO.inspect client

		render(conn, "calendar_index.html", client: client, calendars: calendars)
	end

	def create_calendar(conn, params) do
		user = conn.assigns.user
		IO.inspect "Create End Of Day"
		IO.inspect params
		start_date = params["start_date"];
		end_date = params["end_date"];
		name = params["name"];

		startDateStr = String.split(start_date, "-");
		IO.inspect startDateStr;
		startDateStrYr = Enum.at(startDateStr, 0);
		startDateStrMn = Enum.at(startDateStr, 1);
		startDateStrDd = Enum.at(startDateStr, 2);
		startDateStr = startDateStrYr <> "-" <> startDateStrMn <> "-" <> startDateStrDd
		IO.inspect startDateStr;

		endDateStr = String.split(end_date, "-");
		IO.inspect endDateStr;
		endDateStrYr = Enum.at(endDateStr, 0);
		endDateStrMn = Enum.at(endDateStr, 1);
		endDateStrDd = Enum.at(endDateStr, 2);
		endDateStr = endDateStrYr <> "-" <> endDateStrMn <> "-" <> endDateStrDd

		d1 = Date.from_iso8601(startDateStr)
		IO.inspect d1
		start_date = case d1 do
		   {:ok, start_date} ->
			start_date
		  {:error, :invalid_format} ->
			  nil
		end
		IO.inspect start_date

		end_date = case Date.from_iso8601(endDateStr) do
		   {:ok, end_date} ->
			end_date
		  {:error, :invalid_format} ->
			  nil
		end

		type_str = "FIXED DEPOSITS"

		isMatured = false
		isDivested = false

		query = from au in Calendar,
			where: au.start_date <= type(^start_date, :date),
			where: au.end_date >= type(^end_date, :date),
			order_by: [desc: :inserted_at],
			select: au
		calendarList = Repo.all(query);

		IO.inspect "calendarList";
		IO.inspect Enum.count(calendarList);

		if Enum.count(calendarList)>0 do
			conn
				|> put_flash(:error, "You can not create this calendar as the start and or end dates fall within an existing calendar")
				|> redirect(to: "/View/calendar")
		else
			attrs = %LoanSavingsSystem.EndOfDay.Calendar{
				start_date: start_date,
				end_date: end_date,
				name: name,
				createdby_id: user.id
			}

			Repo.insert!(attrs)


			conn
				|> put_flash(:info, "Calendar created successfully")
				|> redirect(to: "/View/calendar")


		end
	end


	def index_holiday(conn, params) do
		host = conn.host
		IO.inspect params
		calendarId = params["calendarId"];
		query = from cl in LoanSavingsSystem.EndOfDay.Holiday,
			join: calendar in Calendar,
			on:
            cl.calendar_id == calendar.id,
			where: (cl.calendar_id == ^calendarId),
			select: %{holiday: cl, calendar: calendar}
		holidays = Repo.all(query);

		query = from cl in LoanSavingsSystem.SystemSetting.ClientTelco, where: cl.domain == ^host, select: cl
		clientTelco = Repo.one(query);

		query = from cl in LoanSavingsSystem.Client.Clients, where: cl.id == 1, select: cl
		client = Repo.one(query);

		IO.inspect client

		render(conn, "holiday_index.html", client: client, holidays: holidays, calendarId: calendarId)
	end

	def create_holiday(conn, params) do
		user = conn.assigns.user
		IO.inspect "Create End Of Day"
		IO.inspect params
		start_date = params["start_date"];
		end_date = params["end_date"];
		reschedule_repayment = params["reschedule_repayment"];
		calendar_id = params["calendar_id"];
		calendar_id = elem Integer.parse(calendar_id), 0;
		name = params["name"];

		startDateStr = String.split(start_date, "-");
		IO.inspect startDateStr;
		startDateStrYr = Enum.at(startDateStr, 0);
		startDateStrMn = Enum.at(startDateStr, 1);
		startDateStrDd = Enum.at(startDateStr, 2);
		startDateStr = startDateStrYr <> "-" <> startDateStrMn <> "-" <> startDateStrDd
		IO.inspect startDateStr;

		endDateStr = String.split(end_date, "-");
		IO.inspect endDateStr;
		endDateStrYr = Enum.at(endDateStr, 0);
		endDateStrMn = Enum.at(endDateStr, 1);
		endDateStrDd = Enum.at(endDateStr, 2);
		endDateStr = endDateStrYr <> "-" <> endDateStrMn <> "-" <> endDateStrDd

		rescheduleRepaymentDateStr = String.split(reschedule_repayment, "-");
		IO.inspect rescheduleRepaymentDateStr;
		rescheduleRepaymentDateStrYr = Enum.at(rescheduleRepaymentDateStr, 0);
		rescheduleRepaymentDateStrMn = Enum.at(rescheduleRepaymentDateStr, 1);
		rescheduleRepaymentDateStrDd = Enum.at(rescheduleRepaymentDateStr, 2);
		rescheduleRepaymentDateStr = rescheduleRepaymentDateStrYr <> "-" <> rescheduleRepaymentDateStrMn <> "-" <> rescheduleRepaymentDateStrDd

		d1 = Date.from_iso8601(startDateStr)
		IO.inspect d1
		start_date = case d1 do
		   {:ok, start_date} ->
			start_date
		  {:error, :invalid_format} ->
			  nil
		end
		IO.inspect start_date

		end_date = case Date.from_iso8601(endDateStr) do
		   {:ok, end_date} ->
			end_date
		  {:error, :invalid_format} ->
			  nil
		end

		reschedule_repayment_date = case Date.from_iso8601(rescheduleRepaymentDateStr) do
		   {:ok, reschedule_repayment_date} ->
			reschedule_repayment_date
		  {:error, :invalid_format} ->
			  nil
		end

		type_str = "FIXED DEPOSITS"

		isMatured = false
		isDivested = false

		query = from au in Holiday,
			where: au.from_date <= type(^start_date, :date),
			where: au.to_date >= type(^end_date, :date),
			where: au.maturity_payments_rescheduled_to >= type(^reschedule_repayment_date, :date),
			order_by: [desc: :inserted_at],
			select: au
		holidayList = Repo.all(query);

		IO.inspect "holidayList";
		IO.inspect Enum.count(holidayList);
		url = "/view/holidays/#{calendar_id}";

		if Enum.count(holidayList)>0 do
			conn
				|> put_flash(:error, "You can not create this holiday as the holiday dates fall within an existing holiday")
				|> redirect(to: url)
		else
			attrs = %LoanSavingsSystem.EndOfDay.Holiday{
				from_date: start_date,
				to_date: end_date,
				maturity_payments_rescheduled_to: reschedule_repayment_date,
				name: name,
				calendar_id: calendar_id,
				status: "ACTIVE"
			}

			Repo.insert!(attrs)


			conn
				|> put_flash(:info, "Holiday created successfully")
				|> redirect(to: url)


		end
	end


end
