defmodule Loanmanagementsystem.Accounts.NextOfKin do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_next_of_kin" do
    field :kin_first_name, :string
    field :kin_gender, :string
    field :kin_id_number, :string
    field :kin_last_name, :string
    field :kin_mobile_number, :string
    field :kin_other_name, :string
    field :kin_personal_email, :string
    field :kin_relationship, :string
    field :kin_status, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(next_of_kin, attrs) do
    next_of_kin
    |> cast(attrs, [:user_id, :kin_id_number, :kin_first_name, :kin_gender, :kin_last_name, :kin_mobile_number, :kin_other_name, :kin_personal_email, :kin_relationship, :kin_status])
    |> validate_required([:user_id, :kin_id_number, :kin_first_name, :kin_gender, :kin_last_name, :kin_mobile_number, :kin_other_name, :kin_personal_email, :kin_relationship, :kin_status])
  end
end
