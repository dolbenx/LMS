defmodule LoanSavingsSystem.Repo.Migrations.CreateUssdRequests do
  use Ecto.Migration

  def change do
    create table(:ussd_requests) do
      add :mobile_number, :string
      add :request_data, :string
      add :session_ended, :integer
      add :session_id, :string
      add :is_logged_in, :integer

      timestamps()
    end

  end
end
