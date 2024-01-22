defmodule Loanmanagementsystem.Loan.Loan_customer_details do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_loan_customer_details" do
    field :cell_number, :string
    field :customer_id, :integer
    field :dob, :string
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
    field :crb_consent, :string

    field :designation, :string
    field :company_name, :string
    field :company_phone_no, :string
    field :company_email, :string
    field :company_tpin, :string
    field :sector, :string
    field :geographical_location, :string
    field :type_of_facility, :string
    field :employee_number, :string


    timestamps()
  end

  @doc false
  def changeset(loan_customer_details, attrs) do
    loan_customer_details
    |> cast(attrs, [:customer_id, :crb_consent, :sector, :employee_number, :geographical_location, :type_of_facility, :designation, :company_name, :company_phone_no, :company_email, :company_tpin, :firstname, :surname, :othername, :id_type, :id_number, :gender, :cell_number, :email, :dob, :residential_address, :landmark, :town, :province, :marital_status, :reference_no])
    # |> validate_required([:customer_id, :firstname, :surname, :othername, :id_type, :id_number, :gender, :cell_number, :email, :dob, :residential_address, :landmark, :town, :province, :marital_status])
  end
end
