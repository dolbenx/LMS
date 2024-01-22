defmodule Loanmanagementsystem.Loan.Loan_recommendation_and_assessment do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_loan_recommendation" do
    field :comments, :string
    field :customer_id, :integer
    field :date, :string
    field :date_received, :string
    field :file_sent_to_sale, :string, default: "NO"
    field :name, :string
    field :on_hold, :string, default: "NO"
    field :position, :string
    field :recommended, :string, default: "NO"
    field :reference_no, :string
    field :signature, :string
    field :time_out, :string
    field :time_received, :string
    field :user_type, :string


    timestamps()
  end

  @doc false
  def changeset(loan_recommendation_and_assessment, attrs) do
    loan_recommendation_and_assessment
    |> cast(attrs, [:customer_id, :reference_no, :recommended, :on_hold, :file_sent_to_sale, :comments, :name, :signature, :position, :date, :time_received, :time_out, :date_received, :user_type])
    # |> validate_required([:customer_id, :reference_no, :recommended, :on_hold, :file_sent_to_sale, :comments, :name, :signature, :position, :date, :time_received, :time_out, :date_received])
  end
end
