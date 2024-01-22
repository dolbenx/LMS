defmodule Loanmanagementsystem.Ussd.UssdRequests do
  use Ecto.Schema
  import Ecto.Changeset
  @timestamps_opts [autogenerate: {Loanmanagementsystem.Loan.Loans.Localtime, :autogenerate, []}]
  @number_regex ~r(^[0-9]*$)

  schema "tbl_ussd_requests" do
    field :is_logged_in, :integer
    field :mobile_number, :string
    field :request_data, :string
    field :session_ended, :integer
    field :session_id, :string

    timestamps()
  end

  @doc false
  def changeset(ussd_requests, attrs) do
    ussd_requests
    |> cast(attrs, [:mobile_number, :request_data, :session_ended, :session_id, :is_logged_in])
    |> validate_required([
      :mobile_number,
      :request_data,
      :session_ended,
      :session_id,
      :is_logged_in
    ])
  end

  @doc false
  def changesetForUpdate(ussd_request, attrs) do
    ussd_request
    |> cast(attrs, [:mobile_number, :request_data, :session_ended, :session_id, :is_logged_in])
  end
end
