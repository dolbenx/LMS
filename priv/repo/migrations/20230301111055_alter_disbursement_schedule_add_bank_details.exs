defmodule Loanmanagementsystem.Repo.Migrations.AlterDisbursementScheduleAddBankDetails do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_disbursement_schedule) do
      add :account_name, :string
      add :swiftcode, :string
      add :mno_provider, :string
      add :mobile_number, :string

    end

  end
end
