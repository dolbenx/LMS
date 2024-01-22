defmodule Loanmanagementsystem.Repo.Migrations.AlterUserBoiAddEmployeeNo do
  use Ecto.Migration

  def change do
    alter table(:tbl_user_bio_data) do
      add :employee_number, :string
    end
  end
end
