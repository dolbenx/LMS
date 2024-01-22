defmodule Loanmanagementsystem.Maintenance.Message_Management do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_msg_mgt" do
    field :msg, :string
    field :msg_type, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(message__management, attrs) do
    message__management
    |> cast(attrs, [:msg_type, :msg, :status])
    |> validate_required([:msg_type, :msg, :status])
  end
end
