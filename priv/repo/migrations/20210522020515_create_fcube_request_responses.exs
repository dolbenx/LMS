defmodule LoanSavingsSystem.Repo.Migrations.CreateFcubeRequestResponses do
  use Ecto.Migration

  def change do
    create table(:fcube_request_responses) do
      add :request_data, :string
      add :response_data, :string

      timestamps()
    end

  end
end
