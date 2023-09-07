defmodule Loanmanagementsystem.Repo.Migrations.AddFieldsTblLoan do
  use Ecto.Migration

  def up do
    alter table(:tbl_loans) do
      add :disbursement_method, :string
      add :bank_name, :string
      add :bank_account_no, :string
      add :account_name, :string
      add :bevura_wallet_no, :string
      add :receipient_number, :string
      add :reference_no, :string
    end
  end

  def down do
    alter table(:tbl_loans) do
      remove_if_exists(:disbursement_method, :string)
      remove_if_exists(:bank_name, :string)
      remove_if_exists(:bank_account_no, :string)
      remove_if_exists(:account_name, :string)
      remove_if_exists(:bevura_wallet_no, :string)
      remove_if_exists(:receipient_number, :string)
      remove_if_exists(:reference_no, :string)
    end
  end
end
