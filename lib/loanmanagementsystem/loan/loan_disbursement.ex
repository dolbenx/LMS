defmodule Loanmanagementsystem.Loan.Loan_disbursement do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  schema "tbl_loan_disbursement" do
    field :comp_bank_account_no, :string
    field :amount, :float
    field :comp_account_name, :string
    field :comp_bank_name, :string
    field :comp_cvv, :string
    field :comp_expiry_month, :string
    field :comp_expiry_year, :string
    field :comp_mno_type, :string
    field :comp_mobile_no, :string
    field :comp_swift_code, :string
    field :currency, :string
    field :customer_id, :integer
    field :disbursement_dt, :string
    field :loan_id, :integer
    field :loan_product, :string
    field :maker_id, :integer
    field :mode_of_disbursement, :string
    field :product_id, :integer
    field :customer_account_name, :string
    field :customer_bank_account_no, :string
    field :customer_bank_name, :string
    field :customer_cvv, :string
    field :customer_expiry_month, :string
    field :customer_expiry_year, :string
    field :customer_mno_mobile_no, :string
    field :customer_mno_type, :string
    field :customer_swift_code, :string
    field :status, :string
    field :narration, :string

    timestamps()
  end

  @doc false
  def changeset(loan_disbursement, attrs) do
    loan_disbursement
    |> cast(attrs, [
      :loan_product,
      :narration,
      :currency,
      :amount,
      :disbursement_dt,
      :mode_of_disbursement,
      :comp_mno_type,
      :comp_mobile_no,
      :comp_bank_name,
      :comp_bank_account_no,
      :comp_swift_code,
      :comp_account_name,
      :comp_expiry_month,
      :comp_expiry_year,
      :comp_cvv,
      :customer_mno_type,
      :customer_mno_mobile_no,
      :customer_bank_name,
      :customer_bank_account_no,
      :customer_swift_code,
      :customer_account_name,
      :customer_expiry_month,
      :customer_expiry_year,
      :customer_cvv,
      :maker_id,
      :customer_id,
      :loan_id,
      :product_id,
      :status
    ])

    # |> validate_required([:loan_product, :currency, :amount, :disbursement_dt, :mode_of_disbursement, :comp_mno_type, :comp_mobile_no, :comp_bank_name, :comp_bank_account_no, :comp_swift_code, :comp_account_name, :comp_expiry_month, :comp_expiry_year, :comp_cvv, :customer_mno_type, :customer_mno_mobile_no, :customer_bank_name, :customer_bank_account_no, :customer_swift_code, :customer_account_name, :customer_expiry_month, :customer_expiry_year, :customer_cvv, :maker_id, :customer_id, :loan_id, :product_id, :status])
  end
end
