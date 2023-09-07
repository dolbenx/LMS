defmodule Loanmanagementsystem.Repo.Migrations.CreateTblChartOfAccounts do
  use Ecto.Migration

  def change do
    create table(:tbl_chart_of_accounts) do
      add :ac_gl_no, :string
      add :ac_gl_ccy, :string
      add :ac_ccy_res, :string
      add :ac_or_gl, :string
      add :cust_no, :string
      add :gl_type, :string
      add :ac_gl_descption, :string
      add :alt_ac_no, :string
      add :cust_name, :string
      add :gl_category, :string
      add :overall_limit, :string
      add :revaluation, :string
      add :ac_open_date, :string
      add :gl_post_type, :string
      add :branch_code, :string
      add :gl_branch_res, :string
      add :ac_status, :string
      add :auth_status, :string
      add :leaf_or_node, :string
      add :node_gl, :string

      timestamps()
    end

    create unique_index(:tbl_chart_of_accounts, [:ac_gl_no])
  end
end
