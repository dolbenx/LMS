defmodule Savings.FixedDeposit do
  @moduledoc """
  The FixedDeposit context.
  """

  import Ecto.Query, warn: false
  alias Savings.Repo

  alias Savings.FixedDeposit.FixedDeposits
  alias Savings.Client.UserBioData

  @doc """
  Returns the list of tbl_fixed_deposit.

  ## Examples

      iex> list_tbl_fixed_deposit()
      [%FixedDeposits{}, ...]

  """
  def list_tbl_fixed_deposit do
    Repo.all(FixedDeposits)
  end

  def list_matured_transactions do
    date = Timex.now
    FixedDeposits
    |> join(:left, [a], u in "tbl_account", on: a.userId == u.userId)
    |> join(:left, [a], uB in "tbl_user_bio_data", on: a.userId == uB.userId)
    |> order_by([a, u, uB], desc: a.inserted_at)
    |> where([a, u, uB], a.inserted_at >= ^Timex.beginning_of_day(date) and a.inserted_at <= ^Timex.end_of_day(date) and a.isMatured == true)
    |> select([a, u, uB], %{
      accountNo: u.accountNo,
      principalAmount: a.principalAmount,
      fixedPeriod: a.fixedPeriod,
      fixedPeriodType: a.fixedPeriodType,
      interestRate: a.interestRate,
      interestRateType: a.interestRateType,
      accruedInterest: a.accruedInterest,
      currency: a.currency,
      currencyDecimals: a.currencyDecimals,
      yearLengthInDays: a.yearLengthInDays,
      totalDepositCharge: a.totalDepositCharge,
      totalWithdrawalCharge: a.totalWithdrawalCharge,
      totalPenalties: a.totalPenalties,
      totalAmountPaidOut: a.totalAmountPaidOut,
      startDate: a.startDate,
      endDate: a.endDate,
      expectedInterest: a.expectedInterest,
      firstName: uB.firstName,
      inserted_at: a.inserted_at,
      lastName: uB.lastName
    })
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  def list_transactions do
    activeStatus = "ACTIVE"
    maturedStatus = "MATURED"
    FixedDeposits
    |> join(:left, [a], u in "tbl_account", on: a.userId == u.userId)
    |> join(:left, [a], uB in "tbl_user_bio_data", on: a.userId == uB.userId)
    |> join(:left, [a], p in "tbl_products", on: a.productId == p.id)
    |> where([a, uB, p], a.fixedDepositStatus == ^activeStatus or a.fixedDepositStatus == ^maturedStatus)
    |> select([a, u, uB, p], %{
      accountNo: u.accountNo,
      principalAmount: a.principalAmount,
      fixedPeriod: a.fixedPeriod,
      fixedPeriodType: a.fixedPeriodType,
      interestRate: a.interestRate,
      interestRateType: a.interestRateType,
      accruedInterest: a.accruedInterest,
      currency: a.currency,
      currencyDecimals: a.currencyDecimals,
      yearLengthInDays: a.yearLengthInDays,
      totalDepositCharge: a.totalDepositCharge,
      totalWithdrawalCharge: a.totalWithdrawalCharge,
      totalPenalties: a.totalPenalties,
      totalAmountPaidOut: a.totalAmountPaidOut,
      startDate: a.startDate,
      endDate: a.endDate,
      isMatured: a.isMatured,
      isDivested: a.isDivested,
      isWithdrawn: a.isWithdrawn,
      expectedInterest: a.expectedInterest,
      firstName: uB.firstName,
      lastName: uB.lastName,
      productName: p.name,
      fixedDepositStatus: a.fixedDepositStatus,
      totalDeposits: u.totalDeposits,
      id: a.id
    })
    |> order_by(desc: :inserted_at)
    |> Repo.all()
  end

  @doc """
  Gets a single fixed_deposits.

  Raises `Ecto.NoResultsError` if the Fixed deposits does not exist.

  ## Examples

      iex> get_fixed_deposits!(123)
      %FixedDeposits{}

      iex> get_fixed_deposits!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fixed_deposits!(id), do: Repo.get!(FixedDeposits, id)



  def range(params) do
    IO.inspect "---------------------------------------------------------------------"
IO.inspect params
    fixedPeriodType = get_in(params, ["fixedPeriodType"])
    principal_minimum = get_in(params, ["principal_minimum"])
    principal_maximum = get_in(params, ["principal_maximum"])
    intrest_min = get_in(params, ["intrest_min"])
    intrest_max = get_in(params, ["intrest_max"])
    tenure_min = get_in(params, ["tenure_min"])
    tenure_max = get_in(params, ["tenure_max"])
    start_date = start_date_conversion(params)
    end_date = end_date_conversion(params)
    params = %{
      principal_minimum: principal_minimum,
      principal_maximum: principal_maximum,
      intrest_min: intrest_min,
      intrest_max: intrest_max,
      tenure_min: tenure_min,
      tenure_max: tenure_max,
      start_date: start_date,
      end_date: end_date,
      fixedPeriodType: fixedPeriodType
    }

    Divestment
    |> search(params)
    |> Repo.all()
  end

  def search(_Divestment, params) do

   %{columns: _, num_rows: _, rows: [[principal_minimum_result]]} =  Ecto.Adapters.SQL.query!(Repo, "select min(u.principalAmount) from tbl_fixed_deposit u", [])
   %{columns: _, num_rows: _, rows: [[principal_maximum_result]]} = Ecto.Adapters.SQL.query!(Repo, "select max(u.principalAmount) from tbl_fixed_deposit u", [])
   %{columns: _, num_rows: _, rows: [[intrest_min_result]]} = Ecto.Adapters.SQL.query!(Repo, "select min(u.interestRate) from tbl_fixed_deposit u", [])
   %{columns: _, num_rows: _, rows: [[intrest_max_result]]} = Ecto.Adapters.SQL.query!(Repo, "select max(u.interestRate) from tbl_fixed_deposit u", [])
   %{columns: _, num_rows: _, rows: [[tenure_min_result]]} = Ecto.Adapters.SQL.query!(Repo, "select min(u.fixedPeriod) from tbl_fixed_deposit u", [])
   %{columns: _, num_rows: _, rows: [[tenure_max_result]]} = Ecto.Adapters.SQL.query!(Repo, "select max(u.fixedPeriod) from tbl_fixed_deposit u", [])
   %{columns: _, num_rows: _, rows: [[start_date_min]]} = Ecto.Adapters.SQL.query!(Repo, "SELECT min(u.inserted_at) FROM tbl_fixed_deposit u", [])
   %{columns: _, num_rows: _, rows: [[end_date_max]]} = Ecto.Adapters.SQL.query!(Repo, "SELECT max(u.inserted_at) FROM tbl_fixed_deposit u", [])


   principal_minimum = if params.principal_minimum == "", do: principal_minimum_result, else: params.principal_minimum
   principal_maximum = if params.principal_maximum == "", do: principal_maximum_result, else: params.principal_maximum

   intrest_min = if params.intrest_min == "", do: intrest_min_result, else: params.intrest_min
   intrest_max = if params.intrest_max == "", do: intrest_max_result, else: params.intrest_max

   tenure_min = if params.tenure_min == "", do: tenure_min_result, else: params.tenure_min
   tenure_max = if params.tenure_max == "", do: tenure_max_result, else: params.tenure_max


    start_date = if params.start_date == "", do: start_date_min, else: params.start_date
    end_date = if params.end_date == "", do: end_date_max, else: params.end_date

    from d in FixedDeposits,
    or_where: d.principalAmount >= ^principal_minimum and d.principalAmount <= ^principal_maximum and
             d.interestRate >= ^intrest_min and d.interestRate <= ^intrest_max and
             d.fixedPeriod >= ^tenure_min and d.fixedPeriod <= ^tenure_max and
             d.inserted_at >= ^start_date and d.inserted_at <= ^end_date,
      select:
      struct(
        d,
        [
          :principalAmount,
          :fixedPeriod,
          :fixedPeriodType,
          :interestRate,
          :interestRateType,
          :expectedInterest,
          :accruedInterest,
          :currency,
          :currencyDecimals,
          :yearLengthInDays,
          :totalDepositCharge,
          :totalWithdrawalCharge,
          :totalPenalties,
          :totalAmountPaidOut,
          :startDate,
          :endDate
        ]
      )


  end

  def start_date_conversion(params) do

   %{columns: _, num_rows: _, rows: [[start_date_min]]} = Ecto.Adapters.SQL.query!(Repo, "SELECT min(u.inserted_at) FROM tbl_fixed_deposit u", [])
    case params["start_date"] == "" do
        true -> start_date_min
        false ->

        date =  NaiveDateTime.new Date.from_iso8601!(params["start_date"]), ~T[00:00:00]
        {:ok , changed_date} = date
        start_date1 = Timex.beginning_of_day(changed_date)
        start_date2 = to_string(start_date1)
        start_date = String.slice(start_date2, 0..15)

        IO.inspect start_date, label: "Start date"

      end
  end

  def end_date_conversion(params) do

    case params["end_date"] == "" do
      true -> Timex.now()
      false ->
      date =  NaiveDateTime.new Date.from_iso8601!(params["end_date"]), ~T[00:00:00]
      {:ok , changed_date2} = date
      end_date1 = Timex.end_of_day(changed_date2)
      end_date2 = to_string(end_date1)
      end_date = String.slice(end_date2, 0..15)

      IO.inspect end_date, label: "End date"
    end

   end

  @doc """
  Creates a fixed_deposits.

  ## Examples

      iex> create_fixed_deposits(%{field: value})
      {:ok, %FixedDeposits{}}

      iex> create_fixed_deposits(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fixed_deposits(attrs \\ %{}) do
    %FixedDeposits{}
    |> FixedDeposits.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fixed_deposits.

  ## Examples

      iex> update_fixed_deposits(fixed_deposits, %{field: new_value})
      {:ok, %FixedDeposits{}}

      iex> update_fixed_deposits(fixed_deposits, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fixed_deposits(%FixedDeposits{} = fixed_deposits, attrs) do
    fixed_deposits
    |> FixedDeposits.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fixed_deposits.

  ## Examples

      iex> delete_fixed_deposits(fixed_deposits)
      {:ok, %FixedDeposits{}}

      iex> delete_fixed_deposits(fixed_deposits)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fixed_deposits(%FixedDeposits{} = fixed_deposits) do
    Repo.delete(fixed_deposits)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fixed_deposits changes.

  ## Examples

      iex> change_fixed_deposits(fixed_deposits)
      %Ecto.Changeset{source: %FixedDeposits{}}

  """
  def change_fixed_deposits(%FixedDeposits{} = fixed_deposits) do
    FixedDeposits.changeset(fixed_deposits, %{})
  end

  alias Savings.FixedDeposit.FixedDepositTransaction

  @doc """
  Returns the list of tbl_fixed_deposit_transactions.

  ## Examples

      iex> list_tbl_fixed_deposit_transactions()
      [%FixedDepositTransaction{}, ...]

  """
  def list_tbl_fixed_deposit_transactions do
    Repo.all(FixedDepositTransaction)
  end



  @doc """
  Gets a single fixed_deposit_transaction.

  Raises `Ecto.NoResultsError` if the Fixed deposit transaction does not exist.

  ## Examples

      iex> get_fixed_deposit_transaction!(123)
      %FixedDepositTransaction{}

      iex> get_fixed_deposit_transaction!(456)
      ** (Ecto.NoResultsError)

  """
  def get_fixed_deposit_transaction!(id), do: Repo.get!(FixedDepositTransaction, id)

  @doc """
  Creates a fixed_deposit_transaction.

  ## Examples

      iex> create_fixed_deposit_transaction(%{field: value})
      {:ok, %FixedDepositTransaction{}}

      iex> create_fixed_deposit_transaction(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_fixed_deposit_transaction(attrs \\ %{}) do
    %FixedDepositTransaction{}
    |> FixedDepositTransaction.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a fixed_deposit_transaction.

  ## Examples

      iex> update_fixed_deposit_transaction(fixed_deposit_transaction, %{field: new_value})
      {:ok, %FixedDepositTransaction{}}

      iex> update_fixed_deposit_transaction(fixed_deposit_transaction, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_fixed_deposit_transaction(%FixedDepositTransaction{} = fixed_deposit_transaction, attrs) do
    fixed_deposit_transaction
    |> FixedDepositTransaction.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a fixed_deposit_transaction.

  ## Examples

      iex> delete_fixed_deposit_transaction(fixed_deposit_transaction)
      {:ok, %FixedDepositTransaction{}}

      iex> delete_fixed_deposit_transaction(fixed_deposit_transaction)
      {:error, %Ecto.Changeset{}}

  """
  def delete_fixed_deposit_transaction(%FixedDepositTransaction{} = fixed_deposit_transaction) do
    Repo.delete(fixed_deposit_transaction)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking fixed_deposit_transaction changes.

  ## Examples

      iex> change_fixed_deposit_transaction(fixed_deposit_transaction)
      %Ecto.Changeset{source: %FixedDepositTransaction{}}

  """
  def change_fixed_deposit_transaction(%FixedDepositTransaction{} = fixed_deposit_transaction) do
    FixedDepositTransaction.changeset(fixed_deposit_transaction, %{})
  end


  # Savings.FixedDeposit.fixed_deposits_report(nil, 1, 10)



  def fixed_deposits_report(search_params, page, size) do
    Savings.FixedDeposit.FixedDeposits
    |> handle_fixed_deposits_report_filter(search_params)
    |> order_by([fxd, div, pro, user, dep_txn], desc: fxd.updated_at)
    |> compose_fixed_deposits_report_select()
    |> Repo.paginate(page: page, page_size: size)
  end

  def fixed_deposits_report(_source, search_params) do
    Savings.FixedDeposit.FixedDeposits
    |> handle_fixed_deposits_report_filter(search_params)
    |> order_by([fxd, div, pro, user, dep_txn], desc: fxd.updated_at)
    |> compose_fixed_deposits_report_select()
  end

# fixedPeriod
  defp compose_fixed_deposits_report_select(query) do
    query
    |> join(:left, [fxd], div in Savings.Divestments.Divestment, on: fxd.id == div.fixedDepositId)
    |> join(:left, [fxd, div], pro in Savings.Products.Product, on: fxd.productId   == pro.id)
    |> join(:left, [fxd, div, pro], user in Savings.Accounts.Account, on: fxd.accountId  == user.id)
    |> join(:left, [fxd, div, pro, user], dep_txn in Savings.FixedDeposit.FixedDepositTransaction, on: fxd.id == dep_txn.fixedDepositId)
    |> join(:left, [fxd, div, pro, user, dep_txn], user_bio in Savings.Client.UserBioData, on: fxd.userId == user_bio.userId)
    |> select(
        [fxd, div, pro, user, dep_txn, user_bio],
        %{
          date_details: fragment("concat(?, ?, ?, ?, ?)", "PAID: ", fxd.startDate, "  ", "MATURITY: ", fxd.endDate),
          accountId: fxd.accountId,
          productId: fxd.productId,
          principalAmount: fxd.principalAmount,
          fixedPeriod: fxd.fixedPeriod,
          fixedPeriodType: fxd.fixedPeriodType,
          interestRate: fxd.interestRate,
          interestRateType: fxd.interestRateType,
          expectedInterest: fxd.expectedInterest,
          accruedInterest: fxd.accruedInterest,
          isMatured: fxd.isMatured,
          isDivested: fxd.isDivested,
          divestmentPackageId: fxd.divestmentPackageId,
          currencyId: fxd.currencyId,
          currency: fxd.currency,
          currencyDecimals: fxd.currencyDecimals,
          yearLengthInDays: fxd.yearLengthInDays,
          totalDepositCharge: fxd.totalDepositCharge,
          totalWithdrawalCharge: fxd.totalWithdrawalCharge,
          totalPenalties: fxd.totalPenalties,
          userRoleId: fxd.userRoleId,
          userId: fxd.userId,
          totalAmountPaidOut: fxd.totalAmountPaidOut,
          startDate: fxd.startDate,
          startTime: fxd.startDate,
          endDate: fxd.endDate,
          clientId: fxd.clientId,
          divestmentId: fxd.divestmentId,
          branchId: fxd.branchId,
          productInterestMode: fxd.productInterestMode,
          divestedInterestRate: fxd.divestedInterestRate,
          divestedInterestRateType: fxd.divestedInterestRateType,
          amountDivested: fxd.amountDivested,
          divestedInterestAmount: fxd.divestedInterestAmount,
          divestedPeriod: fxd.divestedPeriod,
          fixedDepositStatus: fxd.fixedDepositStatus,
          lastEndOfDayDate: fxd.lastEndOfDayDate,
          isWithdrawn: fxd.isWithdrawn,
          customerName: fxd.customerName,
          autoCreditOnMaturityDone: fxd.autoCreditOnMaturityDone,
          autoCreditOnMaturity: fxd.autoCreditOnMaturity,
          autoRollOverAmount: fxd.autoRollOverAmount,
          inserted_at: fxd.inserted_at,
          updated_at: fxd.updated_at,


          div_currencyDecimals: div.currencyDecimals,
          div_currency: div.currency,
          div_customerName: div.customerName,
          div_divestmentType: div.divestmentType,
          div_fixedDepositId: div.fixedDepositId,
          div_principalAmount: div.principalAmount,
          div_fixedPeriod: div.fixedPeriod,
          div_interestRate: div.interestRate,
          div_interestRateType: div.interestRateType,
          div_divestmentDate: div.divestmentDate,
          div_divestmentDayCount: div.divestmentDayCount,
          div_divestmentValuation: div.divestmentValuation,
          div_divestAmount: div.divestAmount,
          div_clientId: div.clientId,
          div_interestAccrued: div.interestAccrued,
          div_userId: div.userId,
          div_userRoleId: div.userRoleId,

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

          accountOfficerId: user.accountOfficerId,
          user_branchId: user.branchId,
          userRoleId: user.userRoleId,
          user_deactivatedReason: user.deactivatedReason,
          user_blockedReason: user.blockedReason,
          user_clientId: user.clientId,
          user_accountNo: user.accountNo,
          user_externalId: user.externalId,
          user_accountType: user.accountType,
          # user_dateClosed: user.DateClosed,
          user_currencyId: user.currencyId,
          user_currencyDecimals: user.currencyDecimals,
          user_currencyName: user.currencyName,
          user_totalDeposits: user.totalDeposits,
          user_totalWithdrawals: user.totalWithdrawals,
          user_totalCharges: user.totalCharges,
          user_totalPenalties: user.totalPenalties,
          user_totalInterestEarned: user.totalInterestEarned,
          user_totalInterestPosted: user.totalInterestPosted,
          user_totalTax: user.totalTax,
          user_accountVersion: user.accountVersion,
          user_derivedAccountBalance: user.derivedAccountBalance,
          user_userId: user.userId,
          user_blockedByUserId: user.blockedByUserId,
          user_status: user.status,

          dep_txn_status: dep_txn.status,
          dep_txn_fixedDepositId: dep_txn.fixedDepositId,
          dep_txn_transactionId: dep_txn.transactionId,
          dep_txn_clientId: dep_txn.clientId,
          dep_txn_amountDeposited: dep_txn.amountDeposited,
          dep_txn_userId: dep_txn.userId,
          dep_txn_userRoleId: dep_txn.userRoleId,

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



    defp handle_fixed_deposits_report_filter(query, %{"isearch" => search_term} = search_params)
      when search_term == "" or is_nil(search_term) do
      query
      |> handle_customer_first_name_filter(search_params)
      |> handle_customer_last_name_filter(search_params)
      |> handle_product_name_filter(search_params)
      |> handle_divestment_type_filter(search_params)
      |> handle_deposit_status_filter(search_params)
      |> handle_curreny_filter(search_params)
      |> handle_minimum_principal_filter(search_params)
      |> handle_deposit_date_filter(search_params)
      |> handle_maturity_date_filter(search_params)

    end

    defp handle_fixed_deposits_report_filter(query, %{"isearch" => search_term}) do
      search_term = "%#{search_term}%"
      compose_fixed_deposits_isearch_filter(query, search_term)
    end

    defp handle_customer_first_name_filter(query, %{"customer_first_name" => customer_first_name})
    when customer_first_name == "" or is_nil(customer_first_name),
    do: query

    defp handle_customer_first_name_filter(query, %{"customer_first_name" => customer_first_name}) do
     where(query, [fxd, div, pro, user, dep_txn, user_bio], fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^"%#{customer_first_name}%"))
    end

    defp handle_customer_last_name_filter(query, %{"customer_last_name" => customer_last_name})
     when customer_last_name == "" or is_nil(customer_last_name),
     do: query

    defp handle_customer_last_name_filter(query, %{"customer_last_name" => customer_last_name}) do
      where(query, [fxd, div, pro, user, dep_txn, user_bio], fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^"%#{customer_last_name}%"))
    end


    defp handle_product_name_filter(query, %{"product_name" => product_name})
      when product_name == "" or is_nil(product_name),
      do: query

    defp handle_product_name_filter(query, %{"product_name" => product_name}) do
    where(query, [fxd, div, pro, user, dep_txn, user_bio], fragment("lower(?) LIKE lower(?)", pro.id, ^"%#{product_name}%"))
    end


    defp handle_divestment_type_filter(query, %{"divestment_type" => divestment_type})
    when divestment_type == "" or is_nil(divestment_type),
    do: query

    defp handle_divestment_type_filter(query, %{"divestment_type" => divestment_type}) do
    where(query, [fxd, div, pro, user, dep_txn, user_bio], fragment("lower(?) LIKE lower(?)", div.divestmentType, ^"%#{divestment_type}%"))
    end

    defp handle_deposit_status_filter(query, %{"fixed_deposit_status" => fixed_deposit_status})
    when fixed_deposit_status == "" or is_nil(fixed_deposit_status),
    do: query

    defp handle_deposit_status_filter(query, %{"fixed_deposit_status" => fixed_deposit_status}) do
    where(query, [fxd, div, pro, user, dep_txn, user_bio], fragment("lower(?) LIKE lower(?)", fxd.fixedDepositStatus, ^"%#{fixed_deposit_status}%"))
    end


    defp handle_curreny_filter(query, %{"currency_id" => currency_id})
    when currency_id == "" or is_nil(currency_id),
    do: query

    defp handle_curreny_filter(query, %{"currency_id" => currency_id}) do
    where(query, [fxd, div, pro, user, dep_txn, user_bio], fragment("lower(?) LIKE lower(?)", fxd.currencyId, ^"%#{currency_id}%"))
    end



    defp handle_minimum_principal_filter(query, %{"product_minimum_amount" => product_minimum_amount, "product_maximum_amount" => product_maximum_amount})
      when byte_size(product_minimum_amount) > 0 and byte_size(product_maximum_amount) > 0 do
        query
        |> where(
          [fxd, div, pro, user, dep_txn, user_bio],

        fragment("? >= ?", fxd.principalAmount, ^product_minimum_amount) and
        fragment("? <= ?", fxd.principalAmount, ^product_maximum_amount)


        )
    end

    defp handle_minimum_principal_filter(query, _params), do: query

    defp handle_deposit_date_filter(query, %{"deposit_date_from" => deposit_date_from, "deposit_date_to" => deposit_date_to})
      when byte_size(deposit_date_from) > 0 and byte_size(deposit_date_to) > 0 do
        query
        |> where(
          [fxd, div, pro, user, dep_txn, user_bio],
            fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", fxd.inserted_at, ^deposit_date_from) and
            fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", fxd.inserted_at, ^deposit_date_to)
        )
    end

    defp handle_deposit_date_filter(query, _params), do: query

    defp handle_maturity_date_filter(query, %{"maturity_date_from" => maturity_date_from, "maturity_date_to" => maturity_date_to})
    when byte_size(maturity_date_from) > 0 and byte_size(maturity_date_to) > 0 do
      query
      |> where(
        [fxd, div, pro, user, dep_txn, user_bio],
          fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", fxd.inserted_at, ^maturity_date_from) and
          fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", fxd.inserted_at, ^maturity_date_to)
      )
  end

  defp handle_maturity_date_filter(query, _params), do: query


  defp compose_fixed_deposits_isearch_filter(query, search_term) do
    query
    |> where(
      [fxd, div, pro, user, dep_txn, user_bio],
        fragment("lower(?) LIKE lower(?)", user_bio.firstName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", user_bio.lastName, ^search_term) or
        fragment("lower(?) LIKE lower(?)", user_bio.otherName, ^search_term)
      )
  end




end
