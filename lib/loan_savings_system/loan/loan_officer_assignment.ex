defmodule LoanSavingsSystem.Loan.LoanOfficerAssignment do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_loan_officer_assignment" do
    field :created_date, :date
    field :createdby_id, :integer
    field :end_date, :date
    field :lastmodifiedby_id, :integer
    field :loan_id, :integer
    field :loan_officer_id, :integer
    field :start_date, :date
    field :updated_date, :date

    timestamps()
  end

  @doc false
  def changeset(loan_officer_assignment, attrs) do
    loan_officer_assignment
    |> cast(attrs, [:loan_id, :loan_officer_id, :start_date, :end_date, :createdby_id, :created_date, :updated_date, :lastmodifiedby_id])
    |> validate_required([:loan_id, :loan_officer_id, :start_date, :end_date, :createdby_id, :created_date, :updated_date, :lastmodifiedby_id])
  end
end
