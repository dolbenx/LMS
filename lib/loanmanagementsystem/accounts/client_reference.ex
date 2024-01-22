defmodule Loanmanagementsystem.Accounts.Client_reference do
  use Ecto.Schema
  use Endon
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_client_reference" do
    field :contact_no, :string
    field :customer_id, :integer
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(client_reference, attrs) do
    client_reference
    |> cast(attrs, [:customer_id, :name, :contact_no, :status])
    # |> validate_required([:customer_id, :name, :contact_no, :status])
  end
end
