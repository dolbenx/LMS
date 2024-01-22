defmodule Loanmanagementsystem.Repo.Migrations.AlteredTblCompanyByAddingSector do
  use Ecto.Migration

  def up do
    alter table(:tbl_company) do
      add :business_sector, :string
    end
  end

  def down do
    alter table(:tbl_company) do
      remove :business_sector, :string
    end
  end
end
