defmodule Loanmanagementsystem.Accounts.Nextofkin do
  use Ecto.Schema
  import Ecto.Changeset
  use Endon

  schema "tbl_next_of_kin" do
    field :applicant_nrc, :string
    field :kin_ID_number, :string
    field :kin_first_name, :string
    field :kin_gender, :string
    field :kin_last_name, :string
    field :kin_mobile_number, :string
    field :kin_other_name, :string
    field :kin_personal_email, :string
    field :kin_relationship, :string
    field :kin_status, :string
    field :userID, :integer
    field :reference_no, :string


    timestamps()
  end

  @doc false
  def changeset(nextofkin, attrs) do
    nextofkin
    |> cast(attrs, [:kin_first_name, :kin_last_name, :kin_other_name, :kin_status, :kin_relationship, :kin_ID_number, :userID, :kin_mobile_number, :kin_personal_email, :kin_gender, :applicant_nrc, :reference_no])
    # |> validate_required([:kin_first_name, :kin_last_name, :kin_other_name, :kin_status, :kin_relationship, :kin_ID_number, :userID, :kin_mobile_number, :kin_personal_email, :kin_gender, :applicant_nrc])
  end
end
