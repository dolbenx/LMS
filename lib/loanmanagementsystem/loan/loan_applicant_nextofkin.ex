defmodule Loanmanagementsystem.Loan.Loan_applicant_nextofkin do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_loan_nextofkin" do
    field :consent_crb, :string
    field :customer_id, :integer
    field :firstname, :string
    field :gender, :string
    field :mobile_no, :string
    field :relationship, :string
    field :surname, :string

    timestamps()
  end

  @doc false
  def changeset(loan_applicant_nextofkin, attrs) do
    loan_applicant_nextofkin
    |> cast(attrs, [:customer_id, :firstname, :surname, :relationship, :mobile_no, :consent_crb, :gender])
    # |> validate_required([:customer_id, :firstname, :surname, :relationship, :mobile_no, :consent_crb, :gender])
  end
end
