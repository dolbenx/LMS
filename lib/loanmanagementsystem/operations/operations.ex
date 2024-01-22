defmodule Loanmanagementsystem.Operations do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Accounts.{UserBioData, UserRole, User, Address_Details}
  alias Loanmanagementsystem.Maintenance.Bank
  # Loanmanagementsystem.Operations.get_company
  alias Loanmanagementsystem.Loan.Loan_Provisioning_Criteria
  alias Loanmanagementsystem.Products.Product
  # alias Loanmanagementsystem.Loan.{LoanRepaymentSchedule, Loan_amortization_schedule}
  alias Loanmanagementsystem.Loan.Writtenoff_loans
  alias Loanmanagementsystem.Accounts.Client_Documents
  # alias Loanmanagementsystem.Loan.Loan_disbursement_schedule
  alias Loanmanagementsystem.Core_transaction.Journal_entries
  alias Loanmanagementsystem.Logs.UserLogs
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Employment.Employment_Details

  alias Loanmanagementsystem.Logs.UserLogs





  # Loanmanagementsystem.Operations.employer_get_staff_pending_loans(6)
  def employer_get_staff_pending_loans(company_id) do
    Loans
    |>join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |>join(:left, [l,uB], p in Product, on: l.product_id == p.id)
    |>where([l,uB, p], l.company_id == ^company_id and ilike(l.status, "PENDING%"))
    |>select([l,uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount,
      repayment_frequency: l.repayment_frequency,
      tenor: l.tenor,
      principal_amount: l.principal_amount,
      account_name: l.account_name,
      bank_account_no: l.bank_account_no,
      # expiry_date: l.expiry_date,
      cvv: l.cvv,
      disbursement_method: l.disbursement_method,
      receipient_number: l.receipient_number,
      product_id: p.id,
      closedon_date: l.closedon_date,
      total_repaid: l.total_repaid,
      reference_no: l.reference_no,
      disbursedon_date: l.disbursedon_date,
      inserted_at: l.inserted_at,
      # user_role_id: uR.id,
      total_repayment_derived: l.total_repayment_derived,
      status: l.status
    })|>Repo.all()
  end

  # Loanmanagementsystem.Operations.admin_user_logs
  def admin_user_logs do
    UserLogs
    |>join(:left, [uL], uB in UserBioData, on: uL.user_id == uB.userId)
    |> order_by([uL, uB], desc: uL.inserted_at)
    |> select([uL, uB], %{
      activity: uL.activity,
      user_id: uL.user_id,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName ,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      otherName: uB.otherName,
      title: uB.title,
      inserted_at: uL.inserted_at
    })
    |> Repo.all()
  end



    # Loanmanagementsystem.Operations.employer_employee_pending_loans_list(nil, 1, 10, 6)
  def employer_employee_pending_loans_list(search_params, page, size, companyId) do
    Loans
    # |> handle_customer_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_employee_pending_loans_list(companyId)
    |> Repo.paginate(page: page, page_size: size)
  end

  def employer_employee_pending_loans_list(_source, search_params, companyId) do
    Loans
    # |> handle_customer_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_employee_pending_loans_list(companyId)
  end

  defp compose_employee_pending_loans_list(query, companyId) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cA in Loanmanagementsystem.Accounts.Customer_account, on: l.customer_id == cA.user_id)
    |> join(:left, [l, uB, p, cA], comp in Loanmanagementsystem.Companies.Company, on: l.company_id == comp.id )
    |> where([l, uB, p, cA, comp], l.company_id == ^companyId and ilike(l.status, "PENDING%"))
    |> select([l, uB, p, cA, comp], %{
      id: l.id,
      company_name: comp.companyName,
      loan_id: l.id,
      loan_account_no: cA.account_number,
      customer_principal_amount: fragment("concat(?, concat(' ', ?))", l.currency_code, l.principal_amount),
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      customer_identification_number: fragment("concat(?, concat(' - ', ?))",uB.meansOfIdentificationType, uB.meansOfIdentificationNumber),
      principal_repaid_derived: l.principal_repaid_derived,
      number_of_repayments: l.number_of_repayments,
      withdrawnon_date: l.withdrawnon_date,
      currency_code: l.currency_code,
      is_npa: l.is_npa,
      repay_every_type: l.repay_every_type,
      principal_writtenoff_derived: l.principal_writtenoff_derived,
      disbursedon_userid: l.disbursedon_userid,
      approvedon_userid: l.approvedon_userid,
      total_writtenoff_derived: l.total_writtenoff_derived,
      repay_every: l.repay_every,
      closedon_userid: l.closedon_userid,
      product_id: l.product_id,
      customer_id: l.customer_id,
      interest_method: l.interest_method,
      annual_nominal_interest_rate: l.annual_nominal_interest_rate,
      writtenoffon_date: l.writtenoffon_date,
      total_outstanding_derived: l.total_outstanding_derived,
      interest_calculated_from_date: l.interest_calculated_from_date,
      loan_counter: l.loan_counter,
      interest_charged_derived: l.interest_charged_derived,
      term_frequency_type: l.term_frequency_type,
      total_charges_due_at_disbursement_derived: l.total_charges_due_at_disbursement_derived,
      penalty_charges_waived_derived: l.penalty_charges_waived_derived,
      total_overpaid_derived: l.total_overpaid_derived,
      approved_principal: l.approved_principal,
      principal_disbursed_derived: l.principal_disbursed_derived,
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      interest_outstanding_derived: l.interest_outstanding_derived,
      interest_writtenoff_derived: l.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: l.penalty_charges_writtenoff_derived,
      loan_status: l.loan_status,
      fee_charges_charged_derived: l.fee_charges_charged_derived,
      fee_charges_waived_derived: l.fee_charges_waived_derived,
      interest_waived_derived: l.interest_waived_derived,
      total_costofloan_derived: l.total_costofloan_derived,
      principal_amount_proposed: l.principal_amount_proposed,
      fee_charges_repaid_derived: l.fee_charges_repaid_derived,
      total_expected_repayment_derived: l.total_expected_repayment_derived,
      principal_outstanding_derived: l.principal_outstanding_derived,
      penalty_charges_charged_derived: l.penalty_charges_charged_derived,
      is_legacyloan: l.is_legacyloan,
      total_waived_derived: l.total_waived_derived,
      interest_repaid_derived: l.interest_repaid_derived,
      rejectedon_date: l.rejectedon_date,
      fee_charges_outstanding_derived: l.fee_charges_outstanding_derived,
      expected_disbursedon_date: l.expected_disbursedon_date,
      closedon_date: l.closedon_date,
      fee_charges_writtenoff_derived: l.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: l.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: l.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: l.penalty_charges_repaid_derived,
      withdrawnon_userid: l.withdrawnon_userid,
      expected_maturity_date: l.expected_maturity_date,
      external_id: l.external_id,
      term_frequency: l.term_frequency,
      total_repayment_derived: l.total_repayment_derived,
      loan_identity_number: l.loan_identity_number,
      branch_id: l.branch_id,
      status: l.status,
      app_user_id: l.app_user_id,
      mobile_money_response: l.mobile_money_response,
      total_principal_repaid: l.total_principal_repaid,
      total_interest_repaid: l.total_interest_repaid,
      total_charges_repaid: l.total_charges_repaid,
      total_penalties_repaid: l.total_penalties_repaid,
      total_repaid: l.total_repaid,
      momoProvider: l.momoProvider,
      company_id: l.company_id,
      loan_userroleid: l.loan_userroleid,
      disbursement_method: l.disbursement_method,
      bank_name: l.bank_name,
      bank_account_no: l.bank_account_no,
      account_name: l.account_name,
      bevura_wallet_no: l.bevura_wallet_no,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.inserted_at,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      title: uB.title,
      userId: uB.userId,
      idNo: uB.idNo,
      clientId: p.clientId,
      product_code: p.code,
      currencyDecimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currencyName: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,
      maximumPrincipal: p.maximumPrincipal,
      minimumPrincipal: p.minimumPrincipal,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      principle_account_id: p.principle_account_id,
      interest_account_id: p.interest_account_id,
      charges_account_id: p.charges_account_id,
      classification_id: p.classification_id,
      balance: l.balance,
      loan_duration_month: l.loan_duration_month
    })
  end


   # Loanmanagementsystem.Operations.get_pending_loan_by_userId(1624)
   def get_pending_loan_by_userId(user_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |>join(:left, [l, s, uB], uR in "tbl_user_roles", on: uB.userId == uR.userId)
    |> join(:left, [l, s, uB, uR], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, u], l.customer_id == ^user_id and ilike(l.status, "PENDING%"))
    |> select([l, s, uB,uR, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount,
      repayment_frequency: l.repayment_frequency,
      tenor: l.tenor,
      principal_amount: l.principal_amount,
      account_name: l.account_name,
      bank_account_no: l.bank_account_no,
      # expiry_date: l.expiry_date,
      cvv: l.cvv,
      disbursement_method: l.disbursement_method,
      receipient_number: l.receipient_number,
      product_id: p.id,
      closedon_date: l.closedon_date,
      total_repaid: l.total_repaid,
      reference_no: l.reference_no,
      disbursedon_date: l.disbursedon_date,
      inserted_at: l.inserted_at,
      user_role_id: uR.id,
      total_repayment_derived: l.total_repayment_derived,
      status: l.status
    })
    |> Repo.all()
  end





  # Loanmanagementsystem.Operations.get_address_by_userId(1269)
  def get_address_by_userId(userid) do
    Address_Details
    |> where([aD], aD.userId == ^userid)
    |> select([aD], %{
      accomodation_status: aD.accomodation_status,
      area: aD.area,
      house_number: aD.house_number,
      street_name: aD.street_name,
      town: aD.town,
      userId: aD.userId,
      year_at_current_address: aD.year_at_current_address,
      province: aD.province,
      land_mark: aD.land_mark,
      company_id: aD.company_id,
    })|>Repo.all()
  end

 # Loanmanagementsystem.Operations.get_employmentdetails_by_userId(1624)
  def get_employmentdetails_by_userId(userid) do
    Employment_Details
    |> Repo.get_by!(userId: userid)
  end


  # Loanmanagementsystem.Operations.get_employmentdetails_by_company_id(6)
  def get_employmentdetails_by_company_id(company_id) do
    Company
    |> Repo.get_by!(id: company_id)
  end





  # Loanmanagementsystem.Operations.get_logged_admin_user_details
    def get_logged_admin_user_details do
      User
      |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
      |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
      |> where([uA, uB, uR], (uR.roleType != "INDIVIDUALS" and uR.roleType != "EMPLOYEE" and uR.roleType != "EMPLOYER" and uR.roleType != "EMPLOYER_INITIATOR" and uR.roleType != "EMPLOYER_APPROVER" and uR.roleType != "SME" and uR.roleType != "OFFTAKER"))
      |> select([uA, uB, uR], %{
        id: uA.id,
        status: uA.status,
        username: uA.username,
        firstname: uB.firstName,
        lastname: uB.lastName,
        othername: uB.otherName,
        dateofbirth: uB.dateOfBirth,
        meansofidentificationtype: uB.meansOfIdentificationType,
        meansofidentificationnumber: uB.meansOfIdentificationNumber,
        title: uB.title,
        gender: uB.gender,
        mobilenumber: uB.mobileNumber,
        emailaddress: uB.emailAddress,
        roletype: uR.roleType,
        company_id: uA.company_id,
        classification_id: uA.classification_id
      })
      |> Repo.all()
    end






  # def list_customer_reference_details(customer_id) do
  #   User
  #   |> join(:left, [uS], cO in "tbl_company", on: uS.company_id == cO.id )
  #   |> join(:left, [uS, cO], uB in "tbl_user_bio_data", on: uS.id == uB.userId)
  #   |> join()
  #   |> where([l], l.userId == ^customer_id)
  #   |> select([l], %{
  #     area: l.area,
  #     date_of_joining: l.date_of_joining,
  #     employee_number: l.employee_number,
  #     employer: l.employer,
  #     employer_industry_type: l.employer_industry_type,
  #     employer_office_building_name: l.employer_office_building_name,
  #     employer_officer_street_name: l.employer_officer_street_name,
  #     employment_type: l.employment_type,
  #     hr_supervisor_email: l.hr_supervisor_email,
  #     hr_supervisor_mobile_number: l.hr_supervisor_mobile_number,
  #     hr_supervisor_name: l.hr_supervisor_name,
  #     job_title: l.job_title,
  #     occupation: l.occupation,
  #     province: l.province,
  #     town: l.town,
  #     userId: l.userId,
  #     departmentId: l.departmentId,
  #     mobile_network_operator: l.mobile_network_operator,
  #     registered_name_mobile_number: l.registered_name_mobile_number,
  #     contract_start_date: l.contract_start_date,
  #     contract_end_date: l.contract_end_date,

  #   })
  #   |> limit(1)
  #   |> Repo.one()
  # end
    # Loanmanagementsystem.Operations.get_client_by_userid(56)
  def get_client_by_userid(userid) do
    UserBioData
    |> join(:left, [c], u in Loanmanagementsystem.Accounts.UserRole, on: c.userId == u.userId)
    |> join(:left, [c, u], uA in Loanmanagementsystem.Accounts.User, on: c.userId == uA.id)
    |> where([c, u, uA], c.userId == ^userid)
    |> select([c, u, uA], %{
      firstName: c.firstName,
      lastName: c.lastName,
      userId: c.userId,
      otherName: c.otherName,
      dateOfBirth: c.dateOfBirth,
      meansOfIdentificationType: c.meansOfIdentificationType,
      meansOfIdentificationNumber: c.meansOfIdentificationNumber,
      title: c.title,
      gender: c.gender,
      mobileNumber: c.mobileNumber,
      emailAddress: c.emailAddress,
      role_id: u.id,
      marital_status: c.marital_status,
      designation: c.designation,
      employee_number: c.employee_number,
      with_mou: uA.with_mou
    })
    |> Repo.one()
  end

  # Loanmanagementsystem.Operations.get_products_individual



  def get_products_individual() do
    Product
    |> where([p], (p.name != "BUSINESS TERM LOAN" and p.name != "Bussiness Term Loan") and p.status == "ACTIVE")
    |> select([p], %{
      id: p.id,
      clientId: p.clientId,
      code: p.code,
      currencyDecimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currencyName: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,
      maximumPrincipal: p.maximumPrincipal,
      minimumPrincipal: p.minimumPrincipal,
      name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      principle_account_id: p.principle_account_id,
      interest_account_id: p.interest_account_id,
      charges_account_id: p.charges_account_id,
      classification_id: p.classification_id,
      charge_id: p.charge_id,
      reference_id: p.reference_id,
      reason: p.reason,
      insurance: p.insurance,
      proccessing_fee: p.proccessing_fee,
      crb_fee: p.crb_fee,
    })|> Repo.all()
  end
  # Loanmanagementsystem.Operations.get_products_individual_by_product_id(1)

  def get_products_individual_by_product_id(product_id) do
    Product
    |> where([p], (p.name != "BUSINESS TERM LOAN" and p.name != "Bussiness Term Loan") and p.status == "ACTIVE" and p.id == ^product_id)
    |> select([p], %{
      id: p.id,
      clientId: p.clientId,
      product_code: p.code,
      currencyDecimals: p.currencyDecimals,
      currencyId: p.currencyId,
      currency_name: p.currencyName,
      defaultPeriod: p.defaultPeriod,
      details: p.details,
      interest: p.interest,
      interestMode: p.interestMode,
      interestType: p.interestType,

      max_amount: p.maximumPrincipal,
      min_amount: p.minimumPrincipal,
      product_name: p.name,
      period_type: p.periodType,
      product_type: p.productType,

      status: p.status,
      yearLengthInDays: p.yearLengthInDays,
      principle_account_id: p.principle_account_id,
      interest_account_id: p.interest_account_id,
      charges_account_id: p.charges_account_id,
      classification_id: p.classification_id,
      charge_id: p.charge_id,
      reference_id: p.reference_id,
      reason: p.reason,
      insurance: p.insurance,
      proccessing_fee: p.proccessing_fee,
      crb_fee: p.crb_fee,
    })|> Repo.all()
  end



  # Loanmanagementsystem.Operations.disbursed_loan_count(56)
  def disbursed_loan_count(user_id) do
    Loans
    |> where([l], l.customer_id == ^user_id and  fragment("lower(?) LIKE lower(?)", l.loan_status, ^"DISBURSED"))
    |> Repo.aggregate(:count)
  end


  # Loanmanagementsystem.Operations.rejected_loan_count(56)
  def rejected_loan_count(user_id) do
    Loans
    |> where([l], l.customer_id == ^user_id and  fragment("lower(?) LIKE lower(?)", l.loan_status, ^"REJECTED"))
    |> Repo.aggregate(:count)
  end


  # Loanmanagementsystem.Operations.loan_count(56)
  def loan_count(user_id) do
    Loans
    |> where([l], l.customer_id == ^user_id)
    |> Repo.aggregate(:count)
  end


  # Loanmanagementsystem.Operations.pending_loan_count(56) this the does something like the string.contains method
  def pending_loan_count(user_id) do
    Loans
    |> where([l], l.customer_id == ^user_id and  fragment("? ILIKE ?", l.loan_status, ^"%PENDING%"))
    |> Repo.aggregate(:count)
  end




  # Loanmanagementsystem.Operations.loan_interest_amount(1269)
  def loan_interest_amount(userid) do
    Loans
    |> join(:left, [l], a in "tbl_loan_amortization_schedule" ,on: l.id == a.loan_id)
    |> where([l], l.customer_id == ^userid)
    |> group_by([l,a], l.customer_id)
    |> select([l,a], %{
      overall_interest_amount: sum(a.interest),
      overall_balance: sum(a.payment)
    })
    |> Repo.all()
    # |> to_float_decimal()
  end

  # def to_float_decimal(map) do
  #   for map <- map |> Enum.count() -1 do
  #     interest_amount: Float.floor(map.interest_amount, 2)
  #     balance: Float.floor(map.balance, 2)
  #   end
  # end

  # Loanmanagementsystem.Operations.get_loan_by_userid(1269)
  def get_loan_by_userid(userid) do
    Loans
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> where([l, uB], l.customer_id == ^userid)
    |>select([l, uB], %{
      loan_id: l.id,
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      is_npa: l.is_npa,
      product_id: l.product_id,
      customer_id: l.customer_id,
      loan_type: l.loan_type,
      loan_status: l.loan_status,
      principal_amount_proposed: l.principal_amount_proposed,
      status: l.status,
      reference_no: l.reference_no,
      applied_date: l.inserted_at,
      loan_duration_month: l.loan_duration_month,
      # balance: fragment("select beginning_balance from tbl_loan_amortization_schedule where \"customer_id\" = ? and max(date) = ?", l.customer_id, true),
      balance: fragment("SELECT beginning_balance FROM tbl_loan_amortization_schedule WHERE reference_no = ? ORDER BY inserted_at DESC LIMIT 1", l.reference_no),
      interest_amount: fragment("select sum(interest) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no),
      repayment_amount: fragment("select sum(payment) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no),
      closedon_date: l.closedon_date,
      tenor: l.tenor,
      due_date: fragment("select max(date) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no)
    })
    |> Repo.all()
  end


    # Loanmanagementsystem.Operations.get_loan_by_userId_individualview_loan_tracking(1269)
  def get_loan_by_userId_individualview_loan_tracking(user_id) do
    Loans
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, s, uB], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, s, uB, p], l.customer_id == ^user_id)
    |> select([l, s, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      currency: p.currencyName,
      requested_amount: l.requested_amount,
      principal_amount: l.principal_amount,
      principal_amount_proposed: l.principal_amount_proposed,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      closedon_date: l.closedon_date,
      due_date: fragment("select max(date) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no),
      repayment_amount: l.repayment_amount,
      balance: fragment("SELECT beginning_balance FROM tbl_loan_amortization_schedule WHERE reference_no = ? ORDER BY inserted_at DESC LIMIT 1", l.reference_no),
      interest_amount: fragment("select sum(interest) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no)
    })
    |> Repo.all()
  end


    # Loanmanagementsystem.Operations.get_loan_by_user_id_for_repayment(1269)
  def get_loan_by_user_id_for_repayment(user_id) do
    Loans
    |> join(:left, [l], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |> join(:left, [l, uB], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, uB, p], l.customer_id == ^user_id and l.loan_status == "DISBURSED")
    |> select([l, uB, p], %{
      id: l.id,
      customer_id: l.customer_id,
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      principal_amount_proposed: l.principal_amount_proposed,
      product_name: p.name,
      product_id: p.id,
      currency: p.currencyName,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      closedon_date: l.closedon_date,
      repayment_amount: l.repayment_amount,
      interest_amount: l.interest_amount,
      reference_no: l.reference_no,
      requested_amount: l.requested_amount,
      due_date: fragment("select max(date) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no),
      balance: fragment("SELECT beginning_balance FROM tbl_loan_amortization_schedule WHERE reference_no = ? ORDER BY inserted_at DESC LIMIT 1", l.reference_no),
      interest_amount: fragment("select sum(interest) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no)
    })
    |> Repo.all()
  end
  # Loanmanagementsystem.Operations.get_user_info_by_user_id(56)
  def get_user_info_by_user_id(userid) do
    UserBioData
    |> where([uB], uB.userId == ^userid)
    |> select([uB], %{
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      title: uB.title,
      customer_id: uB.userId,
      marital_status: uB.marital_status,
      nationality: uB.nationality,
      employee_confirmation: uB.employee_confirmation,
      employee_number: uB.employee_number,
    })|> Repo.all()
  end

  # Loanmanagementsystem.Operations.get_last_five_loan_by_userid(56)
  def get_last_five_loan_by_userid(userid) do
    Loans
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> order_by([l,uB], desc: l.inserted_at)
    |> limit(5)
    |> where([l, uB], l.customer_id == ^userid)
    |>select([l, uB], %{
      loan_id: l.id,
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      is_npa: l.is_npa,
      product_id: l.product_id,
      customer_id: l.customer_id,
      loan_type: l.loan_type,
      loan_status: l.loan_status,
      principal_amount_proposed: l.principal_amount_proposed,
      status: l.status,
      reference_no: l.reference_no,
      applied_date: l.inserted_at,
      loan_duration_month: l.loan_duration_month,
      # balance: fragment("select beginning_balance from tbl_loan_amortization_schedule where \"customer_id\" = ? and max(date) = ?", l.customer_id, true),
      balance: fragment("SELECT beginning_balance FROM tbl_loan_amortization_schedule WHERE reference_no = ? ORDER BY inserted_at DESC LIMIT 1", l.reference_no),
      interest_amount: fragment("select sum(interest) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no),
      repayment_amount: fragment("select sum(payment) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no),
      closedon_date: l.closedon_date,
      tenor: l.tenor,
      due_date: fragment("select max(date) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no)
    })
    |> Repo.all()
  end


    # Loanmanagementsystem.Operations.get_loan_by_loan_id(5)
    def get_loan_by_loan_id(loan_id) do
      Loans
      |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
      |> where([l, uB], l.id == ^loan_id)
      |>select([l, uB], %{
        id: l.id,
        loan_id: l.id,
        customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
        is_npa: l.is_npa,
        product_id: l.product_id,
        customer_id: l.customer_id,
        loan_type: l.loan_type,
        loan_status: l.loan_status,
        principal_amount_proposed: l.principal_amount_proposed,
        status: l.status,
        reference_no: l.reference_no,
        applied_date: l.inserted_at,
        loan_duration_month: l.loan_duration_month,
        # balance: fragment("select beginning_balance from tbl_loan_amortization_schedule where \"customer_id\" = ? and max(date) = ?", l.customer_id, true),
        balance: fragment("SELECT beginning_balance FROM tbl_loan_amortization_schedule WHERE reference_no = ? ORDER BY inserted_at DESC LIMIT 1", l.reference_no),
        interest_amount: fragment("select sum(interest) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no),
        repayment_amount: fragment("select sum(payment) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no),
        closedon_date: l.closedon_date,
        tenor: l.tenor,
        due_date: fragment("select max(date) from tbl_loan_amortization_schedule where \"reference_no\" = ?", l.reference_no),
        disbursedon_date: l.disbursedon_date,
        interest_charged_derived: l.interest_charged_derived,
        annual_nominal_interest_rate: l.annual_nominal_interest_rate,
        repayment_type: l.repayment_type
      })
      |> Repo.one()

    end



   # Loanmanagementsystem.Operations.customer_relationship_officer(16)
  def customer_relationship_officer(cro_id) do
    User
    |> join(:left, [uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uA], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> where([uA, uB, uR],  uA.id == ^cro_id)
    |> select([uA, uB, uR], %{
      id: uA.id,
      status: uA.status,
      username: uA.username,
      firstname: uB.firstName,
      lastname: uB.lastName,
      othername: uB.otherName,
      dateofbirth: uB.dateOfBirth,
      meansofidentificationtype: uB.meansOfIdentificationType,
      meansofidentificationnumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobilenumber: uB.mobileNumber,
      emailaddress: uB.emailAddress,
      roletype: uR.roleType,
      company_id: uA.company_id
    })
    |> Repo.one()
  end

  # Loanmanagementsystem.Operations.get_documents_by_company_id(6)
  def get_documents_by_company_id(company_id) do
    Client_Documents
    |>where([c], c.company_id == ^company_id)
    |>select([c], %{
      id: c.id,
      name: c.name,
      path: c.path,
      company_id: c.company_id,
      userID: c.userID,
      docType: c.docType,
      status: c.status,
      clientID: c.clientID,
      createdBy: c.createdBy,
      approvedBy: c.approvedBy,
      file: c.file,
      loan_id: c.loan_id,
      file_category: c.file_category,
    })|> Repo.all()
  end

   # Loanmanagementsystem.Operations.get_company
  def get_company() do
    Company
    |> join(:left, [cO], bA in Bank, on: cO.bank_id == bA.id)
    |> join(:left, [cO, bA], aD in Address_Details, on: cO.id == aD.company_id)
    |> where([cO, bA, aD], is_nil(aD.userId) == true)
    |> select([cO, bA, aD], %{
      id: cO.id,
      companyName: cO.companyName,
      companyPhone: cO.companyPhone,
      contactEmail: cO.contactEmail,
      registrationNumber: cO.registrationNumber,
      companystatus: cO.status,
      taxno: cO.taxno,
      isSme: cO.isSme,
      isEmployer: cO.isEmployer,
      isOfftaker: cO.isOfftaker,
      companyAccountNumber: cO.companyAccountNumber,
      bank_id: cO.bank_id,
      companyRegistrationDate: cO.companyRegistrationDate,
      acronym: bA.acronym,
      bank_code: bA.bank_code,
      bank_descrip: bA.bank_descrip,
      center_code: bA.center_code,
      process_branch: bA.process_branch,
      swift_code: bA.swift_code,
      bankName: bA.bankName,
      status: cO.status,
      accomodation_status: aD.accomodation_status,
      area: aD.area,
      house_number: aD.house_number,
      street_name: aD.street_name,
      town: aD.town,
      company_id: aD.company_id,
      year_at_current_address: aD.year_at_current_address,
      province: aD.province,
      land_mark: aD.land_mark,

      employer_industry_type: cO.employer_industry_type,
      employer_office_building_name: cO.employer_office_building_name,
      employer_officer_street_name: cO.employer_officer_street_name,
    })
    |> Repo.all()
  end



  def get_company_by_id(company_id) do
    Company
    |> join(:left, [cO], bA in Bank, on: cO.bank_id == bA.id)
    |> join(:left, [cO, bA], aD in Address_Details, on: cO.id == aD.company_id)
    |> where([cO, bA, aD], cO.id == ^company_id)
    |> select([cO, bA, aD], %{
      id: cO.id,
      companyName: cO.companyName,
      companyPhone: cO.companyPhone,
      contactEmail: cO.contactEmail,
      registrationNumber: cO.registrationNumber,
      companystatus: cO.status,
      taxno: cO.taxno,
      isSme: cO.isSme,
      isEmployer: cO.isEmployer,
      isOfftaker: cO.isOfftaker,
      companyAccountNumber: cO.companyAccountNumber,
      bank_id: cO.bank_id,
      companyRegistrationDate: cO.companyRegistrationDate,
      acronym: bA.acronym,
      bank_code: bA.bank_code,
      bank_descrip: bA.bank_descrip,
      center_code: bA.center_code,
      process_branch: bA.process_branch,
      swift_code: bA.swift_code,
      bankName: bA.bankName,
      status: cO.status,
      accomodation_status: aD.accomodation_status,
      area: aD.area,
      house_number: aD.house_number,
      street_name: aD.street_name,
      town: aD.town,
      company_id: aD.company_id,
      year_at_current_address: aD.year_at_current_address,
      province: aD.province,
      land_mark: aD.land_mark,
    })
    |> Repo.all()
  end

  # make query to get repreaentatives for a specific company
  # Loanmanagementsystem.Operations.get_company_and_rep_details(6)
  def get_company_and_rep_details(company_id) do

    User
    |>join(:left, [uS], uB in UserBioData, on: uS.id == uB.userId)
    |>join(:left, [uS, uB], aD in Address_Details, on: uS.id == aD.userId)
    |>join(:left, [uS,uB, aD], bA in Bank, on: uB.bank_id == bA.id)
    |>where([uS, uB,aD, bA], uS.company_id == ^company_id)
    |> select([uS, uB,aD, bA], %{
      user_company_id: uS.company_id,
      user_status: uS.status,
      username: uS.username,
      user_dateOfBirth: uB.dateOfBirth,
      user_emailAddress: uB.emailAddress,
      user_firstName: uB.firstName,
      user_gender: uB.gender,
      user_lastName: uB.lastName,
      user_meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      user_meansOfIdentificationType: uB.meansOfIdentificationType,
      user_mobileNumber: uB.mobileNumber,
      user_designation: uB.designation,
      user_otherName: uB.otherName,
      user_title: uB.title,
      user_userId: uB.userId,
      user_idNo: uB.idNo,
      user_bank_id: uB.bank_id,
      user_bank_account_number: uB.bank_account_number,
      user_marital_status: uB.marital_status,
      user_nationality: uB.nationality,
      user_number_of_dependants: uB.number_of_dependants,
      acronym: bA.acronym,
      bank_code: bA.bank_code,
      bank_descrip: bA.bank_descrip,
      center_code: bA.center_code,
      process_branch: bA.process_branch,
      swift_code: bA.swift_code,
      bankName: bA.bankName,
      representative_1: uB.representative_1,
      representative_2: uB.representative_2,

      accomodation_status: aD.accomodation_status,
      area: aD.area,
      house_number: aD.house_number,
      street_name: aD.street_name,
      town: aD.town,

      year_at_current_address: aD.year_at_current_address,
      province: aD.province,
      land_mark: aD.land_mark,


    })
    |> Repo.all()
  end
  # Loanmanagementsystem.Operations.get_provisioning_criteria
  def get_provisioning_criteria() do
    Loan_Provisioning_Criteria
    |> join(:left, [lP], pR in Product, on: lP.productId == pR.id)
    |> select([lP, pR], %{
      category: lP.category,
      criteriaName: lP.criteriaName,
      expense_account_id: lP.expense_account_id,
      liability_account_id: lP.liability_account_id,
      maxAge: lP.maxAge,
      minAge: lP.minAge,
      percentage: lP.percentage,
      productId: lP.productId,
      clientId: pR.clientId,
      code: pR.code,
      currencyDecimals: pR.currencyDecimals,
      currencyId: pR.currencyId,
      currencyName: pR.currencyName,
      defaultPeriod: pR.defaultPeriod,
      details: pR.details,
      interest: pR.interest,
      interestMode: pR.interestMode,
      interestType: pR.interestType,
      maximumPrincipal: pR.maximumPrincipal,
      minimumPrincipal: pR.minimumPrincipal,
      name: pR.name,
      periodType: pR.periodType,
      productType: pR.productType,
      yearLengthInDays: pR.yearLengthInDays,
      principle_account_id: pR.principle_account_id,
      interest_account_id: pR.interest_account_id,
      charges_account_id: pR.charges_account_id,
      classification_id: pR.classification_id,
      charge_id: pR.charge_id,
      reference_id: pR.reference_id,
      reason: pR.reason
    })
    |> Repo.all()
  end




    # Loanmanagementsystem.Operations.get_offtaker_reps_details(2)
    def get_offtaker_reps_details(company_id) do
      offtaker = "OFFTAKER"
      User
      |> join(:left, [uA], uB in UserBioData, on: uA.id == uB.userId)
      |> join(:left, [uA], uR in UserRole, on: uA.id == uR.userId)
      |> where([uA, uB, uR], uR.roleType == ^offtaker and uA.company_id == ^company_id)
      |> select([uA, uB, uR], %{
        id: uA.id,
        status: uA.status,
        username: uA.username,
        firstname: uB.firstName,
        lastname: uB.lastName,
        othername: uB.otherName,
        dateofbirth: uB.dateOfBirth,
        meansofidentificationtype: uB.meansOfIdentificationType,
        meansofidentificationnumber: uB.meansOfIdentificationNumber,
        title: uB.title,
        gender: uB.gender,
        mobilenumber: uB.mobileNumber,
        emailaddress: uB.emailAddress,
        roletype: uR.roleType,
        company_id: uA.company_id,
        classification_id: uA.classification_id
      })
      |> Repo.all()
    end


    # Loanmanagementsystem.Operations.get_employer_reps_details(8)
    def get_employer_reps_details(company_id) do
      offtaker = "EMPLOYER"
      User
      |> join(:left, [uA], uB in UserBioData, on: uA.id == uB.userId)
      |> join(:left, [uA], uR in UserRole, on: uA.id == uR.userId)
      |> where([uA, uB, uR], uR.roleType == ^offtaker and uA.company_id == ^company_id)
      |> select([uA, uB, uR], %{
        id: uA.id,
        status: uA.status,
        username: uA.username,
        firstname: uB.firstName,
        lastname: uB.lastName,
        othername: uB.otherName,
        dateofbirth: uB.dateOfBirth,
        meansofidentificationtype: uB.meansOfIdentificationType,
        meansofidentificationnumber: uB.meansOfIdentificationNumber,
        title: uB.title,
        gender: uB.gender,
        mobilenumber: uB.mobileNumber,
        emailaddress: uB.emailAddress,
        roletype: uR.roleType,
        company_id: uA.company_id,
        classification_id: uA.classification_id
      })
      |> Repo.all()
    end

    # Loanmanagementsystem.Operations.get_sme_reps_details(2)
    def get_sme_reps_details(company_id) do
      sme = "SME"
      User
      |> join(:left, [uA], uB in UserBioData, on: uA.id == uB.userId)
      |> join(:left, [uA], uR in UserRole, on: uA.id == uR.userId)
      |> where([uA, uB, uR], uR.roleType == ^sme and uA.company_id == ^company_id)
      |> select([uA, uB, uR], %{
        id: uA.id,
        status: uA.status,
        username: uA.username,
        firstname: uB.firstName,
        lastname: uB.lastName,
        othername: uB.otherName,
        dateofbirth: uB.dateOfBirth,
        meansofidentificationtype: uB.meansOfIdentificationType,
        meansofidentificationnumber: uB.meansOfIdentificationNumber,
        title: uB.title,
        gender: uB.gender,
        mobilenumber: uB.mobileNumber,
        emailaddress: uB.emailAddress,
        roletype: uR.roleType,
        company_id: uA.company_id,
        classification_id: uA.classification_id
      })
      |> Repo.all()
    end

    alias Loanmanagementsystem.Loan.Loans
    # Loanmanagementsystem.Operations.get_all_loans()
    def get_all_loans() do
      Loans
      |>join(:left, [lO], uB in UserBioData, on: lO.customer_id == uB.userId)
      |>select([lO, uB], %{
        approvedon_date: lO.approvedon_date,
        rejectedon_date: lO.rejectedon_date,
        requested_amount: lO.requested_amount,
        application_date: lO.application_date,
        cro_id: lO.cro_id,
        # client_name: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
        client_name: fragment("select distinct case when company_name is null then concat(?, concat(' ', ?)) else company_name end from tbl_loan_customer_details where reference_no = ?", uB.firstName, uB.lastName, lO.reference_no),
        loan_status: lO.loan_status,
        reason: lO.reason,
        id: lO.id,
        total_loan: fragment("select sum(requested_amount) from tbl_loans"),
        loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
        # loan_officer: fragment("select \"firstName\"  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
      })|> Repo.all()
    end



    # Loanmanagementsystem.Operations.view_customers
    def view_customers() do

      User
      |>join(:left, [uS], uB in UserBioData, on: uS.id == uB.userId)
      |>join(:left, [uS, uB], uR in UserRole, on: uS.id == uR.userId)
      |> where([uS, uB, uR], uR.roleType == "INDIVIDUALS" or uR.roleType == "SME" or uR.roleType == "EMPLOYEE" or uR.roleType == "EMPLOYER" or uR.roleType == "OFFTAKER")
      |> select([uS, uB, uR], %{
        # Users
        status: uS.status ,
        username: uS.username ,
        company_id: uS.company_id ,

        # UserBioData

        dateOfBirth: uB.dateOfBirth ,
        emailAddress: uB.emailAddress ,
        firstName: uB.firstName ,
        gender: uB.gender ,
        lastName: uB.lastName ,
        meansOfIdentificationNumber: uB.meansOfIdentificationNumber ,
        meansOfIdentificationType: uB.meansOfIdentificationType ,
        mobileNumber: uB.mobileNumber ,
        otherName: uB.otherName ,
        title: uB.title ,
        userId: uB.userId ,
        bank_id: uB.bank_id ,
        bank_account_number: uB.bank_account_number ,
        marital_status: uB.marital_status ,
        nationality: uB.nationality ,
        number_of_dependants: uB.number_of_dependants ,
        representative_1: uB.representative_1 ,
        representative_2: uB.representative_2 ,

        # UserROle
        roleType: uR.roleType ,
        otp: uR.otp ,
        client_type: uR.client_type ,
        isStaff: uR.isStaff ,
        loan_limit: uR.loan_limit ,

      })
      |>Repo.all()

    end





      # Loanmanagementsystem.Operations.list_customer(nil, 1, 10)

  def list_customer(search_params, page, size) do
    UserBioData
    |> handle_customer_filter(search_params)
    |> order_by([uB, uR], desc: uB.inserted_at)
    |> compose_list_customer()
    |> Repo.paginate(page: page, page_size: size)
  end

  def list_customer(_source, search_params) do
    UserBioData
    |> handle_customer_filter(search_params)
    |> order_by([uB, uR], desc: uB.inserted_at)
    |> compose_list_customer()
  end

  defp compose_list_customer(query) do
    query
    |>join(:left, [uB], uR in UserRole, on: uB.userId == uR.userId)
    |> where([uB, uR], uR.roleType == "INDIVIDUALS" or uR.roleType == "SME" or uR.roleType == "EMPLOYEE" or uR.roleType == "EMPLOYER" or uR.roleType == "OFFTAKER")
    |> select(
      [uB, uR],
      %{


        # UserBioData
        dateOfBirth: uB.dateOfBirth ,
        emailAddress: uB.emailAddress ,
        firstName: uB.firstName ,
        gender: uB.gender ,
        lastName: uB.lastName ,
        meansOfIdentificationNumber: uB.meansOfIdentificationNumber ,
        meansOfIdentificationType: uB.meansOfIdentificationType ,
        mobileNumber: uB.mobileNumber ,
        otherName: uB.otherName ,

        userId: uB.userId ,
        bank_id: uB.bank_id ,
        bank_account_number: uB.bank_account_number ,
        marital_status: uB.marital_status ,
        nationality: uB.nationality ,
        number_of_dependants: uB.number_of_dependants ,
        representative_1: uB.representative_1 ,
        representative_2: uB.representative_2 ,

        # UserROle
        roleType: uR.roleType ,
        otp: uR.otp ,
        client_type: uR.client_type ,
        isStaff: uR.isStaff ,
        loan_limit: uR.loan_limit,
        title: fragment("select title from tbl_users where \"id\" = ?", uB.userId),
      }
    )
  end


defp handle_customer_filter(query, %{"isearch" => search_term} = search_params)
  when search_term == "" or is_nil(search_term) do
IO.inspect(search_params, label: "search_params---------------------")
query
|> handle_customer_registration_date(search_params)
|> handle_gender_filter(search_params)
|> handle_registration_number_filter(search_params)
|> handle_phone_number_filter(search_params)
end

defp handle_customer_filter(query, %{"isearch" => search_term}) do
search_term = "%#{search_term}%"
compose_customer_isearch_filter(query, search_term)
end


defp handle_customer_registration_date(query, %{"filter_registration_date" => filter_registration_date, "filter_registration_date_to" => filter_registration_date_to})
when byte_size(filter_registration_date) > 0 and byte_size(filter_registration_date_to) > 0 do
query
|> where(
  [uB, uR],
  fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", uB.inserted_at, ^filter_registration_date) and
  fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", uB.inserted_at, ^filter_registration_date_to)
)
end

defp handle_customer_registration_date(query, _params), do: query


defp handle_gender_filter(query, %{"filter_gender" => filter_gender}) do
  if filter_gender =="" do
    where(
      query,
      [uB, uR],
      fragment("lower(?) LIKE lower(?)", uB.gender, ^"%#{filter_gender}%")
    )
  else
    where(
      query,
      [uB, uR],
      uB.gender == ^filter_gender
    )
  end
end

defp handle_gender_filter(query, %{"filter_gender" => filter_gender})
      when filter_gender == "" or is_nil(filter_gender),
      do: query


defp handle_registration_number_filter(query, %{"filter_registration_id" => filter_registration_id}) do
  if filter_registration_id =="" do
    where(
      query,
      [uB, uR],
      fragment("lower(?) LIKE lower(?)", uB.meansOfIdentificationNumber, ^"%#{filter_registration_id}%")
    )
  else
    where(
      query,
      [uB, uR],
      uB.meansOfIdentificationNumber == ^filter_registration_id
    )
  end
end

defp handle_registration_number_filter(query, %{"filter_registration_id" => filter_registration_id})
      when filter_registration_id == "" or is_nil(filter_registration_id),
      do: query

defp handle_phone_number_filter(query, %{"filter_phone_number" => filter_phone_number}) do
  if filter_phone_number =="" do
    where(
      query,
      [uB, uR],
      fragment("lower(?) LIKE lower(?)", uB.mobileNumber, ^"%#{filter_phone_number}%")
    )
  else
    where(
      query,
      [uB, uR],
      uB.mobileNumber == ^filter_phone_number
    )
  end
end

defp handle_phone_number_filter(query, %{"filter_phone_number" => filter_phone_number})
      when filter_phone_number == "" or is_nil(filter_phone_number),
      do: query


defp compose_customer_isearch_filter(query, search_term) do
  query
  |> where(
    [uS, uB, uR],
    fragment("lower(?) LIKE lower(?)", uS.inserted_at, ^search_term)or
    fragment("lower(?) LIKE lower(?)", uB.title, ^search_term) or
    fragment("lower(?) LIKE lower(?)", uS.status, ^search_term) or
    fragment("lower(?) LIKE lower(?)", uB.gender, ^search_term) or
    fragment("lower(?) LIKE lower(?)", uB.meansOfIdentificationNumber, ^search_term)
      # fragment("lower(?) LIKE lower(?)", lO.rejectedon_date, ^search_term)
  )
end












  # Loanmanagementsystem.Operations.loan_list(nil, 1, 10)

  def loan_list(search_params, page, size) do
    Loans
    |> handle_loan_filter(search_params)
    |> order_by([lO, uB], desc: lO.inserted_at)
    |> compose_loan_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def loan_list(_source, search_params) do
    Loans
    |> handle_loan_filter(search_params)
    |> order_by([lO, uB], desc: lO.inserted_at)
    |> compose_loan_list()
  end

  defp compose_loan_list(query) do
    query
    |>join(:left, [lO], uB in UserBioData, on: lO.customer_id == uB.userId)
    |> select(
      [lO, uB],
      %{
        approvedon_date: lO.approvedon_date,
        rejectedon_date: lO.rejectedon_date,
        requested_amount: lO.requested_amount,
        application_date: lO.application_date,
        cro_id: lO.cro_id,
        # client_name: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
        client_name: fragment("select distinct case when company_name is null then concat(?, concat(' ', ?)) else company_name end from tbl_loan_customer_details where reference_no = ?", uB.firstName, uB.lastName, lO.reference_no),
        loan_status: lO.loan_status,
        reason: lO.reason,
        id: lO.id,
        total_loan: fragment("select sum(requested_amount) from tbl_loans"),
        loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
        nrc_number: uB.meansOfIdentificationNumber,
        account_no: lO.account_no,
        duedate: fragment("select max(date) from tbl_loan_amortization_schedule where \"customer_id\" = ?", uB.userId),
        total_loan: lO.balance,
        # interest: lO.interest
      }
    )
  end

  defp handle_loan_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_status_filter(search_params)
    |> handle_application_date(search_params)
    |> handle_filter_loan_id(search_params)
    |> handle_approvedon_date(search_params)
    |> handle_filter_requested_amount(search_params)
    # |> handle_created_date_filter(search_params)
  end

  defp handle_loan_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_loan_isearch_filter(query, search_term)
  end

  # defp handle_product_name_filter(query, %{"filter_product_name" => filter_product_name}) do
  #   where(query, [p], fragment("lower(?) LIKE lower(?)", p.name, ^"%#{filter_product_name}%"))
  # end

  # defp handle_product_name_filter(query, %{"filter_product_name" => filter_product_name})
  #      when filter_product_name == "" or is_nil(filter_product_name),
  #      do: query

  defp handle_status_filter(query, %{"filter_loan_status" => filter_loan_status}) do
    where(
      query,
      [lO, uB],
      fragment("lower(?) LIKE lower(?)", lO.loan_status, ^"%#{filter_loan_status}%")
    )
  end

  defp handle_status_filter(query, %{"filter_loan_status" => filter_loan_status})
       when filter_loan_status == "" or is_nil(filter_loan_status),
       do: query


  # defp handle_application_date(query, %{"filter_application_date" => filter_application_date}) do
  #   where(
  #     query,
  #     [lO, uB],
  #     fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", lO.application_date, ^filter_application_date)
  #   )
  # end
  defp handle_application_date(query, %{"filter_application_date" => filter_application_date, "filter_application_date_to" => filter_application_date_to})
    when byte_size(filter_application_date) > 0 and byte_size(filter_application_date_to) > 0 do
    query
    |> where(
      [lO, uB],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", lO.approvedon_date, ^filter_application_date) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", lO.approvedon_date, ^filter_application_date_to)
    )
  end

defp handle_application_date(query, _params), do: query

  # defp handle_application_date(query, %{"filter_application_date" => filter_application_date})
  #   when filter_application_date == "" or is_nil(filter_application_date),
  #   do: query



  defp handle_filter_loan_id(query, %{"filter_loan_id" => filter_loan_id}) do
    where(
      query,
      [lO, uB],
      fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", lO.id, ^"%#{filter_loan_id}%")
    )
  end

  defp handle_filter_loan_id(query, %{"filter_loan_id" => filter_loan_id})
        when filter_loan_id == "" or is_nil(filter_loan_id),
        do: query


    defp handle_filter_cro(query, %{"filter_loan_cro" => filter_loan_cro})
    when filter_loan_cro == "" or is_nil(filter_loan_cro),
    do: query

    defp handle_filter_cro(query, %{"filter_loan_cro" => filter_loan_cro}) do
    where(query, [lO, uB], fragment("lower(CAST(? AS TEXT)) LIKE lower(CAST(? AS TEXT))", lO.cro_id, ^"%#{filter_loan_cro}%"))
    end


    # defp handle_approvedon_date(query, %{"filter_approvedon_date" => filter_approvedon_date}) do
    #   where(
    #     query,
    #     [lO, uB],
    #     fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", lO.rejectedon_date, ^filter_approvedon_date)
    #   )
    # end

    # defp handle_approvedon_date(query, %{"filter_approvedon_date" => filter_approvedon_date})
    #   when filter_approvedon_date == "" or is_nil(filter_approvedon_date),
    #   do: query

  defp handle_filter_requested_amount(query, %{
         "filter_requested_amount" => filter_requested_amount
       }) do
    where(
      query,
      [lO, uB],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        lO.requested_amount,
        ^"%#{filter_requested_amount}%"
      )
    )
  end

  defp handle_filter_requested_amount(query, %{
         "filter_requested_amount" => filter_requested_amount
       })
       when filter_requested_amount == "" or is_nil(filter_requested_amount),
       do: query

    defp handle_approvedon_date(query, %{"approvedon_date_from" => approvedon_date_from, "approvedon_date_to" => approvedon_date_to})
      when byte_size(approvedon_date_from) > 0 and byte_size(approvedon_date_to) > 0 do
      query
      |> where(
        [lO, uB],
        fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", lO.approvedon_date, ^approvedon_date_from) and
          fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", lO.approvedon_date, ^approvedon_date_to)
      )
    end

    defp handle_approvedon_date(query, _params), do: query

  # defp handle_maximum_principal_filter(query, %{
  #        "filter_maximum_principal" => filter_maximum_principal
  #      }) do
  #   where(
  #     query,
  #     [p],
  #     fragment(
  #       "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
  #       p.maximumPrincipal,
  #       ^"%#{filter_maximum_principal}%"
  #     )
  #   )
  # end

  # defp handle_maximum_principal_filter(query, %{
  #        "filter_maximum_principal" => filter_maximum_principal
  #      })
  #      when filter_maximum_principal == "" or is_nil(filter_maximum_principal),
  #      do: query

  # defp handle_created_date_filter(query, %{"from" => from, "to" => to})
  #      when byte_size(from) > 0 and byte_size(to) > 0 do
  #   query
  #   |> where(
  #     [p],
  #     fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", p.inserted_at, ^from) and
  #       fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", p.inserted_at, ^to)
  #   )
  # end

  # defp handle_created_date_filter(query, _params), do: query

  defp compose_loan_isearch_filter(query, search_term) do
    query
    |> where(
      [lO, uB],
      fragment("lower(?) LIKE lower(?)", lO.application_date, ^search_term) or
      fragment("lower(?) LIKE lower(?)", lO.loan_status, ^search_term) or
      fragment("lower(?) LIKE lower(?)", lO.id, ^search_term) or
      fragment("lower(?) LIKE lower(?)", lO.approvedon_date, ^search_term)or
      fragment("lower(?) LIKE lower(?)", lO.requested_amount, ^search_term)
        # fragment("lower(?) LIKE lower(?)", lO.rejectedon_date, ^search_term)
    )
  end























  # DIsbursed Loans


  # Loanmanagementsystem.Operations.disbursed_loan_list(nil, 1, 10)

  def disbursed_loan_list(search_params, page, size) do
    Loans
    |> handle_disbursed_loan_list_filter(search_params)
    |> order_by([lO], desc: lO.inserted_at)
    |> compose_disbursed_loan_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def disbursed_loan_list(_source, search_params) do
    Loans
    |> handle_disbursed_loan_list_filter(search_params)
    |> order_by([lO], desc: lO.inserted_at)
    |> compose_disbursed_loan_list()
  end

  defp compose_disbursed_loan_list(query) do
    query
    |>where([lO], lO.loan_status == ^"DISBURSED")
    |> select(
      [lO],
      %{
        disbursedon_date: lO.disbursedon_date,
        approvedon_date: lO.approvedon_date,
        rejectedon_date: lO.rejectedon_date,
        requested_amount: lO.requested_amount,
        application_date: lO.application_date,
        cro_id: lO.cro_id,
        # client_name:  fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.customer_id),
        client_name: fragment("select case when a.company_name is null then concat(b.\"firstName\", concat(' ', b.\"lastName\")) else a.company_name end from tbl_loan_customer_details a, tbl_user_bio_data b  where a.customer_id = b. \"userId\" and  a.reference_no = ? ", lO.reference_no),
        loan_status: lO.loan_status,
        reason: lO.reason,
        expiry_year: lO.expiry_year,
        expiry_month: lO.expiry_month,
        id: lO.id,
        total_loan: fragment("select sum(requested_amount) from tbl_loans"),
        loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
        duedate: fragment("select max(date) from tbl_loan_amortization_schedule where \"loan_id\" = ? and \"customer_id\" = ?", lO.id, lO.customer_id),
        fromdate: lO.application_date,
        account_no: lO.account_no,
        net_loan: fragment("select ROUND(CAST(net_disbiursed AS numeric), 2) from tbl_loan_disbursement_schedule where  \"loan_id\" = ? and \"reference_no\" = ?  and \"customer_id\" = ?", lO.id, lO.reference_no, lO.customer_id),
        occupation: fragment("select occupation from tbl_employment_details   where  \"userId\" = ?", lO.customer_id),
        employer: fragment("select employer from tbl_employment_details   where  \"userId\" = ?", lO.customer_id),

      }
    )
  end


  def daily_disbursed_loan_list(search_params, page, size) do
    Loans
    |> handle_disbursed_loan_list_filter(search_params)
    |> order_by([lO], desc: lO.inserted_at)
    |> compose_disbursed_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def daily_disbursed_loan_list(_source, search_params) do
    Loans
    |> handle_disbursed_loan_list_filter(search_params)
    |> order_by([lO], desc: lO.inserted_at)
    |> compose_disbursed_list()
  end

  defp compose_disbursed_list(query) do
    query
    |>where([lO], lO.loan_status == ^"DISBURSED")
    |> select(
      [lO],
      %{
        branch: fragment("select branch from tbl_user_bio_data where \"userId\" = ?", lO.customer_id),
        client_no: lO.customer_id,
        product_name: fragment("select name from tbl_products where \"id\" = ?", lO.product_id),
        business_sector: "",
        interest_rate: fragment("select  interest * 12 from tbl_products where \"id\" = ?", lO.product_id),
        repeat_loan: "",
        collateral_deposit: "",
        opening_date_deposit: "",
        expiration_date_deposit: "",
        pmec_value: "",
        pmec: "",
        phone_no: fragment("select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
        portfolio_category: "",
        interest: fragment("select ROUND(CAST(sum(interest) AS numeric), 2) from tbl_loan_amortization_schedule where loan_id = ?", lO.id),
        disbursedon_date: lO.disbursedon_date,
        approvedon_date: lO.approvedon_date,
        rejectedon_date: lO.rejectedon_date,
        requested_amount: lO.requested_amount,
        application_date: lO.application_date,
        cro_id: lO.cro_id,
        # client_name:  fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.customer_id),
        client_name: fragment("select distinct case when a.company_name is null then concat(b.\"firstName\", concat(' ', b.\"lastName\")) else a.company_name end from tbl_loan_customer_details a, tbl_user_bio_data b  where a.customer_id = b. \"userId\" and  a.reference_no = ? ", lO.reference_no),
        loan_status: lO.loan_status,
        reason: lO.reason,
        expiry_year: lO.expiry_year,
        expiry_month: lO.expiry_month,
        id: lO.id,
        total_loan: fragment("select sum(requested_amount) from tbl_loans"),
        loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
        duedate: fragment("select max(date) from tbl_loan_amortization_schedule where \"loan_id\" = ? and \"customer_id\" = ?", lO.id, lO.customer_id),
        fromdate: lO.application_date,
        account_no: lO.account_no,
        net_loan: fragment("select ROUND(CAST(net_disbiursed AS numeric), 2) from tbl_loan_disbursement_schedule where  \"loan_id\" = ? and \"reference_no\" = ?  and \"customer_id\" = ?", lO.id, lO.reference_no, lO.customer_id),
        occupation: fragment("select occupation from tbl_employment_details   where  \"userId\" = ?", lO.customer_id),
        employer: fragment("select employer from tbl_employment_details   where  \"userId\" = ?", lO.customer_id),

      }
    )
  end

  def daily_deliquency_list(search_params, page, size) do
    Loans
    |> join(:left, [lO], lT in Journal_entries, on: lO.id == lT.loan_id)
    |> where([lO, lT], lT.drcr_ind == ^"C" and lT.process_status == ^"APPROVED")
    |> handle_disbursed_loan_list_filter(search_params)
    |> group_by([lO, lT], lO.cro_id)
    |> compose_dialy_deliquency_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def daily_deliquency_list(_source, search_params) do
    Loans
    |> join(:left, [lO], lT in Journal_entries, on: lO.id == lT.loan_id)
    |> where([lO, lT], lT.drcr_ind == ^"C" and lT.process_status == ^"APPROVED")
    |> handle_disbursed_loan_list_filter(search_params)
    |> group_by([lO, lT], lO.cro_id)
    |> compose_dialy_deliquency_list()
  end


  defp compose_dialy_deliquency_list(query) do
    query
    |> select(
      [lO, lT],
      %{
        credit_agent_ac: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
        outstanding_portofilo: fragment("select ROUND(CAST( sum(a.payment) - ? AS numeric), 2) from tbl_loan_amortization_schedule a  left join tbl_loans b on a.loan_id = b.id where b.cro_id = ?", sum(lT.lcy_amount), lO.cro_id),
        amount_par1: fragment("select ROUND(CAST( sum(a.payment) AS numeric), 2) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date BETWEEN 0 AND 29 and b.cro_id = ?",  lO.cro_id),
        amount_par30: fragment("select ROUND(CAST( sum(a.payment) AS numeric), 2) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date BETWEEN 30 AND 59 and b.cro_id = ?", lO.cro_id),
        amount_par60: fragment("select ROUND(CAST( sum(a.payment) AS numeric), 2) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date BETWEEN 60 AND 89 and b.cro_id = ?", lO.cro_id),
        amount_par90: fragment("select ROUND(CAST(sum(a.payment) AS numeric), 2) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date  >= 90 and b.cro_id = ?", lO.cro_id),
        par1: (fragment("select ROUND(CAST( sum(a.payment) AS numeric), 2) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date BETWEEN 0 AND 29 and b.cro_id = ?",  lO.cro_id) / fragment("select ROUND(CAST( sum(a.payment) - ? AS numeric), 2) from tbl_loan_amortization_schedule a  left join tbl_loans b on a.loan_id = b.id where b.cro_id = ?", sum(lT.lcy_amount), lO.cro_id)) * 100,
        par30: (fragment("select ROUND(CAST( sum(a.payment) AS numeric), 2) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date BETWEEN 30 AND 59 and b.cro_id = ?",  lO.cro_id) / fragment("select ROUND(CAST( sum(a.payment) - ? AS numeric), 2) from tbl_loan_amortization_schedule a  left join tbl_loans b on a.loan_id = b.id where b.cro_id = ?", sum(lT.lcy_amount), lO.cro_id)) * 100,
        par60: (fragment("select ROUND(CAST( sum(a.payment) AS numeric), 2) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date BETWEEN 60 AND 89 and b.cro_id = ?",  lO.cro_id) / fragment("select ROUND(CAST( sum(a.payment) - ? AS numeric), 2) from tbl_loan_amortization_schedule a  left join tbl_loans b on a.loan_id = b.id where b.cro_id = ?", sum(lT.lcy_amount), lO.cro_id)) * 100,
        par90: (fragment("select ROUND(CAST( sum(a.payment) AS numeric), 2) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date >= 90 and b.cro_id = ?",  lO.cro_id) / fragment("select ROUND(CAST( sum(a.payment) - ? AS numeric), 2) from tbl_loan_amortization_schedule a  left join tbl_loans b on a.loan_id = b.id where b.cro_id = ?", sum(lT.lcy_amount), lO.cro_id)) * 100,
      }
    )
  end

  # defp compose_dialy_deliquency_list(query) do
  #   query
  #   |> select(
  #     [lO, lA, lT],
  #     %{
  #       credit_agent_ac: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
  #       outstanding_portofilo: fragment("select ? - sum(lcy_amount) from tbl_trans_log a  left join tbl_loans b on a.loan_id = b.id where a.drcr_ind = 'C' and a.process_status = 'APPROVED' and b.cro_id = ?", sum(lA.payment), lO.cro_id),
  #       amount_par1: fragment("select sum( a.payment) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date BETWEEN 0 AND 29 and b.cro_id = ?",  lO.cro_id),
  #       amount_par30: fragment("select sum( a.payment) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date BETWEEN 30 AND 59 and b.cro_id = ?", lO.cro_id),
  #       amount_par60: fragment("select sum( a.payment) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date BETWEEN 60 AND 89 and b.cro_id = ?", lO.cro_id),
  #       amount_par90: fragment("select sum( a.payment) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where    current_date - a.date  >= 90 and b.cro_id = ?", lO.cro_id),
  #       par1: fragment("select sum( a.payment) / ? - sum(lcy_amount) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where  current_date - a.date BETWEEN 0 AND 29 and b.cro_id = ?",  sum(lA.payment), lO.cro_id),
  #       # par1: fragment("select ROUND(CAST( (( ? - sum(distinct(b.lcy_amount))) / (sum(a.payment)) * 100) AS numeric), 2) from  tbl_loan_amortization_schedule a left join tbl_trans_log b on a.loan_id = b.loan_id left join tbl_loans c on a.loan_id = c.id where b.drcr_ind = 'C' and b.process_status = 'APPROVED'  and current_date - a.date BETWEEN 0 AND 29 and c.cro_id = ?", sum(lA.payment), lO.cro_id),
  #       par30: fragment("select ROUND(CAST( (( ? - sum( (b.lcy_amount))) / (sum(a.payment)) * 100) AS numeric), 2) from  tbl_loan_amortization_schedule a left join tbl_trans_log b on a.loan_id = b.loan_id left join tbl_loans c on a.loan_id = c.id where b.drcr_ind = 'C' and b.process_status = 'APPROVED'  and current_date - a.date BETWEEN 30 AND 59 and c.cro_id = ?", sum(lA.payment), lO.cro_id),
  #       par60: fragment("select ROUND(CAST( (( ? - sum( (b.lcy_amount))) / (sum(a.payment)) * 100) AS numeric), 2) from  tbl_loan_amortization_schedule a left join tbl_trans_log b on a.loan_id = b.loan_id left join tbl_loans c on a.loan_id = c.id where b.drcr_ind = 'C' and b.process_status = 'APPROVED'  and current_date - a.date BETWEEN 60 AND 89 and c.cro_id = ?", sum(lA.payment), lO.cro_id),
  #       par90: fragment("select ROUND(CAST( (( ? - sum( (b.lcy_amount))) / (sum(a.payment)) * 100) AS numeric), 2) from  tbl_loan_amortization_schedule a left join tbl_trans_log b on a.loan_id = b.loan_id left join tbl_loans c on a.loan_id = c.id where b.drcr_ind = 'C' and b.process_status = 'APPROVED'  and CURRENT_DATE - a.date  >= 90 and c.cro_id = ?", sum(lA.payment), lO.cro_id)

  #     }
  #   )
  # end

  # below is the sample alternative for PAR (Percentage at Risk) Calculations
  # amount_part30: fragment("select sum(a.payment) from tbl_loan_amortization_schedule a left join tbl_loans b on a.loan_id = b.id where a.calculation_date IS NOT NULL and a.calculation_date + INTERVAL '59 days' < CURRENT_DATE and b.cro_id = ?", lO.cro_id),


  def user_activity_logs(search_params, page, size) do
    UserLogs
    |> join(:left, [uL], uA in "tbl_users", on: uL.user_id == uA.id)
    |> join(:left, [ul, uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uL, uA, uB], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> handle_user_activity_logs_list_filter(search_params)
    |> compose_user_activity_logs_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def user_activity_logs(_source, search_params) do
    UserLogs
    |> join(:left, [uL], uA in "tbl_users", on: uL.user_id == uA.id)
    |> join(:left, [ul, uA], uB in "tbl_user_bio_data", on: uA.id == uB.userId)
    |> join(:left, [uL, uA, uB], uR in "tbl_user_roles", on: uA.id == uR.userId)
    |> handle_user_activity_logs_list_filter(search_params)
    |> compose_user_activity_logs_list()
  end

  defp compose_user_activity_logs_list(query) do
    query
    |> select(
      [uL, uA, uB, uR],
      %{
        id: uL.id,
        username: uA.username,
        firstName: fragment("select \"firstName\" from tbl_user_bio_data where \"userId\" = ?", uA.id),
        lastName: fragment("select \"lastName\" from tbl_user_bio_data where \"userId\" = ?", uA.id),
        otherName: fragment("select \"otherName\" from tbl_user_bio_data where \"userId\" = ?", uA.id),
        dateOfBirth: fragment("select \"dateOfBirth\" from tbl_user_bio_data where \"userId\" = ?", uA.id),
        meansOfIdentificationType: fragment("select \"meansOfIdentificationType\" from tbl_user_bio_data where \"userId\" = ?", uA.id),
        meansOfIdentificationNumber: fragment("select \"meansOfIdentificationNumber\" from tbl_user_bio_data where \"userId\" = ?", uA.id),
        title: fragment("select \"title\" from tbl_user_bio_data where \"userId\" = ?", uA.id),
        gender: fragment("select \"gender\" from tbl_user_bio_data where \"userId\" = ?", uA.id),
        mobileNumber: fragment("select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?", uA.id),
        emailAddress: fragment("select \"emailAddress\" from tbl_user_bio_data where \"userId\" = ?", uA.id),
        roleType: fragment("select \"roleType\" from tbl_user_roles where \"userId\" = ?", uA.id),
        activity: uL.activity,
        inserted_at: fragment("select distinct ? + INTERVAL '2 hours' AS new_timestamp from tbl_user_logs where user_id = ?", uL.inserted_at, uA.id),
        userId: uA.id
      }
    )
  end



  defp handle_user_activity_logs_list_filter(query, %{"isearch" => search_term} = search_params)
  when search_term == "" or is_nil(search_term) do
  query
  |> handle_filter_mobileno(search_params)
  |> handle_filter_email_address(search_params)
  |> handle_filter_user_role(search_params)
  |> handle_filter_activity(search_params)
  |> handle_user_activity_created_date_filter(search_params)
  end


defp handle_user_activity_created_date_filter(query, %{"filter_application_date_from" => filter_application_date_from, "filter_application_date_to" => filter_application_date_to})
when filter_application_date_from == "" or is_nil(filter_application_date_from) or filter_application_date_to == "" or is_nil(filter_application_date_to),
do: query

defp handle_user_activity_created_date_filter(query, %{"filter_application_date_from" => filter_application_date_from, "filter_application_date_to" => filter_application_date_to}) do
query
|> where(
[uL, uA, uB, uR],

fragment("CAST(? AS DATE) >= ?", uL.inserted_at, ^Date.from_iso8601!(filter_application_date_from)) and
fragment("CAST(? AS DATE) <= ?", uL.inserted_at, ^Date.from_iso8601!(filter_application_date_to))
)
end

defp handle_filter_mobileno(query, %{"filter_mobileno" => filter_mobileno})
      when filter_mobileno == "" or is_nil(filter_mobileno),
      do: query

defp handle_filter_mobileno(query, %{"filter_mobileno" => filter_mobileno}) do
  where(
    query,
    [uL, uA, uB, uR],
    fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", uB.mobileNumber, ^filter_mobileno)
  )
end

defp handle_filter_email_address(query, %{"filter_email_address" => filter_email_address})
      when filter_email_address == "" or is_nil(filter_email_address),
      do: query

defp handle_filter_email_address(query, %{"filter_email_address" => filter_email_address}) do
  where(
    query,
    [uL, uA, uB, uR],
    fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", uB.emailAddress, ^filter_email_address)
  )
end


defp handle_filter_user_role(query, %{"filter_user_role" => filter_user_role})
      when filter_user_role == "" or is_nil(filter_user_role),
      do: query

defp handle_filter_user_role(query, %{"filter_user_role" => filter_user_role}) do
  where(
    query,
    [uL, uA, uB, uR],
    fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", uR.roleType, ^filter_user_role)
  )
end

defp handle_filter_activity(query, %{"filter_activity" => filter_activity})
      when filter_activity == "" or is_nil(filter_activity),
      do: query

defp handle_filter_activity(query, %{"filter_activity" => filter_activity}) do
  where(
    query,
    [uL, uA, uB, uR],
    fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", uL.activity, ^filter_activity)
  )
end


  defp handle_disbursed_loan_list_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_filter_disbursed_approvedon_date(search_params)
    |> handle_disbursed_application_date(search_params)
    |> handle_filter_loan_id(search_params)
    |> handle_filter_requested_amount(search_params)
    # |> handle_filter_requested_amount(search_params)
    # |> handle_created_date_filter(search_params)
  end

  # defp handle_disbursed_loan_list_filter(query, %{"isearch" => search_term}) do
  #   search_term = "%#{search_term}%"
  #   compose_loan_isearch_filter(query, search_term)
  # end

  # # defp handle_product_name_filter(query, %{"filter_product_name" => filter_product_name}) do
  # #   where(query, [p], fragment("lower(?) LIKE lower(?)", p.name, ^"%#{filter_product_name}%"))
  # # end

  # # defp handle_product_name_filter(query, %{"filter_product_name" => filter_product_name})
  # #      when filter_product_name == "" or is_nil(filter_product_name),
  # #      do: query

  # defp handle_status_filter(query, %{"filter_loan_status" => filter_loan_status}) do
  #   where(
  #     query,
  #     [lO, uB],
  #     fragment("lower(?) LIKE lower(?)", lO.loan_status, ^"%#{filter_loan_status}%")
  #   )
  # end

  # defp handle_status_filter(query, %{"filter_loan_status" => filter_loan_status})
  #      when filter_loan_status == "" or is_nil(filter_loan_status),
  #      do: query


  # defp handle_application_date(query, %{"filter_application_date" => filter_application_date}) do
  #   where(
  #     query,
  #     [lO, uB],
  #     fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", lO.application_date, ^filter_application_date)
  #   )
  # end
  defp handle_disbursed_application_date(query, %{"filter_application_date_from" => filter_application_date_from, "filter_application_date_to" => filter_application_date_to})
    when byte_size(filter_application_date_from) > 0 and byte_size(filter_application_date_to) > 0 do
    query
    |> where(
      [uT, lO],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", lO.application_date, ^filter_application_date_from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", lO.application_date, ^filter_application_date_to)
    )
  end

defp handle_disbursed_application_date(query, _params), do: query


defp handle_filter_disbursed_approvedon_date(query, %{"filter_approvedon_date_from" => filter_approvedon_date_from, "filter_approvedon_date_to" => filter_approvedon_date_to})
  when byte_size(filter_approvedon_date_from) > 0 and byte_size(filter_approvedon_date_to) > 0 do
  query
  |> where(
    [uT, lO],
    fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", lO.approvedon_date, ^filter_approvedon_date_from) and
      fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", lO.approvedon_date, ^filter_approvedon_date_to)
  )
end

defp handle_filter_disbursed_approvedon_date(query, _params), do: query

  # defp handle_application_date(query, %{"filter_application_date" => filter_application_date})
  #   when filter_application_date == "" or is_nil(filter_application_date),
  #   do: query



defp handle_filter_loan_id(query, %{"filter_loan_id" => filter_loan_id}) do
  where(
    query,
    [uT, lO],
    fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", lO.id, ^filter_loan_id)
  )
end

defp handle_filter_loan_id(query, %{"filter_loan_id" => filter_loan_id})
      when filter_loan_id == "" or is_nil(filter_loan_id),
      do: query


defp handle_filter_requested_amount(query, %{"filter_requested_amount" => filter_requested_amount}) do
  where(
    query,
    [uT, lO],
    fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", lO.requested_amount, ^filter_requested_amount)
  )
end

defp handle_filter_requested_amount(query, %{"filter_requested_amount" => filter_requested_amount})
      when filter_requested_amount == "" or is_nil(filter_requested_amount),
      do: query


  # defp handle_approvedon_date(query, %{"filter_approvedon_date" => filter_approvedon_date}) do
  #   where(
  #     query,
  #     [lO, uB],
  #     fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", lO.rejectedon_date, ^filter_approvedon_date)
  #   )
  # end

  # defp handle_approvedon_date(query, %{"filter_approvedon_date" => filter_approvedon_date})
  #   when filter_approvedon_date == "" or is_nil(filter_approvedon_date),
  #   do: query

  # defp handle_filter_requested_amount(query, %{
  #        "filter_requested_amount" => filter_requested_amount
  #      }) do
  #   where(
  #     query,
  #     [lO, uB, lS],
  #     fragment(
  #       "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
  #       lO.requested_amount,
  #       ^"%#{filter_requested_amount}%"
  #     )
  #   )
  # end

  # defp handle_filter_requested_amount(query, %{
  #        "filter_requested_amount" => filter_requested_amount
  #      })
  #      when filter_requested_amount == "" or is_nil(filter_requested_amount),
  #      do: query

    defp handle_approvedon_date(query, %{"approvedon_date_from" => approvedon_date_from, "approvedon_date_to" => approvedon_date_to})
      when byte_size(approvedon_date_from) > 0 and byte_size(approvedon_date_to) > 0 do
      query
      |> where(
        [lO, uB, lS],
        fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", lO.approvedon_date, ^approvedon_date_from) and
          fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", lO.approvedon_date, ^approvedon_date_to)
      )
    end

    defp handle_approvedon_date(query, _params), do: query

  # defp handle_maximum_principal_filter(query, %{
  #        "filter_maximum_principal" => filter_maximum_principal
  #      }) do
  #   where(
  #     query,
  #     [p],
  #     fragment(
  #       "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
  #       p.maximumPrincipal,
  #       ^"%#{filter_maximum_principal}%"
  #     )
  #   )
  # end

  # defp handle_maximum_principal_filter(query, %{
  #        "filter_maximum_principal" => filter_maximum_principal
  #      })
  #      when filter_maximum_principal == "" or is_nil(filter_maximum_principal),
  #      do: query

  # defp handle_created_date_filter(query, %{"from" => from, "to" => to})
  #      when byte_size(from) > 0 and byte_size(to) > 0 do
  #   query
  #   |> where(
  #     [p],
  #     fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", p.inserted_at, ^from) and
  #       fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", p.inserted_at, ^to)
  #   )
  # end

  # defp handle_created_date_filter(query, _params), do: query

  defp compose_disbursed_loan_isearch_filter(query, search_term) do
    query
    |> where(
      [lO, uB, lS],
      fragment("lower(?) LIKE lower(?)", lO.application_date, ^search_term) or
      fragment("lower(?) LIKE lower(?)", lO.loan_status, ^search_term) or
      fragment("lower(?) LIKE lower(?)", lO.id, ^search_term) or
      fragment("lower(?) LIKE lower(?)", lO.approvedon_date, ^search_term)or
      fragment("lower(?) LIKE lower(?)", lO.requested_amount, ^search_term)
        # fragment("lower(?) LIKE lower(?)", lO.rejectedon_date, ^search_term)
    )
  end







# outstanding loan balance

# Loanmanagementsystem.Operations.outstanding_loan_balance(nil, 1, 10)

def outstanding_loan_balance(search_params, page, size) do
  Loans
  |> handle_outstanding_loan_balance_filter(search_params)
  |> order_by([lO, uB, p], desc: lO.inserted_at)
  |> compose_outstanding_loan_balance()
  |> Repo.paginate(page: page, page_size: size)
end

def outstanding_loan_balance(_source, search_params) do
  Loans
  |> handle_outstanding_loan_balance_filter(search_params)
  |> order_by([lO, uB, p], desc: lO.inserted_at)
  |> compose_outstanding_loan_balance()
end

defp compose_outstanding_loan_balance(query) do
  query
  |>join(:left, [lO], uB in UserBioData, on: lO.customer_id == uB.userId)
  |> join(:left, [lO, uB], p in Product, on: lO.product_id == p.id)
  |> where([lO], not is_nil(lO.customer_id) or lO.loan_status == "DIBURSED" or lO.loan_status == "WRITTEN_OFF" or lO.loan_status =="REPAID")
  |> select(
    [lO, uB, p],
    %{
      disbursedon_date: lO.disbursedon_date,
      approvedon_date: lO.approvedon_date,
      rejectedon_date: lO.rejectedon_date,
      requested_amount: lO.requested_amount,
      application_date: lO.application_date,
      userId: uB.userId,
      cro_id: lO.cro_id,
      # client_name: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      client_name: fragment("select distinct case when company_name is null then concat(?, concat(' ', ?)) else company_name end from tbl_loan_customer_details where reference_no = ?", uB.firstName, uB.lastName, lO.reference_no),
      loan_status: lO.loan_status,
      reason: lO.reason,
      expiry_year: lO.expiry_year,
      expiry_month: lO.expiry_month,
      id: lO.id,
      total_loan: fragment("select sum(requested_amount) from tbl_loans"),
      loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
      duedate: fragment("select max(date) from tbl_loan_amortization_schedule where \"customer_id\" = ?", uB.userId),
      fromdate: lO.application_date,
      account_no: lO.account_no,
      reference_no: lO.reference_no,
      balance: lO.balance,
      interest_amount: lO.interest_amount,
      total_interest_repaid: lO.total_interest_repaid,
      product_name: p.name,
      interest: fragment("select ROUND(CAST(sum(interest) AS numeric), 2) from tbl_loan_amortization_schedule where loan_id = ?", lO.id),
      outstanding_balance:  fragment("select ROUND(CAST((sum(distinct c.requested_amount) + sum(distinct a.interest)) - (sum(distinct b.lcy_amount))  AS numeric), 2) from tbl_loan_amortization_schedule a, tbl_trans_log b, tbl_loans c where a.loan_id = b.loan_id and a.loan_id = c.id and b.drcr_ind = 'C' and b.process_status = 'APPROVED' and b.module = 'INSTALLMENT DUE' and a.loan_id = ?", lO.id),
      lasttxn_date: fragment("select trn_dt from tbl_trans_log where \"customer_id\" = ? and \"reference_no\" = ? ORDER BY inserted_at DESC LIMIT 1", lO.customer_id, lO.reference_no),
      payoff_amount: fragment("select ROUND(CAST(sum(interest) + ? AS numeric), 2) from tbl_loan_amortization_schedule where loan_id = ?", lO.requested_amount, lO.id),

    }
  )
end

defp handle_outstanding_loan_balance_filter(query, %{"isearch" => search_term} = search_params)
  when search_term == "" or is_nil(search_term) do
    query
    |> handle_filter_disbursed_approvedon_date(search_params)
    |> handle_disbursed_application_date(search_params)
    |> handle_filter_loan_id(search_params)
    |> handle_filter_requested_amount(search_params)
    |> handle_filter_cro(search_params)
end




  # Loanmanagementsystem.Operations.repayment_loan_list(nil, 1, 10)

  def repayment_loan_list(search_params, page, size) do
    Journal_entries
    |> handle_repayments_loan_balance_filter(search_params)
    |> order_by([uT, lO], desc: uT.inserted_at)
    |> compose_repayment_loan_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def repayment_loan_list(_source, search_params) do
    Journal_entries
    |> handle_repayments_loan_balance_filter(search_params)
    |> order_by([uT, lO], desc: uT.inserted_at)
    |> compose_repayment_loan_list()
  end

  defp compose_repayment_loan_list(query) do
    query
    |>join(:left, [uT], lO in Loans, on: lO.customer_id == uT.customer_id and lO.id == uT.loan_id)
    |>where([uT, lO], not is_nil(uT.loan_id) and not is_nil(uT.customer_id) and uT.drcr_ind == "C")
    |> select(
      [uT, lO],
      %{
        approvedon_date: lO.approvedon_date,
        rejectedon_date: lO.rejectedon_date,
        requested_amount: lO.requested_amount,
        application_date: lO.application_date,
        cro_id: lO.cro_id,
        # client_name:  fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.customer_id),
        client_name: fragment("select distinct case when a.company_name is null then concat(b.\"firstName\", concat(' ', b.\"lastName\")) else a.company_name end from tbl_loan_customer_details a, tbl_user_bio_data b  where a.customer_id = b. \"userId\" and  a.reference_no = ? ", lO.reference_no),
        loan_status: lO.loan_status,
        reason: lO.reason,
        id: lO.id,
        loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
        account_no: lO.account_no,
        duedate: fragment("select max(date) from tbl_loan_amortization_schedule where \"customer_id\" = ?", lO.customer_id),
        total_loan: lO.balance,
        installment: uT.lcy_amount,
        principle: uT.principle,
        interest: uT.interest,
        client_number: lO.customer_id,
        trans_date: uT.trn_dt

      }
    )
  end

defp handle_repayments_loan_balance_filter(query, %{"isearch" => search_term} = search_params)
  when search_term == "" or is_nil(search_term) do
    query
    |> handle_disbursed_application_date(search_params)
    |> handle_filter_loan_id(search_params)
end


# defp handle_filter_nrc_number(query, %{"filter_nrc_number" => filter_nrc_number}) do

#   if filter_nrc_number == "" do
#     where(
#       query,
#       [lO, uB],
#       fragment("lower(cast((?) as text)) LIKE lower(cast((?) as text))", uB.meansOfIdentificationNumber, ^filter_nrc_number)
#     )
#   else
#     where(
#       query,
#       [lO, uB],
#       uB.meansOfIdentificationNumber == ^filter_nrc_number
#     )
#   end

# end


# defp handle_filter_nrc_number(query, _params), do: query



def expected_repayment_loan_list(search_params, page, size) do
  Loans
  # |> handle_repayments_loan_balance_filter(search_params)
  |> order_by([lO], desc: lO.inserted_at)
  |> compose_expected_repayment_loan_list()
  |> Repo.paginate(page: page, page_size: size)
end

def expected_repayment_loan_list(_source, search_params) do
  Loans
  # |> handle_repayments_loan_balance_filter(search_params)
  |> order_by([lO], desc: lO.inserted_at)
  |> compose_expected_repayment_loan_list()
end

defp compose_expected_repayment_loan_list(query) do
  query
  |>where([lO], not is_nil(lO.customer_id) or lO.loan_status == "DIBURSED" or lO.loan_status == "WRITTEN_OFF" or lO.loan_status =="REPAID")
  |> select(
    [lO],
    %{
      approvedon_date: lO.approvedon_date,
      rejectedon_date: lO.rejectedon_date,
      requested_amount: lO.requested_amount,
      application_date: lO.application_date,
      cro_id: lO.cro_id,
      # client_name:  fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.customer_id),
      client_name: fragment("select case when a.company_name is null then concat(b.\"firstName\", concat(' ', b.\"lastName\")) else a.company_name end from tbl_loan_customer_details a, tbl_user_bio_data b  where a.customer_id = b. \"userId\" and  a.reference_no = ? ", lO.reference_no),
      loan_status: lO.loan_status,
      reason: lO.reason,
      id: lO.id,
      loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
      account_no: lO.account_no,
      duedate: fragment("select max(date) from tbl_loan_amortization_schedule where \"customer_id\" = ?", lO.customer_id),
      total_loan: lO.balance,
      payoff_amount: fragment("select ROUND(CAST(sum(interest) + ? AS numeric), 2) from tbl_loan_amortization_schedule where loan_id = ?", lO.requested_amount, lO.id),
      outstanding_balance:  fragment("select ROUND(CAST((sum(distinct c.requested_amount) + sum(distinct a.interest)) - (sum(distinct b.lcy_amount))  AS numeric), 2) from tbl_loan_amortization_schedule a, tbl_trans_log b, tbl_loans c where a.loan_id = b.loan_id and a.loan_id = c.id and b.drcr_ind = 'C' and b.process_status = 'APPROVED' and b.module = 'INSTALLMENT DUE' and a.loan_id = ?", lO.id),
      paid_amount: fragment("select ROUND(CAST(sum(distinct lcy_amount) AS numeric), 2) from tbl_trans_log where loan_id = ? and loan_id IS NOT NULL and drcr_ind = 'C' and process_status = 'APPROVED' and module = 'INSTALLMENT DUE'", lO.id),
      interest: fragment("select ROUND(CAST(sum(interest) AS numeric), 2) from tbl_loan_amortization_schedule where loan_id = ?", lO.id),
    }
  )
end

defp handle_repayments_loan_balance_filter(query, %{"isearch" => search_term} = search_params)
when search_term == "" or is_nil(search_term) do
  query
  |> handle_disbursed_application_date(search_params)
  |> handle_filter_loan_id(search_params)
end








    # Loanmanagementsystem.Operations.last_repayment_overpay_list(nil, 1, 10)

    def last_repayment_overpay_list(search_params, page, size) do
      Loans
      # |> handle_repayments_loan_balance_filter(search_params)
      |> order_by([lO], desc: lO.inserted_at)
      |> compose_last_repayment_overpay_list()
      |> Repo.paginate(page: page, page_size: size)
    end

    def last_repayment_overpay_list(_source, search_params) do
      Loans
      # |> handle_repayments_loan_balance_filter(search_params)
      |> order_by([lO], desc: lO.inserted_at)
      |> compose_last_repayment_overpay_list()
    end

    defp compose_last_repayment_overpay_list(query) do
      query
      |>where([lO], not is_nil(lO.customer_id) or lO.loan_status == "DIBURSED" or lO.loan_status == "WRITTEN_OFF" or lO.loan_status =="REPAID")
      |> select(
        [lO],
        %{
          approvedon_date: lO.approvedon_date,
          rejectedon_date: lO.rejectedon_date,
          requested_amount: lO.requested_amount,
          application_date: lO.application_date,
          cro_id: lO.cro_id,
          # client_name:  fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.customer_id),
          client_name: fragment("select case when a.company_name is null then concat(b.\"firstName\", concat(' ', b.\"lastName\")) else a.company_name end from tbl_loan_customer_details a, tbl_user_bio_data b  where a.customer_id = b. \"userId\" and  a.reference_no = ? ", lO.reference_no),
          loan_status: lO.loan_status,
          reason: lO.reason,
          id: lO.id,
          loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
          account_no: lO.account_no,
          duedate: fragment("select max(date) from tbl_loan_amortization_schedule where \"customer_id\" = ?", lO.customer_id),
          total_loan: lO.balance,
          payoff_amount: fragment("select ROUND(CAST(sum(interest) + ? AS numeric), 2) from tbl_loan_amortization_schedule where loan_id = ?", lO.requested_amount, lO.id),
          outstanding_balance:  fragment("select ROUND(CAST((sum(distinct c.requested_amount) + sum(distinct a.interest)) - (sum(distinct b.lcy_amount))  AS numeric), 2) from tbl_loan_amortization_schedule a, tbl_trans_log b, tbl_loans c where a.loan_id = b.loan_id and a.loan_id = c.id and b.drcr_ind = 'C' and b.process_status = 'APPROVED' and b.module = 'INSTALLMENT DUE' and a.loan_id = ?", lO.id),
          paid_amount: fragment("select ROUND(CAST(sum(distinct lcy_amount) AS numeric), 2) from tbl_trans_log where loan_id = ? and loan_id IS NOT NULL and drcr_ind = 'C' and process_status = 'APPROVED' and module = 'INSTALLMENT DUE'", lO.id),
          interest: fragment("select ROUND(CAST(sum(interest) AS numeric), 2) from tbl_loan_amortization_schedule where loan_id = ?", lO.id),
          lasttxn_date: fragment("select trn_dt from tbl_trans_log where \"customer_id\" = ? and \"reference_no\" = ? ORDER BY inserted_at DESC LIMIT 1", lO.customer_id, lO.reference_no),
        }
      )
      end

      # Loanmanagementsystem.Operations.last_repayment_overpay_list(nil, 1, 10)
      def last_repayment_writeoff_list(search_params, page, size) do
        Journal_entries
        |>join(:left, [txn], lO in Loans, on: txn.loan_id == lO.id)
        |> where([txn, lO], not is_nil(txn.loan_id)  and lO.loan_status == "WRITTEN_OFF")
        # |> handle_loan_filter(search_params)
        |> order_by([txn, lO], desc: lO.id)
        |> group_by([txn, lO], [lO.id, lO.requested_amount ])
        |> compose_last_repayment_writeoff_list()
        |> Repo.paginate(page: page, page_size: size)
      end

      def last_repayment_writeoff_list(_source, search_params) do
        Journal_entries
        |>join(:left, [txn], lO in Loans, on: txn.loan_id == lO.id)
        |> where([txn, lO], not is_nil(txn.loan_id) and lO.loan_status == "WRITTEN_OFF")
        # |> handle_loan_filter(search_params)
        |> order_by([txn, lO], desc: txn.id)
        |> group_by([txn, lO], [lO.id, lO.requested_amount ])
        |> compose_last_repayment_writeoff_list()
      end

      defp compose_last_repayment_writeoff_list(query) do
        query
        |> select(
          [txn, lO],
          %{
            id: lO.id,
            loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
            client: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.customer_id),
            writeoff: fragment("select amount_writtenoff from tbl_writteoff_loans where loan_id = ?", lO.id),
            writeoff_dt: fragment("select date_of_writtenoff from tbl_writteoff_loans where loan_id = ?", lO.id),
            loan_amount: lO.requested_amount,
            loan_interest: fragment("select sum(interest) from tbl_loan_amortization_schedule where loan_id = ?", lO.id),
            principle_repaid: fragment("select sum(principle) from tbl_trans_log where loan_id = ? and loan_id IS NOT NULL and module != 'DISBURSEMENT'", lO.id),
            interest_repaid: fragment("select sum(interest) from tbl_trans_log where loan_id = ? and loan_id IS NOT NULL and module != 'DISBURSEMENT'", lO.id),
            total_repaid: fragment("select ROUND(CAST(sum(distinct lcy_amount) AS numeric), 2) from tbl_trans_log where loan_id = ? and loan_id IS NOT NULL and drcr_ind = 'C' and process_status = 'APPROVED' and module = 'INSTALLMENT DUE'", lO.id),
            payoff_amount: fragment("select sum(interest) + ? from tbl_loan_amortization_schedule where loan_id = ?", lO.requested_amount, lO.id),

          }
        )
      end

       # Loanmanagementsystem.Operations.last_repayment_overpay_list(nil, 1, 10)
       def written_off_loan_report_list(search_params, page, size) do
        Writtenoff_loans
        # |> handle_loan_filter(search_params)
        |> order_by([lO], desc: lO.id)
        |> compose_written_off_loan_report_list()
        |> Repo.paginate(page: page, page_size: size)
      end

      def written_off_loan_report_list(_source, search_params) do
        Writtenoff_loans
        # |> handle_loan_filter(search_params)
        |> order_by([lO], desc: lO.id)
        |> compose_written_off_loan_report_list()
      end

      defp compose_written_off_loan_report_list(query) do
        query
        |> select(
          [lO],
          %{
            id: lO.id,
            date_of_writtenoff: lO.date_of_writtenoff,
            client_name: lO.client_name,
            amount_writtenoff: lO.amount_writtenoff,
            writtenoff_by: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.writtenoff_by),
          }
        )
      end


      def arrears_report_list(_search_params, page, size) do
        Loans
        # |> handle_repayments_loan_balance_filter(search_params)
        # |> where([lO], lO.loan_status == "DISBURSED" )
        |> order_by([lO], desc: lO.inserted_at)
        |> compose_arrears_report_list()
        |> Repo.paginate(page: page, page_size: size)
      end

      def arrears_report_list(_source, _search_params) do
        Loans
        # |> handle_repayments_loan_balance_filter(search_params)
        # |> where([lO], lO.loan_status == "DISBURSED" )
        |> order_by([lO], desc: lO.inserted_at)
        |> compose_arrears_report_list()
      end

      defp compose_arrears_report_list(query) do
        query
        |> select(
          [lO],
          %{
            id: lO.id,
            # client_name: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.customer_id),
            client_name: fragment("select distinct case when a.company_name is null then concat(b.\"firstName\", concat(' ', b.\"lastName\")) else a.company_name end from tbl_loan_customer_details a, tbl_user_bio_data b  where a.customer_id = b. \"userId\" and  a.reference_no = ? ", lO.reference_no),
            product: fragment("select name from tbl_products where \"id\" = ?", lO.product_id),
            loan_amount: lO.requested_amount,
            interest: fragment("select sum(interest) from tbl_loan_amortization_schedule where loan_id = ?", lO.id),
            payoff_amount: fragment("select sum(interest) + ? from tbl_loan_amortization_schedule where loan_id = ?", lO.requested_amount, lO.id),
            principle_arrears: fragment("select ? - sum(principle) from tbl_trans_log where loan_id = ? and loan_id IS NOT NULL and module != 'DISBURSEMENT'",lO.requested_amount, lO.id),
            interest_arears: fragment("select sum(b.interest) - sum(a.interest) from tbl_trans_log a, tbl_loan_amortization_schedule b where a.loan_id = ? and a.loan_id IS NOT NULL and a.module != 'DISBURSEMENT'", lO.id),
            total_arrears:  fragment("select ROUND(CAST((sum(distinct c.requested_amount) + sum(distinct a.interest)) - (sum(distinct b.lcy_amount))  AS numeric), 2) from tbl_loan_amortization_schedule a, tbl_trans_log b, tbl_loans c where a.loan_id = b.loan_id and a.loan_id = c.id and b.drcr_ind = 'C' and b.process_status = 'APPROVED' and b.module = 'INSTALLMENT DUE' and a.loan_id = ?", lO.id),
            loan_officer: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", lO.cro_id),
            last_repayment_dt: fragment("select max(trn_dt) from tbl_trans_log where loan_id = ? and loan_id IS NOT NULL and module != 'DISBURSEMENT'", lO.id),
            payoff_amount: fragment("select ROUND(CAST(sum(interest) + ? AS numeric), 2) from tbl_loan_amortization_schedule where loan_id = ?", lO.requested_amount, lO.id),
            outstanding_balance: fragment("select ROUND(CAST((sum(distinct c.requested_amount) + sum(distinct a.interest)) - (sum(distinct b.lcy_amount))  AS numeric), 2) from tbl_loan_amortization_schedule a, tbl_trans_log b, tbl_loans c where a.loan_id = b.loan_id and a.loan_id = c.id and b.drcr_ind = 'C' and b.process_status = 'APPROVED' and b.module = 'INSTALLMENT DUE' and a.loan_id = ?", lO.id),
            duedate: fragment("select max(date) from tbl_loan_amortization_schedule where \"customer_id\" = ?", lO.customer_id),
            portifolio_at_risk: "",

          }
        )
      end









# Loanmanagementsystem.Operations.mini_statement_report(nil, 1, 10,1269)
  def mini_statement_report(search_params, page, size, userid) do
    Loans
    # |> handle_mini_statement_filter(search_params)
    |> order_by([a], desc: a.inserted_at)
    |> compose_mini_statement_individual(userid)
    |> Repo.paginate(page: page, page_size: size)
  end

  def mini_statement_report(_source, search_params, userid) do
    Loans
    # |> handle_mini_statement_filter(search_params)
    |> order_by([a], desc: a.inserted_at)
    |> compose_mini_statement_individual(userid)
  end

  defp compose_mini_statement_individual(query, userid) do
    query
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.customer_id == u.userId)
    |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
    |> where([a, u, p], a.customer_id == ^userid)
    |> select([a, u, p], %{
      sn: a.id,
      id: a.id,
      customer_id: a.customer_id,
      first_name: u.firstName,
      last_name: u.lastName,
      phone: u.mobileNumber,
      email_address: u.emailAddress,
      loan_status: a.loan_status,
      company_id: a.company_id,
      principal_amount: a.principal_amount_proposed,
      product_name: p.name,
      product_id: p.id,
      currency: p.currencyName,
      interest_outstanding_derived: a.interest_outstanding_derived,
      total_principal_repaid: a.total_principal_repaid,
      principal_outstanding_derived: a.principal_outstanding_derived,
      repayment_type: a.repayment_type,
      approvedon_date: a.approvedon_date,


      balance: fragment("SELECT beginning_balance FROM tbl_loan_amortization_schedule WHERE reference_no = ? ORDER BY inserted_at DESC LIMIT 1", a.reference_no),
      interest_amount: fragment("select sum(interest) from tbl_loan_amortization_schedule where \"reference_no\" = ?", a.reference_no),
      repayment_amount: fragment("select sum(payment) from tbl_loan_amortization_schedule where \"reference_no\" = ?", a.reference_no),
      closedon_date: a.closedon_date,
      tenor: a.tenor,
      due_date: fragment("select max(date) from tbl_loan_amortization_schedule where \"reference_no\" = ?", a.reference_no)
    })
  end










  # Loanmanagementsystem.Operations.historical_individual_statement_report(nil, 1, 10,56)
  def historical_individual_statement_report(search_params, page, size, userid) do
    Loans
    # |> handle_mini_statement_filter(search_params)
    |> order_by([a], desc: a.inserted_at)
    |> compose_historical_statement_individual(userid)
    |> Repo.paginate(page: page, page_size: size)
  end

  def historical_individual_statement_report(_source, search_params, userid) do
    Loans
    # |> handle_mini_statement_filter(search_params)
    |> order_by([a], desc: a.inserted_at)
    |> compose_historical_statement_individual(userid)
  end

  defp compose_historical_statement_individual(query, userid) do
    query
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.customer_id == u.userId)
    |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
    |> where([a, u, p], a.customer_id == ^userid)
    |> select([a, u, p], %{
      sn: a.id,
      id: a.id,
      customer_id: a.customer_id,
      first_name: u.firstName,
      last_name: u.lastName,
      phone: u.mobileNumber,
      email_address: u.emailAddress,
      loan_status: a.loan_status,
      company_id: a.company_id,
      principal_amount: a.principal_amount_proposed,
      product_name: p.name,
      product_id: p.id,
      currency: p.currencyName,
      interest_outstanding_derived: a.interest_outstanding_derived,
      total_principal_repaid: a.total_principal_repaid,
      principal_outstanding_derived: a.principal_outstanding_derived,
      repayment_type: a.repayment_type,
      approvedon_date: a.approvedon_date,


      balance: fragment("SELECT beginning_balance FROM tbl_loan_amortization_schedule WHERE reference_no = ? ORDER BY inserted_at DESC LIMIT 1", a.reference_no),
      interest_amount: fragment("select sum(interest) from tbl_loan_amortization_schedule where \"reference_no\" = ?", a.reference_no),
      repayment_amount: fragment("select sum(payment) from tbl_loan_amortization_schedule where \"reference_no\" = ?", a.reference_no),
      closedon_date: a.closedon_date,
      tenor: a.tenor,
      due_date: fragment("select max(date) from tbl_loan_amortization_schedule where \"reference_no\" = ?", a.reference_no)
    })
  end






  # Loanmanagementsystem.Operations.get_individual_mini_statement(56)
  def get_individual_mini_statement(userid) do
    Loans
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.customer_id == u.userId)
    |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
    |> order_by([a, u, p], desc: a.inserted_at)
    |> limit(5)
    |> where([a, u, p], a.customer_id == ^userid)
    |> select([a, u, p], %{
      sn: a.id,
      id: a.id,
      customer_id: a.customer_id,
      first_name: u.firstName,
      last_name: u.lastName,
      phone: u.mobileNumber,
      email_address: u.emailAddress,
      loan_status: a.loan_status,
      company_id: a.company_id,
      principal_amount: a.principal_amount,
      product_name: p.name,
      product_id: p.id,
      currency: p.currencyName,
      principal_amount: a.principal_amount,
      interest_outstanding_derived: a.interest_outstanding_derived,
      total_principal_repaid: a.total_principal_repaid,
      principal_outstanding_derived: a.principal_outstanding_derived,
      repayment_type: a.repayment_type,
      approvedon_date: a.approvedon_date,
      closedon_date: a.closedon_date,
      repayment_amount: a.repayment_amount,
      balance: a.balance,
      interest_amount: a.interest_amount,
      application_date: a.application_date

    })|> Repo.all()
  end



  # Loanmanagementsystem.Operations.get_individual_historical_statement(56)
  def get_individual_historical_statement(userid) do
    Loans
    |> join(:left, [a], u in "tbl_user_bio_data", on: a.customer_id == u.userId)
    |> join(:left, [a, u], p in "tbl_products", on: a.product_id == p.id)
    |> order_by([a, u, p], desc: a.inserted_at)
    |> where([a, u, p], a.customer_id == ^userid)
    |> select([a, u, p], %{
      sn: a.id,
      id: a.id,
      customer_id: a.customer_id,
      first_name: u.firstName,
      last_name: u.lastName,
      phone: u.mobileNumber,
      email_address: u.emailAddress,
      loan_status: a.loan_status,
      company_id: a.company_id,
      principal_amount: a.principal_amount,
      product_name: p.name,
      product_id: p.id,
      currency: p.currencyName,
      principal_amount: a.principal_amount,
      interest_outstanding_derived: a.interest_outstanding_derived,
      total_principal_repaid: a.total_principal_repaid,
      principal_outstanding_derived: a.principal_outstanding_derived,
      repayment_type: a.repayment_type,
      approvedon_date: a.approvedon_date,
      closedon_date: a.closedon_date,
      repayment_amount: a.repayment_amount,
      balance: a.balance,
      interest_amount: a.interest_amount,
      application_date: a.application_date

    })|> Repo.all()
  end

alias Loanmanagementsystem.Employment.Employment_Details
  # Loanmanagementsystem.Operations.get_individual_address_details(56)
  def get_individual_address_details(userid) do
    Address_Details
    |> join(:left, [aD], eM in Employment_Details, on: aD.userId == eM.userId)
    |> where([aD, eM], aD.userId == ^userid)
    |> select([aD, eM], %{
      accomodation_status: aD.accomodation_status,
      area: aD.area,
      house_number: aD.house_number,
      street_name: aD.street_name,
      town: aD.town,
      userId: aD.userId,
      year_at_current_address: aD.year_at_current_address,
      province: aD.province,
      land_mark: aD.land_mark,
      company_id: aD.company_id,
      employer_industry_type: eM.employer_industry_type
    })|> Repo.all()
  end




    # Loanmanagementsystem.Operations.pending_loan_list(nil, 1, 10, 1626)

    def pending_loan_list(search_params, page, size, user_id) do
      Loans
      # |> handle_loan_filter(search_params)
      |> order_by([l, s, uB,uR, p], desc: l.inserted_at)
      |> compose_pending_loan_list(user_id)
      |> Repo.paginate(page: page, page_size: size)
    end

    def pending_loan_list(_source, search_params, user_id) do
      Loans
      # |> handle_loan_filter(search_params)
      |> order_by([l, s, uB,uR, p], desc: l.inserted_at)
      |> compose_pending_loan_list(user_id)
    end

  defp compose_pending_loan_list(query, user_id) do
    query
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |>join(:left, [l, s, uB], uR in "tbl_user_roles", on: uB.userId == uR.userId)
    |> join(:left, [l, s, uB, uR], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, u], l.customer_id == ^user_id and ilike(l.status, "PENDING%"))
    |> select([l, s, uB,uR, p], %{
      id: l.id,
      customer_id: l.customer_id,
      client_name: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", l.customer_id),
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount,
      repayment_frequency: l.repayment_frequency,
      tenor: l.tenor,
      principal_amount: l.principal_amount,
      account_name: l.account_name,
      bank_account_no: l.bank_account_no,
      # expiry_date: l.expiry_date,
      cvv: l.cvv,
      disbursement_method: l.disbursement_method,
      receipient_number: l.receipient_number,
      product_id: p.id,
      closedon_date: l.closedon_date,
      total_repaid: l.total_repaid,
      reference_no: l.reference_no,
      disbursedon_date: l.disbursedon_date,
      inserted_at: l.inserted_at,
      user_role_id: uR.id,
      total_repayment_derived: l.total_repayment_derived,
      status: l.status
    }
      )

  end


    # Loanmanagementsystem.Operations.tracking_loan_list(nil, 1, 10, 1626)

    def tracking_loan_list(search_params, page, size, user_id) do
      Loans
      # |> handle_loan_filter(search_params)
      |> order_by([l, s, uB,uR, p], desc: l.inserted_at)
      |> compose_tracking_loan_list(user_id)
      |> Repo.paginate(page: page, page_size: size)
    end

    def tracking_loan_list(_source, search_params, user_id) do
      Loans
      # |> handle_loan_filter(search_params)
      |> order_by([l, s, uB,uR, p], desc: l.inserted_at)
      |> compose_tracking_loan_list(user_id)
    end

    defp compose_tracking_loan_list(query, user_id) do
    query
    |> join(:left, [l], s in "tbl_users", on: l.customer_id == s.id)
    |> join(:left, [l, s], uB in "tbl_user_bio_data", on: l.customer_id == uB.userId)
    |>join(:left, [l, s, uB], uR in "tbl_user_roles", on: uB.userId == uR.userId)
    |> join(:left, [l, s, uB, uR], p in "tbl_products", on: l.product_id == p.id)
    |> where([l, u], l.customer_id == ^user_id )
    |> select([l, s, uB,uR, p], %{
      id: l.id,
      customer_id: l.customer_id,
      client_name: fragment("select concat(\"firstName\", concat(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?", l.customer_id),
      first_name: uB.firstName,
      last_name: uB.lastName,
      phone: uB.mobileNumber,
      email_address: uB.emailAddress,
      loan_status: l.loan_status,
      company_id: l.company_id,
      principal_amount: l.principal_amount,
      product_name: p.name,
      principal_amount: l.principal_amount,
      interest_outstanding_derived: l.interest_outstanding_derived,
      total_principal_repaid: l.total_principal_repaid,
      principal_outstanding_derived: l.principal_outstanding_derived,
      repayment_type: l.repayment_type,
      approvedon_date: l.approvedon_date,
      repayment_amount: l.repayment_amount,
      balance: l.balance,
      interest_amount: l.interest_amount,
      repayment_frequency: l.repayment_frequency,
      tenor: l.tenor,
      principal_amount: l.principal_amount,
      account_name: l.account_name,
      bank_account_no: l.bank_account_no,
      # expiry_date: l.expiry_date,
      cvv: l.cvv,
      disbursement_method: l.disbursement_method,
      receipient_number: l.receipient_number,
      product_id: p.id,
      closedon_date: l.closedon_date,
      total_repaid: l.total_repaid,
      reference_no: l.reference_no,
      disbursedon_date: l.disbursedon_date,
      inserted_at: l.inserted_at,
      user_role_id: uR.id,
      total_repayment_derived: l.total_repayment_derived,
      status: l.status
    }
      )
    end

    defp handle_loan_filter(query, %{"isearch" => search_term} = search_params)
         when search_term == "" or is_nil(search_term) do
      query
      |> handle_status_filter(search_params)
      |> handle_application_date(search_params)
      |> handle_filter_loan_id(search_params)
      |> handle_approvedon_date(search_params)
      |> handle_filter_requested_amount(search_params)
      # |> handle_created_date_filter(search_params)
    end




















end
