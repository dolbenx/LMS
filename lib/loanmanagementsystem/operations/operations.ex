defmodule Loanmanagementsystem.Operations do
  import Ecto.Query, warn: false
  alias Loanmanagementsystem.Repo

  alias Loanmanagementsystem.Companies.Company
  alias Loanmanagementsystem.Accounts.{UserBioData, UserRole}
  alias Loanmanagementsystem.Maintenance.Bank
  # Loanmanagementsystem.Operations.get_company
  alias Loanmanagementsystem.Loan.Loan_Provisioning_Criteria
  alias Loanmanagementsystem.Products.Product

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
      status: cO.status
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
end
