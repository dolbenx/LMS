defmodule Loanmanagementsystem.Settings.Receivers do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_notification_receivers" do
    field :company, :string
    field :email, :string
    field :name, :string
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(receivers, attrs) do
    receivers
    |> cast(attrs, [:name, :email, :status, :company])
    |> validate_required([:name, :email, :status, :company])
  end
end
