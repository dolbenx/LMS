defmodule Loanmanagementsystem.Repo.Migrations.CreateTblRequestLogs do
  use Ecto.Migration

  def change do
    create table(:tbl_request_logs) do
      add :request_type, :string
      add :request, :string
      add :response, :string
      add :request_time, :utc_datetime
      add :response_time, :utc_datetime

      timestamps()
    end

    alter table(:tbl_request_logs) do
      modify :request, :text
      modify :response, :text
    end
  end
end
