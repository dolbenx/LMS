defmodule Loanmanagementsystem.Accounts.UserBioData do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_user_bio_data" do
    field :accept_conditions, :boolean, default: false
    field :age, :integer
    field :date_of_birth, :date
    field :email_address, :string
    field :first_name, :string
    field :gender, :string
    field :id_number, :string
    field :id_type, :string
    field :last_name, :string
    field :marital_status, :string
    field :mobile_number, :string
    field :nationality, :string
    field :number_of_dependants, :integer
    field :other_name, :string
    field :title, :string
    field :user_id, :integer

    timestamps()
  end

  @doc false
  def changeset(user_bio_data, attrs) do
    user_bio_data
    |> cast(attrs, [:first_name, :last_name, :gender, :date_of_birth, :email_address, :id_number, :id_type, :mobile_number, :other_name, :title, :user_id, :marital_status, :nationality, :number_of_dependants, :age, :accept_conditions])
    |> validate_required([:first_name, :last_name, :gender, :date_of_birth, :email_address, :id_number, :id_type, :mobile_number, :other_name, :title, :user_id, :marital_status, :nationality, :number_of_dependants, :age, :accept_conditions])
  end
end
