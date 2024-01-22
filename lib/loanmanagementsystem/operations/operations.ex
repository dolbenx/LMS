defmodule Loanmanagementsystem.Operations do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Accounts.{UserBioData, UserRole, User, Address_Details}
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Loan.Loan_Provisioning_Criteria
  alias Loanmanagementsystem.Products.Product
  alias Loanmanagementsystem.Companies.Documents
  alias Loanmanagementsystem.Loan.Loan_application_documents
  alias Loanmanagementsystem.Loan.Order_finance_loan_invoice

  alias Loanmanagementsystem.Loan.LoanCharge
  alias Loanmanagementsystem.Loan.Loans
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Loan.LoanTransaction
  alias Loanmanagementsystem.Loan.LoanRepayment
  alias Loanmanagementsystem.Accounts.Customer_account
  alias Loanmanagementsystem.Merchants.Merchant
  alias Loanmanagementsystem.Maintenance.{Branch, Bank}
  alias Loanmanagementsystem.Loan.Loan_invoice
  alias Loanmanagementsystem.Products.Product_rates
  alias Loanmanagementsystem.Loan.Loan_funder


  def test,
  do: Timex.shift(Date.utc_today, days: -120)

  # Loanmanagementsystem.Operations.test()
  def get_funder() do
    Loan_funder
    |> join(:left, [f], uB in UserBioData, on: f.funderID == uB.userId)
    |> select([f, uB], %{
      funderID: f.funderID,
      totalAmountFunded: f.totalAmountFunded,
      totalbalance: f.totalbalance,
      totalinterest_accumulated: f.totalinterest_accumulated,
      status: f.status,
      payment_mode: f.payment_mode,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      firstName: uB.firstName,
      gender: uB.gender,
      lastName: uB.lastName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Operations.get_employer_docs(51)
  def get_employer_docs(userID) do
    IO.inspect(userID, label: "----------------------------------------userID")

    Company
    |> join(:left, [uS, idvdoc], idvdoc in Documents, on: uS.id == ^userID)
    |> where([uS, idvdoc], idvdoc.userID == ^userID)
    |> select([uS, idvdoc], %{
      id: idvdoc.id,
      docName: idvdoc.docName,
      docPath: idvdoc.path,
      docStatus: idvdoc.status,
      docType: idvdoc.docType
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Operations.get_docs_order_finance(12)

  def get_docs_order_finance(loan_id) do
    Loans
    |> join(:left, [uS, idvdoc], idvdoc in Loan_application_documents, on: uS.id == idvdoc.loan_id)
    |> where([uS, idvdoc], uS.id == ^loan_id)
    |> select([uS, idvdoc], %{
      id: idvdoc.id,
      docName: idvdoc.doc_name,
      docPath: idvdoc.path,
      docStatus: idvdoc.status,
      docType: idvdoc.doc_type,
      fileName: idvdoc.fileName,
      customer_id: idvdoc.customer_id,
      loan_id: idvdoc.loan_id,
      for_repayment: idvdoc.for_repayment
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Operations.get_loan_client_docs(129,10)
  def get_loan_client_docs(userID, loan_id) do
    Loan_application_documents
    |> where([idvdoc], idvdoc.customer_id == ^userID and idvdoc.loan_id == ^loan_id)
    |> select([idvdoc], %{
      id: idvdoc.id,
      docName: idvdoc.doc_name,
      docPath: idvdoc.path,
      docStatus: idvdoc.status,
      docType: idvdoc.doc_type,
      loan_id: idvdoc.loan_id,
      fileName: idvdoc.fileName,
      customer_id: idvdoc.customer_id,
      inserted_at: idvdoc.inserted_at
    })
    |> Repo.all()
  end


  # Loanmanagementsystem.Operations.get_loan_funder_docs(106,11)
  def get_loan_funder_docs(userID, loan_id) do
    Loan_application_documents
    |> join(:left, [idvdoc], l in Loans, on: l.id == idvdoc.loan_id)
    |> where([idvdoc, l], l.funderID == ^userID and idvdoc.loan_id == ^loan_id)
    |> select([idvdoc,l], %{
      id: idvdoc.id,
      docName: idvdoc.doc_name,
      docPath: idvdoc.path,
      docStatus: idvdoc.status,
      docType: idvdoc.doc_type,
      loan_id: idvdoc.loan_id,
      fileName: idvdoc.fileName,
      customer_id: idvdoc.customer_id,
      inserted_at: idvdoc.inserted_at
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Operations.get_offtaker_client_docs()
  def get_offtaker_client_docs(loan_id, userId) do
    Loan_application_documents
    |> where([idvdoc], idvdoc.loan_id == ^loan_id and idvdoc.customer_id == ^userId)
    |> select([idvdoc], %{
      id: idvdoc.id,
      docName: idvdoc.doc_name,
      fileName: idvdoc.fileName,
      docPath: idvdoc.path,
      docStatus: idvdoc.status,
      docType: idvdoc.doc_type,
      customer_id: idvdoc.customer_id,
      loan_id: idvdoc.loan_id
    })
    |> Repo.all()
  end


  def get_company_by_id(userid) do
    Company
    |> join(:full, [cO], uS in User, on: cO.id == uS.company_id)
    |> join(:full, [cO, uS], uB in UserBioData, on: uB.userId == uS.id)
    |> join(:full, [cO, uS, uB], uR in UserRole, on: uR.userId == uS.id)
    |> join(:full, [cO, uS, uB, uR], bA in Bank, on: cO.bank_id == bA.id)
    |> join(:left, [cO, uS, uB, uR, bA], bM in Address_Details, on: bM.userId == uS.id)
    |> where([cO, uS, uB, uR, bM], cO.id == ^userid)
    |> select([cO, uS, uB, uR, bA, bM], %{
      id: cO.id,
      roleId: uR.id,
      firstName: uB.firstName,
      lastName: uB.lastName,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      gender: uB.gender,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      bank_account_number: uB.bank_account_number,
      marital_status: uB.marital_status,
      title: uB.title,
      nationality: uB.nationality,
      number_of_dependants: uB.number_of_dependants,
      roleType: uR.roleType,
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
      address_id: bM.userId,
      province: bM.province,
      year_at_current_address: bM.year_at_current_address,
      town: bM.town,
      street_name: bM.street_name,
      house_number: bM.house_number,
      area: bM.area,
      accomodation_status: bM.accomodation_status,
      company_id: cO.id,
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Operations.get_loan_by_id!()
  def get_loan_by_id!(id) do
    Loans
    |> join(:left, [lO], pR in Product, on: lO.product_id == pR.id)
    |> where([lO, pR], lO.id == ^id)
    |> select([lO, pR], %{
      customer_id: lO.customer_id,
      interest_method: lO.interest_method,
      loan_type: lO.loan_type,
      principal_amount: lO.principal_amount,
      loan_status: lO.loan_status,
      principal_amount_proposed: lO.principal_amount_proposed,
      expected_maturity_date: lO.expected_maturity_date,
      status: lO.status,
      total_repaid: lO.total_repaid,
      company_id: lO.company_id,
      disbursement_method: lO.disbursement_method,
      loan_id: lO.id,
      reference_no: lO.receipient_number,
      repayment_type: lO.repayment_type,
      repayment_amount: lO.repayment_amount,
      balance: lO.balance,
      interest_amount: lO.interest_amount,
      tenor: lO.tenor,
      reason: lO.reason,
      requested_amount: lO.requested_amount,
      loan_duration_month: lO.loan_duration_month,
      loan_purpose: lO.loan_purpose,
      application_date: lO.application_date,
      has_mou: lO.has_mou,
      name: pR.name
    })
    |> Repo.one()
  end

  # Loanmanagementsystem.Operations.get_company_by_id_offtaker(20,79,2)
  def get_company_by_id_offtaker(offtakerid, userId, loan_id) do
    Company
    |> join(:left, [cO], lO in Loans, on: cO.id == lO.offtakerID)
    |> join(:left, [cO, lO], uS in User, on: lO.customer_id == uS.id)
    |> join(:left, [cO, lO, uS], uB in UserBioData, on: uB.userId == uS.id)
    |> join(:left, [cO, lO, uS, uB], bA in Bank, on: cO.bank_id == bA.id)
    |> join(:left, [cO, lO, uS, uB, bA], bM in Address_Details, on: bM.userId == uS.id)
    |> where(
      [cO, lO, uS, uB, bM],
      cO.id == ^offtakerid and lO.customer_id == ^userId and lO.id == ^loan_id
    )
    |> select([cO, lO, uS, uB, bA, bM], %{
      id: cO.id,
      firstName: uB.firstName,
      lastName: uB.lastName,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      gender: uB.gender,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      bank_account_number: uB.bank_account_number,
      marital_status: uB.marital_status,
      title: uB.title,
      nationality: uB.nationality,
      number_of_dependants: uB.number_of_dependants,
      companyName: cO.companyName,
      companyPhone: cO.companyPhone,
      contactEmail: cO.contactEmail,
      registrationNumber: cO.registrationNumber,
      companystatus: cO.status,
      customer_id: lO.customer_id,
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
      address_id: bM.userId,
      province: bM.province,
      year_at_current_address: bM.year_at_current_address,
      town: bM.town,
      street_name: bM.street_name,
      house_number: bM.house_number,
      area: bM.area,
      accomodation_status: bM.accomodation_status,
      company_id: cO.id,
    })
    |> Repo.all()
  end

  def get_company() do
    Company
    |> join(:left, [cO], uB in UserBioData, on: cO.createdByUserId == uB.userId)
    |> join(:left, [cO, uB], uR in UserRole, on: cO.createdByUserRoleId == uR.id)
    |> join(:left, [cO, uB, uR], bA in Bank, on: cO.bank_id == bA.id)
    |> select([cO, uB, uR, bA], %{
      id: cO.id,
      roleId: uR.id,
      firstName: uB.firstName,
      lastName: uB.lastName,
      dateOfBirth: uB.dateOfBirth,
      emailAddress: uB.emailAddress,
      gender: uB.gender,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      mobileNumber: uB.mobileNumber,
      otherName: uB.otherName,
      bank_account_number: uB.bank_account_number,
      marital_status: uB.marital_status,
      title: uB.title,
      nationality: uB.nationality,
      number_of_dependants: uB.number_of_dependants,
      roleType: uR.roleType,
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
      company_id: cO.id,
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

  # Loanmanagementsystem.Operations.offtaker_pending_loans_list(nil, 1, 10, 20)

  def offtaker_pending_loans_list(search_params, page, size, company_id) do
    Loans
    # |> handle_offtaker_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_offtaker_pending_loans_list(company_id)
    |> Repo.paginate(page: page, page_size: size)
  end

  def offtaker_pending_loans_list(_source, search_params, company_id) do
    Loans
    # |> handle_offtaker_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_offtaker_pending_loans_list(company_id)
  end

  defp compose_offtaker_pending_loans_list(query, company_id) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> where(
      [l, uB, p],
      l.offtakerID == ^company_id and l.status == "PENDING_OFFTAKER_CONFIRMATION"
    )
    |> select([l, uB, p], %{
      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.inserted_at,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      company_id: l.offtakerID
    })
  end

  defp handle_offtaker_loans_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    # |> handle_customer_first_name_filter(search_params)
    # |> handle_customer_last_name_filter(search_params)
    # |> handle_product_name_filter(search_params)
    # |> handle_minimum_principal_filter(search_params)
    # |> handle_maximum_principal_filter(search_params)
    # |> handle_product_type_filter(search_params)
    # |> handle_created_date_filter(search_params)
  end

  defp handle_offtaker_loans_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_offtaker_loans_isearch_filter(query, search_term)
  end

  defp compose_offtaker_loans_isearch_filter(query, search_term) do
    query
    |> where(
      [l, uB, p],
      fragment("lower(?) LIKE lower(?)", p.product_name, ^search_term) or
        fragment("lower(?) LIKE lower(?)", p.period_type, ^search_term) or
        fragment("lower(?) LIKE lower(?)", p.status, ^search_term)
    )
  end

  # Loanmanagementsystem.Operations.get_credit_invoice_docs(12)
  alias Loanmanagementsystem.Loan.Loan_application_documents

  def get_credit_invoice_docs(loan_id) do
    Loan_application_documents
    |> where([idvdoc], idvdoc.loan_id == ^loan_id)
    |> select([idvdoc], %{
      id: idvdoc.id,
      docName: idvdoc.doc_name,
      docPath: idvdoc.path,
      docStatus: idvdoc.status,
      docType: idvdoc.doc_type,
      fileName: idvdoc.fileName,
      customer_id: idvdoc.customer_id,
      loan_id: idvdoc.loan_id
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.Operations.ordering_finance_get_offtaker(12)

  def ordering_finance_get_offtaker(loan_id) do
    Loans
    |> join(:left, [l], c in Company, on: l.offtakerID == c.id)
    |> where([l, c], l.id == ^loan_id)
    |> select([l, c], %{
      companyName: c.companyName,
      companyPhone: c.companyPhone,
      contactEmail: c.contactEmail,
      createdByUserId: c.createdByUserId,
      createdByUserRoleId: c.createdByUserRoleId,
      isOfftaker: c.isOfftaker,
      registrationNumber: c.registrationNumber,
      status: c.status,
      taxno: c.taxno,
      companyRegistrationDate: c.companyRegistrationDate,
      companyAccountNumber: c.companyAccountNumber,
      bank_id: c.bank_id
    })
    |> Repo.one()
  end

  # Loanmanagementsystem.Operations.ordering_finance_details(83)
  def ordering_finance_details(loan_id) do
    Loans
    |> join(:left, [l], uS in User, on: l.customer_id == uS.id)
    |> join(:left, [l, uS], uB in UserBioData, on: uS.id == uB.userId)
    |> join(:left, [l, uS, uB], pr in Product_rates, on: l.product_id == pr.product_id)
    |> join(:left, [l, uS, uB, pr], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uS, uB, pr, p], c in Company, on: uS.company_id == c.id)
    |> join(:left, [l, uS, uB, pr, p, c], b in Bank, on: c.bank_id == b.id)
    |> join(:left, [l, uS, uB, pr, p, c, b], funder in UserBioData,
      on: funder.userId == l.funderID
    )
    |> join(:left, [l, uS, uB, pr, p, c, b], order_invoice in Order_finance_loan_invoice, on: order_invoice.loan_id == l.id)
    |> where([l, uS, uB, pr, p, c, b, funder, order_invoice], l.id == ^loan_id)
    |> select([l, uS, uB, pr, p, c, b, funder, order_invoice], %{
      id: l.id,
      principal_repaid_derived: l.principal_repaid_derived,
      number_of_repayments: l.number_of_repayments,
      withdrawnon_date: l.withdrawnon_date,
      currency_code: l.currency_code,
      repay_every_type: l.repay_every_type,
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
      tenor: l.tenor,
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
      principal_amount_proposed: l.principal_amount_proposed,
      fee_charges_repaid_derived: l.fee_charges_repaid_derived,
      total_expected_repayment_derived: l.total_expected_repayment_derived,
      principal_outstanding_derived: l.principal_outstanding_derived,
      rejectedon_date: l.rejectedon_date,
      closedon_date: l.closedon_date,
      monthly_installment: l.monthly_installment,
      repayment_amount: l.repayment_amount,
      interest_amount: l.interest_amount,
      fee_charges_writtenoff_derived: l.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: l.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: l.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: l.penalty_charges_repaid_derived,
      withdrawnon_userid: l.withdrawnon_userid,
      expected_maturity_date: l.expected_maturity_date,
      term_frequency: l.term_frequency,
      total_repayment_derived: l.total_repayment_derived,
      loan_identity_number: l.loan_identity_number,
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
      has_mou: l.has_mou,
      loan_userroleid: l.loan_userroleid,
      disbursement_method: l.disbursement_method,
      funderID: l.funderID,
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
      code: p.code,
      currencyDecimals: p.currencyDecimals,
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
      companyName: c.companyName,
      contactEmail: c.contactEmail,
      companyPhone: c.companyPhone,
      registrationNumber: c.registrationNumber,
      taxno: c.taxno,
      companyRegistrationDate: c.companyRegistrationDate,
      companyAccountNumber: c.companyAccountNumber,
      bank_id: c.bank_id,
      bankName: b.bankName,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      funder_first_name: funder.firstName,
      funder_last_name: funder.lastName,

      item_description: order_invoice.item_description,
      order_date: order_invoice.order_date,
      order_number: order_invoice.order_number,
      order_value: order_invoice.order_value,
      order_invoice_tenor: order_invoice.tenor,
      expected_due_date: order_invoice.expected_due_date
    })
    |> Repo.one()
  end

  # --------------------------------------------credit analyst loan Approval ----------------------------------------
  # Loanmanagementsystem.Operations.credit_analyst_pending_loans_approval_list(nil, 1, 10)

  def credit_analyst_pending_loans_approval_list(search_params, page, size) do
    Loans
    # |> handle_offtaker_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_credit_analyst_pending_loans_approval_list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def credit_analyst_pending_loans_approval_list(_source, search_params) do
    Loans
    # |> handle_offtaker_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_credit_analyst_pending_loans_approval_list()
  end

  defp compose_credit_analyst_pending_loans_approval_list(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> where([l, uB, p], l.loan_type == "ORDER FINANCE")
    |> select([l, uB, p], %{
      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      company_names:
        fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      company_id: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: l.interest_amount,
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      repayment_type: l.repayment_type
    })
  end

  # -----------------------------------------------------end credit analyst approval-------------------------------------

  alias Loanmanagementsystem.Accounts.Role

  # Loanmanagementsystem.Operations.get_current_user_by_bio_data(44)
  def get_current_user_by_bio_data(user_id) do
    UserBioData
    |> join(:left, [uB], uS in User, on: uB.userId == uS.id)
    |> join(:left, [uB, uS], r in Role, on: uS.role_id == r.id)
    |> where([uB, uS, r], uB.userId == ^user_id)
    |> select([uB, uS, r], %{
      id: uB.id,
      userId: uB.userId,
      firstName: uB.firstName,
      lastName: uB.lastName,
      otherName: uB.otherName,
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      role_desc: r.role_desc,
      role_group: r.role_group
    })
    |> Repo.one()
  end

  # --------------------------------------------SME loan ----------------------------------------
  # Loanmanagementsystem.Operations.sme_loans__list(nil, 1, 10)

  def sme_loans__list(search_params, page, size) do
    Loans
    # |> handle_offtaker_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_sme_loans__list()
    |> Repo.paginate(page: page, page_size: size)
  end

  def sme_loans__list(_source, search_params) do
    Loans
    # |> handle_offtaker_loans_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_sme_loans__list()
  end

  defp compose_sme_loans__list(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> where([l, uB, p], l.loan_type == "SME LOAN")
    |> select([l, uB, p], %{
      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      company_names:
        fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      company_id: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: l.interest_amount,
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      repayment_type: l.repayment_type
    })
  end

  # -----------------------------------------------------end credit analyst approval-------------------------------------

  # Loanmanagementsystem.Operations.get_a_loan_by_reference_no(7592)

  def get_a_loan_by_reference_no(reference_no) do
    Loans
    |> join(:left, [l], cO in "tbl_company", on: l.offtakerID == cO.id)
    |> where([l, cO], l.reference_no == ^reference_no)
    |> select([l, cO], %{
      loan_id: l.id,
      customer_names: fragment("select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?", l.customer_id),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      customer_id: l.customer_id,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      company_id: l.company_id,
      closedon_date: l.closedon_date,
      interest_amount: l.interest_amount,
      balance: l.balance,
      repayment_amount: l.repayment_amount,


      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      total_interest: (l.daily_accrued_interest + l.daily_accrued_finance_cost),
      calculated_balance: (l.principal_amount + l.daily_accrued_interest + l.daily_accrued_finance_cost),

      calculated_with_arrangement_fee: (l.principal_amount + l.daily_accrued_interest + l.daily_accrued_finance_cost + l.arrangement_fee),

      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      reference_no: l.reference_no,
      offtakerID: cO.id,
      offtaker_companyName: cO.companyName,
      offtaker_companyPhone: cO.companyPhone,
      offtaker_contactEmail: cO.contactEmail,
      offtaker_createdByUserId: cO.createdByUserId,
      offtaker_createdByUserRoleId: cO.createdByUserRoleId,
      offtaker_registrationNumber: cO.registrationNumber,
      offtaker_status: cO.status,
      offtaker_taxno: cO.taxno,
      offtaker_companyRegistrationDate: cO.companyRegistrationDate,
      offtaker_companyAccountNumber: cO.companyAccountNumber,
      offtaker_bank_id: cO.bank_id,
      total_balance_acrued: l.balance,
      repayment_type: l.repayment_type
    })
    |> Repo.one()
  end

  # Loanmanagementsystem.Operations.get_company_details_by_reference_no(7592)
  def get_company_details_by_reference_no(reference_no) do
    Loans
    |> join(:left, [l], cO in "tbl_company", on: l.company_id == cO.id)
    |> where([l, cO], l.reference_no == ^reference_no)
    |> select([l, cO], %{
      company_id: cO.id,
      company_companyName: cO.companyName,
      company_companyPhone: cO.companyPhone,
      company_contactEmail: cO.contactEmail,
      company_createdByUserId: cO.createdByUserId,
      company_createdByUserRoleId: cO.createdByUserRoleId,
      company_registrationNumber: cO.registrationNumber,
      company_status: cO.status,
      company_taxno: cO.taxno,
      company_companyRegistrationDate: cO.companyRegistrationDate,
      company_companyAccountNumber: cO.companyAccountNumber,
      company_bank_id: cO.bank_id,
      customer_id: l.customer_id
    })
    |> Repo.one()
  end

  # Loanmanagementsystem.Operations.get_client_company_detials("1234567")
  def get_client_company_detials(reference_no) do
    Loans
    |> join(:left, [l], cO in "tbl_client_company_details", on: l.customer_id == cO.userId)
    |> where([l, cO], l.reference_no == ^reference_no)
    |> select([l, cO], %{
      individual_bank_id: cO.bank_id,
      individual_company_account_number: cO.company_account_number,
      individual_company_name: cO.company_name,
      individual_company_phone: cO.company_phone,
      individual_company_registration_date: cO.company_registration_date,
      individual_contact_email: cO.contact_email,
      individual_createdByUserId: cO.createdByUserId,
      individual_createdByUserRoleId: cO.createdByUserRoleId,
      individual_registration_number: cO.registration_number,
      individual_company_status: cO.status,
      individual_taxno: cO.taxno,
      individual_company_department: cO.company_department,
      individual_company_bank_name: cO.company_bank_name,
      individual_company_account_name: cO.company_account_name,
      customer_id: l.customer_id
    })
    |> Repo.one()
  end

  # def customer_report() do
  #   User
  #   |>join(:left, [uS], uB in UserBioData, on: uS.id == uB.userId)
  #   |> join(:left, [uS, uB], uR in UserRole, on: )
  # end



  # Loanmanagementsystem.Operations.loan_application_report_miz(nil, 1, 10)

  def loan_application_report_miz(search_params, page, size) do
    Loans
    |> handle_loan_application_report_filter(search_params)
    |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_loan_application_report_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def loan_application_report_miz(_source, search_params) do
    Loans
    |> handle_loan_application_report_filter(search_params)
    |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_loan_application_report_miz()
  end

  defp compose_loan_application_report_miz(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
    |> where([l, uB, p, cO], is_nil(l.application_date) != true and l.status == "PENDING_CREDIT_ANALYST")
    |> select([l, uB, p, cO], %{
      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      customer_phone_number:
        fragment(
          "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
        company_client:
        fragment(
          "select \"companyName\" from tbl_company where \"id\" = ?",
          l.company_id
        ),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
      company_id: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: l.interest_amount,
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      tenor: l.tenor,
      end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      start_date: l.disbursedon_date,
      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      number_of_months: l.eod_count,
      accrued_no_days: l.accrued_no_days

    })
  end

defp handle_loan_application_report_filter(query, %{"isearch" => search_term} = search_params)
  when search_term == "" or is_nil(search_term) do
query
|> handle_loan_created_date_filter(search_params)
|> handle_fname_filter(search_params)
|> handle_lname_filter(search_params)
|> handle_loan_application_type_filter(search_params)
|> handle_requested_amount_filter(search_params)
|> handle_loan_disbursement_date_filter(search_params)
|> handle_loan_application_date_filter(search_params)
|> handle_filter_by_days_miz_date_filter(search_params)
# |> handle_reference_number_filter(search_params)
# |> handle_company_registration_number_filter(search_params)
# |> handle_loan_status_type_filter(search_params)
|> handle_contact_person_filter(search_params)
end

  # Loanmanagementsystem.Operations.loan_credit_assessment_report_miz(nil, 1, 10)

  def loan_credit_assessment_report_miz(search_params, page, size) do
    Loans
    |> handle_loan_credit_assessment_report_filter(search_params)
    |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_loan_credit_assessment_report_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def loan_credit_assessment_report_miz(_source, search_params) do
    Loans
    |> handle_loan_credit_assessment_report_filter(search_params)
    |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_loan_credit_assessment_report_miz()
  end

  defp compose_loan_credit_assessment_report_miz(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
    |> where([l, uB, p, cO], is_nil(l.application_date) != true and (l.status == "PENDING_OPERATIONS_MANAGER" or l.status == "OPERATIONS AND CREDIT MANAGER APPROVAL"))
    |> select([l, uB, p, cO], %{
      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      customer_phone_number:
        fragment(
          "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      company_client:
        fragment(
          "select \"companyName\" from tbl_company where \"id\" = ?",
          l.company_id
        ),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
      company_id: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: l.interest_amount,
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      tenor: l.tenor,
      end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      start_date: l.disbursedon_date,
      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      number_of_months: l.eod_count,
      accrued_no_days: l.accrued_no_days


    })
  end

  defp handle_loan_credit_assessment_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_created_date_filter(search_params)
    |> handle_fname_filter(search_params)
    |> handle_lname_filter(search_params)
    |> handle_loan_application_type_filter(search_params)
    |> handle_requested_amount_filter(search_params)
    |> handle_loan_disbursement_date_filter(search_params)
    |> handle_loan_application_date_filter(search_params)
    |> handle_filter_by_days_miz_date_filter(search_params)
    # |> handle_reference_number_filter(search_params)
    # |> handle_company_registration_number_filter(search_params)
    # |> handle_loan_status_type_filter(search_params)
    |> handle_contact_person_filter(search_params)
  end

  # Loanmanagementsystem.Operations.approve_loan_awaiting_disbursement_miz(nil, 1, 10)

  def approve_loan_awaiting_disbursement_miz(search_params, page, size) do
    Loans
    |> handle_loan_awaiting_disbursement_report_filter(search_params)
    |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_approve_loan_awaiting_disbursement_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def approve_loan_awaiting_disbursement_miz(_source, search_params) do
    Loans
    |> handle_loan_awaiting_disbursement_report_filter(search_params)
    |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_approve_loan_awaiting_disbursement_miz()
  end

  defp compose_approve_loan_awaiting_disbursement_miz(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
    |> where([l, uB, p, cO], l.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT" or l.loan_status == "PENDING_ACCOUNTANT")
    |> select([l, uB, p, cO], %{
      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      customer_phone_number:
        fragment(
          "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      company_client:
        fragment(
          "select \"companyName\" from tbl_company where \"id\" = ?",
          l.company_id
        ),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
      company_id: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: l.interest_amount,
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      tenor: l.tenor
    })
  end


defp handle_loan_awaiting_disbursement_report_filter(query, %{"isearch" => search_term} = search_params)
  when search_term == "" or is_nil(search_term) do
query
|> handle_loan_created_date_filter(search_params)
|> handle_fname_filter(search_params)
|> handle_lname_filter(search_params)
|> handle_loan_application_type_filter(search_params)
|> handle_requested_amount_filter(search_params)
|> handle_loan_disbursement_date_filter(search_params)
|> handle_loan_application_date_filter(search_params)
|> handle_filter_by_days_miz_date_filter(search_params)
# |> handle_reference_number_filter(search_params)
# |> handle_company_registration_number_filter(search_params)
# |> handle_loan_status_type_filter(search_params)
|> handle_contact_person_filter(search_params)
end


  # Loanmanagementsystem.Operations.get_monthly_loans_by_companies
  def get_monthly_loans_by_companies() do
    # start_date = Timex.beginning_of_day(Timex.now)
    # start_end = Timex.end_of_day(Timex.now)
    this_year = Timex.today().year

    Loanmanagementsystem.Loan.Loans
    |> join(:left, [lo], u in "tbl_company", on: lo.company_id == u.id)
    |> order_by([lo, u],
      asc: [
        fragment(
          "SELECT CONCAT(CONCAT(TO_CHAR(?, 'Month'),'-'), EXTRACT(YEAR FROM ?))",
          lo.inserted_at,
          lo.inserted_at
        )
      ]
    )
    |> group_by([lo, u], [
      fragment("SELECT TO_CHAR(?, 'Month')", lo.inserted_at),
      fragment(
        "SELECT CONCAT(CONCAT(TO_CHAR(?, 'Month'),'-'), EXTRACT(YEAR FROM ?))",
        lo.inserted_at,
        lo.inserted_at
      ),
      u.id,
      u.companyName,
      lo.repayment_type,
      lo.inserted_at
    ])
    |> where(
      [lo, u],
      is_nil(lo.repayment_type) != true and lo.loan_status != "PENDING_MOMO" and
        lo.loan_status != "FAILED" and
        fragment("SELECT EXTRACT(YEAR FROM ?)", lo.inserted_at) == ^this_year
    )
    |> select([lo, u],
      year:
        fragment(
          "SELECT CONCAT(CONCAT( REGEXP_REPLACE(TO_CHAR(?,'Month'), '\s+$', ''),'-'),EXTRACT(YEAR FROM ?))",
          lo.inserted_at,
          lo.inserted_at
        ),
      period: fragment("CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'),'\s+$',''))", lo.inserted_at),
      count_companies: count(fragment("SELECT DISTINCT ON (company_id) ?", lo.company_id)),
      principal_disbursed_derived: sum(lo.principal_disbursed_derived),
      total_repayment_derived: sum(lo.total_repayment_derived),
      company_name: u.companyName,
      company_id: count(u.id),
      repayment_type: lo.repayment_type,
      # customer_count: count(fragment("DISTINCT ?", lo.customer_id)),
      total_repayment_amount:
        fragment(
          "SELECT SUM(total_repayment_derived) as total_repayment_derived WHERE EXTRACT(YEAR FROM ?) = ? and repayment_type is NOT NULL",
          lo.inserted_at,
          ^this_year
        ),
      total_outstanding_derived:
        fragment(
          "SELECT SUM(total_expected_repayment_derived) as total_expected_repayment_derived WHERE EXTRACT(YEAR FROM ?) = ? and repayment_type is NOT NULL",
          lo.inserted_at,
          ^this_year
        ),
      interest_outstanding_derived:
        fragment(
          "SELECT SUM(interest_outstanding_derived) as interest_outstanding_derived WHERE EXTRACT(YEAR FROM ?) = ? and repayment_type is NOT NULL",
          lo.inserted_at,
          ^this_year
        )
    )
    |> Repo.all()
    |> Enum.map(&Enum.into(&1, %{}))
  end

  # def get_monthly_loans_by_companies() do

  #   # start_date = Timex.beginning_of_day(Timex.now)
  #   # start_end = Timex.end_of_day(Timex.now)
  #   this_year = Timex.today.year

  #   LoanSystem.Loan.Loans
  # |> join(:left, [lo], u in "tbl_companies", on: lo.company_id == u.id)
  # # |> where([a], a.status == "COMPLETE" and fragment("DATEPART(MONTH, ?) = ? and YEAR(?) = ?", a.date, ^month, a.date, ^year))
  # |> order_by([lo, u], asc: [fragment("DATEPART(YEAR, ?)", lo.inserted_at), fragment("DATEPART(MONTH, ?)", lo.inserted_at)])
  # |> group_by([lo, u], [fragment("DATEPART(YEAR, ?)", lo.inserted_at), fragment("DATEPART(MONTH, ?)", lo.inserted_at), fragment("CONCAT(DATENAME(mm, (?)), '-', DATEPART(yy, (?)))", lo.inserted_at, lo.inserted_at), u.id, u.company_name, lo.loan_status])
  # |> where([lo, u], lo.loan_status != "PENDING_MOMO" and lo.loan_status != "FAILED" and fragment("DATEPART(YEAR, ?)", lo.inserted_at) == ^this_year)
  # |> select([lo, u],

  #   year: fragment("CONCAT(DATENAME(mm, (?)), '-', DATEPART(yy, (?)))", lo.inserted_at, lo.inserted_at),
  #   period: fragment("DATEPART(MONTH, ?)", lo.inserted_at),
  #   count_companies: count(fragment("DISTINCT ?", lo.company_id)),
  #   principal_disbursed_derived: sum(lo.principal_disbursed_derived),
  #   total_repayment_derived: sum(lo.total_repayment_derived),
  #   company_name: u.company_name,
  #   company_id: count(u.id),
  #   customer_count: count(fragment("DISTINCT ?", lo.customer_id)),

  #   total_repayment_amount: fragment("SELECT SUM(total_repayment_derived) as total_repayment_derived WHERE EXTRACT(YEAR FROM ?) = ?;", lo.inserted_at, ^this_year),
  #   total_outstanding_derived: fragment("select sum(total_expected_repayment_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'Disbursed' ", lo.inserted_at),
  #   interest_outstanding_derived: fragment("select sum(interest_outstanding_derived) where DATEPART(year, ?) = YEAR(CURRENT_TIMESTAMP) and loan_status = 'Disbursed' ", lo.inserted_at),

  #   )

  #     |> Repo.all()
  #     |> Enum.map(&Enum.into(&1, %{}))

  # end

  # Loanmanagementsystem.Operations.debtors_analysis_report(nil, 1, 10, Timex.today.year)

  def debtors_analysis_report(search_params, page, size, this_year) do
    Loans
    |> handle_loan_debtors_analysis_report_filter(search_params)
    # |> order_by([lo, u, uB], fragment("SELECT CONCAT(CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'), '\s+$', ''),'-'),EXTRACT(YEAR FROM ?))", lo.inserted_at, lo.inserted_at))
    |> compose_debtors_analysis_report(this_year)
    |> Repo.paginate(page: page, page_size: size)
  end

  def debtors_analysis_report(_source, search_params, this_year) do
    Loans
    |> handle_loan_debtors_analysis_report_filter(search_params)
    # |> order_by([l, cO, uB], fragment("SELECT CONCAT(CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'), '\s+$', ''),'-'),EXTRACT(YEAR FROM ?))", lo.inserted_at, lo.inserted_at))
    |> compose_debtors_analysis_report(this_year)
  end

  defp compose_debtors_analysis_report(query, this_year) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.funderID == uB.userId)
    |> join(:left, [l, uB], p in Product, on: l.product_id == p.id)
    |> join(:left, [l,uB, p], cO in "tbl_company", on: l.company_id == cO.id)

    # |> order_by([l, uB, p, cO], asc: fragment("SELECT CONCAT(CONCAT(TO_CHAR(?, 'Month'),'-'), EXTRACT(YEAR FROM ?))", l.inserted_at, l.inserted_at))
    # |> group_by([l, uB, p, cO], [fragment("SELECT TO_CHAR(?, 'Month')", l.inserted_at), fragment("SELECT CONCAT(CONCAT(TO_CHAR(?, 'Month'),'-'), EXTRACT(YEAR FROM ?))", l.inserted_at, l.inserted_at), cO.id, cO.companyName, l.repayment_type, l.inserted_at, l.loan_type, uB.firstName, uB.lastName, l.principal_amount,l.interest_amount])
    |> group_by([l, uB, p, cO], [
      l.repayment_type,
      cO.companyPhone,
      cO.companyName,
      l.company_id,
      l.loan_type,
      l.principal_amount,
      l.interest_amount,
      l.inserted_at,
      l.disbursedon_date,
      uB.firstName,
      uB.lastName,
      cO.user_bio_id,
      l.funderID,
      l.id,
      l.daily_accrued_interest,
      l.daily_accrued_finance_cost

    ])
    |> where(
      [l, uB, p, cO],
      is_nil(l.repayment_type) != true and
        fragment("SELECT EXTRACT(YEAR FROM ?)", l.inserted_at) == ^this_year
    )
    |> select([l, uB, p, cO], %{
      year:
        fragment(
          "SELECT CONCAT(CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'), '\s+$', ''),'-'),EXTRACT(YEAR FROM ?))",
          l.inserted_at,
          l.inserted_at
        ),
      period: fragment("CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'),'\s+$',''))", l.inserted_at),
      count_companies: count(fragment("SELECT DISTINCT ON (company_id) ?", l.company_id)),
      principal_disbursed_derived: sum(l.principal_disbursed_derived),
      total_repayment_derived: sum(l.total_repayment_derived),
      company_name: cO.companyName,
      company_phone_number: cO.companyPhone,
      loan_type: l.loan_type,
      company_id: count(cO.id),
      repayment_type: l.repayment_type,
      individual_funder_name:
        fragment(
          "SELECT CONCAT(\"firstName\", CONCAT(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?",
          l.funderID
        ),
      customer_count: count(fragment("DISTINCT ?", l.customer_id)),
      principal_amount: l.principal_amount,
      interest_amount: l.interest_amount,
      total_repayment_amount:
        fragment(
          "SELECT SUM(total_repayment_derived) as total_repayment_derived WHERE EXTRACT(YEAR FROM ?) = ? and repayment_type is NOT NULL",
          l.inserted_at,
          ^this_year
        ),
      total_outstanding_derived:
        fragment(
          "SELECT SUM(total_expected_repayment_derived) as total_expected_repayment_derived WHERE EXTRACT(YEAR FROM ?) = ? and repayment_type is NOT NULL",
          l.inserted_at,
          ^this_year
        ),
      interest_outstanding_derived:
        fragment(
          "SELECT SUM(interest_outstanding_derived) as interest_outstanding_derived WHERE EXTRACT(YEAR FROM ?) = ? and repayment_type is NOT NULL",
          l.inserted_at,
          ^this_year
        ),
        end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
        start_date: l.disbursedon_date,
        daily_accrued_interest: l.daily_accrued_interest,
        daily_accrued_finance_cost: l.daily_accrued_finance_cost,
        # total_balance_acrued: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),
        total_balance_acrued: l.balance,
        accrued_no_days: l.accrued_no_days,
        customer_represe: fragment("select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"id\" = ?", cO.user_bio_id),
        customer_names:
          fragment(
            "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
            l.customer_id
          ),

        company_client:
            fragment(
              "select \"companyName\" from tbl_company where \"id\" = ?",
              l.company_id
            ),
        corporate_funder_name:
          fragment(
            "SELECT \"companyName\" FROM tbl_company WHERE \"user_bio_id\" = (SELECT \"id\" FROM tbl_user_bio_data WHERE \"userId\" = ?)",
            l.funderID
          ),


    })
  end

defp handle_loan_debtors_analysis_report_filter(query, %{"isearch" => search_term} = search_params)
    when search_term == "" or is_nil(search_term) do
  query
  |> handle_loan_created_date_filter(search_params)
  |> handle_fname_filter(search_params)
  |> handle_lname_filter(search_params)
  |> handle_loan_application_type_filter(search_params)
  |> handle_requested_amount_filter(search_params)
  |> handle_loan_disbursement_date_filter(search_params)
  |> handle_loan_application_date_filter(search_params)
  |> handle_filter_by_days_miz_date_filter(search_params)
  # |> handle_reference_number_filter(search_params)
  # |> handle_company_registration_number_filter(search_params)
  # |> handle_loan_status_type_filter(search_params)
  |> handle_contact_person_filter(search_params)
end

  # corperate Customer report look up




  # -------------------------Loan Book ----------------------------------
  # Loanmanagementsystem.Operations.loan_book_analysis_report(nil, 1, 10, Timex.today.year)
  def loan_book_analysis_report(search_params, page, size, this_year) do
    Loans
    |> handle_loan_book_analysis_report_filter(search_params)
    |> compose_loan_book_analysis_report(this_year)
    |> Repo.paginate(page: page, page_size: size)
  end

  def loan_book_analysis_report(_source, search_params, this_year) do
    Loans
    |> handle_loan_book_analysis_report_filter(search_params)
    # |> order_by([l, cO, uB], fragment("SELECT CONCAT(CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'), '\s+$', ''),'-'),EXTRACT(YEAR FROM ?))", lo.inserted_at, lo.inserted_at))
    |> compose_loan_book_analysis_report(this_year)
  end

  defp compose_loan_book_analysis_report(query, this_year) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.funderID == uB.userId)
    |> join(:left, [l, uB], p in Product, on: l.product_id == p.id)
    # |> join(:left, [l,uB, p], cO in "tbl_company", on: l.company_id == cO.id)
    |> join(:left, [l,uB, p], loan_c in Loanmanagementsystem.Loan.Loan_Colletral_Documents, on: l.reference_no == loan_c.reference_no)
    |> join(:left, [l,uB, p, loan_c], funder_bio in UserBioData, on: l.funderID == funder_bio.userId)
    |> order_by([l, uB, p, loan_c, funder_bio], desc: l.disbursedon_date)
    # |> group_by([l, uB, p, cO], [fragment("SELECT TO_CHAR(?, 'Month')", l.inserted_at), fragment("SELECT CONCAT(CONCAT(TO_CHAR(?, 'Month'),'-'), EXTRACT(YEAR FROM ?))", l.inserted_at, l.inserted_at), cO.id, cO.companyName, l.repayment_type, l.inserted_at, l.loan_type, uB.firstName, uB.lastName, l.principal_amount,l.interest_amount])
    # |> group_by([l, uB, p, cO, loan_c], [
    #   l.repayment_type,
    #   cO.companyPhone,
    #   cO.companyName,
    #   l.loan_type,
    #   p.productType,
    #   l.principal_amount,
    #   l.interest_amount,
    #   l.inserted_at,
    #   l.disbursedon_date,
      # uB.firstName,
      # uB.lastName,
    #   l.funderID,
    #   l.tenor,
    #   l.days_under_due,
    #   l.days_over_due,
    #   loan_c.name,
    #   l.company_id
    # ])


    # |> where( [l, uB, p, cO, loan_c], is_nil(l.repayment_type) != true and  fragment("SELECT EXTRACT(YEAR FROM ?)", l.inserted_at) == ^this_year )
    |> where( [l, uB, p, loan_c, funder_bio], is_nil(l.disbursedon_date) != true)
    |> select([l, uB, p, loan_c, funder_bio], %{


      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),

        corporate_collateral:
        fragment("select \"fileName\" from tbl_loan_application_documents where \"loan_id\" = ? and \"fileName\" = ?", l.id, "Original Collateral Document & Letter Of Sale"),

        individual_client_collateral:
          fragment("select \"fileName\" from tbl_loan_application_documents where \"loan_id\" = ? and \"fileName\" = ?", l.id, "Post-dated cheques"),

        funder_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.funderID
        ),
        funder_as_company:
        fragment("select \"companyName\" from tbl_company where \"user_bio_id\" = ?", funder_bio.id),

      customer_phone_number:
        fragment(
          "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      company_client:
        fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),

      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      application_date: l.application_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      repayment_amount: l.repayment_amount,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
      company_id: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: (l.interest_amount + l.finance_cost),
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      tenor: l.tenor,
      days_under_due: l.days_under_due,
      days_over_due: l.days_over_due,
      end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      start_date: l.disbursedon_date,
      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      # total_balance_acrued: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),
      total_balance_acrued: l.balance,
      number_of_months: l.eod_count,
      accrued_no_days: l.accrued_no_days,
      total_daily_accrued_charges: (l.daily_accrued_interest + l.daily_accrued_finance_cost),
      total_collectable_amount: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),




      # year:
      #   fragment(
      #     "SELECT CONCAT(CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'), '\s+$', ''),'-'),EXTRACT(YEAR FROM ?))",
      #     l.inserted_at,
      #     l.inserted_at
      #   ),
      # period: fragment("CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'),'\s+$',''))", l.inserted_at),
      # # count_companies: count(fragment("SELECT DISTINCT ON (company_id) ?", l.company_id)),
      # principal_disbursed_derived: sum(l.principal_disbursed_derived),
      # total_repayment_derived: sum(l.total_repayment_derived),
      # company_name: cO.companyName,
      # company_phone_number: cO.companyPhone,
      # loan_type: l.loan_type,
      # company_client: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),
      # # company_id: count(cO.id),
      # repayment_type: l.repayment_type,
      # disbursedon_date: l.disbursedon_date,
      # productType: p.productType,
      # tenor: l.tenor,
      # days_under_due: l.days_under_due,
      # days_over_due: l.days_over_due,
      # principal_repaid_derived: sum(l.principal_repaid_derived),
      # balance: sum(l.balance),
      # collatral_name: loan_c.name,
      # funder_name:
      #   fragment(
      #     "SELECT CONCAT(\"firstName\", CONCAT(' ', \"lastName\"))  from tbl_user_bio_data where \"userId\" = ?",
      #     l.funderID
      #   ),
      # # customer_count: count(fragment("DISTINCT ?", l.customer_id)),
      # principal_amount: l.principal_amount,
      # interest_amount: l.interest_amount,
      # total_repayment_amount:
      #   fragment(
      #     "SELECT SUM(total_repayment_derived) as total_repayment_derived WHERE EXTRACT(YEAR FROM ?) = ? and repayment_type is NOT NULL",
      #     l.inserted_at,
      #     ^this_year
      #   ),
      # total_outstanding_derived:
      #   fragment(
      #     "SELECT SUM(total_expected_repayment_derived) as total_expected_repayment_derived WHERE EXTRACT(YEAR FROM ?) = ? and repayment_type is NOT NULL",
      #     l.inserted_at,
      #     ^this_year
      #   ),
      # interest_outstanding_derived:
      #   fragment(
      #     "SELECT SUM(interest_outstanding_derived) as interest_outstanding_derived WHERE EXTRACT(YEAR FROM ?) = ? and repayment_type is NOT NULL",
      #     l.inserted_at,
      #     ^this_year
      #   )
    })
  end

defp handle_loan_book_analysis_report_filter(query, %{"isearch" => search_term} = search_params)
    when search_term == "" or is_nil(search_term) do
  query
  # |> handle_loan_created_date_filter(search_params)
  # |> handle_fname_filter(search_params)
  # |> handle_lname_filter(search_params)
  # |> handle_loan_application_type_filter(search_params)
  |> handle_loan_book_requested_amount_filter(search_params)
  # |> handle_loan_disbursement_date_filter(search_params)
  # |> handle_loan_application_date_filter(search_params)
  # |> handle_filter_by_days_miz_date_filter(search_params)
  # |> handle_reference_number_filter(search_params)
  # |> handle_company_registration_number_filter(search_params)
  # |> handle_loan_status_type_filter(search_params)
  # |> handle_contact_person_filter(search_params)
  |> handle_loan_book_loan_type_filter(search_params)
  |> handle_loan_book_loan_outstanding_amount_filter(search_params)
  |> handle_loan_book_loan_status_filter(search_params)


end

  # -----------------------------------------------------------------
  # Loanmanagementsystem.Operations.corperate_customer_report_miz(nil, 1, 10)

  def corperate_customer_report_miz(search_params, page, size) do
    Loans
    |> handle_corperate_customer_filter(search_params)
    |> compose_corperate_customer_report_miz()
    |> order_by([l, uB, p, cO], desc: l.disbursedon_date)
    |> Repo.paginate(page: page, page_size: size)
  end

  def corperate_customer_report_miz(_source, search_params) do
    Loans
    |> handle_corperate_customer_filter(search_params)
    |> compose_corperate_customer_report_miz()
    |> order_by([l, uB, p, cO], desc: l.disbursedon_date)
  end

  defp compose_corperate_customer_report_miz(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l, uB], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
    |> where([l, uB, p, cO], is_nil(l.company_id) != true)
    |> select([l, uB, p, cO], %{
      loan_id: l.id,
      txn_loan_id:
      fragment(
        "select \"loan_id\" from tbl_transactions where \"loan_id\" = ? ORDER BY inserted_at DESC LIMIT 1",
        l.id
      ),
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      customer_phone_number:
        fragment(
          "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      customer_reg_number:
        fragment(
          "select \"meansOfIdentificationNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      company_client:
        fragment(
          "select \"companyName\" from tbl_company where \"id\" = ?",
          l.company_id
        ),

      # invoice_value: fragment(
      #   "select \"invoiceValue\" from tbl_loan_invoice where \"id\" = ?",
      #   l.id
      # ),
      invoice_no: fragment(
        "select \"invoiceNo\" from tbl_loan_invoice where \"id\" = ?",
        l.id
      ),

      vendor_name: fragment(
        "select \"vendorName\" from tbl_loan_invoice where \"id\" = ?",
        l.id
      ),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
      company_name:
        fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),
      offtakerID: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: l.interest_amount,
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      tenor: l.tenor,
      funder:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.funderID
        ),
      company_reg_no:
        fragment("select \"registrationNumber\" from tbl_company where \"id\" = ?", l.company_id),
      repayment_amount: l.repayment_amount,
      due_date:
        fragment("SELECT max(date) FROM tbl_loan_amortization_schedule WHERE loan_id = (?)", l.id),
      last_repayment_date:
        fragment(
          "SELECT max(\"dateOfRepayment\") FROM tbl_loan_repayment WHERE loan_id = (?)",
          l.id
        ),
      monthly_installment: l.monthly_installment,
      accrued_interest: fragment("SELECT interest_accrued FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      # accrued_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      # accrued_period: fragment("(? - ?)", fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id), l.disbursedon_date),
      end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      start_date: l.disbursedon_date,
      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      # total_balance_acrued: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),
      total_balance_acrued: l.balance,
      invoice_number:
        fragment("select \"invoiceNo\" from tbl_loan_invoice where \"loanID\" = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      order_number:
        fragment("select \"order_number\" from tbl_order_finace_loan_invoice where \"loan_id\" = ? ORDER BY inserted_at DESC LIMIT 1", l.id),

      invoice_value:
        fragment("select \"invoiceValue\" from tbl_loan_invoice where \"loanID\" = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      order_value:
        fragment("select \"order_value\" from tbl_order_finace_loan_invoice where \"loan_id\" = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      number_of_months: l.eod_count,
      accrued_no_days: l.accrued_no_days,
      customer_user_id: l.customer_id,




      # accrued_period: fragment("(SELECT DATEDIFF(MAX(inserted_at), ?) FROM tbl_end_of_day_entries WHERE loan_id = ?)", l.disbursedon_date, l.id)

    })


  end

  defp handle_corperate_customer_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_created_date_filter(search_params)
    |> handle_fname_filter(search_params)
    |> handle_lname_filter(search_params)
    |> handle_loan_application_type_filter(search_params)
    |> handle_requested_amount_filter(search_params)
    |> handle_loan_disbursement_date_filter(search_params)
    |> handle_company_registration_number_filter(search_params)
  end

  defp handle_corperate_customer_filter(query, %{"isearch" => search_term}) do
    search_term = "%#{search_term}%"
    compose_loan_isearch_filter(query, search_term)
  end

  defp handle_fname_filter(query, %{"first_name_filter" => first_name_filter}) do
    where(
      query,
      [l, uB, p, cO],
      fragment("lower(?) LIKE lower(?)", uB.firstName, ^"%#{first_name_filter}%")
    )
  end

  defp handle_fname_filter(query, %{"first_name_filter" => first_name_filter})
       when first_name_filter == "" or is_nil(first_name_filter),
       do: query

  defp handle_lname_filter(query, %{"last_name_filter" => last_name_filter}) do
    where(
      query,
      [l, uB, p, cO],
      fragment("lower(?) LIKE lower(?)", uB.lastName, ^"%#{last_name_filter}%")
    )
  end

  defp handle_lname_filter(query, %{"last_name_filter" => last_name_filter})
       when last_name_filter == "" or is_nil(last_name_filter),
       do: query

  defp handle_loan_application_type_filter(query, %{"loan_type_filter" => loan_type_filter}) do
    where(
      query,
      [l, uB, p, cO],
      fragment("lower(?) LIKE lower(?)", l.loan_type, ^"%#{loan_type_filter}%")
    )
  end

  defp handle_loan_application_type_filter(query, %{"loan_type_filter" => loan_type_filter})
       when loan_type_filter == "" or is_nil(loan_type_filter),
       do: query

  defp handle_requested_amount_filter(query, %{
         "requested_amount_filter" => requested_amount_filter
       }) do
    where(
      query,
      [l, uB, p, cO],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        l.requested_amount,
        ^"%#{requested_amount_filter}%"
      )
    )
  end

  defp handle_requested_amount_filter(query, %{
         "requested_amount_filter" => requested_amount_filter
       })
       when requested_amount_filter == "" or is_nil(requested_amount_filter),
       do: query

  defp handle_company_registration_number_filter(query, %{
         "registration_number_filter" => registration_number_filter
       }) do
    where(
      query,
      [l, uB, p, cO],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        cO.registrationNumber,
        ^"%#{registration_number_filter}%"
      )
    )
  end

  defp handle_company_registration_number_filter(query, %{
         "registration_number_filter" => registration_number_filter
       })
       when registration_number_filter == "" or is_nil(registration_number_filter),
       do: query

  defp handle_loan_created_date_filter(query, %{"from" => from, "to" => to})
       when byte_size(from) > 0 and byte_size(to) > 0 do
    query
    |> where(
      [l, uB, p, cO],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.inserted_at, ^from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.inserted_at, ^to)
    )
  end

  defp handle_loan_created_date_filter(query, _params), do: query

  defp handle_loan_disbursement_date_filter(query, %{
         "disbursement_from" => disbursement_from,
         "disbursement_to" => disbursement_to
       })
       when byte_size(disbursement_from) > 0 and byte_size(disbursement_to) > 0 do
    query
    |> where(
      [l, uB, p, cO],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^disbursement_from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^disbursement_to)
    )
  end

  defp handle_loan_disbursement_date_filter(query, _params), do: query

  defp handle_loan_application_date_filter(query, %{
         "applied_on_from" => applied_on_from,
         "applied_on_to" => applied_on_to
       })
       when byte_size(applied_on_from) > 0 and byte_size(applied_on_to) > 0 do
    query
    |> where(
      [l, uB, p, cO],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.application_date, ^applied_on_from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.application_date, ^applied_on_to)
    )
  end

  defp handle_loan_application_date_filter(query, _params), do: query

  defp compose_loan_isearch_filter(query, search_term) do
    query
    |> where(
      [l, uB, p],
      fragment("lower(?) LIKE lower(?)", l.loan_type, ^search_term) or
        fragment("lower(?) LIKE lower(?)", l.requested_amount, ^search_term) or
        fragment("lower(?) LIKE lower(?)", uB.firstName, ^search_term)
    )
  end

  # ------------------------------ End of COrperate customer loan--------------------------

  # Loanmanagementsystem.Operations.individual_customer_report_miz(nil, 1, 10)

  def individual_customer_report_miz(search_params, page, size) do
    Loans
    |> handle_individual_customer_filter(search_params)
    |> compose_individual_customer_report_miz()
    |> order_by([l, uB, p], desc: l.disbursedon_date)
    |> Repo.paginate(page: page, page_size: size)
  end

  def individual_customer_report_miz(_source, search_params) do
    Loans
    |> handle_individual_customer_filter(search_params)
    |> compose_individual_customer_report_miz()
    |> order_by([l, uB, p], desc: l.disbursedon_date)
  end

  defp compose_individual_customer_report_miz(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> where([l, uB, p], is_nil(l.company_id) == true)
    |> select([l, uB, p], %{
      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      customer_phone_number:
        fragment(
          "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      customer_reg_number:
        fragment(
          "select \"meansOfIdentificationNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      company_client:
        fragment(
          "select \"companyName\" from tbl_company where \"id\" = ?",
          l.company_id
        ),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
      company_name:
        fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),
      offtakerID: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: l.interest_amount,
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      tenor: l.tenor,
      funder:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.funderID
        ),
      company_reg_no:
        fragment("select \"registrationNumber\" from tbl_company where \"id\" = ?", l.company_id),
      repayment_amount: l.repayment_amount,
      due_date:
        fragment("SELECT max(date) FROM tbl_loan_amortization_schedule WHERE loan_id = (?)", l.id),
      last_repayment_date:
        fragment(
          "SELECT max(\"dateOfRepayment\") FROM tbl_loan_repayment WHERE loan_id = (?)",
          l.id
        ),
      monthly_installment: l.monthly_installment,
      accrued_interest: fragment("SELECT interest_accrued FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      # accrued_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      # accrued_period: fragment("(? - ?)", fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id), l.disbursedon_date),
      end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      start_date: l.disbursedon_date,
      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      # total_balance_acrued: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),
      total_balance_acrued: l.balance,
      number_of_months: l.eod_count,
      accrued_no_days: l.accrued_no_days,
      txn_loan_id: fragment("select \"loan_id\" from tbl_transactions where \"loan_id\" = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
    })
  end

  defp handle_individual_customer_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_created_date_filter(search_params)
    |> handle_fname_filter(search_params)
    |> handle_lname_filter(search_params)
    |> handle_loan_application_type_filter(search_params)
    |> handle_requested_amount_filter(search_params)
    |> handle_loan_disbursement_date_filter(search_params)
  end

  # Loanmanagementsystem.Operations.transaction_report_miz(nil, 1, 10)

  def transaction_report_miz(search_params, page, size) do
    Loans
    |> handle_transaction_report_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_transaction_report_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def transaction_report_miz(_source, search_params) do
    Loans
    |> handle_transaction_report_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_transaction_report_miz()
  end

  defp compose_transaction_report_miz(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
    |> where(
      [l, uB, p, cO],
      l.loan_status == "PENDING_CREDIT_ANALYST_REPAYMENT" or l.loan_status == "REPAID" or
        l.loan_status == "DISBURSED"
    )
    |> select([l, uB, p, cO], %{
      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      customer_phone_number:
        fragment(
          "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      customer_reg_number:
        fragment(
          "select \"meansOfIdentificationNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
      company_name:
        fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),
      offtakerID: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: l.interest_amount,
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      tenor: l.tenor,
      funder:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.funderID
        ),
      company_reg_no:
        fragment("select \"registrationNumber\" from tbl_company where \"id\" = ?", l.company_id),
      repayment_amount: l.repayment_amount,
      due_date:
        fragment("SELECT max(date) FROM tbl_loan_amortization_schedule WHERE loan_id = (?)", l.id),
      last_repayment_date:
        fragment(
          "SELECT max(\"dateOfRepayment\") FROM tbl_loan_repayment WHERE loan_id = (?)",
          l.id
        ),
      monthly_installment: l.monthly_installment
    })
  end

  defp handle_transaction_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_created_date_filter(search_params)
    |> handle_fname_filter(search_params)
    |> handle_lname_filter(search_params)
    |> handle_loan_application_type_filter(search_params)
    |> handle_requested_amount_filter(search_params)
    |> handle_loan_disbursement_date_filter(search_params)
    |> handle_loan_application_date_filter(search_params)
    # |> handle_company_id_filter(search_params)
    |> handle_reference_number_filter(search_params)
    |> handle_company_registration_number_filter(search_params)
    |> handle_loan_status_type_filter(search_params)
    |> handle_loan_repayment_type_filter(search_params)
  end

  defp handle_loan_status_type_filter(query, %{"loan_status_filter" => loan_status_filter}) do
    where(
      query,
      [l, uB, p, cO],
      fragment("lower(?) LIKE lower(?)", l.loan_status, ^"%#{loan_status_filter}%")
    )
  end

  defp handle_loan_status_type_filter(query, %{"loan_status_filter" => loan_status_filter})
       when loan_status_filter == "" or is_nil(loan_status_filter),
       do: query



  defp handle_loan_repayment_type_filter(query, %{
         "loan_repayment_status_filter" => loan_repayment_status_filter
       }) do
    where(
      query,
      [l, uB, p, cO],
      fragment("lower(?) LIKE lower(?)", l.repayment_type, ^"%#{loan_repayment_status_filter}%")
    )
  end

  defp handle_loan_repayment_type_filter(query, %{
         "loan_repayment_status_filter" => loan_repayment_status_filter
       })
       when loan_repayment_status_filter == "" or is_nil(loan_repayment_status_filter),
       do: query

  defp handle_company_id_filter(query, %{"company_id_filter" => company_id_filter}) do
    IO.inspect(company_id_filter, label: "--------------------- ")
    where(
      query,
      [l, uB, p, cO],
      fragment("lower(?) LIKE lower(?)", cO.id, ^"#{company_id_filter}")
    )
  end

  defp handle_company_id_filter(query,__params ), do: query
      #  when company_id_filter == "" or is_nil(company_id_filter),


  defp handle_reference_number_filter(query, %{
         "reference_number_filter" => reference_number_filter
       }) do
    where(
      query,
      [l, uB, p, cO],
      fragment("lower(?) LIKE lower(?)", l.reference_no, ^"%#{reference_number_filter}%")
    )
  end

  defp handle_reference_number_filter(query, %{
         "reference_number_filter" => reference_number_filter
       })
       when reference_number_filter == "" or is_nil(reference_number_filter),
       do: query

  # --------------------------------------- Loan Application lookup
  # Loanmanagementsystem.Operations.collections_report_listing(nil, 1, 10)
  def collections_report_listing(search_params, page, size) do
    Loanmanagementsystem.Loan.Loans
    |> join(:left, [l], uS in UserBioData, on: l.customer_id == uS.userId)
    |> join(:left, [l, uS, uR], pR in Product, on: pR.id == l.product_id)
    |> join(:left, [l, uS], uR in UserRole, on: uS.userId == uR.userId)
    |> handle_collection_report_filter(search_params)
    |> order_by([l], desc: l.inserted_at)
    |> collections_report_listing_listing()
    |> Repo.paginate(page: page, page_size: size)
  end

  def collections_report_listing(_source, search_params) do
    Loanmanagementsystem.Loan.Loans
    |> join(:left, [l], uS in UserBioData, on: l.customer_id == uS.userId)
    |> join(:left, [l, uS, uR], pR in Product, on: pR.id == l.product_id)
    |> join(:left, [l, uS], uR in UserRole, on: uS.userId == uR.userId)
    |> handle_collection_report_filter(search_params)
    |> order_by([l], desc: l.inserted_at)
    |> collections_report_listing_listing()
  end

  defp collections_report_listing_listing(query) do
    query
    |> where(
      [l, uS, pR, uR],
      l.repayment_type == "PARTIAL REPAYMENT" or l.repayment_type == "FULL REPAYMENT"
    )
    |> select(
      [l, uS, pR, uR],
      %{
        isStaff: uR.isStaff,
        loan_limit: uR.loan_limit,
        due_date:
          fragment(
            "SELECT max(date) FROM tbl_loan_amortization_schedule WHERE loan_id = (?)",
            l.id
          ),
        # tbl_loan
        id: l.id,
        reference_no: l.reference_no,
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
        loan_status: l.loan_status,
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
        sms_status: l.sms_status,
        loan_userroleid: l.loan_userroleid,
        disbursement_method: l.disbursement_method,
        bank_name: l.bank_name,
        bank_account_no: l.bank_account_no,
        account_name: l.account_name,
        bevura_wallet_no: l.bevura_wallet_no,
        receipient_number: l.receipient_number,
        reference_no: l.reference_no,
        repayment_type: l.repayment_type,
        repayment_amount: l.repayment_amount,
        balance: l.balance,
        interest_amount: l.interest_amount,
        tenor: l.tenor,
        tenor_in_days: l.tenor * 30,
        expiry_month: l.expiry_month,
        expiry_year: l.expiry_year,
        cvv: l.cvv,
        repayment_frequency: l.repayment_frequency,
        reason: l.reason,
        application_date: l.application_date,
        reference_no: l.reference_no,
        requested_amount: l.requested_amount,
        arrangement_fee: l.arrangement_fee,
        finance_cost: l.finance_cost,
        monthly_installment: l.monthly_installment,

        # tbl_userbiodate
        dateOfBirth: uS.dateOfBirth,
        emailAddress: uS.emailAddress,
        firstName: uS.firstName,
        customerName: fragment("concat(?, concat(' ', ?))", uS.firstName, uS.lastName),
        gender: uS.gender,
        lastName: uS.lastName,
        meansOfIdentificationNumber: uS.meansOfIdentificationNumber,
        meansOfIdentificationType: uS.meansOfIdentificationType,
        mobileNumber: uS.mobileNumber,
        otherName: uS.otherName,
        title: uS.title,
        userId: uS.userId,
        idNo: uS.idNo,
        bank_id: uS.bank_id,
        personal_bank_account_number: uS.bank_account_number,
        marital_status: uS.marital_status,
        nationality: uS.nationality,
        number_of_dependants: uS.number_of_dependants,
        age: uS.age,
        disability_detail: uS.disability_detail,
        disability_status: uS.disability_status,
        # tbl_product
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
        product_status: pR.status,
        yearLengthInDays: pR.yearLengthInDays,
        principle_account_id: pR.principle_account_id,
        interest_account_id: pR.interest_account_id,
        charges_account_id: pR.charges_account_id,
        classification_id: pR.classification_id,
        charge_id: pR.charge_id,
        reference_id: pR.reference_id,
        product_reason: pR.reason,
        productId: pR.id,
        repayment_type: l.repayment_type
      }
    )
  end


defp handle_collection_report_filter(query, %{"isearch" => search_term} = search_params)
  when search_term == "" or is_nil(search_term) do
query
# |> handle_loan_created_date_filter(search_params)
|> handle_first_name_filter(search_params)
|> handle_last_name_filter(search_params)
|> handle_loan_product_type_filter(search_params)
|> handle_requested_amount_two_filter(search_params)
|> handle_loan_date_of_disbursement_filter(search_params)
|> handle_loan_date_of_application_filter(search_params)
# # |> handle_company_id_filter(search_params)
|> handle_reference_id_filter(search_params)
# |> handle_company_registration_number_filter(search_params)
|> handle_loan_status_filter(search_params)
|> handle_loan_repayment_status_filter(search_params)
end



defp handle_first_name_filter(query, %{"first_name_filter" => first_name_filter}) do
  where(
    query,
    [l, uS, pR, uR],
    fragment("lower(?) LIKE lower(?)", uS.firstName, ^"%#{first_name_filter}%")
  )
end

defp handle_first_name_filter(query, %{"first_name_filter" => first_name_filter})
     when first_name_filter == "" or is_nil(first_name_filter),
     do: query

defp handle_last_name_filter(query, %{"last_name_filter" => last_name_filter}) do
  where(
    query,
    [l, uS, pR, uR],
    fragment("lower(?) LIKE lower(?)", uS.lastName, ^"%#{last_name_filter}%")
  )
end

defp handle_last_name_filter(query, %{"last_name_filter" => last_name_filter})
     when last_name_filter == "" or is_nil(last_name_filter),
     do: query

 defp handle_requested_amount_two_filter(query, %{
        "requested_amount_filter" => requested_amount_filter
      }) do
    where(
        query,
        [l, uS, pR, uR],
        fragment(
          "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
          l.requested_amount,
          ^"%#{requested_amount_filter}%"
      )
  )
end

defp handle_requested_amount_two_filter(query, %{
      "requested_amount_filter" => requested_amount_filter
    })
    when requested_amount_filter == "" or is_nil(requested_amount_filter),
    do: query

defp handle_loan_product_type_filter(query, %{"loan_type_filter" => loan_type_filter}) do
  where(
    query,
    [l, uS, pR, uR],
    fragment("lower(?) LIKE lower(?)", l.loan_type, ^"%#{loan_type_filter}%")
  )
end

defp handle_loan_product_type_filter(query, %{"loan_type_filter" => loan_type_filter})
      when loan_type_filter == "" or is_nil(loan_type_filter),
      do: query

defp handle_loan_status_filter(query, %{"loan_status_filter" => loan_status_filter}) do
  where(
    query,
    [l, uS, pR, uR],
    fragment("lower(?) LIKE lower(?)", l.loan_status, ^"%#{loan_status_filter}%")
  )
end

defp handle_loan_status_filter(query, %{"loan_status_filter" => loan_status_filter})
      when loan_status_filter == "" or is_nil(loan_status_filter),
      do: query



defp handle_loan_repayment_status_filter(query, %{
        "loan_repayment_status_filter" => loan_repayment_status_filter
      }) do
  where(
    query,
    [l, uS, pR, uR],
    fragment("lower(?) LIKE lower(?)", l.repayment_type, ^"%#{loan_repayment_status_filter}%")
  )
end

defp handle_loan_repayment_status_filter(query, %{
        "loan_repayment_status_filter" => loan_repayment_status_filter
      })
      when loan_repayment_status_filter == "" or is_nil(loan_repayment_status_filter),
      do: query

# defp handle_company_registration_id_filter(query, %{
#         "registration_number_filter" => registration_number_filter
#       }) do
#    where(
#      query,
#      [l, uS, pR, uR],
#      fragment(
#        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
#        cO.registrationNumber,
#        ^"%#{registration_number_filter}%"
#      )
#    )
#  end

#  defp handle_company_registration_id_filter(query, %{
#         "registration_number_filter" => registration_number_filter
#       })
#       when registration_number_filter == "" or is_nil(registration_number_filter),
#       do: query


defp handle_reference_id_filter(query, %{
  "reference_number_filter" => reference_number_filter
  }) do
  where(
  query,
  [l, uS, pR, uR],
  fragment("lower(?) LIKE lower(?)", l.reference_no, ^"%#{reference_number_filter}%")
  )
end

defp handle_reference_id_filter(query, %{
    "reference_number_filter" => reference_number_filter
  })
  when reference_number_filter == "" or is_nil(reference_number_filter),
  do: query


defp handle_loan_date_of_application_filter(query, %{
  "applied_on_from" => applied_on_from,
  "applied_on_to" => applied_on_to
})
when byte_size(applied_on_from) > 0 and byte_size(applied_on_to) > 0 do
  query
  |> where(
  [l, uB, p, cO],
  fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.application_date, ^applied_on_from) and
    fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.application_date, ^applied_on_to)
  )
end

defp handle_loan_date_of_application_filter(query, _params), do: query





defp handle_loan_date_of_disbursement_filter(query, %{
        "disbursement_from" => disbursement_from,
        "disbursement_to" => disbursement_to
      })
    when byte_size(disbursement_from) > 0 and byte_size(disbursement_to) > 0 do
    query
    |> where(
      [l, uS, pR, uR],
      fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^disbursement_from) and
        fragment("? <= TO_DATE(?, 'YYYY/MM/DD')", l.disbursedon_date, ^disbursement_to)
    )
 end

 defp handle_loan_date_of_disbursement_filter(query, _params), do: query




# -------------------------------------------------------------------------------------------------------
  # Loanmanagementsystem.Operations.loan_aging_report_miz(nil, 1, 10)

  def loan_aging_report_miz(search_params, page, size) do
    Loans
    |> handle_loan_aging_report_filter(search_params)
    |> order_by([l, uB, p,cO], desc: l.inserted_at)
    |> compose_loan_aging_report_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def loan_aging_report_miz(_source, search_params) do
    Loans
    |> handle_loan_aging_report_filter(search_params)
    |> order_by([l, uB, p,cO], desc: l.inserted_at)
    |> compose_loan_aging_report_miz()
  end

  defp compose_loan_aging_report_miz(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
    |> where([l, uB, p, cO], is_nil(l.disbursedon_date) != true)
    |> select([l, uB, p, cO], %{
      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      customer_phone_number:
        fragment(
          "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      company_id: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: l.interest_amount,
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      tenor: l.tenor,
      end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      start_date: l.disbursedon_date,
      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      number_of_months: l.eod_count,
      accrued_no_days: l.accrued_no_days,
      company_client:
      fragment(
        "select \"companyName\" from tbl_company where \"id\" = ?",
        l.company_id
      ),
      customer_represe: fragment("select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"id\" = ?", cO.user_bio_id),
    })
  end


  defp handle_loan_aging_report_filter(query, %{"isearch" => search_term} = search_params)
       when search_term == "" or is_nil(search_term) do
    query
    |> handle_loan_created_date_filter(search_params)
    |> handle_fname_filter(search_params)
    |> handle_lname_filter(search_params)
    |> handle_loan_application_type_filter(search_params)
    |> handle_requested_amount_filter(search_params)
    |> handle_loan_disbursement_date_filter(search_params)
    |> handle_loan_application_date_filter(search_params)
    |> handle_filter_by_days_miz_date_filter(search_params)
    # |> handle_reference_number_filter(search_params)
    # |> handle_company_registration_number_filter(search_params)
    # |> handle_loan_status_type_filter(search_params)
    |> handle_contact_person_filter(search_params)
  end


  defp handle_contact_person_filter(query, %{"contact_person_number_filter" => contact_person_number_filter}) do
    where(
      query,
        [l, uB, p, cO],
        fragment("lower(?) LIKE lower(?)", uB.mobileNumber, ^"%#{contact_person_number_filter}%")
    )
  end

  # defp handle_contact_person_filter(query, %{"contact_person_number_filter" => contact_person_number_filter})
  #   when contact_person_number_filter == "" or is_nil(contact_person_number_filter),
  #   do: query


  #   defp handle_filter_by_days_miz_date_filter(query, %{"filter_by_number_of_days_filter" => filter_by_number_of_days_filter})
  #   when byte_size(filter_by_number_of_days_filter) > 0  do
  #     today = Date.utc_today
  #     given_date = Timex.shift(today, days: String.to_integer(filter_by_number_of_days_filter))

  #     case Date.compare(given_date, Date.utc_today()) do
  #       :lt ->
  #         given_date = Date.to_string(given_date)
  #       query
  #       |> where([l, uB, p, cO], fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.inserted_at, ^given_date))
  #       )
  #       :gt ->
  #         given_date = Date.to_string(given_date)
  #         query
  #         |> where([l, uB, p, cO], fragment("CAST(? AS DATE) >= ?", l.inserted_at, type(^given_date, :date)))

  #     end
  # end

  defp handle_filter_by_days_miz_date_filter(query, %{"filter_by_number_of_days_filter" => filter_by_number_of_days_filter})

     when byte_size(filter_by_number_of_days_filter) > 0 do
      today = Date.utc_today
      # given_date = Timex.shift(today, days: String.to_integer(filter_by_number_of_days_filter))
      given_date = String.to_integer(filter_by_number_of_days_filter)
      # CHeck if the given value from params is a negative number
      case is_negative(given_date) do
        true ->
          given_date = abs(given_date)
            query
            |> where(
              [l, uB, p, cO],
              fragment("DATE_PART('day', NOW() - ?::timestamp) < ?", l.application_date, ^given_date)

            )

        false ->
          # runs this if given figure is positive number
          query
          |> where(
            [l, uB, p, cO],
            fragment("DATE_PART('day', NOW() - ?::timestamp) > ?", l.application_date, ^given_date)

          )

      end
  end


  def is_negative(number) when number < 0 do
    true
  end
  def is_negative(_), do: false

#   defp handle_filter_by_days_miz_date_filter(query, %{"filter_by_number_of_days_filter" => filter_by_number_of_days_filter})
#   when byte_size(filter_by_number_of_days_filter) > 0  do
#     today = Date.utc_today
#     given_date = Timex.shift(today, days: String.to_integer(filter_by_number_of_days_filter))

#     case Date.compare(given_date, Date.utc_today()) do

#       :lt ->
#         given_date = Date.to_string(given_date)
#         IO.inspect(given_date, label: "^^^^^^ CHeck ^^^^^")

#       :eq ->
#         IO.inspect(given_date, label: "^^^^^^ CHeck eq ^^^^^")
#         # Handle the case when given_date is equal to today (days = 0)
#         query
#         |> where([l, uB, p, cO], fragment("CAST(? AS DATE) = CAST(? AS DATE)", l.application_date, ^given_date))

#       :gt ->
#         IO.inspect(given_date, label: "^^^^^^ CHeck gt ^^^^^")
#         # Filter days greater than 120
#         query
#         |> where([l, uB, p, cO], fragment("CAST(? AS DATE) > CAST(? AS DATE)", l.application_date, ^given_date))

#       :lt ->
#         # Filter days less than 120
#         IO.inspect(given_date, label: "^^^^^^ CHeck it 22 ^^^^^")
#         query
#         |> where([l, uB, p, cO], fragment("CAST(? AS DATE) < CAST(? AS DATE)", l.application_date, ^given_date))

#     end
# end


defp handle_filter_by_days_miz_date_filter(query, _params), do: query

  # --------------------------------------- Loan Application lookup
  # Loanmanagementsystem.Operations.user_logs_report_listing(nil, 1, 10)
  def user_logs_report_listing(search_params, page, size) do
    Loanmanagementsystem.Logs.UserLogs
    |> join(:left, [lO], uS in UserBioData, on: lO.user_id == uS.userId)
    # |> handle_loan_filter(search_params)
    |> order_by([lO, uS], desc: lO.inserted_at)
    |> user_logs_report_listing_listing()
    |> Repo.paginate(page: page, page_size: size)
  end

  def user_logs_report_listing(_source, search_params) do
    Loanmanagementsystem.Logs.UserLogs
    |> join(:left, [lO], uS in UserBioData, on: lO.user_id == uS.userId)
    # |> handle_loan_filter(search_params)
    |> order_by([lO, uS], desc: lO.inserted_at)
    |> user_logs_report_listing_listing()
  end

  defp user_logs_report_listing_listing(query) do
    query
    |> select(
      [lO, uS],
      %{
        name:
          fragment(
            "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
            lO.user_id
          ),
        activity: lO.activity,
        log_date: lO.inserted_at,
        user_id: lO.user_id,
        id: lO.id
      }
    )
  end

    def loan__pipeline_report_miz(search_params, page, size) do
      Loans
      # |> handle_loan_credit_assessment_report_filter(search_params)
      |> order_by([l, uB, p, cO], desc: l.inserted_at)
      |> compose_loan_pipeline_report_miz()
      |> Repo.paginate(page: page, page_size: size)
    end

    def loan__pipeline_report_miz(_source, search_params) do
      Loans
      # |> handle_loan_credit_assessment_report_filter(search_params)
      |> order_by([l, uB, p, cO], desc: l.inserted_at)
      |> compose_loan_pipeline_report_miz()
    end

    defp compose_loan_pipeline_report_miz(query) do
      query
      |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
      |> join(:left, [l], p in Product, on: l.product_id == p.id)
      |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
      |> where([l, uB, p, cO], is_nil(l.application_date) != true and (l.status != "DISBURSED" or l.status != "PENDING_CREDIT_ANALYST_ASSESSMENT"))
      |> select([l, uB, p, cO], %{
        loan_id: l.id,
        customer_names:
          fragment(
            "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
            l.customer_id
          ),
        customer_phone_number:
          fragment(
            "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
            l.customer_id
          ),
        company_client:
          fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),

        rejectedon_userid: l.rejectedon_userid,
        approvedon_date: l.approvedon_date,
        application_date: l.application_date,
        loan_type: l.loan_type,
        principal_amount: l.principal_amount,
        requested_amount: l.requested_amount,
        disbursedon_date: l.disbursedon_date,
        account_no: l.account_no,
        principal_amount_proposed: l.principal_amount_proposed,
        expected_disbursedon_date: l.expected_disbursedon_date,
        loan_identity_number: l.loan_identity_number,
        loan_status: l.loan_status,
        status: fragment("replace(?, '_', ' ')", l.status),
        receipient_number: l.receipient_number,
        reference_no: l.reference_no,
        applied_date: l.application_date,
        userId: l.customer_id,
        interest: p.interest,
        product_name: p.name,
        periodType: p.periodType,
        productType: p.productType,
        product_status: p.status,
        expected_maturity_date: l.expected_maturity_date,
        total_repaid: l.total_repaid,
        oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
        company_id: l.offtakerID,
        closedon_date: l.closedon_date,
        interest_amount: l.interest_amount,
        balance: l.balance,
        total_repayment_derived: l.total_repayment_derived,
        arrangement_fee: l.arrangement_fee,
        finance_cost: l.finance_cost,
        tenor: l.tenor,
        end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
        start_date: l.disbursedon_date,
        daily_accrued_interest: l.daily_accrued_interest,
        daily_accrued_finance_cost: l.daily_accrued_finance_cost,
        # total_balance_acrued: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),
        total_balance_acrued: l.balance,
        number_of_months: l.eod_count,
        accrued_no_days: l.accrued_no_days

      })
    end


    # Loanmanagementsystem.Operations.disbursed_loans_by_funder_report_miz(nil, 1, 10)


    def disbursed_loans_by_funder_report_miz(search_params, page, size) do
      Loans
      |> handle_all_dibursed_loans_report_filter(search_params)
      |> order_by([l, uB, p, cO], desc: l.inserted_at)
      |> compose_disbursed_loans_by_funder_report_miz()
      |> Repo.paginate(page: page, page_size: size)
    end

    def disbursed_loans_by_funder_report_miz(_source, search_params) do
      Loans
      |> handle_all_dibursed_loans_report_filter(search_params)
      |> order_by([l, uB, p, cO], desc: l.inserted_at)
      |> compose_disbursed_loans_by_funder_report_miz()
    end

    defp compose_disbursed_loans_by_funder_report_miz(query) do
      query
      |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
      |> join(:left, [l], p in Product, on: l.product_id == p.id)
      |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
      |> join(:left, [l, uB, p], funder in Loanmanagementsystem.Loan.Loan_funder, on: l.funderID == funder.funderID)
      |> join(:left, [l, uB, p, funder], funder_bio in UserBioData, on: l.funderID == funder_bio.userId)
      |> where([l, uB, p, cO, funder, funder_bio], is_nil(l.application_date) != true and l.loan_status == "DISBURSED")
      |> group_by([l, uB, p, cO, funder, funder_bio], [])
      |> select([l, uB, p, cO, funder, funder_bio], %{
        loan_id: l.id,
        funder_names:
          fragment(
            "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
            funder.funderID
          ),

        funder_as_company:
            fragment("select \"companyName\" from tbl_company where \"user_bio_id\" = ?", funder_bio.id),

        customer_phone_number:
          fragment(
            "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
            l.customer_id
          ),
          customer_names:
          fragment(
            "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
            l.customer_id
          ),
        company_client:
          fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),
          company_client:
          fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),

         user_bio_id: uB.id,

        rejectedon_userid: l.rejectedon_userid,
        approvedon_date: l.approvedon_date,
        application_date: l.application_date,
        loan_type: l.loan_type,
        principal_amount: l.principal_amount,
        requested_amount: l.requested_amount,
        disbursedon_date: l.disbursedon_date,
        repayment_amount: l.repayment_amount,
        account_no: l.account_no,
        principal_amount_proposed: l.principal_amount_proposed,
        expected_disbursedon_date: l.expected_disbursedon_date,
        loan_identity_number: l.loan_identity_number,
        loan_status: l.loan_status,
        status: l.status,
        receipient_number: l.receipient_number,
        reference_no: l.reference_no,
        applied_date: l.application_date,
        userId: l.customer_id,
        interest: p.interest,
        product_name: p.name,
        periodType: p.periodType,
        productType: p.productType,
        product_status: p.status,
        expected_maturity_date: l.expected_maturity_date,
        total_repaid: l.total_repaid,
        oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
        company_id: l.offtakerID,
        closedon_date: l.closedon_date,
        interest_amount: l.interest_amount,
        balance: l.balance,
        total_repayment_derived: l.total_repayment_derived,
        arrangement_fee: l.arrangement_fee,
        finance_cost: l.finance_cost,
        tenor: l.tenor,
        end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
        start_date: l.disbursedon_date,
        daily_accrued_interest: l.daily_accrued_interest,
        daily_accrued_finance_cost: l.daily_accrued_finance_cost,
        # total_balance_acrued: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),
        total_balance_acrued: l.balance,
        number_of_months: l.eod_count,
        accrued_no_days: l.accrued_no_days,

      })
    end



  defp handle_all_dibursed_loans_report_filter(query, %{"isearch" => search_term} = search_params)
    when search_term == "" or is_nil(search_term) do
      query
      # |> handle_loan_created_date_filter(search_params)
      # |> handle_fname_filter(search_params)
      # |> handle_lname_filter(search_params)
      # |> handle_loan_application_type_filter(search_params)
      # |> handle_requested_amount_filter(search_params)
      # |> handle_loan_disbursement_date_filter(search_params)
      # |> handle_loan_application_date_filter(search_params)
      # |> handle_filter_by_days_miz_date_filter(search_params)
      # |> handle_reference_number_filter(search_params)
      # |> handle_company_registration_number_filter(search_params)
      # |> handle_loan_status_type_filter(search_params)
      # |> handle_contact_person_filter(search_params)
      |> handle_disbursed_by_funder_filter(search_params)
      |> handle_disbursed_by_offtaker_filter(search_params)
  end

  defp handle_disbursed_by_funder_filter(query, %{
      "disbursed_funder_id_filter" => disbursed_funder_id_filter
      }) do
      where(
      query,
      [l, uB, p, cO, funder, funder_bio],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        funder.funderID,
        ^"%#{disbursed_funder_id_filter}%"
      )
    )
  end

  defp handle_disbursed_by_funder_filter(query, %{
      "disbursed_funder_id_filter" => disbursed_funder_id_filter
    })
    when disbursed_funder_id_filter == "" or is_nil(disbursed_funder_id_filter),
    do: query


    defp handle_disbursed_by_offtaker_filter(query, %{
      "disbursed_offtaker_id_filter" => disbursed_offtaker_id_filter
      }) do
      where(
      query,
      [l, uB, p, cO, funder, funder_bio],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        l.offtakerID,
        ^"%#{disbursed_offtaker_id_filter}%"
      )
    )
  end

  defp handle_disbursed_by_offtaker_filter(query, %{
      "disbursed_offtaker_id_filter" => disbursed_offtaker_id_filter
    })
    when disbursed_offtaker_id_filter == "" or is_nil(disbursed_offtaker_id_filter),
    do: query

    # Loanmanagementsystem.Operations.get_collateral_loan_client_docs(93, 23, "Original Collateral Document & Letter Of Sale")

    def get_collateral_loan_client_docs(loan_id, fileName) do
      IO.inspect(fileName, label: "fileName here")
      case fileName do
          "Original Collateral Document" ->

                file_name = "Original Collateral Document & Letter Of Sale"
                Loan_application_documents
                |> where([idvdoc], idvdoc.loan_id == ^loan_id and idvdoc.fileName == ^file_name)
                |> select([idvdoc], %{
                  id: idvdoc.id,
                  docName: idvdoc.doc_name,
                  docPath: idvdoc.path,
                  docStatus: idvdoc.status,
                  docType: idvdoc.doc_type,
                  loan_id: idvdoc.loan_id,
                  fileName: idvdoc.fileName,
                  customer_id: idvdoc.customer_id,
                  inserted_at: idvdoc.inserted_at
                })
                |> Repo.all()

          "Post-dated cheques" ->

                  file_name = "Post-dated cheques"
                  Loan_application_documents
                  |> where([idvdoc], idvdoc.loan_id == ^loan_id and idvdoc.fileName == ^file_name)
                  |> select([idvdoc], %{
                    id: idvdoc.id,
                    docName: idvdoc.doc_name,
                    docPath: idvdoc.path,
                    docStatus: idvdoc.status,
                    docType: idvdoc.doc_type,
                    loan_id: idvdoc.loan_id,
                    fileName: idvdoc.fileName,
                    customer_id: idvdoc.customer_id,
                    inserted_at: idvdoc.inserted_at
                  })
                  |> Repo.all()

          _ ->

              file_name = "Original Collateral Document & Letter Of Sale"
              Loan_application_documents
              |> where([idvdoc], idvdoc.loan_id == ^loan_id and idvdoc.fileName == ^file_name)
              |> select([idvdoc], %{
                id: idvdoc.id,
                docName: idvdoc.doc_name,
                docPath: idvdoc.path,
                docStatus: idvdoc.status,
                docType: idvdoc.doc_type,
                loan_id: idvdoc.loan_id,
                fileName: idvdoc.fileName,
                customer_id: idvdoc.customer_id,
                inserted_at: idvdoc.inserted_at
              })
              |> Repo.all()
      end
    end


    defp handle_loan_book_loan_type_filter(query, %{"loan_type_filter" => loan_type_filter}) do
      where(
        query,
        [l, uB, p, loan_c, funder_bio],
        fragment("lower(?) LIKE lower(?)", p.name, ^"%#{loan_type_filter}%")
      )
    end

    defp handle_loan_book_loan_type_filter(query, %{"loan_type_filter" => loan_type_filter})
         when loan_type_filter == "" or is_nil(loan_type_filter),
         do: query

    defp handle_loan_book_requested_amount_filter(query, %{
            "requested_amount_filter" => requested_amount_filter
          }) do
      where(
        query,
        [l, uB, p, loan_c, funder_bio],
        fragment(
          "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
          l.principal_amount,
          ^"%#{requested_amount_filter}%"
        )
      )
    end

    defp handle_loan_book_requested_amount_filter(query, %{
        "requested_amount_filter" => requested_amount_filter
      })
      when requested_amount_filter == "" or is_nil(requested_amount_filter),
      do: query


      defp handle_loan_book_loan_status_filter(query, %{"loan_status_filter" => loan_status_filter}) do
        where(
          query,
          [l, uB, p, loan_c, funder_bio],
          fragment("lower(?) LIKE lower(?)", l.status, ^"%#{loan_status_filter}%")
        )
      end

      defp handle_loan_book_loan_status_filter(query, %{"loan_status_filter" => loan_status_filter})
           when loan_status_filter == "" or is_nil(loan_status_filter),
           do: query


      defp handle_loan_book_loan_outstanding_amount_filter(query, %{
            "outstanding_amount_filter" => outstanding_amount_filter
            }) do
        where(
          query,
          [l, uB, p, loan_c, funder_bio],
          fragment(
            "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
            l.balance,
            ^"%#{outstanding_amount_filter}%"
          )
        )
      end

    defp handle_loan_book_loan_outstanding_amount_filter(query, %{
        "outstanding_amount_filter" => outstanding_amount_filter
      })
      when outstanding_amount_filter == "" or is_nil(outstanding_amount_filter),
      do: query




    # Loanmanagementsystem.Operations.loan_per_offtaker_report_miz(nil, 1, 10)
    def loan_per_offtaker_report_miz(search_params, page, size) do
      Loans
      |> handle_loan_per_offtaker_report_filter(search_params)
      |> compose_loan_per_offtaker_report_miz()
      |> order_by([l, uB, p, cO], desc: l.disbursedon_date)
      |> Repo.paginate(page: page, page_size: size)
    end

    def loan_per_offtaker_report_miz(_source, search_params) do
      Loans
      |> handle_loan_per_offtaker_report_filter(search_params)
      |> compose_loan_per_offtaker_report_miz()
      |> order_by([l, uB, p, cO], desc: l.disbursedon_date)
    end




    defp compose_loan_per_offtaker_report_miz(query) do
      query
      |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
      |> join(:left, [l], p in Product, on: l.product_id == p.id)
      |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
      |> where([l, uB, p, cO], is_nil(l.offtakerID) != true and l.status == "DISBURSED")
      |> select([l, uB, p, cO], %{
        loan_id: l.id,
        customer_names:
          fragment(
            "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
            l.customer_id
          ),
        customer_phone_number:
          fragment(
            "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
            l.customer_id
          ),
        company_client:
          fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),

        rejectedon_userid: l.rejectedon_userid,
        approvedon_date: l.approvedon_date,
        loan_type: l.loan_type,
        principal_amount: l.principal_amount,
        requested_amount: l.requested_amount,
        disbursedon_date: l.disbursedon_date,
        account_no: l.account_no,
        principal_amount_proposed: l.principal_amount_proposed,
        expected_disbursedon_date: l.expected_disbursedon_date,
        loan_identity_number: l.loan_identity_number,
        loan_status: l.loan_status,
        status: l.status,
        receipient_number: l.receipient_number,
        reference_no: l.reference_no,
        applied_date: l.application_date,
        userId: l.customer_id,
        interest: p.interest,
        product_name: p.name,
        periodType: p.periodType,
        productType: p.productType,
        product_status: p.status,
        expected_maturity_date: l.expected_maturity_date,
        total_repaid: l.total_repaid,
        company_id: l.offtakerID,
        closedon_date: l.closedon_date,
        interest_amount: l.interest_amount,
        balance: l.balance,
        total_repayment_derived: l.total_repayment_derived,
        arrangement_fee: l.arrangement_fee,
        finance_cost: l.finance_cost,
        tenor: l.tenor,
        invoice_value: fragment("select max(\"invoiceValue\") from tbl_loan_invoice where \"loanID\" = ?",
          l.id
        ),
        invoice_no: fragment(
          "select \"invoiceNo\" from tbl_loan_invoice where \"loanID\" = ? ORDER BY inserted_at DESC LIMIT 1",
          l.id
        ),
        invoice_date: fragment(
          "select max(\"dateOfIssue\") from tbl_loan_invoice where \"id\" = ?",
          l.id
        ),
        offtaker_id: l.offtakerID,
        offtaker_name: fragment(
          "select \"companyName\" from tbl_company where \"id\" = ?",
          l.offtakerID
        ),
        offtaker_rep_name: fragment(
          "SELECT CONCAT(\"firstName\", concat(' ', \"lastName\")) FROM tbl_user_bio_data AS ub, tbl_company AS c WHERE \"userId\" = ? AND c.id = ?",
          l.customer_id, l.offtakerID
        ),
        currency_code: l.currency_code,

        order_invoice_value: fragment("select max(\"order_value\") from tbl_order_finace_loan_invoice where \"loan_id\" = ?", l.id),

        order_finance_number: fragment("select max(\"order_number\") from tbl_order_finace_loan_invoice where \"loan_id\" = ?", l.id),

        order_invoice_date: fragment("select max(\"order_date\") from tbl_order_finace_loan_invoice where \"loan_id\" = ?", l.id)
      })
    end



    defp handle_loan_per_offtaker_report_filter(query, %{"isearch" => search_term} = search_params)
    when search_term == "" or is_nil(search_term) do
      query
      |> handle_first_name_per_offtaker(search_params)
      |> handle_last_name_per_offtaker(search_params)
      |> handle_loan_per_offtaker_by_offtaker_filter(search_params)
      |> handle_requested_amount_per_offtaker_filter(search_params)
      |> handle_loan_type_per_offtaker_filter(search_params)
      |> handle_contact_person_per_offtaker_filter(search_params)
      |> handle_filter_by_days_per_offtaker_filter(search_params)

  end



  defp handle_loan_per_offtaker_by_offtaker_filter(query, %{
      "loan_per_offtaker_offtaker_id_filter" => loan_per_offtaker_offtaker_id_filter
      }) do
      where(
      query,
      [l, uB, p, cO],
      fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        l.offtakerID,
        ^"%#{loan_per_offtaker_offtaker_id_filter}%"
      )
    )
  end

  defp handle_loan_per_offtaker_by_offtaker_filter(query, %{
      "loan_per_offtaker_offtaker_id_filter" => loan_per_offtaker_offtaker_id_filter
    })
    when loan_per_offtaker_offtaker_id_filter == "" or is_nil(loan_per_offtaker_offtaker_id_filter),
  do: query

  defp handle_first_name_per_offtaker(query, %{"first_name_per_offtaker_filter" => first_name_per_offtaker_filter}) do
    where(
      query,
      [l, uB, p, cO],
      fragment("lower(?) LIKE lower(?)", uB.firstName, ^"%#{first_name_per_offtaker_filter}%")
    )
  end

  defp handle_first_name_per_offtaker(query, %{"first_name_per_offtaker_filter" => first_name_per_offtaker_filter})
       when first_name_per_offtaker_filter == "" or is_nil(first_name_per_offtaker_filter),
       do: query

  defp handle_last_name_per_offtaker(query, %{"last_name_per_offtaker_filter" => last_name_per_offtaker_filter}) do
    where(
      query,
      [l, uB, p, cO],
      fragment("lower(?) LIKE lower(?)", uB.lastName, ^"%#{last_name_per_offtaker_filter}%")
    )
  end

  defp handle_last_name_per_offtaker(query, %{"last_name_per_offtaker_filter" => last_name_per_offtaker_filter})
       when last_name_per_offtaker_filter == "" or is_nil(last_name_per_offtaker_filter),
       do: query



  defp handle_requested_amount_per_offtaker_filter(query, %{
        "requested_amount_per_offtaker_filter" => requested_amount_per_offtaker_filter
          }) do
      where(
        query,
        [l, uB, p, cO],
        fragment(
        "lower(cast((?) as text)) LIKE lower(cast((?) as text))",
        l.requested_amount,
        ^"%#{requested_amount_per_offtaker_filter}%"
        )
      )
  end

  defp handle_requested_amount_per_offtaker_filter(query, %{
      "requested_amount_per_offtaker_filter" => requested_amount_per_offtaker_filter
    })
    when requested_amount_per_offtaker_filter == "" or is_nil(requested_amount_per_offtaker_filter),
    do: query


    defp handle_loan_type_per_offtaker_filter(query, %{"loan_type_per_offtaker_filter" => loan_type_per_offtaker_filter}) do
			where(
			  query,
			  [l, uB, p, cO],
			  fragment("lower(?) LIKE lower(?)", l.loan_type, ^"%#{loan_type_per_offtaker_filter}%")
			)
		 end

		defp handle_loan_type_per_offtaker_filter(query, %{"loan_type_per_offtaker_filter" => loan_type_per_offtaker_filter})
		   when loan_type_per_offtaker_filter == "" or is_nil(loan_type_per_offtaker_filter),
		   do: query


    defp handle_contact_person_per_offtaker_filter(query, %{"contact_person_number_per_offtaker_filter" => contact_person_number_per_offtaker_filter}) do
      where(
        query,
          [l, uB, p, cO],
          fragment("lower(?) LIKE lower(?)", uB.mobileNumber, ^"%#{contact_person_number_per_offtaker_filter}%")
      )
    end

    defp handle_contact_person_per_offtaker_filter(query, %{"contact_person_number_per_offtaker_filter" => contact_person_number_per_offtaker_filter})
      when contact_person_number_per_offtaker_filter == "" or is_nil(contact_person_number_per_offtaker_filter),
        do: query


      defp handle_filter_by_days_per_offtaker_filter(query, %{"filter_by_number_of_days_per_offtaker_filter" => filter_by_number_of_days_per_offtaker_filter})

        when byte_size(filter_by_number_of_days_per_offtaker_filter) > 0 do
         today = Date.utc_today
         # given_date = Timex.shift(today, days: String.to_integer(filter_by_number_of_days_per_offtaker_filter))
         given_date = String.to_integer(filter_by_number_of_days_per_offtaker_filter)
         # CHeck if the given value from params is a negative number
         case is_negative(given_date) do
         true ->
           given_date = abs(given_date)
           query
           |> where(
             [l, uB, p, cO],
             fragment("DATE_PART('day', NOW() - ?::timestamp) < ?", l.application_date, ^given_date)

           )

         false ->
           # runs this if given figure is positive number
           query
           |> where(
           [l, uB, p, cO],
           fragment("DATE_PART('day', NOW() - ?::timestamp) > ?", l.application_date, ^given_date)

           )

         end
     end

     defp handle_filter_by_days_per_offtaker_filter(query, _params), do: query


  # Loanmanagementsystem.Operations.last_five_disbursed_loans_miz(nil, 1, 10)

  def last_five_disbursed_loans_miz(search_params, page, size) do
    Loans
    |> handle_last_five_disbursed_loans_miz(search_params)
    |> order_by([l, u, prod], desc: l.inserted_at)
    |> compose_last_five_disbursed_loans()
    |> Repo.paginate(page: page, page_size: size)
  end

  def last_five_disbursed_loans_miz(_source, search_params) do
    Loans
    |> handle_last_five_disbursed_loans_miz(search_params)
    |> order_by([l, u, prod], desc: l.inserted_at)
    |> compose_last_five_disbursed_loans()
  end

  defp compose_last_five_disbursed_loans(query) do
    query
    |> join(:left, [l], u in Loanmanagementsystem.Accounts.UserBioData, on: u.userId == l.customer_id)
    |> join(:left, [l, u], prod in Loanmanagementsystem.Products.Product, on: prod.id == l.product_id)
    |> where([l, u, prod], (l.loan_status == "DISBURSED"))
    |> select([l, u, prod], %{
      principal_amount: l.principal_amount,
      customer_name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", u.firstName, u.lastName, u.otherName),
      product_name: prod.name,
      interest_amount: l.interest_amount,
      total_expected_repayment: l.total_expected_repayment_derived,
      disbursedon_date: l.disbursedon_date,
      application_date: l.application_date,
      loan_status: l.loan_status,
      start_date: l.disbursedon_date,
      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      number_of_months: l.eod_count,
      total_balance_acrued: l.balance,
      total_amount_repaid: l.total_repaid,
      accrued_no_days: l.accrued_no_days,
      company_name: fragment("SELECT \"companyName\" FROM tbl_company WHERE id = ?", l.company_id)
    })
  end


defp handle_last_five_disbursed_loans_miz(query, %{"isearch" => search_term} = search_params)
  when search_term == "" or is_nil(search_term) do
query
|> handle_loan_created_date_filter(search_params)
|> handle_fname_filter(search_params)
|> handle_lname_filter(search_params)
|> handle_loan_application_type_filter(search_params)
|> handle_requested_amount_filter(search_params)
|> handle_loan_disbursement_date_filter(search_params)
|> handle_loan_application_date_filter(search_params)
|> handle_filter_by_days_miz_date_filter(search_params)
# |> handle_reference_number_filter(search_params)
# |> handle_company_registration_number_filter(search_params)
# |> handle_loan_status_type_filter(search_params)
# |> handle_contact_person_filter(search_params)
end





 # Loanmanagementsystem.Operations.get_active_loans_by_product_miz(nil, 1, 10)

 def get_active_loans_by_product_miz(search_params, page, size) do
  Loans

  # |> order_by([l, uB, p, cO], desc: l.inserted_at)
  |> compose_get_active_loans_by_product()
  |> Repo.paginate(page: page, page_size: size)
end

def get_active_loans_by_product_miz(_source, search_params) do
  Loans

  # |> order_by([l, uB, p, cO], desc: l.inserted_at)
  |> compose_get_active_loans_by_product()
end

defp compose_get_active_loans_by_product(query) do
  query
  |> join(:left, [l], prod in Loanmanagementsystem.Products.Product, on: l.product_id == prod.id)
  |> group_by([l, prod], [prod.name])
  |> where([l, prod], (l.loan_status == "DISBURSED"))
  |> select([l, prod], %{
    product_name: prod.name,
    loan_count: count(l.id),
    interest_amount: sum(l.interest_amount),
    principal_amount: sum(l.principal_amount),
    total_expected_repayment: sum(l.total_expected_repayment_derived),
    daily_accrued_interest: sum(l.daily_accrued_interest),
    daily_accrued_finance_cost: sum(l.daily_accrued_finance_cost),
    total_balance_acrued: sum(l.balance),
    total_repaid: sum(l.total_repaid),


  })

end



alias Loanmanagementsystem.Transactions.Loan_transactions


 # Loanmanagementsystem.Operations.get_active_loans_by_product()

  def get_active_loans_by_product() do
    Loans
    |> join(:left, [lo], prod in Loanmanagementsystem.Products.Product, on: lo.product_id == prod.id)
    |> group_by([lo, prod], [prod.name])
    |> where([lo, prod], (lo.loan_status == "DISBURSED"))
    |> select([lo, prod], %{
      product_name: prod.name,
      loan_count: count(lo.id),
      interest_amount: sum(lo.interest_amount),
      principal_amount: sum(lo.principal_amount),
      total_expected_repayment: sum(lo.total_expected_repayment_derived),
    })
    |> Repo.all()
  end

# Loanmanagementsystem.Operations.get_corperate_customer_statement("156")

  def get_corperate_customer_statement(client_loan_id) do
    Loan_transactions
    |> join(:left, [txn], lo in Loans, on: txn.loan_id == lo.id)
    |> join(:left, [txn, lo], uB in UserBioData, on: txn.customer_id == uB.userId)
    |> join(:left, [txn, lo, uB], p in Product, on: txn.product_id == p.id)
    |> join(:left, [txn, lo, uB, p], cO in Company, on: lo.company_id == cO.id)
    |> where([txn, lo, uB, p, cO], is_nil(lo.company_id) != true and txn.loan_id == ^client_loan_id)
    |> order_by([txn, lo, uB, p, cO], asc: txn.inserted_at)
    |> select([txn, lo, uB, p, cO], %{
            loan_id: txn.loan_id,
            rep_id: uB.userId,
            customer_names:
              fragment(
                "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            customer_phone_number:
              fragment(
                "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            customer_reg_number:
              fragment(
                "select \"meansOfIdentificationNumber\" from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            company_client:
              fragment(
                "select \"companyName\" from tbl_company where \"id\" = ?",
                lo.company_id
              ),

              total_interest_accrued: txn.total_interest_accrued,
              principal_amount: txn.principal_amount,
              repaid_amount: txn.repaid_amount,
              productType: p.productType,
              accrued_no_days: txn.days_accrued,
              transaction_date: txn.transaction_date,
              principal_amount: txn.principal_amount,
              total_finance_cost_accrued: txn.total_finance_cost_accrued,
              outstanding_balance: txn.outstanding_balance,
              daily_accrued_interest: lo.daily_accrued_interest,
              daily_accrued_finance_cost: lo.daily_accrued_finance_cost,
              total_interest: (lo.daily_accrued_interest + lo.daily_accrued_finance_cost),
              calculated_balance: (txn.principal_amount + txn.total_interest_accrued + txn.total_finance_cost_accrued),

      })
    |> Repo.all()
  end


  def get_corperate_customer_statement_accrues(client_loan_id) do
    Loans
      |> join(:left, [lo], uB in UserBioData, on: lo.customer_id == uB.userId)
      |> join(:left, [lo, uB], p in Product, on: lo.product_id == p.id)
      |> join(:left, [lo, uB, p], cO in Company, on: lo.company_id == cO.id)
      |> where([lo, uB, p, cO], is_nil(lo.company_id) != true and lo.id == ^client_loan_id)
      |> select([lo, uB, p, cO], %{
            rep_id: uB.userId,
            principal_amount: lo.principal_amount,
            repaid_amount: lo.total_repaid,
            productType: p.productType,
            accrued_no_days: lo.accrued_no_days,
            outstanding_balance: lo.balance,
            daily_accrued_interest: lo.daily_accrued_interest,
            daily_accrued_finance_cost: lo.daily_accrued_finance_cost,
            total_interest: (lo.daily_accrued_interest + lo.daily_accrued_finance_cost),
            calculated_balance: (lo.principal_amount + lo.daily_accrued_interest + lo.daily_accrued_finance_cost),

        })
      |> Repo.all()
  end



  def get_corperate_customer_details_for_statement(client_loan_id) do
    Loan_transactions
    |> join(:left, [txn], lo in Loans, on: txn.loan_id == lo.id)
    |> join(:left, [txn, lo], uB in UserBioData, on: txn.customer_id == uB.userId)
    |> join(:left, [txn, lo, uB], address in Loanmanagementsystem.Accounts.Address_Details, on: lo.customer_id == address.userId)
    |> join(:left, [txn, lo, uB, address], p in Product, on: txn.product_id == p.id)
    |> join(:left, [txn, lo, uB, addres, p], cO in Company, on: lo.company_id == cO.id)
    |> where([txn, lo, uB, addres, p, cO], is_nil(lo.company_id) != true and txn.loan_id == ^client_loan_id)
    |> select([txn, lo, uB, addres, p, cO], %{
            loan_id: txn.loan_id,
            rep_id: uB.userId,
            rep_address: fragment("concat(?, concat(', ', ?))", addres.street_name, addres.area),
            customer_names:
              fragment(
                "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            customer_phone_number:
              fragment(
                "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            customer_reg_number:
              fragment(
                "select \"meansOfIdentificationNumber\" from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            company_client:
              fragment(
                "select \"companyName\" from tbl_company where \"id\" = ?",
                lo.company_id
              ),

              total_interest_accrued: txn.total_interest_accrued,
              principal_amount: txn.principal_amount,
              repaid_amount: txn.repaid_amount,

      })
      |> limit(1)
       |> Repo.one()
  end



    def get_corperate_customer_totals_for_statement(client_loan_id) do
        Loan_transactions
        |> join(:left, [txn], lo in Loans, on: txn.loan_id == lo.id)
        |> where([txn, lo], txn.loan_id == ^client_loan_id)
        |> group_by([txn, lo], [txn.loan_id])
        |> select([txn, lo], %{
            total_repaid_amount: sum(txn.repaid_amount),
            txn_principal_amount: fragment("select \"principal_amount\" from tbl_transactions where \"loan_id\" = ? ORDER BY inserted_at DESC LIMIT 1", txn.loan_id),

          })
          |> Repo.one()
    end



  def get_individual_customer_statement(client_loan_id) do
    Loan_transactions
    |> join(:left, [txn], lo in Loans, on: txn.loan_id == lo.id)
    |> join(:left, [txn, lo], uB in UserBioData, on: txn.customer_id == uB.userId)
    |> join(:left, [txn, lo, uB], p in Product, on: txn.product_id == p.id)
    |> where([txn, lo, uB, p], is_nil(lo.company_id) == true and txn.loan_id == ^client_loan_id)
    |> order_by([txn, lo, uB, p, cO], asc: txn.inserted_at)
    |> select([txn, lo, uB, p], %{
            loan_id: txn.loan_id,
            rep_id: uB.userId,
            customer_names:
              fragment(
                "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            customer_phone_number:
              fragment(
                "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            customer_reg_number:
              fragment(
                "select \"meansOfIdentificationNumber\" from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            company_client:
              fragment(
                "select \"companyName\" from tbl_company where \"id\" = ?",
                lo.company_id
              ),

              total_interest_accrued: txn.total_interest_accrued,
              principal_amount: txn.principal_amount,
              repaid_amount: txn.repaid_amount,
              productType: p.productType,
              accrued_no_days: txn.days_accrued,
              transaction_date: txn.transaction_date,
              principal_amount: txn.principal_amount,
              total_finance_cost_accrued: txn.total_finance_cost_accrued,
              outstanding_balance: txn.outstanding_balance,
              daily_accrued_interest: lo.daily_accrued_interest,
              daily_accrued_finance_cost: lo.daily_accrued_finance_cost,
              total_interest: (lo.daily_accrued_interest + lo.daily_accrued_finance_cost),
              calculated_balance: (txn.principal_amount + txn.total_interest_accrued + txn.total_finance_cost_accrued),


      })
    |> Repo.all()
  end

  # Loanmanagementsystem.Operations.get_individual_customer_statement_accrues("158")


  def get_individual_customer_statement_accrues(client_loan_id) do
    Loans
    |> join(:left, [lo], uB in UserBioData, on: lo.customer_id == uB.userId)
    |> join(:left, [lo, uB], p in Product, on: lo.product_id == p.id)
    |> where([lo, uB, p], is_nil(lo.company_id) == true and lo.id == ^client_loan_id)
    |> select([lo, uB, p], %{
              rep_id: uB.userId,
              principal_amount: lo.principal_amount,
              repaid_amount: lo.total_repaid,
              productType: p.productType,
              accrued_no_days: lo.accrued_no_days,
              outstanding_balance: lo.balance,
              daily_accrued_interest: lo.daily_accrued_interest,
              daily_accrued_finance_cost: lo.daily_accrued_finance_cost,
              total_interest: (lo.daily_accrued_interest + lo.daily_accrued_finance_cost),
              calculated_balance: (lo.principal_amount + lo.daily_accrued_interest + lo.daily_accrued_finance_cost),

      })
      |> Repo.all()
  end
# Loanmanagementsystem.Operations.get_individual_customer_details_for_statement("45")

  def get_individual_customer_details_for_statement(client_loan_id) do
    Loan_transactions
    |> join(:left, [txn], lo in Loans, on: txn.loan_id == lo.id)
    |> join(:left, [txn, lo], uB in UserBioData, on: txn.customer_id == uB.userId)
    |> join(:left, [txn, lo, uB], address in Loanmanagementsystem.Accounts.Address_Details, on: lo.customer_id == address.userId)
    |> join(:left, [txn, lo, uB, address], p in Product, on: txn.product_id == p.id)
    |> where([txn, lo, uB, addres, p], is_nil(lo.company_id) == true and txn.loan_id == ^client_loan_id)
    |> select([txn, lo, uB, addres, p], %{
            loan_id: txn.loan_id,
            rep_id: uB.userId,
            rep_address: fragment("concat(?, concat(', ', ?))", addres.street_name, addres.area),
            customer_names:
              fragment(
                "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            customer_phone_number:
              fragment(
                "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            customer_reg_number:
              fragment(
                "select \"meansOfIdentificationNumber\" from tbl_user_bio_data where \"userId\" = ?",
                txn.customer_id
              ),
            company_client:
              fragment(
                "select \"companyName\" from tbl_company where \"id\" = ?",
                lo.company_id
              ),

              total_interest_accrued: txn.total_interest_accrued,
              principal_amount: txn.principal_amount,
              repaid_amount: txn.repaid_amount,

      })
      |> limit(1)
       |> Repo.one()
  end



# Loanmanagementsystem.Operations.get_corperate_customer_statement_first_record("157")

  def get_corperate_customer_statement_first_record(client_loan_id) do
    Loan_transactions
    |> join(:left, [txn], lo in Loans, on: txn.loan_id == lo.id)
    |> join(:left, [txn, lo], uB in UserBioData, on: txn.customer_id == uB.userId)
    |> join(:left, [txn, lo, uB], p in Product, on: txn.product_id == p.id)
    |> join(:left, [txn, lo, uB, p], cO in Company, on: lo.company_id == cO.id)
    |> where([txn, lo, uB, p, cO], is_nil(lo.company_id) != true and txn.loan_id == ^client_loan_id)
    |> order_by([txn, lo, uB, p, cO], asc: txn.inserted_at)
    |> select([txn, lo, uB, p, cO], %{
            loan_id: txn.loan_id,
            rep_id: uB.userId,
              total_interest_accrued: txn.total_interest_accrued,
              principal_amount: txn.principal_amount,
              repaid_amount: txn.repaid_amount,
              productType: p.productType,
              accrued_no_days: txn.days_accrued,
              transaction_date: txn.transaction_date,
              principal_amount: txn.principal_amount,
              total_finance_cost_accrued: txn.total_finance_cost_accrued,
              is_bulk_upload: txn.is_bulk_upload,
              outstanding_balance: txn.outstanding_balance,
              # daily_accrued_interest: lo.daily_accrued_interest,
              # daily_accrued_finance_cost: lo.daily_accrued_finance_cost,
              # total_interest: (lo.daily_accrued_interest + lo.daily_accrued_finance_cost),
              calculated_balance: (lo.principal_amount + txn.total_interest_accrued + txn.total_finance_cost_accrued),

      })
      |> limit(1)
      |> Repo.one()
  end


  def get_individual_customer_statement_first_record(client_loan_id) do
    Loan_transactions
    |> join(:left, [txn], lo in Loans, on: txn.loan_id == lo.id)
    |> join(:left, [txn, lo], uB in UserBioData, on: txn.customer_id == uB.userId)
    |> join(:left, [txn, lo, uB], p in Product, on: txn.product_id == p.id)
    |> where([txn, lo, uB, p], is_nil(lo.company_id) == true and txn.loan_id == ^client_loan_id)
    |> order_by([txn, lo, uB, p, cO], asc: txn.inserted_at)
    |> select([txn, lo, uB, p], %{
      loan_id: txn.loan_id,
      rep_id: uB.userId,
        total_interest_accrued: txn.total_interest_accrued,
        principal_amount: txn.principal_amount,
        repaid_amount: txn.repaid_amount,
        productType: p.productType,
        accrued_no_days: txn.days_accrued,
        transaction_date: txn.transaction_date,
        principal_amount: txn.principal_amount,
        total_finance_cost_accrued: txn.total_finance_cost_accrued,
        is_bulk_upload: txn.is_bulk_upload,
        outstanding_balance: txn.outstanding_balance,
        # daily_accrued_interest: lo.daily_accrued_interest,
        # daily_accrued_finance_cost: lo.daily_accrued_finance_cost,
        # total_interest: (lo.daily_accrued_interest + lo.daily_accrued_finance_cost),
        calculated_balance: (lo.principal_amount + txn.total_interest_accrued + txn.total_finance_cost_accrued),


      })
      |> limit(1)
      |> Repo.one()
  end



  def all_loan_analysis_by_funder_report(search_params, page, size, this_year, funderID) do
    Loans
    # |> handle_loan_book_analysis_report_filter(search_params)
    |> compose_loan_analysis_by_funder_report(this_year, funderID)
    |> Repo.paginate(page: page, page_size: size)
  end

  def all_loan_analysis_by_funder_report(_source, search_params, this_year, funderID) do
    Loans
    # |> handle_loan_book_analysis_report_filter(search_params)
    # |> order_by([l, cO, uB], fragment("SELECT CONCAT(CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'), '\s+$', ''),'-'),EXTRACT(YEAR FROM ?))", lo.inserted_at, lo.inserted_at))
    |> compose_loan_analysis_by_funder_report(this_year, funderID)
  end

  defp compose_loan_analysis_by_funder_report(query, this_year, funderID) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.funderID == uB.userId)
    |> join(:left, [l, uB], p in Product, on: l.product_id == p.id)
    # |> join(:left, [l,uB, p], cO in "tbl_company", on: l.company_id == cO.id)
    |> join(:left, [l,uB, p], loan_c in Loanmanagementsystem.Loan.Loan_Colletral_Documents, on: l.reference_no == loan_c.reference_no)
    |> join(:left, [l,uB, p, loan_c], funder_bio in UserBioData, on: l.funderID == funder_bio.userId)
    |> order_by([l, uB, p, loan_c, funder_bio], desc: l.disbursedon_date)
    |> where( [l, uB, p, loan_c, funder_bio], is_nil(l.disbursedon_date) != true and l.funderID == ^funderID)
    |> select([l, uB, p, loan_c, funder_bio], %{

      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),

        corporate_collateral:
        fragment("select \"fileName\" from tbl_loan_application_documents where \"loan_id\" = ? and \"fileName\" = ?", l.id, "Original Collateral Document & Letter Of Sale"),

        individual_client_collateral:
          fragment("select \"fileName\" from tbl_loan_application_documents where \"loan_id\" = ? and \"fileName\" = ?", l.id, "Post-dated cheques"),

        funder_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.funderID
        ),
        funder_as_company:
        fragment("select \"companyName\" from tbl_company where \"user_bio_id\" = ?", funder_bio.id),

      customer_phone_number:
        fragment(
          "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      company_client:
        fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),

      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      application_date: l.application_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      repayment_amount: l.repayment_amount,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
      company_id: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: (l.interest_amount + l.finance_cost),
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      tenor: l.tenor,
      days_under_due: l.days_under_due,
      days_over_due: l.days_over_due,
      end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      start_date: l.disbursedon_date,
      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      # total_balance_acrued: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),
      total_balance_acrued: l.balance,
      number_of_months: l.eod_count,
      accrued_no_days: l.accrued_no_days,
      total_daily_accrued_charges: (l.daily_accrued_interest + l.daily_accrued_finance_cost),
      total_collectable_amount: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),

    })
  end




  def all_over_due_loan_analysis_by_funder_report(search_params, page, size, this_year, funderID) do
    Loans
    # |> handle_loan_book_analysis_report_filter(search_params)
    |> compose_over_due_loan_analysis_by_funder_report(this_year, funderID)
    |> Repo.paginate(page: page, page_size: size)
  end

  def all_over_due_loan_analysis_by_funder_report(_source, search_params, this_year, funderID) do
    Loans
    # |> handle_loan_book_analysis_report_filter(search_params)
    # |> order_by([l, cO, uB], fragment("SELECT CONCAT(CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'), '\s+$', ''),'-'),EXTRACT(YEAR FROM ?))", lo.inserted_at, lo.inserted_at))
    |> compose_over_due_loan_analysis_by_funder_report(this_year, funderID)
  end

  defp compose_over_due_loan_analysis_by_funder_report(query, this_year, funderID) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.funderID == uB.userId)
    |> join(:left, [l, uB], p in Product, on: l.product_id == p.id)
    # |> join(:left, [l,uB, p], cO in "tbl_company", on: l.company_id == cO.id)
    |> join(:left, [l,uB, p], loan_c in Loanmanagementsystem.Loan.Loan_Colletral_Documents, on: l.reference_no == loan_c.reference_no)
    |> join(:left, [l,uB, p, loan_c], funder_bio in UserBioData, on: l.funderID == funder_bio.userId)
    |> order_by([l, uB, p, loan_c, funder_bio], desc: l.disbursedon_date)
    |> where( [l, uB, p, loan_c, funder_bio], is_nil(l.disbursedon_date) != true and l.funderID == ^funderID and l.tenor < l.accrued_no_days)
    |> select([l, uB, p, loan_c, funder_bio], %{

      loan_id: l.id,
      customer_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),

        corporate_collateral:
        fragment("select \"fileName\" from tbl_loan_application_documents where \"loan_id\" = ? and \"fileName\" = ?", l.id, "Original Collateral Document & Letter Of Sale"),

        individual_client_collateral:
          fragment("select \"fileName\" from tbl_loan_application_documents where \"loan_id\" = ? and \"fileName\" = ?", l.id, "Post-dated cheques"),

        funder_names:
        fragment(
          "select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?",
          l.funderID
        ),
        funder_as_company:
        fragment("select \"companyName\" from tbl_company where \"user_bio_id\" = ?", funder_bio.id),

      customer_phone_number:
        fragment(
          "select \"mobileNumber\" from tbl_user_bio_data where \"userId\" = ?",
          l.customer_id
        ),
      company_client:
        fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.company_id),

      rejectedon_userid: l.rejectedon_userid,
      approvedon_date: l.approvedon_date,
      application_date: l.application_date,
      loan_type: l.loan_type,
      principal_amount: l.principal_amount,
      requested_amount: l.requested_amount,
      disbursedon_date: l.disbursedon_date,
      account_no: l.account_no,
      principal_amount_proposed: l.principal_amount_proposed,
      expected_disbursedon_date: l.expected_disbursedon_date,
      loan_identity_number: l.loan_identity_number,
      loan_status: l.loan_status,
      status: l.status,
      receipient_number: l.receipient_number,
      reference_no: l.reference_no,
      applied_date: l.application_date,
      userId: l.customer_id,
      interest: p.interest,
      product_name: p.name,
      repayment_amount: l.repayment_amount,
      periodType: p.periodType,
      productType: p.productType,
      product_status: p.status,
      expected_maturity_date: l.expected_maturity_date,
      total_repaid: l.total_repaid,
      oftaker: fragment("select \"companyName\" from tbl_company where \"id\" = ?", l.offtakerID),
      company_id: l.offtakerID,
      closedon_date: l.closedon_date,
      interest_amount: (l.interest_amount + l.finance_cost),
      balance: l.balance,
      total_repayment_derived: l.total_repayment_derived,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      tenor: l.tenor,
      days_under_due: l.days_under_due,
      days_over_due: l.days_over_due,
      end_date: fragment("SELECT inserted_at FROM tbl_end_of_day_entries WHERE loan_id = ? ORDER BY inserted_at DESC LIMIT 1", l.id),
      start_date: l.disbursedon_date,
      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      # total_balance_acrued: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),
      total_balance_acrued: l.balance,
      number_of_months: l.eod_count,
      accrued_no_days: l.accrued_no_days,
      total_daily_accrued_charges: (l.daily_accrued_interest + l.daily_accrued_finance_cost),
      total_collectable_amount: (l.daily_accrued_interest + l.daily_accrued_finance_cost + l.principal_amount),

    })
  end


  # def last_five_disbursed_loans_per_funder(search_params, page, size, funderID) do
  #   Loans
  #   # |> handle_last_five_disbursed_loans_miz(search_params)
  #   |> order_by([l, uB, p, cO], desc: l.inserted_at)
  #   |> compose_funder_last_five_disbursed_loans(funderID)
  #   |> Repo.paginate(page: 1, page_size: 5)
  #   # |> limit(5)  # Add limit of 5 records
  # end

  def last_five_disbursed_loans_per_funder(search_params, page, size, funderID) do
    Loans
    # |> handle_last_five_disbursed_loans_miz(search_params)
    |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_funder_last_five_disbursed_loans(funderID)
    |> Repo.paginate(page: page, page_size: size)
  end

  def last_five_disbursed_loans_per_funder(_source, search_params, funderID) do
    Loans
    # |> handle_last_five_disbursed_loans_miz(search_params)
    |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_funder_last_five_disbursed_loans(funderID)
  end


  defp compose_funder_last_five_disbursed_loans(query, funderID) do
    query
    |> join(:left, [l], u in Loanmanagementsystem.Accounts.UserBioData, on: l.customer_id == u.userId)
    |> join(:left, [l, u], prod in Loanmanagementsystem.Products.Product, on: l.product_id == prod.id)
    |> where([l, u, prod], (l.loan_status == "DISBURSED") and l.funderID == ^funderID)
    |> select([l, u, prod], %{
      principal_amount: l.principal_amount,
      customer_name: fragment("concat(?, concat(' ', ?, concat(' ', ?)))", u.firstName, u.lastName, u.otherName),
      product_name: prod.name,
      interest_amount: l.interest_amount,
      total_expected_repayment: l.total_expected_repayment_derived,
      disbursedon_date: l.disbursedon_date,
      application_date: l.application_date,
      loan_status: l.loan_status,
      start_date: l.disbursedon_date,
      daily_accrued_interest: l.daily_accrued_interest,
      daily_accrued_finance_cost: l.daily_accrued_finance_cost,
      number_of_months: l.eod_count,
      total_balance_acrued: l.balance,
      total_amount_repaid: l.total_repaid,
      accrued_no_days: l.accrued_no_days


    })
  end


  def get_active_loans_by_product_per_funder(search_params, page, size, funderID) do
    Loans

    # |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_get_active_loans_by_product_per_funder(funderID)
    |> Repo.paginate(page: page, page_size: size)
  end

  def get_active_loans_by_product_per_funder(_source, search_params, funderID) do
    Loans

    # |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_get_active_loans_by_product_per_funder(funderID)
  end

  defp compose_get_active_loans_by_product_per_funder(query, funderID) do
    query
    |> join(:left, [l], prod in Loanmanagementsystem.Products.Product, on: l.product_id == prod.id)
    |> group_by([l, prod], [prod.name])
    |> where([l, prod], (l.loan_status == "DISBURSED") and l.funderID == ^funderID)
    |> select([l, prod], %{
      product_name: prod.name,
      loan_count: count(l.id),
      interest_amount: sum(l.interest_amount),
      principal_amount: sum(l.principal_amount),
      total_expected_repayment: sum(l.total_expected_repayment_derived),
      daily_accrued_interest: sum(l.daily_accrued_interest),
      daily_accrued_finance_cost: sum(l.daily_accrued_finance_cost),
      total_balance_acrued: sum(l.balance),
      total_repaid: sum(l.total_repaid),


    })

  end


  def get_company_bank_name_by_id(bank_id, company_id) do
    Bank
    |> join(:left, [bk], com in Company, on: bk.id == com.bank_id)
    |> group_by([bk, com], [bk.bankName, com.companyAccountNumber])
    |> where([bk, com], (bk.status == "ACTIVE") and bk.id == ^bank_id and com.id == ^company_id)
    |> select([bk, com], %{
      bankName: bk.bankName,
      bank_account_number: com.companyAccountNumber,

    })
    |> Repo.all()
  end

# Loanmanagementsystem.Operations.get_company_bank_name_by_id(1, 51)
  # :status,
  # :bankName,
  # :acronym,
  # :bank_descrip,
  # :center_code,
  # :bank_code,
  # :process_branch,
  # :swift_code

  def get_employer_docs_by_company_id(company_id) do
    Company
    |> join(:left, [uS, idvdoc], idvdoc in Documents, on: uS.id == idvdoc.companyID)
    |> where([uS, idvdoc], idvdoc.companyID == ^company_id)
    |> select([uS, idvdoc], %{
      id: idvdoc.id,
      docName: idvdoc.docName,
      docPath: idvdoc.path,
      docStatus: idvdoc.status,
      docType: idvdoc.docType
    })
    |> Repo.all()
  end


end
