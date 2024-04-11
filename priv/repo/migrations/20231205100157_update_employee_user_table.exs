defmodule Loanmanagementsystem.Repo.Migrations.UpdateEmployeeUserTable do
  use Ecto.Migration

  def up do
    alter table(:tbl_users) do
      add :employer_code, :string
    end
  end

  def down do
    alter table(:tbl_users) do
      remove :employer_code
    end
  end
end
