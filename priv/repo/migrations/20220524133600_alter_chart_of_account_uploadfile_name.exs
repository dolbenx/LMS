defmodule Loanmanagementsystem.Repo.Migrations.AlterChartOfAccountUploadfileName do
  use Ecto.Migration

  def change do
    alter table(:tbl_chart_of_accounts) do
      add :uploafile_name, :string
    end
  end
end
