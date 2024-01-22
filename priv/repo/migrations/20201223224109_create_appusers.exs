defmodule LoanSystem.Repo.Migrations.CreateAppusers do
  use Ecto.Migration

  def change do
    create table(:appusers) do
      add :staff_id, :integer
      add :mobile_number, :string
      add :password, :string
      add :status, :string
      add :password_fail_count, :integer

      timestamps()
    end

  end
end
