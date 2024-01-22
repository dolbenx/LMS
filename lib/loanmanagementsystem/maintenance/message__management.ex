defmodule Loanmanagementsystem.Maintenance.Message_Management do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
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
