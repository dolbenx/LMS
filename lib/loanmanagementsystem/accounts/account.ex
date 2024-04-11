defmodule Loanmanagementsystem.Accounts.Account do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_account" do
    field :account_number, :string
    field :account_type, :string
    field :available_balance, :float
    field :current_balance, :float
    field :external_id, :integer
    field :limit, :float
    field :mobile_number, :string
    field :status, :string
    field :total_credited, :float
    field :total_debited, :float
    field :user_id, :integer
    field :user_role_id, :integer

    timestamps()
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:account_number, :external_id, :status, :user_id, :mobile_number, :user_role_id, :account_type, :available_balance, :current_balance, :total_debited, :total_credited, :limit])
    |> validate_required([:account_number, :external_id, :status, :user_id, :mobile_number, :user_role_id, :account_type, :available_balance, :current_balance, :total_debited, :total_credited, :limit])
  end
end
