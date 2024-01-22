defmodule Loanmanagementsystem.Repo.Migrations.AlterEodEntryTblAsAt140823 do
  use Ecto.Migration

  def up do
    alter table(:tbl_end_of_day) do
      add :eod_ref_no, :string
    end
  end

  def down do
    alter table(:tbl_end_of_day) do
      remove_if_exists(:eod_ref_no, :string)
    end
  end
end
