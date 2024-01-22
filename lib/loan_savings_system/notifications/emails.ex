defmodule LoanSavingsSystem.Notifications.Emails do
  use Endon
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_emails" do
    field :first_name, :string
    field :last_name, :string
    field :email, :string
    field :msg, :string
    field :msg_count, :string, default: "0"
    field :status, :string
    field :type, :string
    field :date_sent, :naive_datetime
    field :title, :string


    timestamps()
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [:title, :last_name, :first_name, :type, :email, :msg_count, :status, :msg])
    |> validate_required([:last_name, :first_name, :email, :msg_count, :status, :msg])
  end
end
