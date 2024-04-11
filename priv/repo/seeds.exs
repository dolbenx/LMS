alias Loanmanagementsystem.{Accounts, Settings}
alias Loanmanagementsystem.Accounts.UserRole
alias Loanmanagementsystem.Accounts.{User, Role, UserRole, UserBioData}
alias Loanmanagementsystem.Settings.ConfigSettings

encode_data = fn data -> data |> Poison.encode!() end

multiple = Ecto.Multi.new()

post_send = fn query, text ->
  Loanmanagementsystem.Repo.transaction(query)
  |> case do
    {:ok, _} ->
      IO.inspect(":ok", label: text)

    {:error, v, error, _} ->
      IO.inspect(error, label: :error)
      IO.inspect(v, label: :function)
  end
end

###############################################################################################################################

# users = [
#     %{
#       username: "dolben800@gmail.com",
#       password: Pbkdf2.hash_pwd_salt("Password@06"),
#       auto_password: "N",
#       is_admin: true,
#       is_employee: false,
#       is_employer: false,
#       is_offtaker: false,
#       is_rm: false,
#       is_sme: false,
#       password_fail_count: 0,
#       role_id: 1,
#       status: "ACTIVE",
#       inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
#       updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
#   }
# ]

# multiple
# |> Ecto.Multi.insert_all(:user, User, users)
# |> post_send.("USER-LOGIN")

Accounts.register_user(
  %{
    username: "dolben800@gmail.com",
    password: "Password@06",
    auto_password: "N",
    is_admin: true,
    is_employee: false,
    is_employer: false,
    is_offtaker: false,
    is_rm: false,
    is_sme: false,
    password_fail_count: 0,
    role_id: 1,
    status: "ACTIVE"
    # inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
    # updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  }
)


###############################################################################################################################

roles = [
    %{
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
      inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  }
]

multiple
|> Ecto.Multi.insert_all(:role, Role, roles)
|> post_send.("USER-ROLE")


###############################################################################################################################

userRoles = [
  %{
      role_type: "ADMIN",
      user_id: 1,
      status: "ACTIVE",
      inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
      updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  }
]

multiple
|> Ecto.Multi.insert_all(:userRole, UserRole, userRoles)
|> post_send.("USER-ROLE-ATTACH")

###############################################################################################################################

userBios = [
  %{
    first_name: "Davies",
    last_name: "Phiri",
    other_name: "Dolben",
    user_id: 1,
    email_address: "dolben800@gmail.com",
    id_type: "NRC",
    id_number: "102030/10/1",
    gender: "MALE",
    mobile_number: "260978242442",
    marital_status: "SINGLE",
    accept_conditions: true,
    age: 18,
    nationality: "ZAMBIAN",
    number_of_dependants: 4,
    title: "MR",
    inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
    updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  }
]

multiple
|> Ecto.Multi.insert_all(:userBio, UserBioData, userBios)
|> post_send.("USER-BIO-DATA")

###############################################################################################################################

configs = [
  %{
    name: "login_failed_attempts_max",
    value_type: "times",
    value: "3",
    description: "Maxmum login attempt count",
    inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
    updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  },
  %{
    name: "user_inactive_session_notification",
    value_type: "minutes",
    value: "100",
    description: "Notify the user when the page is inactive in x interval",
    inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
    updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  },
  %{
    name: "inactive_user_model_timeout",
    value_type: "minutes",
    value: "100",
    description: "Notify the user when the page is inactive in x interval",
    inserted_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second),
    updated_at: NaiveDateTime.truncate(NaiveDateTime.utc_now(), :second)
  }
]


multiple
|> Ecto.Multi.insert_all(:config, ConfigSettings, configs)
|> post_send.("CONFIGURATIONS")

###############################################################################################################################
