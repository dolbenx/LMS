defmodule Loanmanagementsystem.SetUser.SetUser do
  # Loanmanagementsystem.SetUser.SetUser.super()
  # Loanmanagementsystem.SetUser.SetUser.employer()
  # Loanmanagementsystem.SetUser.SetUser.individual()
  # Loanmanagementsystem.SetUser.SetUser.employee()
  # Loanmanagementsystem.SetUser.SetUser.sme()



  # ADMIN #
  def super() do
    create_role =
      Loanmanagementsystem.Accounts.create_role(%{
        role_desc: "SUPER ADMIN",
        role_group: "SUPER ADMIN",
        role_str: %{
          "loan": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "user": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "email": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "client": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "charges": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "holiday": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "product": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "reports": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "calender": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "currency": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "countries": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "dashboard": %{
            "admin": "Y",
            "individual": "N"
          },
          "user_logs": %{
            "view": "Y"
          },
          "change_mgt": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "bank_branch": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "system_user": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "transaction": %{
            "view": "Y",
            "change_status": "Y"
          },
          "sms_settings": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "financial_mgt": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "maker_checker": %{
            "maker": "Y",
            "checker": "Y"
          },
          "company_branches": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "relationship_mgt": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "security_question": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          },
          "user_role_maintenance": %{
            "edit": "Y",
            "view": "Y",
            "create": "Y",
            "change_status": "Y"
          }
        },
        status: "ACTIVE",
        inserted_at: NaiveDateTime.utc_now(),
        updated_at: NaiveDateTime.utc_now()
      }

      )

    case create_role do
      {:ok, create_role} ->
        role_id = create_role.id
        create_user = create_user_fxn(role_id)

        case create_user do
          {:ok, create_user} ->
            # IO.inspect(create_user, label: "Check created user \n\n\n\n")
            user_id = create_user.id

            create_super_role(user_id)
            create_user_bio(user_id)

            # create_client()
            # create_client_telco()

            IO.inspect(create_role, label: "Check created create_role \n\n\n\n")

          {:error, "create_user_reason"} ->
            "You have an error"
        end

      {:error, "create_user_reason"} ->
        "You have an error on roles"
    end
  end

  def create_user_fxn(role_id) do
    Loanmanagementsystem.Accounts.create_user(%{
      username: "admin@probasegroup.com",
      password: "Password@06",
      auto_password: "N",
      status: "ACTIVE",
      role_id: role_id,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end
  def create_super_role(user_id) do
    %{
      roleType: "ADMIN",
      userId: user_id,
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Loanmanagementsystem.Accounts.create_user_role()
  end

  def create_user_bio(user_id) do
    Loanmanagementsystem.Accounts.create_user_bio_data(%{
      firstName: "Joseph",
      lastName: "Katongo",
      otherName: "Jnr",
      userId: user_id,
      emailAddress: "admin@probasegroup.com",
      meansOfIdentificationType: "NRC",
      meansOfIdentificationNumber: "100101/101/1",
      gender: "MALE",
      mobileNumber: "0978242441",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end
  # END #

  # EMPLOYEE #

  def employee() do
    create_employee_role()
    create_employee_user_bio()
    create_employee_account()

    Loanmanagementsystem.Accounts.create_user(%{
      username: "employee@probasegroup.com",
      password: "Password@06",
      auto_password: "N",
      status: "ACTIVE",
      role_id: 1,
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
      account_number: "01",
      status: "ACTIVE",
      user_id: 3,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Loanmanagementsystem.Accounts.create_customer_account()
  end

  def create_employee_user_bio() do
    Loanmanagementsystem.Accounts.create_user_bio_data(%{
      firstName: "Muhammad",
      lastName: "Chanda",
      otherName: "Momo",
      userId: 3,
      emailAddress: "muhammad@gmail.com",
      meansOfIdentificationType: "NRC",
      meansOfIdentificationNumber: "23101/10/3",
      gender: "MALE",
      mobileNumber: "0975042512",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  # END #

  # EMPLOYER #
  def employer() do
    create_employer_role()
    create_employer_user_bio()

    Loanmanagementsystem.Accounts.create_user(%{
      username: "employer@probasegroup.com",
      password: "Password@06",
      auto_password: "N",
      status: "ACTIVE",
      role_id: 1,
      company_id: 1,
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
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end
 # END #

 # INDIVIDUAL #

 def individual() do
  create_individual()
  create_individual_user_bio()

  Loanmanagementsystem.Accounts.create_user(%{
    username: "individual@probasegroup.com",
    password: "Password@06",
    auto_password: "N",
    role_id: 1,
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
    emailAddress: "mfula@gmail.com",
    meansOfIdentificationType: "NRC",
    meansOfIdentificationNumber: "100104/10/6",
    gender: "MALE",
    mobileNumber: "0966466455",
    inserted_at: NaiveDateTime.utc_now(),
    updated_at: NaiveDateTime.utc_now()
  })
end

# END #

# OFFTAKER #

def sme() do
  create_sme_role()
  create_sme_user_bio()

  Loanmanagementsystem.Accounts.create_user(%{
    username: " victor@gmail.com",
    password: "Password@06",
    auto_password: "N",
    role_id: 1,
    status: "ACTIVE",
    inserted_at: NaiveDateTime.utc_now(),
    updated_at: NaiveDateTime.utc_now()
  })
end

def create_sme_role() do
  %{
    roleType: "SME",
    userId: 5,
    status: "ACTIVE",
    inserted_at: NaiveDateTime.utc_now(),
    updated_at: NaiveDateTime.utc_now()
  }
  |> Loanmanagementsystem.Accounts.create_user_role()
end

def create_sme_user_bio() do
  Loanmanagementsystem.Accounts.create_user_bio_data(%{
    firstName: "Victor",
    lastName: "Tembo",
    otherName: "Miz",
    userId: 5,
    emailAddress: "victor@gmail.com",
    meansOfIdentificationType: "NRC",
    meansOfIdentificationNumber: "144501/10/5",
    gender: "MALE",
    mobileNumber: "09623466433",
    inserted_at: NaiveDateTime.utc_now(),
    updated_at: NaiveDateTime.utc_now()
  })
end

# END #
end
