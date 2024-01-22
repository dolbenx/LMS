defmodule Loanmanagementsystem.Logs.UserLogs do
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_user_logs" do
    field :activity, :string
    belongs_to :user, Loanmanagementsystem.Accounts.User, foreign_key: :user_id, type: :id

    timestamps()
  end

  @doc false
  def changeset(user_logs, attrs) do
    user_logs
    |> cast(attrs, [:activity, :user_id])
    |> validate_required([:activity, :user_id])
  end
end
