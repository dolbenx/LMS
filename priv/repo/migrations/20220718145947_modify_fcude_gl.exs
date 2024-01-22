defmodule Savings.Repo.Migrations.ModifyFcudeGl do
  use Ecto.Migration

  def up do
    alter table(:fcube_general_ledger) do
      add :status, :string
    end
  end

  def down do
    alter table(:fcube_general_ledger) do
      remove :status
    end
  end
end
