defmodule LoanSystem.Repo.Migrations.CreateTblUssdRequests do
  use Ecto.Migration

  def change do
    create table(:tbl_ussd_requests) do
      add :mobile_number, :string
      add :request_data, :string
      add :session_id, :string
      add :session_ended, :integer
      add :is_logged_in, :integer

      timestamps()
    end

  end
end
