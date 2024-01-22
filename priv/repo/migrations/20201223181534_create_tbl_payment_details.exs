defmodule LoanSystem.Repo.Migrations.CreateTblPaymentDetails do
  use Ecto.Migration

  def change do
    create table(:tbl_payment_details) do
      add :payment_type_id, :integer
      add :account_number, :string
      add :cheque_number, :string
      add :receipt_number, :string
      add :bank_number, :string
      add :routing_code, :string
      add :debit_gl_account_id, :integer
      add :credit_gl_account_id, :integer

      timestamps()
    end

  end
end
