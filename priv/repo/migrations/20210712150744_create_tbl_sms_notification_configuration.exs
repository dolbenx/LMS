defmodule LoanSavingsSystem.Repo.Migrations.CreateTblSmsNotificationConfiguration do
  use Ecto.Migration

  def change do
    create table(:tbl_sms_notification_configuration) do
      add :days, :integer
      add :actionType, :string
      add :numberOfSms, :integer
      add :interval, :integer
      add :intervaltype, :string
      add :message, :string
	    add :status, :string

      timestamps()
    end

  end
end
