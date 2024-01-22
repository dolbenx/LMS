defmodule LoanSavingsSystem.RefundRequests.RefundRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_refund_requests" do
    field :cancelationReason, :string
    field :canceledByUserRoleId, :integer
    field :loanId, :integer
    field :refundAmount, :float
    field :requestNo, :string
    field :requestedByUserId, :integer
    field :requestedByUserRoleId, :integer
    field :status, :string
    field :transactionId, :integer

    timestamps()
  end

  @doc false
  def changeset(refund_request, attrs) do
    refund_request
    |> cast(attrs, [:loanId, :transactionId, :requestNo, :requestedByUserId, :requestedByUserRoleId, :refundAmount, :status, :cancelationReason, :canceledByUserRoleId])
    |> validate_required([:loanId, :transactionId, :requestNo, :requestedByUserId, :requestedByUserRoleId, :refundAmount, :status, :cancelationReason, :canceledByUserRoleId])
  end
end
