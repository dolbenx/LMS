defmodule LoanSavingsSystem.Repo.Migrations.CreateTblGlAccount do
  use Ecto.Migration

  def change do
    create table(:tbl_gl_account) do
      add :accountType, :string
      add :accountName, :string
      add :accountNumber, :string
      add :accountSubType, :string
      add :clientId, :integer
      add :createdByUserId, :integer

      timestamps()
    end

  end
end
