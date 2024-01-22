defmodule Loanmanagementsystem.AuthenticationServices.AuthenticateUser do
  alias Loanmanagementsystem.Accounts
  import Loanmanagementsystem.Security.JwtToken.UserAuth
  alias Loanmanagementsystem.Notifications.Messages
  alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Auth
  alias Loanmanagementsystem.Accounts.User

  def log_in(conn, %{"username" => username, "password" => enc_password} = params) do
    case User.exists?(username: username)  do
      true ->
    case Accounts.get_user_by_username_api(username) do
      [] ->
      Messages.error_message("Username or Password is incorrect")
      user_kyc ->
      if  user_kyc.status == "ACTIVE"  do
        user = try do User.find_by(username: username) rescue _-> "" end
        case Auth.confirm_password(user, String.trim(enc_password)) do
          {:error, _reason} -> attempts_validation()
          {:ok, _reason} -> user_verification(conn, user, user_kyc, params)
        end
      else
        Messages.user_blocked()
      end
    end
    false ->
      Messages.error_message("Username or Password is incorrect")
    end
  end

  defp attempts_validation do
    Messages.invalid_user_details()
  end

  defp user_verification(conn, user, user_kyc, _params) do
    msg = "#{user_kyc.firstname} #{user_kyc.lastname} successfully correct username and password"
    UserController.success_login_activity(conn, user_kyc, msg)
    |> case do
      {:ok,  _} ->
         final_login_results(user, user_kyc)
      {:error, message} ->
        Messages.error_message(message)
    end
  end

  defp final_login_results(user, user_kyc) do
    Messages.success_message("Login Successful", %{
      token: token(user),
      exp_time: 1,
      exp_type: "hours",
      user: %{
        id: user_kyc.id,
        firstname: user_kyc.firstname,
        lastname: user_kyc.lastname,
        phone: user_kyc.mobilenumber,
        email: user_kyc.emailaddress,
        gender: user_kyc.gender,
        idtype: user_kyc.idtype,
        idnumber: user_kyc.idnumber,
        role:  user_kyc.roletype

      }
    })
  end


end
