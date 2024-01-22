defmodule Loanmanagementsystem.Chart_of_accounts.Accounts_mgt do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_accounts_mgt" do
    field :account_name, :string
    field :account_no, :string
    field :status, :string
    field :type, :string

    timestamps()
  end

  @doc false
  def changeset(accounts_mgt, attrs) do
    accounts_mgt
    |> cast(attrs, [:account_no, :account_name, :type, :status])
    |> validate_required([:account_no, :account_name, :type, :status])
  end
end
