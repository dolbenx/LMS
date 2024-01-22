defmodule LoanSavingsSystem.Ussd.UssdRequest do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ussd_requests" do
    field :is_logged_in, :integer
    field :mobile_number, :string
    field :request_data, :string
    field :session_ended, :integer
    field :session_id, :string

    timestamps()
  end

  @doc false
  def changeset(ussd_request, attrs) do
    ussd_request
    |> cast(attrs, [:mobile_number, :request_data, :session_ended, :session_id, :is_logged_in])
    |> validate_required([:mobile_number, :request_data, :session_ended, :session_id, :is_logged_in])
  end
  
  @doc false
  def changesetForUpdate(ussd_request, attrs) do
    ussd_request
    |> cast(attrs, [:mobile_number, :request_data, :session_ended, :session_id, :is_logged_in])
  end
end
