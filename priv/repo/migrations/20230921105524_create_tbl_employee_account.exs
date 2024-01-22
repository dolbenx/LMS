defmodule Loanmanagementsystem.Repo.Migrations.CreateTblEmployeeAccount do
  use Ecto.Migration

  def change do
    create table(:tbl_employee_account) do
      add :employee_id, :integer
      add :employee_number, :string
      add :balance, :float
      add :status, :string
      add :limit, :float

      timestamps()
    end

  end
end
