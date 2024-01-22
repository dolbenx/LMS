defmodule LoanSystem.Repo.Migrations.CreateCharges do
  use Ecto.Migration

  def change do
    create table(:charges) do
      add :name, :string
      add :type, :string
      add :valuation, :float
      add :applicable_during_disbursement, :boolean, default: false
      add :is_penalty, :boolean, default: false

      timestamps()
    end

  end
end
