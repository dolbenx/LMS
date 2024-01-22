defmodule Savings.SetUser do
  # Savings.SetUser.super()

  def super() do
    create_role =
      Savings.Accounts.create_role(%{
        role_desc: "ADMIN",
        role_group: "ADMIN",
        role_str: %{
          eod: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          client: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          report: %{
            view: "Y",
            change_status: "N"
          },
          product: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          branches: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          calendar: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          chargers: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          currency: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          countries: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          user_logs: %{
            view: "Y"
          },
          transaction: %{
            view: "Y",
            change_status: "Y"
          },
          system_users: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          sec_quesstion: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          role_maintenance: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          customer: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          },
          maintenance: %{
            edit: "Y",
            view: "Y",
            create: "Y",
            change_status: "Y"
          }
        },
        status: "ACTIVE",
        inserted_at: NaiveDateTime.utc_now(),
        updated_at: NaiveDateTime.utc_now()
      })

    case create_role do
      {:ok, create_role} ->
        role_id = create_role.id
        create_user = create_user_fxn(role_id)

        case create_user do
          {:ok, create_user} ->
            # IO.inspect(create_user, label: "Check created user \n\n\n\n")
            user_id = create_user.id

            create_super_role(user_id, role_id)
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
    Savings.Accounts.create_user(%{
      username: "admin@mfz.com",
      password: "Password@06",
      auto_password: "N",
      status: "ACTIVE",
      role_id: role_id,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  def create_super_role(user_id, role_id) do
    %{
      roleType: "SUPER ADMIN",
      userId: user_id,
      status: "ACTIVE",
      clientId: 1,
      roleId: role_id,
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Savings.Accounts.create_user_role()
  end

  def create_user_bio(user_id) do
    Savings.Client.create_user_bio_data(%{
      firstName: "Probase",
      lastName: "User",
      otherName: "Solutions",
      userId: user_id,
      emailAddress: "admin@probasegroup.com",
      meansOfIdentificationType: "NRC",
      meansOfIdentificationNumber: "100000/00/0",
      gender: "MALE",
      mobileNumber: "0978242442",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    })
  end

  def create_client() do
    %{
      ussdCode: "*115#",
      bankId: 1,
      isBank: "1",
      isDomicileAccountAtBank: "1",
      countryId: 1,
      accountCreationEndpoint: "Bank",
      balanceEnquiryEndpoint: "10",
      fundsTransferEndpoint: "Bank",
      defaultCurrencyId: 1,
      defaultCurrencyName: "ZMW",
      defaultCurrencyDecimals: 1,
      clientName: "MFZ",
      contact_email: "admin@probasegroup.com",
      contact_url: "MFZ",
      status: "ACTIVE",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Savings.Client.create_clients()
  end

  def create_client_telco() do
    %{
      telcoId: 1,
      clientId: 1,
      accountVersion: 1,
      ussdShortCode: "*115#",
      domain: "mfz.com",
      inserted_at: NaiveDateTime.utc_now(),
      updated_at: NaiveDateTime.utc_now()
    }
    |> Savings.SystemSetting.create_client_telco()
  end
end
