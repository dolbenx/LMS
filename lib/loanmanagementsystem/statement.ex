defmodule Loanmanagementsystem.Statement do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Loan.Loans
  alias  Loanmanagementsystem.Accounts.UserRole
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Core_transaction.Journal_entries

  def loan_statement_generation_lookup(search_params, page, size) do
    Journal_entries
    |> join(:left, [t], uB in UserRole, on: t.customer_id == uB.userId)
    |> join(:left, [t], uC in UserBioData, on: t.customer_id == uC.userId)
    |> join(:left, [t], uE in Company, on: t.customer_id == uE.createdByUserId)
    |> join(:left, [t], l in Loans, on: l.customer_id == t.customer_id)
    |> where([t, uB, uC, uE, l], t.process_status == "APPROVED" and l.id == t.loan_id)
    |> order_by([t, uB, uC, l], asc: t.id)
    |> handle_loan_statement_generation_filter(search_params)
    |> compose_loan_statement_select()
    |> Repo.paginate(page: page, page_size: size)
    |> compute_loan_running_balance_map()
  end

  def loan_statement_generation_lookup(_source, search_params) do
    Journal_entries
    |> join(:left, [t], uB in UserRole, on: t.customer_id == uB.userId)
    |> join(:left, [t], uC in UserBioData, on: t.customer_id == uC.userId)
    |> join(:left, [t], uE in Company, on: t.customer_id == uE.createdByUserId)
    |> join(:left, [t], l in Loans, on: l.customer_id == t.customer_id)
    |> where([t, uB, uC, uE, l], t.process_status == "APPROVED" and l.id == t.loan_id)
    |> order_by([t, uB, uC, l], asc: t.id)
    |> handle_loan_statement_generation_filter(search_params)
    |> compose_loan_statement_select()
  end


  defp handle_loan_statement_generation_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_statement_mobile_filter(search_params)
    |> handle_loan_statement_amount_filter(search_params)
    |> handle_loan_statement_firstname_filter(search_params)
    |> handle_loan_statement_lastname_filter(search_params)
    |> handle_loan_statement_idno_filter(search_params)
    |> handle_loan_statement_loanid_filter(search_params)
  end

  defp handle_loan_statement_mobile_filter(query, %{"mobileno" => mobileno})
      when byte_size(mobileno) > 0 and byte_size(mobileno) > 0 do
    query
    |> where(
    [t, uB, uC, uE, l],
    fragment("lower(?) LIKE lower(?)", uC.mobileNumber, ^mobileno)
    )
  end
  defp handle_loan_statement_mobile_filter(query, _params), do: query

  defp handle_loan_statement_amount_filter(query, %{"amount" => amount})
       when byte_size(amount) > 0 and byte_size(amount) > 0 do
    query
    |> where(
      [t, uB, uC, uE, l],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.requested_amount, ^amount)
    )
  end
  defp handle_loan_statement_amount_filter(query, _params), do: query

  defp handle_loan_statement_loanid_filter(query, %{"loanid" => loanid})
  when byte_size(loanid) > 0 and byte_size(loanid) > 0 do
  query
  |> where(
  [t, uB, uC, uE, l],
  fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", l.id, ^loanid)
  )
  end
  defp handle_loan_statement_loanid_filter(query, _params), do: query


  defp handle_loan_statement_firstname_filter(query, %{"fname" => fname})
  when byte_size(fname) > 0 and byte_size(fname) > 0 do
  query
  |> where(
  [t, uB, uC, uE, l],
  fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", uC.firstName, ^fname)
  )
  end

  defp handle_loan_statement_firstname_filter(query, _params), do: query

  defp handle_loan_statement_lastname_filter(query, %{"lname" => lname})
  when byte_size(lname) > 0 and byte_size(lname) > 0 do
  query
  |> where(
  [t, uB, uC, uE, l],
  fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", uC.lastName, ^lname)
  )
  end

  defp handle_loan_statement_lastname_filter(query, _params), do: query

  defp handle_loan_statement_idno_filter(query, %{"idno" => idno})
  when byte_size(idno) > 0 and byte_size(idno) > 0 do
  query
  |> where(
  [t, uB, uC, uE, l],
  fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", uC.meansOfIdentificationNumber, ^idno)
  )
  end

  defp handle_loan_statement_idno_filter(query, _params), do: query


  defp compose_loan_statement_select(query) do
    query
    |> select(
      [t, uB, uC, uE, l],
      %{
        id: l.id,
        account_no: l.account_no,
        external_id: l.external_id,
        customer_id: l.customer_id,
        product_id: l.product_id,
        loan_status: l.loan_status,
        # name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", uC.firstName, uC.lastName, uC.otherName),
        name: fragment("select distinct case when company_name is null then concat(?, concat(' ', ?)) else company_name end from tbl_loan_customer_details where reference_no = ?", uC.firstName, uC.lastName, l.reference_no),
        loan_type: l.loan_type,
        currency_code: l.currency_code,
        principal_amount: l.principal_amount,
        repayment_amount: l.repayment_amount,
        total_repaid: l.total_repaid,
        balance: l.balance,
        total_repayment_derived: l.total_repayment_derived,
        disbursedon_date: l.disbursedon_date,
        expected_maturity_date: l.expected_maturity_date,
        total_charges_repaid: l.total_charges_repaid,
        inserted_at: l.inserted_at,
        roleType: uB.roleType,
        firstName: uC.firstName,
        lastName: uC.lastName,
        otherName: uC.otherName,
        meansOfIdentificationNumber: uC.meansOfIdentificationNumber,
        mobileNumber: uC.mobileNumber,
        companyName: uE.companyName,
        taxno: uE.taxno,
        requested_amount: l.requested_amount,
        transaction: t.narration,
        application_date: l.application_date,
        loan_interest: fragment("select sum(interest) from tbl_loan_amortization_schedule where loan_id = ?", l.id),
        total_pl: fragment("select sum(interest) from tbl_loan_amortization_schedule where loan_id = ?", l.id) + l.requested_amount,
        principle_balance: l.requested_amount,
        interest_balance: fragment("select sum(interest) from tbl_loan_amortization_schedule where loan_id = ?", l.id),
        total_balance: fragment("select sum(interest) from tbl_loan_amortization_schedule where loan_id = ?", l.id) + l.requested_amount,
        net_disbursed: fragment("select net_disbiursed from tbl_loan_disbursement_schedule where loan_id = ?", l.id),
        month_installment: fragment("select month_installment from tbl_loan_disbursement_schedule where loan_id = ?", l.id),
        fees: fragment("select sum(processing_fee + insurance + crb + motor_insurance) from tbl_loan_disbursement_schedule where loan_id = ?", l.id),
        processing_fee: fragment("select sum(processing_fee) from tbl_loan_disbursement_schedule where loan_id = ?", l.id),
        crb: fragment("select sum(crb) from tbl_loan_disbursement_schedule where loan_id = ?", l.id),
        insurance: fragment("select sum(insurance + motor_insurance)from tbl_loan_disbursement_schedule where loan_id = ?", l.id),
        loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", l.cro_id),
        repayment_period: fragment("select repayment_period from tbl_loan_disbursement_schedule where loan_id = ?", l.id),
        interet_per_month: fragment("select interet_per_month * 12 from tbl_loan_disbursement_schedule where loan_id = ?", l.id),
        trn_dt: t.trn_dt,
        payment: t.lcy_amount,
        interest: t.interest,
        principle: t.principle,
        drcr_ind: t.drcr_ind,
        module: t.module,
        processing_fee_percent: fragment("select proccessing_fee * 100 from tbl_products where id = ?", l.product_id),
        insurance_percent: fragment("select insurance * 100 from tbl_products where id = ?", l.product_id)

      }
    )
  end


  def compute_loan_running_balance_map(map) do
    map
    |> (fn %{entries: entries} = results ->
    {formatted_entries, _total_balance} = Enum.map_reduce(entries, 0, fn result, running_balance ->
       running_balance =
        case result.drcr_ind do
          "D" ->
            running_balance -  (result.total_balance - result.payment)
          "C" ->
            IO.inspect result, label: "result ----------------------------"

            case result.module do
              "DISBURSEMENT" ->
                result.total_balance
              "INSTALLMENT DUE" ->

                IO.inspect running_balance, label: "running_balance ----------------------------"

                if running_balance == 0  do
                  result.total_balance - result.payment
                else
                  running_balance - result.payment
                end

            end
        end
    {Map.merge(result, %{runningBalance: running_balance}), running_balance}
    end)
    %{results | entries: formatted_entries }
    end).()
  end




end
