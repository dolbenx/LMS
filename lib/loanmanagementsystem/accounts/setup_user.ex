defmodule Loanmanagementsystem.SetUser do
  # Loanmanagementsystem.SetUser.super()
  # Loanmanagementsystem.SetUser.employer()
  # Loanmanagementsystem.SetUser.employee()
  # Loanmanagementsystem.SetUser.sme()
  # Loanmanagementsystem.SetUser.individual()
  # Loanmanagementsystem.SetUser.offtaker()

  def super() do
    create_super_role()
    create_user_bio()

    Loanmanagementsystem.Accounts.create_user(%{
      username: "admin@probasegroup.com",
      password: "Password@06",
      auto_password: "N",
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  def create_super_role() do
    %{
      roleType: "ADMIN",
      userId: 1,
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Loanmanagementsystem.Accounts.create_user_role()
  end

  def create_user_bio() do
    Loanmanagementsystem.Accounts.create_user_bio_data(%{
      firstName: "Mizeck",
      lastName: "Tembo",
      otherName: "Victor",
      userId: 1,
      emailAddress: "admin@probase.com",
      meansOfIdentificationType: "NRC",
      meansOfIdentificationNumber: "100101/101/1",
      gender: "MALE",
      mobileNumber: "0978659654",
      accept_conditions: false,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  # EMPLOYER

  def employer() do
    create_employer_role()
    create_employer_user_bio()

    Loanmanagementsystem.Accounts.create_user(%{
      username: "employer@probasegroup.com",
      password: "Password@06",
      auto_password: "N",
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  def create_employer_role() do
    %{
      roleType: "EMPLOYER",
      userId: 2,
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Loanmanagementsystem.Accounts.create_user_role()
  end

  def create_employer_user_bio() do
    Loanmanagementsystem.Accounts.create_user_bio_data(%{
      firstName: "Shuko",
      lastName: "Njobvu",
      otherName: "Mwale",
      userId: 2,
      emailAddress: "employer@probasegroup.com",
      meansOfIdentificationType: "NRC",
      meansOfIdentificationNumber: "100101/10/2",
      gender: "MALE",
      mobileNumber: "0966866400",
      accept_conditions: false,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  # EMPLOYEE

  def employee() do
    create_employee_role()
    create_employee_user_bio()
    create_employee_account()

    Loanmanagementsystem.Accounts.create_user(%{
      username: "employee@probasegroup.com",
      password: "Password@06",
      auto_password: "N",
      status: "ACTIVE",
      company_id: 1,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  def create_employee_role() do
    %{
      roleType: "EMPLOYEE",
      userId: 3,
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Loanmanagementsystem.Accounts.create_user_role()
  end

  def create_employee_account() do
    %{
      account_number: "123456789",
      status: "ACTIVE",
      user_id: 3,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Loanmanagementsystem.Accounts.create_customer_account()
  end

  def create_employee_user_bio() do
    Loanmanagementsystem.Accounts.create_user_bio_data(%{
      firstName: "Shuko",
      lastName: "Njobvu",
      otherName: "Mwale",
      userId: 3,
      emailAddress: "mwale@gmail.com",
      meansOfIdentificationType: "NRC",
      meansOfIdentificationNumber: "30101/10/3",
      gender: "MALE",
      mobileNumber: "09773711",
      accept_conditions: false,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  # SME

  def sme() do
    create_sme_role()
    create_sme_user_bio()

    Loanmanagementsystem.Accounts.create_user(%{
      username: "muhammadchanda9@gmail.com",
      password: "Password@06",
      auto_password: "N",
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  def create_sme_role() do
    %{
      roleType: "SME",
      userId: 4,
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Loanmanagementsystem.Accounts.create_user_role()
  end

  def create_sme_user_bio() do
    Loanmanagementsystem.Accounts.create_user_bio_data(%{
      firstName: "Muhammad",
      lastName: "Chanda",
      otherName: "Momo",
      userId: 4,
      emailAddress: "muhammadchanda9@gmail.com",
      meansOfIdentificationType: "NRC",
      meansOfIdentificationNumber: "370342/51/1",
      gender: "MALE",
      accept_conditions: false,
      mobileNumber: "0975042546",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  # OFFTAKER

  def offtaker() do
    create_offtaker_role()
    create_offtaker_user_bio()

    Loanmanagementsystem.Accounts.create_user(%{
      username: "offtaker@probasegroup.com",
      password: "Password@06",
      auto_password: "N",
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  def create_offtaker_role() do
    %{
      roleType: "OFFTAKER",
      userId: 5,
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Loanmanagementsystem.Accounts.create_user_role()
  end

  def create_offtaker_user_bio() do
    Loanmanagementsystem.Accounts.create_user_bio_data(%{
      firstName: "Shuko",
      lastName: "Njobvu",
      otherName: "Mwale",
      userId: 5,
      accept_conditions: false,
      emailAddress: "shuko.n@gmail.com",
      meansOfIdentificationType: "NRC",
      meansOfIdentificationNumber: "100101/10/5",
      gender: "MALE",
      mobileNumber: "0966866433",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  # OFFTAKER

  def individual() do
    create_individual()
    create_individual_user_bio()

    Loanmanagementsystem.Accounts.create_user(%{
      username: "mfula@gmail.com",
      password: "Password@06",
      auto_password: "N",
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  def create_individual() do
    %{
      roleType: "INDIVIDUALS",
      userId: 6,
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Loanmanagementsystem.Accounts.create_user_role()
  end

  def create_individual_user_bio() do
    Loanmanagementsystem.Accounts.create_user_bio_data(%{
      firstName: "John",
      lastName: "Mfula",
      otherName: "Bwalya",
      userId: 6,
      accept_conditions: false,
      emailAddress: "mfula@gmail.com",
      meansOfIdentificationType: "NRC",
      meansOfIdentificationNumber: "100104/10/6",
      gender: "MALE",
      mobileNumber: "0966466455",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end
end
