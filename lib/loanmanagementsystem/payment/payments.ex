defmodule Loanmanagementsystem.Payment.Payments do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_payment_type" do
    field :payment_type_description, :string
    field :system_id, :string

    timestamps()
  end

  @doc false
  def changeset(payments, attrs) do
    payments
    |> cast(attrs, [:payment_type_description, :system_id])
    |> validate_required([:payment_type_description, :system_id])
  end
end
