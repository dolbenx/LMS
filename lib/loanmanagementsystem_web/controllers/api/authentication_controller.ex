defmodule LoanmanagementsystemWeb.AuthenticationController do
  use LoanmanagementsystemWeb, :controller
  alias Loanmanagementsystem.Security.ParamsValidator

  alias Loanmanagementsystem.AuthenticationServices.{
    AuthenticateUser,
    AuthenticateSettings,
    CreateNewCustomerAccount
  }

  def authentication(conn, param) do
    params = Map.merge(param, %{"auth" => true})
    conn.method
    |> case do
      "GET" -> get(conn, params)
      "POST" -> post(conn, params)
    end
  end

  def un_authentication(conn, param) do
    params = Map.merge(param, %{"auth" => false})
    conn.method
    |> case do
      "GET" -> get(conn, params)
      "POST" -> post(conn, params)
    end
  end

  defp post(conn, %{"auth" => false, "service" => "CreateAccount"} = params) do
    ParamsValidator.validate(conn, params, %{
      "first_name" => :string,
      "last_name" => :string,
      "other_name" => :string,
      "mobile_no" => :string,
      "password" => :string
    })
    |> case do
      {:error, conn, message} -> respond(conn, message, :bad_request)
      {:ok, conn} -> json(conn, CreateNewCustomerAccount.index(conn, params))
    end
  end

  defp post(conn, %{"auth" => false, "service" => "ValidatePhoneNumber"} = params) do
    ParamsValidator.validate(conn, params, %{"mobile_number" => :string})
    |> case do
      {:error, conn, message} -> respond(conn, message, :bad_request)
      {:ok, conn} -> json(conn, CreateNewCustomerAccount.validate_phone_number(conn, params))
    end
  end

  defp post(conn, %{"auth" => false, "service" => "ValidatePhoneNumberOTP"} = params) do
    ParamsValidator.validate(conn, params, %{"otp_key" => :string, "otp" => :string})
    |> case do
      {:error, conn, message} -> respond(conn, message, :bad_request)
      {:ok, conn} -> json(conn, CreateNewCustomerAccount.validate_phone_number_otp(conn, params))
    end
  end

  defp post(conn, %{"auth" => false, "service" => "AuthenticateUser"} = params) do
    ParamsValidator.validate(conn, params, %{"username" => :string, "password" => :string})
    |> case do
      {:error, conn, message} -> respond(conn, message, :bad_request)
      {:ok, conn} -> json(conn, AuthenticateUser.log_in(conn, params))
    end
  end

  defp post(conn, %{"auth" => true, "service" => "ChangePassword"} = params) do
    ParamsValidator.validate(conn, params, %{
      "current_password" => :string,
      "new_password" => :string
    })
    |> case do
      {:error, conn, message} -> respond(conn, message, :bad_request)
      {:ok, conn} -> json(conn, AuthenticateSettings.change_password(conn, params))
    end
  end

  defp post(conn, %{"auth" => false, "service" => "ForgotPassword"} = params) do
    ParamsValidator.validate(conn, params, %{
      "email" => :string
    })
    |> case do
      {:error, conn, message} -> respond(conn, message, :bad_request)
      {:ok, conn} -> json(conn, AuthenticateSettings.forgot_password(conn, params))
    end
  end

  defp post(conn, %{"auth" => false, "service" => "ConfirmOTP"} = params) do
    ParamsValidator.validate(conn, params, %{
      "otp" => :string
    })
    |> case do
      {:error, conn, message} -> respond(conn, message, :bad_request)
      {:ok, conn} -> json(conn, AuthenticateSettings.confirm_otp(conn, params))
    end
  end

  defp get(conn, %{"auth" => true, "service" => "LogOut"} = params),
    do: json(conn, AuthenticateSettings.log_out_user(conn, params))

  defp get(conn, %{"auth" => true, "service" => "ContactDetails"} = params) do
    json(conn, AuthenticateSettings.list_contact_details(conn, params))
  end

  def respond(conn, message, status \\ :bad_request),
    do: put_status(conn, status) |> json(message)
end
