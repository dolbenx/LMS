defmodule Loanmanagementsystem.Notifications.Messages do
  def invalid_user_details, do: error_message("Username or Password is incorrect")

  def user_blocked,
    do: error_message("User can't access the system. Please contact customer care")

  def device_in_use,
    do: error_message_with_status("User account logged in on a different device", 601)

  def error_message(message), do: error_message_with_status(message, 1)

  def error_message_with_status(message, status),
    do: %{status: status, message: message, success: false}

  def success_message(message, data \\  %{}) do
    if data == %{} do
      %{status: 0, message: message, success: true}
    else
      %{status: 0, message: message, success: true, data: data}
    end
  end
end
