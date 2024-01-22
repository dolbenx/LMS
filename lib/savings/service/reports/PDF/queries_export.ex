defmodule Savings.Service.QueriesExport do

  import Ecto.Query, warn: false
  alias Savings.Repo

  # get Tnx Fixed list
  def fix_dep_export() do
    Savings.FixedDeposit.FixedDepositTransaction
    |> join(:left, [fxd_dep_txn], fxd_dep in Savings.FixedDeposit.FixedDeposits, on: fxd_dep_txn.fixedDepositId == fxd_dep.id)
    |> join(:left, [fxd_dep_txn, fxd_dep], txn in Savings.Transactions.Transaction, on: fxd_dep_txn.transactionId == txn.id)
    |> join(:left, [fxd_dep_txn, fxd_dep, txn], acc in Savings.Accounts.Account, on: txn.userId == acc.userId)
    |> join(:left, [fxd_dep_txn, fxd_dep, txn, acc], user_bio in Savings.Client.UserBioData, on: acc.userId == user_bio.userId)
    |> select(
      [fxd_dep_txn, fxd_dep, txn, acc, user_bio],
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
        fldep_startDate: fxd_dep.startDate,
        fldep_endDate: fxd_dep.endDate,
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
        deposited_amount: fxd_dep.principalAmount,
        account_status: acc.status,
        account_number: acc.accountNo
      }
    )
    |> Repo.all()
  end

  ######################################################################################################################################################

  def customer_export() do
    Savings.Accounts.User
    |> join(:left, [a], u in Savings.Client.UserBioData, on: a.id == u.userId)
    |> join(:left, [a, u], ro in Savings.Accounts.UserRole, on: u.userId == ro.userId)
    |> join(:left, [a, u, ro], acc in Savings.Accounts.Account, on: ro.userId == acc.userId)
    |> where([a, u, ro, acc], a.id == acc.userId and ro.roleType == ^"INDIVIDUAL")
    |> select(
      [a, u, ro, acc],
      %{
        id: acc.id,
        status: a.status,
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
        accountType: acc.accountType,
        total_deposits: acc.totalDeposits,
        total_withdrawals: acc.totalWithdrawals,
        total_interest: acc.totalInterestEarned,
        total_balance: acc.totalDeposits + acc.totalInterestEarned - acc.totalWithdrawals,
        account_status: acc.status,
        acc_inserted_at: acc.inserted_at,
        customer_names: fragment("concat(?, '  ', ?)", u.firstName, u.lastName)
      }
    )
    |> Repo.all()
  end

  ######################################################################################################################################################

  def partial_divestment_export() do
    Savings.Divestments.DivestmentTransaction
    |> join(:left, [dive_txn], dive in Savings.Divestments.Divestment, on: dive_txn.divestmentId == dive.id)
    |> join(:left, [dive_txn, dive], fldep in Savings.FixedDeposit.FixedDeposits, on: dive.fixedDepositId == fldep.id)
    |> join(:left, [dive_txn, dive, fldep], txn in Savings.Transactions.Transaction, on: dive_txn.transactionId == txn.id)
    |> join(:left, [dive_txn, dive, fldep, txn], user_bio in Savings.Client.UserBioData, on: txn.userId == user_bio.userId)
    |> join(:left, [dive_txn, dive, fldep, txn, user_bio], acc in Savings.Accounts.Account, on: user_bio.userId == acc.userId)
    |> where([dive_txn, dive, fldep, txn, user_bio, acc], dive.divestmentType == "Partial Divestment" or dive.divestmentType == "PARTIAL DIVESTMENT")
    |> select(
      [dive_txn, dive, fldep, txn, user_bio, acc],
      %{
        divestmentId: dive_txn.divestmentId,
        transactionId: dive_txn.transactionId,
        amountDivested: dive_txn.amountDivested,
        interestAccrued: dive_txn.interestAccrued,
        userId: dive_txn.userId,
        userRoleId: dive_txn.userRoleId,
        clientId: dive_txn.clientId,
        fixedDepositStatus: fldep.fixedDepositStatus,
        divestmentType: dive.divestmentType,
        divestment_date: dive_txn.inserted_at,
        txn_totalAmount: txn.totalAmount,
        txn_status: txn.status,
        txn_customerName: txn.customerName,
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
        account_status: acc.status,
        account_number: acc.accountNo
      }
    )
    |> Repo.all()
  end

  ######################################################################################################################################################

  def full_divestment_export() do
    Savings.Divestments.DivestmentTransaction
    |> join(:left, [dive_txn], dive in Savings.Divestments.Divestment, on: dive_txn.divestmentId == dive.id)
    |> join(:left, [dive_txn, dive], fldep in Savings.FixedDeposit.FixedDeposits, on: dive.fixedDepositId == fldep.id)
    |> join(:left, [dive_txn, dive, fldep], txn in Savings.Transactions.Transaction, on: dive_txn.transactionId == txn.id)
    |> join(:left, [dive_txn, dive, fldep, txn], user_bio in Savings.Client.UserBioData, on: txn.userId == user_bio.userId)
    |> join(:left, [dive_txn, dive, fldep, txn, user_bio], acc in Savings.Accounts.Account, on: user_bio.userId == acc.userId)
    |> where([dive_txn, dive, fldep, txn, user_bio, acc], dive.divestmentType == "Full Divestment" or dive.divestmentType == "FULL DIVESTMENT")
    |> select([dive_txn, dive, fldep, txn, user_bio, acc],
      %{
        divestmentId: dive_txn.divestmentId,
        transactionId: dive_txn.transactionId,
        amountDivested: dive_txn.amountDivested,
        interestAccrued: dive_txn.interestAccrued,
        userId: dive_txn.userId,
        userRoleId: dive_txn.userRoleId,
        clientId: dive_txn.clientId,
        fixedDepositStatus: fldep.fixedDepositStatus,
        divestmentType: dive.divestmentType,
        divestment_date: dive_txn.inserted_at,
        txn_totalAmount: txn.totalAmount,
        txn_status: txn.status,
        txn_customerName: txn.customerName,
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
        account_status: acc.status,
        account_number: acc.accountNo
      }
    )
    |> Repo.all()
  end

  ######################################################################################################################################################

  def mature_withdraw_export() do
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

  ######################################################################################################################################################

  def all_transactions_export() do
    Savings.Transactions.Transaction
    |> join(:left, [txn], user_bio in Savings.Client.UserBioData, on: txn.userId == user_bio.userId)
    |> join(:left, [txn, user_bio], acc in Savings.Accounts.Account, on: user_bio.userId == acc.userId)
    |> join(:left, [txn, user_bio, acc], pro in Savings.Products.Product, on: txn.productId == pro.id)
    |> select(
      [txn, user_bio, acc, pro],
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
        # user_status: user.status,
        # fldep_startDate: fldep.startDate,
        # fldep_endDate: fldep.endDate,
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

  def fix_dep_report_export() do
    Savings.FixedDeposit.FixedDepositTransaction
    |> join(:left, [fxd_dep_txn], fxd_dep in Savings.FixedDeposit.FixedDeposits, on: fxd_dep_txn.fixedDepositId == fxd_dep.id)
    |> join(:left, [fxd_dep_txn, fxd_dep], txn in Savings.Transactions.Transaction, on: fxd_dep_txn.transactionId == txn.id)
    |> join(:left, [fxd_dep_txn, fxd_dep, txn], acc in Savings.Accounts.Account, on: txn.userId == acc.userId)
    |> join(:left, [fxd_dep_txn, fxd_dep, txn, acc], user_bio in Savings.Client.UserBioData, on: acc.userId == user_bio.userId)
    |> join(:full, [fxd_dep_txn, fxd_dep, txn, acc, user_bio], pro in Savings.Products.Product, on: fxd_dep.productId  == pro.id)
    |> select(
      [fxd_dep_txn, fxd_dep, txn, acc, user_bio, pro],
      %{
        deposited_date: fxd_dep_txn.inserted_at,
        txn_accountId: txn.accountId,
        txn_totalAmount: txn.totalAmount,
        txn_productId: fxd_dep.productId,
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
        fldep_startDate: fxd_dep.startDate,
        fldep_endDate: fxd_dep.endDate,
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
        deposited_amount: fxd_dep.principalAmount,
        account_status: acc.status,
        account_number: acc.accountNo,
        product_name: pro.name,
        product_code: pro.code,
        startDate: fxd_dep.startDate,
        startTime: fxd_dep.startDate,
        endDate: fxd_dep.endDate,
        fixedPeriod: fxd_dep.fixedPeriod,
        interestRate: fxd_dep.interestRate,
        divestmentType: fxd_dep.divestedInterestRateType,
        principalAmount: fxd_dep.principalAmount,
        totalDepositCharge: fxd_dep.totalDepositCharge,
        accruedInterest: fxd_dep.accruedInterest,
        amountDivested: fxd_dep.amountDivested,
        expectedInterest: fxd_dep.expectedInterest
      }
    )
    |> Repo.all()
  end

  ######################################################################################################################################################

  def report_deposit_summury_export() do
    Savings.FixedDeposit.FixedDepositTransaction
    |> join(:left, [fxd_dep_txn], fdep in Savings.FixedDeposit.FixedDeposits, on: fxd_dep_txn.fixedDepositId == fdep.id)
    |> join(:left, [fxd_dep_txn, fdep], txn in Savings.Transactions.Transaction, on: fxd_dep_txn.transactionId == txn.id)
    |> join(:left, [fxd_dep_txn, fdep, txn], user_bio in Savings.Client.UserBioData, on: fxd_dep_txn.userId == user_bio.userId)
    |> join(:left, [fxd_dep_txn, fdep, txn, user_bio], user in Savings.Accounts.User, on: fxd_dep_txn.userId == user.id)
    |> join(:left, [fxd_dep_txn, fdep, txn, user_bio, user], pro in Savings.Products.Product, on: fdep.productId == pro.id)
    |> where([fxd_dep_txn, fdep, txn, user_bio, user, pro], txn.transactionTypeEnum == ^"DEPOSIT")
    |> select(
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
      %{
        txn_accountId: txn.accountId,
        txn_totalAmount: txn.totalAmount,
        txn_productId: fdep.productId,
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
        product_name: pro.name,
        product_code: pro.code,
        product_minimumPeriod: pro.minimumPeriod,
        product_maximumPeriod: pro.maximumPeriod,
        product_details: pro.details,
        product_currencyId: pro.currencyId,
        product_currencyName: pro.currencyName,
        pro_currencyDecimals: pro.currencyDecimals,
        product_interest: pro.interest,
        product_interestType: pro.interestType,
        product_interestMode: pro.interestMode,
        product_defaultPeriod: pro.defaultPeriod,
        product_periodType: pro.periodType,
        productType: pro.productType,
        product_minimumPrincipal: pro.minimumPrincipal,
        product_maximumPrincipal: pro.maximumPrincipal,
        product_clientId: pro.clientId,
        product_yearLengthInDays: pro.yearLengthInDays,
        product_status: pro.status,
        product_id: pro.id,
        txn_client_first_name: user_bio.firstName,
        txn_client_last_name: user_bio.lastName,
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
        user_status: user.status,
        fdep_principle_amount: fdep.principalAmount,
        fdep_startDate: fdep.startDate,
        fdep_endDate: fdep.endDate
      }
    )
    |> Repo.all()
  end

  ######################################################################################################################################################


  def report_deposit_interest_export() do
    Savings.FixedDeposit.FixedDepositTransaction
    |> join(:left, [fxd_dep_txn], fdep in Savings.FixedDeposit.FixedDeposits, on: fxd_dep_txn.fixedDepositId == fdep.id)
    |> join(:left, [fxd_dep_txn, fdep], txn in Savings.Transactions.Transaction, on: fxd_dep_txn.transactionId == txn.id)
    |> join(:left, [fxd_dep_txn, fdep, txn], user_bio in Savings.Client.UserBioData, on: fxd_dep_txn.userId == user_bio.userId)
    |> join(:left, [fxd_dep_txn, fdep, txn, user_bio], user in Savings.Accounts.User, on: fxd_dep_txn.userId == user.id)
    |> join(:left, [fxd_dep_txn, fdep, txn, user_bio, user], pro in Savings.Products.Product, on: fdep.productId == pro.id)
    |> where([fxd_dep_txn, fdep, txn, user_bio, user, pro], txn.transactionTypeEnum == ^"DEPOSIT")
    |> select(
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
      %{
        txn_accountId: txn.accountId,
        txn_totalAmount: txn.totalAmount,
        txn_productId: fdep.productId,
        fdep_accruedInterest: fdep.accruedInterest,
        fdep_expectedInterest: fdep.expectedInterest,
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
        product_name: pro.name,
        product_code: pro.code,
        product_minimumPeriod: pro.minimumPeriod,
        product_maximumPeriod: pro.maximumPeriod,
        product_details: pro.details,
        product_currencyId: pro.currencyId,
        product_currencyName: pro.currencyName,
        pro_currencyDecimals: pro.currencyDecimals,
        product_interest: pro.interest,
        product_interestType: pro.interestType,
        product_interestMode: pro.interestMode,
        product_defaultPeriod: pro.defaultPeriod,
        product_periodType: pro.periodType,
        productType: pro.productType,
        product_minimumPrincipal: pro.minimumPrincipal,
        product_maximumPrincipal: pro.maximumPrincipal,
        product_clientId: pro.clientId,
        product_yearLengthInDays: pro.yearLengthInDays,
        product_status: pro.status,
        product_id: pro.id,
        txn_client_first_name: user_bio.firstName,
        txn_client_last_name: user_bio.lastName,
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
        user_status: user.status,
        fdep_principle_amount: fdep.principalAmount,
        fdep_startDate: fdep.startDate,
        fdep_endDate: fdep.endDate
      }
    )
    |> Repo.all()
  end

  ######################################################################################################################################################

end
