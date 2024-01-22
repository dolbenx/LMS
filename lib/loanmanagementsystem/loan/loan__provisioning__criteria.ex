defmodule Loanmanagementsystem.Loan.Loan_Provisioning_Criteria do
   use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_loan_provisioning_criteria" do
    field :category, :string
    field :criteriaName, :string
    field :expense_account_id, :string
    field :liability_account_id, :string
    field :maxAge, :string
    field :minAge, :string
    field :percentage, :string
    field :productId, :integer

    timestamps()
  end

  @doc false
  def changeset(loan__provisioning__criteria, attrs) do
    loan__provisioning__criteria
    |> cast(attrs, [
      :criteriaName,
      :productId,
      :minAge,
      :maxAge,
      :percentage,
      :liability_account_id,
      :expense_account_id,
      :category
    ])

    # |> validate_required([:criteriaName, :productId, :minAge, :maxAge, :percentage, :liability_account_id, :expense_account_id, :category])
  end
end
