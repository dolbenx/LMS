defmodule Loanmanagementsystem.Email_configs.Email_config_receiver do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_email_receiver" do
    field :email, :string
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(email_config_receiver, attrs) do
    email_config_receiver
    |> cast(attrs, [:email, :status, :name])
    |> validate_required([:email, :status, :name])
  end
end
