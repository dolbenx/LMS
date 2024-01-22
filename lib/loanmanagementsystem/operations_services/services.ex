defmodule Loanmanagementsystem.OperationsServices do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts.UserBioData
  alias Loanmanagementsystem.Accounts.UserRole

  alias Loanmanagementsystem.Employment.Employment_Details
  alias Loanmanagementsystem.Companies.{Company,Client_company_details}
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Employment.Personal_Bank_Details
  alias Loanmanagementsystem.Products.Product
  alias Loanmanagementsystem.Employment.Employee_Maintenance
  alias Loanmanagementsystem.Accounts.Address_Details
  alias Loanmanagementsystem.Maintenance.Qfin_Brance_maintenance
  alias Loanmanagementsystem.Maintenance.Company_maintenance
  alias Loanmanagementsystem.Companies.Department
  alias Loanmanagementsystem.Accounts.Customer_account
  alias Loanmanagementsystem.Accounts.Client_Documents
  alias Loanmanagementsystem.Accounts.Nextofkin

  # Loanmanagementsystem.OperationsServices.get_blacklisted_clients
  def get_blacklisted_clients do
    User
    |> join(:left, [uS], uB in UserBioData, on: uS.id == uB.userId)
    |> join(:left, [uS, uB], uR in UserRole, on: uS.id == uR.userId)
    |> where([uS, uB, uR], uS.status == ^"BLACKLISTED")
    |> select([uS, uB, uR], %{
      company_id: uS.company_id,
      classification_id: uS.classification_id,
      roleType: uR.roleType,
      status: uR.status,
      userId: uR.userId,
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
      idNo: uB.idNo,
      bank_id: uB.bank_id,
      bank_account_number: uB.bank_account_number,
      marital_status: uB.marital_status,
      nationality: uB.nationality,
      number_of_dependants: uB.number_of_dependants
    })
    |> Repo.all()
  end

  def get_individual_docs(userID) do
    User
    |> join(:left, [uS, idvdoc], idvdoc in Client_Documents, on: uS.id == ^userID)
    |> where([uS, idvdoc], idvdoc.userID == ^userID)
    |> select([uS, idvdoc], %{
      id: idvdoc.id,
      docName: idvdoc.name,
      docPath: idvdoc.path,
      docStatus: idvdoc.status,
      docType: idvdoc.docType,
      docFile: idvdoc.file
    })
    |> Repo.all()
  end

  def get_individual_details_by_id(userID) do
    User
    |> join(:left, [uS], uB in UserBioData, on: uS.id == uB.userId)
    |> join(:left, [uS, uB], uR in UserRole, on: uS.id == uR.userId)
    |> join(:left, [uS], aD in Address_Details, on: uS.id == aD.userId)
    |> join(:left, [uS], kD in Nextofkin, on: uS.id == kD.userID)
    |> where([uS, uB, uR, aD, kD], uS.id == ^userID)
    |> select([uS, uB, uR, aD, kD], %{
      company_id: uS.company_id,
      classification_id: uS.classification_id,
      roleType: uR.roleType,
      status: uR.status,
      userId: uR.userId,
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
      idNo: uB.idNo,
      bank_id: uB.bank_id,
      bank_account_number: uB.bank_account_number,
      marital_status: uB.marital_status,
      nationality: uB.nationality,
      number_of_dependants: uB.number_of_dependants,
      accomodation_status: aD.accomodation_status,
      area: aD.area,
      house_number: aD.house_number,
      street_name: aD.street_name,
      town_personal: aD.town,
      year_at_current_address: aD.year_at_current_address,
      kin_ID_number: kD.kin_ID_number,
      kin_first_name: kD.kin_first_name,
      kin_gender: kD.kin_gender,
      kin_last_name: kD.kin_last_name,
      kin_mobile_number: kD.kin_mobile_number,
      kin_other_name: kD.kin_other_name,
      kin_personal_email: kD.kin_personal_email,
      kin_relationship: kD.kin_relationship,
      kin_status: kD.kin_status,
    })
    |> Repo.all()
  end
  # Repo.all(from m in Client_Documents, where: m.userID == ^id, select: %{id: m.id, name: m.name, path: m.path}) |> Enum.map(fn map -> %{id: map.id, name: map.name, path: Enum.at(Path.wildcard(map.path), 0) } end) |> Enum.filter(fn %{id: _id, name: _name, path: path} -> path != nil end) |> IO.inspect
  # Loanmanagementsystem.OperationsServices.get_individual_details
  def get_individual_details() do
    User
    |> join(:left, [uS], uB in UserBioData, on: uS.id == uB.userId)
    |> join(:left, [uS, uB], uR in UserRole, on: uS.id == uR.userId)
    |> join(:left, [uS, uB, uR], eD in Employment_Details, on: uS.id == eD.userId)
    |> join(:left, [uS, uB, uR, eD], cO in Company, on: uS.company_id == cO.id)
    |> join(:left, [uS, uB, uR, eD, cO], aD in Address_Details, on: uS.id == aD.userId)
    |> join(:left, [uS, uB, uR, eD, cO, aD], pbD in Personal_Bank_Details, on: uS.id == pbD.userId)
    |> join(:left, [uS, uB, uR, eD, cO, aD, pbD], ccD in Client_company_details, on: uS.id == ccD.createdByUserId)
    # |> join(:left, [uS, uB, uR, eD, cO, aD, pbD, ccD], idvdoc in Client_Documents, on: uS.id == idvdoc.userID)
    |> where([uS, uB, uR, eD, cO, aD], uR.roleType in ["INDIVIDUALS"])
    |> select([uS, uB, uR, eD, cO, aD, pbD, ccD], %{
      company_id: uS.company_id,
      client_company_id: ccD.id,
      client_company_name: ccD.company_name,
      client_company_account_number: ccD.company_account_number,
      client_company_phone: ccD.company_phone,
      client_company_registration_date: ccD.company_registration_date,
      client_contact_email: ccD.contact_email,
      client_registration_number: ccD.registration_number,
      client_taxno: ccD.taxno,
      client_company_bank_name: ccD.company_bank_name,
      client_company_account_name: ccD.company_account_name,
      client_bank_id: ccD.bank_id,
      client_createdByUserId: ccD.createdByUserId,
      client_createdByUserRoleId: ccD.createdByUserRoleId,
      client_company_department: ccD.company_department,
      userid: uS.id,
      user_status: uS.status,
      classification_id: uS.classification_id,
      roletype: uR.roleType,
      status: uR.status,
      userId: uR.userId,
      bio_id: uB.id,
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
      idNo: uB.idNo,
      bank_id: uB.bank_id,
      bank_account_number: uB.bank_account_number,
      marital_status: uB.marital_status,
      nationality: uB.nationality,
      number_of_dependants: uB.number_of_dependants,
      employer_area: eD.area,
      date_of_joining: eD.date_of_joining,
      employee_number: eD.employee_number,
      employername: eD.employer,
      employer_industry_type: eD.employer_industry_type,
      employer_office_building_name: eD.employer_office_building_name,
      employer_officer_street_name: eD.employer_officer_street_name,
      employment_status: eD.employment_type,
      hr_supervisor_email: eD.hr_supervisor_email,
      hr_supervisor_mobile_number: eD.hr_supervisor_mobile_number,
      hr_supervisor_name: eD.hr_supervisor_name,
      job_title: eD.job_title,
      employer_occupation: eD.occupation,
      employer_province: eD.province,
      employer_town: eD.town,
      accomodation_status: aD.accomodation_status,
      area: aD.area,
      house_number: aD.house_number,
      street_name: aD.street_name,
      town_personal: aD.town,
      year_at_current_address: aD.year_at_current_address,
      companyId: cO.id,
      companyName: cO.companyName,
      companyPhone: cO.companyPhone,
      company_contactEmail: cO.contactEmail,
      company_registrationNumber: cO.registrationNumber,
      company_status: cO.status,
      company_taxno: cO.taxno,
      companyRegistrationDate: cO.companyRegistrationDate,
      companyAccountNumber: cO.companyAccountNumber,
      company_bank_id: cO.bank_id,
      accountName: pbD.accountName,
      accountNumber: pbD.accountNumber,
      bankName: pbD.bankName,
      branchName: pbD.branchName,
      upload_bank_statement: pbD.upload_bank_statement
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.OperationsServices.get_client_details
def get_client_details() do
  User
  |> join(:left, [uS], uB in UserBioData, on: uS.id == uB.userId)
  |> join(:left, [uS, uB], uR in UserRole, on: uS.id == uR.userId)
  |> join(:left, [uS, uB, uR], eD in Employment_Details, on: uS.id == eD.userId)
  |> join(:left, [uS, uB, uR, eD], cO in Company, on: uS.company_id == cO.id)
  |> join(:left, [uS, uB, uR, eD, cO], aD in Address_Details, on: uS.id == aD.userId)
  |> join(:left, [uS, uB, uR, eD, cO, aD], pbD in Personal_Bank_Details, on: uS.id == pbD.userId)
  |> join(:left, [uS, uB, uR, eD, cO, aD, pbD], ccD in Client_company_details, on: uS.id == ccD.createdByUserId)
  |> where([uS, uB, uR, eD, cO, aD], uR.roleType in ["EMPLOYEE"])
  |> select([uS, uB, uR, eD, cO, aD, pbD, ccD], %{
    company_id: uS.company_id,
    client_company_id: ccD.id,
    client_company_name: ccD.company_name,
    client_company_account_number: ccD.company_account_number,
    client_company_phone: ccD.company_phone,
    client_company_registration_date: ccD.company_registration_date,
    client_contact_email: ccD.contact_email,
    client_registration_number: ccD.registration_number,
    client_taxno: ccD.taxno,
    client_company_bank_name: ccD.company_bank_name,
    client_company_account_name: ccD.company_account_name,
    client_bank_id: ccD.bank_id,
    client_createdByUserId: ccD.createdByUserId,
    client_createdByUserRoleId: ccD.createdByUserRoleId,
    client_company_department: ccD.company_department,
    userid: uS.id,
    user_status: uS.status,
    classification_id: uS.classification_id,
    roletype: uR.roleType,
    status: uR.status,
    userId: uR.userId,
    bio_id: uB.id,
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
    idNo: uB.idNo,
    bank_id: uB.bank_id,
    bank_account_number: uB.bank_account_number,
    marital_status: uB.marital_status,
    nationality: uB.nationality,
    number_of_dependants: uB.number_of_dependants,
    employer_area: eD.area,
    date_of_joining: eD.date_of_joining,
    employee_number: eD.employee_number,
    employername: eD.employer,
    employer_industry_type: eD.employer_industry_type,
    employer_office_building_name: eD.employer_office_building_name,
    employer_officer_street_name: eD.employer_officer_street_name,
    employment_status: eD.employment_type,
    hr_supervisor_email: eD.hr_supervisor_email,
    hr_supervisor_mobile_number: eD.hr_supervisor_mobile_number,
    hr_supervisor_name: eD.hr_supervisor_name,
    job_title: eD.job_title,
    employer_occupation: eD.occupation,
    employer_province: eD.province,
    employer_town: eD.town,
    accomodation_status: aD.accomodation_status,
    area: aD.area,
    house_number: aD.house_number,
    street_name: aD.street_name,
    town_personal: aD.town,
    year_at_current_address: aD.year_at_current_address,
    companyId: cO.id,
    companyName: cO.companyName,
    companyPhone: cO.companyPhone,
    company_contactEmail: cO.contactEmail,
    company_registrationNumber: cO.registrationNumber,
    company_status: cO.status,
    company_taxno: cO.taxno,
    companyRegistrationDate: cO.companyRegistrationDate,
    companyAccountNumber: cO.companyAccountNumber,
    company_bank_id: cO.bank_id,
    accountName: pbD.accountName,
    accountNumber: pbD.accountNumber,
    bankName: pbD.bankName,
    branchName: pbD.branchName,
    upload_bank_statement: pbD.upload_bank_statement
  })
  |> Repo.all()
end

# Loanmanagementsystem.OperationsServices.get_client_individual_details
def get_client_individual_details(userId) do
  User
  |> join(:left, [uS], uB in UserBioData, on: uS.id == uB.userId)
  |> join(:left, [uS, uB], uR in UserRole, on: uS.id == uR.userId)
  |> join(:left, [uS, uB, uR], eD in Employment_Details, on: uS.id == eD.userId)
  |> join(:left, [uS, uB, uR, eD], cO in Company, on: uS.company_id == cO.id)
  |> join(:left, [uS, uB, uR, eD, cO], aD in Address_Details, on: uS.id == aD.userId)
  |> join(:left, [uS, uB, uR, eD, cO, aD], pbD in Personal_Bank_Details, on: uS.id == pbD.userId)
  |> join(:left, [uS, uB, uR, eD, cO, aD, pbD], ccD in Client_company_details, on: uS.id == ccD.createdByUserId)
  |> where([uS, uB, uR, eD, cO, aD, ccD], uS.id == ^userId)
  |> select([uS, uB, uR, eD, cO, aD, pbD, ccD], %{
    company_id: uS.company_id,
    client_company_id: ccD.id,
    client_company_name: ccD.company_name,
    client_company_account_number: ccD.company_account_number,
    client_company_phone: ccD.company_phone,
    client_company_registration_date: ccD.company_registration_date,
    client_contact_email: ccD.contact_email,
    client_registration_number: ccD.registration_number,
    client_taxno: ccD.taxno,
    client_company_bank_name: ccD.company_bank_name,
    client_company_account_name: ccD.company_account_name,
    client_bank_id: ccD.bank_id,
    client_createdByUserId: ccD.createdByUserId,
    client_createdByUserRoleId: ccD.createdByUserRoleId,
    client_company_department: ccD.company_department,
    userid: uS.id,
    user_status: uS.status,
    classification_id: uS.classification_id,
    roletype: uR.roleType,
    status: uR.status,
    userId: uR.userId,
    bio_id: uB.id,
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
    idNo: uB.idNo,
    bank_id: uB.bank_id,
    bank_account_number: uB.bank_account_number,
    marital_status: uB.marital_status,
    nationality: uB.nationality,
    number_of_dependants: uB.number_of_dependants,
    employer_area: eD.area,
    date_of_joining: eD.date_of_joining,
    employee_number: eD.employee_number,
    employername: eD.employer,
    employer_industry_type: eD.employer_industry_type,
    employer_office_building_name: eD.employer_office_building_name,
    employer_officer_street_name: eD.employer_officer_street_name,
    employment_status: eD.employment_type,
    hr_supervisor_email: eD.hr_supervisor_email,
    hr_supervisor_mobile_number: eD.hr_supervisor_mobile_number,
    hr_supervisor_name: eD.hr_supervisor_name,
    job_title: eD.job_title,
    employer_occupation: eD.occupation,
    employer_province: eD.province,
    employer_town: eD.town,
    accomodation_status: aD.accomodation_status,
    area: aD.area,
    house_number: aD.house_number,
    street_name: aD.street_name,
    town_personal: aD.town,
    year_at_current_address: aD.year_at_current_address,
    companyId: cO.id,
    companyName: cO.companyName,
    companyPhone: cO.companyPhone,
    company_contactEmail: cO.contactEmail,
    company_registrationNumber: cO.registrationNumber,
    company_status: cO.status,
    company_taxno: cO.taxno,
    companyRegistrationDate: cO.companyRegistrationDate,
    companyAccountNumber: cO.companyAccountNumber,
    company_bank_id: cO.bank_id,
    accountName: pbD.accountName,
    accountNumber: pbD.accountNumber,
    bankName: pbD.bankName,
    branchName: pbD.branchName,
    upload_bank_statement: pbD.upload_bank_statement
  })
  |> Repo.all()
end

  # Loanmanagementsystem.OperationsServices.get_employer_employee
  def get_employer_employee() do
    User
    |> join(:left, [uS], uB in UserBioData, on: uS.id == uB.userId)
    |> join(:left, [uS, uB], uR in UserRole, on: uS.id == uR.userId)
    |> join(:left, [uS, uB, uR], eD in Employment_Details, on: uS.id == eD.userId)
    |> join(:left, [uS, uB, uR, eD], cO in Company, on: uS.company_id == cO.id)
    |> join(:left, [uS, uB, uR, eD, cO], aD in Address_Details, on: uS.id == aD.userId)
    |> join(:left, [uS, uB, uR, eD, cO, aD], pbD in Personal_Bank_Details, on: uS.id == pbD.userId)
    |> where([uS, uB, uR, eD, cO, aD], uR.roleType == ^"EMPLOYEE")
    |> select([uS, uB, uR, eD, cO, aD, pbD], %{
      company_id: uS.company_id,
      userid: uS.id,
      user_status: uS.status,
      classification_id: uS.classification_id,
      roleType: uR.roleType,
      status: uR.status,
      userId: uR.userId,
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
      idNo: uB.idNo,
      bank_id: uB.bank_id,
      bank_account_number: uB.bank_account_number,
      marital_status: uB.marital_status,
      nationality: uB.nationality,
      number_of_dependants: uB.number_of_dependants,
      employer_area: eD.area,
      date_of_joining: eD.date_of_joining,
      employee_number: eD.employee_number,
      employername: eD.employer,
      employer_industry_type: eD.employer_industry_type,
      employer_office_building_name: eD.employer_office_building_name,
      employer_officer_street_name: eD.employer_officer_street_name,
      employment_status: eD.employment_type,
      hr_supervisor_email: eD.hr_supervisor_email,
      hr_supervisor_mobile_number: eD.hr_supervisor_mobile_number,
      hr_supervisor_name: eD.hr_supervisor_name,
      job_title: eD.job_title,
      employer_occupation: eD.occupation,
      employer_province: eD.province,
      employer_town: eD.town,
      accomodation_status: aD.accomodation_status,
      area: aD.area,
      house_number: aD.house_number,
      street_name: aD.street_name,
      town_personal: aD.town,
      year_at_current_address: aD.year_at_current_address,
      companyId: cO.id,
      companyName: cO.companyName,
      companyPhone: cO.companyPhone,
      company_contactEmail: cO.contactEmail,
      company_registrationNumber: cO.registrationNumber,
      company_status: cO.status,
      company_taxno: cO.taxno,
      companyRegistrationDate: cO.companyRegistrationDate,
      companyAccountNumber: cO.companyAccountNumber,
      company_bank_id: cO.bank_id,
      accountName: pbD.accountName,
      accountNumber: pbD.accountNumber,
      bankName: pbD.bankName,
      branchName: pbD.branchName,
      upload_bank_statement: pbD.upload_bank_statement
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.OperationsServices.get_loan_details_for_appraisal
  def get_loan_details_for_appraisal() do
    Loanmanagementsystem.Loan.Loans
    |> join(:left, [lO], uS in UserBioData, on: lO.customer_id == uS.userId)
    |> join(:left, [lO, uS, uR], pR in Product, on: pR.id == lO.product_id)
    |> join(:left,[lO, uS], uR in UserRole, on: uS.userId == uR.userId)
    |> select([lO, uS, pR, uR], %{
      isStaff: uR.isStaff,
      loan_limit: uR.loan_limit,
      # tbl_loan
      id: lO.id,
      reject_reason: lO.reason,
      reference_no: lO.reference_no,
      principal_repaid_derived: lO.principal_repaid_derived,
      number_of_repayments: lO.number_of_repayments,
      withdrawnon_date: lO.withdrawnon_date,
      currency_code: lO.currency_code,
      is_npa: lO.is_npa,
      repay_every_type: lO.repay_every_type,
      principal_writtenoff_derived: lO.principal_writtenoff_derived,
      disbursedon_userid: lO.disbursedon_userid,
      approvedon_userid: lO.approvedon_userid,
      total_writtenoff_derived: lO.total_writtenoff_derived,
      repay_every: lO.repay_every,
      closedon_userid: lO.closedon_userid,
      product_id: lO.product_id,
      customer_id: lO.customer_id,
      interest_method: lO.interest_method,
      annual_nominal_interest_rate: lO.annual_nominal_interest_rate,
      writtenoffon_date: lO.writtenoffon_date,
      total_outstanding_derived: lO.total_outstanding_derived,
      interest_calculated_from_date: lO.interest_calculated_from_date,
      loan_counter: lO.loan_counter,
      interest_charged_derived: lO.interest_charged_derived,
      term_frequency_type: lO.term_frequency_type,
      total_charges_due_at_disbursement_derived: lO.total_charges_due_at_disbursement_derived,
      penalty_charges_waived_derived: lO.penalty_charges_waived_derived,
      total_overpaid_derived: lO.total_overpaid_derived,
      approved_principal: lO.approved_principal,
      principal_disbursed_derived: lO.principal_disbursed_derived,
      rejectedon_userid: lO.rejectedon_userid,
      approvedon_date: lO.approvedon_date,
      loan_type: lO.loan_type,
      principal_amount: lO.principal_amount,
      disbursedon_date: lO.disbursedon_date,
      account_no: lO.account_no,
      interest_outstanding_derived: lO.interest_outstanding_derived,
      interest_writtenoff_derived: lO.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: lO.penalty_charges_writtenoff_derived,
      loan_status: lO.loan_status,
      fee_charges_charged_derived: lO.fee_charges_charged_derived,
      fee_charges_waived_derived: lO.fee_charges_waived_derived,
      interest_waived_derived: lO.interest_waived_derived,
      total_costofloan_derived: lO.total_costofloan_derived,
      principal_amount_proposed: lO.principal_amount_proposed,
      fee_charges_repaid_derived: lO.fee_charges_repaid_derived,
      total_expected_repayment_derived: lO.total_expected_repayment_derived,
      principal_outstanding_derived: lO.principal_outstanding_derived,
      penalty_charges_charged_derived: lO.penalty_charges_charged_derived,
      is_legacyloan: lO.is_legacyloan,
      total_waived_derived: lO.total_waived_derived,
      interest_repaid_derived: lO.interest_repaid_derived,
      rejectedon_date: lO.rejectedon_date,
      fee_charges_outstanding_derived: lO.fee_charges_outstanding_derived,
      expected_disbursedon_date: lO.expected_disbursedon_date,
      closedon_date: lO.closedon_date,
      fee_charges_writtenoff_derived: lO.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: lO.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: lO.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: lO.penalty_charges_repaid_derived,
      withdrawnon_userid: lO.withdrawnon_userid,
      expected_maturity_date: lO.expected_maturity_date,
      external_id: lO.external_id,
      term_frequency: lO.term_frequency,
      total_repayment_derived: lO.total_repayment_derived,
      loan_identity_number: lO.loan_identity_number,
      branch_id: lO.branch_id,
      status: lO.status,
      app_user_id: lO.app_user_id,
      mobile_money_response: lO.mobile_money_response,
      total_principal_repaid: lO.total_principal_repaid,
      total_interest_repaid: lO.total_interest_repaid,
      total_charges_repaid: lO.total_charges_repaid,
      total_penalties_repaid: lO.total_penalties_repaid,
      total_repaid: lO.total_repaid,
      momoProvider: lO.momoProvider,
      company_id: lO.company_id,
      sms_status: lO.sms_status,
      loan_userroleid: lO.loan_userroleid,
      disbursement_method: lO.disbursement_method,
      bank_name: lO.bank_name,
      bank_account_no: lO.bank_account_no,
      account_name: lO.account_name,
      bevura_wallet_no: lO.bevura_wallet_no,
      receipient_number: lO.receipient_number,
      reference_no: lO.reference_no,
      repayment_type: lO.repayment_type,
      repayment_amount: lO.repayment_amount,
      balance: lO.balance,
      interest_amount: lO.interest_amount,
      tenor: lO.tenor,
      expiry_month: lO.expiry_month,
      expiry_year: lO.expiry_year,
      cvv: lO.cvv,
      repayment_frequency: lO.repayment_frequency,
      reason: lO.reason,
      application_date: lO.application_date,
      reference_no: lO.reference_no,
      requested_amount: lO.requested_amount,

      # tbl_userbiodate
      dateOfBirth: uS.dateOfBirth,
      emailAddress: uS.emailAddress,
      firstName: uS.firstName,
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

    })
    |> Repo.all()
  end

  # Loanmanagementsystem.OperationsServices.get_loan_details_for_appraisal_by_userId
  def get_loan_details_for_appraisal_by_userId(userId) do
    Loanmanagementsystem.Loan.Loans
    |> join(:left, [lO], uS in UserBioData, on: lO.customer_id == uS.userId)
    |> join(:left, [lO, uS], pR in Product, on: pR.id == lO.product_id)
    |> join(:left,[lO, uS, pR], uR in UserRole, on: uS.userId == uR.userId)
    |> where([lO, uS, pR, uR], lO.customer_id == ^userId)
    |> select([lO, uS, pR, uR], %{

      isStaff: uR.isStaff,
      loan_limit: uR.loan_limit,
      # tbl_loan
      id: lO.id,
      principal_repaid_derived: lO.principal_repaid_derived,
      number_of_repayments: lO.number_of_repayments,
      withdrawnon_date: lO.withdrawnon_date,
      currency_code: lO.currency_code,
      is_npa: lO.is_npa,
      repay_every_type: lO.repay_every_type,
      principal_writtenoff_derived: lO.principal_writtenoff_derived,
      disbursedon_userid: lO.disbursedon_userid,
      approvedon_userid: lO.approvedon_userid,
      total_writtenoff_derived: lO.total_writtenoff_derived,
      repay_every: lO.repay_every,
      closedon_userid: lO.closedon_userid,
      product_id: lO.product_id,
      customer_id: lO.customer_id,
      interest_method: lO.interest_method,
      annual_nominal_interest_rate: lO.annual_nominal_interest_rate,
      writtenoffon_date: lO.writtenoffon_date,
      total_outstanding_derived: lO.total_outstanding_derived,
      interest_calculated_from_date: lO.interest_calculated_from_date,
      loan_counter: lO.loan_counter,
      interest_charged_derived: lO.interest_charged_derived,
      term_frequency_type: lO.term_frequency_type,
      total_charges_due_at_disbursement_derived: lO.total_charges_due_at_disbursement_derived,
      penalty_charges_waived_derived: lO.penalty_charges_waived_derived,
      total_overpaid_derived: lO.total_overpaid_derived,
      approved_principal: lO.approved_principal,
      principal_disbursed_derived: lO.principal_disbursed_derived,
      rejectedon_userid: lO.rejectedon_userid,
      approvedon_date: lO.approvedon_date,
      loan_type: lO.loan_type,
      principal_amount: lO.principal_amount,
      disbursedon_date: lO.disbursedon_date,
      account_no: lO.account_no,
      interest_outstanding_derived: lO.interest_outstanding_derived,
      interest_writtenoff_derived: lO.interest_writtenoff_derived,
      penalty_charges_writtenoff_derived: lO.penalty_charges_writtenoff_derived,
      loan_status: lO.loan_status,
      fee_charges_charged_derived: lO.fee_charges_charged_derived,
      fee_charges_waived_derived: lO.fee_charges_waived_derived,
      interest_waived_derived: lO.interest_waived_derived,
      total_costofloan_derived: lO.total_costofloan_derived,
      principal_amount_proposed: lO.principal_amount_proposed,
      fee_charges_repaid_derived: lO.fee_charges_repaid_derived,
      total_expected_repayment_derived: lO.total_expected_repayment_derived,
      principal_outstanding_derived: lO.principal_outstanding_derived,
      penalty_charges_charged_derived: lO.penalty_charges_charged_derived,
      is_legacyloan: lO.is_legacyloan,
      total_waived_derived: lO.total_waived_derived,
      interest_repaid_derived: lO.interest_repaid_derived,
      rejectedon_date: lO.rejectedon_date,
      fee_charges_outstanding_derived: lO.fee_charges_outstanding_derived,
      expected_disbursedon_date: lO.expected_disbursedon_date,
      closedon_date: lO.closedon_date,
      fee_charges_writtenoff_derived: lO.fee_charges_writtenoff_derived,
      penalty_charges_outstanding_derived: lO.penalty_charges_outstanding_derived,
      total_expected_costofloan_derived: lO.total_expected_costofloan_derived,
      penalty_charges_repaid_derived: lO.penalty_charges_repaid_derived,
      withdrawnon_userid: lO.withdrawnon_userid,
      expected_maturity_date: lO.expected_maturity_date,
      external_id: lO.external_id,
      term_frequency: lO.term_frequency,
      total_repayment_derived: lO.total_repayment_derived,
      loan_identity_number: lO.loan_identity_number,
      branch_id: lO.branch_id,
      loan_status: lO.status,
      app_user_id: lO.app_user_id,
      mobile_money_response: lO.mobile_money_response,
      total_principal_repaid: lO.total_principal_repaid,
      total_interest_repaid: lO.total_interest_repaid,
      total_charges_repaid: lO.total_charges_repaid,
      total_penalties_repaid: lO.total_penalties_repaid,
      total_repaid: lO.total_repaid,
      momoProvider: lO.momoProvider,
      company_id: lO.company_id,
      sms_status: lO.sms_status,
      loan_userroleid: lO.loan_userroleid,
      disbursement_method: lO.disbursement_method,
      bank_name: lO.bank_name,
      bank_account_no: lO.bank_account_no,
      account_name: lO.account_name,
      bevura_wallet_no: lO.bevura_wallet_no,
      receipient_number: lO.receipient_number,
      reference_no: lO.reference_no,
      repayment_type: lO.repayment_type,
      repayment_amount: lO.repayment_amount,
      balance: lO.balance,
      interest_amount: lO.interest_amount,
      tenor: lO.tenor,
      expiry_month: lO.expiry_month,
      expiry_year: lO.expiry_year,
      cvv: lO.cvv,
      repayment_frequency: lO.repayment_frequency,
      reason: lO.reason,

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
      product_reason: pR.reason
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.OperationsServices.get_user_by_id
  def get_user_by_id(userId) do
    UserBioData
    |> join(:left,[ uS], uR in UserRole, on: uS.userId == uR.userId)
    |> where([uS, uR], uS.userId == ^userId)
    |> select([uS, uR], %{

      isStaff: uR.isStaff,
      loan_limit: uR.loan_limit,
      # tbl_userbiodate
      dateOfBirth: uS.dateOfBirth,
      emailAddress: uS.emailAddress,
      firstName: uS.firstName,
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
      disability_status: uS.disability_status
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.OperationsServices.get_qfin_employees
  def get_qfin_employees() do
    Employee_Maintenance
    |> join(:left, [eM], uB in UserBioData, on: eM.userId == uB.userId)
    |> join(:left, [eM, uB], aD in Address_Details, on: eM.userId == aD.userId)
    |> join(:left, [eM, uB, aD], uS in User, on: uS.id == uB.userId)
    |> join(:left, [eM, uB, aD, uS], uR in UserRole, on: uS.id == uR.userId)
    |> join(:left, [eM, uB, aD, uS], qF in Qfin_Brance_maintenance, on: eM.branchId == qF.id)
    |> join(:left, [eM, uB, aD, uS, cM], cM in Company_maintenance)
    |> join(:left, [eM, uB, aD, uS, cM, qf], dP in Department, on: dP.id == eM.departmentId)
    |> where(
      [eM, uB, aD, uS, uR, qF, cM, dP],
      uR.roleType ==
        "EMPLOYEE" and uR.isStaff == true
    )|> limit(10)
    |> select([eM, uB, aD, uS, uR, qF, cM, dP], %{
      branchId: eM.branchId,
      branch_name: qF.name,
      departmentId: eM.departmentId,
      department_deptCode: dP.deptCode,
      department_name: dP.name,
      department_status: dP.status,
      employee_number: eM.employee_number,
      employee_status: eM.employee_status,
      mobile_network_operator: eM.mobile_network_operator,
      nrc_image: eM.nrc_image,
      registered_name_mobile_number: eM.registered_name_mobile_number,
      nationality: uB.nationality,
      number_of_dependants: uB.number_of_dependants,
      marital_status: uB.marital_status,
      bank_id: uB.bank_id,
      bank_account_number: uB.bank_account_number,
      firstName: uB.firstName,
      lastName: uB.lastName,
      idNo: uB.idNo,
      otherName: uB.otherName,
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      accomodation_status: aD.accomodation_status,
      area: aD.area,
      house_number: aD.house_number,
      street_name: aD.street_name,
      employee_town: aD.town,
      year_at_current_address: aD.year_at_current_address,
      province: aD.province,
      qfin_branchAddress: qF.branchAddress,
      qfin_branchCode: qF.branchCode,
      qfin_city: qF.city,
      qfin_name: qF.name,
      qfin_province: qF.province,
      qfin_status: qF.status,
      status: uS.status,
      roleType: uR.roleType,
      user_role_status: uR.status,
      userId: uR.userId,
      client_type: uR.client_type,
      isStaff: uR.isStaff,
      job_title: eM.job_title,
      company_id: cM.id,
      address: cM.address,
      company_logo: cM.company_logo,
      company_name: cM.company_name,
      company_registrationNumber: cM.company_reg_no,
      country: cM.country,
      currency: cM.currency,
      companyPhone: cM.phone_no,
      # work on this field
      company_contactEmail: cM.phone_no,
      employer_town: cM.town,
      company_taxno: cM.tpin
    })
    |> Repo.all()
  end

  # Loanmanagementsystem.OperationsServices.get_qfin_crm_employees
  def get_qfin_crm_employees() do
    Employee_Maintenance
    |> join(:left, [eM], uB in UserBioData, on: eM.userId == uB.userId)
    |> join(:left, [eM, uB], uS in User, on: uS.id == uB.userId)
    |> join(:left, [eM, uB, uS], uR in UserRole, on: uS.id == uR.userId)
    |> join(:left, [eM, uB, uS], qF in Qfin_Brance_maintenance, on: eM.branchId == qF.id)
    |> join(:left, [eM, uB, uS], dP in Department, on: dP.id == eM.departmentId)
    |> where(
      [eM, uB, uS, uR, qF, dP],
      uR.roleType ==
        "EMPLOYEE" and uR.isStaff == true
    )
    |> select([eM, uB, uS, uR, qF, dP], %{
      branchId: eM.branchId,
      branch_name: qF.name,
      departmentId: eM.departmentId,
      department_name: dP.name,
      employee_number: eM.employee_number,
      employee_status: eM.employee_status,
      firstName: uB.firstName,
      lastName: uB.lastName,
      otherName: uB.otherName,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      qfin_name: qF.name,
      job_title: eM.job_title,
      userId: uB.userId
    })
    |> Repo.all()
  end
  # Loanmanagementsystem.OperationsServices.get_clients_for_re_assignemnt(1)
  def get_clients_for_re_assignemnt(userId) do
  #  subquery = UserBioData
  #     |>where([cM], cM.userId == ^userId)
  #     |>select([cM], %{
  #     customer_names: fragment("concat(?, concat(' ', ?))", cM.firstName, cM.lastName),
  #     dateOfBirth: cM.dateOfBirth,
  #     meansOfIdentificationType: cM.meansOfIdentificationType,
  #     meansOfIdentificationNumber: cM.meansOfIdentificationNumber,
  #     title: cM.title,
  #     gender: cM.gender,
  #     mobileNumber: cM.mobileNumber,
  #     emailAddress: cM.emailAddress,
  #     userId: cM.userId,
  #     })



    UserBioData
    |> join(:left, [uB], rM in Customer_account, on: uB.userId == rM.user_id)
    |> where([uB, rM], rM.loan_officer_id == ^userId)
    # |> union_all( ^subquery)
    |> select([uB, rM], %{
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      userId: uB.userId,
      assignment_date: rM.assignment_date
    })
    |>Repo.all()



  end



  # def get_crm_by_userId(userId) do
  #     UserBioData
  #     |>where([cM], cM.userId == ^userId)
  #     |>select([cM], %{
  #       crm_dateOfBirth: cM.dateOfBirth ,
  #       crm_emailAddress: cM.emailAddress ,
  #       crm_firstName: cM.firstName ,
  #       crm_gender: cM.gender ,
  #       crm_lastName: cM.lastName ,
  #       crm_meansOfIdentificationNumber: cM.meansOfIdentificationNumber ,
  #       crm_meansOfIdentificationType: cM.meansOfIdentificationType ,
  #       crm_mobileNumber: cM.mobileNumber ,
  #       crm_otherName: cM.otherName ,
  #       crm_title: cM.title ,
  #       crm_userId: cM.userId ,
  #       crm_marital_status: cM.marital_status ,
  #       crm_nationality: cM.nationality ,
  #     })|>Repo.all()


  # end
  #  def get_cargo_mover_user_roles do
  #    Repo.all(
  #      from(
  #        u in  UserRole,
  #        where: u.role_desc == ^"Cargo mover",
  #        select: u
  #      ) |> preload([:maker, :checker])
  #    )|>Enum.at(0)
  #  end




  # def lookup_tonnage(quarter, year) do
  #   from(a in UserBioData, as: :requisite)
  #   |> where(
  #     [a],
  #     a.status == "ACTIVE" and
  #   )
  #   |> join(:left, [a], b in Customer_account, on: a.userId == b.user_id)
  #   |> where(
  #     [a, b],
  #     exists(
  #       from(m in Customer_account, where: parent_as(:requisite).user_id == m.userId)
  #     )
  #   )
  #   |> select([a, b], %{
  #     clients: fragment("concat(?, concat(' ', ?))", a.firstName, a.lastName), a.dateOfBirth,a.meansOfIdentificationType, a.meansOfIdentificationNumber, a.title,a.gender,a.mobileNumber, a.emailAddress,  a.userId,
  #     crms:  fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),,
  #   })
  #   |> Repo.all()
  # end
  # def lookup_tonnage(quarter, year) do
  #   from(a in Zrl.Order.FuelMonitoring, as: :requisite)
  #   |> where(
  #     [a],
  #     a.status == "COMPLETE" and
  #       fragment("DATEPART(QUARTER, ?) = ? and YEAR(?) = ?", a.date, ^quarter, a.date, ^year)
  #   )
  #   |> join(:left, [a], b in Zrl.Order.Movement, on: a.train_number == b.train_no)
  #   |> join(:left, [a, b], c in Zrl.Order.Consignment,
  #     on:
  #       c.document_date == b.consignment_date and c.final_destination_id == b.destin_station_id and
  #         c.origin_station_id == b.origin_station_id and c.wagon_id == b.wagon_id and
  #         c.consignee_id == b.consignee_id and c.consigner_id == b.consigner_id
  #   )
  #   |> where(
  #     [a, b],
  #     exists(
  #       from(m in Zrl.Order.Movement, where: parent_as(:requisite).train_number == m.train_no)
  #     )
  #   )
  #   |> order_by([a, b, c], desc: [fragment("FORMAT(?, 'MMMM', 'en-US')", a.date)])
  #   |> group_by([a, b, c], [
  #     a.train_destination_id,
  #     a.depo_refueled_id,
  #     fragment("FORMAT(?, 'MMMM', 'en-US')", a.date)
  #   ])
  #   |> select([a, b, c], %{
  #     mvt_revenue: sum(c.total),
  #     date: fragment("FORMAT(?, 'MMMM', 'en-US')", a.date),
  #     tonnages: fragment( "sum(case when ? < 1 then ? else ? end)", c.actual_tonnes, c.container_no, c.actual_tonnes),
  #     tonnages_per_km: fragment("sum(case when ? < 1 then ? else ? end)", c.actual_tonnes, c.container_no, c.actual_tonnes) * fragment(
  #           "select distance from tbl_distance where destin = ? and station_orig = ? ",
  #           a.train_destination_id,
  #           a.depo_refueled_id
  #         )
  #   })
  #   |> Repo.all()
  # end

  # Loanmanagementsystem.OperationsServices.get_clients_for_re_assignemet_by_officers_id(1)
def get_clients_for_re_assignemet_by_officers_id(userId) do
    UserBioData
    |> join(:left, [uB], rM in Customer_account, on: uB.userId == rM.user_id)
    |> where([uB, rM], rM.loan_officer_id == ^userId)
    |> select([uB, rM], %{
      customer_names: fragment("concat(?, concat(' ', ?))", uB.firstName, uB.lastName),
      dateOfBirth: uB.dateOfBirth,
      meansOfIdentificationType: uB.meansOfIdentificationType,
      meansOfIdentificationNumber: uB.meansOfIdentificationNumber,
      title: uB.title,
      gender: uB.gender,
      mobileNumber: uB.mobileNumber,
      emailAddress: uB.emailAddress,
      assignment_date: rM.assignment_date
    })|>Repo.all

end




end
