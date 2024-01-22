defmodule Loanmanagementsystem.Email_configs.Email_config_sender do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_email_sender" do
    field :email, :string
    field :password, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(email_config_sender, attrs) do
    email_config_sender
    |> cast(attrs, [:email, :status, :password])
    |> validate_required([:email, :status, :password])
  end
end
