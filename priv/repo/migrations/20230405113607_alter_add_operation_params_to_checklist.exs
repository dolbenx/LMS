defmodule Loanmanagementsystem.Repo.Migrations.AlterAddOperationParamsToChecklist do
  use Ecto.Migration

  def change do
    alter table(:tbl_loan_checklist) do
      add :completed_approved_application, :string
      add :valid_id, :string
      add :trading_license_or_other, :string
      add :three_months_sale, :string
      add :moveable_or_immovable_collateral, :string
      add :motor_vehicle_insurance, :string
      add :crb_report, :string
      add :proof_of_residence, :string
      add :reference_letter, :string
      add :three_months_pay_slip, :string
      add :incorporation_doc, :string
      add :tax_clearance, :string
      add :rep_valid_id, :string
      add :tenancy_agreement, :string
      add :board_resolution, :string
      add :six_month_statement, :string
    end
  end
end
