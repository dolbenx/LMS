defmodule Savings.Repo.Migrations.CreateTblBranch do
  use Ecto.Migration

  def change do
    create table(:tbl_branch) do
      add :branchName, :string
      add :branchCode, :string
      add :isDefaultUSSDBranch, :boolean, default: false, null: false
      add :status, :string

      timestamps()
    end
  end
end
