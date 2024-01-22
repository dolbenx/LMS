defmodule LoanSavingsSystem.Repo.Migrations.CreateTblUssdLogs do
  use Ecto.Migration

  def change do
    create table(:tbl_ussd_logs) do
      add :userId, :integer
      add :action, :string
      add :status, :string
      add :parentRoute, :string
      add :details, :string
	  add :mobileNo, :string

      timestamps()
    end

  end
end
