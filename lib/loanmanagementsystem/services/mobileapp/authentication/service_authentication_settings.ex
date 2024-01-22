defmodule Loanmanagementsystem.AuthenticationServices.AuthenticateSettings do
  alias Loanmanagementsystem.Notifications.Messages
  alias Loanmanagementsystem.Accounts.User
  alias Loanmanagementsystem.Accounts
  alias Loanmanagementsystem.Auth
  alias Loanmanagementsystem.Emails.Email
  alias LoanmanagementsystemWeb.UserController
  alias Loanmanagementsystem.Administration.SttmCustomer
  alias Loanmanagementsystem.Administration
  alias Loanmanagementsystem.{Repo, Logs.UserLogs}
  alias Loanmanagementsystem.Notifications.Sms
  alias Loanmanagementsystem.Accounts.UserBioData


  def change_password(
        conn,
        %{"current_password" => current_password, "new_password" => new_password}
      ) do
    user = conn.assigns.current_user
    case Auth.confirm_password(user,  String.trim(current_password)) do
      {:error, _reason} ->
        Messages.error_message("Invalid Current Password")
      {:ok, _reason} ->
        case Auth.confirm_password(user,  String.trim(new_password)) do
          {:ok, _reason} ->
            Messages.error_message("Current Password and New Password can't be the same")
          {:error, _reason} ->
            Ecto.Multi.new()
            |> Ecto.Multi.update(:user, User.changeset(user, %{password: new_password}))
            |> Repo.transaction()
            |> case do
              {:error, message} -> Messages.error_message(message)
              {:ok, _} ->
                msg = "\"#{conn.assigns.current_user.username}\" Successfully Changed Password "
                UserController.success_login_activity(conn, user, msg)
                Messages.success_message("Successfully Changed Password", %{})
            end
        end
    end
  end

  def forgot_password(
      conn,
      %{"email" => email}
    ) do
     case UserBioData.exists?(emailAddress: email)  do
        true ->
          user_id = try do UserBioData.find_by(emailAddress: email).userId rescue _-> "" end
          username = try do User.find_by(id: user_id).username rescue _-> "" end
       case Accounts.get_user_by_username_api(username) do
        [] ->
          Messages.error_message("User does not exist")
          user_kyc ->
          user = try do User.find_by(username: username) rescue _-> "" end
          if  user_kyc.status == "ACTIVE"  do
            pwd = UserController.random_string
            full_name = if user_kyc.firstname == nil && user_kyc.lastname == nil do "Customer" else "#{user_kyc.firstname} #{user_kyc.lastname}" end
              Ecto.Multi.new()
              |> Ecto.Multi.update(:user, User.changeset(user, %{password: pwd}))
              |> Repo.transaction()
              |> case do
                {:error, message} -> Messages.error_message(message)
                {:ok, _} ->
                  msgsms_log = %{
                    status: "READY",
                    msg:  "Dear #{user_kyc.firstname} #{user_kyc.lastname}, Your User Account Password for GNC LMS has been reset. Your Username is: #{user_kyc.username} and password is: #{pwd}",
                    mobile: "#{user_kyc.mobilenumber}",
                    msg_count: "1",
                    type: "SMS"
                  }
                  Sms.changeset(%Sms{}, msgsms_log)
                  |> Repo.insert()
                  Email.reset_user_password_via_app(email, pwd, username, full_name)
                  msg = "#{user_kyc.firstname} #{user_kyc.lastname} Password Reset was successfully"
                  UserController.success_login_activity(conn, user_kyc, msg)
                  Messages.success_message("Instructions have been sent to you via Email and SMS", %{})
              end
          else
            Messages.user_blocked()
          end
       end
      false ->
        Messages.error_message("User does not exist")
      end
  end

  def confirm_otp(_conn,%{"otp" => otp}) do
      if User.exists?(verification_code: otp) == true  do
      case User.exists?(verification_code: otp)  do
        true ->
          users = handle_user_details(otp)
          Messages.success_message("valid OTP User Details", %{user: users})
        false ->
         Messages.error_message("Invalid OTP")
      end
     else if User.exists?(otp: otp) == true  do
      case User.exists?(otp: otp)  do
        true ->
          users = handle_user_details_otp(otp)
          Messages.success_message("valid OTP User Details", %{user: users})
        false ->
         Messages.error_message("Invalid OTP")
      end
     else
      Messages.error_message("Invalid OTP")
     end
   end
  end

  defp handle_user_details(otp) do
    user = try do User.find_by(verification_code: otp) rescue _-> "" end
    %{
      id: user.id,
      username: user.username,
      name: user.first_name <> " " <> user.last_name,
      phone: user.phone,
      email: user.email,
      customer_no: user.customer_no
    }
  end

  defp handle_user_details_otp(otp) do
    user = try do User.find_by(otp: otp) rescue _-> "" end
    %{
      id: user.id,
      username: user.username,
      name: user.first_name <> " " <> user.last_name,
      phone: user.phone,
      email: user.email,
      customer_no: user.customer_no
    }
  end

  def generate_verification_code do
    spec =Enum.to_list(?1..?9)
    length = 6
    to_string(Enum.take_random(spec, length))
  end

  def list_contact_details(conn, _params) do
    username = try do conn.assigns.current_user.username rescue _-> "" end
    contact_details = Accounts.customer_contact_details(username)
    Messages.success_message("User Details", %{userdetails: contact_details})
  end

  def update_contact_details(conn, params) do
    customer_id = try do conn.assigns.current_user.id rescue _-> "" end
    contact_details = Administration.get_sttm_customer!(params["id"])
    user_details = Accounts.get_user!(customer_id)
    Ecto.Multi.new()
    |> Ecto.Multi.update(:user_details, User.changeset(user_details, %{phone: params["mobile_number"]}))
    |> Ecto.Multi.update(:contact_details, SttmCustomer.changeset(contact_details, params))
    |> Ecto.Multi.run(:user_log, fn(_, %{contact_details: _contact_details}) ->
        activity = "Contact Details Updated with Customer number #{conn.assigns.current_user.customer_no}\" Via - App Channel"
        user_log = %{
          user_id:  conn.assigns.current_user.id,
          activity: activity
          }
      UserLogs.changeset(%UserLogs{}, user_log)
      |> Repo.insert()
    end)
    |> Repo.transaction()
    |> case do
      {:ok, %{contact_details: _contact_details, user_log: _user_log}} ->
        Messages.success_message("Successfully Updated Contacts", %{})
      {:error, _failed_operation, failed_value, _changes_so_far} ->
        reason = traverse_errors(failed_value.errors) |> List.first()
        Messages.error_message(reason)
    end
  end

  def log_out_user(_conn, _params) do
    # UserContext.log_out(conn)
    Messages.success_message("Logged Out Successfully", %{})
  end

  def traverse_errors(errors) do
    for {key, {msg, _opts}} <- errors, do: "#{key} #{msg}"
  end

  def transaction_auth(user, %{"auth_text" => auth_text, "auth_type" => auth_type}) do
    case auth_type do
      "PASS" -> Auth.confirm_password(user,  String.trim(auth_text))
      _ -> false
    end
  end

end
