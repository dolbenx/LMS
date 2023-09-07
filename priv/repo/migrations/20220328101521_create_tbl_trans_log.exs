defmodule Loanmanagementsystem.Repo.Migrations.CreateTblTransLog do
  use Ecto.Migration

  def change do
    create table(:tbl_trans_log) do
      add :module, :string
      add :trn_ref_no, :string
      add :event, :string
      add :account_no, :string
      add :account_name, :string
      add :currency, :string
      add :drcr_ind, :string
      add :exch_rate, :string
      add :fcy_amount, :float
      add :lcy_amount, :float
      add :trn_dt, :string
      add :value_dt, :string
      add :financial_cycle, :string
      add :period_code, :string
      add :user_id, :string
      add :auth_status, :string
      add :ac_gl, :string
      add :mobile_no, :string
      add :batch_no, :string
      add :product, :string
      add :process_status, :string
      add :batch_status, :string
      add :batch_id, references(:tbl_batch_number, column: :id, on_delete: :nothing)
      add :narration, :string

      timestamps()
    end
  end
end
