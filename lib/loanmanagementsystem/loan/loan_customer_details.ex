defmodule Loanmanagementsystem.Loan.Loan_customer_details do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_loan_customer_details" do
    field :cell_number, :string
    field :customer_id, :integer
    field :dob, :date
    field :email, :string
    field :firstname, :string
    field :gender, :string
    field :id_number, :string
    field :id_type, :string
    field :landmark, :string
    field :marital_status, :string
    field :othername, :string
    field :province, :string
    field :residential_address, :string
    field :surname, :string
    field :town, :string
    field :reference_no, :string
    field :loan_id, :integer

    timestamps()
  end

  @doc false
  def changeset(loan_customer_details, attrs) do
    loan_customer_details
    |> cast(attrs, [:customer_id, :firstname, :surname, :othername, :id_type, :id_number, :gender, :cell_number, :email, :dob, :residential_address, :landmark, :town, :province, :marital_status, :reference_no, :loan_id])
    # |> validate_required([:customer_id, :firstname, :surname, :othername, :id_type, :id_number, :gender, :cell_number, :email, :dob, :residential_address, :landmark, :town, :province, :marital_status])
  end
end
