defmodule Loanmanagementsystem.Settings.SmsConfigs do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_sms_configuration" do
    field :host, :string
    field :max_attempts, :string
    field :password, :string
    field :sender, :string
    field :username, :string

    timestamps()
  end

  @doc false
  def changeset(sms_configs, attrs) do
    sms_configs
    |> cast(attrs, [:username, :password, :host, :sender, :max_attempts])
    |> validate_required([:username, :password, :host, :sender, :max_attempts])
  end
end
