defmodule Loanmanagementsystem.Repo.Migrations.UpdateCompanysTable do
  use Ecto.Migration

  def up do
    alter table(:tbl_company) do
      add :employer_code, :string
    end
  end

  def down do
    alter table(:tbl_company) do
      remove :employer_code

    end
  end
end
