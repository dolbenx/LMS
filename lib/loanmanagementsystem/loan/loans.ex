defmodule Loanmanagementsystem.Loan.Loans do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)


  schema "tbl_loans" do
    field(:principal_repaid_derived, :float)
    field(:number_of_repayments, :integer)
    field(:withdrawnon_date, :date)
    field(:currency_code, :string)
    field(:is_npa, :boolean, default: false)
    field(:repay_every_type, :string)
    field(:principal_writtenoff_derived, :float)
    field(:disbursedon_userid, :integer)
    field(:approvedon_userid, :integer)
    field(:total_writtenoff_derived, :float)
    field(:repay_every, :integer)
    field(:closedon_userid, :integer)
    field(:product_id, :integer)
    field(:customer_id, :integer)
    field(:interest_method, :string)
    field(:annual_nominal_interest_rate, :float)
    field(:writtenoffon_date, :date)
    field(:total_outstanding_derived, :float)
    field(:interest_calculated_from_date, :date)
    field(:loan_counter, :integer)
    field(:interest_charged_derived, :float)
    field(:term_frequency_type, :string)
    field(:total_charges_due_at_disbursement_derived, :float)
    field(:penalty_charges_waived_derived, :float)
    field(:total_overpaid_derived, :float)
    field(:approved_principal, :float)
    field(:principal_disbursed_derived, :float)
    field(:rejectedon_userid, :integer)
    field(:approvedon_date, :date)
    field(:loan_type, :string)
    field(:principal_amount, :float)
    field(:disbursedon_date, :date)
    field(:account_no, :string)
    field(:interest_outstanding_derived, :float)
    field(:interest_writtenoff_derived, :float)
    field(:penalty_charges_writtenoff_derived, :float)
    field(:loan_status, :string)
    field(:fee_charges_charged_derived, :float)
    field(:fee_charges_waived_derived, :float)
    field(:interest_waived_derived, :float)
    field(:total_costofloan_derived, :float)
    field(:principal_amount_proposed, :float)
    field(:fee_charges_repaid_derived, :float)
    field(:total_expected_repayment_derived, :float)
    field(:principal_outstanding_derived, :float)
    field(:penalty_charges_charged_derived, :float)
    field(:is_legacyloan, :boolean, default: false)
    field(:total_waived_derived, :float)
    field(:interest_repaid_derived, :float)
    field(:rejectedon_date, :date)
    field(:fee_charges_outstanding_derived, :float)
    field(:expected_disbursedon_date, :date)
    field(:closedon_date, :date)
    field(:fee_charges_writtenoff_derived, :float)
    field(:penalty_charges_outstanding_derived, :float)
    field(:total_expected_costofloan_derived, :float)
    field(:penalty_charges_repaid_derived, :float)
    field(:withdrawnon_userid, :integer)
    field(:expected_maturity_date, :date)
    field(:external_id, :string)
    field(:term_frequency, :integer)
    field(:total_repayment_derived, :float)
    field(:loan_identity_number, :string)
    field(:branch_id, :integer)
    field(:status, :string)
    field(:app_user_id, :integer)
    field(:mobile_money_response, :string)
    field(:total_principal_repaid, :float)
    field(:total_interest_repaid, :float)
    field(:total_charges_repaid, :float)
    field(:total_penalties_repaid, :float)
    field(:total_repaid, :float, default: 0.0)
    field(:momoProvider, :string)
    field(:company_id, :integer)
    field(:sms_status, :string, default: "not_sent")
    field(:loan_userroleid, :integer)

    field(:disbursement_method, :string)
    field(:bank_name, :string)
    field(:bank_account_no, :string)
    field(:account_name, :string)
    field(:bevura_wallet_no, :string)
    field(:receipient_number, :string)
    field(:reference_no, :string)
    field(:repayment_type, :string)
    field(:repayment_amount, :float)
    field(:balance, :float, default: 0.0)
    field(:interest_amount, :float)
    field(:tenor, :integer)
    # field :branch_name, :string
    field(:expiry_month, :string)
    field(:expiry_year, :string)
    field(:cvv, :string)
    field(:repayment_frequency, :string)
    field(:reason, :string)

    field :requested_amount, :float
    field :loan_duration_month, :string
    field :monthly_installment, :string
    field :proposed_repayment_date, :date
    field :loan_purpose, :string
    field :application_date, :date
    field :offtakerID, :integer
    field :has_mou, :string
    field :funderID, :integer
    field :loan_limit, :float
    field :arrangement_fee, :float
    field :finance_cost, :float
    field :disbursement_status, :string
    field :loan_officer_id, :integer
    field :days_under_due, :integer, default: 0
    field :days_over_due, :integer, default: 0
    field(:daily_accrued_interest, :float, default: 0.0)
    field(:daily_accrued_finance_cost, :float, default: 0.0)
    field(:calculated_balance, :float, default: 0.0)
    field :eod_count, :integer, default: 0
    field :eod_status, :boolean, default: false
    field :accrued_no_days, :integer, default: 0
    field(:init_interest_per, :float, default: 0.0)
    field(:init_arrangement_fee_per, :float, default: 0.0)
    field(:init_finance_cost_per, :float, default: 0.0)


    timestamps()
  end

  @doc false
  def changeset(loans, attrs) do
    loans
    |> cast(attrs, [
      :loan_limit,
      :sms_status,
      :arrangement_fee,
      :finance_cost,
      :offtakerID,
      :reason,
      :repayment_type,
      :expiry_month,
      :expiry_year,
      :repayment_amount,
      :tenor,
      :disbursement_status,
      :balance,
      :interest_amount,
      :company_id,
      :total_penalties_repaid,
      :momoProvider,
      :total_repaid,
      :total_principal_repaid,
      :total_interest_repaid,
      :total_charges_repaid,
      :mobile_money_response,
      :branch_id,
      :app_user_id,
      :loan_identity_number,
      :account_no,
      :external_id,
      :customer_id,
      :product_id,
      :loan_status,
      :loan_type,
      :currency_code,
      :principal_amount_proposed,
      :principal_amount,
      :approved_principal,
      :annual_nominal_interest_rate,
      :interest_method,
      :term_frequency,
      :term_frequency_type,
      :repay_every,
      :repay_every_type,
      :number_of_repayments,
      :approvedon_date,
      :approvedon_userid,
      :expected_disbursedon_date,
      :disbursedon_date,
      :disbursedon_userid,
      :expected_maturity_date,
      :interest_calculated_from_date,
      :closedon_date,
      :closedon_userid,
      :total_charges_due_at_disbursement_derived,
      :principal_disbursed_derived,
      :principal_repaid_derived,
      :principal_writtenoff_derived,
      :principal_outstanding_derived,
      :interest_charged_derived,
      :interest_repaid_derived,
      :interest_waived_derived,
      :interest_writtenoff_derived,
      :interest_outstanding_derived,
      :fee_charges_charged_derived,
      :fee_charges_repaid_derived,
      :fee_charges_waived_derived,
      :fee_charges_writtenoff_derived,
      :fee_charges_outstanding_derived,
      :penalty_charges_charged_derived,
      :penalty_charges_repaid_derived,
      :penalty_charges_waived_derived,
      :penalty_charges_writtenoff_derived,
      :penalty_charges_outstanding_derived,
      :total_expected_repayment_derived,
      :total_repayment_derived,
      :total_expected_costofloan_derived,
      :total_costofloan_derived,
      :total_waived_derived,
      :total_writtenoff_derived,
      :total_outstanding_derived,
      :total_overpaid_derived,
      :rejectedon_date,
      :rejectedon_userid,
      :withdrawnon_date,
      :withdrawnon_userid,
      :writtenoffon_date,
      :loan_counter,
      :is_npa,
      :is_legacyloan,
      :status,
      :loan_userroleid,
      :disbursement_method,
      :bank_name,
      :bank_account_no,
      :account_name,
      :bevura_wallet_no,
      :receipient_number,
      :reference_no,
      :application_date,
      :requested_amount,
      :loan_duration_month,
      :monthly_installment,
      :proposed_repayment_date,
      :loan_purpose,
      :has_mou,
      :funderID,
      :loan_officer_id,
      :days_under_due,
      :days_over_due,
      :daily_accrued_interest,
      :daily_accrued_finance_cost,
      :eod_count,
      :eod_status,
      :accrued_no_days,
      :calculated_balance,
      :init_interest_per,
      :init_arrangement_fee_per,
      :init_finance_cost_per,

    ])
    # |> validate_required([

    #   :customer_id,
    #   :product_id,
    #   :loan_status,
    #   :loan_type,
    #   :currency_code,
    #   :interest_amount,
    #   :principal_amount,
    #   :tenor,
    #   :balance
    # ])
    |> multi_validate_format([:account_no])
    |> validate_less_or_equal_to_zero()
  end

  @doc false
  def changesetForUpdate(loans, attrs) do
    loans
    |> cast(attrs, [
      :sms_status,
      :offtakerID,
      :reason,
      :repayment_type,
      :expiry_month,
      :expiry_year,
      :repayment_amount,
      :tenor,
      :balance,
      :interest_amount,
      :total_penalties_repaid,
      :total_repaid,
      :total_principal_repaid,
      :total_interest_repaid,
      :total_charges_repaid,
      :mobile_money_response,
      :branch_id,
      :app_user_id,
      :loan_identity_number,
      :customer_id,
      :product_id,
      :loan_status,
      :loan_type,
      :currency_code,
      :principal_amount_proposed,
      :principal_amount,
      :approved_principal,
      :annual_nominal_interest_rate,
      :interest_method,
      :term_frequency,
      :term_frequency_type,
      :repay_every,
      :repay_every_type,
      :number_of_repayments,
      :approvedon_date,
      :approvedon_userid,
      :expected_disbursedon_date,
      # :disbursedon_date,
      :disbursedon_userid,
      :expected_maturity_date,
      :interest_calculated_from_date,
      :closedon_date,
      :closedon_userid,
      :total_charges_due_at_disbursement_derived,
      :principal_disbursed_derived,
      :principal_repaid_derived,
      :principal_writtenoff_derived,
      :principal_outstanding_derived,
      :interest_charged_derived,
      :interest_repaid_derived,
      :interest_waived_derived,
      :interest_writtenoff_derived,
      :interest_outstanding_derived,
      :fee_charges_charged_derived,
      :fee_charges_repaid_derived,
      :fee_charges_waived_derived,
      :fee_charges_writtenoff_derived,
      :fee_charges_outstanding_derived,
      :penalty_charges_charged_derived,
      :penalty_charges_repaid_derived,
      :penalty_charges_waived_derived,
      :penalty_charges_writtenoff_derived,
      :penalty_charges_outstanding_derived,
      :total_expected_repayment_derived,
      :total_repayment_derived,
      :total_expected_costofloan_derived,
      :total_costofloan_derived,
      :total_waived_derived,
      :total_writtenoff_derived,
      :total_outstanding_derived,
      :total_overpaid_derived,
      :rejectedon_date,
      :withdrawnon_date,
      :loan_counter,
      :is_npa,
      :is_legacyloan,
      :loan_userroleid,
      :has_mou,
      :funderID,
      :loan_officer_id,
      :daily_accrued_interest,
      :days_under_due,
      :days_over_due,
      :finance_cost,
      :daily_accrued_finance_cost,
      :eod_count,
      :eod_status,
      :accrued_no_days,
      :calculated_balance,
      :init_interest_per,
      :init_arrangement_fee_per,
      :init_finance_cost_per,

    ])
  end

  def multi_validate_format(changeset, keys) do
    Enum.reduce(keys, changeset, fn field, changeset ->
      validate_format(changeset, field, @number_regex, message: " can't be alphanumeric")
    end)
  end

  def validate_less_or_equal_to_zero(
        %Ecto.Changeset{valid?: true, changes: %{principal_amount: amt}} = changeset
      ) do
    case get_field(changeset, :loan_status) do
      "PENDING_APPROVAL" ->
        amount = Decimal.new(amt)

        case Decimal.cmp(amount, 0) do
          result when result in [:lt, :eq] ->
            add_error(changeset, :principal_amount, " can't be equal or less than zero")

          _ ->
            changeset
        end

      _ ->
        changeset
    end
  end

  def validate_less_or_equal_to_zero(changeset), do: changeset

  defmodule Localtime do
    def autogenerate,
      do:
      Timex.local()
      |> NaiveDateTime.truncate(:second)
  end


end
