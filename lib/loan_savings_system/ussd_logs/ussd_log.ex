defmodule LoanSavingsSystem.UssdLogs.UssdLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_ussd_logs" do
    field :action, :string
    field :parentRoute, :string
    field :status, :string
    field :userId, :integer
    field :details, :string
	field :mobileNo, :string

    timestamps()
  end

  @doc false
  def changeset(ussd_log, attrs) do
    ussd_log
    |> cast(attrs, [:mobileNo, :userId, :action, :status, :parentRoute, :details])
    |> validate_required([:userId, :action, :status, :parentRoute])
  end
end
