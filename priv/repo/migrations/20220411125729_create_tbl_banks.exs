defmodule Loanmanagementsystem.Repo.Migrations.CreateTblBanks do
  use Ecto.Migration

  def change do
    create table(:tbl_banks) do
      add :acronym, :string
      add :bank_descrip, :string
      add :center_code, :string
      add :bank_code, :string
      add :process_branch, :string
      add :swift_code, :string
      add :bankName, :string
      add :status, :string

      timestamps()
    end
  end
end
