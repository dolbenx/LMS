defmodule FundsMgt.AuthenticationServices.Transactions do
  @moduledoc false

  alias FundsMgt.{Notifications.Messages, Security.JwtToken}

  def index(conn, pin) do
    user = conn.assigns.current_user

    cond do
      user.pin == nil ->
        Messages.error_message("Wrong PIN")

      user.pin == pin ->
        Messages.success_message("Success", %{
          otp_key: JwtToken.Token.gen_token(user.device, %{"jnv" => user.salt}),
          exp_time: 1,
          exp_type: "minutes"
        })

      true ->
        Messages.error_message("Wrong PIN")
    end
  end
end
