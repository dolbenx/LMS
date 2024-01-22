defmodule Loanmanagementsystem.RelationshipManagement.Leads do
  use Ecto.Schema
  import Ecto.Changeset

  schema "tbl_leads" do
    field :bankId, :integer
    field :date_of_birth, :date
    field :disability_detail, :string
    field :disability_status, :string
    field :email_address, :string
    field :first_name, :string
    field :gender, :string
    field :identification_number, :string
    field :identification_type, :string
    field :last_name, :string
    field :marital_status, :string
    field :mobile_number, :string
    field :nationality, :string
    field :number_of_dependants, :integer
    field :other_name, :string
    field :title, :string
    field :userId, :integer
    field :status, :string

    timestamps()
  end

  @doc false
  def changeset(leads, attrs) do
    leads
    |> cast(attrs, [:first_name, :last_name, :other_name, :title, :date_of_birth, :identification_type, :identification_number, :gender, :mobile_number, :email_address, :marital_status, :nationality, :disability_detail, :disability_status, :number_of_dependants, :userId, :bankId, :status])
    |> validate_required([:first_name, :last_name, :other_name, :title, :date_of_birth, :identification_type, :identification_number, :gender, :mobile_number, :email_address, :marital_status, :nationality, :disability_detail, :disability_status, :number_of_dependants, :userId, :status])
  end
end
