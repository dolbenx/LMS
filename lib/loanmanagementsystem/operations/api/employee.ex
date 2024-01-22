defmodule Loanmanagementsystem.Operations.Api.Employee do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Accounts.{UserBioData, UserRole, User}
  alias Loanmanagementsystem.Accounts.Address_Details
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


  # Loanmanagementsystem.Operations.Api.Employee.get_employee_company_detail(6)
  def get_employee_company_detail(company_id) do
    Company
    |> where([cO], cO.id == ^company_id)
    |> select([cO], %{
      company_id: cO.id,
      companyName: cO.companyName,
      companyPhone: cO.companyPhone,
      contactEmail: cO.contactEmail,
      createdByUserId: cO.createdByUserId,
      createdByUserRoleId: cO.createdByUserRoleId,
      isEmployer: cO.isEmployer,
      isOfftaker: cO.isOfftaker,
      isSme: cO.isSme,
      registrationNumber: cO.registrationNumber,
      status: cO.status,
      taxno: cO.taxno,
      companyRegistrationDate: cO.companyRegistrationDate ,
      companyAccountNumber: cO.companyAccountNumber,
      bank_id: cO.bank_id,
      area: cO.area,
      town: cO.twon,
      province: cO.province,
      employer_industry_type: cO.employer_industry_type,
      employer_office_building_name: cO.employer_office_building_name,
      employer_officer_street_name: cO.employer_officer_street_name,
      business_sector: cO.business_sector,
    })|> Repo.one()
  end

  # Loanmanagementsystem.Operations.Api.Employee.get_address_by_userId(1269)
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
    })|>Repo.one()
  end

  # Loanmanagementsystem.Operations.Api.Employee.get_employmentdetails_by_userId(1626)
  def get_employmentdetails_by_userId(userid) do
    Employment_Details
    |> where([eD], eD.userId == ^userid)
    |> select([eD], %{
      area: eD.area,
      date_of_joining: eD.date_of_joining,
      employee_number: eD.employee_number,
      employer: eD.employer,
      employer_industry_type: eD.employer_industry_type,
      employer_office_building_name: eD.employer_office_building_name,
      employer_officer_street_name: eD.employer_officer_street_name,
      employment_type: eD.employment_type,
      hr_supervisor_email: eD.hr_supervisor_email,
      hr_supervisor_mobile_number: eD.hr_supervisor_mobile_number,
      hr_supervisor_name: eD.hr_supervisor_name,
      job_title: eD.job_title,
      occupation: eD.occupation,
      province: eD.province,
      town: eD.town,
      userId: eD.userId,
      department: eD.departmentId,
      # departmentId: eD.,
      mobile_network_operator: eD.mobile_network_operator,
      registered_name_mobile_number: eD.registered_name_mobile_number,
      contract_start_date: eD.contract_start_date,
      contract_end_date: eD.contract_end_date,
      company_id: eD.company_id,
    })|>Repo.one()
  end

  # Loanmanagementsystem.Operations.Api.Employee.get_products_employee
  def get_products_employee() do
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


  # Loanmanagementsystem.Operations.Api.Employee.disbursed_loan_count(1626)
  def disbursed_loan_count(user_id) do
    Loans
    |> where([l], l.customer_id == ^user_id and  fragment("lower(?) LIKE lower(?)", l.loan_status, ^"DISBURSED"))
    |> Repo.aggregate(:count)
  end


  # Loanmanagementsystem.Operations.Api.Employee.rejected_loan_count(1626)
  def rejected_loan_count(user_id) do
    Loans
    |> where([l], l.customer_id == ^user_id and  fragment("lower(?) LIKE lower(?)", l.loan_status, ^"REJECTED"))
    |> Repo.aggregate(:count)
  end


  # Loanmanagementsystem.Operations.Api.Employee.loan_count(1626)
  def loan_count(user_id) do
    Loans
    |> where([l], l.customer_id == ^user_id)
    |> Repo.aggregate(:count)
  end


  # Loanmanagementsystem.Operations.Api.Employee.pending_loan_count(1626) this the does something like the string.contains method
  def pending_loan_count(user_id) do
    Loans
    |> where([l], l.customer_id == ^user_id and  fragment("? ILIKE ?", l.loan_status, ^"%PENDING%"))
    |> Repo.aggregate(:count)
  end










  # Loanmanagementsystem.Operations.Api.Employee.loan_interest_amount(1626)
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

  # Loanmanagementsystem.Operations.Api.Employee.get_loan_by_userid(1626)
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


  # Loanmanagementsystem.Operations.Api.Employee.get_user_info_by_user_id(1626)
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

  # Loanmanagementsystem.Operations.Api.Employee.get_last_five_loan_by_userid(1626)
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


    # Loanmanagementsystem.Operations.Api.Employee.get_loan_by_loan_id(2079)
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







end
