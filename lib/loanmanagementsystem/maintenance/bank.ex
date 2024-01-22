defmodule Loanmanagementsystem.Maintenance.Bank do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_banks" do
    field :acronym, :string
    field :bank_code, :string
    field :bank_descrip, :string
    field :center_code, :string
    field :process_branch, :string
    field :swift_code, :string
    field :bankName, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(bank, attrs) do
    bank
    |> cast(attrs, [
      :status,
      :bankName,
      :acronym,
      :bank_descrip,
      :center_code,
      :bank_code,
      :process_branch,
      :swift_code
    ])
    |> validate_required([
      :status,
      :bankName,
      :acronym,
      :bank_descrip,
      :center_code,
      :bank_code,
      :process_branch,
      :swift_code
    ])
  end
end
