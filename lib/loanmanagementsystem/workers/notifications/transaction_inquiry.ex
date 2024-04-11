# defmodule LoanSavingsSystem.Workers.TransactionInquiry do
# 	require Record
#   import Ecto.Query, warn: false
#   alias LoanSavingsSystem.Repo
#   alias LoanSavingsSystem.Notifications
#   alias Core.Constants
#   alias Core.RunProcesses

#   alias LoanSavingsSystem.SystemSetting

#   def pending_transactions() do
# 	case LoanSavingsSystem.Transactions.pending_transactions() do
#       [] ->
#         []
#       transactions ->
#         transactions
#     end
#   end

#   def inquire_pending_transaction_statusOld() do
# 	IO.inspect "inquire_pending_transaction_statusOld"
#   end

#   def inquire_pending_transaction_status() do
# 	IO.inspect "Check for Pending Transactions"
#     Enum.each(pending_transactions(), fn txn ->

# 		xml = %{"client_id": "d3c57107-fd9a-4ea6-9aa1-461ac69384b0", "client_secret": "7ec36e58-d805-4076-9910-4a050328ce3c", "grant_type": "client_credentials"}
# 		IO.inspect "xml3"
# 		IO.inspect xml
# 		xml = Jason.encode!(xml);
# 		options = [];
# 		#ssl: [{:versions, [:'tlsv3']}], recv_timeout: 5000
# 		header = [{"Content-Type", "application/json"}, {"Accept", "*/*"}];
# 		url = "https://openapiuat.airtel.africa/auth/oauth2/token";

# 		case HTTPoison.request(:post, url, xml, [{"Content-Type", "application/json"}, {"Accept", "*/*"}]) do
# 			{:error, %HTTPoison.Error{id: nil, reason: reason}} ->
# 				IO.inspect "TXN INQUIRY ERROR"
# 				IO.inspect reason
# 				#logUssdRequest(nil, "TRANSACTION INQUIRY", nil, "FAILED", mobileNumber, "Transaction Inquiry Failed - #{txn.orderRef}" );
# 			{:ok, struct} ->
# 				IO.inspect struct.body
# 				bearerBody =  Jason.decode!(struct.body)
# 				IO.inspect bearerBody
# 				bearer = bearerBody["access_token"]
# 				IO.inspect bearer

# 				url = "https://openapiuat.airtel.africa/standard/v1/payments/#{txn.orderRef}";
# 				case HTTPoison.request(:get, url, "", [{"Accept", "*/*"}, {"X-Country", "ZM"}, {"X-Currency", "ZMW"}, {"Authorization", "Bearer #{bearer}"}]) do
# 					{:error, %HTTPoison.Error{id: nil, reason: reason}} ->
# 						IO.inspect "000000000000000000"
# 						IO.inspect reason
# 					{:ok, struct} ->
# 						IO.inspect struct.body
# 						bodyStruct =  Jason.decode!(struct.body)
# 						IO.inspect bodyStruct
# 						txnStatus = bodyStruct["data"]["transaction"]["status"]

# 						transactionId = txn.orderRef;
# 						txnid = txn.id;
# 						status_code = bodyStruct["data"]["transaction"]["status"];
# 						airtelRefNo = bodyStruct["data"]["transaction"]["airtel_money_id"];
# 						IO.inspect transactionId

# 						if(status_code=="TS") do
# 							status = "Success";

# 							attrs = %{status: "Success", referenceNo: airtelRefNo}
# 							txn
# 							|> LoanSavingsSystem.Transactions.Transaction.changesetForUpdate(attrs)
# 							|> Repo.update()

# 							status = "PENDING";
# 							query = from au in LoanSavingsSystem.FixedDeposit.FixedDepositTransaction,
# 								where: (au.transactionId == type(^txnid, :integer) and au.status == type(^status, :string)),
# 								select: au
# 							fixedDepositTransaction = Repo.one(query);

# 							if(fixedDepositTransaction) do
# 								attrs = %{status: "SUCCESSFUL"}
# 								fixedDepositTransaction
# 								|> LoanSavingsSystem.FixedDeposit.FixedDepositTransaction.changesetForUpdate(attrs)
# 								|> Repo.update()

# 								fixedDepositStatus = "PENDING";
# 								query = from au in LoanSavingsSystem.FixedDeposit.FixedDeposits,
# 									where: (au.id == type(^fixedDepositTransaction.fixedDepositId, :integer) and au.fixedDepositStatus == type(^fixedDepositStatus, :string)),
# 									select: au
# 								fixedDeposit = Repo.one(query);

# 								if(fixedDeposit) do
# 									attrs = %{fixedDepositStatus: "ACTIVE"}
# 									fixedDeposit
# 									|> LoanSavingsSystem.FixedDeposit.FixedDeposits.changesetForUpdate(attrs)
# 									|> Repo.update()

# 									query = from au in LoanSavingsSystem.Accounts.Account,
# 										where: (au.userId == type(^fixedDeposit.userId, :integer)),
# 										select: au
# 									acc = Repo.one(query);

# 									acct = LoanSavingsSystem.Accounts.Account.changesetForUpdate(acc,
# 									%{
# 										accountNo: acc.accountNo,
# 										accountType: acc.accountType,
# 										accountVersion: acc.accountVersion,
# 										clientId: acc.clientId,
# 										currencyDecimals: acc.currencyDecimals,
# 										currencyId: acc.currencyId,
# 										currencyName: acc.currencyName,
# 										status: acc.status,
# 										totalCharges: acc.totalCharges,
# 										totalDeposits: (acc.totalDeposits + fixedDeposit.principalAmount),
# 										totalInterestEarned: acc.totalInterestEarned,
# 										totalInterestPosted: acc.totalInterestPosted,
# 										totalPenalties: acc.totalPenalties,
# 										totalTax: acc.totalTax,
# 										totalWithdrawals: acc.totalWithdrawals,
# 										userId: acc.userId,
# 										userRoleId: acc.userRoleId,
# 										DateClosed: nil,
# 										accountOfficerUserId: acc.accountOfficerId,
# 										blockedByUserId: acc.blockedByUserId,
# 										blockedReason: acc.blockedReason,
# 										deactivatedReason: acc.deactivatedReason,
# 										derivedAccountBalance: acc.derivedAccountBalance,
# 										externalId: acc.externalId
# 									})

# 									Repo.update!(acct)
# 								end
# 							end
# 						else
# 							if(status_code=="TF") do

# 								IO.inspect ">>>>>>>>Transaction Failed"
# 								status = "Failed";

# 								attrs = %{status: "Failed", referenceNo: airtelRefNo}
# 								txn
# 								|> LoanSavingsSystem.Transactions.Transaction.changesetForUpdate(attrs)
# 								|> Repo.update()

# 								status = "PENDING";
# 								query = from au in LoanSavingsSystem.FixedDeposit.FixedDepositTransaction,
# 									where: (au.transactionId == type(^txnid, :integer) and au.status == type(^status, :string)),
# 									select: au
# 								fixedDepositTransaction = Repo.one(query);

# 								if(fixedDepositTransaction) do
# 									attrs = %{status: "FAILED"}
# 									fixedDepositTransaction
# 									|> LoanSavingsSystem.FixedDeposit.FixedDepositTransaction.changesetForUpdate(attrs)
# 									|> Repo.update()

# 									fixedDepositStatus = "PENDING";
# 									query = from au in LoanSavingsSystem.FixedDeposit.FixedDeposits,
# 										where: (au.id == type(^fixedDepositTransaction.fixedDepositId, :integer) and au.fixedDepositStatus == type(^fixedDepositStatus, :string)),
# 										select: au
# 									fixedDeposit = Repo.one(query);

# 									if(fixedDeposit) do
# 										attrs = %{fixedDepositStatus: "FAILED"}
# 										fixedDeposit
# 										|> LoanSavingsSystem.FixedDeposit.FixedDeposits.changesetForUpdate(attrs)
# 										|> Repo.update()

# 										query = from au in LoanSavingsSystem.Accounts.Account,
# 											where: (au.userId == type(^fixedDeposit.userId, :integer)),
# 											select: au
# 										acc = Repo.one(query);

# 										acct = LoanSavingsSystem.Accounts.Account.changesetForUpdate(acc,
# 										%{
# 											accountNo: acc.accountNo,
# 											accountType: acc.accountType,
# 											accountVersion: acc.accountVersion,
# 											clientId: acc.clientId,
# 											currencyDecimals: acc.currencyDecimals,
# 											currencyId: acc.currencyId,
# 											currencyName: acc.currencyName,
# 											status: acc.status,
# 											totalCharges: acc.totalCharges,
# 											totalDeposits: (acc.totalDeposits + fixedDeposit.principalAmount),
# 											totalInterestEarned: acc.totalInterestEarned,
# 											totalInterestPosted: acc.totalInterestPosted,
# 											totalPenalties: acc.totalPenalties,
# 											totalTax: acc.totalTax,
# 											totalWithdrawals: acc.totalWithdrawals,
# 											userId: acc.userId,
# 											userRoleId: acc.userRoleId,
# 											DateClosed: nil,
# 											accountOfficerUserId: acc.accountOfficerId,
# 											blockedByUserId: acc.blockedByUserId,
# 											blockedReason: acc.blockedReason,
# 											deactivatedReason: acc.deactivatedReason,
# 											derivedAccountBalance: acc.derivedAccountBalance,
# 											externalId: acc.externalId
# 										})

# 										Repo.update!(acct)
# 									end
# 								end
# 							end
# 						end

# 				end
# 		end
#     end)
#   end

#   defp date_time(), do: DateTime.to_iso8601(Timex.local()) |> to_string |> String.slice(0..22)
# end
