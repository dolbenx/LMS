defmodule LoanSavingsSystem.Repo.Migrations.CreateTblClientTelco do
  use Ecto.Migration

  def change do
    create table(:tbl_client_telco) do
      add :telcoId, :integer
      add :clientId, :integer
      add :accountVersion, :float
      add :ussdShortCode, :string
      add :domain, :string

      timestamps()
    end

  end
end
