defmodule Loanmanagementsystem.SetUser.SetUser do
  # Loanmanagementsystem.SetUser.SetUser.super()

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
end
