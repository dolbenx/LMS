defmodule Savings.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias Savings.Repo

  alias Savings.Transactions.Transaction
  alias Savings.Client.UserBioData

  @doc """
  Returns the list of tbl_transactions.

  ## Examples

      iex> list_tbl_transactions()
      [%Transaction{}, ...]

  """
  def list_tbl_transactions do
    Repo.all(Transaction)
  end

  def list_today_transactions do
    date = Timex.now()

    Transaction
    |> join(:left, [a], u in "tbl_account", on: a.userId == u.userId)
    |> join(:left, [a], uB in "tbl_user_bio_data", on: a.userId == uB.userId)
    |> order_by([a, u, uB], desc: a.inserted_at)
    |> where(
      [a, u, uB],
      a.inserted_at >= ^Timex.beginning_of_day(date) and a.inserted_at <= ^Timex.end_of_day(date)
    )
    |> select([a, u, uB], %{
      accountNo: u.accountNo,
      totalAmount: a.totalAmount,
      productType: a.productType,
      referenceNo: a.referenceNo,
      orderRef: a.orderRef,
      transactionType: a.transactionType,
      status: a.status,
      inserted_at: u.inserted_at,
      firstName: uB.firstName,
      lastName: uB.lastName,
      customerName: a.customerName
    })
    |> Repo.all()
  end

  def list_transactions do
    Transaction
    |> join(:left, [a], u in "tbl_account", on: a.userId == u.userId)
    |> join(:left, [a], uB in "tbl_user_bio_data", on: a.userId == uB.userId)
    |> join(:left, [a], p in "tbl_products", on: a.productId == p.id)
    |> select([a, u, uB, p], %{
      accountNo: u.accountNo,
      totalAmount: a.totalAmount,
      productType: a.productType,
      referenceNo: a.referenceNo,
      orderRef: a.orderRef,
      transactionType: a.transactionType,
      transactionDetail: a.transactionDetail,
      transactionTypeEnum: a.transactionTypeEnum,
      status: a.status,
      inserted_at: u.inserted_at,
      firstName: uB.firstName,
      lastName: uB.lastName,
      productName: p.name,
      currency: a.currency,
      newTotalBalance: a.newTotalBalance
    })
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single transaction.

  Raises `Ecto.NoResultsError` if the Transaction does not exist.

  ## Examples

      iex> get_transaction!(123)
      %Transaction{}

      iex> get_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_transaction!(id), do: Repo.get!(Transaction, id)

  @doc """
  Creates a transaction.

  ## Examples

      iex> create_transaction(%{field: value})
      {:ok, %Transaction{}}

      iex> create_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_transaction(attrs \\ %{}) do
    %Transaction{}
    |> Transaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a transaction.

  ## Examples

      iex> update_transaction(transaction, %{field: new_value})
      {:ok, %Transaction{}}

      iex> update_transaction(transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_transaction(%Transaction{} = transaction, attrs) do
    transaction
    |> Transaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a transaction.

  ## Examples

      iex> delete_transaction(transaction)
      {:ok, %Transaction{}}

      iex> delete_transaction(transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_transaction(%Transaction{} = transaction) do
    Repo.delete(transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking transaction changes.

  ## Examples

      iex> change_transaction(transaction)
      %Ecto.Changeset{source: %Transaction{}}

  """
  def change_transaction(%Transaction{} = transaction) do
    Transaction.changeset(transaction, %{})
  end

  def pending_transactions() do
    status = "PENDING"
    query =
      from(au in Savings.Transactions.Transaction,
        where: au.status == type(^status, :string),
        select: au
      )

    transactions = Repo.all(query)
    transactions
  end

  def pending_transactions_update() do
    status = "SUCCESS"

    query =
      from(au in Savings.Transactions.Transaction,
        where: au.status == type(^status, :string),
        select: au
      )

    transactions = Repo.all(query)
    transactions
  end

  # Savings.Transactions.all_customer_txn_data_report(nil, 1, 10)

  def all_customer_txn_data_report(search_params, page, size) do
    Savings.Transactions.Transaction
    |> handle_transaction_report_filter(search_params)
    |> order_by([txn, pro, user_bio], desc: txn.updated_at)
    |> compose_all_customer_txn_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def all_customer_txn_data_report(_source, search_params) do
    Savings.Transactions.Transaction
    |> handle_transaction_report_filter(search_params)
    |> order_by([txn, pro, user_bio], desc: txn.updated_at)
    |> compose_all_customer_txn_report_select()
  end

  defp compose_all_customer_txn_report_select(query) do
    query
    |> join(:left, [txn], pro in Savings.Products.Product, on: txn.productId == pro.id)
    |> join(:left, [txn, pro], user_bio in Savings.Client.UserBioData,
      on: txn.userId == user_bio.userId
    )
    |> select(
      [txn, pro, user_bio],
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
        # product_name: pro.name,
        # product_code: pro.code,
        # product_minimumPeriod: pro.minimumPeriod,
        # product_maximumPeriod: pro.maximumPeriod,
        # product_details: pro.details,
        # product_currencyId: pro.currencyId,
        # product_currencyName: pro.currencyName,
        # pro_currencyDecimals: pro.currencyDecimals,
        # product_interest: pro.interest,
        # product_interestType: pro.interestType,
        # product_interestMode: pro.interestMode,
        # product_defaultPeriod: pro.defaultPeriod,
        # product_periodType: pro.periodType,
        # productType: pro.productType,
        # product_minimumPrincipal: pro.minimumPrincipal,
        # product_maximumPrincipal: pro.maximumPrincipal,
        # product_clientId: pro.clientId,
        # product_yearLengthInDays: pro.yearLengthInDays,
        # product_status: pro.status,
        # product_id: pro.id,
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
        user_bio_clientId: user_bio.clientId
      }
    )
  end

  defp handle_transaction_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_customer_first_name_filter(search_params)
    |> handle_customer_last_name_filter(search_params)
    |> handle_product_name_filter(search_params)
    |> handle_customer_phone_number_filter(search_params)
    |> handle_customer_txn_status_filter(search_params)
    |> handle_transaction_type_filter(search_params)
    |> handle_minimum_principal_filter(search_params)
    |> handle_transaction_date_filter(search_params)
  end

  defp handle_transaction_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_transaction_isearch_filter(query, search_term)
  end

  defp handle_customer_first_name_filter(query, %{
         "txn_customer_first_name" => txn_customer_first_name
       })
       when txn_customer_first_name == "" or is_nil(txn_customer_first_name),
       do: query

  defp handle_customer_first_name_filter(query, %{
         "txn_customer_first_name" => txn_customer_first_name
       }) do
    where(
      query,
      [txn, pro, user_bio],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{txn_customer_first_name}%")
    )
  end

  defp handle_customer_last_name_filter(query, %{
         "txn_customer_last_name" => txn_customer_last_name
       })
       when txn_customer_last_name == "" or is_nil(txn_customer_last_name),
       do: query

  defp handle_customer_last_name_filter(query, %{
         "txn_customer_last_name" => txn_customer_last_name
       }) do
    where(
      query,
      [txn, pro, user_bio],
      fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{txn_customer_last_name}%")
    )
  end

  defp handle_customer_phone_number_filter(query, %{
         "txn_customer_phone_number" => txn_customer_phone_number
       })
       when txn_customer_phone_number == "" or is_nil(txn_customer_phone_number),
       do: query

  defp handle_customer_phone_number_filter(query, %{
         "txn_customer_phone_number" => txn_customer_phone_number
       }) do
    where(
      query,
      [txn, pro, user_bio],
      fragment("lower(?) LIKE lower(?)", user_bio.mobileNumber, ^"%#{txn_customer_phone_number}%")
    )
  end

  defp handle_customer_txn_status_filter(query, %{"customer_txn_status" => customer_txn_status})
       when customer_txn_status == "" or is_nil(customer_txn_status),
       do: query

  defp handle_customer_txn_status_filter(query, %{"customer_txn_status" => customer_txn_status}) do
    where(
      query,
      [txn, pro, user_bio],
      fragment("lower(?) LIKE lower(?)", txn.status, ^"%#{customer_txn_status}%")
    )
  end

  defp handle_product_name_filter(query, %{"txn_product_name" => txn_product_name})
       when txn_product_name == "" or is_nil(txn_product_name),
       do: query

  defp handle_product_name_filter(query, %{"txn_product_name" => txn_product_name}) do
    where(
      query,
      [txn, pro, user_bio],
      fragment("lower(?) LIKE lower(?)", pro.id, ^"%#{txn_product_name}%")
    )
  end

  defp handle_transaction_type_filter(query, %{"transaction_type" => transaction_type})
       when transaction_type == "" or is_nil(transaction_type),
       do: query

  defp handle_transaction_type_filter(query, %{"transaction_type" => transaction_type}) do
    where(
      query,
      [txn, pro, user_bio],
      fragment("lower(?) LIKE lower(?)", txn.transactionType, ^"%#{transaction_type}%")
    )
  end

  defp handle_minimum_principal_filter(query, %{
         "txn_product_minimum_amount" => txn_product_minimum_amount,
         "txn_product_maximum_amount" => txn_product_maximum_amount
       })
       when byte_size(txn_product_minimum_amount) > 0 and
              byte_size(txn_product_maximum_amount) > 0 do
    query
    |> where(
      [txn, pro, user_bio],
      fragment("? >= ?", txn.totalAmount, ^txn_product_minimum_amount) and
        fragment("? <= ?", txn.totalAmount, ^txn_product_maximum_amount)
    )
  end

  defp handle_minimum_principal_filter(query, _params), do: query

  defp handle_transaction_date_filter(query, %{
         "txn_date_from" => txn_date_from,
         "txn_date_to" => txn_date_to
       })
       when byte_size(txn_date_from) > 0 and byte_size(txn_date_to) > 0 do
    query
    |> where(
      [txn, pro, user_bio],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^txn_date_from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^txn_date_to)
    )
  end

  defp handle_transaction_date_filter(query, _params), do: query

  defp compose_transaction_isearch_filter(query, search_term) do
    query
    |> where(
      [txn, pro, user_bio],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", user_bio.otherName, ^search_term)
    )
  end

  def all_customer_data_report(search_params, page, size) do
    Savings.Transactions.Transaction
    |> handle_client_transaction_report_filter(search_params)
    |> order_by([txn, pro, user_bio], desc: txn.updated_at)
    |> compose_all_customer_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def all_customer_data_report(_source, search_params) do
    Savings.Transactions.Transaction
    |> handle_client_transaction_report_filter(search_params)
    |> order_by([txn, pro, user_bio], desc: txn.updated_at)
    |> compose_all_customer_report_select()
  end

  defp compose_all_customer_report_select(query) do
    query
    |> join(:left, [txn], pro in Savings.Products.Product, on: txn.productId == pro.id)
    |> join(:left, [txn, pro], user_bio in Savings.Client.UserBioData,
      on: txn.userId == user_bio.userId
    )
    |> join(:left, [txn, pro, user_bio], user in Savings.Accounts.User, on: txn.userId == user.id)
    |> select(
      [txn, pro, user_bio, user],
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
        user_status: user.status
      }
    )
  end

  # ----------------------------------MIZ-----------------------------------------

  def customer_data_report_deposit_interest(search_params, page, size) do
    Savings.FixedDeposit.FixedDepositTransaction
    |> handle_client_transaction_report_filter(search_params)
    |> order_by([fxd_dep_txn, fdep, txn, user_bio, user, pro], desc: txn.updated_at)
    |> customer_data_report_deposit_interest_customer_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def customer_data_report_deposit_interest(_source, search_params) do
    Savings.FixedDeposit.FixedDepositTransaction
    |> handle_client_transaction_report_filter(search_params)
    |> order_by([fxd_dep_txn, fdep, txn, user_bio, user, pro], desc: txn.updated_at)
    |> customer_data_report_deposit_interest_customer_report_select()
  end

  defp customer_data_report_deposit_interest_customer_report_select(query) do
    query
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
  end






  #00000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000

  def customer_data_report_deposit_summary(search_params, page, size) do
    Savings.FixedDeposit.FixedDepositTransaction
    |> handle_client_transaction_report_filter(search_params)
    |> order_by([fxd_dep_txn, fdep, txn, user_bio, user, pro], desc: txn.updated_at)
    |> customer_data_report_deposit_summary_customer_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def customer_data_report_deposit_summary(_source, search_params) do
    Savings.FixedDeposit.FixedDepositTransaction
    |> handle_client_transaction_report_filter(search_params)
    |> order_by([fxd_dep_txn, fdep, txn, user_bio, user, pro], desc: txn.updated_at)
    |> customer_data_report_deposit_summary_customer_report_select()
  end

  defp customer_data_report_deposit_summary_customer_report_select(query) do
    query
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
  end


  defp handle_client_transaction_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_client_first_name_filter(search_params)
    |> handle_client_last_name_filter(search_params)
    # |> handle_product_name_filter(search_params)
    |> handle_client_phone_number_filter(search_params)
    |> handle_client_txn_status_filter(search_params)
    # |> handle_client_transaction_type_filter(search_params)
    |> handle_client_minimum_principal_filter(search_params)
    |> handle_client_transaction_date_filter(search_params)
  end

  defp handle_client_transaction_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_client_transaction_isearch_filter(query, search_term)
  end

  defp compose_client_transaction_isearch_filter(query, search_term) do
    query
    |> where(
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
        fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", user_bio.otherName, ^search_term)
    )
  end

  def all_customer_liquid_data_report(search_params, page, size) do
    Savings.FixedDeposit.FixedDepositTransaction
    |> handle_client_liquid_report_filter(search_params)
    |> order_by([txn, pro, user_bio], desc: txn.updated_at)
    |> compose_all_liquid_customer_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def all_customer_liquid_data_report(_source, search_params) do
    Savings.FixedDeposit.FixedDepositTransaction
    |> handle_client_liquid_report_filter(search_params)
    |> order_by([txn, pro, user_bio], desc: txn.updated_at)
    |> compose_all_liquid_customer_report_select()
  end

  defp compose_all_liquid_customer_report_select(query) do
    query
    |> join(:left, [fxd_dep_txn], fdep in Savings.FixedDeposit.FixedDeposits, on: fxd_dep_txn.fixedDepositId == fdep.id)
    |> join(:left, [fxd_dep_txn, fdep], txn in Savings.Transactions.Transaction, on: fxd_dep_txn.transactionId == txn.id)
    |> join(:left, [fxd_dep_txn, fdep, txn], user_bio in Savings.Client.UserBioData, on: fxd_dep_txn.userId == user_bio.userId)
    |> join(:left, [fxd_dep_txn, fdep, txn, user_bio], user in Savings.Accounts.User, on: fxd_dep_txn.userId == user.id)
    |> join(:left, [fxd_dep_txn, fdep, txn, user_bio, user], pro in Savings.Products.Product, on: fdep.productId == pro.id)
    |> where([fxd_dep_txn, fdep, txn, user_bio, user, pro], txn.transactionTypeEnum == ^"DIVESTMENT")
    |> select([fxd_dep_txn, fdep, txn, user_bio, user, pro],
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
  end

  defp handle_client_liquid_report_filter(query, %{"isearch" => search_term} = search_params)
    when search_term == "" or is_nil(search_term) do
      query
      |> handle_client_first_name_filter(search_params)
      |> handle_client_last_name_filter(search_params)
      # |> handle_product_name_filter(search_params)
      |> handle_client_phone_number_filter(search_params)
      |> handle_client_txn_status_filter(search_params)
      # |> handle_client_transaction_type_filter(search_params)
      |> handle_client_minimum_principal_filter(search_params)
      |> handle_client_transaction_date_filter(search_params)
  end

  defp handle_client_liquid_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_client_liquid_isearch_filter(query, search_term)
  end

  defp compose_client_liquid_isearch_filter(query, search_term) do
    query
    |> where(
      [txn, pro, user_bio, user, fldep],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", user_bio.otherName, ^search_term)
    )
  end

  # ---------------------------------------END-----------------------------------------------


  defp handle_client_first_name_filter(query, %{"txn_client_first_name" => txn_client_first_name})
       when txn_client_first_name == "" or is_nil(txn_client_first_name),
       do: query

  defp handle_client_first_name_filter(query, %{"txn_client_first_name" => txn_client_first_name}) do
    where(
      query,
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{txn_client_first_name}%")
    )
  end

  defp handle_client_last_name_filter(query, %{"txn_client_last_name" => txn_client_last_name})
       when txn_client_last_name == "" or is_nil(txn_client_last_name),
       do: query

  defp handle_client_last_name_filter(query, %{"txn_client_last_name" => txn_client_last_name}) do
    where(
      query,
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
      fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{txn_client_last_name}%")
    )
  end

  defp handle_client_phone_number_filter(query, %{
         "txn_client_phone_number" => txn_client_phone_number
       })
       when txn_client_phone_number == "" or is_nil(txn_client_phone_number),
       do: query

  defp handle_client_phone_number_filter(query, %{
         "txn_client_phone_number" => txn_client_phone_number
       }) do
    where(
      query,
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
      fragment("lower(?) LIKE lower(?)", user_bio.mobileNumber, ^"%#{txn_client_phone_number}%")
    )
  end

  defp handle_client_txn_status_filter(query, %{"client_txn_status" => client_txn_status})
       when client_txn_status == "" or is_nil(client_txn_status),
       do: query

  defp handle_client_txn_status_filter(query, %{"client_txn_status" => client_txn_status}) do
    where(
      query,
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
      fragment("lower(?) LIKE lower(?)", txn.status, ^"%#{client_txn_status}%")
    )
  end

  defp handle_product_name_filter(query, %{"txn_product_name" => txn_product_name})
       when txn_product_name == "" or is_nil(txn_product_name),
       do: query

  defp handle_product_name_filter(query, %{"txn_product_name" => txn_product_name}) do
    where(
      query,
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
      fragment("lower(?) LIKE lower(?)", pro.id, ^"%#{txn_product_name}%")
    )
  end

  defp handle_client_transaction_type_filter(query, %{"transaction_type" => transaction_type})
       when transaction_type == "" or is_nil(transaction_type),
       do: query

  defp handle_client_transaction_type_filter(query, %{"transaction_type" => transaction_type}) do
    where(
      query,
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
      fragment("lower(?) LIKE lower(?)", txn.transactionType, ^"%#{transaction_type}%")
    )
  end

  defp handle_client_minimum_principal_filter(query, %{
         "txn_product_minimum_amount" => txn_product_minimum_amount,
         "txn_product_maximum_amount" => txn_product_maximum_amount
       })
       when byte_size(txn_product_minimum_amount) > 0 and
              byte_size(txn_product_maximum_amount) > 0 do
    query
    |> where(
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
      fragment("? >= ?", txn.totalAmount, type(^txn_product_minimum_amount, :float)) and
        fragment("? <= ?", txn.totalAmount, type(^txn_product_maximum_amount, :float))
    )
  end

  defp handle_client_minimum_principal_filter(query, _params), do: query

  defp handle_client_transaction_date_filter(query, %{
         "txn_date_from" => txn_date_from,
         "txn_date_to" => txn_date_to
       })
       when byte_size(txn_date_from) > 0 and byte_size(txn_date_to) > 0 do
    query
    |> where(
      [fxd_dep_txn, fdep, txn, user_bio, user, pro],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^txn_date_from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^txn_date_to)
    )
  end

  defp handle_client_transaction_date_filter(query, _params), do: query


  # Savings.Accounts.get_all_customer_details()

  def get_all_customer_details() do
    Savings.Accounts.User
    |> join(:left, [a], u in Savings.Client.UserBioData, on: a.id == u.userId)
    |> join(:left, [a, u], ro in Savings.Accounts.UserRole, on: u.userId == ro.userId)
    |> join(:left, [a, u, ro], acc in Savings.Accounts.Account, on: ro.userId == acc.userId)
    |> where([a, u, ro, acc], ro.userId == acc.userId)
    |> select([a, u, ro, acc], %{
      # accountType: a.accountType,
      # userId: a.userId,
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
      account_status: acc.status
    })
    |> Repo.all()
  end

  # Savings.Transactions.get_all_clients_txn_details(nil, 1, 10)

  # Hello Get All TXN

  def get_all_clients_txn_details(search_params, page, size) do
    Savings.Transactions.Transaction
    |> handle_txn_report_filter(search_params)
    |> order_by([txn, user_bio, acc], desc: txn.inserted_at)
    |> compose_customer_txn_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def product_list(_source, search_params) do
    Savings.Transactions.Transaction
    |> handle_txn_report_filter(search_params)
    |> order_by([txn, user_bio, acc], desc: txn.inserted_at)
    |> compose_customer_txn_list()
  end

  defp compose_customer_txn_list(query) do
    query
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
        # deposited_amount: fldep.principalAmount,
        account_status: acc.status,
        account_number: acc.accountNo,
        product_name: pro.name,
        product_code: pro.code
      }
    )
  end

  defp handle_txn_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_txn_first_name_filter(search_params)
    |> handle_txn_last_name_filter(search_params)
    |> handle_txn_txt_account_no_filter(search_params)
    |> handle_txn_phone_filter(search_params)
    |> handle_txn_type_filter(search_params)
    |> handle_txn_status_filter(search_params)
    |> handle_txn_txt_date_filter(search_params)
  end

  defp handle_txn_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_txn_isearch_filter(query, search_term)
  end

  defp handle_txn_first_name_filter(query, %{"customer_first_name" => customer_first_name}) do
    where(
      query,
      [txn, user_bio, acc, pro],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{customer_first_name}%")
    )
  end

  defp handle_txn_first_name_filter(query, %{"customer_first_name" => customer_first_name})
       when customer_first_name == "" or is_nil(customer_first_name),
       do: query

  defp handle_txn_last_name_filter(query, %{"customer_last_name" => customer_last_name}) do
    where(
      query,
      [txn, user_bio, acc, pro],
      fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{customer_last_name}%")
    )
  end

  defp handle_txn_last_name_filter(query, %{"customer_last_name" => customer_last_name})
       when customer_last_name == "" or is_nil(customer_last_name),
       do: query

  defp handle_txn_customer_id_filter(query, %{"customer_id_num" => customer_id_num}) do
    where(
      query,
      [txn, user_bio, acc, pro],
      fragment(
        "lower(?) LIKE lower(?)",
        user_bio.meansOfIdentificationNumber,
        ^"%#{customer_id_num}%"
      )
    )
  end

  defp handle_txn_customer_id_filter(query, %{"customer_id_num" => customer_id_num})
       when customer_id_num == "" or is_nil(customer_id_num),
       do: query

  defp handle_txn_txt_account_no_filter(query, %{"customer_acc_num" => customer_acc_num}) do
    where(
      query,
      [txn, user_bio, acc, pro],
      fragment("lower(?) LIKE lower(?)", acc.accountNo, ^"%#{customer_acc_num}%")
    )
  end

  defp handle_txn_txt_account_no_filter(query, %{"customer_acc_num" => customer_acc_num})
       when customer_acc_num == "" or is_nil(customer_acc_num),
       do: query

  defp handle_txn_phone_filter(query, %{"customer_phone_num" => customer_phone_num}) do
    where(
      query,
      [txn, user_bio, acc, pro],
      fragment("lower(?) LIKE lower(?)", user_bio.mobileNumber, ^"%#{customer_phone_num}%")
    )
  end

  defp handle_txn_phone_filter(query, %{"customer_phone_num" => customer_phone_num})
       when customer_phone_num == "" or is_nil(customer_phone_num),
       do: query

  defp handle_txn_type_filter(query, %{"txn_type" => txn_type}) do
    where(
      query,
      [txn, user_bio, acc, pro],
      fragment("lower(?) LIKE lower(?)", txn.transactionTypeEnum, ^"%#{txn_type}%")
    )
  end

  defp handle_txn_type_filter(query, %{"txn_type" => txn_type})
       when txn_type == "" or is_nil(txn_type),
       do: query

  defp handle_txn_status_filter(query, %{"txn_status" => txn_status}) do
    where(
      query,
      [txn, user_bio, acc, pro],
      fragment("lower(?) LIKE lower(?)", txn.status, ^"%#{txn_status}%")
    )
  end

  defp handle_txn_status_filter(query, %{"txn_status" => txn_status})
       when txn_status == "" or is_nil(txn_status),
       do: query

  defp handle_txn_txt_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [txn, user_bio, acc, pro],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^to)
    )
  end

  defp handle_txn_txt_date_filter(query, _params), do: query

  defp compose_txn_isearch_filter(query, search_term) do
    query
    |> where(
      [txn, user_bio, acc, pro],
      fragment("lower(?) LIKE lower(?)", txn.productId, ^search_term) or
        fragment("lower(?) LIKE lower(?)", acc.accountNo, ^search_term)
    )
  end

  # Savings.Transactions.get_all_clients_full_withdraws_details(nil, 1, 10)
  # Russ here

  def get_all_clients_full_divestment_withdraws(search_params, page, size) do
    Savings.Divestments.DivestmentTransaction
    |> handle_full_divestment_report_filter(search_params)
    |> order_by([fxd_txn, txn], desc: txn.inserted_at)
    |> compose_customer_full_divestment_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def get_all_clients_full_divestment_withdraws(_source, search_params) do
    Savings.Divestments.DivestmentTransaction
    |> handle_full_divestment_report_filter(search_params)
    |> order_by([fxd_txn, txn], desc: txn.inserted_at)
    |> compose_customer_full_divestment_list()
  end

  defp compose_customer_full_divestment_list(query) do
    query
    |> join(:left, [dive_txn], dive in Savings.Divestments.Divestment,
      on: dive_txn.divestmentId == dive.id
    )
    |> join(:left, [dive_txn, dive], fldep in Savings.FixedDeposit.FixedDeposits,
      on: dive.fixedDepositId == fldep.id
    )
    |> join(:left, [dive_txn, dive, fldep], txn in Savings.Transactions.Transaction,
      on: dive_txn.transactionId == txn.id
    )
    |> join(:left, [dive_txn, dive, fldep, txn], user_bio in Savings.Client.UserBioData,
      on: txn.userId == user_bio.userId
    )
    |> join(:left, [dive_txn, dive, fldep, txn, user_bio], acc in Savings.Accounts.Account,
      on: user_bio.userId == acc.userId
    )
    |> where(
      [dive_txn, dive, fldep, txn, user_bio, acc],
      dive.divestmentType == "Full Divestment" or dive.divestmentType == "FULL DIVESTMENT"
    )
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

        # txn_accountId: txn.accountId,
        txn_totalAmount: txn.totalAmount,
        # txn_productId: txn.productId,
        # txn_productType: txn.productType,
        # txn_userId: txn.userId,
        # txn_userRoleId: txn.userRoleId,
        # txn_referenceNo: txn.referenceNo,
        # txn_orderRef: txn.orderRef,
        # txn_transactionType: txn.transactionType,
        txn_status: txn.status,
        # txn_isReversed: txn.isReversed,
        # txn_requestData: txn.requestData,
        # txn_responseData: txn.responseData,
        # txn_carriedOutByUserId: txn.carriedOutByUserId,
        # txn_carriedOutByUserRoleId: txn.carriedOutByUserRoleId,
        # txn_transactionTypeEnum: txn.transactionTypeEnum,
        # txn_transactionDetail: txn.transactionDetail,
        # txn_newTotalBalance: txn.newTotalBalance,
        # txn_currencyDecimals: txn.currencyDecimals,
        # txn_currency: txn.currency,
        txn_customerName: txn.customerName,
        # txn_inserted_at: txn.inserted_at,
        # txn_updated_at: txn.updated_at

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
  end

  defp handle_full_divestment_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_full_divest_withdraw_first_name_filter(search_params)
    |> handle_full_divest_withdraw_last_name_filter(search_params)
    |> handle_full_divest_withdraw_txt_account_no_filter(search_params)
    |> handle_full_divest_withdraw_phone_filter(search_params)
    |> handle_full_divest_withdraw_customer_id_filter(search_params)
    |> handle_full_div_txn_status_filter(search_params)
    |> handle_full_divest_withdraw_txt_date_filter(search_params)
  end

  defp handle_full_divestment_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_txn_isearch_filter(query, search_term)
  end

  defp handle_full_divest_withdraw_first_name_filter(query, %{
         "customer_first_name" => customer_first_name
       }) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{customer_first_name}%")
    )
  end

  defp handle_full_divest_withdraw_first_name_filter(query, %{
         "customer_first_name" => customer_first_name
       })
       when customer_first_name == "" or is_nil(customer_first_name),
       do: query

  defp handle_full_divest_withdraw_last_name_filter(query, %{
         "customer_last_name" => customer_last_name
       }) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{customer_last_name}%")
    )
  end

  defp handle_full_divest_withdraw_last_name_filter(query, %{
         "customer_last_name" => customer_last_name
       })
       when customer_last_name == "" or is_nil(customer_last_name),
       do: query

  defp handle_full_divest_withdraw_customer_id_filter(query, %{
         "customer_id_num" => customer_id_num
       }) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment(
        "lower(?) LIKE lower(?)",
        user_bio.meansOfIdentificationNumber,
        ^"%#{customer_id_num}%"
      )
    )
  end

  defp handle_full_divest_withdraw_customer_id_filter(query, %{
         "customer_id_num" => customer_id_num
       })
       when customer_id_num == "" or is_nil(customer_id_num),
       do: query

  defp handle_full_divest_withdraw_txt_account_no_filter(query, %{
         "customer_acc_num" => customer_acc_num
       }) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", acc.accountNo, ^"%#{customer_acc_num}%")
    )
  end

  defp handle_full_divest_withdraw_txt_account_no_filter(query, %{
         "customer_acc_num" => customer_acc_num
       })
       when customer_acc_num == "" or is_nil(customer_acc_num),
       do: query

  defp handle_full_divest_withdraw_phone_filter(query, %{
         "customer_phone_num" => customer_phone_num
       }) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.mobileNumber, ^"%#{customer_phone_num}%")
    )
  end

  defp handle_full_divest_withdraw_phone_filter(query, %{
         "customer_phone_num" => customer_phone_num
       })
       when customer_phone_num == "" or is_nil(customer_phone_num),
       do: query

  defp handle_full_div_txn_status_filter(query, %{"txn_status" => txn_status}) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", txn.status, ^"%#{txn_status}%")
    )
  end

  defp handle_full_div_txn_status_filter(query, %{"txn_status" => txn_status})
       when txn_status == "" or is_nil(txn_status),
       do: query

  defp handle_full_divest_withdraw_txt_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^to)
    )
  end

  defp handle_full_divest_withdraw_txt_date_filter(query, _params), do: query

  defp compose_full_divest_withdraw_isearch_filter(query, search_term) do
    query
    |> where(
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", txn.productId, ^search_term) or
        fragment("lower(?) LIKE lower(?)", acc.accountNo, ^search_term)
    )
  end

  # Savings.Transactions.get_all_clients_full_withdraws_details(nil, 1, 10)

  def get_all_clients_fixed_deposits_details(search_params, page, size) do
    Savings.Transactions.Transaction
    |> handle_full_withdraws_report_filter(search_params)
    |> order_by([txn, pro, user_bio, user, fldep, acc], desc: txn.inserted_at)
    |> compose_customer_full_withdraws_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def get_all_clients_fixed_deposits_details(_source, search_params) do
    Savings.Transactions.Transaction
    |> handle_full_withdraws_report_filter(search_params)
    |> order_by([txn, pro, user_bio, user, fldep, acc], desc: txn.inserted_at)
    |> compose_customer_full_withdraws_list()
  end

  defp compose_customer_full_withdraws_list(query) do
    query
    |> join(:left, [txn], pro in Savings.Products.Product, on: txn.productId == pro.id)
    |> join(:left, [txn, pro], user_bio in Savings.Client.UserBioData,
      on: txn.userId == user_bio.userId
    )
    |> join(:left, [txn, pro, user_bio], user in Savings.Accounts.User, on: txn.userId == user.id)
    |> join(:left, [txn, pro, user_bio, user], fldep in Savings.FixedDeposit.FixedDeposits,
      on: user.id == user.id
    )
    |> join(:left, [txn, pro, user_bio, user, fldep], acc in Savings.Accounts.Account,
      on: fldep.userId == acc.userId
    )
    |> where([txn, pro, user_bio, user, fldep, acc], fldep.isWithdrawn == true)
    |> select(
      [txn, pro, user_bio, user, fldep, acc],
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
        user_status: user.status,
        fldep_startDate: fldep.startDate,
        fldep_endDate: fldep.endDate,
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
        deposited_amount: fldep.principalAmount,
        account_status: acc.status,
        account_number: acc.accountNo
      }
    )
  end

  defp handle_full_withdraws_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_full_withdraws_first_name_filter(search_params)
    |> handle_full_withdraws_last_name_filter(search_params)
    |> handle_full_withdraws_txt_account_no_filter(search_params)
    |> handle_full_withdraws_phone_filter(search_params)
    |> handle_full_withdraws_customer_id_filter(search_params)
    |> handle_full_withdraws_txt_date_filter(search_params)
  end

  defp handle_full_withdraws_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_txn_isearch_filter(query, search_term)
  end

  defp handle_full_withdraws_first_name_filter(query, %{
         "customer_first_name" => customer_first_name
       }) do
    where(
      query,
      [txn, pro, user_bio, user, fldep, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{customer_first_name}%")
    )
  end

  defp handle_full_withdraws_first_name_filter(query, %{
         "customer_first_name" => customer_first_name
       })
       when customer_first_name == "" or is_nil(customer_first_name),
       do: query

  defp handle_full_withdraws_last_name_filter(query, %{"customer_last_name" => customer_last_name}) do
    where(
      query,
      [txn, pro, user_bio, user, fldep, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{customer_last_name}%")
    )
  end

  defp handle_full_withdraws_last_name_filter(query, %{"customer_last_name" => customer_last_name})
       when customer_last_name == "" or is_nil(customer_last_name),
       do: query

  defp handle_full_withdraws_customer_id_filter(query, %{"customer_id_num" => customer_id_num}) do
    where(
      query,
      [txn, pro, user_bio, user, fldep, acc],
      fragment(
        "lower(?) LIKE lower(?)",
        user_bio.meansOfIdentificationNumber,
        ^"%#{customer_id_num}%"
      )
    )
  end

  defp handle_full_withdraws_customer_id_filter(query, %{"customer_id_num" => customer_id_num})
       when customer_id_num == "" or is_nil(customer_id_num),
       do: query

  defp handle_full_withdraws_txt_account_no_filter(query, %{
         "customer_acc_num" => customer_acc_num
       }) do
    where(
      query,
      [txn, pro, user_bio, user, fldep, acc],
      fragment("lower(?) LIKE lower(?)", acc.accountNo, ^"%#{customer_acc_num}%")
    )
  end

  defp handle_full_withdraws_txt_account_no_filter(query, %{
         "customer_acc_num" => customer_acc_num
       })
       when customer_acc_num == "" or is_nil(customer_acc_num),
       do: query

  defp handle_full_withdraws_phone_filter(query, %{"customer_phone_num" => customer_phone_num}) do
    where(
      query,
      [txn, pro, user_bio, user, fldep, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.mobileNumber, ^"%#{customer_phone_num}%")
    )
  end

  defp handle_full_withdraws_phone_filter(query, %{"customer_phone_num" => customer_phone_num})
       when customer_phone_num == "" or is_nil(customer_phone_num),
       do: query

  defp handle_full_withdraws_txt_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [txn, pro, user_bio, user, fldep, acc],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^to)
    )
  end

  defp handle_full_withdraws_txt_date_filter(query, _params), do: query

  defp compose_full_withdraws_isearch_filter(query, search_term) do
    query
    |> where(
      [txn, pro, user_bio, user, fldep, acc],
      fragment("lower(?) LIKE lower(?)", txn.productId, ^search_term) or
        fragment("lower(?) LIKE lower(?)", acc.accountNo, ^search_term)
    )
  end

  # Savings.Transactions.get_all_clients_fixed_deposits(nil, 1, 10)

  def get_all_clients_fixed_deposits(search_params, page, size) do
    Savings.FixedDeposit.FixedDepositTransaction
    |> handle_fixed_deposits_report_filter(search_params)
    |> order_by([fxd_dep_txn, fxd_dep, txn, acc, user_bio], desc: txn.inserted_at)
    |> compose_customer_fixed_deposits_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def get_all_clients_fixed_deposits(_source, search_params) do
    Savings.FixedDeposit.FixedDepositTransaction
    |> handle_fixed_deposits_report_filter(search_params)
    |> order_by([fxd_dep_txn, fxd_dep, txn, acc, user_bio], desc: txn.inserted_at)
    |> compose_customer_fixed_deposits_list()
  end

  defp compose_customer_fixed_deposits_list(query) do
    query
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
  end

  defp handle_fixed_deposits_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_fixed_deposits_first_name_filter(search_params)
    |> handle_fixed_deposits_last_name_filter(search_params)
    |> handle_fixed_deposits_phone_filter(search_params)
    |> handle_fixed_deposits_txn_status_filter(search_params)
    |> handle_fixed_deposits_txt_date_filter(search_params)
  end

  defp handle_fixed_deposits_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_txn_isearch_filter(query, search_term)
  end

  defp handle_fixed_deposits_first_name_filter(query, %{
         "customer_first_name" => customer_first_name
       }) do
    where(
      query,
      [fxd_dep_txn, fxd_dep, txn, acc, user_bio],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{customer_first_name}%")
    )
  end

  defp handle_fixed_deposits_first_name_filter(query, %{
         "customer_first_name" => customer_first_name
       })
       when customer_first_name == "" or is_nil(customer_first_name),
       do: query

  defp handle_fixed_deposits_last_name_filter(query, %{"customer_last_name" => customer_last_name}) do
    where(
      query,
      [fxd_dep_txn, fxd_dep, txn, acc, user_bio],
      fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{customer_last_name}%")
    )
  end

  defp handle_fixed_deposits_last_name_filter(query, %{"customer_last_name" => customer_last_name})
       when customer_last_name == "" or is_nil(customer_last_name),
       do: query

  defp handle_fixed_deposits_customer_id_filter(query, %{"customer_id_num" => customer_id_num}) do
    where(
      query,
      [fxd_dep_txn, fxd_dep, txn, acc, user_bio],
      fragment(
        "lower(?) LIKE lower(?)",
        user_bio.meansOfIdentificationNumber,
        ^"%#{customer_id_num}%"
      )
    )
  end

  defp handle_fixed_deposits_customer_id_filter(query, %{"customer_id_num" => customer_id_num})
       when customer_id_num == "" or is_nil(customer_id_num),
       do: query

  defp handle_fixed_deposits_txt_account_no_filter(query, %{
         "customer_acc_num" => customer_acc_num
       }) do
    where(
      query,
      [fxd_dep_txn, fxd_dep, txn, acc, user_bio],
      fragment("lower(?) LIKE lower(?)", acc.accountNo, ^"%#{customer_acc_num}%")
    )
  end

  defp handle_fixed_deposits_txt_account_no_filter(query, %{
         "customer_acc_num" => customer_acc_num
       })
       when customer_acc_num == "" or is_nil(customer_acc_num),
       do: query

  defp handle_fixed_deposits_phone_filter(query, %{"customer_phone_num" => customer_phone_num}) do
    where(
      query,
      [fxd_dep_txn, fxd_dep, txn, acc, user_bio],
      fragment("lower(?) LIKE lower(?)", user_bio.mobileNumber, ^"%#{customer_phone_num}%")
    )
  end

  defp handle_fixed_deposits_txn_status_filter(query, %{"txn_status" => txn_status}) do
    where(
      query,
      [fxd_dep_txn, fxd_dep, txn, acc, user_bio],
      fragment("lower(?) LIKE lower(?)", txn.status, ^"%#{txn_status}%")
    )
  end

  defp handle_fixed_deposits_txn_status_filter(query, %{"txn_status" => txn_status})
       when txn_status == "" or is_nil(txn_status),
       do: query

  defp handle_fixed_deposits_phone_filter(query, %{"customer_phone_num" => customer_phone_num})
       when customer_phone_num == "" or is_nil(customer_phone_num),
       do: query

  defp handle_fixed_deposits_txt_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [fxd_dep_txn, fxd_dep, txn, acc, user_bio],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^to)
    )
  end

  defp handle_fixed_deposits_txt_date_filter(query, _params), do: query

  defp compose_fixed_deposits_isearch_filter(query, search_term) do
    query
    |> where(
      [fxd_dep_txn, fxd_dep, txn, acc, user_bio],
      fragment("lower(?) LIKE lower(?)", txn.productId, ^search_term) or
        fragment("lower(?) LIKE lower(?)", acc.accountNo, ^search_term)
    )
  end

  # Savings.Transactions.get_all_clients_partial_withdraws_details(nil, 1, 10)

  def get_all_clients_partial_withdraws_details(search_params, page, size) do
    Savings.Divestments.DivestmentTransaction
    |> handle_partial_withdraws_report_filter(search_params)
    |> order_by([dive_txn, dive, fldep, txn, user_bio, acc], desc: txn.inserted_at)
    |> compose_customer_partial_withdraws_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def get_all_clients_partial_withdraws_details(_source, search_params) do
    Savings.Divestments.DivestmentTransaction
    |> handle_partial_withdraws_report_filter(search_params)
    |> order_by([dive_txn, dive, fldep, txn, user_bio, acc], desc: txn.inserted_at)
    |> compose_customer_partial_withdraws_list()
  end

  defp compose_customer_partial_withdraws_list(query) do
    query
    |> join(:left, [dive_txn], dive in Savings.Divestments.Divestment,
      on: dive_txn.divestmentId == dive.id
    )
    |> join(:left, [dive_txn, dive], fldep in Savings.FixedDeposit.FixedDeposits,
      on: dive.fixedDepositId == fldep.id
    )
    |> join(:left, [dive_txn, dive, fldep], txn in Savings.Transactions.Transaction,
      on: dive_txn.transactionId == txn.id
    )
    |> join(:left, [dive_txn, dive, fldep, txn], user_bio in Savings.Client.UserBioData,
      on: txn.userId == user_bio.userId
    )
    |> join(:left, [dive_txn, dive, fldep, txn, user_bio], acc in Savings.Accounts.Account,
      on: user_bio.userId == acc.userId
    )
    |> where(
      [dive_txn, dive, fldep, txn, user_bio, acc],
      dive.divestmentType == "Partial Divestment" or dive.divestmentType == "PARTIAL DIVESTMENT"
    )
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

        # txn_accountId: txn.accountId,
        txn_totalAmount: txn.totalAmount,
        # txn_productId: txn.productId,
        # txn_productType: txn.productType,
        # txn_userId: txn.userId,
        # txn_userRoleId: txn.userRoleId,
        # txn_referenceNo: txn.referenceNo,
        # txn_orderRef: txn.orderRef,
        # txn_transactionType: txn.transactionType,
        txn_status: txn.status,
        # txn_isReversed: txn.isReversed,
        # txn_requestData: txn.requestData,
        # txn_responseData: txn.responseData,
        # txn_carriedOutByUserId: txn.carriedOutByUserId,
        # txn_carriedOutByUserRoleId: txn.carriedOutByUserRoleId,
        # txn_transactionTypeEnum: txn.transactionTypeEnum,
        # txn_transactionDetail: txn.transactionDetail,
        # txn_newTotalBalance: txn.newTotalBalance,
        # txn_currencyDecimals: txn.currencyDecimals,
        # txn_currency: txn.currency,
        txn_customerName: txn.customerName,
        # txn_inserted_at: txn.inserted_at,
        # txn_updated_at: txn.updated_at

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
  end

  defp handle_partial_withdraws_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_partial_withdraws_first_name_filter(search_params)
    |> handle_partial_withdraws_last_name_filter(search_params)
    |> handle_partial_withdraws_txt_account_no_filter(search_params)
    |> handle_partial_withdraws_phone_filter(search_params)
    |> handle_partial_withdraws_customer_id_filter(search_params)
    |> handle_partial_divestment_txn_status_filter(search_params)
    |> handle_partial_withdraws_txt_date_filter(search_params)
  end

  defp handle_partial_withdraws_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_txn_isearch_filter(query, search_term)
  end

  defp handle_partial_withdraws_first_name_filter(query, %{
         "customer_first_name" => customer_first_name
       }) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{customer_first_name}%")
    )
  end

  defp handle_partial_withdraws_first_name_filter(query, %{
         "customer_first_name" => customer_first_name
       })
       when customer_first_name == "" or is_nil(customer_first_name),
       do: query

  defp handle_partial_withdraws_last_name_filter(query, %{
         "customer_last_name" => customer_last_name
       }) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{customer_last_name}%")
    )
  end

  defp handle_partial_withdraws_last_name_filter(query, %{
         "customer_last_name" => customer_last_name
       })
       when customer_last_name == "" or is_nil(customer_last_name),
       do: query

  defp handle_partial_withdraws_customer_id_filter(query, %{"customer_id_num" => customer_id_num}) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment(
        "lower(?) LIKE lower(?)",
        user_bio.meansOfIdentificationNumber,
        ^"%#{customer_id_num}%"
      )
    )
  end

  defp handle_partial_withdraws_customer_id_filter(query, %{"customer_id_num" => customer_id_num})
       when customer_id_num == "" or is_nil(customer_id_num),
       do: query

  defp handle_partial_withdraws_txt_account_no_filter(query, %{
         "customer_acc_num" => customer_acc_num
       }) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", acc.accountNo, ^"%#{customer_acc_num}%")
    )
  end

  defp handle_partial_withdraws_txt_account_no_filter(query, %{
         "customer_acc_num" => customer_acc_num
       })
       when customer_acc_num == "" or is_nil(customer_acc_num),
       do: query

  defp handle_partial_withdraws_phone_filter(query, %{"customer_phone_num" => customer_phone_num}) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.mobileNumber, ^"%#{customer_phone_num}%")
    )
  end

  defp handle_partial_withdraws_phone_filter(query, %{"customer_phone_num" => customer_phone_num})
       when customer_phone_num == "" or is_nil(customer_phone_num),
       do: query

  defp handle_partial_divestment_txn_status_filter(query, %{"txn_status" => txn_status}) do
    where(
      query,
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", txn.status, ^"%#{txn_status}%")
    )
  end

  defp handle_partial_divestment_txn_status_filter(query, %{"txn_status" => txn_status})
       when txn_status == "" or is_nil(txn_status),
       do: query

  defp handle_partial_withdraws_txt_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^to)
    )
  end

  defp handle_partial_withdraws_txt_date_filter(query, _params), do: query

  defp compose_partial_withdraws_isearch_filter(query, search_term) do
    query
    |> where(
      [dive_txn, dive, fldep, txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", txn.productId, ^search_term) or
        fragment("lower(?) LIKE lower(?)", acc.accountNo, ^search_term)
    )
  end

  # Savings.Transactions.count_txn()

  # def count_txn() do
  #   usser_id = 2

  #   query =
  #     from au in Savings.Transactions.Transaction,
  #       where: au.userId == ^usser_id,
  #       select: count(au.id)

  #   userBioData = Repo.one(query)
  #   IO.inspect(userBioData)
  # end

  # def count_txn() do
  #   Savings.Transactions.Transaction
  #   |> where(
  #     [txn], fragment("cast(txn.inserted_at as date)")
  #      == fragment("SELECT CURRENT_DATE")
  #   )
  #   |> select([txn], %{
  #     # accountType: a.accountType,
  #     # userId: a.userId,
  #     inserted_at: txn.inserted_at
  #   })
  #   |> Repo.all()
  # end

  # def count_txn() do
  #   start_date = Timex.beginning_of_day(Timex.now())
  #   start_end = Timex.end_of_day(Timex.now())

  #   Savings.Transactions.Transaction
  #   |> where(
  #     [txn],
  #     txn.inserted_at >= ^start_date and txn.inserted_at <= ^start_end
  #   )
  #   # |> group_by([txn], [txn.inserted_at])
  #   |> select([txn], %{
  #     count_txn: count(txn.id),
  #     total_amount: sum(txn.totalAmount)
  #   })
  #   |> Repo.all()
  # end

  # Savings.Transactions.get_all_clients_withdraws_txn_details(nil, 1, 10)
  # All withdraws on Maturity
  def get_all_clients_withdraws_txn_details(search_params, page, size) do
    Savings.Transactions.Transaction
    |> handle_all_clients_withdraws_txn_report_filter(search_params)
    |> order_by([txn, user_bio, acc], desc: txn.inserted_at)
    |> compose_customer_withdraws_txn_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def get_all_clients_withdraws_txn_details(_source, search_params) do
    Savings.Transactions.Transaction
    |> handle_all_clients_withdraws_txn_report_filter(search_params)
    |> order_by([txn, user_bio, acc], desc: txn.inserted_at)
    |> compose_customer_withdraws_txn_list()
  end

  defp compose_customer_withdraws_txn_list(query) do
    query
    |> join(:left, [txn], user_bio in Savings.Client.UserBioData,
      on: txn.userId == user_bio.userId
    )
    # |> join(:left, [txn, pro, user_bio], user in Savings.Accounts.User, on: txn.userId == user.id)
    # |> join(:left, [txn, pro, user_bio, user], fldep in Savings.FixedDeposit.FixedDeposits,
    #   on: user.id == user.id
    # )
    |> join(:left, [txn, user_bio], acc in Savings.Accounts.Account,
      on: user_bio.userId == acc.userId
    )
    |> join(:left, [txn, user_bio, acc], pro in Savings.Products.Product,
      on: txn.productId == pro.id
    )
    |> where(
      [txn, user_bio, acc, pro],
      txn.transactionTypeEnum == "Withdrawal"
    )
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
        # deposited_amount: fldep.principalAmount,
        account_status: acc.status,
        account_number: acc.accountNo,
        product_name: pro.name,
        product_code: pro.code
      }
    )
  end

  defp handle_all_clients_withdraws_txn_report_filter(
         query,
         %{"isearch" => search_term} = search_params
       )
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_all_clients_withdraws_txn_first_name_filter(search_params)
    |> handle_all_clients_withdraws_txn_last_name_filter(search_params)
    |> handle_all_clients_withdraws_txn_txt_account_no_filter(search_params)
    |> handle_all_clients_withdraws_txn_phone_filter(search_params)
    |> handle_all_clients_withdraws_txn_customer_id_filter(search_params)
    |> handle_all_clients_withdraws_txn_status_filter(search_params)
    |> handle_all_clients_withdraws_txn_txt_date_filter(search_params)
  end

  defp handle_all_clients_withdraws_txn_report_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_txn_isearch_filter(query, search_term)
  end

  defp handle_all_clients_withdraws_txn_first_name_filter(query, %{
         "customer_first_name" => customer_first_name
       }) do
    where(
      query,
      [txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{customer_first_name}%")
    )
  end

  defp handle_all_clients_withdraws_txn_first_name_filter(query, %{
         "customer_first_name" => customer_first_name
       })
       when customer_first_name == "" or is_nil(customer_first_name),
       do: query

  defp handle_all_clients_withdraws_txn_last_name_filter(query, %{
         "customer_last_name" => customer_last_name
       }) do
    where(
      query,
      [txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{customer_last_name}%")
    )
  end

  defp handle_all_clients_withdraws_txn_last_name_filter(query, %{
         "customer_last_name" => customer_last_name
       })
       when customer_last_name == "" or is_nil(customer_last_name),
       do: query

  defp handle_all_clients_withdraws_txn_customer_id_filter(query, %{
         "customer_id_num" => customer_id_num
       }) do
    where(
      query,
      [txn, user_bio, acc],
      fragment(
        "lower(?) LIKE lower(?)",
        user_bio.meansOfIdentificationNumber,
        ^"%#{customer_id_num}%"
      )
    )
  end

  defp handle_all_clients_withdraws_txn_customer_id_filter(query, %{
         "customer_id_num" => customer_id_num
       })
       when customer_id_num == "" or is_nil(customer_id_num),
       do: query

  defp handle_all_clients_withdraws_txn_txt_account_no_filter(query, %{
         "customer_acc_num" => customer_acc_num
       }) do
    where(
      query,
      [txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", acc.accountNo, ^"%#{customer_acc_num}%")
    )
  end

  defp handle_all_clients_withdraws_txn_txt_account_no_filter(query, %{
         "customer_acc_num" => customer_acc_num
       })
       when customer_acc_num == "" or is_nil(customer_acc_num),
       do: query

  defp handle_all_clients_withdraws_txn_phone_filter(query, %{
         "customer_phone_num" => customer_phone_num
       }) do
    where(
      query,
      [txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", user_bio.mobileNumber, ^"%#{customer_phone_num}%")
    )
  end

  defp handle_all_clients_withdraws_txn_phone_filter(query, %{
         "customer_phone_num" => customer_phone_num
       })
       when customer_phone_num == "" or is_nil(customer_phone_num),
       do: query

  defp handle_all_clients_withdraws_txn_status_filter(query, %{"txn_status" => txn_status}) do
    where(
      query,
      [txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", txn.status, ^"%#{txn_status}%")
    )
  end

  defp handle_all_clients_withdraws_txn_status_filter(query, %{"txn_status" => txn_status})
       when txn_status == "" or is_nil(txn_status),
       do: query

  defp handle_all_clients_withdraws_txn_txt_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [txn, user_bio, acc],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^to)
    )
  end

  defp handle_all_clients_withdraws_txn_txt_date_filter(query, _params), do: query

  defp compose_all_clients_withdraws_txn_isearch_filter(query, search_term) do
    query
    |> where(
      [txn, user_bio, acc],
      fragment("lower(?) LIKE lower(?)", txn.productId, ^search_term) or
        fragment("lower(?) LIKE lower(?)", acc.accountNo, ^search_term)
    )
  end
end
