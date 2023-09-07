defmodule Loanmanagementsystem.Repo.Migrations.ModifyEmployeeTable do
  use Ecto.Migration

  def up do
    alter table(:tbl_employee) do
      add :uploafile_name, :string
    end
  end

  def down do
    alter table(:tbl_employee) do
      remove :uploafile_name
    end
  end
end
