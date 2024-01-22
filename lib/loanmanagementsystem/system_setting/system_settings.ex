defmodule Loanmanagementsystem.SystemSetting.SystemSettings do
  use Endon
  use Ecto.Schema
  import Ecto.Changeset

  @timestamps_opts [autogenerate: {Loanmanagementsystem.Accounts.Account.Localtime, :autogenerate, []}]
  schema "tbl_system_settings" do
    field :username, :string
    field :password, :string
    field :host, :string
    field :sender, :string
    field :max_attempts, :string

    timestamps()
  end

  @doc false
  def changeset(system_settings, attrs) do
    system_settings
    |> cast(attrs, [:username, :password, :host, :sender, :max_attempts])
    |> validate_required([:username, :password, :host, :sender])
  end
end
