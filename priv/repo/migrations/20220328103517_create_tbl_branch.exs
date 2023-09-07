defmodule Loanmanagementsystem.Repo.Migrations.CreateTblBranch do
  use Ecto.Migration

  def change do
    create table(:tbl_branch) do
      add :branchName, :string
      add :branchCode, :string
      add :isDefaultUSSDBranch, :boolean, default: false, null: false
      add :clientId, :integer
      add :status, :string
      add :created_by, :integer
      add :approved_by, :integer
      add :province, :string
      add :city, :string
      add :branchAddress, :string
      timestamps()
    end
  end
end
