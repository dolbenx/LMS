defmodule Loanmanagementsystem.AuthenticationServices.CreateNewCustomerAccount do
  alias Loanmanagementsystem.{TextMessagesContext, UserContext}
  alias Loanmanagementsystem.{Notifications.Messages, Security.JwtToken.Token, Utility.Randomizer}

  def index(conn, params) do
    UserContext.create_new_customer(params)
    |> case do
      {:ok, _} -> Messages.success_message("Successfully Created Account", %{})
      {:error, error} -> Messages.error_message(error)
    end
  end

  def validate_phone_number(conn, %{"mobile_number" => mobile_number}) do
    case Loanmanagementsystem.UserContext.validate_mobile(mobile_number) do
      nil ->
        opt = Randomizer.randomizer(6, :numeric)

        data =
          TextMessagesContext.save_message(
            "<#> Please verify your account using this OTP code - #{opt} \n Assy6BMSNY0",
            mobile_number
          )

        Messages.success_message(
          "Request sent successfully",
          %{
            otp_key:
              Token.gen_token(
                UserContext.get_device(conn),
                %{"jnv" => data.id, "key" => Bcrypt.hash_pwd_salt(opt), "phn" => mobile_number}
              ),
            exp_time: 5,
            exp_type: "minutes"
          }
        )

      _ ->
        Messages.error_message_with_status("Account already exist with this mobile number", 1)
    end
  end

  def validate_phone_number_otp(conn, %{"otp_key" => otp_key, "otp" => otp}) do
    Token.check_token(UserContext.get_device(conn), otp_key)
    |> case do
      {:error, [message: _, claim: _, claim_val: _]} ->
        Messages.error_message("Code is expired")

      {:error, :signature_error} ->
        Messages.error_message_with_status("Invalid otp key", 601)

      {:ok, claims} ->
        Bcrypt.verify_pass(otp, claims["key"])
        |> case do
          true ->
            Messages.success_message("Phone number validated successfully", %{
              mobile_number: claims["phn"]
            })

          false ->
            Messages.error_message("Invalid OTP Code")
        end
    end
  end
end
