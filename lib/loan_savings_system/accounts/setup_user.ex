defmodule LoanSavingsSystem.SetUser do
  # LoanSavingsSystem.SetUser.super()
  # LoanSavingsSystem.SetUser.create_super_role()
  # LoanSavingsSystem.SetUser.create_enployee_role()
  # LoanSavingsSystem.SetUser.create_enployer_role()
  # LoanSavingsSystem.SetUser.create_individual_role()
  # LoanSavingsSystem.SetUser.create_company()

  def super() do
    create_super_role()
    create_user_bio()
    create_client()
    create_client_telco()

    create_enployer_role()
    create_enployee_role()
    create_individual_role()
    create_sme_role()
    create_company()
    create_offtacker_role()
    LoanSavingsSystem.Accounts.create_user(%{username: "admin", password: "Password@06", auto_password: "N", status: "ACTIVE", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
  end

  def create_enployee_role() do
    %{roleType: "EMPLOYEE", userId: 1, netPay: 10000, companyId: 1, status: "ACTIVE", clientId: 1, inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now}
    |> LoanSavingsSystem.Accounts.create_user_role()
  end

  def create_offtacker_role() do
    %{roleType: "OFFTAKER", userId: 1, status: "ACTIVE", netPay: 10000,  clientId: 1, companyId: 1, inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now}
    |> LoanSavingsSystem.Accounts.create_user_role()
  end

  def create_enployer_role() do
    %{roleType: "EMPLOYER", userId: 1, netPay: 10000, companyId: 1, status: "ACTIVE", clientId: 1, inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now}
    |> LoanSavingsSystem.Accounts.create_user_role()
  end

  def create_sme_role() do
    %{roleType: "SME", userId: 1, netPay: 10000, companyId: 1, status: "ACTIVE", clientId: 1, inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now}
    |> LoanSavingsSystem.Accounts.create_user_role()
  end

  def create_super_role() do
    %{roleType: "ADMIN", userId: 1, status: "ACTIVE", clientId: 1, inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now}
    |> LoanSavingsSystem.Accounts.create_user_role()
  end

  def create_individual_role() do
    %{roleType: "INDIVIDUAL", userId: 1, status: "ACTIVE", clientId: 1, inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now}
    |> LoanSavingsSystem.Accounts.create_user_role()
  end

  def create_user_bio() do
    LoanSavingsSystem.Client.create_user_bio_data(%{firstName: "Davies", lastName: "Phiri", otherName: "Dolben", userId: 1, emailAddress: "admin@probasegroup.com", meansOfIdentificationType: "NRC", meansOfIdentificationNumber: "100101/101/1", gender: "MALE", mobileNumber: "0978242442", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now})
  end

  def create_client() do
    %{ussdCode: "*245#", bankId: 1, isBank: "1", isDomicileAccountAtBank: "1",  countryId: 1, accountCreationEndpoint: "Bank", balanceEnquiryEndpoint: "10", fundsTransferEndpoint: "Bank", defaultCurrencyId: 1, defaultCurrencyName: "ZMW", defaultCurrencyDecimals: 1, clientName: "Victor", contact_email: "admin@probasegroup.com", contact_url: "MFZ", status: "ACTIVE", inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now}
    |> LoanSavingsSystem.Client.create_clients()

  end

  def create_client_telco() do
    %{telcoId: 1, clientId: 1, accountVersion: 1, ussdShortCode: "*245#", domain: "mfz.com",  inserted_at: NaiveDateTime.utc_now, updated_at: NaiveDateTime.utc_now}
    |> LoanSavingsSystem.SystemSetting.create_client_telco()
  end

  def create_company() do
    %{
      companyName: "ProBase",
      contactPhone: "09777777777",
      registrationNumber: "0000000",
      taxNo: "999999999",
      contactEmail: "test@mfz.com",
      isEmployer: true,
      isSme: true,
      isOffTaker: false,
      createdByUserId: 1,
      createdByRoleId: 1,
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now,
      updated_at: NaiveDateTime.utc_now
        }
    |> LoanSavingsSystem.Companies.create_company()
  end



end
