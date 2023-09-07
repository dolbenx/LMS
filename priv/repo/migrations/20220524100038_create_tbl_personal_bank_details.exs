defmodule Loanmanagementsystem.Repo.Migrations.CreateTblPersonalBankDetails do
  use Ecto.Migration

  def change do
    create table(:tbl_personal_bank_details) do
      add :bankName, :string
      add :branchName, :string
      add :accountNumber, :string
      add :accountName, :string
      add :upload_bank_statement, :string
      add :userId, :integer
      add :bank_id, :integer
      add :mobile_number, :string

      timestamps()
    end
  end
end
