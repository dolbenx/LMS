# defmodule LoanSavingsSystem.Workers.Emails do

#   import Ecto.Query, warn: false
#   alias LoanSavingsSystem.Repo
#   alias LoanSavingsSystem.Emails.Email
#   alias LoanSavingsSystem.Notifications.Emails

#   def perform do
#     case Repo.all(from m in Emails, where: m.status == ^"READY") do
#       emails -> send_emails(emails)
#       [] -> nil
#     end
#   end
#   def send_emails(emails), do: Enum.map(emails, fn map -> Email.send_sme_email(map) end)

#   def update_email_status(_resp, map) do
#     Ecto.Multi.new()
#     |> Ecto.Multi.update(:update_emails, Emails.changeset(map, %{status: "SUCCESS"}))
#     |> Repo.transaction()
#   end

# end
