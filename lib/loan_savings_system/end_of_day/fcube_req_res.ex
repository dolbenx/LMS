defmodule LoanSavingsSystem.EndOfDay.FcubeReqRes do
  use Ecto.Schema
  import Ecto.Changeset

  schema "fcube_request_responses" do
    field :request_data, :string
    field :response_data, :string

    timestamps()
  end

  @doc false
  def changeset(fcube_req_res, attrs) do
    fcube_req_res
    |> cast(attrs, [:request_data, :response_data])
    |> validate_required([:request_data, :response_data])
  end
end
