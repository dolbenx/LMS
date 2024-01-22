defmodule LoanSavingsSystem.Repo.Migrations.CreateFlexcubelogs do
  use Ecto.Migration

  def change do
    create table(:flexcubelogs) do
      add :action_type, :string
      add :endpoint, :string
      add :request, :string
      add :response_data, :string
      add :status, :string
      add :value_date, :string
      add :dr_gl_account_code, :string
      add :cr_gl_account_code, :string
      add :amount_posted, :float

      timestamps()
    end

  end
end
