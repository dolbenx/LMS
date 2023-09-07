defmodule Loanmanagementsystem.Repo.Migrations.ModifyLeads do
  use Ecto.Migration

  def up do
    alter table(:tbl_leads) do
      add :status, :string
    end
  end

  def down do
    alter table(:tbl_leads) do
      remove :status
    end
  end
end
