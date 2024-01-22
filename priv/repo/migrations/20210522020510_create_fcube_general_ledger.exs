defmodule LoanSavingsSystem.Repo.Migrations.CreateFcubeGeneralLedger do
  use Ecto.Migration

  def change do
    create table(:fcube_general_ledger) do
      add :account_name, :string
      add :gl_account_no, :string

      timestamps()
    end

  end
end
