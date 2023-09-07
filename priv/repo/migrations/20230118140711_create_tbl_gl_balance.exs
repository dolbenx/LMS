defmodule Loanmanagementsystem.Repo.Migrations.CreateTblGlBalance do
  use Ecto.Migration

  def change do
    create table(:tbl_gl_balance) do
      add :account_gl_number, :string
      add :account_gl_name, :string
      add :gl_type, :string
      add :gl_date, :date
      add :node, :string
      add :gl_category, :string
      add :currency, :string
      add :fin_year, :string
      add :fin_period, :string
      add :dr_balance, :decimal
      add :cr_balance, :decimal

      timestamps()
    end

  end
end
