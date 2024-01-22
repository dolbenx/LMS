defmodule LoanSavingsSystem.FlexcubeLogs.FlexcubeLog do
  use Ecto.Schema
  import Ecto.Changeset

  schema "flexcubelogs" do
    field :action_type, :string
    field :endpoint, :string
    field :request, :string
    field :response_data, :string
    field :status, :string
    field :value_date, :string
    field :dr_gl_account_code, :string
    field :cr_gl_account_code, :string
    field :amount_posted, :float

    timestamps()
  end

  @doc false
  def changeset(flexcube_log, attrs) do
    flexcube_log
    |> cast(attrs, [:value_date, :dr_gl_account_code, :cr_gl_account_code, :amount_posted, :action_type, :endpoint, :request, :response_data, :status])
    |> validate_required([:action_type, :endpoint, :request, :response_data, :status])
  end
end
