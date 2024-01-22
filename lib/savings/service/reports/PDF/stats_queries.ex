defmodule Savings.Service.StatsQueries do

  import Ecto.Query, warn: false
  alias Savings.Repo
  alias Savings.Accounts.Account
  alias Savings.FixedDeposit.FixedDeposits

  def get_all_savings_customer_details(userId) do
    Account
      |> join(:left, [a], u in "tbl_user_bio_data", on: a.userId == u.userId)
      |> join(:left, [a], aU in "tbl_users", on: a.userId == aU.id)
      |> where([a, u, aU], a.accountType == "SAVINGS")
      |> select([a, u, aU], %{
        id: a.id,
        accountType: a.accountType,
        userId: a.userId,
        accountStatus: a.status,
        status: aU.status,
        firstName: u.firstName,
        lastName: u.lastName,
        otherName: u.otherName,
        dateOfBirth: u.dateOfBirth,
        meansOfIdentificationType: u.meansOfIdentificationType,
        meansOfIdentificationNumber: u.meansOfIdentificationNumber,
        title: u.title,
        gender: u.gender,
        mobileNumber: u.mobileNumber,
        emailAddress: u.emailAddress,
        ussdActive: aU.ussdActive
      })
      |> Repo.all()
  end

  # Savings.Service.StatsQueries.get_customer_balance(3)

  def get_customer_balance(userId) do
    Account
    |> join(:full, [a], fdp in "tbl_fixed_deposit", on: a.id == fdp.accountId)
    |> where([a, fdp], a.id == ^userId and fdp.fixedDepositStatus == "ACTIVE")
    |> select([a, fdp], %{
      totalDeposits: sum(fdp.principalAmount),
      expectedInterest: sum(fdp.expectedInterest),
      total_deps: count(fdp.id),
      totalWithdrawals: sum(a.totalWithdrawals),
      totalBalance: sum(fdp.totalBalance)
      })
    |> Repo.all()
  end

  def get_customer_withdraws_balance(userId) do
    Account
    |> join(:full, [a], tnx in "tbl_transactions", on: a.id == tnx.accountId)
    |> where([a, tnx], a.id == ^userId and tnx.transactionTypeEnum == "Withdrawal")
    |> select([a, tnx], %{
      total_withdraw: count(tnx.id),
      })
    |> Repo.all()
  end

  def get_customer_availabe_balance(userId) do
    Account
    |> join(:full, [a], fdp in "tbl_fixed_deposit", on: a.id == fdp.accountId)
    |> where([a, fdp], a.id == ^userId and fdp.fixedDepositStatus == "ACTIVE")
    |> select([a, fdp], %{
      total_balance: sum(a.totalWithdrawals)
      })
    |> Repo.all()
  end

  ######################################################################################################################################################


  def customer_fix_dep_export(userId) do
    Savings.FixedDeposit.FixedDepositTransaction
    |> join(:left, [fxd_dep_txn], fxd_dep in Savings.FixedDeposit.FixedDeposits, on: fxd_dep_txn.fixedDepositId == fxd_dep.id)
    |> join(:left, [fxd_dep_txn, fxd_dep], txn in Savings.Transactions.Transaction, on: fxd_dep_txn.transactionId == txn.id)
    |> join(:left, [fxd_dep_txn, fxd_dep, txn], acc in Savings.Accounts.Account, on: acc.id == fxd_dep.accountId)
    |> where([fxd_dep_txn, fxd_dep, txn, acc], acc.id == ^userId and fxd_dep.fixedDepositStatus == "ACTIVE")
    |> select(
      [fxd_dep_txn, fxd_dep, txn, acc],
      %{
        deposited_date: fxd_dep_txn.inserted_at,
        txn_accountId: txn.accountId,
        txn_totalAmount: txn.totalAmount,
        txn_productId: txn.productId,
        txn_productType: txn.productType,
        txn_userId: txn.userId,
        txn_userRoleId: txn.userRoleId,
        txn_referenceNo: txn.referenceNo,
        txn_orderRef: txn.orderRef,
        txn_transactionType: txn.transactionType,
        txn_status: txn.status,
        txn_isReversed: txn.isReversed,
        txn_requestData: txn.requestData,
        txn_responseData: txn.responseData,
        txn_carriedOutByUserId: txn.carriedOutByUserId,
        txn_carriedOutByUserRoleId: txn.carriedOutByUserRoleId,
        txn_transactionTypeEnum: txn.transactionTypeEnum,
        txn_transactionDetail: txn.transactionDetail,
        txn_newTotalBalance: txn.newTotalBalance,
        txn_currencyDecimals: txn.currencyDecimals,
        txn_currency: txn.currency,
        txn_customerName: txn.customerName,
        txn_inserted_at: txn.inserted_at,
        txn_updated_at: txn.updated_at,
        fldep_startDate: fxd_dep.startDate,
        fldep_endDate: fxd_dep.endDate,
        fdep_accruedInterest: fxd_dep.accruedInterest,
        fdep_expectedInterest: fxd_dep.expectedInterest,
        deposited_amount: fxd_dep.principalAmount,
        account_status: acc.status,
        account_number: acc.accountNo
      }
    )
    |> Repo.all()
  end

  ######################################################################################################################################################

  def customer_transactions_export(userId) do
    Savings.Transactions.Transaction
    |> join(:left, [txn], acc in Savings.Accounts.Account, on: txn.accountId == acc.id)
    |> join(:left, [txn, acc], pro in Savings.Products.Product, on: txn.productId == pro.id)
    |> where([txn, acc, pro], acc.id == ^userId)
    |> select(
      [txn, acc, pro],
      %{
        txn_accountId: txn.accountId,
        txn_totalAmount: txn.totalAmount,
        txn_productId: txn.productId,
        txn_productType: txn.productType,
        txn_userId: txn.userId,
        txn_userRoleId: txn.userRoleId,
        txn_referenceNo: txn.referenceNo,
        txn_orderRef: txn.orderRef,
        txn_transactionType: txn.transactionType,
        txn_status: txn.status,
        txn_isReversed: txn.isReversed,
        txn_requestData: txn.requestData,
        txn_responseData: txn.responseData,
        txn_carriedOutByUserId: txn.carriedOutByUserId,
        txn_carriedOutByUserRoleId: txn.carriedOutByUserRoleId,
        txn_transactionTypeEnum: txn.transactionTypeEnum,
        txn_transactionDetail: txn.transactionDetail,
        txn_newTotalBalance: txn.newTotalBalance,
        txn_currencyDecimals: txn.currencyDecimals,
        txn_currency: txn.currency,
        txn_customerName: txn.customerName,
        txn_inserted_at: txn.inserted_at,
        txn_updated_at: txn.updated_at,
        # user_status: user.status,
        # fldep_startDate: fldep.startDate,
        # fldep_endDate: fldep.endDate,
        deposited_date: txn.inserted_at,
        deposited_amount: txn.totalAmount,
        account_status: acc.status,
        account_number: acc.accountNo,
        product_name: pro.name,
        product_code: pro.code,
        divestmentType: txn.transactionType
      }
    )
    |> Repo.all()
  end

  ######################################################################################################################################################


  def customer_mature_withdraw_export(userId) do
    Savings.Transactions.Transaction
    |> join(:left, [txn], user_bio in Savings.Client.UserBioData, on: txn.userId == user_bio.userId)
    |> join(:left, [txn, user_bio], acc in Savings.Accounts.Account, on: user_bio.userId == acc.userId)
    |> join(:left, [txn, user_bio, acc], pro in Savings.Products.Product, on: txn.productId == pro.id)
    |> where([txn, user_bio, acc, pro], txn.transactionTypeEnum == "Withdrawal")
    |> select([txn, user_bio, acc, pro],
      %{
        txn_accountId: txn.accountId,
        txn_totalAmount: txn.totalAmount,
        txn_productId: txn.productId,
        txn_productType: txn.productType,
        txn_userId: txn.userId,
        txn_userRoleId: txn.userRoleId,
        txn_referenceNo: txn.referenceNo,
        txn_orderRef: txn.orderRef,
        txn_transactionType: txn.transactionType,
        txn_status: txn.status,
        txn_isReversed: txn.isReversed,
        txn_requestData: txn.requestData,
        txn_responseData: txn.responseData,
        txn_carriedOutByUserId: txn.carriedOutByUserId,
        txn_carriedOutByUserRoleId: txn.carriedOutByUserRoleId,
        txn_transactionTypeEnum: txn.transactionTypeEnum,
        txn_transactionDetail: txn.transactionDetail,
        txn_newTotalBalance: txn.newTotalBalance,
        txn_currencyDecimals: txn.currencyDecimals,
        txn_currency: txn.currency,
        txn_customerName: txn.customerName,
        txn_inserted_at: txn.inserted_at,
        txn_updated_at: txn.updated_at,
        firstName: user_bio.firstName,
        lastName: user_bio.lastName,
        user_bio_userId: user_bio.userId,
        otherName: user_bio.otherName,
        dateOfBirth: user_bio.dateOfBirth,
        meansOfIdentificationType: user_bio.meansOfIdentificationType,
        meansOfIdentificationNumber: user_bio.meansOfIdentificationNumber,
        user_bio_title: user_bio.title,
        user_bio_gender: user_bio.gender,
        mobileNumber: user_bio.mobileNumber,
        emailAddress: user_bio.emailAddress,
        user_bio_clientId: user_bio.clientId,
        customer_identity:
          fragment(
            "concat(?, ' - ', ?)",
            user_bio.meansOfIdentificationType,
            user_bio.meansOfIdentificationNumber
          ),
        customer_names:
          fragment(
            "concat(?, '  ', ?)",
            user_bio.firstName,
            user_bio.lastName
          ),
        account_status: acc.status,
        account_number: acc.accountNo,
        product_name: pro.name,
        product_code: pro.code
      }
    )
    |> Repo.all()
  end

  # Savings.Service.StatsQueries.format_date
  def format_date() do
    input_string = "2023-10-03T22:32:16Z"

    # Parse the input string into a DateTime struct
    parsed_datetime = DateTime.from_iso8601!(input_string)

    # Format the DateTime struct as a string in the desired format
    formatted_date = Calendar.Format.DateTime.Formatter.strftime(parsed_datetime, "{0D} {AbbrMMM} {YYYY}")
                     |> String.downcase()

    IO.puts formatted_date


  end

end
