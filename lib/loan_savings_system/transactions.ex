defmodule LoanSavingsSystem.Transactions do
  @moduledoc """
  The Transactions context.
  """

  import Ecto.Query, warn: false
  alias LoanSavingsSystem.Repo

  alias LoanSavingsSystem.Transactions.Transaction
  alias LoanSavingsSystem.Client.UserBioData

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
    date = Timex.now
    Transaction
    |> join(:left, [a], u in "tbl_account", on: a.userId == u.userId)
    |> join(:left, [a], uB in "tbl_user_bio_data", on: a.userId == uB.userId)
    |> where([a, u, uB], a.inserted_at >= ^Timex.beginning_of_day(date) and a.inserted_at <= ^Timex.end_of_day(date))
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
		status = "Pending";
		query = from au in LoanSavingsSystem.Transactions.Transaction,
			where: au.status == type(^status, :string),
			select: au
		transactions = Repo.all(query);
		transactions
	end


  # LoanSavingsSystem.Transactions.all_customer_txn_data_report(nil, 1, 10)

  def all_customer_txn_data_report(search_params, page, size) do
    LoanSavingsSystem.Transactions.Transaction
    |> handle_transaction_report_filter(search_params)
    |> order_by([txn, pro, user_bio], desc: txn.updated_at)
    |> compose_all_customer_txn_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def all_customer_txn_data_report(_source, search_params) do
    LoanSavingsSystem.Transactions.Transaction
    |> handle_transaction_report_filter(search_params)
    |> order_by([txn, pro, user_bio], desc: txn.updated_at)
    |> compose_all_customer_txn_report_select()
  end


  defp compose_all_customer_txn_report_select(query) do
    query
    |> join(:left, [txn], pro in LoanSavingsSystem.Products.Product, on: txn.productId   == pro.id)
    |> join(:left, [txn, pro], user_bio in LoanSavingsSystem.Client.UserBioData, on: txn.userId   == user_bio.userId)
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

        })

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

  defp handle_customer_first_name_filter(query, %{"txn_customer_first_name" => txn_customer_first_name})
  when txn_customer_first_name == "" or is_nil(txn_customer_first_name),
  do: query

  defp handle_customer_first_name_filter(query, %{"txn_customer_first_name" => txn_customer_first_name}) do
  where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{txn_customer_first_name}%"))
  end

  defp handle_customer_last_name_filter(query, %{"txn_customer_last_name" => txn_customer_last_name})
  when txn_customer_last_name == "" or is_nil(txn_customer_last_name),
  do: query

  defp handle_customer_last_name_filter(query, %{"txn_customer_last_name" => txn_customer_last_name}) do
    where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{txn_customer_last_name}%"))
  end

  defp handle_customer_phone_number_filter(query, %{"txn_customer_phone_number" => txn_customer_phone_number})
  when txn_customer_phone_number == "" or is_nil(txn_customer_phone_number),
  do: query

  defp handle_customer_phone_number_filter(query, %{"txn_customer_phone_number" => txn_customer_phone_number}) do
    where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", user_bio.mobileNumber, ^"%#{txn_customer_phone_number}%"))
  end

  defp handle_customer_txn_status_filter(query, %{"customer_txn_status" => customer_txn_status})
  when customer_txn_status == "" or is_nil(customer_txn_status),
  do: query

  defp handle_customer_txn_status_filter(query, %{"customer_txn_status" => customer_txn_status}) do
    where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", txn.status, ^"%#{customer_txn_status}%"))
  end


  defp handle_product_name_filter(query, %{"txn_product_name" => txn_product_name})
    when txn_product_name == "" or is_nil(txn_product_name),
    do: query

  defp handle_product_name_filter(query, %{"txn_product_name" => txn_product_name}) do
  where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", pro.id, ^"%#{txn_product_name}%"))
  end


  defp handle_transaction_type_filter(query, %{"transaction_type" => transaction_type})
  when transaction_type == "" or is_nil(transaction_type),
  do: query

  defp handle_transaction_type_filter(query, %{"transaction_type" => transaction_type}) do
  where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", txn.transactionType, ^"%#{transaction_type}%"))
  end


  defp handle_minimum_principal_filter(query, %{"txn_product_minimum_amount" => txn_product_minimum_amount, "txn_product_maximum_amount" => txn_product_maximum_amount})
    when byte_size(txn_product_minimum_amount) > 0 and byte_size(txn_product_maximum_amount) > 0 do
      query
      |> where(
        [txn, pro, user_bio],

      fragment("? >= ?", txn.totalAmount, ^txn_product_minimum_amount) and
      fragment("? <= ?", txn.totalAmount, ^txn_product_maximum_amount)


      )
  end

  defp handle_minimum_principal_filter(query, _params), do: query

  defp handle_transaction_date_filter(query, %{"txn_date_from" => txn_date_from, "txn_date_to" => txn_date_to})
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
    LoanSavingsSystem.Transactions.Transaction
    |> handle_client_transaction_report_filter(search_params)
    |> order_by([txn, pro, user_bio], desc: txn.updated_at,)
    |> compose_all_customer_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def all_customer_data_report(_source, search_params) do
    LoanSavingsSystem.Transactions.Transaction
    |> handle_client_transaction_report_filter(search_params)
    |> order_by([txn, pro, user_bio], desc: txn.updated_at,)
    |> compose_all_customer_report_select()
  end


  defp compose_all_customer_report_select(query) do
    query
    |> join(:left, [txn], pro in LoanSavingsSystem.Products.Product, on: txn.productId   == pro.id)
    |> join(:left, [txn, pro], user_bio in LoanSavingsSystem.Client.UserBioData, on: txn.userId   == user_bio.userId)
    |> join(:left, [txn, pro, user_bio], user in LoanSavingsSystem.Accounts.User, on: txn.userId   == user.id)
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

        })

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

  defp handle_client_first_name_filter(query, %{"txn_client_first_name" => txn_client_first_name})
  when txn_client_first_name == "" or is_nil(txn_client_first_name),
  do: query

  defp handle_client_first_name_filter(query, %{"txn_client_first_name" => txn_client_first_name}) do
  where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{txn_client_first_name}%"))
  end

  defp handle_client_last_name_filter(query, %{"txn_client_last_name" => txn_client_last_name})
  when txn_client_last_name == "" or is_nil(txn_client_last_name),
  do: query

  defp handle_client_last_name_filter(query, %{"txn_client_last_name" => txn_client_last_name}) do
    where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{txn_client_last_name}%"))
  end

  defp handle_client_phone_number_filter(query, %{"txn_client_phone_number" => txn_client_phone_number})
  when txn_client_phone_number == "" or is_nil(txn_client_phone_number),
  do: query

  defp handle_client_phone_number_filter(query, %{"txn_client_phone_number" => txn_client_phone_number}) do
    where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", user_bio.mobileNumber, ^"%#{txn_client_phone_number}%"))
  end

  defp handle_client_txn_status_filter(query, %{"client_txn_status" => client_txn_status})
  when client_txn_status == "" or is_nil(client_txn_status),
  do: query

  defp handle_client_txn_status_filter(query, %{"client_txn_status" => client_txn_status}) do
    where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", txn.status, ^"%#{client_txn_status}%"))
  end


  defp handle_product_name_filter(query, %{"txn_product_name" => txn_product_name})
    when txn_product_name == "" or is_nil(txn_product_name),
    do: query

  defp handle_product_name_filter(query, %{"txn_product_name" => txn_product_name}) do
  where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", pro.id, ^"%#{txn_product_name}%"))
  end


  defp handle_client_transaction_type_filter(query, %{"transaction_type" => transaction_type})
  when transaction_type == "" or is_nil(transaction_type),
  do: query

  defp handle_client_transaction_type_filter(query, %{"transaction_type" => transaction_type}) do
  where(query, [txn, pro, user_bio], fragment("lower(?) LIKE lower(?)", txn.transactionType, ^"%#{transaction_type}%"))
  end


  defp handle_client_minimum_principal_filter(query, %{"txn_product_minimum_amount" => txn_product_minimum_amount, "txn_product_maximum_amount" => txn_product_maximum_amount})
    when byte_size(txn_product_minimum_amount) > 0 and byte_size(txn_product_maximum_amount) > 0 do
      query
      |> where(
        [txn, pro, user_bio],

      fragment("? >= ?", txn.totalAmount, ^txn_product_minimum_amount) and
      fragment("? <= ?", txn.totalAmount, ^txn_product_maximum_amount)


      )
  end

  defp handle_client_minimum_principal_filter(query, _params), do: query

  defp handle_client_transaction_date_filter(query, %{"txn_date_from" => txn_date_from, "txn_date_to" => txn_date_to})
    when byte_size(txn_date_from) > 0 and byte_size(txn_date_to) > 0 do
      query
      |> where(
        [txn, pro, user_bio],
          fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^txn_date_from) and
          fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", txn.inserted_at, ^txn_date_to)
      )
  end

  defp handle_client_transaction_date_filter(query, _params), do: query


  defp compose_client_transaction_isearch_filter(query, search_term) do
  query
  |> where(
    [txn, pro, user_bio],
      fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^search_term) or
      fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^search_term) or
      fragment("lower(?) LIKE lower(?)", user_bio.otherName, ^search_term)
    )
  end




end
