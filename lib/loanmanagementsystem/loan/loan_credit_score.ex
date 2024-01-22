defmodule Loanmanagementsystem.Loan.Loan_credit_score do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_loan_credit_score" do
    field :applicant_character, :string
    field :applicant_name, :string
    field :borrowing_history, :string
    field :business_employment_experience, :string
    field :collateral_assessment, :string
    field :credit_analyst, :string
    field :cro_staff, :string
    field :customer_id, :integer
    field :date_of_credit_score, :date
    field :dti_ratio, :string
    field :family_situation, :string
    field :loan_amount, :float
    field :number_of_reference, :string
    field :reference_no, :string
    field :signature, :string
    field :total_score, :float
    field :type_of_collateral, :string
    field :type_of_loan, :string
    field :weighted_credit_score, :float
    field :loan_id, :integer

    timestamps()
  end

  @doc false
  def changeset(loan_credit_score, attrs) do
    loan_credit_score
    |> cast(attrs, [:customer_id, :reference_no, :applicant_name, :type_of_loan, :loan_amount, :cro_staff, :date_of_credit_score, :weighted_credit_score, :business_employment_experience, :family_situation, :borrowing_history, :dti_ratio, :collateral_assessment, :type_of_collateral, :applicant_character, :number_of_reference, :total_score, :credit_analyst, :signature, :loan_id])
    # |> validate_required([:customer_id, :reference_no, :applicant_name, :type_of_loan, :loan_amount, :cro_staff, :date_of_credit_score, :weighted_credit_score, :business_employment_experience, :family_situation, :borrowing_history, :dti_ratio, :collateral_assessment, :type_of_collateral, :applicant_character, :number_of_reference, :total_score, :credit_analyst, :signature])
  end
end
