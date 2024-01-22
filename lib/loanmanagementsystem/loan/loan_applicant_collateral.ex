defmodule Loanmanagementsystem.Loan.Loan_applicant_collateral do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_loan_collateral" do
    field :asset_value, :float
    field :color, :string
    field :customer_id, :integer
    field :id_number, :string
    field :name_of_collateral, :string
    field :applicant_signature, :string
    field :name_of_witness, :string
    field :witness_signature, :string
    field :cro_staff_name, :string
    field :cro_staff_signature, :string
    field :reference_no, :string
    field :serialNo, :string

    timestamps()
  end

  @doc false
  def changeset(loan_applicant_collateral, attrs) do
    loan_applicant_collateral
    |> cast(attrs, [:customer_id, :serialNo, :name_of_collateral, :id_number, :color, :asset_value, :applicant_signature, :name_of_witness, :witness_signature, :cro_staff_name, :cro_staff_signature, :reference_no])
    # |> validate_required([:customer_id, :name_of_collateral, :id_number, :color, :asset_value, :applicant_signature, :name_of_witness, :witness_signature, :cro_staff_name, :cro_staff_signature])
  end
end
