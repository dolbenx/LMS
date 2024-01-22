defmodule Loanmanagementsystem.Repo.Migrations.AlterEodEntriesTblAsAt140823 do
  use Ecto.Migration

  def up do
    alter table(:tbl_end_of_day_entries) do
      add :eod_ref_no, :string
    end
  end

  def down do
    alter table(:tbl_end_of_day_entries) do
      remove_if_exists(:eod_ref_no, :string)
    end
  end
end
