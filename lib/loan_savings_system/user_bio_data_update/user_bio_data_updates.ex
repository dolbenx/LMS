defmodule LoanSavingsSystem.UserBioDataUpdate.UserBioDataUpdates do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_user_bio_data_update" do
    field :approvedByUserId, :integer
    field :status, :string
    field :userBioData, :string

    timestamps()
  end

  @doc false
  def changeset(user_bio_data_updates, attrs) do
    user_bio_data_updates
    |> cast(attrs, [:userBioData, :status, :approvedByUserId])
    |> validate_required([:userBioData, :status])
  end
end
