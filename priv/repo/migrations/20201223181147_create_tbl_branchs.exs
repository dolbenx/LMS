defmodule LoanSystem.Repo.Migrations.CreateTblBranchs do
  use Ecto.Migration

  def change do
    create table(:tbl_branchs) do
      add :branch_name, :string
      add :branch_address, :string
      add :branch_province, :string
      add :branch_district, :string
      add :parent_branch_id, :integer
      add :opening_date, :date

      timestamps()
    end

  end
end
