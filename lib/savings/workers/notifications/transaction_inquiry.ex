defmodule Savings.Workers.TransactionInquiry do
	require Record
  import Ecto.Query, warn: false
  alias Savings.Repo
	alias Savings.Notifications.Sms


  def pending_transactions() do
	case Savings.Transactions.pending_transactions() do
      [] ->
				IO.puts("\n <<<<<<<  NO PENDING TRANSACTIONS WERE FOUND >>>>>>> \n")
        []
      transactions ->
        transactions
    end
  end


  def inquire_pending_transaction_statusOld() do
	IO.inspect "inquire_pending_transaction_statusOld"
  end

  def inquire_pending_transaction_status() do
	IO.inspect "Check for Pending Transactions"
    Enum.each(pending_transactions(), fn txn ->
			# newTotalBalance = txn.newTotalBalance

		xml = %{client_id: "402bffe8-eae6-45e9-92df-9053cfaa30e2", client_secret: "1fb2115f-243f-461f-ba96-eb4118c35c49", grant_type: "client_credentials"}
		IO.inspect "xml3d"
		IO.inspect xml
		xml = Jason.encode!(xml)
		#ssl: [{:versions, [:'tlsv3']}], recv_timeout: 5000
		url = "https://openapi.airtel.africa/auth/oauth2/token"

		case HTTPoison.request(:post, url, xml, [{"Content-Type", "application/json"}, {"Accept", "*/*"}]) do
			{:error, %HTTPoison.Error{id: nil, reason: reason}} ->
				IO.inspect "TOKEN GENERATION ERROR"
				IO.inspect reason
				#logUssdRequest(nil, "TRANSACTION INQUIRY", nil, "FAILED", mobileNumber, "Transaction Inquiry Failed - #{txn.referenceNo}" )
			{:ok, struct} ->
				IO.inspect struct.body
				bearerBody =  Jason.decode!(struct.body)
				IO.inspect bearerBody
				bearer = bearerBody["access_token"]
				IO.inspect "TOKEN GENERATION WORKED"
				IO.inspect bearer

				url = "https://openapi.airtel.africa/standard/v1/payments/#{txn.referenceNo}"
				case HTTPoison.request(:get, url, "", [{"Accept", "*/*"}, {"X-Country", "ZM"}, {"X-Currency", "ZMW"}, {"Authorization", "Bearer #{bearer}"}]) do
					{:error, %HTTPoison.Error{id: nil, reason: reason}} ->
						IO.inspect "TXN INQUIRY ERROR"
						IO.inspect reason
					{:ok, struct} ->
						IO.inspect "reffffffffffffffffffffffffff"
						IO.inspect txn.referenceNo
						IO.inspect struct.body
						bodyStruct =  Jason.decode!(struct.body)
						IO.inspect bodyStruct
						transactionId = txn.referenceNo
						txnid = txn.id
						status_code = bodyStruct["data"]["transaction"]["status"]
						IO.inspect transactionId
						tnxNotRecorded = bodyStruct["status"]["code"]

					if (tnxNotRecorded == "404") do
							if (tnxNotRecorded == "500") do
								IO.inspect ">>>>>>>>Transaction Failed"

								attrs = %{status: "FAILED"}
								txn
								|> Savings.Transactions.Transaction.changesetForUpdate(attrs)
								|> Repo.update()

								status = "PENDING"
								query = from au in Savings.FixedDeposit.FixedDepositTransaction,
									where: (au.transactionId == type(^txnid, :integer) and au.status == type(^status, :string)),
									select: au
								fixedDepositTransaction = Repo.one(query)

								if(fixedDepositTransaction) do
									attrs = %{status: "FAILED"}
									fixedDepositTransaction
									|> Savings.FixedDeposit.FixedDepositTransaction.changesetForUpdate(attrs)
									|> Repo.update()


									fixedDepositStatus = "PENDING"
									query = from au in Savings.FixedDeposit.FixedDeposits,
										where: (au.id == type(^fixedDepositTransaction.fixedDepositId, :integer) and au.fixedDepositStatus == type(^fixedDepositStatus, :string)),
										select: au
									fixedDeposit = Repo.one(query)

									if(fixedDeposit) do
										attrs = %{fixedDepositStatus: "FAILED"}
										fixedDeposit
										|> Savings.FixedDeposit.FixedDeposits.changesetForUpdate(attrs)
										|> Repo.update()

									end
								end
							end
						else
							if(status_code=="TS") do

								attrs = %{status: "SUCCESS"}
								txn
								|> Savings.Transactions.Transaction.changesetForUpdate(attrs)
								|> Repo.update()

								status = "PENDING"
								query = from au in Savings.FixedDeposit.FixedDepositTransaction,
									where: (au.transactionId == type(^txnid, :integer) and au.status == type(^status, :string)),
									select: au
								fixedDepositTransaction = Repo.one(query)

								if(fixedDepositTransaction) do
									attrs = %{status: "SUCCESS"}
									fixedDepositTransaction
									|> Savings.FixedDeposit.FixedDepositTransaction.changesetForUpdate(attrs)
									|> Repo.update()


									fixedDepositStatus = "PENDING"
									query = from au in Savings.FixedDeposit.FixedDeposits,
										where: (au.id == type(^fixedDepositTransaction.fixedDepositId, :integer) and au.fixedDepositStatus == type(^fixedDepositStatus, :string)),
										select: au
									fixedDeposit = Repo.one(query)

									if(fixedDeposit) do
										attrs = %{fixedDepositStatus: "ACTIVE"}
										fixedDeposit
										|> Savings.FixedDeposit.FixedDeposits.changesetForUpdate(attrs)
										|> Repo.update()


										query = from au in Savings.Accounts.Account,
											where: (au.userId == type(^fixedDeposit.userId, :integer)),
											select: au
										acc = Repo.one(query)

										acct = Savings.Accounts.Account.changesetForUpdate(acc,
										%{
											accountNo: acc.accountNo,
											accountType: acc.accountType,
											accountVersion: acc.accountVersion,
											clientId: acc.clientId,
											currencyDecimals: acc.currencyDecimals,
											currencyId: acc.currencyId,
											currencyName: acc.currencyName,
											status: acc.status,
											totalCharges: acc.totalCharges,
											totalDeposits: (acc.totalDeposits + fixedDeposit.principalAmount),
											totalInterestEarned: acc.totalInterestEarned,
											totalInterestPosted: acc.totalInterestPosted,
											totalPenalties: acc.totalPenalties,
											totalTax: acc.totalTax,
											totalWithdrawals: acc.totalWithdrawals,
											userId: acc.userId,
											userRoleId: acc.userRoleId,
											DateClosed: nil,
											accountOfficerUserId: acc.accountOfficerId,
											blockedByUserId: acc.blockedByUserId,
											blockedReason: acc.blockedReason,
											deactivatedReason: acc.deactivatedReason,
											derivedAccountBalance: acc.derivedAccountBalance,
											externalId: acc.externalId
										})

										Repo.update!(acct)
										principalAmount = :erlang.float_to_binary((fixedDeposit.principalAmount), [{:decimals, 2}])
										expectedInterest  = :erlang.float_to_binary((fixedDeposit.expectedInterest), [{:decimals, 2}])
										naive_datetime = Timex.now

											sms = %{
												mobile: acc.accountNo,
												msg: "Dear #{fixedDeposit.customerName},\nYour deposit of #{fixedDeposit.currency} #{principalAmount} has been recorded successfully, your deposit will be fixed for a period of #{fixedDeposit.fixedPeriod} #{fixedDeposit.fixedPeriodType} yielding you an interest of #{fixedDeposit.currency} #{expectedInterest} \nOrder Ref: #{txn.orderRef}",
												status: "READY",
												type: "SMS",
												msg_count: "1",
												date_sent: naive_datetime
											}

											Sms.changeset(%Sms{}, sms)
											|> Repo.insert()
									end
								end
							else
								if(status_code=="TF") do

									IO.inspect ">>>>>>>>Transaction Failed"

									attrs = %{status: "FAILED"}
									txn
									|> Savings.Transactions.Transaction.changesetForUpdate(attrs)
									|> Repo.update()

									status = "PENDING"
									query = from au in Savings.FixedDeposit.FixedDepositTransaction,
										where: (au.transactionId == type(^txnid, :integer) and au.status == type(^status, :string)),
										select: au
									fixedDepositTransaction = Repo.one(query)

									if(fixedDepositTransaction) do
										attrs = %{status: "FAILED"}
										fixedDepositTransaction
										|> Savings.FixedDeposit.FixedDepositTransaction.changesetForUpdate(attrs)
										|> Repo.update()


										fixedDepositStatus = "PENDING"
										query = from au in Savings.FixedDeposit.FixedDeposits,
											where: (au.id == type(^fixedDepositTransaction.fixedDepositId, :integer) and au.fixedDepositStatus == type(^fixedDepositStatus, :string)),
											select: au
										fixedDeposit = Repo.one(query)

										if(fixedDeposit) do
											attrs = %{fixedDepositStatus: "FAILED"}
											fixedDeposit
											|> Savings.FixedDeposit.FixedDeposits.changesetForUpdate(attrs)
											|> Repo.update()

										end
									end
								end
							end



						end

				end
			end
    end)
  end



  defp date_time(), do: DateTime.to_iso8601(Timex.local()) |> to_string |> String.slice(0..22)
end
