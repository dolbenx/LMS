defmodule Loanmanagementsystem.Operations do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Accounts.{UserBioData, UserRole, User, Address_Details}
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Loan.Loan_Provisioning_Criteria
  alias Loanmanagementsystem.Products.Product
  alias Loanmanagementsystem.Companies.Documents
  alias Loanmanagementsystem.Loan.Loan_application_documents

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

  # Loanmanagementsystem.Operations.get_employer_docs(129)
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
      accomodation_status: bM.accomodation_status
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
      accomodation_status: bM.accomodation_status
    })
    |> Repo.all()
  end
  # Loanmanagementsystem.Operations.get_company()
  def get_company() do
    Company
    |> join(:left, [cO], uB in UserBioData, on: cO.user_bio_id == uB.id)
    |> join(:left, [cO, uB], uR in UserRole, on: uB.userId == uR.userId)
    |> join(:left, [cO, uB, uR], bA in Bank, on: cO.bank_id == bA.id)
    |> join(:left, [cO, uB, uR, bA], uS in User, on: uB.userId == uS.id)
    |> select([cO, uB, uR, bA, uS], %{
      id: cO.id,
      roleId: uR.id,
      userId: uB.userId,
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
      user_status: uS.status
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

  # Loanmanagementsystem.Loan.ordering_finance_details(5)
  def ordering_finance_details(loan_id) do
    Loans
    |> join(:left, [l], uS in User, on: l.customer_id == uS.id)
    |> join(:left, [l, uS], uB in UserBioData, on: uS.id == uB.userId)
    |> join(:left, [l, uS, uB], pr in Product_rates, on: l.product_id == pr.product_id)
    |> join(:left, [l, uS, uB, pr], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uS, uB, pr, p], c in Company, on: uS.company_id == c.id)
    |> join(:left, [l, uS, uB, pr, p, c], b in Bank, on: c.bank_id == b.id)
    |> join(:left, [l, uS, uB, pr, p, c, b], inv in Loan_invoice,
      on: l.customer_id == inv.customer_id
    )
    |> join(:left, [l, uS, uB, pr, p, c, b, inv], funder in UserBioData,
      on: funder.userId == l.funderID
    )
    |> where([l, uS, uB, pr, p, c, b, inv, funder], l.id == ^loan_id)
    |> select([l, uS, uB, pr, p, c, b, inv, funder], %{
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
      invoiceValue: inv.invoiceValue,
      paymentTerms: inv.paymentTerms,
      dateOfIssue: inv.dateOfIssue,
      invoiceNo: inv.invoiceNo,
      loanID: inv.loanID,
      status: inv.status,
      vendorName: inv.vendorName,
      arrangement_fee: l.arrangement_fee,
      finance_cost: l.finance_cost,
      funder_first_name: funder.firstName,
      funder_last_name: funder.lastName
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
      offtaker_bank_id: cO.bank_id
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
    |> where([l, uB, p, cO], is_nil(l.application_date) != true)
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
    |> where([l, uB, p, cO], is_nil(l.application_date) != true)
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
    # |> handle_loan_awaiting_disbursement_report_filter(search_params)
    |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_approve_loan_awaiting_disbursement_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def approve_loan_awaiting_disbursement_miz(_source, search_params) do
    Loans
    # |> handle_loan_awaiting_disbursement_report_filter(search_params)
    |> order_by([l, uB, p, cO], desc: l.inserted_at)
    |> compose_approve_loan_awaiting_disbursement_miz()
  end

  defp compose_approve_loan_awaiting_disbursement_miz(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
    |> where([l, uB, p, cO], l.loan_status == "PENDING_ACCOUNTANT_DISBURSEMENT")
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
      l.loan_type,
      l.principal_amount,
      l.interest_amount,
      l.inserted_at,
      uB.firstName,
      uB.lastName,
      l.funderID
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
      funder_name:
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
        )
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

  def loan_book_analysis_report(search_params, page, size, this_year) do
    Loans
    |> handle_loan_book_analysis_report_filter(search_params)
    # |> order_by([lo, u, uB], fragment("SELECT CONCAT(CONCAT(REGEXP_REPLACE(TO_CHAR(?,'Month'), '\s+$', ''),'-'),EXTRACT(YEAR FROM ?))", lo.inserted_at, lo.inserted_at))
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
    |> join(:left, [l,uB, p], cO in "tbl_company", on: l.company_id == cO.id)

    # |> order_by([l, uB, p, cO], asc: fragment("SELECT CONCAT(CONCAT(TO_CHAR(?, 'Month'),'-'), EXTRACT(YEAR FROM ?))", l.inserted_at, l.inserted_at))
    # |> group_by([l, uB, p, cO], [fragment("SELECT TO_CHAR(?, 'Month')", l.inserted_at), fragment("SELECT CONCAT(CONCAT(TO_CHAR(?, 'Month'),'-'), EXTRACT(YEAR FROM ?))", l.inserted_at, l.inserted_at), cO.id, cO.companyName, l.repayment_type, l.inserted_at, l.loan_type, uB.firstName, uB.lastName, l.principal_amount,l.interest_amount])
    |> group_by([l, uB, p, cO], [
      l.repayment_type,
      cO.companyPhone,
      cO.companyName,
      l.loan_type,
      l.principal_amount,
      l.interest_amount,
      l.inserted_at,
      uB.firstName,
      uB.lastName,
      l.funderID
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
      funder_name:
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
        )
    })
  end

defp handle_loan_book_analysis_report_filter(query, %{"isearch" => search_term} = search_params)
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

  # -----------------------------------------------------------------
  # Loanmanagementsystem.Operations.corperate_customer_report_miz(nil, 1, 10)

  def corperate_customer_report_miz(search_params, page, size) do
    Loans
    |> handle_corperate_customer_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_corperate_customer_report_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def corperate_customer_report_miz(_source, search_params) do
    Loans
    |> handle_corperate_customer_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_corperate_customer_report_miz()
  end

  defp compose_corperate_customer_report_miz(query) do
    query
    |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
    |> join(:left, [l, uB], p in Product, on: l.product_id == p.id)
    |> join(:left, [l, uB, p], cO in Company, on: l.company_id == cO.id)
    |> where([l, uB, p, cO], is_nil(l.company_id) != true)
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
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_individual_customer_report_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def individual_customer_report_miz(_source, search_params) do
    Loans
    |> handle_individual_customer_filter(search_params)
    |> order_by([l, uB, p], desc: l.inserted_at)
    |> compose_individual_customer_report_miz()
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
      tenor: l.tenor
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
  when byte_size(filter_by_number_of_days_filter) > 0  do
    today = Date.utc_today
    given_date = Timex.shift(today, days: String.to_integer(filter_by_number_of_days_filter))

    case Date.compare(given_date, Date.utc_today()) do
      :lt ->
        given_date = Date.to_string(given_date)

      # query
      # |> where([l, uB, p, cO], fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.inserted_at, ^given_date) and
      #   fragment("CAST(? AS DATE) <= ?", l.inserted_at, l.application_date)
      # )
      query
        |> where([l, uB, p, cO], fragment("CAST(? AS DATE) <= ?", l.application_date, type(^given_date, :date)) and
          fragment("CAST(? AS DATE) >= ?", l.application_date, type(^given_date, :date))
        )
      # :gt ->
      #   given_date = Date.to_string(given_date)
      #   query
      #   # |> where([l, uB, p, cO], fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.inserted_at, type(^given_date, :date)))
      #   |> where([l, uB, p, cO], fragment("CAST(? AS DATE) >= ?", l.inserted_at, type(^given_date, :date)))
      # query
      # |> where([l, uB, p, cO], fragment("? >= TO_DATE(?, 'YYYY/MM/DD')", l.inserted_at, ^given_date) and
      #   fragment("CAST(? AS DATE) >= ?", l.inserted_at, l.application_date)
      # )
    end
end

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



    # Loanmanagementsystem.Operations.defaulters_report_miz(nil, 1, 10)

    def defaulters_report_miz(search_params, page, size) do
      Loans
      # |> handle_defaulters_report_filter(search_params)
      |> order_by([l, uB, p,cO], desc: l.inserted_at)
      |> compose_defaulters_report_miz()
      |> Repo.paginate(page: page, page_size: size)
    end

    def defaulters_report_miz(_source, search_params) do
      Loans
      # |> handle_defaulters_report_filter(search_params)
      |> order_by([l, uB, p,cO], desc: l.inserted_at)
      |> compose_defaulters_report_miz()
    end

    defp compose_defaulters_report_miz(query) do
      query
      |> join(:left, [l], uB in UserBioData, on: l.customer_id == uB.userId)
      |> join(:left, [l, uB], cO in Company, on: l.company_id == cO.id)
      |> join(:left, [l, uB, cO], p in Product, on: l.product_id == p.id)
      |> select([l, uB, cO, p], %{
        id: l.id,
        dateOfBirth: uB.dateOfBirth,
        emailAddress: uB.emailAddress,
        customer_names: fragment("select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?", l.customer_id),
        gender: uB.gender,
        meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
        meansOfIdentificationType: uB.meansOfIdentificationType,
        mobileNumber: uB.mobileNumber,
        title: uB.title,
        userId: uB.userId,
        idNo: uB.idNo,
        bank_id: uB.bank_id,
        bank_account_number: uB.bank_account_number,
        marital_status: uB.marital_status,
        nationality: uB.nationality,
        approvedon_date: l.approvedon_date,
        loan_type: l.loan_type,
        principal_amount: l.principal_amount,
        requested_amount: l.requested_amount,
        disbursedon_date: l.disbursedon_date,
        account_no: l.account_no,
        principal_amount_proposed: l.principal_amount_proposed,
        expected_disbursedon_date: l.expected_disbursedon_date,
        loan_status: l.loan_status,
        status: l.status,
        receipient_number: l.receipient_number,
        reference_no: l.reference_no,
        applied_date: l.application_date,
        interest: p.interest,
        product_name: p.name,
        expected_maturity_date: l.expected_maturity_date,
        total_repaid: l.total_repaid,
        closedon_date: l.closedon_date,
        interest_amount: l.interest_amount,
        balance: l.balance,
        tenor: l.tenor,
        employer: cO.companyName,
        pending_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"userId\" = ? AND LOWER(\"status\") LIKE ?",l.customer_id, "%pending%"),
        active_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"userId\" = ?", l.customer_id),
        disbursed_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"userId\" = ? AND LOWER(\"status\") LIKE ?", l.customer_id, "%disbursed%"),
        rejected_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"userId\" = ? AND LOWER(\"status\") LIKE ?", l.customer_id, "%rejected%")
      })
    end




  # Loanmanagementsystem.Operations.employers_report_miz(nil, 1, 10)

  def employers_report_miz(search_params, page, size) do
    Company
    # |> handle_employers_report_filter(search_params)
    |> order_by([cO, emp, l], desc: l.inserted_at)
    |> compose_employers_report_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def employers_report_miz(_source, search_params) do
    Company
    # |> handle_employers_report_filter(search_params)
    |> order_by([cO, emp, l], desc: l.inserted_at)
    |> compose_employers_report_miz()
  end

  defp compose_employers_report_miz(query) do
    query
    |> join(:left, [cO], emp in "tbl_users", on: cO.id == emp.company_id)
    |> join(:left, [cO, emp], l in "tbl_loans", on: cO.id == l.company_id)
    |> group_by([cO, emp, l], [cO.companyName,cO.id, emp.company_id, cO.companyRegistrationDate, cO.status, l.inserted_at] )
    |> select([cO, emp, l], %{
      company_id: cO.id,
      employer_name: cO.companyName,
      number_of_employees: fragment("SELECT COUNT(*) FROM tbl_users WHERE \"company_id\" = ?", emp.company_id),
      number_of_loans: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"company_id\"= ?", emp.company_id),
      companyRegistrationDate: cO.companyRegistrationDate,
      pending_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"company_id\" = ? AND LOWER(\"status\") LIKE ?",emp.company_id, "%pending%"),
      active_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"company_id\" = ?", emp.company_id),
      disbursed_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"company_id\" = ? AND LOWER(\"status\") LIKE ?", emp.company_id, "%disbursed%"),
      rejected_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"company_id\" = ? AND LOWER(\"status\") LIKE ?", emp.company_id, "%rejected%"),
      status: cO.status
    })
  end


  # Loanmanagementsystem.Operations.blackliast_client_report_miz(nil, 1, 10)

  def blackliast_client_report_miz(search_params, page, size) do
    User
    # |> handle_blackliast_client_report_filter(search_params)
    |> order_by([uS], desc: uS.inserted_at)
    |> compose_blackliast_client_report_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def blackliast_client_report_miz(_source, search_params) do
    User
    # |> handle_blackliast_client_report_filter(search_params)
    |> order_by([uS], desc: uS.inserted_at)
    |> compose_blackliast_client_report_miz()
  end

  defp compose_blackliast_client_report_miz(query) do
    query
    |> where([uS], fragment("SELECT \"roleType\" FROM tbl_user_roles WHERE \"userId\" = ?", uS.id) != "ADMIN" and fragment("SELECT \"roleType\" FROM tbl_user_roles WHERE \"userId\" = ?", uS.id) == "BLACKLISTED")
    |> select([uS], %{
      customer_names: fragment("select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?", uS.id),
      userId: uS.id,
      inserted_at: uS.inserted_at,
      user_status: uS.status,
      role: fragment("SELECT \"roleType\" FROM tbl_user_roles WHERE \"userId\" = ?", uS.id),
      employer: fragment("SELECT \"companyName\" FROM tbl_company WHERE \"id\" = ?", uS.company_id),
      pending_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ? AND LOWER(\"status\") LIKE ?",uS.id, "%pending%"),
      active_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ?", uS.id),
      disbursed_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ? AND LOWER(\"status\") LIKE ?", uS.id, "%disbursed%"),
      rejected_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ? AND LOWER(\"status\") LIKE ?", uS.id, "%rejected%")
    })
  end

  # Loanmanagementsystem.Operations.employers_employees_list_report_miz(nil, 1, 10)

  def employers_employees_list_report_miz(search_params, page, size) do
    User
    # |> handle_employers_employees_list_report_filter(search_params)
    |> order_by([uS], desc: uS.inserted_at)
    |> compose_employers_employees_list_report_miz()
    |> Repo.paginate(page: page, page_size: size)
  end

  def employers_employees_list_report_miz(_source, search_params) do
    User
    # |> handle_employers_employees_list_report_filter(search_params)
    |> order_by([uS], desc: uS.inserted_at)
    |> compose_employers_employees_list_report_miz()
  end

  defp compose_employers_employees_list_report_miz(query) do
    query
    |>join(:left, [uS], emp in "tbl_employment_details", on: uS.id == emp.userId)
    |> where([uS, emp], fragment("SELECT \"roleType\" FROM tbl_user_roles WHERE \"userId\" = ?", uS.id) != "ADMIN" and fragment("SELECT \"roleType\" FROM tbl_user_roles WHERE \"userId\" = ?", uS.id) != "EMPLOYER" and is_nil(uS.company_id) != true)
    |> select([uS, emp], %{
      customer_names: fragment("select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?", uS.id),
      userId: uS.id,
      inserted_at: uS.inserted_at,
      user_status: uS.status,
      job_title: emp.job_title,
      registration_date: emp.inserted_at,
      role: fragment("SELECT \"roleType\" FROM tbl_user_roles WHERE \"userId\" = ?", uS.id),
      employer: fragment("SELECT \"companyName\" FROM tbl_company WHERE \"id\" = ?", uS.company_id),
      pending_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ? AND LOWER(\"status\") LIKE ?",uS.id, "%pending%"),
      active_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ?", uS.id),
      disbursed_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ? AND LOWER(\"status\") LIKE ?", uS.id, "%disbursed%"),
      rejected_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ? AND LOWER(\"status\") LIKE ?", uS.id, "%rejected%")
    })
  end
  # Loanmanagementsystem.Operations.employers_employees_list
  def employers_employees_list() do
    User
    |>join(:left, [uS], emp in "tbl_employment_details", on: uS.id == emp.userId)
    |> where([uS, emp], fragment("SELECT \"roleType\" FROM tbl_user_roles WHERE \"userId\" = ?", uS.id) != "ADMIN" and fragment("SELECT \"roleType\" FROM tbl_user_roles WHERE \"userId\" = ?", uS.id) != "EMPLOYER")
    |> select([uS, emp], %{
      customer_names: fragment("select concat(\"firstName\", concat(' ', \"lastName\")) from tbl_user_bio_data where \"userId\" = ?", uS.id),
      userId: uS.id,
      inserted_at: uS.inserted_at,
      user_status: uS.status,
      job_title: emp.job_title,
      registration_date: emp.inserted_at,
      role: fragment("SELECT \"roleType\" FROM tbl_user_roles WHERE \"userId\" = ?", uS.id),
      employer: fragment("SELECT \"companyName\" FROM tbl_company WHERE \"id\" = ?", uS.company_id),
      pending_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ? AND LOWER(\"status\") LIKE ?",uS.id, "%pending%"),
      active_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ?", uS.id),
      disbursed_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ? AND LOWER(\"status\") LIKE ?", uS.id, "%disbursed%"),
      rejected_loan: fragment("SELECT COUNT(*) FROM tbl_loans WHERE \"customer_id\" = ? AND LOWER(\"status\") LIKE ?", uS.id, "%rejected%")
    })|> Repo.all()
  end
end
