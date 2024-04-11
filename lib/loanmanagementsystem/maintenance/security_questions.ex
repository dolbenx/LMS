defmodule Loanmanagementsystem.Maintenance.Security_questions do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_security_questions" do
    field :productType, :string
    field :question, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(security_questions, attrs) do
    security_questions
    |> cast(attrs, [:question, :status, :productType])
    |> validate_required([:question, :status])

    # |> validate_required([:question, :status, :productType])
  end
end
