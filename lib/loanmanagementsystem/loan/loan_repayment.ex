defmodule Loanmanagementsystem.Loan.LoanRepayment do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_loan_repayment" do
    field :amountRepaid, :float
    field :chequeNo, :string
    field :dateOfRepayment, :string
    field :modeOfRepayment, :string
    field :receiptNo, :string
    field :recipientUserRoleId, :integer
    field :registeredByUserId, :integer
    field :repayment, :string
    field :company_id, :integer

    field :loan_product, :string
    field :repayment_type, :string
    field :repayment_method, :string
    field :bank_name, :string
    field :branch_name, :string
    field :swift_code, :string
    field :expiry_date, :string
    field :cvc, :string
    field :bank_account_no, :string
    field :account_name, :string
    field :bevura_wallet_no, :string
    field :receipient_number, :string
    field :mno_mobile_no, :string
    field :reference_no, :string
    field :status, :string
    field :loan_id, :integer

    timestamps()
  end

  @doc false
  def changeset(loan_repayment, attrs) do
    loan_repayment
    |> cast(attrs, [
      :repayment,
      :mno_mobile_no,
      :repayment_type,
      :loan_id,
      :repayment_method,
      :bank_name,
      :loan_product,
      :branch_name,
      :swift_code,
      :expiry_date,
      :cvc,
      :bank_account_no,
      :account_name,
      :bevura_wallet_no,
      :receipient_number,
      :reference_no,
      :status,
      :dateOfRepayment,
      :modeOfRepayment,
      :amountRepaid,
      :chequeNo,
      :receiptNo,
      :registeredByUserId,
      :recipientUserRoleId,
      :company_id
    ])

    # |> validate_required([:repayment, :dateOfRepayment, :modeOfRepayment, :amountRepaid, :chequeNo, :receiptNo, :registeredByUserId, :recipientUserRoleId, :company_id])
  end
end
