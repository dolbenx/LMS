defmodule Loanmanagementsystem.Chart_of_accounts.Gl_balance do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_gl_balance" do
    field :account_gl_name, :string
    field :account_gl_number, :string
    field :cr_balance, :decimal
    field :currency, :string
    field :dr_balance, :decimal
    field :fin_period, :string
    field :fin_year, :string
    field :gl_category, :string
    field :gl_date, :date
    field :gl_type, :string
    field :node, :string

    timestamps()
  end

  @doc false
  def changeset(gl_balance, attrs) do
    gl_balance
    |> cast(attrs, [:account_gl_number, :account_gl_name, :gl_type, :gl_date, :node, :gl_category, :currency, :fin_year, :fin_period, :dr_balance, :cr_balance])
    |> validate_required([:account_gl_number, :account_gl_name, :gl_type, :gl_date, :node, :gl_category, :currency, :fin_year, :fin_period, :dr_balance, :cr_balance])
  end
end
