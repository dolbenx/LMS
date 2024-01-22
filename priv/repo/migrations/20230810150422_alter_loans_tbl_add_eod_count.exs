defmodule Loanmanagementsystem.Repo.Migrations.AlterLoansTblAddEodCount do
  use Ecto.Migration

  def up do
    alter table(:tbl_loans) do
      add :eod_count, :integer, default: 0
      add :eod_status, :boolean, default: false
    end
  end

  def down do
    alter table(:tbl_loans) do
      remove_if_exists(:eod_count, :integer)
      remove_if_exists(:eod_status, :boolean)
    end
  end
end
