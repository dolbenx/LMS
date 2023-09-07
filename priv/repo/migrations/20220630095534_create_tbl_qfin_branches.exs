defmodule Loanmanagementsystem.Repo.Migrations.CreateTblQfinBranches do
  use Ecto.Migration

  def change do
    create table(:tbl_qfin_branches) do
      add :name, :string
      add :branchCode, :string
      add :branchAddress, :string
      add :city, :string
      add :province, :string
      add :status, :string

      timestamps()
    end
  end
end
