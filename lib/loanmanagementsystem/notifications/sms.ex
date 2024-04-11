defmodule Loanmanagementsystem.Notifications.Sms do
  use Endon
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_sms" do
    field :mobile, :string
    field :msg, :string
    field :msg_count, :string, default: "0"
    field :status, :string
    field :type, :string
    field :date_sent, :naive_datetime
    field :transactionRef, :string

    timestamps()
  end

  @doc false
  def changeset(sms, attrs) do
    sms
    |> cast(attrs, [:type, :mobile, :msg_count, :status, :msg, :transactionRef])

    # |> validate_required([:type, :mobile, :msg_count, :status, :msg])
  end
end
