defmodule LoanSavingsSystem.Repo.Migrations.CreateTblRefundRequests do
  use Ecto.Migration

  def change do
    create table(:tbl_refund_requests) do
      add :loanId, :integer
      add :transactionId, :integer
      add :requestNo, :string
      add :requestedByUserId, :integer
      add :requestedByUserRoleId, :integer
      add :refundAmount, :float
      add :status, :string
      add :cancelationReason, :string
      add :canceledByUserRoleId, :integer

      timestamps()
    end

  end
end
